//***********************************************************
//                       EwbMouseHook unit                  *
//                                                          *
//                     For Delphi 5 to XE                   *
//                     Freeware Component                   *
//                            by                            *
//                          (smot)                          *
//                                                          *
//  Documentation and updated versions:                     *
//                                                          *
//               http://www.bsalsa.com                      *
//***********************************************************
{*******************************************************************************}
{LICENSE:
THIS SOFTWARE IS PROVIDED TO YOU "AS IS" WITHOUT WARRANTY OF ANY KIND,
EITHER EXPRESSED OR IMPLIED INCLUDING BUT NOT LIMITED TO THE APPLIED
WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
YOU ASSUME THE ENTIRE RISK AS TO THE ACCURACY AND THE USE OF THE SOFTWARE
AND ALL OTHER RISK ARISING OUT OF THE USE OR PERFORMANCE OF THIS SOFTWARE
AND DOCUMENTATION. BSALSA PRODUCTIONS DOES NOT WARRANT THAT THE SOFTWARE IS ERROR-FREE
OR WILL OPERATE WITHOUT INTERRUPTION. THE SOFTWARE IS NOT DESIGNED, INTENDED
OR LICENSED FOR USE IN HAZARDOUS ENVIRONMENTS REQUIRING FAIL-SAFE CONTROLS,
INCLUDING WITHOUT LIMITATION, THE DESIGN, CONSTRUCTION, MAINTENANCE OR
OPERATION OF NUCLEAR FACILITIES, AIRCRAFT NAVIGATION OR COMMUNICATION SYSTEMS,
AIR TRAFFIC CONTROL, AND LIFE SUPPORT OR WEAPONS SYSTEMS. BSALSA PRODUCTIONS SPECIFICALLY
DISCLAIMS ANY EXPRESS OR IMPLIED WARRANTY OF FITNESS FOR SUCH PURPOSE.

You may use, change or modify the component under 4 conditions:
1. In your website, add a link to "http://www.bsalsa.com"
2. In your application, add credits to "Embedded Web Browser"
3. Mail me  (bsalsa@gmail.com) any code change in the unit
   for the benefit of the other users.
4. Please, consider donation in our web site!
{*******************************************************************************}

unit EwbMouseHook;

interface

{$I EWB.inc}

uses
  Windows, Types, Messages, Classes, Forms, Controls;

// -- TEWBMouseHook ------------------------------------------------------------

type
  TMouseWheelEvent = procedure(Point: TPoint; hwndFromPoint: HWND; lp: LPARAM;
    var Handled: Boolean) of object;

type
  TEWBMouseHook = class(TObject)
  private
    FMouseHook: HHOOK;
    function LocalMouseProc(nCode: Integer; wp: WPARAM; lp: LPARAM): LRESULT;
  public
    OnMouseWheel: TMouseWheelEvent;
    FActiveFormOnly: Boolean;
    class function NewInstance: TObject; override;
    procedure FreeInstance; override;
    constructor Create;
    destructor Destroy; override;
    procedure Activate;
    procedure Deactivate;
  end;

var
  EWBEnableMouseWheelFix: Boolean = True; // DO NOT CHANGE HERE

implementation

uses
  EWBCoreTools;

var
  GEWBMouseHook: TEWBMouseHook = nil;
  GRefCount: Integer = 0;

function LowLevelMouseHookProc(nCode: Integer; wp: WPARAM; lp: LPARAM): LRESULT stdcall;
begin
  if Assigned(GEWBMouseHook) then
    Result := GEWBMouseHook.LocalMouseProc(nCode, wp, lp)
  else
  begin
    Assert(False);
    Result := CallNextHookEx(0, nCode, wp, lp);
  end;
end;

function TEWBMouseHook.LocalMouseProc(nCode: Integer; wp: WPARAM; lp: LPARAM): LRESULT;
var
  bHandled, bCancel: Boolean;
  mhs: TMouseHookStruct;
  hwndCurrentFocus: HWND;
  P: TPoint;
  hwndFromPoint, hwndFocusShellEmbedding, hwndWFPShellEmbedding: HWND;
  WinControl: TWinControl;
  ParentForm: TCustomForm;
//  nState: SHORT;
begin
  if nCode < 0 then
    Result := CallNextHookEx(FMouseHook, nCode, wp, LPARAM(lp))
  else
  begin
    bHandled := False;
    if (wp = WM_MOUSEWHEEL) and (nCode = HC_ACTION) then
    begin
      mhs := PMouseHookStruct(lp)^;
      P := Point(mhs.pt.X, mhs.pt.Y);
      hwndFromPoint := WindowFromPoint(P);
          // Handle OnMouseWheel
      bCancel := False;
      if Assigned(OnMouseWheel) then
        OnMouseWheel(P, hwndFromPoint, lp, bCancel);
          // Handle ActiveFormOnly
      if FActiveFormOnly then
      begin
        WinControl := FindVCLWindow(P);
        if Assigned(WinControl) then
        begin
          ParentForm := GetParentForm(WinControl);
          if Assigned(ParentForm) then
            bCancel := ParentForm <> Screen.ActiveForm;
        end;
      end;

      if not bCancel then
        if hwndFromPoint <> 0 then
        begin
          hwndCurrentFocus := GetFocus;
          if hwndCurrentFocus <> 0 then
          begin
            hwndWFPShellEmbedding := GetParentWinByClass(hwndFromPoint,
              'Shell Embedding');
            if (hwndWFPShellEmbedding <> 0) then
                      // Parent of WindowFromPoint is WB
            begin
              hwndFocusShellEmbedding :=
                GetParentWinByClass(hwndCurrentFocus,
                'Shell Embedding');
              if (hwndWFPShellEmbedding <> hwndFocusShellEmbedding) or
                (GetWinClass(hwndCurrentFocus) =
                'Shell DocObject View') then
                          // Only handle if WB has not the focus or other WB has the focus
              begin
            //  nState := GetKeyState(VK_CONTROL);
            //  if (nState and $80000000) = $80000000 then
              begin
                bHandled := True;
                Windows.SetFocus(hwndFromPoint);
              end;
              end;
            end;
          end;
        end;
    end;
    if bHandled then
      Result := HC_SKIP
    else
      Result := CallNextHookEx(FMouseHook, nCode, wp, lp);
  end;
end;

class function TEWBMouseHook.NewInstance: TObject;
begin
  if not Assigned(GEWBMouseHook) then
  begin
    GEWBMouseHook := TEWBMouseHook(inherited NewInstance);
    GEWBMouseHook.FActiveFormOnly := False;
  end;
  Result := GEWBMouseHook;
  Inc(GRefCount);
end;

procedure TEWBMouseHook.FreeInstance;
begin
  Dec(GRefCount);
  if GRefCount = 0 then
  begin
    GEWBMouseHook := nil;
    inherited FreeInstance;
  end;
end;

procedure TEWBMouseHook.Activate;
begin
  if (FMouseHook = 0) and EWBEnableMouseWheelFix then
    FMouseHook := SetWindowsHookEx(WH_MOUSE, @LowLevelMouseHookProc, 0, GetCurrentThreadID);
end;

procedure TEWBMouseHook.Deactivate;
begin
  if FMouseHook <> 0 then
  begin
    if UnhookWindowsHookEx(FMouseHook) then
      FMouseHook := 0;
  end;
end;

constructor TEWBMouseHook.Create;
begin
  inherited;
  //  if (GRefCount = 1) then
end;

destructor TEWBMouseHook.Destroy;
begin
  inherited;
  //  if ((GRefCount <= 1)) then
end;

end.
