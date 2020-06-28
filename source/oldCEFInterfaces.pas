// ************************************************************************
// ***************************** OldCEF4Delphi ****************************
// ************************************************************************
//
// OldCEF4Delphi is based on DCEF3 which uses CEF3 to embed a chromium-based
// browser in Delphi applications.
//
// The original license of DCEF3 still applies to OldCEF4Delphi.
//
// For more information about OldCEF4Delphi visit :
//         https://www.briskbard.com/index.php?lang=en&pageid=cef
//
//        Copyright © 2019 Salvador Díaz Fau. All rights reserved.
//
// ************************************************************************
// ************ vvvv Original license and comments below vvvv *************
// ************************************************************************
(*
 *                       Delphi Chromium Embedded 3
 *
 * Usage allowed under the restrictions of the Lesser GNU General Public License
 * or alternatively the restrictions of the Mozilla Public License 1.1
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
 * the specific language governing rights and limitations under the License.
 *
 * Unit owner : Henri Gourvest <hgourvest@gmail.com>
 * Web site   : http://www.progdigy.com
 * Repository : http://code.google.com/p/delphichromiumembedded/
 * Group      : http://groups.google.com/group/delphichromiumembedded
 *
 * Embarcadero Technologies, Inc is not permitted to use or redistribute
 * this source code without explicit permission.
 *
 *)

unit oldCEFInterfaces;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
  {$IFDEF MSWINDOWS}WinApi.Windows,{$ENDIF} System.Classes,
  {$ELSE}
  Windows, Classes,
  {$ENDIF}
  oldCEFTypes;

type
  IOldCefBrowser = interface;
  IOldCefFrame = interface;
  IOldCefRequest = interface;
  IOldCefv8Value = interface;
  IOldCefV8Exception = interface;
  IOldCefV8StackTrace = interface;
  IOldCefDomVisitor = interface;
  IOldCefDomDocument = interface;
  IOldCefDomNode = interface;
  IOldCefv8Context = interface;
  IOldCefListValue = interface;
  IOldCefBinaryValue = interface;
  IOldCefDictionaryValue = interface;
  IOldCefClient = interface;
  IOldCefUrlrequestClient = interface;
  IOldCefBrowserHost = interface;
  IOldCefTask = interface;
  IOldCefTaskRunner = interface;
  IOldCefFileDialogCallback = interface;
  IOldCefPrintHandler = interface;
  IOldCefPrintDialogCallback = interface;
  IOldCefPrintJobCallback = interface;
  IOldCefRequestContext = interface;
  IOldCefAccessibilityHandler = interface;
  IOldCefDragData = interface;
  IOldCefNavigationEntry = interface;
  IOldCefSslInfo = interface;
  IOldChromiumEvents = interface;
  IOldCefCommandLine = interface;
  IOldCefRequestHandler = interface;
  IOldCefResourceBundleHandler = interface;
  IOldCefBrowserProcessHandler = interface;
  IOldCefRenderProcessHandler = interface;
  IOldCefProcessMessage = interface;
  IOldCefLifeSpanHandler = interface;
  IOldCefStreamReader = interface;
  IOldCefLoadHandler = interface;
  IOldCefContextMenuParams = interface;
  IOldCefMenuModel = interface;
  IOldCefRunContextMenuCallback = interface;
  IOldCefDownloadItem = interface;
  IOldCefBeforeDownloadCallback = interface;
  IOldCefJsDialogCallback = interface;
  IOldCefDownloadItemCallback = interface;
  IOldCefRequestCallback = interface;
  IOldCefResourceHandler = interface;
  IOldCefResponse = interface;
  IOldCefResponseFilter = interface;
  IOldCefAuthCallback = interface;
  IOldCefCallback = interface;
  IOldCefDragHandler = interface;
  IOldCefFindHandler = interface;
  IOldCefGeolocationCallback = interface;
  IOldCefGeolocationHandler = interface;
  IOldCefSchemeRegistrar = interface;
  IOldCefUrlRequest = interface;

  TOldCefv8ValueArray = array of IOldCefv8Value;
  TOldCefBinaryValueArray = array of IOldCefBinaryValue;
  TOldCefFrameIdentifierArray = array of int64;



  // *******************************************
  // ***************** Events ******************
  // *******************************************


  TOnRegisterCustomSchemes           = {$IFDEF DELPHI12_UP}reference to{$ENDIF} procedure(const registrar: IOldCefSchemeRegistrar) {$IFNDEF DELPHI12_UP}of object{$ENDIF};
  TOnRenderThreadCreatedEvent        = {$IFDEF DELPHI12_UP}reference to{$ENDIF} procedure(const extraInfo: IOldCefListValue) {$IFNDEF DELPHI12_UP}of object{$ENDIF};
  TOnWebKitInitializedEvent          = {$IFDEF DELPHI12_UP}reference to{$ENDIF} procedure() {$IFNDEF DELPHI12_UP}of object{$ENDIF};
  TOnBrowserCreatedEvent             = {$IFDEF DELPHI12_UP}reference to{$ENDIF} procedure(const browser: IOldCefBrowser) {$IFNDEF DELPHI12_UP}of object{$ENDIF};
  TOnBrowserDestroyedEvent           = {$IFDEF DELPHI12_UP}reference to{$ENDIF} procedure(const browser: IOldCefBrowser) {$IFNDEF DELPHI12_UP}of object{$ENDIF};
  TOnBeforeNavigationEvent           = {$IFDEF DELPHI12_UP}reference to{$ENDIF} procedure(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; navigationType: TOldCefNavigationType; isRedirect: Boolean; var aStopNavigation : boolean) {$IFNDEF DELPHI12_UP}of object{$ENDIF};
  TOnContextCreatedEvent             = {$IFDEF DELPHI12_UP}reference to{$ENDIF} procedure(const browser: IOldCefBrowser; const frame: IOldCefFrame; const context: IOldCefv8Context) {$IFNDEF DELPHI12_UP}of object{$ENDIF};
  TOnContextReleasedEvent            = {$IFDEF DELPHI12_UP}reference to{$ENDIF} procedure(const browser: IOldCefBrowser; const frame: IOldCefFrame; const context: IOldCefv8Context) {$IFNDEF DELPHI12_UP}of object{$ENDIF};
  TOnUncaughtExceptionEvent          = {$IFDEF DELPHI12_UP}reference to{$ENDIF} procedure(const browser: IOldCefBrowser; const frame: IOldCefFrame; const context: IOldCefv8Context; const exception: IOldCefV8Exception; const stackTrace: IOldCefV8StackTrace) {$IFNDEF DELPHI12_UP}of object{$ENDIF};
  TOnFocusedNodeChangedEvent         = {$IFDEF DELPHI12_UP}reference to{$ENDIF} procedure(const browser: IOldCefBrowser; const frame: IOldCefFrame; const node: IOldCefDomNode) {$IFNDEF DELPHI12_UP}of object{$ENDIF};
  TOnProcessMessageReceivedEvent     = {$IFDEF DELPHI12_UP}reference to{$ENDIF} procedure(const browser: IOldCefBrowser; sourceProcess: TOldCefProcessId; const message: IOldCefProcessMessage; var aHandled : boolean) {$IFNDEF DELPHI12_UP}of object{$ENDIF};
  TOnContextInitializedEvent         = {$IFDEF DELPHI12_UP}reference to{$ENDIF} procedure() {$IFNDEF DELPHI12_UP}of object{$ENDIF};
  TOnBeforeChildProcessLaunchEvent   = {$IFDEF DELPHI12_UP}reference to{$ENDIF} procedure(const commandLine: IOldCefCommandLine) {$IFNDEF DELPHI12_UP}of object{$ENDIF};
  TOnRenderProcessThreadCreatedEvent = {$IFDEF DELPHI12_UP}reference to{$ENDIF} procedure(const extraInfo: IOldCefListValue) {$IFNDEF DELPHI12_UP}of object{$ENDIF};
  TOnGetDataResourceEvent            = {$IFDEF DELPHI12_UP}reference to{$ENDIF} procedure(resourceId: Integer; out data: Pointer; out dataSize: NativeUInt; var aResult : Boolean) {$IFNDEF DELPHI12_UP}of object{$ENDIF};
  TOnGetLocalizedStringEvent         = {$IFDEF DELPHI12_UP}reference to{$ENDIF} procedure(stringId: Integer; out stringVal: oldustring; var aResult : Boolean) {$IFNDEF DELPHI12_UP}of object{$ENDIF};
  TOnGetDataResourceForScaleEvent    = {$IFDEF DELPHI12_UP}reference to{$ENDIF} procedure(resourceId: Integer; scaleFactor: TOldCefScaleFactor; out data: Pointer; out dataSize: NativeUInt; var aResult : Boolean) {$IFNDEF DELPHI12_UP}of object{$ENDIF};
  TOnRenderLoadStart                 = {$IFDEF DELPHI12_UP}reference to{$ENDIF} procedure(const browser: IOldCefBrowser; const frame: IOldCefFrame) {$IFNDEF DELPHI12_UP}of object{$ENDIF};
  TOnRenderLoadEnd                   = {$IFDEF DELPHI12_UP}reference to{$ENDIF} procedure(const browser: IOldCefBrowser; const frame: IOldCefFrame; httpStatusCode: Integer) {$IFNDEF DELPHI12_UP}of object{$ENDIF};
  TOnRenderLoadError                 = {$IFDEF DELPHI12_UP}reference to{$ENDIF} procedure(const browser: IOldCefBrowser; const frame: IOldCefFrame; errorCode: TOldCefErrorCode; const errorText, failedUrl: oldustring) {$IFNDEF DELPHI12_UP}of object{$ENDIF};
  TOnRenderLoadingStateChange        = {$IFDEF DELPHI12_UP}reference to{$ENDIF} procedure(const browser: IOldCefBrowser; isLoading, canGoBack, canGoForward: Boolean) {$IFNDEF DELPHI12_UP}of object{$ENDIF};



  // *******************************************
  // **** Callback procedures and functions ****
  // *******************************************



  TOnPdfPrintFinishedProc            = {$IFDEF DELPHI12_UP}reference to{$ENDIF} procedure(const path: oldustring; ok: Boolean);

  TOldCefDomVisitorProc                 = {$IFDEF DELPHI12_UP}reference to{$ENDIF} procedure(const document: IOldCefDomDocument);
  TOldCefDomVisitorProc2                = {$IFDEF DELPHI12_UP}reference to{$ENDIF} procedure(const browser : IOldCefBrowser; const document: IOldCefDomDocument);
  TOldCefStringVisitorProc              = {$IFDEF DELPHI12_UP}reference to{$ENDIF} procedure(const str: oldustring);

  TOldCefRunFileDialogCallbackProc      = {$IFDEF DELPHI12_UP}reference to{$ENDIF} procedure(selectedAcceptFilter: Integer; const filePaths: TStrings);

  TOldCefCompletionCallbackProc         = {$IFDEF DELPHI12_UP}reference to{$ENDIF} procedure;
  TOldCefSetCookieCallbackProc          = {$IFDEF DELPHI12_UP}reference to{$ENDIF} procedure(success: Boolean);
  TOldCefDeleteCookiesCallbackProc      = {$IFDEF DELPHI12_UP}reference to{$ENDIF} procedure(numDeleted: Integer);
  TOldCefNavigationEntryVisitorProc     = {$IFDEF DELPHI12_UP}reference to{$ENDIF} function(const entry: IOldCefNavigationEntry; current: Boolean; index, total: Integer): Boolean;
  TOldCefCookieVisitorProc              = {$IFDEF DELPHI12_UP}reference to{$ENDIF} function(const name, value, domain, path: oldustring; secure, httponly, hasExpires: Boolean; const creation, lastAccess, expires: TDateTime; count, total: Integer; out deleteCookie: Boolean): Boolean;



  // *******************************************
  // ************ Custom interfaces ************
  // *******************************************


  IOldCefStringList = interface
    ['{DB24F301-2F64-48D6-A72E-33697748147E}']
    function  GetHandle: TOldCefStringList;
    function  GetSize: Integer;
    function  GetValue(Index: Integer): oldustring;
    procedure Append(const Value: oldustring);
    procedure Clear;
    function  Copy : TOldCefStringList;
    procedure CopyToStrings(const aStrings : TStrings);
    procedure AddStrings(const aStrings : TStrings);

    property Handle                   : TOldCefStringList read GetHandle;
    property Size                     : Integer        read GetSize;
    property Value[index: Integer]    : oldustring        read GetValue;
  end;

  IOldCefStringMap = interface
    ['{A33EBC01-B23A-4918-86A4-E24A243B342F}']
    function  GetHandle: TOldCefStringMap;
    function  GetSize: Integer;
    function  Find(const Key: oldustring): oldustring;
    function  GetKey(Index: Integer): oldustring;
    function  GetValue(Index: Integer): oldustring;
    function  Append(const Key, Value: oldustring) : boolean;
    procedure Clear;

    property Handle                   : TOldCefStringMap read GetHandle;
    property Size                     : Integer       read GetSize;
    property Key[index: Integer]      : oldustring       read GetKey;
    property Value[index: Integer]    : oldustring       read GetValue;
  end;

  IOldCefStringMultimap = interface
    ['{583ED0C2-A9D6-4034-A7C9-20EC7E47F0C7}']
    function  GetHandle: TOldCefStringMultimap;
    function  GetSize: Integer;
    function  FindCount(const Key: oldustring): Integer;
    function  GetEnumerate(const Key: oldustring; ValueIndex: Integer): oldustring;
    function  GetKey(Index: Integer): oldustring;
    function  GetValue(Index: Integer): oldustring;
    function  Append(const Key, Value: oldustring) : boolean;
    procedure Clear;

    property Handle                                                : TOldCefStringMultimap read GetHandle;
    property Size                                                  : Integer            read GetSize;
    property Key[index: Integer]                                   : oldustring            read GetKey;
    property Value[index: Integer]                                 : oldustring            read GetValue;
    property Enumerate[const Key: oldustring; ValueIndex: Integer]    : oldustring            read GetEnumerate;
  end;

  IOldChromiumEvents = interface
    ['{0C139DB1-0349-4D7F-8155-76FEA6A0126D}']
    procedure GetSettings(var settings: TOldCefBrowserSettings);

    // IOldCefClient
    function  doOnProcessMessageReceived(const browser: IOldCefBrowser; sourceProcess: TOldCefProcessId; const message: IOldCefProcessMessage): Boolean;

    // IOldCefLoadHandler
    procedure doOnLoadingStateChange(const browser: IOldCefBrowser; isLoading, canGoBack, canGoForward: Boolean);
    procedure doOnLoadStart(const browser: IOldCefBrowser; const frame: IOldCefFrame);
    procedure doOnLoadEnd(const browser: IOldCefBrowser; const frame: IOldCefFrame; httpStatusCode: Integer);
    procedure doOnLoadError(const browser: IOldCefBrowser; const frame: IOldCefFrame; errorCode: TOldCefErrorCode; const errorText, failedUrl: oldustring);

    // IOldCefFocusHandler
    procedure doOnTakeFocus(const browser: IOldCefBrowser; next: Boolean);
    function  doOnSetFocus(const browser: IOldCefBrowser; source: TOldCefFocusSource): Boolean;
    procedure doOnGotFocus(const browser: IOldCefBrowser);

    // IOldCefContextMenuHandler
    procedure doOnBeforeContextMenu(const browser: IOldCefBrowser; const frame: IOldCefFrame; const params: IOldCefContextMenuParams; const model: IOldCefMenuModel);
    function  doRunContextMenu(const browser: IOldCefBrowser; const frame: IOldCefFrame; const params: IOldCefContextMenuParams; const model: IOldCefMenuModel; const callback: IOldCefRunContextMenuCallback): Boolean;
    function  doOnContextMenuCommand(const browser: IOldCefBrowser; const frame: IOldCefFrame; const params: IOldCefContextMenuParams; commandId: Integer; eventFlags: TOldCefEventFlags): Boolean;
    procedure doOnContextMenuDismissed(const browser: IOldCefBrowser; const frame: IOldCefFrame);

    // IOldCefKeyboardHandler
    function  doOnPreKeyEvent(const browser: IOldCefBrowser; const event: POldCefKeyEvent; osEvent: TOldCefEventHandle; out isKeyboardShortcut: Boolean): Boolean;
    function  doOnKeyEvent(const browser: IOldCefBrowser; const event: POldCefKeyEvent; osEvent: TOldCefEventHandle): Boolean;

    // IOldCefDisplayHandler
    procedure doOnAddressChange(const browser: IOldCefBrowser; const frame: IOldCefFrame; const url: oldustring);
    procedure doOnTitleChange(const browser: IOldCefBrowser; const title: oldustring);
    procedure doOnFaviconUrlChange(const browser: IOldCefBrowser; const iconUrls: TStrings);
    procedure doOnFullScreenModeChange(const browser: IOldCefBrowser; fullscreen: Boolean);
    function  doOnTooltip(const browser: IOldCefBrowser; var text: oldustring): Boolean;
    procedure doOnStatusMessage(const browser: IOldCefBrowser; const value: oldustring);
    function  doOnConsoleMessage(const browser: IOldCefBrowser; const message, source: oldustring; line: Integer): Boolean;

    // IOldCefDownloadHandler
    procedure doOnBeforeDownload(const browser: IOldCefBrowser; const downloadItem: IOldCefDownloadItem; const suggestedName: oldustring; const callback: IOldCefBeforeDownloadCallback);
    procedure doOnDownloadUpdated(const browser: IOldCefBrowser; const downloadItem: IOldCefDownloadItem; const callback: IOldCefDownloadItemCallback);

    // IOldCefGeolocationHandler
    function  doOnRequestGeolocationPermission(const browser: IOldCefBrowser; const requestingUrl: oldustring; requestId: Integer; const callback: IOldCefGeolocationCallback): Boolean;
    procedure doOnCancelGeolocationPermission(const browser: IOldCefBrowser; requestId: Integer);

    // IOldCefJsDialogHandler
    function  doOnJsdialog(const browser: IOldCefBrowser; const originUrl, accept_lang: oldustring; dialogType: TOldCefJsDialogType; const messageText, defaultPromptText: oldustring; const callback: IOldCefJsDialogCallback; out suppressMessage: Boolean): Boolean;
    function  doOnBeforeUnloadDialog(const browser: IOldCefBrowser; const messageText: oldustring; isReload: Boolean; const callback: IOldCefJsDialogCallback): Boolean;
    procedure doOnResetDialogState(const browser: IOldCefBrowser);
    procedure doOnDialogClosed(const browser: IOldCefBrowser);

    // IOldCefLifeSpanHandler
    function  doOnBeforePopup(const browser: IOldCefBrowser; const frame: IOldCefFrame; const targetUrl, targetFrameName: oldustring; targetDisposition: TOldCefWindowOpenDisposition; userGesture: Boolean; const popupFeatures: TOldCefPopupFeatures; var windowInfo: TOldCefWindowInfo; var client: IOldCefClient; var settings: TOldCefBrowserSettings; var noJavascriptAccess: Boolean): Boolean;
    procedure doOnAfterCreated(const browser: IOldCefBrowser);
    function  doRunModal(const browser: IOldCefBrowser): Boolean;
    procedure doOnBeforeClose(const browser: IOldCefBrowser);
    function  doOnClose(const browser: IOldCefBrowser): Boolean;

    // IOldCefRequestHandler
    function  doOnBeforeBrowse(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; isRedirect: Boolean): Boolean;
    function  doOnOpenUrlFromTab(const browser: IOldCefBrowser; const frame: IOldCefFrame; const targetUrl: oldustring; targetDisposition: TOldCefWindowOpenDisposition; userGesture: Boolean): Boolean;
    function  doOnBeforeResourceLoad(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; const callback: IOldCefRequestCallback): TOldCefReturnValue;
    function  doOnGetResourceHandler(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest): IOldCefResourceHandler;
    procedure doOnResourceRedirect(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; var newUrl: oldustring);
    function  doOnResourceResponse(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; const response: IOldCefResponse): Boolean;
    function  doOnGetResourceResponseFilter(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; const response: IOldCefResponse): IOldCefResponseFilter;
    procedure doOnResourceLoadComplete(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; const response: IOldCefResponse; status: TOldCefUrlRequestStatus; receivedContentLength: Int64);
    function  doOnGetAuthCredentials(const browser: IOldCefBrowser; const frame: IOldCefFrame; isProxy: Boolean; const host: oldustring; port: Integer; const realm, scheme: oldustring; const callback: IOldCefAuthCallback): Boolean;
    function  doOnQuotaRequest(const browser: IOldCefBrowser; const originUrl: oldustring; newSize: Int64; const callback: IOldCefRequestCallback): Boolean;
    procedure doOnProtocolExecution(const browser: IOldCefBrowser; const url: oldustring; out allowOsExecution: Boolean);
    function  doOnCertificateError(const browser: IOldCefBrowser; certError: TOldCefErrorcode; const requestUrl: oldustring; const sslInfo: IOldCefSslInfo; const callback: IOldCefRequestCallback): Boolean;
    procedure doOnPluginCrashed(const browser: IOldCefBrowser; const pluginPath: oldustring);
    procedure doOnRenderViewReady(const browser: IOldCefBrowser);
    procedure doOnRenderProcessTerminated(const browser: IOldCefBrowser; status: TOldCefTerminationStatus);

    // IOldCefDialogHandler
    function  doOnFileDialog(const browser: IOldCefBrowser; mode: TOldCefFileDialogMode; const title, defaultFilePath: oldustring; const acceptFilters: TStrings; selectedAcceptFilter: Integer; const callback: IOldCefFileDialogCallback): Boolean;

    // IOldCefRenderHandler
    function  doOnGetRootScreenRect(const browser: IOldCefBrowser; var rect: TOldCefRect): Boolean;
    function  doOnGetViewRect(const browser: IOldCefBrowser; var rect: TOldCefRect): Boolean;
    function  doOnGetScreenPoint(const browser: IOldCefBrowser; viewX, viewY: Integer; var screenX, screenY: Integer): Boolean;
    function  doOnGetScreenInfo(const browser: IOldCefBrowser; var screenInfo: TOldCefScreenInfo): Boolean;
    procedure doOnPopupShow(const browser: IOldCefBrowser; show: Boolean);
    procedure doOnPopupSize(const browser: IOldCefBrowser; const rect: POldCefRect);
    procedure doOnPaint(const browser: IOldCefBrowser; kind: TOldCefPaintElementType; dirtyRectsCount: NativeUInt; const dirtyRects: POldCefRectArray; const buffer: Pointer; width, height: Integer);
    procedure doOnCursorChange(const browser: IOldCefBrowser; cursor: TOldCefCursorHandle; cursorType: TOldCefCursorType; const customCursorInfo: POldCefCursorInfo);
    function  doOnStartDragging(const browser: IOldCefBrowser; const dragData: IOldCefDragData; allowedOps: TOldCefDragOperations; x, y: Integer): Boolean;
    procedure doOnUpdateDragCursor(const browser: IOldCefBrowser; operation: TOldCefDragOperation);
    procedure doOnScrollOffsetChanged(const browser: IOldCefBrowser; x, y: Double);

    // IOldCefDragHandler
    function  doOnDragEnter(const browser: IOldCefBrowser; const dragData: IOldCefDragData; mask: TOldCefDragOperations): Boolean;
    procedure doOnDraggableRegionsChanged(const browser: IOldCefBrowser; regionsCount: NativeUInt; regions: POldCefDraggableRegionArray);

    // IOldCefFindHandler
    procedure doOnFindResult(const browser: IOldCefBrowser; identifier, count: Integer; const selectionRect: POldCefRect; activeMatchOrdinal: Integer; finalUpdate: Boolean);

    // Custom
    procedure doCookiesDeleted(numDeleted : integer);
    procedure doPdfPrintFinished(aResultOK : boolean);
    procedure doTextResultAvailable(const aText : string);
    procedure doUpdatePreferences(const aBrowser: IOldCefBrowser);
    procedure doUpdateOwnPreferences;
    function  doSavePreferences : boolean;
    procedure doResolvedHostAvailable(result: TOldCefErrorCode; const resolvedIps: TStrings);
  end;

  IOldCEFUrlRequestClientEvents = interface
    ['{1AA800A7-56A1-43CA-A224-49368F18BDD8}']
    // IOldCefUrlrequestClient
    procedure doOnRequestComplete(const request: IOldCefUrlRequest);
    procedure doOnUploadProgress(const request: IOldCefUrlRequest; current, total: Int64);
    procedure doOnDownloadProgress(const request: IOldCefUrlRequest; current, total: Int64);
    procedure doOnDownloadData(const request: IOldCefUrlRequest; data: Pointer; dataLength: NativeUInt);
    function  doOnGetAuthCredentials(isProxy: Boolean; const host: oldustring; port: Integer; const realm, scheme: oldustring; const callback: IOldCefAuthCallback): Boolean;

    // Custom
    procedure doOnCreateURLRequest;
  end;



  // *******************************************
  // ************** CEF interfaces *************
  // *******************************************


  // TOldCefBase
  // /include/capi/cef_base_capi.h (cef_base_t)
  IOldCefBase = interface
    ['{1F9A7B44-DCDC-4477-9180-3ADD44BDEB7B}']
    function Wrap: Pointer;
    function SameAs(aData : Pointer) : boolean;
  end;

  // TOldCefRunFileDialogCallback
  // /include/capi/cef_browser_capi.h (cef_run_file_dialog_callback_t)
  IOldCefRunFileDialogCallback = interface(IOldCefBase)
    ['{59FCECC6-E897-45BA-873B-F09586C4BE47}']
    procedure OnFileDialogDismissed(selectedAcceptFilter: Integer; const filePaths: TStrings);
  end;

  // TOldCefNavigationEntryVisitor
  // /include/capi/cef_browser_capi.h (cef_navigation_entry_visitor_t)
  IOldCefNavigationEntryVisitor = interface(IOldCefBase)
    ['{CC4D6BC9-0168-4C2C-98BA-45E9AA9CD619}']
    function Visit(const entry: IOldCefNavigationEntry; current: Boolean; index, total: Integer): Boolean;
  end;

  // TOldCefPdfPrintCallback
  // /include/capi/cef_browser_capi.h (cef_pdf_print_callback_t)
  IOldCefPdfPrintCallback = interface(IOldCefBase)
    ['{F1CC58E9-2C30-4932-91AE-467C8D8EFB8E}']
    procedure OnPdfPrintFinished(const path: oldustring; ok: Boolean);
  end;

  // TOldCefBrowserHost
  // /include/capi/cef_browser_capi.h (cef_browser_host_t)
  IOldCefBrowserHost = interface(IOldCefBase)
    ['{53AE02FF-EF5D-48C3-A43E-069DA9535424}']
    function  GetBrowser: IOldCefBrowser;
    procedure CloseBrowser(forceClose: Boolean);
    procedure SetFocus(focus: Boolean);
    procedure SetWindowVisibility(visible: Boolean);
    function  GetWindowHandle: TOldCefWindowHandle;
    function  GetOpenerWindowHandle: TOldCefWindowHandle;
    function  GetRequestContext: IOldCefRequestContext;
    function  GetZoomLevel: Double;
    procedure SetZoomLevel(const zoomLevel: Double);
    procedure RunFileDialog(mode: TOldCefFileDialogMode; const title, defaultFilePath: oldustring; const acceptFilters: TStrings; selectedAcceptFilter: Integer; const callback: IOldCefRunFileDialogCallback);
    procedure RunFileDialogProc(mode: TOldCefFileDialogMode; const title, defaultFilePath: oldustring; const acceptFilters: TStrings; selectedAcceptFilter: Integer; const callback: TOldCefRunFileDialogCallbackProc);
    procedure StartDownload(const url: oldustring);
    procedure Print;
    procedure PrintToPdf(const path: oldustring; settings: POldCefPdfPrintSettings; const callback: IOldCefPdfPrintCallback);
    procedure PrintToPdfProc(const path: oldustring; settings: POldCefPdfPrintSettings; const callback: TOnPdfPrintFinishedProc);
    procedure Find(identifier: Integer; const searchText: oldustring; forward, matchCase, findNext: Boolean);
    procedure StopFinding(clearSelection: Boolean);
    procedure ShowDevTools(const windowInfo: POldCefWindowInfo; const client: IOldCefClient; const settings: POldCefBrowserSettings; inspectElementAt: POldCefPoint);
    procedure CloseDevTools;
    procedure GetNavigationEntries(const visitor: IOldCefNavigationEntryVisitor; currentOnly: Boolean);
    procedure GetNavigationEntriesProc(const proc: TOldCefNavigationEntryVisitorProc; currentOnly: Boolean);
    procedure SetMouseCursorChangeDisabled(disabled: Boolean);
    function  IsMouseCursorChangeDisabled: Boolean;
    procedure ReplaceMisspelling(const word: oldustring);
    procedure AddWordToDictionary(const word: oldustring);
    function  IsWindowRenderingDisabled: Boolean;
    procedure WasResized;
    procedure WasHidden(hidden: Boolean);
    procedure NotifyScreenInfoChanged;
    procedure Invalidate(kind: TOldCefPaintElementType);
    procedure SendKeyEvent(const event: POldCefKeyEvent);
    procedure SendMouseClickEvent(const event: POldCefMouseEvent; kind: TOldCefMouseButtonType; mouseUp: Boolean; clickCount: Integer);
    procedure SendMouseMoveEvent(const event: POldCefMouseEvent; mouseLeave: Boolean);
    procedure SendMouseWheelEvent(const event: POldCefMouseEvent; deltaX, deltaY: Integer);
    procedure SendFocusEvent(setFocus: Boolean);
    procedure SendCaptureLostEvent;
    procedure NotifyMoveOrResizeStarted;
    function  GetWindowlessFrameRate : Integer;
    procedure SetWindowlessFrameRate(frameRate: Integer);
    function  GetNsTextInputContext: TOldCefTextInputContext;
    procedure HandleKeyEventBeforeTextInputClient(keyEvent: TOldCefEventHandle);
    procedure HandleKeyEventAfterTextInputClient(keyEvent: TOldCefEventHandle);
    procedure DragTargetDragEnter(const dragData: IOldCefDragData; const event: POldCefMouseEvent; allowedOps: TOldCefDragOperations);
    procedure DragTargetDragOver(const event: POldCefMouseEvent; allowedOps: TOldCefDragOperations);
    procedure DragTargetDragLeave;
    procedure DragTargetDrop(event: POldCefMouseEvent);
    procedure DragSourceEndedAt(x, y: Integer; op: TOldCefDragOperation);
    procedure DragSourceSystemDragEnded;

    property Browser                : IOldCefBrowser              read GetBrowser;
    property WindowHandle           : TOldCefWindowHandle         read GetWindowHandle;
    property OpenerWindowHandle     : TOldCefWindowHandle         read GetOpenerWindowHandle;
    property ZoomLevel              : Double                   read GetZoomLevel               write SetZoomLevel;
    property RequestContext         : IOldCefRequestContext       read GetRequestContext;
  end;

  // TOldCefProcessMessage
  // /include/capi/cef_process_message_capi.h (cef_process_message_t)
  IOldCefProcessMessage = interface(IOldCefBase)
    ['{E0B1001A-8777-425A-869B-29D40B8B93B1}']
    function IsValid: Boolean;
    function IsReadOnly: Boolean;
    function Copy: IOldCefProcessMessage;
    function GetName: oldustring;
    function GetArgumentList: IOldCefListValue;
    property Name: oldustring read GetName;
    property ArgumentList: IOldCefListValue read GetArgumentList;
  end;

  // TOldCefBrowser
  // /include/capi/cef_browser_capi.h (cef_browser_t)
  IOldCefBrowser = interface(IOldCefBase)
    ['{BA003C2E-CF15-458F-9D4A-FE3CEFCF3EEF}']
    function  GetHost: IOldCefBrowserHost;
    function  CanGoBack: Boolean;
    procedure GoBack;
    function  CanGoForward: Boolean;
    procedure GoForward;
    function  IsLoading: Boolean;
    procedure Reload;
    procedure ReloadIgnoreCache;
    procedure StopLoad;
    function  GetIdentifier: Integer;
    function  IsSame(const that: IOldCefBrowser): Boolean;
    function  IsPopup: Boolean;
    function  HasDocument: Boolean;
    function  GetMainFrame: IOldCefFrame;
    function  GetFocusedFrame: IOldCefFrame;
    function  GetFrameByident(const identifier: Int64): IOldCefFrame;
    function  GetFrame(const name: oldustring): IOldCefFrame;
    function  GetFrameCount: NativeUInt;
    function  GetFrameIdentifiers(var aFrameCount : NativeUInt; var aFrameIdentifierArray : TOldCefFrameIdentifierArray) : boolean;
    function  GetFrameNames(var aFrameNames : TStrings) : boolean;
    function  SendProcessMessage(targetProcess: TOldCefProcessId; const ProcMessage: IOldCefProcessMessage): Boolean;

    property MainFrame    : IOldCefFrame       read GetMainFrame;
    property FocusedFrame : IOldCefFrame       read GetFocusedFrame;
    property FrameCount   : NativeUInt      read GetFrameCount;
    property Host         : IOldCefBrowserHost read GetHost;
    property Identifier   : Integer         read GetIdentifier;
  end;

  // TOldCefPostDataElement
  // /include/capi/cef_request_capi.h (cef_post_data_element_t)
  IOldCefPostDataElement = interface(IOldCefBase)
    ['{3353D1B8-0300-4ADC-8D74-4FF31C77D13C}']
    function  IsReadOnly: Boolean;
    procedure SetToEmpty;
    procedure SetToFile(const fileName: oldustring);
    procedure SetToBytes(size: NativeUInt; const bytes: Pointer);
    function  GetType: TOldCefPostDataElementType;
    function  GetFile: oldustring;
    function  GetBytesCount: NativeUInt;
    function  GetBytes(size: NativeUInt; bytes: Pointer): NativeUInt;
  end;

  // TOldCefPostData
  // /include/capi/cef_request_capi.h (cef_post_data_t)
  IOldCefPostData = interface(IOldCefBase)
    ['{1E677630-9339-4732-BB99-D6FE4DE4AEC0}']
    function  IsReadOnly: Boolean;
    function  HasExcludedElements: Boolean;
    function  GetCount: NativeUInt;
    function  GetElements(Count: NativeUInt): IInterfaceList; // list of IOldCefPostDataElement
    function  RemoveElement(const element: IOldCefPostDataElement): Integer;
    function  AddElement(const element: IOldCefPostDataElement): Integer;
    procedure RemoveElements;
  end;

  // TOldCefRequest
  // /include/capi/cef_request_capi.h (cef_request_t)
  IOldCefRequest = interface(IOldCefBase)
    ['{FB4718D3-7D13-4979-9F4C-D7F6C0EC592A}']
    function  IsReadOnly: Boolean;
    function  GetUrl: oldustring;
    function  GetMethod: oldustring;
    function  GetPostData: IOldCefPostData;
    procedure GetHeaderMap(const HeaderMap: IOldCefStringMultimap);
    procedure SetUrl(const value: oldustring);
    procedure SetMethod(const value: oldustring);
    procedure SetReferrer(const referrerUrl: oldustring; policy: TOldCefReferrerPolicy);
    function  GetReferrerUrl: oldustring;
    function  GetReferrerPolicy: TOldCefReferrerPolicy;
    procedure SetPostData(const value: IOldCefPostData);
    procedure SetHeaderMap(const HeaderMap: IOldCefStringMultimap);
    function  GetFlags: TOldCefUrlRequestFlags;
    procedure SetFlags(flags: TOldCefUrlRequestFlags);
    function  GetFirstPartyForCookies: oldustring;
    procedure SetFirstPartyForCookies(const url: oldustring);
    procedure Assign(const url, method: oldustring; const postData: IOldCefPostData; const headerMap: IOldCefStringMultimap);
    function  GetResourceType: TOldCefResourceType;
    function  GetTransitionType: TOldCefTransitionType;
    function  GetIdentifier: UInt64;

    property Url                  : oldustring               read GetUrl                    write SetUrl;
    property Method               : oldustring               read GetMethod                 write SetMethod;
    property ReferrerUrl          : oldustring               read GetReferrerUrl;
    property ReferrerPolicy       : TOldCefReferrerPolicy    read GetReferrerPolicy;
    property PostData             : IOldCefPostData          read GetPostData               write SetPostData;
    property Flags                : TOldCefUrlRequestFlags   read GetFlags                  write SetFlags;
    property FirstPartyForCookies : oldustring               read GetFirstPartyForCookies   write SetFirstPartyForCookies;
    property ResourceType         : TOldCefResourceType      read GetResourceType;
    property TransitionType       : TOldCefTransitionType    read GetTransitionType;
    property Identifier           : UInt64                read GetIdentifier;
  end;

  // TOldCefStringVisitor
  // /include/capi/cef_string_visitor_capi.h (cef_string_visitor_t)
  IOldCefStringVisitor = interface(IOldCefBase)
    ['{63ED4D6C-2FC8-4537-964B-B84C008F6158}']
    procedure Visit(const str: oldustring);
  end;

  // TOldCefFrame
  // /include/capi/cef_frame_capi.h (cef_frame_t)
  IOldCefFrame = interface(IOldCefBase)
    ['{8FD3D3A6-EA3A-4A72-8501-0276BD5C3D1D}']
    function  IsValid: Boolean;
    procedure Undo;
    procedure Redo;
    procedure Cut;
    procedure Copy;
    procedure Paste;
    procedure Del;
    procedure SelectAll;
    procedure ViewSource;
    procedure GetSource(const visitor: IOldCefStringVisitor);
    procedure GetSourceProc(const proc: TOldCefStringVisitorProc);
    procedure GetText(const visitor: IOldCefStringVisitor);
    procedure GetTextProc(const proc: TOldCefStringVisitorProc);
    procedure LoadRequest(const request: IOldCefRequest);
    procedure LoadUrl(const url: oldustring);
    procedure LoadString(const str, url: oldustring);
    procedure ExecuteJavaScript(const code, scriptUrl: oldustring; startLine: Integer);
    function  IsMain: Boolean;
    function  IsFocused: Boolean;
    function  GetName: oldustring;
    function  GetIdentifier: Int64;
    function  GetParent: IOldCefFrame;
    function  GetUrl: oldustring;
    function  GetBrowser: IOldCefBrowser;
    function  GetV8Context: IOldCefv8Context;
    procedure VisitDom(const visitor: IOldCefDomVisitor);
    procedure VisitDomProc(const proc: TOldCefDomVisitorProc);

    property Name       : oldustring     read GetName;
    property Url        : oldustring     read GetUrl;
    property Browser    : IOldCefBrowser read GetBrowser;
    property Parent     : IOldCefFrame   read GetParent;
    property Identifier : int64       read GetIdentifier;
  end;

  // TOldCefStreamReader
  // /include/capi/cef_stream_capi.h (cef_stream_reader_t)
  IOldCefCustomStreamReader = interface(IOldCefBase)
    ['{BBCFF23A-6FE7-4C28-B13E-6D2ACA5C83B7}']
    function Read(ptr: Pointer; size, n: NativeUInt): NativeUInt;
    function Seek(offset: Int64; whence: Integer): Integer;
    function Tell: Int64;
    function Eof: Boolean;
    function MayBlock: Boolean;
  end;

  // TOldCefStreamReader
  // /include/capi/cef_stream_capi.h (cef_stream_reader_t)
  IOldCefStreamReader = interface(IOldCefBase)
    ['{DD5361CB-E558-49C5-A4BD-D1CE84ADB277}']
    function Read(ptr: Pointer; size, n: NativeUInt): NativeUInt;
    function Seek(offset: Int64; whence: Integer): Integer;
    function Tell: Int64;
    function Eof: Boolean;
    function MayBlock: Boolean;
  end;

  // TOldCefWriteHandler
  // /include/capi/cef_stream_capi.h (cef_write_handler_t)
  IOldCefWriteHandler = interface(IOldCefBase)
    ['{F2431888-4EAB-421E-9EC3-320BE695AF30}']
    function Write(const ptr: Pointer; size, n: NativeUInt): NativeUInt;
    function Seek(offset: Int64; whence: Integer): Integer;
    function Tell: Int64;
    function Flush: Integer;
    function MayBlock: Boolean;
  end;

  // TOldCefStreamWriter
  // /include/capi/cef_stream_capi.h (cef_stream_writer_t)
  IOldCefStreamWriter = interface(IOldCefBase)
    ['{4AA6C477-7D8A-4D5A-A704-67F900A827E7}']
    function Write(const ptr: Pointer; size, n: NativeUInt): NativeUInt;
    function Seek(offset: Int64; whence: Integer): Integer;
    function Tell: Int64;
    function Flush: Integer;
    function MayBlock: Boolean;
  end;

  // TOldCefResponse
  // /include/capi/cef_response_capi.h (cef_response_t)
  IOldCefResponse = interface(IOldCefBase)
    ['{E9C896E4-59A8-4B96-AB5E-6EA3A498B7F1}']
    function  IsReadOnly: Boolean;
    function  GetStatus: Integer;
    procedure SetStatus(status: Integer);
    function  GetStatusText: oldustring;
    procedure SetStatusText(const StatusText: oldustring);
    function  GetMimeType: oldustring;
    procedure SetMimeType(const mimetype: oldustring);
    function  GetHeader(const name: oldustring): oldustring;
    procedure GetHeaderMap(const headerMap: IOldCefStringMultimap);
    procedure SetHeaderMap(const headerMap: IOldCefStringMultimap);

    property Status     : Integer       read GetStatus      write SetStatus;
    property StatusText : oldustring       read GetStatusText  write SetStatusText;
    property MimeType   : oldustring       read GetMimeType    write SetMimeType;
  end;

  // TOldCefDownloadItem
  // /include/capi/cef_download_item_capi.h (cef_download_item_t)
  IOldCefDownloadItem = interface(IOldCefBase)
    ['{B34BD320-A82E-4185-8E84-B98E5EEC803F}']
    function IsValid: Boolean;
    function IsInProgress: Boolean;
    function IsComplete: Boolean;
    function IsCanceled: Boolean;
    function GetCurrentSpeed: Int64;
    function GetPercentComplete: Integer;
    function GetTotalBytes: Int64;
    function GetReceivedBytes: Int64;
    function GetStartTime: TDateTime;
    function GetEndTime: TDateTime;
    function GetFullPath: oldustring;
    function GetId: Cardinal;
    function GetUrl: oldustring;
    function GetOriginalUrl: oldustring;
    function GetSuggestedFileName: oldustring;
    function GetContentDisposition: oldustring;
    function GetMimeType: oldustring;

    property CurrentSpeed       : Int64     read GetCurrentSpeed;
    property PercentComplete    : Integer   read GetPercentComplete;
    property TotalBytes         : Int64     read GetTotalBytes;
    property ReceivedBytes      : Int64     read GetReceivedBytes;
    property StartTime          : TDateTime read GetStartTime;
    property EndTime            : TDateTime read GetEndTime;
    property FullPath           : oldustring   read GetFullPath;
    property Id                 : Cardinal  read GetId;
    property Url                : oldustring   read GetUrl;
    property OriginalUrl        : oldustring   read GetOriginalUrl;
    property SuggestedFileName  : oldustring   read GetSuggestedFileName;
    property ContentDisposition : oldustring   read GetContentDisposition;
    property MimeType           : oldustring   read GetMimeType;
  end;

  // TOldCefBeforeDownloadCallback
  // /include/capi/cef_download_handler_capi.h (cef_before_download_callback_t)
  IOldCefBeforeDownloadCallback = interface(IOldCefBase)
    ['{5A81AF75-CBA2-444D-AD8E-522160F36433}']
    procedure Cont(const downloadPath: oldustring; showDialog: Boolean);
  end;

  // TOldCefDownloadItemCallback
  // /include/capi/cef_download_handler_capi.h (cef_download_item_callback_t)
  IOldCefDownloadItemCallback = interface(IOldCefBase)
    ['{498F103F-BE64-4D5F-86B7-B37EC69E1735}']
    procedure Cancel;
    procedure Pause;
    procedure Resume;
  end;

  // TOldCefDownloadHandler
  // /include/capi/cef_download_handler_capi.h (cef_download_handler_t)
  IOldCefDownloadHandler = interface(IOldCefBase)
    ['{3137F90A-5DC5-43C1-858D-A269F28EF4F1}']
    procedure OnBeforeDownload(const browser: IOldCefBrowser; const downloadItem: IOldCefDownloadItem; const suggestedName: oldustring; const callback: IOldCefBeforeDownloadCallback);
    procedure OnDownloadUpdated(const browser: IOldCefBrowser; const downloadItem: IOldCefDownloadItem; const callback: IOldCefDownloadItemCallback);

    procedure RemoveReferences; // custom procedure to clear all references
  end;

  // TOldCefV8Exception
  // /include/capi/cef_v8_capi.h (cef_v8exception_t)
  IOldCefV8Exception = interface(IOldCefBase)
    ['{7E422CF0-05AC-4A60-A029-F45105DCE6A4}']
    function GetMessage: oldustring;
    function GetSourceLine: oldustring;
    function GetScriptResourceName: oldustring;
    function GetLineNumber: Integer;
    function GetStartPosition: Integer;
    function GetEndPosition: Integer;
    function GetStartColumn: Integer;
    function GetEndColumn: Integer;

    property Message            : oldustring read GetMessage;
    property SourceLine         : oldustring read GetSourceLine;
    property ScriptResourceName : oldustring read GetScriptResourceName;
    property LineNumber         : Integer read GetLineNumber;
    property StartPosition      : Integer read GetStartPosition;
    property EndPosition        : Integer read GetEndPosition;
    property StartColumn        : Integer read GetStartColumn;
    property EndColumn          : Integer read GetEndColumn;
  end;

  // TOldCefV8Context
  // /include/capi/cef_v8_capi.h (cef_v8context_t)
  IOldCefv8Context = interface(IOldCefBase)
    ['{2295A11A-8773-41F2-AD42-308C215062D9}']
    function GetTaskRunner: IOldCefTaskRunner;
    function IsValid: Boolean;
    function GetBrowser: IOldCefBrowser;
    function GetFrame: IOldCefFrame;
    function GetGlobal: IOldCefv8Value;
    function Enter: Boolean;
    function Exit: Boolean;
    function IsSame(const that: IOldCefv8Context): Boolean;
    function Eval(const code: oldustring; var retval: IOldCefv8Value; var exception: IOldCefV8Exception): Boolean;

    property Browser  : IOldCefBrowser read GetBrowser;
    property Frame    : IOldCefFrame   read GetFrame;
    property Global   : IOldCefv8Value read GetGlobal;
  end;

  // TOldCefv8Handler
  // /include/capi/cef_v8_capi.h (cef_v8handler_t)
  IOldCefv8Handler = interface(IOldCefBase)
    ['{F94CDC60-FDCB-422D-96D5-D2A775BD5D73}']
    function Execute(const name: oldustring; const obj: IOldCefv8Value; const arguments: TOldCefv8ValueArray; var retval: IOldCefv8Value; var exception: oldustring): Boolean;
  end;

  // TOldCefV8Accessor
  // /include/capi/cef_v8_capi.h (cef_v8accessor_t)
  IOldCefV8Accessor = interface(IOldCefBase)
    ['{DCA6D4A2-726A-4E24-AA64-5E8C731D868A}']
    function Get(const name: oldustring; const obj: IOldCefv8Value; out retval: IOldCefv8Value; var exception: oldustring): Boolean;
    function Put(const name: oldustring; const obj, value: IOldCefv8Value; var exception: oldustring): Boolean;
  end;

  // TOldCefTask
  // /include/capi/cef_task_capi.h (cef_task_t)
  IOldCefTask = interface(IOldCefBase)
    ['{0D965470-4A86-47CE-BD39-A8770021AD7E}']
    procedure Execute;
  end;

  // TOldCefTaskRunner
  // /include/capi/cef_task_capi.h (cef_task_runner_t)
  IOldCefTaskRunner = interface(IOldCefBase)
    ['{6A500FA3-77B7-4418-8EA8-6337EED1337B}']
    function IsSame(const that: IOldCefTaskRunner): Boolean;
    function BelongsToCurrentThread: Boolean;
    function BelongsToThread(threadId: TOldCefThreadId): Boolean;
    function PostTask(const task: IOldCefTask): Boolean;
    function PostDelayedTask(const task: IOldCefTask; delayMs: Int64): Boolean;
  end;

  // TOldCefv8Value
  // /include/capi/cef_v8_capi.h (cef_v8value_t)
  IOldCefv8Value = interface(IOldCefBase)
    ['{52319B8D-75A8-422C-BD4B-16FA08CC7F42}']
    function IsValid: Boolean;
    function IsUndefined: Boolean;
    function IsNull: Boolean;
    function IsBool: Boolean;
    function IsInt: Boolean;
    function IsUInt: Boolean;
    function IsDouble: Boolean;
    function IsDate: Boolean;
    function IsString: Boolean;
    function IsObject: Boolean;
    function IsArray: Boolean;
    function IsFunction: Boolean;
    function IsSame(const that: IOldCefv8Value): Boolean;
    function GetBoolValue: Boolean;
    function GetIntValue: Integer;
    function GetUIntValue: Cardinal;
    function GetDoubleValue: Double;
    function GetDateValue: TDateTime;
    function GetStringValue: oldustring;
    function IsUserCreated: Boolean;
    function HasException: Boolean;
    function GetException: IOldCefV8Exception;
    function ClearException: Boolean;
    function WillRethrowExceptions: Boolean;
    function SetRethrowExceptions(rethrow: Boolean): Boolean;
    function HasValueByKey(const key: oldustring): Boolean;
    function HasValueByIndex(index: Integer): Boolean;
    function DeleteValueByKey(const key: oldustring): Boolean;
    function DeleteValueByIndex(index: Integer): Boolean;
    function GetValueByKey(const key: oldustring): IOldCefv8Value;
    function GetValueByIndex(index: Integer): IOldCefv8Value;
    function SetValueByKey(const key: oldustring; const value: IOldCefv8Value; attribute: TOldCefV8PropertyAttributes): Boolean;
    function SetValueByIndex(index: Integer; const value: IOldCefv8Value): Boolean;
    function SetValueByAccessor(const key: oldustring; settings: TOldCefV8AccessControls; attribute: TOldCefV8PropertyAttributes): Boolean;
    function GetKeys(const keys: TStrings): Integer;
    function SetUserData(const data: IOldCefv8Value): Boolean;
    function GetUserData: IOldCefv8Value;
    function GetExternallyAllocatedMemory: Integer;
    function AdjustExternallyAllocatedMemory(changeInBytes: Integer): Integer;
    function GetArrayLength: Integer;
    function GetFunctionName: oldustring;
    function GetFunctionHandler: IOldCefv8Handler;
    function ExecuteFunction(const obj: IOldCefv8Value; const arguments: TOldCefv8ValueArray): IOldCefv8Value;
    function ExecuteFunctionWithContext(const context: IOldCefv8Context; const obj: IOldCefv8Value; const arguments: TOldCefv8ValueArray): IOldCefv8Value;
  end;

  // TOldCefV8StackFrame
  // /include/capi/cef_v8_capi.h (cef_v8stack_frame_t)
  IOldCefV8StackFrame = interface(IOldCefBase)
    ['{BA1FFBF4-E9F2-4842-A827-DC220F324286}']
    function IsValid: Boolean;
    function GetScriptName: oldustring;
    function GetScriptNameOrSourceUrl: oldustring;
    function GetFunctionName: oldustring;
    function GetLineNumber: Integer;
    function GetColumn: Integer;
    function IsEval: Boolean;
    function IsConstructor: Boolean;

    property ScriptName             : oldustring read GetScriptName;
    property ScriptNameOrSourceUrl  : oldustring read GetScriptNameOrSourceUrl;
    property FunctionName           : oldustring read GetFunctionName;
    property LineNumber             : Integer read GetLineNumber;
    property Column                 : Integer read GetColumn;
  end;

  // TOldCefV8StackTrace
  // /include/capi/cef_v8_capi.h (cef_v8stack_trace_t)
  IOldCefV8StackTrace = interface(IOldCefBase)
    ['{32111C84-B7F7-4E3A-92B9-7CA1D0ADB613}']
    function IsValid: Boolean;
    function GetFrameCount: Integer;
    function GetFrame(index: Integer): IOldCefV8StackFrame;

    property FrameCount            : Integer          read GetFrameCount;
    property Frame[index: Integer] : IOldCefV8StackFrame read GetFrame;
  end;

  // TOldCefXmlReader
  // /include/capi/cef_xml_reader_capi.h (cef_xml_reader_t)
  IOldCefXmlReader = interface(IOldCefBase)
    ['{0DE686C3-A8D7-45D2-82FD-92F7F4E62A90}']
    function MoveToNextNode: Boolean;
    function Close: Boolean;
    function HasError: Boolean;
    function GetError: oldustring;
    function GetType: TOldCefXmlNodeType;
    function GetDepth: Integer;
    function GetLocalName: oldustring;
    function GetPrefix: oldustring;
    function GetQualifiedName: oldustring;
    function GetNamespaceUri: oldustring;
    function GetBaseUri: oldustring;
    function GetXmlLang: oldustring;
    function IsEmptyElement: Boolean;
    function HasValue: Boolean;
    function GetValue: oldustring;
    function HasAttributes: Boolean;
    function GetAttributeCount: NativeUInt;
    function GetAttributeByIndex(index: Integer): oldustring;
    function GetAttributeByQName(const qualifiedName: oldustring): oldustring;
    function GetAttributeByLName(const localName, namespaceURI: oldustring): oldustring;
    function GetInnerXml: oldustring;
    function GetOuterXml: oldustring;
    function GetLineNumber: Integer;
    function MoveToAttributeByIndex(index: Integer): Boolean;
    function MoveToAttributeByQName(const qualifiedName: oldustring): Boolean;
    function MoveToAttributeByLName(const localName, namespaceURI: oldustring): Boolean;
    function MoveToFirstAttribute: Boolean;
    function MoveToNextAttribute: Boolean;
    function MoveToCarryingElement: Boolean;
  end;

  // TOldCefZipReader
  // /include/capi/cef_zip_reader_capi.h (cef_zip_reader_t)
  IOldCefZipReader = interface(IOldCefBase)
    ['{3B6C591F-9877-42B3-8892-AA7B27DA34A8}']
    function MoveToFirstFile: Boolean;
    function MoveToNextFile: Boolean;
    function MoveToFile(const fileName: oldustring; caseSensitive: Boolean): Boolean;
    function Close: Boolean;
    function GetFileName: oldustring;
    function GetFileSize: Int64;
    function GetFileLastModified: TOldCefTime;
    function OpenFile(const password: oldustring): Boolean;
    function CloseFile: Boolean;
    function ReadFile(buffer: Pointer; bufferSize: NativeUInt): Integer;
    function Tell: Int64;
    function Eof: Boolean;
  end;

  // TOldCefDomNode
  // /include/capi/cef_dom_capi.h (cef_domnode_t)
  IOldCefDomNode = interface(IOldCefBase)
    ['{96C03C9E-9C98-491A-8DAD-1947332232D6}']
    function  GetType: TOldCefDomNodeType;
    function  IsText: Boolean;
    function  IsElement: Boolean;
    function  IsEditable: Boolean;
    function  IsFormControlElement: Boolean;
    function  GetFormControlElementType: oldustring;
    function  IsSame(const that: IOldCefDomNode): Boolean;
    function  GetName: oldustring;
    function  GetValue: oldustring;
    function  SetValue(const value: oldustring): Boolean;
    function  GetAsMarkup: oldustring;
    function  GetDocument: IOldCefDomDocument;
    function  GetParent: IOldCefDomNode;
    function  GetPreviousSibling: IOldCefDomNode;
    function  GetNextSibling: IOldCefDomNode;
    function  HasChildren: Boolean;
    function  GetFirstChild: IOldCefDomNode;
    function  GetLastChild: IOldCefDomNode;
    function  GetElementTagName: oldustring;
    function  HasElementAttributes: Boolean;
    function  HasElementAttribute(const attrName: oldustring): Boolean;
    function  GetElementAttribute(const attrName: oldustring): oldustring;
    procedure GetElementAttributes(const attrMap: IOldCefStringMap);
    function  SetElementAttribute(const attrName, value: oldustring): Boolean;
    function  GetElementInnerText: oldustring;

    property NodeType         : TOldCefDomNodeType read GetType;
    property Name             : oldustring         read GetName;
    property AsMarkup         : oldustring         read GetAsMarkup;
    property Document         : IOldCefDomDocument read GetDocument;
    property Parent           : IOldCefDomNode     read GetParent;
    property PreviousSibling  : IOldCefDomNode     read GetPreviousSibling;
    property NextSibling      : IOldCefDomNode     read GetNextSibling;
    property FirstChild       : IOldCefDomNode     read GetFirstChild;
    property LastChild        : IOldCefDomNode     read GetLastChild;
    property ElementTagName   : oldustring         read GetElementTagName;
    property ElementInnerText : oldustring         read GetElementInnerText;
  end;

  // TOldCefDomDocument
  // /include/capi/cef_dom_capi.h (cef_domdocument_t)
  IOldCefDomDocument = interface(IOldCefBase)
    ['{08E74052-45AF-4F69-A578-98A5C3959426}']
    function GetType: TOldCefDomDocumentType;
    function GetDocument: IOldCefDomNode;
    function GetBody: IOldCefDomNode;
    function GetHead: IOldCefDomNode;
    function GetTitle: oldustring;
    function GetElementById(const id: oldustring): IOldCefDomNode;
    function GetFocusedNode: IOldCefDomNode;
    function HasSelection: Boolean;
    function GetSelectionStartOffset: Integer;
    function GetSelectionEndOffset: Integer;
    function GetSelectionAsMarkup: oldustring;
    function GetSelectionAsText: oldustring;
    function GetBaseUrl: oldustring;
    function GetCompleteUrl(const partialURL: oldustring): oldustring;

    property DocType              : TOldCefDomDocumentType read GetType;
    property Document             : IOldCefDomNode         read GetDocument;
    property Body                 : IOldCefDomNode         read GetBody;
    property Head                 : IOldCefDomNode         read GetHead;
    property Title                : oldustring             read GetTitle;
    property FocusedNode          : IOldCefDomNode         read GetFocusedNode;
    property SelectionStartOffset : Integer             read GetSelectionStartOffset;
    property SelectionEndOffset   : Integer             read GetSelectionEndOffset;
    property SelectionAsMarkup    : oldustring             read GetSelectionAsMarkup;
    property SelectionAsText      : oldustring             read GetSelectionAsText;
    property BaseUrl              : oldustring             read GetBaseUrl;
  end;

  // TOldCefDomVisitor
  // /include/capi/cef_dom_capi.h (cef_domvisitor_t)
  IOldCefDomVisitor = interface(IOldCefBase)
    ['{30398428-3196-4531-B968-2DDBED36F6B0}']
    procedure visit(const document: IOldCefDomDocument);
  end;

  // TOldCefCookieVisitor
  // /include/capi/cef_cookie_capi.h (cef_cookie_visitor_t)
  IOldCefCookieVisitor = interface(IOldCefBase)
    ['{8378CF1B-84AB-4FDB-9B86-34DDABCCC402}']
    function visit(const name, value, domain, path: oldustring; secure, httponly, hasExpires: Boolean; const creation, lastAccess, expires: TDateTime; count, total: Integer; out deleteCookie: Boolean): Boolean;
  end;

  // TOldCefCommandLine
  // /include/capi/cef_command_line_capi.h (cef_command_line_t)
  IOldCefCommandLine = interface(IOldCefBase)
    ['{6B43D21B-0F2C-4B94-B4E6-4AF0D7669D8E}']
    function  IsValid: Boolean;
    function  IsReadOnly: Boolean;
    function  Copy: IOldCefCommandLine;
    procedure InitFromArgv(argc: Integer; const argv: PPAnsiChar);
    procedure InitFromString(const commandLine: oldustring);
    procedure Reset;
    function  GetCommandLineString: oldustring;
    procedure GetArgv(var args: TStrings);
    function  GetProgram: oldustring;
    procedure SetProgram(const prog: oldustring);
    function  HasSwitches: Boolean;
    function  HasSwitch(const name: oldustring): Boolean;
    function  GetSwitchValue(const name: oldustring): oldustring;
    procedure GetSwitches(var switches: TStrings);
    procedure AppendSwitch(const name: oldustring);
    procedure AppendSwitchWithValue(const name, value: oldustring);
    function  HasArguments: Boolean;
    procedure GetArguments(var arguments: TStrings);
    procedure AppendArgument(const argument: oldustring);
    procedure PrependWrapper(const wrapper: oldustring);

    property  CommandLineString  : oldustring   read GetCommandLineString;
  end;

  // TOldCefResourceBundleHandler
  // /include/capi/cef_resource_bundle_handler_capi.h (cef_resource_bundle_handler_t)
  IOldCefResourceBundleHandler = interface(IOldCefBase)
    ['{09C264FD-7E03-41E3-87B3-4234E82B5EA2}']
    function GetLocalizedString(stringId: Integer; var stringVal: oldustring): Boolean;
    function GetDataResource(resourceId: Integer; var data: Pointer; var dataSize: NativeUInt): Boolean;
    function GetDataResourceForScale(resourceId: Integer; scaleFactor: TOldCefScaleFactor; var data: Pointer; var dataSize: NativeUInt): Boolean;
  end;

  // TOldCefBrowserProcessHandler
  // /include/capi/cef_browser_process_handler_capi.h (cef_browser_process_handler_t)
  IOldCefBrowserProcessHandler = interface(IOldCefBase)
    ['{27291B7A-C0AE-4EE0-9115-15C810E22F6C}']
    procedure OnContextInitialized;
    procedure OnBeforeChildProcessLaunch(const commandLine: IOldCefCommandLine);
    procedure OnRenderProcessThreadCreated(const extraInfo: IOldCefListValue);
    procedure GetPrintHandler(var aHandler : IOldCefPrintHandler);
  end;

  // TOldCefRenderProcessHandler
  // /include/capi/cef_render_process_handler_capi.h (cef_render_process_handler_t)
  IOldCefRenderProcessHandler = interface(IOldCefBase)
    ['{FADEE3BC-BF66-430A-BA5D-1EE3782ECC58}']
    procedure OnRenderThreadCreated(const extraInfo: IOldCefListValue);
    procedure OnWebKitInitialized;
    procedure OnBrowserCreated(const browser: IOldCefBrowser);
    procedure OnBrowserDestroyed(const browser: IOldCefBrowser);
    function  GetLoadHandler : IOldCefLoadHandler;
    function  OnBeforeNavigation(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; navigationType: TOldCefNavigationType; isRedirect: Boolean): Boolean;
    procedure OnContextCreated(const browser: IOldCefBrowser; const frame: IOldCefFrame; const context: IOldCefv8Context);
    procedure OnContextReleased(const browser: IOldCefBrowser; const frame: IOldCefFrame; const context: IOldCefv8Context);
    procedure OnUncaughtException(const browser: IOldCefBrowser; const frame: IOldCefFrame; const context: IOldCefv8Context; const V8Exception: IOldCefV8Exception; const stackTrace: IOldCefV8StackTrace);
    procedure OnFocusedNodeChanged(const browser: IOldCefBrowser; const frame: IOldCefFrame; const node: IOldCefDomNode);
    function  OnProcessMessageReceived(const browser: IOldCefBrowser; sourceProcess: TOldCefProcessId; const aMessage: IOldCefProcessMessage): Boolean;
  end;

  // TOldCefApp
  // /include/capi/cef_app_capi.h (cef_app_t)
  IOldCefApp = interface(IOldCefBase)
    ['{970CA670-9070-4642-B188-7D8A22DAEED4}']
    procedure OnBeforeCommandLineProcessing(const processType: oldustring; const commandLine: IOldCefCommandLine);
    procedure OnRegisterCustomSchemes(const registrar : IOldCefSchemeRegistrar);
    procedure GetResourceBundleHandler(var aHandler : IOldCefResourceBundleHandler);
    procedure GetBrowserProcessHandler(var aHandler : IOldCefBrowserProcessHandler);
    procedure GetRenderProcessHandler(var aHandler : IOldCefRenderProcessHandler);
  end;

  // TOldCefCompletionCallback
  // /include/capi/cef_callback_capi.h (cef_completion_callback_t)
  IOldCefCompletionCallback = interface(IOldCefBase)
    ['{A8ECCFBB-FEE0-446F-AB32-AD69A7478D57}']
    procedure OnComplete;
  end;

  // TOldCefSetCookieCallback
  // /include/capi/cef_cookie_capi.h (cef_set_cookie_callback_t)
  IOldCefSetCookieCallback = interface(IOldCefBase)
    ['{16E14B6F-CB0A-4F9D-A008-239E0BC7B892}']
    procedure OnComplete(success: Boolean);
  end;

  // TOldCefDeleteCookiesCallback
  // /include/capi/cef_cookie_capi.h (cef_delete_cookies_callback_t)
  IOldCefDeleteCookiesCallback = interface(IOldCefBase)
    ['{758B79A1-B9E8-4F0D-94A0-DCE5AFADE33D}']
    procedure OnComplete(numDeleted: Integer);
  end;

  // TOldCefCookieManager
  // /include/capi/cef_cookie_capi.h (cef_cookie_manager_t)
  IOldCefCookieManager = Interface(IOldCefBase)
    ['{CC1749E6-9AD3-4283-8430-AF6CBF3E8785}']
    procedure SetSupportedSchemes(const schemes: TStrings; const callback: IOldCefCompletionCallback);
    procedure SetSupportedSchemesProc(const schemes: TStrings; const callback: TOldCefCompletionCallbackProc);
    function  VisitAllCookies(const visitor: IOldCefCookieVisitor): Boolean;
    function  VisitAllCookiesProc(const visitor: TOldCefCookieVisitorProc): Boolean;
    function  VisitUrlCookies(const url: oldustring; includeHttpOnly: Boolean; const visitor: IOldCefCookieVisitor): Boolean;
    function  VisitUrlCookiesProc(const url: oldustring; includeHttpOnly: Boolean; const visitor: TOldCefCookieVisitorProc): Boolean;
    function  SetCookie(const url: oldustring; const name, value, domain, path: oldustring; secure, httponly, hasExpires: Boolean; const creation, lastAccess, expires: TDateTime; const callback: IOldCefSetCookieCallback): Boolean;
    function  SetCookieProc(const url: oldustring; const name, value, domain, path: oldustring; secure, httponly, hasExpires: Boolean; const creation, lastAccess, expires: TDateTime; const callback: TOldCefSetCookieCallbackProc): Boolean;
    function  DeleteCookies(const url, cookieName: oldustring; const callback: IOldCefDeleteCookiesCallback): Boolean;
    function  DeleteCookiesProc(const url, cookieName: oldustring; const callback: TOldCefDeleteCookiesCallbackProc): Boolean;
    function  SetStoragePath(const path: oldustring; persistSessionCookies: Boolean; const callback: IOldCefCompletionCallback): Boolean;
    function  SetStoragePathProc(const path: oldustring; persistSessionCookies: Boolean; const callback: TOldCefCompletionCallbackProc): Boolean;
    function  FlushStore(const handler: IOldCefCompletionCallback): Boolean;
    function  FlushStoreProc(const proc: TOldCefCompletionCallbackProc): Boolean;
  end;

  // TOldCefWebPluginInfo
  // /include/capi/cef_web_plugin_capi.h (cef_web_plugin_info_t)
  IOldCefWebPluginInfo = interface(IOldCefBase)
    ['{AA879E58-F649-44B1-AF9C-655FF5B79A02}']
    function GetName: oldustring;
    function GetPath: oldustring;
    function GetVersion: oldustring;
    function GetDescription: oldustring;

    property Name         : oldustring read GetName;
    property Path         : oldustring read GetPath;
    property Version      : oldustring read GetVersion;
    property Description  : oldustring read GetDescription;
  end;

  // TOldCefCallback
  // /include/capi/cef_callback_capi.h (cef_callback_t)
  IOldCefCallback = interface(IOldCefBase)
    ['{1B8C449F-E2D6-4B78-9BBA-6F47E8BCDF37}']
    procedure Cont;
    procedure Cancel;
  end;

  // TOldCefGeolocationCallback
  // /include/capi/cef_geolocation_handler_capi.h (cef_geolocation_callback_t)
  IOldCefGeolocationCallback = interface(IOldCefBase)
    ['{272B8E4F-4AE4-4F14-BC4E-5924FA0C149D}']
    procedure Cont(allow: Boolean);
  end;

  // TOldCefGeolocationHandler
  // /include/capi/cef_geolocation_handler_capi.h (cef_geolocation_handler_t)
  IOldCefGeolocationHandler = interface(IOldCefBase)
    ['{1178EE62-BAE7-4E44-932B-EAAC7A18191C}']
    function  OnRequestGeolocationPermission(const browser: IOldCefBrowser; const requestingUrl: oldustring; requestId: Integer; const callback: IOldCefGeolocationCallback): Boolean;
    procedure OnCancelGeolocationPermission(const browser: IOldCefBrowser; requestId: Integer);

    procedure RemoveReferences; // custom procedure to clear all references
  end;

  // TOldCefResourceHandler
  // /include/capi/cef_resource_handler_capi.h (cef_resource_handler_t)
  IOldCefResourceHandler = interface(IOldCefBase)
  ['{BD3EA208-AAAD-488C-BFF2-76993022F2B5}']
    function  ProcessRequest(const request: IOldCefRequest; const callback: IOldCefCallback): Boolean;
    procedure GetResponseHeaders(const response: IOldCefResponse; out responseLength: Int64; out redirectUrl: oldustring);
    function  ReadResponse(const dataOut: Pointer; bytesToRead: Integer; var bytesRead: Integer; const callback: IOldCefCallback): Boolean;
    function  CanGetCookie(const cookie: POldCefCookie): Boolean;
    function  CanSetCookie(const cookie: POldCefCookie): Boolean;
    procedure Cancel;
  end;

  // TOldCefSchemeHandlerFactory
  // /include/capi/cef_scheme_capi.h (cef_scheme_handler_factory_t)
  IOldCefSchemeHandlerFactory = interface(IOldCefBase)
    ['{4D9B7960-B73B-4EBD-9ABE-6C1C43C245EB}']
    function New(const browser: IOldCefBrowser; const frame: IOldCefFrame; const schemeName: oldustring; const request: IOldCefRequest): IOldCefResourceHandler;
  end;

  // TOldCefAuthCallback
  // /include/capi/cef_auth_callback_capi.h (cef_auth_callback_t)
  IOldCefAuthCallback = interface(IOldCefBase)
    ['{500C2023-BF4D-4FF7-9C04-165E5C389131}']
    procedure Cont(const username, password: oldustring);
    procedure Cancel;
  end;

  // TOldCefJsDialogCallback
  // /include/capi/cef_jsdialog_handler_capi.h (cef_jsdialog_callback_t)
  IOldCefJsDialogCallback = interface(IOldCefBase)
    ['{187B2156-9947-4108-87AB-32E559E1B026}']
    procedure Cont(success: Boolean; const userInput: oldustring);
  end;

  // TOldCefContextMenuParams
  // /include/capi/cef_context_menu_handler_capi.h (cef_context_menu_params_t)
  IOldCefContextMenuParams = interface(IOldCefBase)
    ['{E31BFA9E-D4E2-49B7-A05D-20018C8794EB}']
    function GetXCoord: Integer;
    function GetYCoord: Integer;
    function GetTypeFlags: TOldCefContextMenuTypeFlags;
    function GetLinkUrl: oldustring;
    function GetUnfilteredLinkUrl: oldustring;
    function GetSourceUrl: oldustring;
    function HasImageContents: Boolean;
    function GetPageUrl: oldustring;
    function GetFrameUrl: oldustring;
    function GetFrameCharset: oldustring;
    function GetMediaType: TOldCefContextMenuMediaType;
    function GetMediaStateFlags: TOldCefContextMenuMediaStateFlags;
    function GetSelectionText: oldustring;
    function GetMisspelledWord: oldustring;
    function GetDictionarySuggestions(const suggestions: TStringList): Boolean;
    function IsEditable: Boolean;
    function IsSpellCheckEnabled: Boolean;
    function GetEditStateFlags: TOldCefContextMenuEditStateFlags;
    function IsCustomMenu: Boolean;
    function IsPepperMenu: Boolean;

    property XCoord            : Integer                        read GetXCoord;
    property YCoord            : Integer                        read GetYCoord;
    property TypeFlags         : TOldCefContextMenuTypeFlags       read GetTypeFlags;
    property LinkUrl           : oldustring                        read GetLinkUrl;
    property UnfilteredLinkUrl : oldustring                        read GetUnfilteredLinkUrl;
    property SourceUrl         : oldustring                        read GetSourceUrl;
    property PageUrl           : oldustring                        read GetPageUrl;
    property FrameUrl          : oldustring                        read GetFrameUrl;
    property FrameCharset      : oldustring                        read GetFrameCharset;
    property MediaType         : TOldCefContextMenuMediaType       read GetMediaType;
    property MediaStateFlags   : TOldCefContextMenuMediaStateFlags read GetMediaStateFlags;
    property SelectionText     : oldustring                        read GetSelectionText;
    property EditStateFlags    : TOldCefContextMenuEditStateFlags  read GetEditStateFlags;
  end;

  // TOldCefMenuModel
  // /include/capi/cef_menu_model_capi.h (cef_menu_model_t)
  IOldCefMenuModel = interface(IOldCefBase)
    ['{40AF19D3-8B4E-44B8-8F89-DEB5907FC495}']
    function Clear: Boolean;
    function GetCount: Integer;
    function AddSeparator: Boolean;
    function AddItem(commandId: Integer; const text: oldustring): Boolean;
    function AddCheckItem(commandId: Integer; const text: oldustring): Boolean;
    function AddRadioItem(commandId: Integer; const text: oldustring; groupId: Integer): Boolean;
    function AddSubMenu(commandId: Integer; const text: oldustring): IOldCefMenuModel;
    function InsertSeparatorAt(index: Integer): Boolean;
    function InsertItemAt(index, commandId: Integer; const text: oldustring): Boolean;
    function InsertCheckItemAt(index, commandId: Integer; const text: oldustring): Boolean;
    function InsertRadioItemAt(index, commandId: Integer; const text: oldustring; groupId: Integer): Boolean;
    function InsertSubMenuAt(index, commandId: Integer; const text: oldustring): IOldCefMenuModel;
    function Remove(commandId: Integer): Boolean;
    function RemoveAt(index: Integer): Boolean;
    function GetIndexOf(commandId: Integer): Integer;
    function GetCommandIdAt(index: Integer): Integer;
    function SetCommandIdAt(index, commandId: Integer): Boolean;
    function GetLabel(commandId: Integer): oldustring;
    function GetLabelAt(index: Integer): oldustring;
    function SetLabel(commandId: Integer; const text: oldustring): Boolean;
    function SetLabelAt(index: Integer; const text: oldustring): Boolean;
    function GetType(commandId: Integer): TOldCefMenuItemType;
    function GetTypeAt(index: Integer): TOldCefMenuItemType;
    function GetGroupId(commandId: Integer): Integer;
    function GetGroupIdAt(index: Integer): Integer;
    function SetGroupId(commandId, groupId: Integer): Boolean;
    function SetGroupIdAt(index, groupId: Integer): Boolean;
    function GetSubMenu(commandId: Integer): IOldCefMenuModel;
    function GetSubMenuAt(index: Integer): IOldCefMenuModel;
    function IsVisible(commandId: Integer): Boolean;
    function isVisibleAt(index: Integer): Boolean;
    function SetVisible(commandId: Integer; visible: Boolean): Boolean;
    function SetVisibleAt(index: Integer; visible: Boolean): Boolean;
    function IsEnabled(commandId: Integer): Boolean;
    function IsEnabledAt(index: Integer): Boolean;
    function SetEnabled(commandId: Integer; enabled: Boolean): Boolean;
    function SetEnabledAt(index: Integer; enabled: Boolean): Boolean;
    function IsChecked(commandId: Integer): Boolean;
    function IsCheckedAt(index: Integer): Boolean;
    function setChecked(commandId: Integer; checked: Boolean): Boolean;
    function setCheckedAt(index: Integer; checked: Boolean): Boolean;
    function HasAccelerator(commandId: Integer): Boolean;
    function HasAcceleratorAt(index: Integer): Boolean;
    function SetAccelerator(commandId, keyCode: Integer; shiftPressed, ctrlPressed, altPressed: Boolean): Boolean;
    function SetAcceleratorAt(index, keyCode: Integer; shiftPressed, ctrlPressed, altPressed: Boolean): Boolean;
    function RemoveAccelerator(commandId: Integer): Boolean;
    function RemoveAcceleratorAt(index: Integer): Boolean;
    function GetAccelerator(commandId: Integer; out keyCode: Integer; out shiftPressed, ctrlPressed, altPressed: Boolean): Boolean;
    function GetAcceleratorAt(index: Integer; out keyCode: Integer; out shiftPressed, ctrlPressed, altPressed: Boolean): Boolean;
  end;

  // TOldCefValue
  // /include/capi/cef_values_capi.h (cef_value_t)
  IOldCefValue = interface(IOldCefBase)
    ['{66F9F439-B12B-4EC3-A945-91AE4EF4D4BA}']
    function IsValid: Boolean;
    function IsOwned: Boolean;
    function IsReadOnly: Boolean;
    function IsSame(const that: IOldCefValue): Boolean;
    function IsEqual(const that: IOldCefValue): Boolean;
    function Copy: IOldCefValue;
    function GetType: TOldCefValueType;
    function GetBool: Boolean;
    function GetInt: Integer;
    function GetDouble: Double;
    function GetString: oldustring;
    function GetBinary: IOldCefBinaryValue;
    function GetDictionary: IOldCefDictionaryValue;
    function GetList: IOldCefListValue;
    function SetNull: Boolean;
    function SetBool(value: Integer): Boolean;
    function SetInt(value: Integer): Boolean;
    function SetDouble(value: Double): Boolean;
    function SetString(const value: oldustring): Boolean;
    function SetBinary(const value: IOldCefBinaryValue): Boolean;
    function SetDictionary(const value: IOldCefDictionaryValue): Boolean;
    function SetList(const value: IOldCefListValue): Boolean;
  end;

  // TOldCefBinaryValue
  // /include/capi/cef_values_capi.h (cef_binary_value_t)
  IOldCefBinaryValue = interface(IOldCefBase)
    ['{974AA40A-9C5C-4726-81F0-9F0D46D7C5B3}']
    function IsValid: Boolean;
    function IsOwned: Boolean;
    function IsSame(const that: IOldCefBinaryValue): Boolean;
    function IsEqual(const that: IOldCefBinaryValue): Boolean;
    function Copy: IOldCefBinaryValue;
    function GetSize: NativeUInt;
    function GetData(buffer: Pointer; bufferSize, dataOffset: NativeUInt): NativeUInt;

    property Size  : NativeUInt   read GetSize;
  end;

  // TOldCefDictionaryValue
  // /include/capi/cef_values_capi.h (cef_dictionary_value_t)
  IOldCefDictionaryValue = interface(IOldCefBase)
    ['{B9638559-54DC-498C-8185-233EEF12BC69}']
    function IsValid: Boolean;
    function isOwned: Boolean;
    function IsReadOnly: Boolean;
    function IsSame(const that: IOldCefDictionaryValue): Boolean;
    function IsEqual(const that: IOldCefDictionaryValue): Boolean;
    function Copy(excludeEmptyChildren: Boolean): IOldCefDictionaryValue;
    function GetSize: NativeUInt;
    function Clear: Boolean;
    function HasKey(const key: oldustring): Boolean;
    function GetKeys(const keys: TStrings): Boolean;
    function Remove(const key: oldustring): Boolean;
    function GetType(const key: oldustring): TOldCefValueType;
    function GetValue(const key: oldustring): IOldCefValue;
    function GetBool(const key: oldustring): Boolean;
    function GetInt(const key: oldustring): Integer;
    function GetDouble(const key: oldustring): Double;
    function GetString(const key: oldustring): oldustring;
    function GetBinary(const key: oldustring): IOldCefBinaryValue;
    function GetDictionary(const key: oldustring): IOldCefDictionaryValue;
    function GetList(const key: oldustring): IOldCefListValue;
    function SetValue(const key: oldustring; const value: IOldCefValue): Boolean;
    function SetNull(const key: oldustring): Boolean;
    function SetBool(const key: oldustring; value: Boolean): Boolean;
    function SetInt(const key: oldustring; value: Integer): Boolean;
    function SetDouble(const key: oldustring; value: Double): Boolean;
    function SetString(const key, value: oldustring): Boolean;
    function SetBinary(const key: oldustring; const value: IOldCefBinaryValue): Boolean;
    function SetDictionary(const key: oldustring; const value: IOldCefDictionaryValue): Boolean;
    function SetList(const key: oldustring; const value: IOldCefListValue): Boolean;
  end;

  // TOldCefListValue
  // /include/capi/cef_values_capi.h (cef_list_value_t)
  IOldCefListValue = interface(IOldCefBase)
    ['{09174B9D-0CC6-4360-BBB0-3CC0117F70F6}']
    function IsValid: Boolean;
    function IsOwned: Boolean;
    function IsReadOnly: Boolean;
    function IsSame(const that: IOldCefListValue): Boolean;
    function IsEqual(const that: IOldCefListValue): Boolean;
    function Copy: IOldCefListValue;
    function SetSize(size: NativeUInt): Boolean;
    function GetSize: NativeUInt;
    function Clear: Boolean;
    function Remove(index: Integer): Boolean;
    function GetType(index: Integer): TOldCefValueType;
    function GetValue(index: Integer): IOldCefValue;
    function GetBool(index: Integer): Boolean;
    function GetInt(index: Integer): Integer;
    function GetDouble(index: Integer): Double;
    function GetString(index: Integer): oldustring;
    function GetBinary(index: Integer): IOldCefBinaryValue;
    function GetDictionary(index: Integer): IOldCefDictionaryValue;
    function GetList(index: Integer): IOldCefListValue;
    function SetValue(index: Integer; const value: IOldCefValue): Boolean;
    function SetNull(index: Integer): Boolean;
    function SetBool(index: Integer; value: Boolean): Boolean;
    function SetInt(index: Integer; value: Integer): Boolean;
    function SetDouble(index: Integer; value: Double): Boolean;
    function SetString(index: Integer; const value: oldustring): Boolean;
    function SetBinary(index: Integer; const value: IOldCefBinaryValue): Boolean;
    function SetDictionary(index: Integer; const value: IOldCefDictionaryValue): Boolean;
    function SetList(index: Integer; const value: IOldCefListValue): Boolean;
  end;

  // TOldCefLifeSpanHandler
  // /include/capi/cef_life_span_handler_capi.h (cef_life_span_handler_t)
  IOldCefLifeSpanHandler = interface(IOldCefBase)
    ['{0A3EB782-A319-4C35-9B46-09B2834D7169}']
    function  OnBeforePopup(const browser: IOldCefBrowser; const frame: IOldCefFrame; const targetUrl, targetFrameName: oldustring; targetDisposition: TOldCefWindowOpenDisposition; userGesture: Boolean; const popupFeatures: TOldCefPopupFeatures; var windowInfo: TOldCefWindowInfo; var client: IOldCefClient; var settings: TOldCefBrowserSettings; var noJavascriptAccess: Boolean): Boolean;
    procedure OnAfterCreated(const browser: IOldCefBrowser);
    function  RunModal(const browser: IOldCefBrowser): Boolean;
    function  DoClose(const browser: IOldCefBrowser): Boolean;
    procedure OnBeforeClose(const browser: IOldCefBrowser);

    procedure RemoveReferences; // custom procedure to clear all references
  end;

  // TOldCefLoadHandler
  // /include/capi/cef_load_handler_capi.h (cef_load_handler_t)
  IOldCefLoadHandler = interface(IOldCefBase)
    ['{2C63FB82-345D-4A5B-9858-5AE7A85C9F49}']
    procedure OnLoadingStateChange(const browser: IOldCefBrowser; isLoading, canGoBack, canGoForward: Boolean);
    procedure OnLoadStart(const browser: IOldCefBrowser; const frame: IOldCefFrame);
    procedure OnLoadEnd(const browser: IOldCefBrowser; const frame: IOldCefFrame; httpStatusCode: Integer);
    procedure OnLoadError(const browser: IOldCefBrowser; const frame: IOldCefFrame; errorCode: Integer; const errorText, failedUrl: oldustring);

    procedure RemoveReferences; // custom procedure to clear all references
  end;

  // TOldCefRequestCallback
  // /include/capi/cef_request_handler_capi.h (cef_request_callback_t)
  IOldCefRequestCallback = interface(IOldCefBase)
    ['{A35B8FD5-226B-41A8-A763-1940787D321C}']
    procedure Cont(allow: Boolean);
    procedure Cancel;
  end;

  // TOldCefResponseFilter
  // /include/capi/cef_response_filter_capi.h (cef_response_filter_t)
  IOldCefResponseFilter = interface(IOldCefBase)
    ['{5013BC3C-F1AE-407A-A571-A4C6B1D6831E}']
    function InitFilter: Boolean;
    function Filter(data_in: Pointer; data_in_size: NativeUInt; var data_in_read: NativeUInt; data_out: Pointer; data_out_size : NativeUInt; var data_out_written: NativeUInt): TOldCefResponseFilterStatus;
  end;

  // TOldCefRequestHandler
  // /include/capi/cef_request_handler_capi.h (cef_request_handler_t)
  IOldCefRequestHandler = interface(IOldCefBase)
    ['{050877A9-D1F8-4EB3-B58E-50DC3E3D39FD}']
    function  OnBeforeBrowse(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; isRedirect: Boolean): Boolean;
    function  OnOpenUrlFromTab(const browser: IOldCefBrowser; const frame: IOldCefFrame; const targetUrl: oldustring; targetDisposition: TOldCefWindowOpenDisposition; userGesture: Boolean): Boolean;
    function  OnBeforeResourceLoad(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; const callback: IOldCefRequestCallback): TOldCefReturnValue;
    function  GetResourceHandler(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest): IOldCefResourceHandler;
    procedure OnResourceRedirect(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; var newUrl: oldustring);
    function  OnResourceResponse(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; const response: IOldCefResponse): Boolean;
    function  GetResourceResponseFilter(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; const response: IOldCefResponse): IOldCefResponseFilter;
    procedure OnResourceLoadComplete(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; const response: IOldCefResponse; status: TOldCefUrlRequestStatus; receivedContentLength: Int64);
    function  GetAuthCredentials(const browser: IOldCefBrowser; const frame: IOldCefFrame; isProxy: Boolean; const host: oldustring; port: Integer; const realm, scheme: oldustring; const callback: IOldCefAuthCallback): Boolean;
    function  OnQuotaRequest(const browser: IOldCefBrowser; const originUrl: oldustring; newSize: Int64; const callback: IOldCefRequestCallback): Boolean;
    procedure OnProtocolExecution(const browser: IOldCefBrowser; const url: oldustring; out allowOsExecution: Boolean);
    function  OnCertificateError(const browser: IOldCefBrowser; certError: TOldCefErrorcode; const requestUrl: oldustring; const sslInfo: IOldCefSslInfo; const callback: IOldCefRequestCallback): Boolean;
    procedure OnPluginCrashed(const browser: IOldCefBrowser; const pluginPath: oldustring);
    procedure OnRenderViewReady(const browser: IOldCefBrowser);
    procedure OnRenderProcessTerminated(const browser: IOldCefBrowser; status: TOldCefTerminationStatus);

    procedure RemoveReferences; // custom procedure to clear all references
  end;

  // TOldCefDisplayHandler
  // /include/capi/cef_display_handler_capi.h (cef_display_handler_t)
  IOldCefDisplayHandler = interface(IOldCefBase)
    ['{1EC7C76D-6969-41D1-B26D-079BCFF054C4}']
    procedure OnAddressChange(const browser: IOldCefBrowser; const frame: IOldCefFrame; const url: oldustring);
    procedure OnTitleChange(const browser: IOldCefBrowser; const title: oldustring);
    procedure OnFaviconUrlChange(const browser: IOldCefBrowser; const icon_urls: TStrings);
    procedure OnFullScreenModeChange(const browser: IOldCefBrowser; fullscreen: Boolean);
    function  OnTooltip(const browser: IOldCefBrowser; var text: oldustring): Boolean;
    procedure OnStatusMessage(const browser: IOldCefBrowser; const value: oldustring);
    function  OnConsoleMessage(const browser: IOldCefBrowser; const message_, source: oldustring; line: Integer): Boolean;

    procedure RemoveReferences; // custom procedure to clear all references
  end;

  // TOldCefFocusHandler
  // /include/capi/cef_focus_handler_capi.h (cef_focus_handler_t)
  IOldCefFocusHandler = interface(IOldCefBase)
    ['{BB7FA3FA-7B1A-4ADC-8E50-12A24018DD90}']
    procedure OnTakeFocus(const browser: IOldCefBrowser; next: Boolean);
    function  OnSetFocus(const browser: IOldCefBrowser; source: TOldCefFocusSource): Boolean;
    procedure OnGotFocus(const browser: IOldCefBrowser);

    procedure RemoveReferences; // custom procedure to clear all references
  end;

  // TOldCefKeyboardHandler
  // /include/capi/cef_keyboard_handler_capi.h (cef_keyboard_handler_t)
  IOldCefKeyboardHandler = interface(IOldCefBase)
    ['{0512F4EC-ED88-44C9-90D3-5C6D03D3B146}']
    function OnPreKeyEvent(const browser: IOldCefBrowser; const event: POldCefKeyEvent; osEvent: TOldCefEventHandle; out isKeyboardShortcut: Boolean): Boolean;
    function OnKeyEvent(const browser: IOldCefBrowser; const event: POldCefKeyEvent; osEvent: TOldCefEventHandle): Boolean;

    procedure RemoveReferences; // custom procedure to clear all references
  end;

  // TOldCefJsDialogHandler
  // /include/capi/cef_jsdialog_handler_capi.h (cef_jsdialog_handler_t)
  IOldCefJsDialogHandler = interface(IOldCefBase)
    ['{64E18F86-DAC5-4ED1-8589-44DE45B9DB56}']
    function  OnJsdialog(const browser: IOldCefBrowser; const originUrl, accept_lang: oldustring; dialogType: TOldCefJsDialogType; const messageText, defaultPromptText: oldustring; const callback: IOldCefJsDialogCallback; out suppressMessage: Boolean): Boolean;
    function  OnBeforeUnloadDialog(const browser: IOldCefBrowser; const messageText: oldustring; isReload: Boolean; const callback: IOldCefJsDialogCallback): Boolean;
    procedure OnResetDialogState(const browser: IOldCefBrowser);
    procedure OnDialogClosed(const browser: IOldCefBrowser);

    procedure RemoveReferences; // custom procedure to clear all references
  end;

  // TOldCefRunContextMenuCallback
  // /include/capi/cef_context_menu_handler_capi.h (cef_run_context_menu_callback_t)
  IOldCefRunContextMenuCallback = interface(IOldCefBase)
    ['{44C3C6E3-B64D-4F6E-A318-4A0F3A72EB00}']
    procedure Cont(commandId: Integer; eventFlags: TOldCefEventFlags);
    procedure Cancel;
  end;

  // TOldCefContextMenuHandler
  // /include/capi/cef_context_menu_handler_capi.h (cef_context_menu_handler_t)
  IOldCefContextMenuHandler = interface(IOldCefBase)
    ['{C2951895-4087-49D5-BA18-4D9BA4F5EDD7}']
    procedure OnBeforeContextMenu(const browser: IOldCefBrowser; const frame: IOldCefFrame; const params: IOldCefContextMenuParams; const model: IOldCefMenuModel);
    function  RunContextMenu(const browser: IOldCefBrowser; const frame: IOldCefFrame; const params: IOldCefContextMenuParams; const model: IOldCefMenuModel; const callback: IOldCefRunContextMenuCallback): Boolean;
    function  OnContextMenuCommand(const browser: IOldCefBrowser; const frame: IOldCefFrame; const params: IOldCefContextMenuParams; commandId: Integer; eventFlags: TOldCefEventFlags): Boolean;
    procedure OnContextMenuDismissed(const browser: IOldCefBrowser; const frame: IOldCefFrame);

    procedure RemoveReferences; // custom procedure to clear all references
  end;

  // TOldCefAccessibilityHandler
  // /include/capi/cef_accessibility_handler_capi.h (cef_accessibility_handler_t)
  IOldCefAccessibilityHandler = interface(IOldCefBase)
    ['{1878C3C7-7692-44AB-BFE0-6C387106816B}']
    procedure OnAccessibilityTreeChange(const value: IOldCefValue);
    procedure OnAccessibilityLocationChange(const value: IOldCefValue);
  end;

  // TOldCefDialogHandler
  // /include/capi/cef_dialog_handler_capi.h (cef_dialog_handler_t)
  IOldCefDialogHandler = interface(IOldCefBase)
    ['{7763F4B2-8BE1-4E80-AC43-8B825850DC67}']
    function OnFileDialog(const browser: IOldCefBrowser; mode: TOldCefFileDialogMode; const title, defaultFilePath: oldustring; const acceptFilters: TStrings; selectedAcceptFilter: Integer; const callback: IOldCefFileDialogCallback): Boolean;

    procedure RemoveReferences; // custom procedure to clear all references
  end;

  // TOldCefRenderHandler
  // /include/capi/cef_render_handler_capi.h (cef_render_handler_t)
  IOldCefRenderHandler = interface(IOldCefBase)
    ['{1FC1C22B-085A-4741-9366-5249B88EC410}']
    function  GetRootScreenRect(const browser: IOldCefBrowser; var rect: TOldCefRect): Boolean;
    function  GetViewRect(const browser: IOldCefBrowser; var rect: TOldCefRect): Boolean;
    function  GetScreenPoint(const browser: IOldCefBrowser; viewX, viewY: Integer; var screenX, screenY: Integer): Boolean;
    function  GetScreenInfo(const browser: IOldCefBrowser; var screenInfo: TOldCefScreenInfo): Boolean;
    procedure OnPopupShow(const browser: IOldCefBrowser; show: Boolean);
    procedure OnPopupSize(const browser: IOldCefBrowser; const rect: POldCefRect);
    procedure OnPaint(const browser: IOldCefBrowser; kind: TOldCefPaintElementType; dirtyRectsCount: NativeUInt; const dirtyRects: POldCefRectArray; const buffer: Pointer; width, height: Integer);
    procedure OnCursorChange(const browser: IOldCefBrowser; cursor: TOldCefCursorHandle; CursorType: TOldCefCursorType; const customCursorInfo: POldCefCursorInfo);
    function  OnStartDragging(const browser: IOldCefBrowser; const dragData: IOldCefDragData; allowedOps: TOldCefDragOperations; x, y: Integer): Boolean;
    procedure OnUpdateDragCursor(const browser: IOldCefBrowser; operation: TOldCefDragOperation);
    procedure OnScrollOffsetChanged(const browser: IOldCefBrowser; x, y: Double);

    procedure RemoveReferences; // custom procedure to clear all references
  end;

  // TOldCefClient
  // /include/capi/cef_client_capi.h (cef_client_t)
  IOldCefClient = interface(IOldCefBase)
    ['{1D502075-2FF0-4E13-A112-9E541CD811F4}']
    procedure GetContextMenuHandler(var aHandler : IOldCefContextMenuHandler);
    procedure GetDialogHandler(var aHandler : IOldCefDialogHandler);
    procedure GetDisplayHandler(var aHandler : IOldCefDisplayHandler);
    procedure GetDownloadHandler(var aHandler : IOldCefDownloadHandler);
    procedure GetDragHandler(var aHandler : IOldCefDragHandler);
    procedure GetFindHandler(var aHandler : IOldCefFindHandler);
    procedure GetFocusHandler(var aHandler : IOldCefFocusHandler);
    procedure GetGeolocationHandler(var aHandler : IOldCefGeolocationHandler);
    procedure GetJsdialogHandler(var aHandler : IOldCefJsDialogHandler);
    procedure GetKeyboardHandler(var aHandler : IOldCefKeyboardHandler);
    procedure GetLifeSpanHandler(var aHandler : IOldCefLifeSpanHandler);
    procedure GetLoadHandler(var aHandler : IOldCefLoadHandler);
    procedure GetRenderHandler(var aHandler : IOldCefRenderHandler);
    procedure GetRequestHandler(var aHandler : IOldCefRequestHandler);
    function  OnProcessMessageReceived(const browser: IOldCefBrowser; sourceProcess: TOldCefProcessId; const message_ : IOldCefProcessMessage): Boolean;

    procedure RemoveReferences; // custom procedure to clear all references
  end;

  // TOldCefUrlRequest
  // /include/capi/cef_urlrequest_capi.h (cef_urlrequest_t)
  IOldCefUrlRequest = interface(IOldCefBase)
    ['{59226AC1-A0FA-4D59-9DF4-A65C42391A67}']
    function  GetRequest: IOldCefRequest;
    function  GetRequestStatus: TOldCefUrlRequestStatus;
    function  GetRequestError: Integer;
    function  GetResponse: IOldCefResponse;
    procedure Cancel;

    property Request           : IOldCefRequest           read GetRequest;
    property RequestStatus     : TOldCefUrlRequestStatus  read GetRequestStatus;
    property RequestError      : Integer               read GetRequestError;
    property Response          : IOldCefResponse          read GetResponse;
  end;

  // TOldCefUrlrequestClient
  // /include/capi/cef_urlrequest_capi.h (cef_urlrequest_client_t)
  IOldCefUrlrequestClient = interface(IOldCefBase)
    ['{114155BD-C248-4651-9A4F-26F3F9A4F737}']
    procedure OnRequestComplete(const request: IOldCefUrlRequest);
    procedure OnUploadProgress(const request: IOldCefUrlRequest; current, total: Int64);
    procedure OnDownloadProgress(const request: IOldCefUrlRequest; current, total: Int64);
    procedure OnDownloadData(const request: IOldCefUrlRequest; data: Pointer; dataLength: NativeUInt);
    function  OnGetAuthCredentials(isProxy: Boolean; const host: oldustring; port: Integer; const realm, scheme: oldustring; const callback: IOldCefAuthCallback): Boolean;

    procedure RemoveReferences; // custom procedure to clear all references
  end;

  // TOldCefWebPluginInfoVisitor
  // /include/capi/cef_web_plugin_capi.h (cef_web_plugin_info_visitor_t)
  IOldCefWebPluginInfoVisitor = interface(IOldCefBase)
    ['{7523D432-4424-4804-ACAD-E67D2313436E}']
    function Visit(const info: IOldCefWebPluginInfo; count, total: Integer): Boolean;
  end;

  // TOldCefWebPluginUnstableCallback
  // /include/capi/cef_web_plugin_capi.h (cef_web_plugin_unstable_callback_t)
  IOldCefWebPluginUnstableCallback = interface(IOldCefBase)
    ['{67459829-EB47-4B7E-9D69-2EE77DF0E71E}']
    procedure IsUnstable(const path: oldustring; unstable: Boolean);
  end;

  // TOldCefEndTracingCallback
  // /include/capi/cef_trace_capi.h (cef_end_tracing_callback_t)
  IOldCefEndTracingCallback = interface(IOldCefBase)
    ['{79020EBE-9D1D-49A6-9714-8778FE8929F2}']
    procedure OnEndTracingComplete(const tracingFile: oldustring);
  end;

  // TOldCefFileDialogCallback
  // /include/capi/cef_dialog_handler_capi.h (cef_file_dialog_callback_t)
  IOldCefFileDialogCallback = interface(IOldCefBase)
    ['{1AF659AB-4522-4E39-9C52-184000D8E3C7}']
    procedure Cont(selectedAcceptFilter: Integer; const filePaths: TStrings);
    procedure Cancel;
  end;

  // TOldCefDragData
  // /include/capi/cef_drag_data_capi.h (cef_drag_data_t)
  IOldCefDragData = interface(IOldCefBase)
    ['{FBB6A487-F633-4055-AB3E-6619EDE75683}']
    function  Clone: IOldCefDragData;
    function  IsReadOnly: Boolean;
    function  IsLink: Boolean;
    function  IsFragment: Boolean;
    function  IsFile: Boolean;
    function  GetLinkUrl: oldustring;
    function  GetLinkTitle: oldustring;
    function  GetLinkMetadata: oldustring;
    function  GetFragmentText: oldustring;
    function  GetFragmentHtml: oldustring;
    function  GetFragmentBaseUrl: oldustring;
    function  GetFileName: oldustring;
    function  GetFileContents(const writer: IOldCefStreamWriter): NativeUInt;
    function  GetFileNames(var names: TStrings): Integer;
    procedure SetLinkUrl(const url: oldustring);
    procedure SetLinkTitle(const title: oldustring);
    procedure SetLinkMetadata(const data: oldustring);
    procedure SetFragmentText(const text: oldustring);
    procedure SetFragmentHtml(const html: oldustring);
    procedure SetFragmentBaseUrl(const baseUrl: oldustring);
    procedure ResetFileContents;
    procedure AddFile(const path, displayName: oldustring);
  end;

  // TOldCefDragHandler
  // /include/capi/cef_drag_handler_capi.h (cef_drag_handler_t)
  IOldCefDragHandler = interface(IOldCefBase)
    ['{59A89579-5B18-489F-A25C-5CC25FF831FC}']
    function  OnDragEnter(const browser: IOldCefBrowser; const dragData: IOldCefDragData; mask: TOldCefDragOperations): Boolean;
    procedure OnDraggableRegionsChanged(const browser: IOldCefBrowser; regionsCount: NativeUInt; regions: POldCefDraggableRegionArray);

    procedure RemoveReferences; // custom procedure to clear all references
  end;

  // TOldCefFindHandler
  // /include/capi/cef_find_handler_capi.h (cef_find_handler_t)
  IOldCefFindHandler = interface(IOldCefBase)
    ['{F20DF234-BD43-42B3-A80B-D354A9E5B787}']
    procedure OnFindResult(const browser: IOldCefBrowser; identifier, count: Integer; const selectionRect: POldCefRect; activeMatchOrdinal: Integer; finalUpdate: Boolean);

    procedure RemoveReferences; // custom procedure to clear all references
  end;

  // TOldCefRequestContextHandler
  // /include/capi/cef_request_context_handler_capi.h (cef_request_context_handler_t)
  IOldCefRequestContextHandler = interface(IOldCefBase)
    ['{76EB1FA7-78DF-4FD5-ABB3-1CDD3E73A140}']
    function  GetCookieManager: IOldCefCookieManager;
    function  OnBeforePluginLoad(const mimeType, pluginUrl : oldustring; const topOriginUrl : oldustring; const pluginInfo: IOldCefWebPluginInfo; pluginPolicy: POldCefPluginPolicy): Boolean;
  end;

  // TOldCefResolveCallback
  // /include/capi/cef_request_context_capi.h (cef_resolve_callback_t)
  IOldCefResolveCallback = interface(IOldCefBase)
    ['{0C0EA252-7968-4163-A1BE-A1453576DD06}']
    procedure OnResolveCompleted(result: TOldCefErrorCode; const resolvedIps: TStrings);
  end;

  // TOldCefRequestContext
  // /include/capi/cef_request_context_capi.h (cef_request_context_t)
  IOldCefRequestContext = interface(IOldCefBase)
    ['{5830847A-2971-4BD5-ABE6-21451F8923F7}']
    function  IsSame(const other: IOldCefRequestContext): Boolean;
    function  IsSharingWith(const other: IOldCefRequestContext): Boolean;
    function  IsGlobal: Boolean;
    function  GetHandler: IOldCefRequestContextHandler;
    function  GetCachePath: oldustring;
    function  GetDefaultCookieManager(const callback: IOldCefCompletionCallback): IOldCefCookieManager;
    function  GetDefaultCookieManagerProc(const callback: TOldCefCompletionCallbackProc): IOldCefCookieManager;
    function  RegisterSchemeHandlerFactory(const schemeName, domainName: oldustring; const factory: IOldCefSchemeHandlerFactory): Boolean;
    function  ClearSchemeHandlerFactories: Boolean;
    procedure PurgePluginListCache(reloadPages: Boolean);
    function  HasPreference(const name: oldustring): Boolean;
    function  GetPreference(const name: oldustring): IOldCefValue;
    function  GetAllPreferences(includeDefaults: Boolean): IOldCefDictionaryValue;
    function  CanSetPreference(const name: oldustring): Boolean;
    function  SetPreference(const name: oldustring; const value: IOldCefValue; out error: oldustring): Boolean;
    procedure ClearCertificateExceptions(const callback: IOldCefCompletionCallback);
    procedure CloseAllConnections(const callback: IOldCefCompletionCallback);
    procedure ResolveHost(const origin: oldustring; const callback: IOldCefResolveCallback);
    function  ResolveHostCached(const origin: oldustring; const resolvedIps: TStrings): TOldCefErrorCode;

    property  CachePath        : oldustring  read GetCachePath;
    property  IsGlobalContext  : boolean  read IsGlobal;
  end;

  // TOldCefPrintSettings
  // /include/capi/cef_print_settings_capi.h (cef_print_settings_t)
  IOldCefPrintSettings = Interface(IOldCefBase)
    ['{ACBD2395-E9C1-49E5-B7F3-344DAA4A0F12}']
    function  IsValid: Boolean;
    function  IsReadOnly: Boolean;
    function  Copy: IOldCefPrintSettings;
    procedure SetOrientation(landscape: Boolean);
    function  IsLandscape: Boolean;
    procedure SetPrinterPrintableArea(const physicalSizeDeviceUnits: POldCefSize; const printableAreaDeviceUnits: POldCefRect; landscapeNeedsFlip: Boolean);
    procedure SetDeviceName(const name: oldustring);
    function  GetDeviceName: oldustring;
    procedure SetDpi(dpi: Integer);
    function  GetDpi: Integer;
    procedure SetPageRanges(const ranges: TOldCefPageRangeArray);
    function  GetPageRangesCount: NativeUInt;
    procedure GetPageRanges(out ranges: TOldCefPageRangeArray);
    procedure SetSelectionOnly(selectionOnly: Boolean);
    function  IsSelectionOnly: Boolean;
    procedure SetCollate(collate: Boolean);
    function  WillCollate: Boolean;
    procedure SetColorModel(model: TOldCefColorModel);
    function  GetColorModel: TOldCefColorModel;
    procedure SetCopies(copies: Integer);
    function  GetCopies: Integer;
    procedure SetDuplexMode(mode: TOldCefDuplexMode);
    function  GetDuplexMode: TOldCefDuplexMode;

    property Landscape      : Boolean         read IsLandscape      write SetOrientation;
    property DeviceName     : oldustring         read GetDeviceName    write SetDeviceName;
    property Dpi            : Integer         read GetDpi           write SetDpi;
    property SelectionOnly  : Boolean         read IsSelectionOnly  write SetSelectionOnly;
    property Collate        : Boolean         read WillCollate      write SetCollate;
    property ColorModel     : TOldCefColorModel  read GetColorModel    write SetColorModel;
    property Copies         : Integer         read GetCopies        write SetCopies;
    property DuplexMode     : TOldCefDuplexMode  read GetDuplexMode    write SetDuplexMode;
  end;

  // TOldCefPrintDialogCallback
  // /include/capi/cef_print_handler_capi.h (cef_print_dialog_callback_t)
  IOldCefPrintDialogCallback = interface(IOldCefBase)
    ['{1D7FB71E-0019-4A80-95ED-91DDD019253B}']
    procedure cont(const settings: IOldCefPrintSettings);
    procedure cancel;
  end;

  // TOldCefPrintJobCallback
  // /include/capi/cef_print_handler_capi.h (cef_print_job_callback_t)
  IOldCefPrintJobCallback = interface(IOldCefBase)
    ['{5554852A-052C-464B-A868-B618C7E7E2FD}']
    procedure cont;
  end;

  // TOldCefPrintHandler
  // /include/capi/cef_print_handler_capi.h (cef_print_handler_t)
  IOldCefPrintHandler = interface(IOldCefBase)
    ['{2831D5C9-6E2B-4A30-A65A-0F4435371EFC}']
    procedure OnPrintStart(const browser: IOldCefBrowser);
    procedure OnPrintSettings(const settings: IOldCefPrintSettings; getDefaults: boolean);
    function  OnPrintDialog(hasSelection: boolean; const callback: IOldCefPrintDialogCallback): boolean;
    function  OnPrintJob(const documentName, PDFFilePath: oldustring; const callback: IOldCefPrintJobCallback): boolean;
    procedure OnPrintReset;
    function  GetPDFPaperSize(deviceUnitsPerInch: Integer): TOldCefSize;
  end;

  // TOldCefNavigationEntry
  // /include/capi/cef_navigation_entry_capi.h (cef_navigation_entry_t)
  IOldCefNavigationEntry = interface(IOldCefBase)
    ['{D17B4B37-AA45-42D9-B4E4-AAB6FE2AB297}']
    function IsValid: Boolean;
    function GetUrl: oldustring;
    function GetDisplayUrl: oldustring;
    function GetOriginalUrl: oldustring;
    function GetTitle: oldustring;
    function GetTransitionType: TOldCefTransitionType;
    function HasPostData: Boolean;
    function GetCompletionTime: TDateTime;
    function GetHttpStatusCode: Integer;

    property Url              : oldustring             read GetUrl;
    property DisplayUrl       : oldustring             read GetDisplayUrl;
    property OriginalUrl      : oldustring             read GetOriginalUrl;
    property Title            : oldustring             read GetTitle;
    property TransitionType   : TOldCefTransitionType  read GetTransitionType;
    property CompletionTime   : TDateTime           read GetCompletionTime;
    property HttpStatusCode   : Integer             read GetHttpStatusCode;
  end;

  // TOldCefSslCertPrincipal
  // /include/capi/cef_ssl_info_capi.h (cef_sslcert_principal_t)
  IOldCefSslCertPrincipal = interface(IOldCefBase)
    ['{A0B083E1-51D3-4753-9FDD-9ADF75C3E68B}']
    function  GetDisplayName: oldustring;
    function  GetCommonName: oldustring;
    function  GetLocalityName: oldustring;
    function  GetStateOrProvinceName: oldustring;
    function  GetCountryName: oldustring;
    procedure GetStreetAddresses(var addresses: TStrings);
    procedure GetOrganizationNames(var names: TStrings);
    procedure GetOrganizationUnitNames(var names: TStrings);
    procedure GetDomainComponents(var components: TStrings);
  end;

  // TOldCefSslInfo
  // /include/capi/cef_ssl_info_capi.h (cef_sslinfo_t)
  IOldCefSslInfo = interface(IOldCefBase)
    ['{67EC86BD-DE7D-453D-908F-AD15626C514F}']
    function  GetCertStatus: TOldCefCertStatus;
    function  IsCertStatusError: Boolean;
    function  IsCertStatusMinorError: Boolean;
    function  GetSubject: IOldCefSslCertPrincipal;
    function  GetIssuer: IOldCefSslCertPrincipal;
    function  GetSerialNumber: IOldCefBinaryValue;
    function  GetValidStart: TOldCefTime;
    function  GetValidExpiry: TOldCefTime;
    function  GetDerEncoded: IOldCefBinaryValue;
    function  GetPemEncoded: IOldCefBinaryValue;
    function  GetIssuerChainSize: NativeUInt;
    procedure GetDEREncodedIssuerChain(chainCount: NativeUInt; var chain : TOldCefBinaryValueArray);
    procedure GetPEMEncodedIssuerChain(chainCount: NativeUInt; var chain : TOldCefBinaryValueArray);
  end;

  // TOldCefResourceBundle
  // /include/capi/cef_resource_bundle_capi.h (cef_resource_bundle_t)
  IOldCefResourceBundle = interface(IOldCefBase)
    ['{3213CF97-C854-452B-B615-39192F8D07DC}']
    function GetLocalizedString(stringId: Integer): oldustring;
    function GetDataResource(resourceId: Integer; var data: Pointer; var dataSize: NativeUInt): Boolean;
    function GetDataResourceForScale(resourceId: Integer; scaleFactor: TOldCefScaleFactor; var data: Pointer; var dataSize: NativeUInt): Boolean;
  end;

  // TOldCefSchemeRegistrar
  // /include/capi/cef_scheme_capi.h (cef_scheme_registrar_t)
  IOldCefSchemeRegistrar = interface(IOldCefBase)
    ['{1832FF6E-100B-4E8B-B996-AD633168BEE7}']
    function AddCustomScheme(const schemeName: oldustring; IsStandard, IsLocal, IsDisplayIsolated: Boolean): Boolean; stdcall;
  end;

implementation

end.
