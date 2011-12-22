//***********************************************************
//                    Import Favorites                      *
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
//$Id: ImportFavorites.pas,v 1.2 2006/11/15 21:01:42 sergev Exp $

unit ImportFavorites;

interface

{$I EWB_jedi.inc}

uses
  Windows, SysUtils, Classes, Dialogs, IniFiles, SHDocVw_EWB, EmbeddedWB, Registry, ComCtrls;

type
  PUrlRec = ^TUrlRec;
  TUrlRec = record
    Rep: string;
    UrlName: string;
    UrlPath: string;
    Level: Integer;
  end;

type
  TImportFavorite = class(TComponent)
  private
    BookmarkList: TStringList;
    FAbout: string;
    FCurrentFileName: string;
    FCurrentFilePath: string;
    FEnabled: Boolean;
    FFavoritesPath: string;
    FNavigateOnComplete: Boolean;
    FShowSuccessMessage: Boolean;
    FStatusBar: TStatusBar;
    FSuccessMessage: TStrings;
    FTargetSubFolder: string;
    FWebBrowser: TEmbeddedWB;
    L: TList;
    LvlList: TStringList;
    TargetFolder: string;
    function FindFolder(HtmlStr: string; var Lvl: Integer): Boolean;
    function FindSectionEnd(HtmlStr: string; var Lvl: Integer): Boolean;
    function FindUrl(HtmlStr: string; Lvl: Integer): Boolean;
    function MakeFolder(Folder: string): Boolean;
    function MakeUrlFile(UrlName, UrlPath: string): Boolean;
    procedure Convert(Folder: string);
    procedure GetFavoritesFolder(var Folder: string);
    procedure MakeFavorites;
    procedure ReplaceIllChars(var S: string);
    procedure ScanBmkLine(I: Integer; Lvl: Integer);
    procedure SetAbout(Value: string);
    procedure SetSuccessMessage(Value: TStrings);
  protected

  public
    SuccessFlag: Boolean;
    NavigatePath: string;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ImportFavorites;
  published
    property About: string read fAbout write SetAbout;
    property CurrentFileName: string read FCurrentFileName write FCurrentFileName;
    property CurrentFilePath: string read FCurrentFilePath write FCurrentFilePath;
    property Enabled: boolean read fEnabled write fEnabled default True;
    property FavoritesPath: string read fFavoritesPath write fFavoritesPath;
    property NarigateOnComplete: Boolean read fNavigateOnComplete write fNavigateOnComplete default False;
    property ShowSuccessMessage: Boolean read fShowSuccessMessage write fShowSuccessMessage default True;
    property StatusBar: TStatusBar read FStatusBar write FStatusBar;
    property SuccessMessage: TStrings read FSuccessMessage write SetSuccessMessage;
    property TargetSubFolder: string read fTargetSubFolder write fTargetSubFolder;
    property WebBrowser: TEmbeddedWB read fWebBrowser write fWebBrowser;
  end;

implementation
uses
  IEConst, EwbCoreTools;

constructor TImportFavorite.Create;
begin
  FAbout := 'TImportFavorites by bsalsa. ' + WEB_SITE;
  FCurrentFileName := 'newbook.htm';
  FCurrentFilePath := 'C:\';
  FTargetSubFolder := 'Imported Bookmarks';
  FFavoritesPath := 'Auto';
  FSuccessMessage := TStringList.Create;
  FSuccessMessage.Add('The bookmarks have been imported into your favorites successfully!'
    + #10 + #13 + 'You can find them in your favorites as a sub folder.');
  FShowSuccessMessage := True;
  SuccessFlag := False;
  FEnabled := True;
  FNavigateOnComplete := False;
  inherited;
end;

destructor TImportFavorite.Destroy;
begin
  FSuccessMessage.Free;
  inherited Destroy;
end;

procedure TImportFavorite.SetSuccessMessage(Value: TStrings);
begin
  FSuccessMessage.Assign(Value)
end;

procedure TImportFavorite.SetAbout(Value: string);
begin
  Exit;
end;

procedure TImportFavorite.GetFavoritesFolder(var Folder: string);
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_CURRENT_USER;
    Registry.OpenKey('Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', False);
    Folder := Registry.ReadString('Favorites');
  finally
    Registry.Free;
  end;
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

procedure TImportFavorite.Convert(Folder: string);
var
  I: Integer;
begin
  L := TList.Create;
  try
    LvlList := TStringList.Create;
    try
      LvlList.Add('');
      ScanBmkLine(0, 0);
      L.Sort(SortFunction);
      MakeFavorites;
      for I := 0 to L.Count - 1 do
        Dispose(PUrlRec(L[I]));
    finally
      LvlList.Free;
    end;
  finally
    L.Free;
  end;
end;

procedure TImportFavorite.ScanBmkLine(I: Integer; Lvl: Integer);
begin
  if I < BookmarkList.Count - 1 then
  begin
    if not FindSectionEnd(BookmarkList[I], Lvl) then
      if not FindUrl(BookmarkList[I], Lvl) then
        FindFolder(BookmarkList[I], Lvl);
    ScanBmkLine(I + 1, Lvl);
  end;
end;

function TImportFavorite.FindFolder(HtmlStr: string; var Lvl: Integer): Boolean;
const
  FolderSubStr: string = '<H3';
var
  J, Idx: Integer;
  S: array[0..255] of Char;
  UrlRec: PUrlRec;
  I: Integer;
  Folder: string;
  FName: string;
begin
  J := Pos(FolderSubStr, HtmlStr);
  Result := (J <> 0);
  if J <> 0 then
  begin
    Inc(Lvl);
    FillChar(S, SizeOf(S), 0);
    Idx := 1;
    for J := 1 to Length(HtmlStr) - 1 do
      if HtmlStr[J] = '>' then
        Idx := J + 1;
    for J := Idx to Length(HtmlStr) - 5 do
      S[J - Idx] := HtmlStr[J];

    Folder := S;
    ReplaceIllChars(Folder);
    if LvlList.Count > Lvl then
      LvlList[Lvl] := Folder
    else
      LvlList.Add(Folder);
    FName := LvlList[Lvl];
    for I := Lvl - 1 downto 1 do
      FName := LvlList[I] + '\' + FName;
    UrlRec := New(PUrlRec);
    UrlRec.Rep := FName;
    UrlRec.UrlName := '';
    UrlRec.UrlPath := '';
    UrlRec.Level := Lvl;
    L.Add(UrlRec);
  end;
end;

function TImportFavorite.FindUrl(HtmlStr: string; Lvl: Integer): Boolean;
const
  UrlSubStr: string = 'http://';
var
  J, K: Integer;
  S1, S2, S3: array[0..255] of Char;
  Apo1, Apo2: PChar;
  I: Integer;
  SPath, SName: string;
  FName: string;
  UrlRec: PUrlRec;
begin
  J := Pos(UrlSubStr, HtmlStr);
  Result := (J <> 0);
  if J <> 0 then
  begin
    FillChar(S1, SizeOf(S1), 0);
    FillChar(S2, SizeOf(S2), 0);
    FillChar(S3, SizeOf(S3), 0);
    SPath := HtmlStr;
    Apo1 := StrScan(PChar(SPath), '"');
    for K := 1 to StrLen(Apo1) do
      S1[K - 1] := Apo1[K];
    for K := 0 to Pos('"', S1) - 2 do
      S2[K] := S1[K];
    SPath := S2;
    Apo2 := StrScan(Apo1, '>');
    for K := 1 to StrLen(Apo2) do
      S1[K - 1] := Apo2[K];
    for K := 0 to Pos('<', S1) - 2 do
      S3[K] := S1[K];
    SName := S3;
    ReplaceIllChars(SName);
    FName := LvlList[Lvl];
    for I := Lvl - 1 downto 1 do
      FName := LvlList[I] + '\' + FName;
    UrlRec := New(PUrlRec);
    UrlRec.Rep := FName;
    UrlRec.UrlName := SName;
    UrlRec.UrlPath := SPath;
    UrlRec.Level := Lvl;
    L.Add(UrlRec);
  end;
end;

function TImportFavorite.FindSectionEnd(HtmlStr: string; var Lvl: Integer): Boolean;
const
  EndSubStr: string = '</DL>';
var
  J: Integer;
begin
  J := Pos(EndSubStr, HtmlStr);
  Result := (J <> 0);
  if J <> 0 then
    Dec(Lvl);
end;

procedure TImportFavorite.MakeFavorites;
var
  I: Integer;
  UrlRec: PUrlRec;
begin
  for I := 0 to L.Count - 1 do
  begin
    UrlRec := L[I];
    if UrlRec.UrlName = '' then
      MakeFolder(TargetFolder + '\' + UrlRec.Rep)
    else
      MakeUrlFile(TargetFolder + '\' + UrlRec.Rep + '\' + UrlRec.UrlName + '.url', UrlRec.UrlPath);
  end;
end;

function TImportFavorite.MakeFolder(Folder: string): Boolean;
begin
  Result := CreateDirectory(PChar(Folder), nil);
end;

function TImportFavorite.MakeUrlFile(UrlName, UrlPath: string): Boolean;
var
  UrlFile: TIniFile;
begin
  UrlFile := TIniFile.Create(UrlName);
  try
    UrlFile.WriteString('InternetShortcut', 'URL', UrlPath);
    Result := True;
  finally
    UrlFile.Free;
  end;
end;

procedure TImportFavorite.ReplaceIllChars(var S: string);
const
  ReplacedChar: Char = '-';
var
  I: Integer;
begin
  for I := 1 to Length(S) do
    if CharInSet(S[I], ['\', '/', ':', '*', '?', '"', '<', '>', '|']) then
    //  if S[I] in ['\', '/', ':', '*', '?', '"', '<', '>', '|'] then
      S[I] := ReplacedChar;
end;

procedure TImportFavorite.ImportFavorites;
var
  R: TSearchRec;
  FavFolder: string;
begin
  if not Enabled then Exit;
  if FCurrentFilePath = '' then
  begin
    MessageDlg('The favorites file path is invalid.' + #10 + #13 + 'Please change it.', mtError, [MbOk], 0);
    Exit;
  end;
  if FCurrentFileName = '' then
  begin
    MessageDlg('The Current file name is invalid.' + #10 + #13 + 'Please change it.', mtError, [MbOk], 0);
    Exit;
  end;
  if not (Pos('htm', FCurrentFileName) > 1) then
  begin
    MessageDlg('The target file name extention is invalid.' + #10 + #13 + 'Please change it to "*.htm".', mtError, [MbOk], 0);
    Exit;
  end;
  if fTargetSubFolder = '' then
  begin
    MessageDlg('You must a proper sub folder name.' + #10 + #13 + 'Please change it.', mtError, [MbOk], 0);
    Exit;
  end;
  if FSuccessMessage.Text = '' then
  begin
    MessageDlg('You must enter a message or turn off messages.' + #10 + #13 + 'Please change it.', mtError, [MbOk], 0);
    Exit;
  end;
  if not FileExists(FCurrentFilePath + '\' + FCurrentFileName) then
  begin
    MessageDlg('The Favorite file you specified does not exist in the current path.', mtError, [MbOk], 0);
  end
  else
  begin
    BookmarkList := TStringList.Create;
    BookmarkList.LoadFromFile(FCurrentFilePath + FCurrentFileName);
    if FFavoritesPath = 'Auto' then
      GetFavoritesFolder(FavFolder)
    else
      FavFolder := fFavoritesPath;
    if (FavFolder <> '') then
    begin
      CreateDirectory(PChar(FavFolder + '\' + TargetSubFolder), nil);
      if FindFirst(FavFolder + '\' + TargetSubFolder, faDirectory, R) = 0 then
      begin
        TargetFolder := FavFolder + '\' + TargetSubFolder;
        Convert(FavFolder + '\' + TargetSubFolder);
        if FShowSuccessMessage then
          MessageDlg(FSuccessMessage.Text, mtInformation, [MbOk], 0);
        if assigned(FStatusBar) then
          FStatusBar.SimpleText := SuccessMessage.Text;
        SuccessFlag := True;
        if FNavigateOnComplete then
          if Assigned(FWebBrowser) then
            FWebBrowser.Navigate(FCurrentFilePath + FCurrentFileName)
          else
            MessageDlg(ASS_MESS, mtError, [MbOk], 0);
      end
      else
      begin
        MessageDlg('The subfolder name you specified is invalid.', mtError, [MbOk], 0);
        SuccessFlag := False;
      end;
      FindClose(R);
    end;
    BookmarkList.Free;
  end;
end;

end.
