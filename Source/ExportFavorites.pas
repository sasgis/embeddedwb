//***********************************************************
//                      TExportFavorites                    *
//                                                          *
//               For Delphi 5,6, 7 , 2005, 2006             *
//                     Freeware Component                   *
//                            by                            *
//                     Eran Bodankin (bsalsa)               *
//                     bsalsa@gmail.com                    *
//                                                          *
//           Based on idea's by:  Troels Jakobsen           *
//                                                          *
//     Documentation and updated versions:                  *
//               http://www.bsalsa.com                      *
//***********************************************************

{*******************************************************************************}
{LICENSE:
THIS SOFTWARE IS PROVIDED TO YOU "AS IS" WITHOUT WARRANTY OF ANY KIND,
EITHER EXPRESSED OR IMPLIED INCLUDING BUT NOT LIMITED TO THE APPLIED
WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
YOU ASSUME THE ENTIRE RISK AS TO THE ACCURACY AND THE USE OF THE SOFTWARE
AND ALL OTHER RISK ARISING OUT OF THE USE OR PERFORMANCE OF THIS SOFTWARE
AND DOCUMENTATION. [YOUR NAME] DOES NOT WARRANT THAT THE SOFTWARE IS ERROR-FREE
OR WILL OPERATE WITHOUT INTERRUPTION. THE SOFTWARE IS NOT DESIGNED, INTENDED
OR LICENSED FOR USE IN HAZARDOUS ENVIRONMENTS REQUIRING FAIL-SAFE CONTROLS,
INCLUDING WITHOUT LIMITATION, THE DESIGN, CONSTRUCTION, MAINTENANCE OR
OPERATION OF NUCLEAR FACILITIES, AIRCRAFT NAVIGATION OR COMMUNICATION SYSTEMS,
AIR TRAFFIC CONTROL, AND LIFE SUPPORT OR WEAPONS SYSTEMS. VSOFT SPECIFICALLY
DISCLAIMS ANY EXPRESS OR IMPLIED WARRANTY OF FITNESS FOR SUCH PURPOSE.

You may use, change or modify the component under 4 conditions:
1. In your website, add a link to "http://www.bsalsa.com"
2. In your application, add credits to "Embedded Web Browser"
3. Mail me  (bsalsa@gmail.com) any code change in the unit
   for the benefit of the other users.
4. Please consider donation in our web site!
{*******************************************************************************}
//$Id: ExportFavorites.pas,v 1.3 2006/11/26 05:55:31 bsalsa Exp $

unit ExportFavorites;
{$I EWB_jedi.inc}
interface

{$IFDEF DELPHI6_UP}
{$WARN UNIT_PLATFORM OFF}
{$ENDIF}

uses
  Classes, dialogs, IniFiles, ShellApi, SHDocVw_EWB, ComCtrls, EmbeddedWB;

type
  PUrlRec = ^TUrlRec;
  TUrlRec = record
    Rep: string;
    UrlName: string;
    UrlPath: string;
    Level: Integer;
  end;

type
  TExportFavorite = class(TComponent)
  private
    BmkList: TStringList;
    fAbout: string;
    FavFolder: string;
    FavList: TList;
    fEnabled: Boolean;
    fExploreFavFileFolder: Boolean;
    FFavoritesPath: string;
    fNavigateOnComplete: Boolean;
    fShowSuccessMessage: Boolean;
    fStatusBar: TStatusBar;
    fSuccessMessage: TStrings;
    FTargetFileName: string;
    FTargetPath: string;
    fEmbeddedWB: TEmbeddedWB;
    procedure GetFavoritesFolder;
    procedure MakeBookmarkFile;
    procedure SearchURL(Folder: string; Level: Integer);
    procedure SetAbout(Value: string);
    procedure SetSuccessMessage(Value: TStrings);
    procedure TraverseFavList(Idx, PrevIdx: Integer);

  protected
    procedure MakeBookmark(UrlRec: PUrlRec);
    procedure MakeDocumentBottom;
    procedure MakeDocumentTop;
    procedure MakeHeaderBottom(UrlRec: PUrlRec);
    procedure MakeHeaderTop(UrlRec: PUrlRec);
    procedure ExportFavoritesToIni;
  public
    SuccessFlag: Boolean;
    NavigatePath: string;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ExportFavorites;

  published
    property About: string read fAbout write SetAbout;
    property Enabled: boolean read fEnabled write fEnabled default True;
    property ExploreFavFileOnComplete: Boolean read fExploreFavFileFolder write fExploreFavFileFolder default False;
    property FavoritesPath: string read FFavoritesPath write FFavoritesPath;
    property NarigateOnComplete: Boolean read fNavigateOnComplete write fNavigateOnComplete default False;
    property ShowSuccessMessage: Boolean read fShowSuccessMessage write fShowSuccessMessage default True;
    property StatusBar: TStatusBar read fStatusBar write fStatusBar;
    property SuccessMessage: TStrings read fSuccessMessage write SetSuccessMessage;
    property TargetFileName: string read FTargetFileName write FTargetFileName;
    property TargetPath: string read FTargetPath write FTargetPath;
    property EmbeddedWB: TEmbeddedWB read fEmbeddedWB write fEmbeddedWB;
  end;

implementation

uses
  Windows, SysUtils, Registry, Forms, IEConst;

constructor TExportFavorite.Create;
begin
  FFavoritesPath := 'Auto';
  FTargetPath := 'C:\';
  FTargetFileName := 'newbook.htm';
  fSuccessMessage := TStringList.Create;
  fSuccessMessage.Add('Your favorites have been exported successfully!');
  fSuccessMessage.Text := 'Your favorites have been exported to successfully!';
  fShowSuccessMessage := True;
  fAbout := 'TExportFavorites by bsalsa. ' + WEB_SITE;
  SuccessFlag := False;
  fEnabled := True;
  fExploreFavFileFolder := false;
  fNavigateOnComplete := false;
  inherited;
end;

destructor TExportFavorite.Destroy;
begin
  fSuccessMessage.Free;
  inherited Destroy;
end;

procedure TExportFavorite.SetSuccessMessage(Value: TStrings);
begin
  fSuccessMessage.Assign(Value)
end;

procedure TExportFavorite.GetFavoritesFolder;
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;
  Registry.RootKey := HKEY_CURRENT_USER;
  Registry.OpenKey('Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', False);
  FavFolder := Registry.ReadString('Favorites');
  Registry.Free;
end;

procedure TExportFavorite.SearchURL(Folder: string; Level: Integer);
var
  Found: Integer;
  SearchRec: TSearchRec;
  UrlFile: TIniFile;
  UrlRec: PUrlRec;
begin
  Found := FindFirst(Folder + '\*.*', faAnyFile, SearchRec);
  while Found = 0 do
  begin
    if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
      if (SearchRec.Attr and faDirectory > 0) then
      begin
{$WARNINGS OFF}
        if not (SearchRec.Attr and faSysFile > 0) then
        begin
          UrlRec := New(PUrlRec);
          UrlRec.Rep := Copy(Folder + '\' + SearchRec.Name, Length(FavFolder) + 2, Length(Folder + '\' + SearchRec.Name));
          UrlRec.UrlName := '';
          UrlRec.UrlPath := '';
          UrlRec.Level := Level;
          FavList.Add(UrlRec);
        end;
        SearchURL(Folder + '\' + SearchRec.Name, Level + 1); // Recursion
{$WARNINGS ON}
      end
      else
      begin
        if UpperCase(ExtractFileExt(SearchRec.Name)) = '.URL' then
        begin
          UrlRec := New(PUrlRec);
          UrlRec.Rep := Copy(Folder, Length(FavFolder) + 2, Length(Folder));
          UrlRec.UrlName := Copy(SearchRec.Name, 0, Length(SearchRec.Name) - 3);
          UrlFile := TIniFile.Create(Folder + '\' + SearchRec.Name);
          UrlRec.UrlPath := UrlFile.ReadString('InternetShortcut', 'URL', 'no path');
          UrlRec.Level := Level;
          UrlFile.Free;
          FavList.Add(UrlRec);
        end;
      end;
    Found := FindNext(SearchRec);
  end;

end;

procedure TExportFavorite.SetAbout(Value: string);
begin
  Exit;
end;

procedure TExportFavorite.TraverseFavList(Idx, PrevIdx: Integer);
var
  UrlRec, PrevUrlRec: PUrlRec;
  X: Integer;
begin
  if Idx < FavList.Count then
  begin
    UrlRec := FavList[Idx];
    if PrevIdx = -1 then
      PrevUrlRec := nil
    else
      PrevUrlRec := FavList[PrevIdx];
    if UrlRec.UrlName = '' then
    begin
      if PrevUrlRec <> nil then
      begin
        X := PrevUrlRec.Level;
        while UrlRec.Level <= X do
        begin
          MakeHeaderBottom(PrevUrlRec);
          Dec(PrevUrlRec.Level);
          Dec(X);
        end;
      end;
      MakeHeaderTop(UrlRec);
      PrevIdx := Idx;
    end
    else
      MakeBookmark(UrlRec);
    TraverseFavList(Idx + 1, PrevIdx);
  end;
end;

procedure TExportFavorite.MakeDocumentTop;
begin
  BmkList.Add('<!-- Made with ' + Application.Title + ' -->');
  BmkList.Add('');
  BmkList.Add('<TITLE>' + 'Exported Favorites' + '</TITLE>');
  BmkList.Add('<H1>' + 'Exported Favorites' + '</H1>');
  BmkList.Add('');
  BmkList.Add('<DL><P>');
end;

procedure TExportFavorite.MakeDocumentBottom;
begin
  BmkList.Add('');
  BmkList.Add('</DL><P>');
end;

procedure TExportFavorite.MakeHeaderTop(UrlRec: PUrlRec);
var
  I, Idx: Integer;
  S: string;
  A: array[0..255] of Char;
begin
  FillChar(A, SizeOf(A), 0);
  Idx := 1;
  for I := 1 to Length(UrlRec.Rep) do
    if UrlRec.Rep[I] = '\' then
      Idx := I + 1;
  for I := Idx to Length(UrlRec.Rep) do
    A[I - Idx] := UrlRec.Rep[I];
  BmkList.Add('');
  for I := 1 to UrlRec.Level do
    S := S + '    ';
  BmkList.Add(S + '<DT><H3>' + A + '</H3>');
  BmkList.Add(S + '<DL><P>');
end;

procedure TExportFavorite.MakeHeaderBottom(UrlRec: PUrlRec);
var
  I: Integer;
  S: string;
begin
  for I := 1 to UrlRec.Level do
    S := S + '    ';
  BmkList.Add(S + '</DL><P>');
  BmkList.Add('');
end;

procedure TExportFavorite.MakeBookmark(UrlRec: PUrlRec);
var
  I: Integer;
  S: string;
begin
  Delete(UrlRec.UrlName, Length(UrlRec.UrlName), 1);
  for I := 1 to UrlRec.Level do
    S := S + '    ';
  BmkList.Add(S + '<DT><A HREF="' + UrlRec.UrlPath + '">' +
    UrlRec.UrlName + '</A>' + '<BR>');
end;

function SortFunction(Item1, Item2: Pointer): Integer;
var
  Rec1, Rec2: PUrlRec;
begin
  Result := 0;
  Rec1 := Item1;
  Rec2 := Item2;
  if Rec1.Rep < Rec2.Rep then
    Result := -1;
  if Rec1.Rep > Rec2.Rep then
    Result := 1;
  if Rec1.Rep = Rec2.Rep then
  begin
    if Rec1.UrlName < Rec2.UrlName then
      Result := -1;
    if Rec1.UrlName > Rec2.UrlName then
      Result := 1;
    if Rec1.UrlName = Rec2.UrlName then
      Result := 0;
  end;
end;

procedure TExportFavorite.MakeBookmarkFile;
begin
  if FTargetPath = '' then
  begin
    MessageDlg('The target path is invalid.' + #10 + #13 + 'Please change it.', mtError, [MbOk], 0);
    exit;
  end;
  if FTargetFileName = '' then
  begin
    MessageDlg('The target file name is invalid.' + #10 + #13 + 'Please change it.', mtError, [MbOk], 0);
    Exit;
  end;
  if not (pos('htm', FTargetFileName) > 1) then
  begin
    MessageDlg('The target file name extension is invalid.' + #10 + #13 + 'Please change it to "*.htm".', mtError, [MbOk], 0);
    Exit;
  end;
  if FFavoritesPath = '' then
  begin
    MessageDlg('The Location path is invalid.' + #10 + #13 + 'Please change it.', mtError, [MbOk], 0);
    Exit;
  end;
  if FSuccessMessage.Text = '' then
  begin
    MessageDlg('You must enter a message or turn off messages.' + #10 + #13 + 'Please change it.', mtError, [MbOk], 0);
    Exit;
  end;
{$IFDEF DELPHI6_UP}{$WARN SYMBOL_PLATFORM OFF}{$ENDIF}
  NavigatePath := IncludeTrailingBackslash(FTargetPath) + FTargetFileName;
{$IFDEF DELPHI6_UP}{$WARN SYMBOL_PLATFORM ON}{$ENDIF}
  BmkList := TStringList.Create;
  try
    MakeDocumentTop;
    TraverseFavList(0, -1);
    MakeDocumentBottom;
    try
      BmkList.SaveToFile(NavigatePath);
    except on EFCreateError do
      begin
        MessageDlg('The target file name is invalid.' + #10 + #13 + 'Please change it.', mtError, [MbOk], 0);
      end;
    end;
  finally
    BmkList.Free;
  end;
  if ShowSuccessMessage then
    MessageDlg(SuccessMessage.Text + 'The file name is: ' + NavigatePath, mtInformation, [MbOk], 0);
  if assigned(fStatusBar) then
    FStatusBar.SimpleText := SuccessMessage.Text + 'The file name is: ' + NavigatePath;
end;

procedure TExportFavorite.ExportFavorites;
var
  I: Integer;
begin
  if not FEnabled then
    Exit;
  FavList := TList.Create;
  try
    if FFavoritesPath = 'Auto' then
      GetFavoritesFolder
    else
      FavFolder := FFavoritesPath;
    if (FavFolder <> '') then
    begin
      SearchURL(FavFolder, 1);
      FavList.Sort(SortFunction);
      MakeBookmarkFile;
      SuccessFlag := True;
      if fExploreFavFileFolder then
        ShellExecute(Forms.Application.Handle, 'explore', Pchar(FTargetPath), nil,
          nil, SW_SHOWNORMAL);
      if fNavigateOnComplete then
        if Assigned(fEmbeddedWB) then
          fEmbeddedWB.Navigate(FTargetPath + FTargetFileName)
        else
          MessageDlg(ASS_MESS, mtError, [MbOk], 0);
    end
    else
    begin
      MessageDlg('The favorites file path is invalid.' + #10 + #13 + 'Please change it.', mtError, [MbOk], 0);
      exit;
    end;
    for I := 0 to FavList.Count - 1 do
      Dispose(PUrlRec(FavList[I]));
  finally
    FavList.Free;
  end;
end;

procedure TExportFavorite.ExportFavoritesToIni;
var
  I: Integer;
  // ini : TIniFile;
begin
  if not FEnabled then
    Exit;
  FavList := TList.Create;
  if FFavoritesPath = 'Auto' then
    GetFavoritesFolder
  else
    FavFolder := FFavoritesPath;
  if (FavFolder <> '') then
  begin
    SearchURL(FavFolder, 1);
    FavList.Sort(SortFunction);
         //--------
    if FTargetPath = '' then
    begin
      MessageDlg('The target path is invalid.' + #10 + #13 + 'Please change it.', mtError, [MbOk], 0);
      exit;
    end;
    if FTargetFileName = '' then
    begin
      MessageDlg('The target file name is invalid.' + #10 + #13 + 'Please change it.', mtError, [MbOk], 0);
      exit;
    end;
    if FFavoritesPath = '' then
    begin
      MessageDlg('The Location path is invalid.' + #10 + #13 + 'Please change it.', mtError, [MbOk], 0);
      exit;
    end;
    if fSuccessMessage.Text = '' then
    begin
      MessageDlg('You must enter a message or turn off messages.' + #10 + #13 + 'Please change it.', mtError, [MbOk], 0);
      exit;
    end;
    NavigatePath := FTargetPath + '\' + FTargetFileName;
    BmkList := TStringList.Create;
   //Ini := TIniFile.create(FTargetPath);

    SuccessFlag := True;
    if fExploreFavFileFolder then
      ShellExecute(Forms.Application.Handle, 'explore', Pchar(FTargetPath), nil,
        nil, SW_SHOWNORMAL);
    if fNavigateOnComplete then
      if Assigned(fEmbeddedWB) then
        fEmbeddedWB.Navigate(FTargetPath + FTargetFileName)
      else
        MessageDlg(ASS_MESS, mtError, [MbOk], 0);
  end
  else
  begin
    MessageDlg('The favorites file path is invalid.' + #10 + #13 + 'Please change it.', mtError, [MbOk], 0);
    exit;
  end;
  for I := 0 to FavList.Count - 1 do
    Dispose(PUrlRec(FavList[I]));
  FavList.Free;
end;

end.
