//****************************************************
//                  IEMultiDownload                  *
//                For Delphi 5 - 2009                *
//                Freeware Component                 *
//                       by                          *
//                                                   *
//              Eran Bodankin (bsalsa)               *
//                 bsalsa@gmail.com                  *
//                                                   *
// Documentation and updated versions:               *
//               http://www.bsalsa.com               *
//****************************************************

{*******************************************************************************}
{LICENSE:
THIS SOFTWARE IS PROVIDED TO YOU "AS IS" WITHOUT WARRANTY OF ANY KIND,
EITHER EXPRESSED OR IMPLIED INCLUDING BUT NOT LIMITED TO THE APPLIED
WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
YOU ASSUME THE ENTIRE RISK AS TO THE ACCURACY AND THE USE OF THE SOFTWARE
AND ALL OTHER RISK ARISING OUT OF THE USE OR PERFORMANCE OF THIS SOFTWARE
AND DocUMENTATION. [YOUR Name] DOES NOT WARRANT THAT THE SOFTWARE IS ERROR-FREE
OR WILL OPERATE WITHOUT INTERRUPTION. THE SOFTWARE IS NOT DESIGNED, INTENDED
OR LICENSED FOR USE IN HAZARDOUS ENVIRONMENTS REQUIRING FAIL-SAFE CONTROLS,
INCLUDING WITHOUT LIMITATION, THE DESIGN, CONSTRUCTION, MAINTENANCE OR
OPERATION OF NUCLEAR FACILITIES, AIRCRAFT NAVIGATION OR COMMUNICATION SystemS,
AIR TRAFFIC CONTROL, AND LIFE SUPPORT OR WEAPONS SystemS. VSOFT SPECIFICALLY
DISCLAIMS ANY EXPRES OR IMPLIED WARRANTY OF FITNESS FOR SUCH PURPOSE.

You may use, change or modify the component under 4 conditions:
1. In your website, add a Link to "http://www.bsalsa.com"
2. In your application, add credits to "Embedded Web Browser"
3. Mail me  (bsalsa@gmail.com) any code change in the unit
   for the benefit of the other users.
4. Please consider donation in our web site!
{*******************************************************************************}

unit IEMultiDownload;

{$I EWB_jedi.inc}

interface

uses
  Dialogs, WinInet, MSHTML_EWB, Windows, SysUtils, Classes, IEDownload, IEParser, EwbUrl;

type
  TMultiState = (msBusy, msReady, msStopped);
  TMultiDownloadOptions = (doAll, doOnlyImages, doOnlyPages);

  TOnMultiParseErrorEvent = procedure(Sender: TObject; const ErrorCode: integer; const
    Url, stError: string) of object;
  TOnMultiCompleteEvent = procedure(Sender: TObject; const DownloadList: TStrings) of object;
  TOnMultiBeforeDownloadEvent = procedure(Sender: TObject; const
    DownloadList: TStrings; var Cancel: boolean) of object;
  TOnMultiGetDocInfoEvent = procedure(Sender: TObject; const Text: string) of object;
  TOnMultiGetQueryInfoEvent = procedure(const MimeType, Encoding, Disposition: string) of object;
  TOnMultiGetImageEvent = procedure(Sender: TObject; const ImgName, Alt, Align: string;
    var Cancel: Boolean) of object;
  TOnMultiGetLinkEvent = procedure(Sender: TObject; const hRef, Host, HostName,
    PathName, Port, Protocol, MimeType, NameProp: string; var Cancel: Boolean) of object;
  TMultiStateChangeEvent = procedure(Sender: TObject; const State: TMultiState) of object;

  TIEMultiDownload = class(TCustomIEDownload)

  private
    FAbout: string;
    FBaseUrl: WideString;
    FDownloadLevel: integer;
    FMultiDownloadOptions: TMultiDownloadOptions;
    FFromBaseSiteOnly: Boolean;
    FOnMultiComplete: TOnMultiCompleteEvent;
    FOnMultiGetDocInfo: TOnMultiGetDocInfoEvent;
    FOnMultiGetQueryInfo: TOnMultiGetQueryInfoEvent;
    FOnMultiGetImage: TOnMultiGetImageEvent;
    FOnMultiGetLink: TOnMultiGetLinkEvent;
    FOnMultiBeforeDownload: TOnMultiBeforeDownloadEvent;
    FMultiState: TMultiState;
    FOnMultiStateChange: TMultiStateChangeEvent;
    FOnMultiParseError: TOnMultiParseErrorEvent;
    FRoorUrl: string;
    HtmlParser: TIEParser;
    UrlParser: TUrl;
    slLinks: TStringList;
    slAll: TStringList;
    slImages: TStringList;
    procedure MultiAnchor(Sender: TObject; hRef, Target, Rel, Rev, Urn,
      Methods, Name, Host, HostName, PathName, Port, Protocol, Search, Hash,
      AccessKey, ProtocolLong, MimeType, NameProp: string; Element: TElementInfo); procedure SetAbout(Value: string);
    procedure MultiImage(Sender: TObject; Source, LowSrc, Vrml, DynSrc,
      Alt, Align, UseMap: string; IsMap: Boolean; Border, Loop: OleVariant; vSpace,
      hSpace, Width, Height: Integer; Element: TElementInfo);
    procedure MultiParseComplete(Sender: TObject; Doc: IhtmlDocument2; All: IHtmlElementCollection);
    procedure MultiGetDocInfo(Sender: TObject; const Text: string);
    procedure MultiGetQueryInfo(const MimeType, Encoding, Disposition: string);
    procedure MultiParseError(Sender: TObject; const ErrorCode: integer; const
      Url, stError: string);

  protected
  public
    constructor Create(Owner: TComponent); override;
    destructor Destroy; override;
    procedure GoMulti(BaseUrl: WideString);
    procedure Stop;
    procedure SetDownloadOptions(const Value: TMultiDownloadOptions);
    property MultiState: TMultiState read FMultiState;

  published
    property About: string read FAbout write SetAbout;
    property BaseUrl: WideString read FBaseUrl write FBaseUrl;
    property DownloadLevel: integer read FDownloadLevel write FDownloadLevel default 1;
    property DownloadOptions: TMultiDownloadOptions read FMultiDownloadOptions write SetDownloadOptions default doAll;
    property FromBaseSiteOnly: boolean read FFromBaseSiteOnly write FFromBaseSiteOnly default True;
    property OnMultiComplete: TOnMultiCompleteEvent read FOnMultiComplete write FOnMultiComplete;
    property OnMultiGetDocInfo: TOnMultiGetDocInfoEvent read FOnMultiGetDocInfo write FOnMultiGetDocInfo;
    property OnMultiGetImage: TOnMultiGetImageEvent read FOnMultiGetImage write FOnMultiGetImage;
    property OnMultiGetLink: TOnMultiGetLinkEvent read FOnMultiGetLink write FOnMultiGetLink;
    property OnMultiGetQueryInfo: TOnMultiGetQueryInfoEvent read FOnMultiGetQueryInfo write
      FOnMultiGetQueryInfo;
    property OnMultiStateChange: TMultiStateChangeEvent read FOnMultiStateChange write
      FOnMultiStateChange;
    property OnMultiParseError: TOnMultiParseErrorEvent read FOnMultiParseError write
      FOnMultiParseError;
    property OnMultiBeforeDownload: TOnMultiBeforeDownloadEvent read FOnMultiBeforeDownload write
      FOnMultiBeforeDownload;
  end;

implementation

uses
  IEDownloadTools;

procedure TIEMultiDownload.MultiParseComplete(Sender: TObject; Doc: IhtmlDocument2; All: IHtmlElementCollection);
var
  bCancel: Boolean;
begin
  bCancel := False;
  if Assigned(FOnMultiBeforeDownload) then
    FOnMultiBeforeDownload(Self, slAll, bCancel);
  if not bCancel then
    case FMultiDownloadOptions of
      doAll: GoList(slAll);
      doOnlyPages: GoList(slLinks);
      doOnlyImages: GoList(slImages);
    end;
  if Assigned(FOnMultiComplete) then
    FOnMultiComplete(Self, slAll);
  FMultiState := msStopped;
  if Assigned(FOnMultiStateChange) then
    FOnMultiStateChange(Self, FMultiState);
end;

procedure TIEMultiDownload.GoMulti(BaseUrl: WideString);
begin
  Reset;
  FMultiState := msBusy;
  if Assigned(FOnMultiStateChange) then
    FOnMultiStateChange(Self, FMultiState);
  UrlParser := TUrl.Create(BaseUrl);
  UrlParser.CrackUrl(BaseUrl, ICU_ESCAPE);
  FRoorUrl := UrlParser.HostName;
  with HtmlParser do
  begin
    OnAnchor := MultiAnchor;
    OnImage := MultiImage;
    OnParseComplete := MultiParseComplete;
    OnParseError := MultiParseError;
    OnDocInfo := MultiGetDocInfo;
    OnQueryInfo := MultiGetQueryInfo;
    Parse(BaseUrl);
  end;
  if UrlParser <> nil then
    FreeAndNil(UrlParser);
end;

procedure TIEMultiDownload.Stop;
begin
  if FMultiState <> msBusy then Exit;
  HtmlParser.Stop;
  CancelAll;
end;

procedure TIEMultiDownload.MultiGetDocInfo(Sender: TObject; const Text: string);
begin
  if Assigned(FOnMultiGetDocInfo) then
    FOnMultiGetDocInfo(Self, Text);
end;


procedure TIEMultiDownload.MultiParseError(Sender: TObject; const ErrorCode: integer; const
  Url, stError: string);
begin
  if Assigned(FOnMultiParseError) then
    FOnMultiParseError(Self, ErrorCode, Url, stError);
end;

procedure TIEMultiDownload.MultiGetQueryInfo(const MimeType, Encoding, Disposition: string);
begin
  if Assigned(FOnMultiGetQueryInfo) then
    FOnMultiGetQueryInfo(MimeType, Encoding, Disposition);
end;

constructor TIEMultiDownload.Create(Owner: Tcomponent);
begin
  inherited Create(Owner);
  FAbout := 'TIEMultiDownload from: http://www.bsalsa.com';
  FDownloadLevel := 1;
  FMultiDownloadOptions := doAll;
  FFromBaseSiteOnly := True;
  slLinks := TStringList.Create;
  with slLinks do
  begin
{$IFDEF DELPHI6_UP}CaseSensitive := False;{$ENDIF}
    Sorted := True;
    Duplicates := dupIgnore;
  end;
  slImages := TStringList.Create;
  with slImages do
  begin
{$IFDEF DELPHI6_UP}CaseSensitive := False;{$ENDIF}
    Sorted := True;
    Duplicates := dupIgnore;
  end;
  slAll := TStringList.Create;
  with slAll do
  begin
{$IFDEF DELPHI6_UP}CaseSensitive := False;{$ENDIF}
    Sorted := True;
    Duplicates := dupIgnore;
  end;
  FMultiState := msReady;
  HtmlParser := TIEParser.Create(nil);
end;

destructor TIEMultiDownload.Destroy;
begin
  slImages.Free;
  slLinks.Free;
  slAll.Free;
  if HtmlParser <> nil then
    FreeAndNil(HtmlParser);
  inherited Destroy;
end;

procedure TIEMultiDownload.SetAbout(Value: string);
begin
  Exit;
end;

procedure TIEMultiDownload.SetDownloadOptions(const Value: TMultiDownloadOptions);
begin
  FMultiDownloadOptions := Value;
end;

procedure TIEMultiDownload.MultiAnchor(Sender: TObject; hRef, Target, Rel, Rev, Urn,
  Methods, Name, Host, HostName, PathName, Port, Protocol, Search, Hash,
  AccessKey, ProtocolLong, MimeType, NameProp: string; Element: TElementInfo);
var
  bCancel: Boolean;
begin
  if FMultiDownloadOptions = doOnlyImages then Exit;
  bCancel := False;
  if (hRef <> EmptyStr) and (not StrContain('mailto', hRef)) then
  begin

    if FFromBaseSiteOnly and (not StrContain(FRoorUrl, hRef)) then
    begin
      Exit;
    end;
    if Assigned(FOnMultiGetLink) then
      FOnMultiGetLink(Self, hRef, Host, HostName, PathName, Port, Protocol,
        MimeType, NameProp, bCancel);
    if (not bCancel) then
    begin
      slLinks.Add(hRef);
      slAll.Add(hRef);
    end;
  end;
end;

procedure TIEMultiDownload.MultiImage(Sender: TObject; Source, LowSrc, Vrml, DynSrc,
  Alt, Align, UseMap: string; IsMap: Boolean; Border, Loop: OleVariant; vSpace,
  hSpace, Width, Height: Integer; Element: TElementInfo);
var
  bCancel: Boolean;
begin
  if FMultiDownloadOptions = doOnlyPages then Exit;
  bCancel := False;
  if Source <> '' then
  begin
    if Assigned(FOnMultiGetImage) then
      FOnMultiGetImage(Self, Source, Alt, Align, bCancel);
    if not bCancel then
    begin
      slImages.Add(Source);
       slAll.Add(Source);
    end;
  end;
end;


end.

