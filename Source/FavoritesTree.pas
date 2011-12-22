//******************************************************************
//                                                                 *
//                       TFavoritesTree                            *                                                      *
//                     Freeware Component                          *
//                     For Delphi 5 - 2009                         *
//                            by                                   *
//                       Pete Morris                               *
//                     and Eran Bodankin                           *
//                                                                 *
//                                                                 *
//  Updated versions:                                              *
//               http://www.bsalsa.com                             *
//******************************************************************

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
//$Id: FavoritesTree.pas,v 1.4 2006/12/05 11:56:31 bsalsa Exp $

unit FavoritesTree;

interface

{$I EWB_jedi.inc}

uses
  ShlObj, Messages, Windows, SysUtils, Classes, Forms, ComCtrls, DIRMonitor,
  iniFiles, EmbeddedWB,
  ExportFavorites, ImportFavorites, EwbAcc;

type
  TNodeType = (ntRoot, ntItem, ntEmptyFolder, ntFolder, ntOrganizeFavorites,
    ntAddToFavorites, ntImportFavorites, ntExportFavorites, ntTools);
  TFavoriteOption = (foShowRoot, foShowItems, foShowOrganize, foShowAdd,
    foShowImport, foShowExport);
  TFavoriteOptions = set of TFavoriteOption;
  TNodeAddedEvent = procedure(Sender: TObject; const aNode: TTreeNode;
    aNodeType: TNodeType) of object;
  TNodeMissingEvent = procedure(Sender: TObject; const aNode: TTreeNode;
    aNodeType: TNodeType) of object;
  TNavigateEvent = procedure(Sender: TObject; const Url: string) of object;
  TPopupMenuMode = (pmm_System, pmm_PopupMenu);

  TCustomFavoritesTree = class(TCustomTreeView)
  private
    lFolder: PItemIDList;
    lPath: array[0..MAX_PATH] of char;
    FavIndex: integer;
    FOptions: TFavoriteOptions;
    FPath: string;
    // FFavoritesMonitor: TDirMonitor;
    fEmbeddedWB: TEmbeddedWB;
    fExportFavorites: TExportFavorite;
    FImportFavorites: TImportFavorite;
    FOnNavigate: TNavigateEvent;
    FOnNodeAdded: TNodeAddedEvent;
    FOnNodeMissing: TNodeMissingEvent;
    FOnFavoritesChanged: TNotifyEvent;
    FPopupMenuMode: TPopupMenuMode;
    //procedure DoFavoritesChanged(Sender: TObject);
    procedure SetOption(const Value: TFavoriteOptions);
    // function ShellItem(Index: Integer): PItem;
  protected
    procedure DblClick; override;
    function InternalAdd(const aParent: TTreeNode; const aCaption: string; const
      aNodeType: TNodeType): TTreeNode; virtual;
    procedure Loaded; override;
    property Options: TFavoriteOptions read FOptions write SetOption;
    property OnFavoritesChanged: TNotifyEvent read FOnFavoritesChanged write
      FOnFavoritesChanged;
    property OnNavigate: TNavigateEvent read FOnNavigate write FOnNavigate;
    property OnNodeAdded: TNodeAddedEvent read FOnNodeAdded write FOnNodeAdded;
    property OnNodeMissing: TNodeMissingEvent read FOnNodeMissing write
      FOnNodeMissing;
    procedure PopupSystemContextMenu(Node: TTreeNode; Point: TPoint);
    procedure WMContextMenu(var Message: TMessage); message WM_Contextmenu;
  public
    constructor Create(AOwner: TComponent); override;
    procedure GetSelectedIndex(Node: TTreeNode); override;
    procedure NodeAdded(Sender: TObject;
      const aNode: TTreeNode; aNodeType: TNodeType);
    destructor Destroy; override;
    procedure AddToFavorites;
    procedure ExportTheFavorites;
    function GetFileName(const aNode: TTreeNode): string;
    procedure ImportTheFavorites;
    procedure OrganizeFavorites;
    procedure Refresh; dynamic;
    procedure RefreshFolder(const aFolder: TTreeNode); dynamic;
    function NodeURL(const aNode: TTreeNode): string;
  published
    property PopupMenuMode: TPopupMenuMode read FPopupMenuMode write
      FPopupMenuMode;
    property EmbeddedWB: TEmbeddedWB read fEmbeddedWB write fEmbeddedWB;
    property ImportFavorites: TImportFavorite read FImportFavorites write
      FImportFavorites;
    property ExportFavorites: TExportFavorite read fExportFavorites write
      fExportFavorites;
  end;
  TFavoritesTree = class(TCustomFavoritesTree)
  private
  protected
  public
  published
    //new properties
    property Options;
    //inherited properties
    property Align;
    property Anchors;
    property BiDiMode;
    property BorderStyle;
    property BorderWidth;
    property ChangeDelay;
    property Color;
    property Constraints;
    property Cursor;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    //  property Expand;
    property Font;
    property Height;
    property HelpContext;
    property HideSelection;
    property Hint;
    property HotTrack;
    property Images;
    property Indent;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property PopupMenu;
    property RightClickSelect;
    property RowSelect;
    property ShowButtons;
    property ShowHint;
    property ShowLines;
    property ShowRoot;
    property StateImages;
    property TabOrder;
    property TabStop;
    property Tag;
    property ToolTips;
    property Top;
    property Visible;
    property Width;
    //NewEvents
    property OnFavoritesChanged;
    //Called when you another app alters the favorites
    property OnNavigate; //When you need to navigate somewhere
    property OnNodeAdded;
    //When a node is added, so you can set the image indexes if you like
    property OnNodeMissing;
    //When a node is clicked, but someone else has deleted the file/folder
    property OnAdvancedCustomDraw;
    property OnAdvancedCustomDrawItem;
    property OnChange;
    property OnChanging;
    property OnClick;
    property OnCollapsed;
    property OnCollapsing;
    property OnContextPopup;
    property OnCustomDraw;
    property OnCustomDrawItem;
    property OnDblClick;
    property OnDeletion;
    property OnDragDrop;
    property OnDragOver;
    property OnEdited;
    property OnEditing;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnExpanded;
    property OnExpanding;
    property OnGetImageIndex;
    property OnGetSelectedIndex;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;

var
  Folder: IShellFolder;

implementation
uses
{$IFDEF DELPHI6_UP}
{$WARN UNIT_PLATFORM OFF}
{$ENDIF}
  MenuContext, SHDocVw_EWB, ComObj, ActiveX, FileCtrl, Registry;

{ TCustomFavoritesTree }

procedure TCustomFavoritesTree.GetSelectedIndex(Node: TTreeNode);
begin
  inherited;
  Node.SelectedIndex := Node.ImageIndex;
end;

procedure TCustomFavoritesTree.NodeAdded(Sender: TObject;
  const aNode: TTreeNode; aNodeType: TNodeType);
begin
  inherited;
end;

constructor TCustomFavoritesTree.Create(AOwner: TComponent);
begin
  inherited;
  SHGetSpecialFolderLocation(0, CSIDL_FAVORITES, lFolder);
  SHGetPathFromIDList(lFolder, lPath);
  FPath := StrPas(lPath);
  if FPath[Length(FPath)] <> '\' then
    FPath := FPath + '\';
  //FFavoritesMonitor := TDIRMonitor.Create(lPath, True, DoFavoritesChanged);
  FOptions := [foShowRoot, foShowItems, foShowOrganize, foShowAdd, foShowImport,
    foShowExport];
  ShowRoot := true;
end;

procedure TCustomFavoritesTree.Loaded;
begin
  inherited;
  ShowRoot := true;
  Refresh;
end;

destructor TCustomFavoritesTree.Destroy;
begin
  //  FFavoritesMonitor.Terminate;
  { if FFavoritesMonitor <> nil then
     FFavoritesMonitor.Free; }
  inherited;
end;

{procedure TCustomFavoritesTree.DoFavoritesChanged(Sender: TObject);
begin
  if Assigned(OnFavoritesChanged) then
    OnFavoritesChanged(Self);
end;}

function TCustomFavoritesTree.NodeURL(const aNode: TTreeNode): string;
const
  CLSID_InternetShortCut: TGUID = (d1: $FBF23B40; D2: $E3F0; D3: $101B; D4:
    ($84, $88, $00, $AA, $00, $3E, $56, $F8));
var
  FileName: string;
  FName: array[0..MAX_PATH] of WideChar;
  Pchr: Pchar;
  IUrl: IUniformResourceLocator;
  PersistFile: IPersistFile;
begin
  FileName := GetFileName(aNode);
  IUrl := CreateComObject(CLSID_InternetShortCut) as IUniformResourceLocator;
  PersistFile := IUrl as IPersistFile;
  StringToWideChar(FileName, FName, MAX_PATH);
  PersistFile.Load(FName, STGM_READ);
  IUrl.GetURL(@Pchr);
  Result := Pchr;
end;

function TCustomFavoritesTree.GetFileName(const aNode: TTreeNode): string;
begin
  if (aNode = nil) or ((aNode = Items[FavIndex]) {and  (foShowRoot in Options)}) then
    Result := FPath
  else
  begin
    case TNodeType(aNode.Data) of
      ntItem: Result := GetFileName(aNode.Parent) + aNode.Text + '.Url';
      ntFolder: Result := GetFileName(aNode.Parent) + aNode.Text + '\';
      ntEmptyFolder: Result := GetFileName(aNode.Parent) + aNode.Text + '\';
      ntTools: Result := GetFileName(aNode.Parent) + aNode.Text + '\';
    end;
  end;
end;

procedure TCustomFavoritesTree.RefreshFolder(const aFolder: TTreeNode);
var
  CurrentPath: string;
  SR: TSearchRec;
  Found: Integer;
begin
  CurrentPath := GetFileName(aFolder);
  Found := FindFirst(CurrentPath + '*.*', faDirectory, SR);
  while Found = 0 do
  begin
    if (SR.Attr and faDirectory <> 0) and (SR.Name <> '.') and (SR.Name <>
      '..') then
      InternalAdd(aFolder, SR.Name, ntEmptyFolder);
    Found := FindNext(SR);
  end;
  FindClose(SR);
  if foShowItems in Options then
  begin
    Found := FindFirst(CurrentPath + '*.Url', faAnyFile, SR);
    while Found = 0 do
    begin
      if (SR.Attr and faDirectory = 0) then
      begin
        InternalAdd(aFolder, copy(SR.Name, 1, Length(SR.Name) - 4),
          ntItem);
      end;
      Found := FindNext(SR);
    end;
    FindClose(SR);
  end;
  if aFolder <> nil then
    if TNodeType(aFolder.Data) = ntEmptyFolder then
      aFolder.Data := Pointer(ntFolder);
  if aFolder <> nil then
    if TNodeType(aFolder.Data) = ntFolder then
    begin
      aFolder.HasChildren := True;
      aFolder.Data := Pointer(ntFolder);
      aFolder.Expand(True);
    end;
end;

function TCustomFavoritesTree.InternalAdd(const aParent: TTreeNode;
  const aCaption: string; const aNodeType: TNodeType): TTreeNode;
begin
  Result := Items.AddChild(aParent, aCaption);
  Result.Data := Pointer(aNodeType);
  if Assigned(OnNodeAdded) then
    OnNodeAdded(Self, Result, aNodeType);
end;

procedure TCustomFavoritesTree.Refresh;
var
  RootNode, RootNode2: TTreeNode;
begin
  try
    Items.BeginUpdate;
    while Items.Count > 0 do
      Items[0].Delete;

    if foShowRoot in Options then
    begin
      RootNode := InternalAdd(nil, 'Tools', ntTools);
    end
    else
      RootNode := nil;
    if foShowOrganize in Options then
      InternalAdd(RootNode, 'Organize favorites', ntOrganizeFavorites);
    if (foShowAdd in Options) then
      InternalAdd(RootNode, 'Add To favorites', ntAddToFavorites);
    if (foShowImport in Options) then
      InternalAdd(RootNode, 'Import favorites', ntImportFavorites);
    if (foShowExport in Options) then
      InternalAdd(RootNode, 'Export favorites', ntExportFavorites);
    if (RootNode <> nil) then
      RootNode.Expanded := True;
    if (pos('Links', RootNode.Text) > 0) or (pos('Imported', RootNode.Text) > 0) then
    begin
      RootNode.HasChildren := True;
    end;
    RootNode2 := InternalAdd(nil, 'Favorites', ntRoot);
    FavIndex := RootNode.Count + 1;
    RefreshFolder(RootNode2);
    RootNode2.Expand(true);

  finally
    Items.EndUpdate;
  end;
end;

procedure TCustomFavoritesTree.SetOption(const Value: TFavoriteOptions);
begin
  FOptions := Value;
end;

procedure TCustomFavoritesTree.ExportTheFavorites;
begin
  if Assigned(ExportFavorites) then
    fExportFavorites.ExportFavorites;
end;

procedure TCustomFavoritesTree.ImportTheFavorites;
begin
  if Assigned(ImportFavorites) then
    FImportFavorites.ImportFavorites;
  Refresh;
end;

procedure TCustomFavoritesTree.OrganizeFavorites;
var
  H: Hwnd;
  p: procedure(Handle: THandle; Path: PAnsiChar); stdcall;
begin
  H := LoadLibrary('shdocvw.dll');
  if H <> 0 then
  begin
    p := GetProcAddress(H, 'DoOrganizeFavDlg');
    if Assigned(p) then
      p(Application.Handle, PAnsiChar(AnsiString(FPath)));
  end;
  FreeLibrary(H);
  Refresh;
end;

procedure AddToFav(const Url, Title: string);
const
  CLSID_SHELLUIHELPER: TGUID = '{64AB4BB7-111E-11D1-8F79-00C04FC2FBE1}';
var
  ShellUIHelper: ISHellUIHelper;
  Url1, Title1: OleVariant;
begin
  Title1 := Title;
  Url1 := Url;
  CoCreateInstance(CLSID_SHELLUIHELPER, nil, CLSCTX_INPROC_SERVER,
    IID_IShellUIHelper, ShellUIHelper);
  ShellUIHelper.AddFavorite(Url1, Title1);
end;

procedure TCustomFavoritesTree.AddToFavorites;
begin
  if Assigned(EmbeddedWB) then
  begin
    AddToFav(EmbeddedWB.LocationURL, EmbeddedWB.LocationName);
  end;
  Refresh;
end;

function URLFromShortcut(const dotURL: string): string;
begin
  with TIniFile.Create(dotURL) do
  try
    try
      Result := ReadString('InternetShortcut', 'Url', '');
    except;
      Result := '';
    end;
  finally
    Free;
  end;
end;

procedure TCustomFavoritesTree.DblClick;
var
  URLPath: widestring;
  //  ID      : PItemIDList;
  X: Olevariant;
  Url: string;
begin
  inherited;
  if Selected = nil then
    Exit;

  case TNodeType(Selected.Data) of
    ntFolder, ntEmptyFolder:
      if not DirectoryExists(GetFileName(Selected)) then
      begin
        if Assigned(OnNodeMissing) then
          OnNodeMissing(Self, Selected, TNodeType(Selected.Data));
        Selected.Delete;
        Exit;
      end;

    ntItem:
      if not FileExists(GetFileName(Selected)) then
      begin
        if Assigned(OnNodeMissing) then
          OnNodeMissing(Self, Selected, TNodeType(Selected.Data));
        Selected.Delete;
        Exit;
      end;
  end;

  case TNodeType(Selected.Data) of
    ntAddToFavorites: AddToFavorites;
    ntOrganizeFavorites: OrganizeFavorites;
    ntImportFavorites: ImportTheFavorites;
    ntExportFavorites: ExportTheFavorites;
    ntTools: Selected.Expand(True);
    ntEmptyFolder:
      begin
        RefreshFolder(Selected);
        Selected.Expand(False);
      end;
    ntItem:
      begin
        if Assigned(OnNavigate) then
          FOnNavigate(Self, NodeURL(Selected));
        if Assigned(EmbeddedWB) then
        begin
          URLPath := GetFileName(Selected);
          Url := URLFromShortcut(URLPath);
          EmbeddedWB.Navigate(Url, X, X, X, X);
        end;
      end;
  end;
end;

{function TCustomFavoritesTree.ShellItem(Index: Integer): aParent;
begin
   Result := PItem(List[Index]);
end; }

procedure TCustomFavoritesTree.PopupSystemContextMenu(Node: TTreeNode; Point:
  TPoint);
var
  ISF: IShellFolder;
  Pidl: PItemIdList;
  Par: TTreeNode;
begin

  if not Assigned(Node) then
    Exit;
  Par := Node.Parent;
  if not Assigned(Par) then
    Exit;
  Pidl := Node.Data;
  try
    MenuContext.DisplayContextMenu(ISF, Pidl, 0, Application.Handle, Point, 1);
  except
    GetLastError;
  end;
end;

procedure TCustomFavoritesTree.WMContextMenu(var Message: TMessage);
var
  Point: TPoint;
  R: TRect;
  NewSel, SelItem: TTreeNode;
begin
  NewSel := nil;
  if Message.lparam = -1 then
  begin
    SelItem := TTreeNode(Selected);
    if not Assigned(SelItem) then
      Exit;
    R := SelItem.DisplayRect(True);
    Point.X := R.Left + ((R.Right - R.Left) div 2);
    Point.Y := R.Top - ((R.Top - R.Bottom) div 2);
  end
  else
  begin
    Point.X := LOWORD(Message.lParam);
    Point.Y := HIWORD(Message.lParam);
    Point := ScreenToClient(Point);
    SelItem := Selected //TListItem(GetPosition(P.X,P.Y));
  end;
  Point := ClientToScreen(Point);
  if (Selected <> SelItem) then
    NewSel := TTreeNode(Selected);
  Selected := SelItem;
  if PopupMenuMode = pmm_PopupMenu then
  begin
    if Assigned(Popupmenu) then
    begin
      PopupMenu.PopupComponent := Self;
      PopupMenu.Popup(Point.X, Point.Y)
    end;
  end
  else
  begin
    PopupSystemContextMenu(SelItem, Point);
  end;
  if Assigned(NewSel) then
    Selected := NewSel;
end;

end.
