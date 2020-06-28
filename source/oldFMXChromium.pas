// ************************************************************************
// ***************************** OldCEF4Delphi *******************************
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

unit oldFMXChromium;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  System.Classes, System.Types,
  {$IFDEF MSWINDOWS}
  WinApi.Windows, WinApi.Messages,
  {$ENDIF}
  FMX.Types, FMX.Platform, FMX.Forms,
  oldCEFTypes, oldCEFInterfaces, oldCEFLibFunctions, oldCEFMiscFunctions, oldCEFClient,
  oldCEFConstants, oldCEFTask, oldCEFChromiumEvents, oldCEFChromiumOptions, oldCEFChromiumFontOptions,
  oldCEFPDFPrintOptions;

type
  {$IFNDEF FPC}{$IFDEF DELPHI16_UP}[ComponentPlatformsAttribute(pidWin32 or pidWin64)]{$ENDIF}{$ENDIF}
  TOldFMXChromium = class(TComponent, IOldChromiumEvents)
    protected
      FHandler                : IOldCefClient;
      FBrowser                : IOldCefBrowser;
      FBrowserId              : Integer;
      FDefaultUrl             : oldustring;
      FOptions                : TOldChromiumOptions;
      FFontOptions            : TOldChromiumFontOptions;
      FPDFPrintOptions        : TOldPDFPrintOptions;
      FDefaultEncoding        : oldustring;
      FProxyType              : integer;
      FProxyScheme            : TOldCefProxyScheme;
      FProxyServer            : string;
      FProxyPort              : integer;
      FProxyUsername          : string;
      FProxyPassword          : string;
      FProxyScriptURL         : string;
      FProxyByPassList        : string;
      FUpdatePreferences      : boolean;
      FCustomHeaderName       : string;
      FCustomHeaderValue      : string;
      FAddCustomHeader        : boolean;
      FDoNotTrack             : boolean;
      FSendReferrer           : boolean;
      FHyperlinkAuditing      : boolean;
      FRunAllFlashInAllowMode : boolean;
      FAllowOutdatedPlugins   : boolean;
      FAlwaysAuthorizePlugins : boolean;
      FSpellChecking          : boolean;
      FSpellCheckerDicts      : string;
      FCookiePrefs            : integer;
      FImagesPrefs            : integer;
      FZoomStep               : byte;
      FWindowName             : string;
      FPrefsFileName          : string;
      FIsOSR                  : boolean;
      FInitialized            : boolean;
      FClosing                : boolean;
      FWindowInfo             : TOldCefWindowInfo;
      FBrowserSettings        : TOldCefBrowserSettings;
      FDevWindowInfo          : TOldCefWindowInfo;
      FDevBrowserSettings     : TOldCefBrowserSettings;
      FDragOperations         : TOldCefDragOperations;
      FDragAndDropInitialized : boolean;
      FWebRTCIPHandlingPolicy : TOldCefWebRTCHandlingPolicy;
      FWebRTCMultipleRoutes   : TOldCefState;
      FWebRTCNonProxiedUDP    : TOldCefState;

      {$IFDEF MSWINDOWS}
      FOldBrowserCompWndPrc   : TFNWndProc;
      FOldWidgetCompWndPrc    : TFNWndProc;
      FOldRenderCompWndPrc    : TFNWndProc;
      FBrowserCompHWND        : THandle;
      FWidgetCompHWND         : THandle;
      FRenderCompHWND         : THandle;
      FBrowserCompStub        : Pointer;
      FWidgetCompStub         : Pointer;
      FRenderCompStub         : Pointer;
      {$ENDIF}

      // IOldCefClient
      FOnProcessMessageReceived       : TOnProcessMessageReceived;

      // IOldCefLoadHandler
      FOnLoadStart                    : TOnLoadStart;
      FOnLoadEnd                      : TOnLoadEnd;
      FOnLoadError                    : TOnLoadError;
      FOnLoadingStateChange           : TOnLoadingStateChange;

      // IOldCefFocusHandler
      FOnTakeFocus                    : TOnTakeFocus;
      FOnSetFocus                     : TOnSetFocus;
      FOnGotFocus                     : TOnGotFocus;

      // IOldCefContextMenuHandler
      FOnBeforeContextMenu            : TOnBeforeContextMenu;
      FOnRunContextMenu               : TOnRunContextMenu;
      FOnContextMenuCommand           : TOnContextMenuCommand;
      FOnContextMenuDismissed         : TOnContextMenuDismissed;

      // IOldCefKeyboardHandler
      FOnPreKeyEvent                  : TOnPreKeyEvent;
      FOnKeyEvent                     : TOnKeyEvent;

      // IOldCefDisplayHandler
      FOnAddressChange                : TOnAddressChange;
      FOnTitleChange                  : TOnTitleChange;
      FOnFavIconUrlChange             : TOnFavIconUrlChange;
      FOnFullScreenModeChange         : TOnFullScreenModeChange;
      FOnTooltip                      : TOnTooltip;
      FOnStatusMessage                : TOnStatusMessage;
      FOnConsoleMessage               : TOnConsoleMessage;

      // IOldCefDownloadHandler
      FOnBeforeDownload               : TOnBeforeDownload;
      FOnDownloadUpdated              : TOnDownloadUpdated;

      // IOldCefGeolocationHandler
      FOnRequestGeolocationPermission : TOnRequestGeolocationPermission;
      FOnCancelGeolocationPermission  : TOnCancelGeolocationPermission;

      // IOldCefJsDialogHandler
      FOnJsdialog                     : TOnJsdialog;
      FOnBeforeUnloadDialog           : TOnBeforeUnloadDialog;
      FOnResetDialogState             : TOnResetDialogState;
      FOnDialogClosed                 : TOnDialogClosed;

      // IOldCefLifeSpanHandler
      FOnBeforePopup                  : TOnBeforePopup;
      FOnAfterCreated                 : TOnAfterCreated;
      FOnRunModal                     : TOnRunModal;
      FOnBeforeClose                  : TOnBeforeClose;
      FOnClose                        : TOnClose;

      // IOldCefRequestHandler
      FOnBeforeBrowse                 : TOnBeforeBrowse;
      FOnOpenUrlFromTab               : TOnOpenUrlFromTab;
      FOnBeforeResourceLoad           : TOnBeforeResourceLoad;
      FOnGetResourceHandler           : TOnGetResourceHandler;
      FOnResourceRedirect             : TOnResourceRedirect;
      FOnResourceResponse             : TOnResourceResponse;
      FOnGetResourceResponseFilter    : TOnGetResourceResponseFilter;
      FOnResourceLoadComplete         : TOnResourceLoadComplete;
      FOnGetAuthCredentials           : TOnGetAuthCredentials;
      FOnQuotaRequest                 : TOnQuotaRequest;
      FOnProtocolExecution            : TOnProtocolExecution;
      FOnCertificateError             : TOnCertificateError;
      FOnPluginCrashed                : TOnPluginCrashed;
      FOnRenderViewReady              : TOnRenderViewReady;
      FOnRenderProcessTerminated      : TOnRenderProcessTerminated;

      // IOldCefDialogHandler
      FOnFileDialog                   : TOnFileDialog;

      // IOldCefRenderHandler
      FOnGetRootScreenRect            : TOnGetRootScreenRect;
      FOnGetViewRect                  : TOnGetViewRect;
      FOnGetScreenPoint               : TOnGetScreenPoint;
      FOnGetScreenInfo                : TOnGetScreenInfo;
      FOnPopupShow                    : TOnPopupShow;
      FOnPopupSize                    : TOnPopupSize;
      FOnPaint                        : TOnPaint;
      FOnCursorChange                 : TOnCursorChange;
      FOnScrollOffsetChanged          : TOnScrollOffsetChanged;

      // IOldCefDragHandler
      FOnDragEnter                    : TOnDragEnter;
      FOnDraggableRegionsChanged      : TOnDraggableRegionsChanged;

      // IOldCefFindHandler
      FOnFindResult                   : TOnFindResult;

      // Custom
      FOnTextResultAvailable          : TOnTextResultAvailableEvent;
      FOnPdfPrintFinished             : TOnPdfPrintFinishedEvent;
      FOnCookiesDeleted               : TOnCookiesDeletedEvent;
      FOnResolvedHostAvailable        : TOnResolvedIPsAvailableEvent;
      {$IFDEF MSWINDOWS}
      FOnBrowserCompMsg               : TOnCompMsgEvent;
      FOnWidgetCompMsg                : TOnCompMsgEvent;
      FOnRenderCompMsg                : TOnCompMsgEvent;
      {$ENDIF}

      function  GetIsLoading : boolean;
      function  GetMultithreadApp : boolean;
      function  GetHasDocument : boolean;
      function  GetHasClientHandler : boolean;
      function  GetHasBrowser : boolean;
      function  GetCanGoBack : boolean;
      function  GetCanGoForward : boolean;
      function  GetDocumentURL : string;
      function  GetZoomLevel : double;
      function  GetZoomPct : double;
      function  GetIsPopUp : boolean;
      function  GetWindowHandle : THandle;
      function  GetWindowlessFrameRate : integer;
      function  GetFrameIsFocused : boolean;
      function  GetInitialized : boolean;
      function  GetHasValidMainFrame : boolean;
      function  GetFrameCount : NativeUInt;
      function  GetRequestContextCache : string;
      function  GetRequestContextIsGlobal : boolean;

      procedure SetDoNotTrack(aValue : boolean);
      procedure SetSendReferrer(aValue : boolean);
      procedure SetHyperlinkAuditing(aValue : boolean);
      procedure SetRunAllFlashInAllowMode(aValue : boolean);
      procedure SetAllowOutdatedPlugins(aValue : boolean);
      procedure SetAlwaysAuthorizePlugins(aValue : boolean);
      procedure SetSpellChecking(aValue : boolean);
      procedure SetSpellCheckerDicts(const aValue : string);
      procedure SetWebRTCIPHandlingPolicy(aValue : TOldCefWebRTCHandlingPolicy);
      procedure SetWebRTCMultipleRoutes(aValue : TOldCefState);
      procedure SetWebRTCNonProxiedUDP(aValue : TOldCefState);
      procedure SetCookiePrefs(aValue : integer);
      procedure SetImagesPrefs(aValue : integer);
      procedure SetProxyType(aValue : integer);
      procedure SetProxyScheme(aValue : TOldCefProxyScheme);
      procedure SetProxyServer(const aValue : string);
      procedure SetProxyPort(aValue : integer);
      procedure SetProxyUsername(const aValue : string);
      procedure SetProxyPassword(const aValue : string);
      procedure SetProxyScriptURL(const aValue : string);
      procedure SetProxyByPassList(const aValue : string);
      procedure SetCustomHeaderName(const aValue : string);
      procedure SetCustomHeaderValue(const aValue : string);
      procedure SetZoomLevel(const aValue : double);
      procedure SetZoomPct(const aValue : double);
      procedure SetZoomStep(aValue : byte);
      procedure SetWindowlessFrameRate(aValue : integer);


      function  CreateBrowserHost(aWindowInfo : POldCefWindowInfo; const aURL : oldustring; const aSettings : POldCefBrowserSettings; const aContext : IOldCefRequestContext): boolean;
      function  CreateBrowserHostSync(aWindowInfo : POldCefWindowInfo; const aURL : oldustring; const aSettings : POldCefBrowserSettings; const aContext : IOldCefRequestContext): boolean;

      procedure DestroyClientHandler;

      procedure ClearBrowserReference;

      procedure InitializeEvents;
      procedure InitializeSettings(var aSettings : TOldCefBrowserSettings);

      procedure GetPrintPDFSettings(var aSettings : TOldCefPdfPrintSettings; const aTitle, aURL : string);

      function  UpdateProxyPrefs(const aBrowser: IOldCefBrowser) : boolean;
      function  UpdatePreference(const aBrowser: IOldCefBrowser; const aName : string; aValue : boolean) : boolean; overload;
      function  UpdatePreference(const aBrowser: IOldCefBrowser; const aName : string; aValue : integer) : boolean; overload;
      function  UpdatePreference(const aBrowser: IOldCefBrowser; const aName : string; const aValue : double) : boolean; overload;
      function  UpdatePreference(const aBrowser: IOldCefBrowser; const aName, aValue : string) : boolean; overload;
      function  UpdatePreference(const aBrowser: IOldCefBrowser; const aName : string; const aValue : TStringList) : boolean; overload;
      function  UpdateStringListPref(const aBrowser: IOldCefBrowser; const aName, aValue : string) : boolean;

      procedure HandleDictionary(const aDict : IOldCefDictionaryValue; var aResultSL : TStringList; const aRoot : string);
      procedure HandleNull(const aValue : IOldCefValue; var aResultSL : TStringList; const aRoot, aKey : string);
      procedure HandleBool(const aValue : IOldCefValue; var aResultSL : TStringList; const aRoot, aKey : string);
      procedure HandleInteger(const aValue : IOldCefValue; var aResultSL : TStringList; const aRoot, aKey : string);
      procedure HandleDouble(const aValue : IOldCefValue; var aResultSL : TStringList; const aRoot, aKey : string);
      procedure HandleString(const aValue : IOldCefValue; var aResultSL : TStringList; const aRoot, aKey : string);
      procedure HandleBinary(const aValue : IOldCefValue; var aResultSL : TStringList; const aRoot, aKey : string);
      procedure HandleList(const aValue : IOldCefValue; var aResultSL : TStringList; const aRoot, aKey : string);
      procedure HandleInvalid(const aValue : IOldCefValue; var aResultSL : TStringList; const aRoot, aKey : string);

      function  MustCreateLoadHandler : boolean; virtual;
      function  MustCreateFocusHandler : boolean; virtual;
      function  MustCreateContextMenuHandler : boolean; virtual;
      function  MustCreateDialogHandler : boolean; virtual;
      function  MustCreateKeyboardHandler : boolean; virtual;
      function  MustCreateDisplayHandler : boolean; virtual;
      function  MustCreateDownloadHandler : boolean; virtual;
      function  MustCreateGeolocationHandler : boolean; virtual;
      function  MustCreateJsDialogHandler : boolean; virtual;
      function  MustCreateDragHandler : boolean; virtual;
      function  MustCreateFindHandler : boolean; virtual;

      procedure ApplyZoomStep;
      function  GetParentForm : TCustomForm;

      {$IFDEF MSWINDOWS}
      procedure FreeAndNilStub(var aStub : pointer);
      procedure CreateStub(const aMethod : TWndMethod; var aStub : Pointer);
      procedure BrowserCompWndProc(var aMessage: TMessage);
      procedure WidgetCompWndProc(var aMessage: TMessage);
      procedure RenderCompWndProc(var aMessage: TMessage);
      {$ENDIF}

      // IChromiumEvents
      procedure GetSettings(var aSettings : TOldCefBrowserSettings);

      // IOldCefClient
      function  doOnProcessMessageReceived(const browser: IOldCefBrowser; sourceProcess: TOldCefProcessId; const aMessage: IOldCefProcessMessage): Boolean; virtual;

      // IOldCefLoadHandler
      procedure doOnLoadStart(const browser: IOldCefBrowser; const frame: IOldCefFrame); virtual;
      procedure doOnLoadEnd(const browser: IOldCefBrowser; const frame: IOldCefFrame; httpStatusCode: Integer); virtual;
      procedure doOnLoadError(const browser: IOldCefBrowser; const frame: IOldCefFrame; errorCode: TOldCefErrorCode; const errorText, failedUrl: oldustring); virtual;
      procedure doOnLoadingStateChange(const browser: IOldCefBrowser; isLoading, canGoBack, canGoForward: Boolean); virtual;

      // IOldCefFocusHandler
      procedure doOnTakeFocus(const browser: IOldCefBrowser; next: Boolean); virtual;
      function  doOnSetFocus(const browser: IOldCefBrowser; source: TOldCefFocusSource): Boolean; virtual;
      procedure doOnGotFocus(const browser: IOldCefBrowser); virtual;

      // IOldCefContextMenuHandler
      procedure doOnBeforeContextMenu(const browser: IOldCefBrowser; const frame: IOldCefFrame; const params: IOldCefContextMenuParams; const model: IOldCefMenuModel); virtual;
      function  doRunContextMenu(const browser: IOldCefBrowser; const frame: IOldCefFrame; const params: IOldCefContextMenuParams; const model: IOldCefMenuModel; const callback: IOldCefRunContextMenuCallback): Boolean; virtual;
      function  doOnContextMenuCommand(const browser: IOldCefBrowser; const frame: IOldCefFrame; const params: IOldCefContextMenuParams; commandId: Integer; eventFlags: TOldCefEventFlags): Boolean; virtual;
      procedure doOnContextMenuDismissed(const browser: IOldCefBrowser; const frame: IOldCefFrame); virtual;

      // IOldCefKeyboardHandler
      function  doOnPreKeyEvent(const browser: IOldCefBrowser; const event: POldCefKeyEvent; osEvent: TOldCefEventHandle; out isKeyboardShortcut: Boolean): Boolean; virtual;
      function  doOnKeyEvent(const browser: IOldCefBrowser; const event: POldCefKeyEvent; osEvent: TOldCefEventHandle): Boolean; virtual;

      // IOldCefDisplayHandler
      procedure doOnAddressChange(const browser: IOldCefBrowser; const frame: IOldCefFrame; const url: oldustring); virtual;
      procedure doOnTitleChange(const browser: IOldCefBrowser; const title: oldustring); virtual;
      procedure doOnFaviconUrlChange(const browser: IOldCefBrowser; const iconUrls: TStrings); virtual;
      procedure doOnFullScreenModeChange(const browser: IOldCefBrowser; fullscreen: Boolean); virtual;
      function  doOnTooltip(const browser: IOldCefBrowser; var text: oldustring): Boolean; virtual;
      procedure doOnStatusMessage(const browser: IOldCefBrowser; const value: oldustring); virtual;
      function  doOnConsoleMessage(const browser: IOldCefBrowser; const aMessage, source: oldustring; line: Integer): Boolean; virtual;

      // IOldCefDownloadHandler
      procedure doOnBeforeDownload(const browser: IOldCefBrowser; const downloadItem: IOldCefDownloadItem; const suggestedName: oldustring; const callback: IOldCefBeforeDownloadCallback); virtual;
      procedure doOnDownloadUpdated(const browser: IOldCefBrowser; const downloadItem: IOldCefDownloadItem; const callback: IOldCefDownloadItemCallback); virtual;

      // IOldCefGeolocationHandler
      function  doOnRequestGeolocationPermission(const browser: IOldCefBrowser; const requestingUrl: oldustring; requestId: Integer; const callback: IOldCefGeolocationCallback): Boolean; virtual;
      procedure doOnCancelGeolocationPermission(const browser: IOldCefBrowser; requestId: Integer); virtual;

      // IOldCefJsDialogHandler
      function  doOnJsdialog(const browser: IOldCefBrowser; const originUrl, accept_lang: oldustring; dialogType: TOldCefJsDialogType; const messageText, defaultPromptText: oldustring; const callback: IOldCefJsDialogCallback; out suppressMessage: Boolean): Boolean; virtual;
      function  doOnBeforeUnloadDialog(const browser: IOldCefBrowser; const messageText: oldustring; isReload: Boolean; const callback: IOldCefJsDialogCallback): Boolean; virtual;
      procedure doOnResetDialogState(const browser: IOldCefBrowser); virtual;
      procedure doOnDialogClosed(const browser: IOldCefBrowser); virtual;

      // IOldCefLifeSpanHandler
      function  doOnBeforePopup(const browser: IOldCefBrowser; const frame: IOldCefFrame; const targetUrl, targetFrameName: oldustring; targetDisposition: TOldCefWindowOpenDisposition; userGesture: Boolean; const popupFeatures: TOldCefPopupFeatures; var windowInfo: TOldCefWindowInfo; var client: IOldCefClient; var settings: TOldCefBrowserSettings; var noJavascriptAccess: Boolean): Boolean; virtual;
      procedure doOnAfterCreated(const browser: IOldCefBrowser); virtual;
      function  doRunModal(const browser: IOldCefBrowser): Boolean; virtual;
      procedure doOnBeforeClose(const browser: IOldCefBrowser); virtual;
      function  doOnClose(const browser: IOldCefBrowser): Boolean; virtual;

      // IOldCefRequestHandler
      function  doOnBeforeBrowse(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; isRedirect: Boolean): Boolean; virtual;
      function  doOnOpenUrlFromTab(const browser: IOldCefBrowser; const frame: IOldCefFrame; const targetUrl: oldustring; targetDisposition: TOldCefWindowOpenDisposition; userGesture: Boolean): Boolean; virtual;
      function  doOnBeforeResourceLoad(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; const callback: IOldCefRequestCallback): TOldCefReturnValue; virtual;
      function  doOnGetResourceHandler(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest): IOldCefResourceHandler; virtual;
      procedure doOnResourceRedirect(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; var newUrl: oldustring); virtual;
      function  doOnResourceResponse(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; const response: IOldCefResponse): Boolean; virtual;
      function  doOnGetResourceResponseFilter(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; const response: IOldCefResponse): IOldCefResponseFilter; virtual;
      procedure doOnResourceLoadComplete(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; const response: IOldCefResponse; status: TOldCefUrlRequestStatus; receivedContentLength: Int64); virtual;
      function  doOnGetAuthCredentials(const browser: IOldCefBrowser; const frame: IOldCefFrame; isProxy: Boolean; const host: oldustring; port: Integer; const realm, scheme: oldustring; const callback: IOldCefAuthCallback): Boolean; virtual;
      function  doOnQuotaRequest(const browser: IOldCefBrowser; const originUrl: oldustring; newSize: Int64; const callback: IOldCefRequestCallback): Boolean; virtual;
      procedure doOnProtocolExecution(const browser: IOldCefBrowser; const url: oldustring; out allowOsExecution: Boolean); virtual;
      function  doOnCertificateError(const browser: IOldCefBrowser; certError: TOldCefErrorcode; const requestUrl: oldustring; const sslInfo: IOldCefSslInfo; const callback: IOldCefRequestCallback): Boolean; virtual;
      procedure doOnPluginCrashed(const browser: IOldCefBrowser; const pluginPath: oldustring); virtual;
      procedure doOnRenderViewReady(const browser: IOldCefBrowser); virtual;
      procedure doOnRenderProcessTerminated(const browser: IOldCefBrowser; status: TOldCefTerminationStatus); virtual;

      // IOldCefDialogHandler
      function  doOnFileDialog(const browser: IOldCefBrowser; mode: TOldCefFileDialogMode; const title, defaultFilePath: oldustring; const acceptFilters: TStrings; selectedAcceptFilter: Integer; const callback: IOldCefFileDialogCallback): Boolean; virtual;

      // IOldCefRenderHandler
      function  doOnGetRootScreenRect(const browser: IOldCefBrowser; var rect: TOldCefRect): Boolean; virtual;
      function  doOnGetViewRect(const browser: IOldCefBrowser; var rect: TOldCefRect): Boolean; virtual;
      function  doOnGetScreenPoint(const browser: IOldCefBrowser; viewX, viewY: Integer; var screenX, screenY: Integer): Boolean; virtual;
      function  doOnGetScreenInfo(const browser: IOldCefBrowser; var screenInfo: TOldCefScreenInfo): Boolean; virtual;
      procedure doOnPopupShow(const browser: IOldCefBrowser; show: Boolean); virtual;
      procedure doOnPopupSize(const browser: IOldCefBrowser; const rect: POldCefRect); virtual;
      procedure doOnPaint(const browser: IOldCefBrowser; kind: TOldCefPaintElementType; dirtyRectsCount: NativeUInt; const dirtyRects: POldCefRectArray; const buffer: Pointer; width, height: Integer); virtual;
      procedure doOnCursorChange(const browser: IOldCefBrowser; cursor: TOldCefCursorHandle; cursorType: TOldCefCursorType; const customCursorInfo: POldCefCursorInfo); virtual;
      function  doOnStartDragging(const browser: IOldCefBrowser; const dragData: IOldCefDragData; allowedOps: TOldCefDragOperations; x, y: Integer): Boolean; virtual;
      procedure doOnUpdateDragCursor(const browser: IOldCefBrowser; operation: TOldCefDragOperation); virtual;
      procedure doOnScrollOffsetChanged(const browser: IOldCefBrowser; x, y: Double); virtual;

      // IOldCefDragHandler
      function  doOnDragEnter(const browser: IOldCefBrowser; const dragData: IOldCefDragData; mask: TOldCefDragOperations): Boolean; virtual;
      procedure doOnDraggableRegionsChanged(const browser: IOldCefBrowser; regionsCount: NativeUInt; regions: POldCefDraggableRegionArray); virtual;

      // IOldCefFindHandler
      procedure doOnFindResult(const browser: IOldCefBrowser; identifier, count: Integer; const selectionRect: POldCefRect; activeMatchOrdinal: Integer; finalUpdate: Boolean); virtual;

      // Custom
      procedure doCookiesDeleted(numDeleted : integer); virtual;
      procedure doPdfPrintFinished(aResultOK : boolean); virtual;
      procedure doTextResultAvailable(const aText : string); virtual;
      procedure doUpdatePreferences(const aBrowser: IOldCefBrowser); virtual;
      procedure doUpdateOwnPreferences; virtual;
      function  doSavePreferences : boolean; virtual;
      procedure doResolvedHostAvailable(result: TOldCefErrorCode; const resolvedIps: TStrings); virtual;

    public
      constructor Create(AOwner: TComponent); override;
      destructor  Destroy; override;
      procedure   AfterConstruction; override;
      procedure   BeforeDestruction; override;
      function    CreateClientHandler(aIsOSR : boolean = True) : boolean; overload;
      function    CreateClientHandler(var aClient : IOldCefClient; aIsOSR : boolean = True) : boolean; overload;
      procedure   CloseBrowser(aForceClose : boolean);
      function    ShareRequestContext(var aContext : IOldCefRequestContext; const aHandler : IOldCefRequestContextHandler = nil) : boolean;
      function    CreateBrowser(const aWindowName : string = ''; const aContext : IOldCefRequestContext = nil; const aCookiesPath : string = ''; aPersistSessionCookies : boolean = False) : boolean; overload; virtual;
      {$IFDEF MSWINDOWS}
      function    CreateBrowser(aParentHandle : HWND; aParentRect : TRect; const aWindowName : string = ''; const aContext : IOldCefRequestContext = nil; const aCookiesPath : string = ''; aPersistSessionCookies : boolean = False) : boolean; overload; virtual;
      {$ENDIF}

      procedure   LoadURL(const aURL : oldustring; const aFrameName : oldustring = ''); overload;
      procedure   LoadURL(const aURL : oldustring; const aFrame : IOldCefFrame); overload;
      procedure   LoadURL(const aURL : oldustring; const aFrameIdentifier : int64); overload;
      procedure   LoadString(const aString : oldustring; const aURL : oldustring = '');
      procedure   LoadRequest(const aRequest: IOldCefRequest);

      procedure   GoBack;
      procedure   GoForward;
      procedure   Reload;
      procedure   ReloadIgnoreCache;
      procedure   StopLoad;
      procedure   StartDownload(const aURL : oldustring);

      procedure   SimulateMouseWheel(aDeltaX, aDeltaY : integer);
      function    DeleteCookies : boolean;
      procedure   RetrieveHTML(const aFrameName : oldustring = ''); overload;
      procedure   RetrieveHTML(const aFrame : IOldCefFrame); overload;
      procedure   RetrieveHTML(const aFrameIdentifier : int64); overload;
      procedure   RetrieveText(const aFrameName : oldustring = ''); overload;
      procedure   RetrieveText(const aFrame : IOldCefFrame); overload;
      procedure   RetrieveText(const aFrameIdentifier : int64); overload;
      function    GetFrameNames(var aFrameNames : TStrings) : boolean;
      function    GetFrameIdentifiers(var aFrameCount : NativeUInt; var aFrameIdentifierArray : TOldCefFrameIdentifierArray) : boolean;
      procedure   ExecuteJavaScript(const aCode, aScriptURL : oldustring; const aFrameName : oldustring = ''; aStartLine : integer = 0); overload;
      procedure   ExecuteJavaScript(const aCode, aScriptURL : oldustring; const aFrame : IOldCefFrame; aStartLine : integer = 0); overload;
      procedure   ExecuteJavaScript(const aCode, aScriptURL : oldustring; const aFrameIdentifier : int64; aStartLine : integer = 0); overload;
      procedure   UpdatePreferences;
      procedure   SavePreferences(const aFileName : string);
      procedure   ResolveHost(const aURL : oldustring);
      function    IsSameBrowser(const aBrowser : IOldCefBrowser) : boolean;

      procedure   Find(aIdentifier : integer; const aSearchText : oldustring; aForward, aMatchCase, aFindNext : Boolean);
      procedure   StopFinding(aClearSelection : Boolean);

      procedure   Print;
      procedure   PrintToPDF(const aFilePath, aTitle, aURL : oldustring);

      procedure   ClipboardCopy;
      procedure   ClipboardPaste;
      procedure   ClipboardCut;
      procedure   ClipboardUndo;
      procedure   ClipboardRedo;
      procedure   ClipboardDel;
      procedure   SelectAll;

      procedure   IncZoomStep;
      procedure   DecZoomStep;
      procedure   ResetZoomStep;

      procedure   MoveFormTo(const x, y: Integer);
      procedure   MoveFormBy(const x, y: Integer);
      procedure   ResizeFormWidthTo(const x : Integer);
      procedure   ResizeFormHeightTo(const y : Integer);
      procedure   SetFormLeftTo(const x : Integer);
      procedure   SetFormTopTo(const y : Integer);

      procedure   WasResized;
      procedure   WasHidden(hidden: Boolean);
      procedure   NotifyScreenInfoChanged;
      procedure   NotifyMoveOrResizeStarted;
      procedure   Invalidate(kind: TOldCefPaintElementType = PET_VIEW);
      procedure   SendKeyEvent(const event: POldCefKeyEvent);
      procedure   SendMouseClickEvent(const event: POldCefMouseEvent; kind: TOldCefMouseButtonType; mouseUp: Boolean; clickCount: Integer);
      procedure   SendMouseMoveEvent(const event: POldCefMouseEvent; mouseLeave: Boolean);
      procedure   SendMouseWheelEvent(const event: POldCefMouseEvent; deltaX, deltaY: Integer);
      procedure   SendFocusEvent(setFocus: Boolean);
      procedure   SendCaptureLostEvent;
      function    SendProcessMessage(targetProcess: TOldCefProcessId; const ProcMessage: IOldCefProcessMessage): Boolean;
      procedure   SetFocus(focus: Boolean);

      procedure   DragTargetDragEnter(const dragData: IOldCefDragData; const event: POldCefMouseEvent; allowedOps: TOldCefDragOperations);
      procedure   DragTargetDragOver(const event: POldCefMouseEvent; allowedOps: TOldCefDragOperations);
      procedure   DragTargetDragLeave;
      procedure   DragTargetDrop(event: POldCefMouseEvent);
      procedure   DragSourceEndedAt(x, y: Integer; op: TOldCefDragOperation);
      procedure   DragSourceSystemDragEnded;


      property  DefaultUrl              : oldustring                   read FDefaultUrl               write FDefaultUrl;
      property  Options                 : TOldChromiumOptions          read FOptions                  write FOptions;
      property  FontOptions             : TOldChromiumFontOptions      read FFontOptions              write FFontOptions;
      property  PDFPrintOptions         : TOldPDFPrintOptions          read FPDFPrintOptions          write FPDFPrintOptions;
      property  DefaultEncoding         : oldustring                   read FDefaultEncoding          write FDefaultEncoding;
      property  BrowserId               : integer                      read FBrowserId;
      property  Browser                 : IOldCefBrowser               read FBrowser;
      property  CefClient               : IOldCefClient                read FHandler;
      property  CefWindowInfo           : TOldCefWindowInfo            read FWindowInfo;
      property  MultithreadApp          : boolean                      read GetMultithreadApp;
      property  IsLoading               : boolean                      read GetIsLoading;
      property  HasDocument             : boolean                      read GetHasDocument;
      property  HasClientHandler        : boolean                      read GetHasClientHandler;
      property  HasBrowser              : boolean                      read GetHasBrowser;
      property  CanGoBack               : boolean                      read GetCanGoBack;
      property  CanGoForward            : boolean                      read GetCanGoForward;
      property  IsPopUp                 : boolean                      read GetIsPopUp;
      property  WindowHandle            : THandle                      read GetWindowHandle;
      property  BrowserHandle           : THandle                      read FBrowserCompHWND;
      property  WidgetHandle            : THandle                      read FWidgetCompHWND;
      property  RenderHandle            : THandle                      read FRenderCompHWND;
      property  FrameIsFocused          : boolean                      read GetFrameIsFocused;
      property  Initialized             : boolean                      read GetInitialized;
      property  RequestContextCache     : string                       read GetRequestContextCache;
      property  RequestContextIsGlobal  : boolean                      read GetRequestContextIsGlobal;
      property  CookiePrefs             : integer                      read FCookiePrefs              write SetCookiePrefs;
      property  ImagesPrefs             : integer                      read FImagesPrefs              write SetImagesPrefs;
      property  DocumentURL             : string                       read GetDocumentURL;
      property  WindowName              : string                       read FWindowName               write FWindowName;
      property  ZoomLevel               : double                       read GetZoomLevel              write SetZoomLevel;
      property  ZoomPct                 : double                       read GetZoomPct                write SetZoomPct;
      property  ZoomStep                : byte                         read FZoomStep                 write SetZoomStep;
      property  WindowlessFrameRate     : integer                      read GetWindowlessFrameRate    write SetWindowlessFrameRate;
      property  CustomHeaderName        : string                       read FCustomHeaderName         write SetCustomHeaderName;
      property  CustomHeaderValue       : string                       read FCustomHeaderValue        write SetCustomHeaderValue;
      property  DoNotTrack              : boolean                      read FDoNotTrack               write SetDoNotTrack;
      property  SendReferrer            : boolean                      read FSendReferrer             write SetSendReferrer;
      property  HyperlinkAuditing       : boolean                      read FHyperlinkAuditing        write SetHyperlinkAuditing;
      property  RunAllFlashInAllowMode  : boolean                      read FRunAllFlashInAllowMode   write SetRunAllFlashInAllowMode;
      property  AllowOutdatedPlugins    : boolean                      read FAllowOutdatedPlugins     write SetAllowOutdatedPlugins;
      property  AlwaysAuthorizePlugins  : boolean                      read FAlwaysAuthorizePlugins   write SetAlwaysAuthorizePlugins;
      property  SpellChecking           : boolean                      read FSpellChecking            write SetSpellChecking;
      property  SpellCheckerDicts       : string                       read FSpellCheckerDicts        write SetSpellCheckerDicts;
      property  HasValidMainFrame       : boolean                      read GetHasValidMainFrame;
      property  FrameCount              : NativeUInt                   read GetFrameCount;
      property  DragOperations          : TOldCefDragOperations           read FDragOperations           write FDragOperations;

      property  WebRTCIPHandlingPolicy  : TOldCefWebRTCHandlingPolicy     read FWebRTCIPHandlingPolicy   write SetWebRTCIPHandlingPolicy;
      property  WebRTCMultipleRoutes    : TOldCefState                    read FWebRTCMultipleRoutes     write SetWebRTCMultipleRoutes;
      property  WebRTCNonproxiedUDP     : TOldCefState                    read FWebRTCNonProxiedUDP      write SetWebRTCNonProxiedUDP;

      property  ProxyType               : integer                      read FProxyType                write SetProxyType;
      property  ProxyScheme             : TOldCefProxyScheme              read FProxyScheme              write SetProxyScheme;
      property  ProxyServer             : string                       read FProxyServer              write SetProxyServer;
      property  ProxyPort               : integer                      read FProxyPort                write SetProxyPort;
      property  ProxyUsername           : string                       read FProxyUsername            write SetProxyUsername;
      property  ProxyPassword           : string                       read FProxyPassword            write SetProxyPassword;
      property  ProxyScriptURL          : string                       read FProxyScriptURL           write SetProxyScriptURL;
      property  ProxyByPassList         : string                       read FProxyByPassList          write SetProxyByPassList;

    published
      property  OnTextResultAvailable   : TOnTextResultAvailableEvent  read FOnTextResultAvailable    write FOnTextResultAvailable;
      property  OnPdfPrintFinished      : TOnPdfPrintFinishedEvent     read FOnPdfPrintFinished       write FOnPdfPrintFinished;
      property  OnCookiesDeleted        : TOnCookiesDeletedEvent       read FOnCookiesDeleted         write FOnCookiesDeleted;
      property  OnResolvedHostAvailable : TOnResolvedIPsAvailableEvent read FOnResolvedHostAvailable  write FOnResolvedHostAvailable;
      {$IFDEF MSWINDOWS}
      property  OnBrowserCompMsg        : TOnCompMsgEvent              read FOnBrowserCompMsg         write FOnBrowserCompMsg;
      property  OnWidgetCompMsg         : TOnCompMsgEvent              read FOnWidgetCompMsg          write FOnWidgetCompMsg;
      property  OnRenderCompMsg         : TOnCompMsgEvent              read FOnRenderCompMsg          write FOnRenderCompMsg;
      {$ENDIF}

      // IOldCefClient
      property OnProcessMessageReceived         : TOnProcessMessageReceived         read FOnProcessMessageReceived         write FOnProcessMessageReceived;

      // IOldCefLoadHandler
      property OnLoadStart                      : TOnLoadStart                      read FOnLoadStart                      write FOnLoadStart;
      property OnLoadEnd                        : TOnLoadEnd                        read FOnLoadEnd                        write FOnLoadEnd;
      property OnLoadError                      : TOnLoadError                      read FOnLoadError                      write FOnLoadError;
      property OnLoadingStateChange             : TOnLoadingStateChange             read FOnLoadingStateChange             write FOnLoadingStateChange;

      // IOldCefFocusHandler
      property OnTakeFocus                      : TOnTakeFocus                      read FOnTakeFocus                      write FOnTakeFocus;
      property OnSetFocus                       : TOnSetFocus                       read FOnSetFocus                       write FOnSetFocus;
      property OnGotFocus                       : TOnGotFocus                       read FOnGotFocus                       write FOnGotFocus;

      // IOldCefContextMenuHandler
      property OnBeforeContextMenu              : TOnBeforeContextMenu              read FOnBeforeContextMenu              write FOnBeforeContextMenu;
      property OnRunContextMenu                 : TOnRunContextMenu                 read FOnRunContextMenu                 write FOnRunContextMenu;
      property OnContextMenuCommand             : TOnContextMenuCommand             read FOnContextMenuCommand             write FOnContextMenuCommand;
      property OnContextMenuDismissed           : TOnContextMenuDismissed           read FOnContextMenuDismissed           write FOnContextMenuDismissed;

      // IOldCefKeyboardHandler
      property OnPreKeyEvent                    : TOnPreKeyEvent                    read FOnPreKeyEvent                    write FOnPreKeyEvent;
      property OnKeyEvent                       : TOnKeyEvent                       read FOnKeyEvent                       write FOnKeyEvent;

      // IOldCefDisplayHandler
      property OnAddressChange                  : TOnAddressChange                  read FOnAddressChange                  write FOnAddressChange;
      property OnTitleChange                    : TOnTitleChange                    read FOnTitleChange                    write FOnTitleChange;
      property OnFavIconUrlChange               : TOnFavIconUrlChange               read FOnFavIconUrlChange               write FOnFavIconUrlChange;
      property OnFullScreenModeChange           : TOnFullScreenModeChange           read FOnFullScreenModeChange           write FOnFullScreenModeChange;
      property OnTooltip                        : TOnTooltip                        read FOnTooltip                        write FOnTooltip;
      property OnStatusMessage                  : TOnStatusMessage                  read FOnStatusMessage                  write FOnStatusMessage;
      property OnConsoleMessage                 : TOnConsoleMessage                 read FOnConsoleMessage                 write FOnConsoleMessage;

      // IOldCefDownloadHandler
      property OnBeforeDownload                 : TOnBeforeDownload                 read FOnBeforeDownload                 write FOnBeforeDownload;
      property OnDownloadUpdated                : TOnDownloadUpdated                read FOnDownloadUpdated                write FOnDownloadUpdated;

      // IOldCefGeolocationHandler
      property OnRequestGeolocationPermission   : TOnRequestGeolocationPermission   read FOnRequestGeolocationPermission   write FOnRequestGeolocationPermission;
      property OnCancelGeolocationPermission    : TOnCancelGeolocationPermission    read FOnCancelGeolocationPermission    write FOnCancelGeolocationPermission;

      // IOldCefJsDialogHandler
      property OnJsdialog                       : TOnJsdialog                       read FOnJsdialog                       write FOnJsdialog;
      property OnBeforeUnloadDialog             : TOnBeforeUnloadDialog             read FOnBeforeUnloadDialog             write FOnBeforeUnloadDialog;
      property OnResetDialogState               : TOnResetDialogState               read FOnResetDialogState               write FOnResetDialogState;
      property OnDialogClosed                   : TOnDialogClosed                   read FOnDialogClosed                   write FOnDialogClosed;

      // IOldCefLifeSpanHandler
      property OnBeforePopup                    : TOnBeforePopup                    read FOnBeforePopup                    write FOnBeforePopup;
      property OnAfterCreated                   : TOnAfterCreated                   read FOnAfterCreated                   write FOnAfterCreated;
      property OnRunModal                       : TOnRunModal                       read FOnRunModal                       write FOnRunModal;
      property OnBeforeClose                    : TOnBeforeClose                    read FOnBeforeClose                    write FOnBeforeClose;
      property OnClose                          : TOnClose                          read FOnClose                          write FOnClose;

      // IOldCefRequestHandler
      property OnBeforeBrowse                   : TOnBeforeBrowse                   read FOnBeforeBrowse                   write FOnBeforeBrowse;
      property OnOpenUrlFromTab                 : TOnOpenUrlFromTab                 read FOnOpenUrlFromTab                 write FOnOpenUrlFromTab;
      property OnBeforeResourceLoad             : TOnBeforeResourceLoad             read FOnBeforeResourceLoad             write FOnBeforeResourceLoad;
      property OnGetResourceHandler             : TOnGetResourceHandler             read FOnGetResourceHandler             write FOnGetResourceHandler;
      property OnResourceRedirect               : TOnResourceRedirect               read FOnResourceRedirect               write FOnResourceRedirect;
      property OnResourceResponse               : TOnResourceResponse               read FOnResourceResponse               write FOnResourceResponse;
      property OnGetResourceResponseFilter      : TOnGetResourceResponseFilter      read FOnGetResourceResponseFilter      write FOnGetResourceResponseFilter;
      property OnResourceLoadComplete           : TOnResourceLoadComplete           read FOnResourceLoadComplete           write FOnResourceLoadComplete;
      property OnGetAuthCredentials             : TOnGetAuthCredentials             read FOnGetAuthCredentials             write FOnGetAuthCredentials;
      property OnQuotaRequest                   : TOnQuotaRequest                   read FOnQuotaRequest                   write FOnQuotaRequest;
      property OnProtocolExecution              : TOnProtocolExecution              read FOnProtocolExecution              write FOnProtocolExecution;
      property OnCertificateError               : TOnCertificateError               read FOnCertificateError               write FOnCertificateError;
      property OnPluginCrashed                  : TOnPluginCrashed                  read FOnPluginCrashed                  write FOnPluginCrashed;
      property OnRenderViewReady                : TOnRenderViewReady                read FOnRenderViewReady                write FOnRenderViewReady;
      property OnRenderProcessTerminated        : TOnRenderProcessTerminated        read FOnRenderProcessTerminated        write FOnRenderProcessTerminated;

      // IOldCefDialogHandler
      property OnFileDialog                     : TOnFileDialog                     read FOnFileDialog                     write FOnFileDialog;

      // IOldCefRenderHandler
      property OnGetRootScreenRect              : TOnGetRootScreenRect              read FOnGetRootScreenRect              write FOnGetRootScreenRect;
      property OnGetViewRect                    : TOnGetViewRect                    read FOnGetViewRect                    write FOnGetViewRect;
      property OnGetScreenPoint                 : TOnGetScreenPoint                 read FOnGetScreenPoint                 write FOnGetScreenPoint;
      property OnGetScreenInfo                  : TOnGetScreenInfo                  read FOnGetScreenInfo                  write FOnGetScreenInfo;
      property OnPopupShow                      : TOnPopupShow                      read FOnPopupShow                      write FOnPopupShow;
      property OnPopupSize                      : TOnPopupSize                      read FOnPopupSize                      write FOnPopupSize;
      property OnPaint                          : TOnPaint                          read FOnPaint                          write FOnPaint;
      property OnCursorChange                   : TOnCursorChange                   read FOnCursorChange                   write FOnCursorChange;
      property OnScrollOffsetChanged            : TOnScrollOffsetChanged            read FOnScrollOffsetChanged            write FOnScrollOffsetChanged;

      // IOldCefDragHandler
      property OnDragEnter                      : TOnDragEnter                      read FOnDragEnter                      write FOnDragEnter;
      property OnDraggableRegionsChanged        : TOnDraggableRegionsChanged        read FOnDraggableRegionsChanged        write FOnDraggableRegionsChanged;

      // IOldCefFindHandler
      property OnFindResult                     : TOnFindResult                     read FOnFindResult                     write FOnFindResult;

  end;

implementation

uses
  System.SysUtils, System.Math,
  oldCEFBrowser, oldCEFValue, oldCEFDictionaryValue, oldCEFStringMultimap, oldCEFFrame,
  oldCEFApplication, oldCEFProcessMessage, oldCEFRequestContext,
  oldCEFPDFPrintCallback, oldCEFResolveCallback, oldCEFDeleteCookiesCallback,
  oldCEFStringVisitor, oldCEFListValue;

constructor TOldFMXChromium.Create(AOwner: TComponent);
begin
  FBrowser                := nil;
  FBrowserId              := 0;
  FClosing                := False;
  FInitialized            := False;
  FDefaultUrl             := 'about:blank';
  FHandler                := nil;
  FOptions                := nil;
  FFontOptions            := nil;
  FDefaultEncoding        := '';
  FPDFPrintOptions        := nil;
  FUpdatePreferences      := False;
  FCustomHeaderName       := '';
  FCustomHeaderValue      := '';
  FPrefsFileName          := '';
  FAddCustomHeader        := False;
  FDoNotTrack             := True;
  FSendReferrer           := True;
  FHyperlinkAuditing      := False;
  FRunAllFlashInAllowMode := False;
  FAllowOutdatedPlugins   := False;
  FAlwaysAuthorizePlugins := False;
  FSpellChecking          := True;
  FSpellCheckerDicts      := '';
  FCookiePrefs            := CEF_CONTENT_SETTING_ALLOW;
  FImagesPrefs            := CEF_CONTENT_SETTING_ALLOW;
  FZoomStep               := ZOOM_STEP_DEF;
  FWindowName             := '';

  {$IFDEF MSWINDOWS}
  FOldBrowserCompWndPrc   := nil;
  FOldWidgetCompWndPrc    := nil;
  FOldRenderCompWndPrc    := nil;
  FBrowserCompHWND        := 0;
  FWidgetCompHWND         := 0;
  FRenderCompHWND         := 0;
  FBrowserCompStub        := nil;
  FWidgetCompStub         := nil;
  FRenderCompStub         := nil;
  {$ENDIF}

  FDragOperations         := DRAG_OPERATION_NONE;
  FDragAndDropInitialized := False;

  FWebRTCIPHandlingPolicy := hpDefault;
  FWebRTCMultipleRoutes   := STATE_DEFAULT;
  FWebRTCNonProxiedUDP    := STATE_DEFAULT;

  FProxyType         := CEF_PROXYTYPE_DIRECT;
  FProxyScheme       := psHTTP;
  FProxyServer       := '';
  FProxyPort         := 80;
  FProxyUsername     := '';
  FProxyPassword     := '';
  FProxyScriptURL    := '';
  FProxyByPassList   := '';

  FillChar(FWindowInfo,    SizeOf(TOldCefWindowInfo), 0);
  FillChar(FDevWindowInfo, SizeOf(TOldCefWindowInfo), 0);

  InitializeSettings(FBrowserSettings);
  InitializeSettings(FDevBrowserSettings);

  InitializeEvents;

  inherited Create(AOwner);
end;

destructor TOldFMXChromium.Destroy;
begin
  try
    try
      ClearBrowserReference;

      if (FFontOptions     <> nil) then FreeAndNil(FFontOptions);
      if (FOptions         <> nil) then FreeAndNil(FOptions);
      if (FPDFPrintOptions <> nil) then FreeAndNil(FPDFPrintOptions);
    except
      on e : exception do
        if CustomExceptionHandler('TFMXChromium.Destroy', e) then raise;
    end;
  finally
    inherited Destroy;
  end;
end;

procedure TOldFMXChromium.BeforeDestruction;
begin
  {$IFDEF MSWINDOWS}
  if (FBrowserCompHWND <> 0) and (FOldBrowserCompWndPrc <> nil) then
    begin
      SetWindowLongPtr(FBrowserCompHWND, GWL_WNDPROC, NativeInt(FOldBrowserCompWndPrc));
      FreeAndNilStub(FBrowserCompStub);
      FOldBrowserCompWndPrc := nil;
    end;

  if (FWidgetCompHWND <> 0) and (FOldWidgetCompWndPrc <> nil) then
    begin
      SetWindowLongPtr(FWidgetCompHWND, GWL_WNDPROC, NativeInt(FOldWidgetCompWndPrc));
      FreeAndNilStub(FWidgetCompStub);
      FOldWidgetCompWndPrc := nil;
    end;

  if (FRenderCompHWND <> 0) and (FOldRenderCompWndPrc <> nil) then
    begin
      SetWindowLongPtr(FRenderCompHWND, GWL_WNDPROC, NativeInt(FOldRenderCompWndPrc));
      FreeAndNilStub(FRenderCompStub);
      FOldRenderCompWndPrc := nil;
    end;
  {$ENDIF}

  DestroyClientHandler;

  inherited BeforeDestruction;
end;

procedure TOldFMXChromium.ClearBrowserReference;
begin
  FBrowser   := nil;
  FBrowserId := 0;
end;

procedure TOldFMXChromium.DestroyClientHandler;
begin
  try
    if (FHandler <> nil) then
      begin
        FHandler.RemoveReferences;
        FHandler := nil;
      end;
  except
    on e : exception do
      if CustomExceptionHandler('TFMXChromium.DestroyClientHandler', e) then raise;
  end;
end;

procedure TOldFMXChromium.AfterConstruction;
begin
  inherited AfterConstruction;

  try
    if not(csDesigning in ComponentState) then
      begin
        FOptions         := TOldChromiumOptions.Create;
        FFontOptions     := TOldChromiumFontOptions.Create;
        FPDFPrintOptions := TOldPDFPrintOptions.Create;
      end;
  except
    on e : exception do
      if CustomExceptionHandler('TFMXChromium.AfterConstruction', e) then raise;
  end;
end;

function TOldFMXChromium.CreateClientHandler(aIsOSR : boolean) : boolean;
begin
  Result := False;

  try
    if (FHandler = nil) then
      begin
        FIsOSR   := aIsOsr;
        FHandler := TOldCustomClientHandler.Create(
          Self,
          MustCreateLoadHandler,
          MustCreateFocusHandler,
          MustCreateContextMenuHandler,
          MustCreateDialogHandler,
          MustCreateKeyboardHandler,
          MustCreateDisplayHandler,
          MustCreateDownloadHandler,
          MustCreateGeolocationHandler,
          MustCreateJsDialogHandler,
          True,
          FIsOSR,
          True,
          MustCreateDragHandler,
          MustCreateFindHandler);

        Result   := True;
      end;
  except
    on e : exception do
      if CustomExceptionHandler('TFMXChromium.CreateClientHandler', e) then raise;
  end;
end;

function TOldFMXChromium.CreateClientHandler(var aClient : IOldCefClient; aIsOSR : boolean) : boolean;
begin
  if CreateClientHandler(aIsOSR) then
    begin
      aClient := FHandler;
      Result  := True;
    end
   else
    Result := False;
end;

procedure TOldFMXChromium.InitializeEvents;
begin
  // IOldCefClient
  FOnProcessMessageReceived       := nil;

  // IOldCefLoadHandler
  FOnLoadStart                    := nil;
  FOnLoadEnd                      := nil;
  FOnLoadError                    := nil;
  FOnLoadingStateChange           := nil;

  // IOldCefFocusHandler
  FOnTakeFocus                    := nil;
  FOnSetFocus                     := nil;
  FOnGotFocus                     := nil;

  // IOldCefContextMenuHandler
  FOnBeforeContextMenu            := nil;
  FOnRunContextMenu               := nil;
  FOnContextMenuCommand           := nil;
  FOnContextMenuDismissed         := nil;

  // IOldCefKeyboardHandler
  FOnPreKeyEvent                  := nil;
  FOnKeyEvent                     := nil;

  // IOldCefDisplayHandler
  FOnAddressChange                := nil;
  FOnTitleChange                  := nil;
  FOnFavIconUrlChange             := nil;
  FOnFullScreenModeChange         := nil;
  FOnTooltip                      := nil;
  FOnStatusMessage                := nil;
  FOnConsoleMessage               := nil;

  // IOldCefDownloadHandler
  FOnBeforeDownload               := nil;
  FOnDownloadUpdated              := nil;

  // IOldCefGeolocationHandler
  FOnRequestGeolocationPermission := nil;
  FOnCancelGeolocationPermission  := nil;

  // IOldCefJsDialogHandler
  FOnJsdialog                     := nil;
  FOnBeforeUnloadDialog           := nil;
  FOnResetDialogState             := nil;
  FOnDialogClosed                 := nil;

  // IOldCefLifeSpanHandler
  FOnBeforePopup                  := nil;
  FOnAfterCreated                 := nil;
  FOnRunModal                     := nil;
  FOnBeforeClose                  := nil;
  FOnClose                        := nil;

  // IOldCefRequestHandler
  FOnBeforeBrowse                 := nil;
  FOnOpenUrlFromTab               := nil;
  FOnBeforeResourceLoad           := nil;
  FOnGetResourceHandler           := nil;
  FOnResourceRedirect             := nil;
  FOnResourceResponse             := nil;
  FOnGetResourceResponseFilter    := nil;
  FOnResourceLoadComplete         := nil;
  FOnGetAuthCredentials           := nil;
  FOnQuotaRequest                 := nil;
  FOnProtocolExecution            := nil;
  FOnCertificateError             := nil;
  FOnPluginCrashed                := nil;
  FOnRenderViewReady              := nil;
  FOnRenderProcessTerminated      := nil;

  // IOldCefDialogHandler
  FOnFileDialog                   := nil;

  // IOldCefRenderHandler
  FOnGetRootScreenRect            := nil;
  FOnGetViewRect                  := nil;
  FOnGetScreenPoint               := nil;
  FOnGetScreenInfo                := nil;
  FOnPopupShow                    := nil;
  FOnPopupSize                    := nil;
  FOnPaint                        := nil;
  FOnCursorChange                 := nil;
  FOnScrollOffsetChanged          := nil;

  // IOldCefDragHandler
  FOnDragEnter                    := nil;
  FOnDraggableRegionsChanged      := nil;

  // IOldCefFindHandler
  FOnFindResult                   := nil;

  // Custom
  FOnTextResultAvailable          := nil;
  FOnPdfPrintFinished             := nil;
  FOnCookiesDeleted               := nil;
  FOnResolvedHostAvailable        := nil;
end;

function TOldFMXChromium.CreateBrowser(const aWindowName  : string;
                                    const aContext     : IOldCefRequestContext;
                                    const aCookiesPath : string;
                                          aPersistSessionCookies : boolean) : boolean;
var
  TempCookieManager : IOldCefCookieManager;
begin
  Result := False;

  try
    // GlobalOldCEFApp.GlobalContextInitialized has to be TRUE before creating any browser
    // even if you use a custom request context.
    // If you create a browser in the initialization of your app, make sure you call this
    // function when GlobalOldCEFApp.GlobalContextInitialized is TRUE.
    // Use the GlobalOldCEFApp.OnContextInitialized event to know when
    // GlobalOldCEFApp.GlobalContextInitialized is set to TRUE.

    if not(csDesigning in ComponentState) and
       not(FClosing)         and
       (FBrowser     =  nil) and
       (FBrowserId   =  0)   and
       (GlobalOldCEFApp <> nil) and
       GlobalOldCEFApp.GlobalContextInitialized and
       CreateClientHandler then
      begin
        GetSettings(FBrowserSettings);
        WindowInfoAsWindowless(FWindowInfo, 0, aWindowName);

        if (aContext <> nil) and (length(aCookiesPath) > 0) then
          begin
            TempCookieManager := aContext.GetDefaultCookieManager(nil);

            if (TempCookieManager = nil) or
               not(TempCookieManager.SetStoragePath(aCookiesPath, aPersistSessionCookies, nil)) then
              OutputDebugMessage('TFMXChromium.CreateBrowser error : cookies cannot be accessed');
          end;


        if GlobalOldCEFApp.MultiThreadedMessageLoop then
          Result := CreateBrowserHost(@FWindowInfo, FDefaultUrl, @FBrowserSettings, aContext)
         else
          Result := CreateBrowserHostSync(@FWindowInfo, FDefaultUrl, @FBrowserSettings, aContext);
      end;
  except
    on e : exception do
      if CustomExceptionHandler('TFMXChromium.CreateBrowser', e) then raise;
  end;
end;

{$IFDEF MSWINDOWS}
function TOldFMXChromium.CreateBrowser(      aParentHandle          : HWND;
                                          aParentRect            : TRect;
                                    const aWindowName            : string;
                                    const aContext               : IOldCefRequestContext;
                                    const aCookiesPath           : string;
                                          aPersistSessionCookies : boolean) : boolean;
var
  TempCookieManager : IOldCefCookieManager;
begin
  Result := False;

  try
    // GlobalOldCEFApp.GlobalContextInitialized has to be TRUE before creating any browser
    // even if you use a custom request context.
    // If you create a browser in the initialization of your app, make sure you call this
    // function when GlobalOldCEFApp.GlobalContextInitialized is TRUE.
    // Use the GlobalOldCEFApp.OnContextInitialized event to know when
    // GlobalOldCEFApp.GlobalContextInitialized is set to TRUE.

    if not(csDesigning in ComponentState) and
       not(FClosing)         and
       (FBrowser     =  nil) and
       (FBrowserId   =  0)   and
       (GlobalOldCEFApp <> nil) and
       GlobalOldCEFApp.GlobalContextInitialized  and
       CreateClientHandler(aParentHandle = 0) then
      begin
        GetSettings(FBrowserSettings);

        if FIsOSR then
          WindowInfoAsWindowless(FWindowInfo, 0, aWindowName)
         else
          WindowInfoAsChild(FWindowInfo, aParentHandle, aParentRect, aWindowName);


        if (aContext <> nil) and (length(aCookiesPath) > 0) then
          begin
            TempCookieManager := aContext.GetDefaultCookieManager(nil);

            if (TempCookieManager = nil) or
               not(TempCookieManager.SetStoragePath(aCookiesPath, aPersistSessionCookies, nil)) then
              OutputDebugMessage('TChromium.CreateBrowser error : cookies cannot be accessed');
          end;


        if GlobalOldCEFApp.MultiThreadedMessageLoop then
          Result := CreateBrowserHost(@FWindowInfo, FDefaultUrl, @FBrowserSettings, aContext)
         else
          Result := CreateBrowserHostSync(@FWindowInfo, FDefaultUrl, @FBrowserSettings, aContext);
      end;
  except
    on e : exception do
      if CustomExceptionHandler('TFMXChromium.CreateBrowser', e) then raise;
  end;
end;
{$ENDIF}

function TOldFMXChromium.ShareRequestContext(var   aContext : IOldCefRequestContext;
                                          const aHandler : IOldCefRequestContextHandler) : boolean;
begin
  Result   := False;
  aContext := nil;

  if Initialized then
    begin
      aContext := TOldCefRequestContextRef.Shared(FBrowser.Host.RequestContext, aHandler);
      Result   := (aContext <> nil);
    end;
end;

procedure TOldFMXChromium.CloseBrowser(aForceClose : boolean);
begin
  if Initialized then FBrowser.Host.CloseBrowser(aForceClose);
end;

function TOldFMXChromium.CreateBrowserHost(aWindowInfo     : POldCefWindowInfo;
                                        const aURL      : oldustring;
                                        const aSettings : POldCefBrowserSettings;
                                        const aContext  : IOldCefRequestContext): Boolean;
var
  TempURL : TOldCefString;
begin
  TempURL := CefString(aURL);
  Result  := cef_browser_host_create_browser(aWindowInfo, FHandler.Wrap, @TempURL, aSettings, CefGetData(aContext)) <> 0;
end;

function TOldFMXChromium.CreateBrowserHostSync(aWindowInfo     : POldCefWindowInfo;
                                            const aURL      : oldustring;
                                            const aSettings : POldCefBrowserSettings;
                                            const aContext  : IOldCefRequestContext): boolean;
var
  TempURL : TOldCefString;
begin
  TempURL  := CefString(aURL);
  FBrowser := TOldCefBrowserRef.UnWrap(cef_browser_host_create_browser_sync(aWindowInfo, FHandler.Wrap, @TempURL, aSettings, CefGetData(aContext)));

  if (FBrowser <> nil) then
    begin
      FBrowserId   := FBrowser.Identifier;
      FInitialized := (FBrowserId <> 0);
      Result       := FInitialized;
    end
   else
    Result := False;
end;

procedure TOldFMXChromium.Find(aIdentifier : integer; const aSearchText : oldustring; aForward, aMatchCase, aFindNext : Boolean);
begin
  if Initialized then FBrowser.Host.Find(aIdentifier, aSearchText, aForward, aMatchCase, aFindNext);
end;

procedure TOldFMXChromium.StopFinding(aClearSelection : Boolean);
begin
  if Initialized then FBrowser.Host.StopFinding(aClearSelection);
end;

procedure TOldFMXChromium.Print;
begin
  if Initialized then FBrowser.Host.Print;
end;

procedure TOldFMXChromium.PrintToPDF(const aFilePath, aTitle, aURL : oldustring);
var
  TempSettings : TOldCefPdfPrintSettings;
  TempCallback : IOldCefPdfPrintCallback;
begin
  if Initialized then
    begin
      GetPrintPDFSettings(TempSettings, aTitle, aURL);
      TempCallback := TOldCefCustomPDFPrintCallBack.Create(self);
      FBrowser.Host.PrintToPdf(aFilePath, @TempSettings, TempCallback);
    end;
end;

procedure TOldFMXChromium.ClipboardCopy;
var
  TempFrame : IOldCefFrame;
begin
  if Initialized then
    begin
      TempFrame := FBrowser.FocusedFrame;
      if (TempFrame = nil) then TempFrame := FBrowser.MainFrame;

      if (TempFrame <> nil) then TempFrame.Copy;
    end;
end;

procedure TOldFMXChromium.ClipboardPaste;
var
  TempFrame : IOldCefFrame;
begin
  if Initialized then
    begin
      TempFrame := FBrowser.FocusedFrame;
      if (TempFrame = nil) then TempFrame := FBrowser.MainFrame;

      if (TempFrame <> nil) then TempFrame.Paste;
    end;
end;

procedure TOldFMXChromium.ClipboardCut;
var
  TempFrame : IOldCefFrame;
begin
  if Initialized then
    begin
      TempFrame := FBrowser.FocusedFrame;
      if (TempFrame = nil) then TempFrame := FBrowser.MainFrame;

      if (TempFrame <> nil) then TempFrame.Cut;
    end;
end;

procedure TOldFMXChromium.ClipboardUndo;
var
  TempFrame : IOldCefFrame;
begin
  if Initialized then
    begin
      TempFrame := FBrowser.FocusedFrame;
      if (TempFrame = nil) then TempFrame := FBrowser.MainFrame;

      if (TempFrame <> nil) then TempFrame.Undo;
    end;
end;

procedure TOldFMXChromium.ClipboardRedo;
var
  TempFrame : IOldCefFrame;
begin
  if Initialized then
    begin
      TempFrame := FBrowser.FocusedFrame;
      if (TempFrame = nil) then TempFrame := FBrowser.MainFrame;

      if (TempFrame <> nil) then TempFrame.Redo;
    end;
end;

procedure TOldFMXChromium.ClipboardDel;
var
  TempFrame : IOldCefFrame;
begin
  if Initialized then
    begin
      TempFrame := FBrowser.FocusedFrame;
      if (TempFrame = nil) then TempFrame := FBrowser.MainFrame;

      if (TempFrame <> nil) then TempFrame.Del;
    end;
end;

procedure TOldFMXChromium.SelectAll;
var
  TempFrame : IOldCefFrame;
begin
  if Initialized then
    begin
      TempFrame := FBrowser.FocusedFrame;
      if (TempFrame = nil) then TempFrame := FBrowser.MainFrame;

      if (TempFrame <> nil) then TempFrame.SelectAll;
    end;
end;

procedure TOldFMXChromium.GetPrintPDFSettings(var aSettings : TOldCefPdfPrintSettings; const aTitle, aURL : string);
begin
  if (FPDFPrintOptions <> nil) then
    begin
      aSettings.header_footer_title   := CefString(aTitle);
      aSettings.header_footer_url     := CefString(aURL);
      aSettings.page_width            := FPDFPrintOptions.page_width;
      aSettings.page_height           := FPDFPrintOptions.page_height;
      aSettings.margin_top            := FPDFPrintOptions.margin_top;
      aSettings.margin_right          := FPDFPrintOptions.margin_right;
      aSettings.margin_bottom         := FPDFPrintOptions.margin_bottom;
      aSettings.margin_left           := FPDFPrintOptions.margin_left;
      aSettings.margin_type           := FPDFPrintOptions.margin_type;
      aSettings.header_footer_enabled := Ord(FPDFPrintOptions.header_footer_enabled);
      aSettings.selection_only        := Ord(FPDFPrintOptions.selection_only);
      aSettings.landscape             := Ord(FPDFPrintOptions.landscape);
      aSettings.backgrounds_enabled   := Ord(FPDFPrintOptions.backgrounds_enabled);
    end;
end;

procedure TOldFMXChromium.GetSettings(var aSettings : TOldCefBrowserSettings);
begin
  if (FFontOptions <> nil) and (FOptions <> nil) then
    begin
      aSettings.size                            := SizeOf(TOldCefBrowserSettings);
      aSettings.windowless_frame_rate           := FOptions.WindowlessFrameRate;
      aSettings.standard_font_family            := CefString(FFontOptions.StandardFontFamily);
      aSettings.fixed_font_family               := CefString(FFontOptions.FixedFontFamily);
      aSettings.serif_font_family               := CefString(FFontOptions.SerifFontFamily);
      aSettings.sans_serif_font_family          := CefString(FFontOptions.SansSerifFontFamily);
      aSettings.cursive_font_family             := CefString(FFontOptions.CursiveFontFamily);
      aSettings.fantasy_font_family             := CefString(FFontOptions.FantasyFontFamily);
      aSettings.default_font_size               := FFontOptions.DefaultFontSize;
      aSettings.default_fixed_font_size         := FFontOptions.DefaultFixedFontSize;
      aSettings.minimum_font_size               := FFontOptions.MinimumFontSize;
      aSettings.minimum_logical_font_size       := FFontOptions.MinimumLogicalFontSize;
      aSettings.remote_fonts                    := FFontOptions.RemoteFonts;
      aSettings.default_encoding                := CefString(DefaultEncoding);
      aSettings.javascript                      := FOptions.Javascript;
      aSettings.javascript_open_windows         := FOptions.JavascriptOpenWindows;
      aSettings.javascript_close_windows        := FOptions.JavascriptCloseWindows;
      aSettings.javascript_access_clipboard     := FOptions.JavascriptAccessClipboard;
      aSettings.javascript_dom_paste            := FOptions.JavascriptDomPaste;
      aSettings.caret_browsing                  := FOptions.CaretBrowsing;
      aSettings.plugins                         := FOptions.Plugins;
      aSettings.universal_access_from_file_urls := FOptions.UniversalAccessFromFileUrls;
      aSettings.file_access_from_file_urls      := FOptions.FileAccessFromFileUrls;
      aSettings.web_security                    := FOptions.WebSecurity;
      aSettings.image_loading                   := FOptions.ImageLoading;
      aSettings.image_shrink_standalone_to_fit  := FOptions.ImageShrinkStandaloneToFit;
      aSettings.text_area_resize                := FOptions.TextAreaResize;
      aSettings.tab_to_links                    := FOptions.TabToLinks;
      aSettings.local_storage                   := FOptions.LocalStorage;
      aSettings.databases                       := FOptions.Databases;
      aSettings.application_cache               := FOptions.ApplicationCache;
      aSettings.webgl                           := FOptions.Webgl;
      aSettings.background_color                := FOptions.BackgroundColor;
      aSettings.accept_language_list            := CefString(FOptions.AcceptLanguageList);
    end;
end;

procedure TOldFMXChromium.InitializeSettings(var aSettings : TOldCefBrowserSettings);
begin
  aSettings.size                            := SizeOf(TOldCefBrowserSettings);
  aSettings.windowless_frame_rate           := 30;
  aSettings.standard_font_family            := CefString('');
  aSettings.fixed_font_family               := CefString('');
  aSettings.serif_font_family               := CefString('');
  aSettings.sans_serif_font_family          := CefString('');
  aSettings.cursive_font_family             := CefString('');
  aSettings.fantasy_font_family             := CefString('');
  aSettings.default_font_size               := 0;
  aSettings.default_fixed_font_size         := 0;
  aSettings.minimum_font_size               := 0;
  aSettings.minimum_logical_font_size       := 0;
  aSettings.remote_fonts                    := STATE_DEFAULT;
  aSettings.default_encoding                := CefString('');
  aSettings.javascript                      := STATE_DEFAULT;
  aSettings.javascript_open_windows         := STATE_DEFAULT;
  aSettings.javascript_close_windows        := STATE_DEFAULT;
  aSettings.javascript_access_clipboard     := STATE_DEFAULT;
  aSettings.javascript_dom_paste            := STATE_DEFAULT;
  aSettings.caret_browsing                  := STATE_DEFAULT;
  aSettings.plugins                         := STATE_DEFAULT;
  aSettings.universal_access_from_file_urls := STATE_DEFAULT;
  aSettings.file_access_from_file_urls      := STATE_DEFAULT;
  aSettings.web_security                    := STATE_DEFAULT;
  aSettings.image_loading                   := STATE_DEFAULT;
  aSettings.image_shrink_standalone_to_fit  := STATE_DEFAULT;
  aSettings.text_area_resize                := STATE_DEFAULT;
  aSettings.tab_to_links                    := STATE_DEFAULT;
  aSettings.local_storage                   := STATE_DEFAULT;
  aSettings.databases                       := STATE_DEFAULT;
  aSettings.application_cache               := STATE_DEFAULT;
  aSettings.webgl                           := STATE_DEFAULT;
  aSettings.background_color                := 0;
  aSettings.accept_language_list            := CefString('');
end;

// Leave aFrameName empty to load the URL in the main frame
procedure TOldFMXChromium.LoadURL(const aURL : oldustring; const aFrameName : oldustring = '');
var
  TempFrame : IOldCefFrame;
begin
  if Initialized then
    begin
      if (length(aFrameName) > 0) then
        TempFrame := FBrowser.GetFrame(aFrameName)
       else
        TempFrame := FBrowser.MainFrame;

      if (TempFrame <> nil) then TempFrame.LoadUrl(aURL);
    end;
end;

procedure TOldFMXChromium.LoadURL(const aURL : oldustring; const aFrame : IOldCefFrame);
begin
  if Initialized and (aFrame <> nil) then aFrame.LoadUrl(aURL);
end;

procedure TOldFMXChromium.LoadURL(const aURL : oldustring; const aFrameIdentifier : int64);
var
  TempFrame : IOldCefFrame;
begin
  if Initialized then
    begin
      if (aFrameIdentifier <> 0) then
        TempFrame := FBrowser.GetFrameByident(aFrameIdentifier)
       else
        TempFrame := FBrowser.MainFrame;

      if (TempFrame <> nil) then TempFrame.LoadUrl(aURL);
    end;
end;

procedure TOldFMXChromium.LoadString(const aString : oldustring; const aURL : oldustring);
var
  TempFrame : IOldCefFrame;
begin
  if Initialized then
    begin
      TempFrame := FBrowser.MainFrame;
      if (TempFrame <> nil) then TempFrame.LoadString(aString, aURL);
    end;
end;

procedure TOldFMXChromium.LoadRequest(const aRequest: IOldCefRequest);
var
  TempFrame : IOldCefFrame;
begin
  if Initialized then
    begin
      TempFrame := FBrowser.MainFrame;
      if (TempFrame <> nil) then TempFrame.LoadRequest(aRequest);
    end;
end;

procedure TOldFMXChromium.GoBack;
begin
  if Initialized and CanGoBack then FBrowser.GoBack;
end;

procedure TOldFMXChromium.GoForward;
begin
  if Initialized and CanGoForward then FBrowser.GoForward;
end;

procedure TOldFMXChromium.Reload;
begin
  if Initialized then FBrowser.Reload;
end;

procedure TOldFMXChromium.ReloadIgnoreCache;
begin
  if Initialized then FBrowser.ReloadIgnoreCache;
end;

procedure TOldFMXChromium.StopLoad;
begin
  if Initialized then FBrowser.StopLoad;
end;

procedure TOldFMXChromium.StartDownload(const aURL : oldustring);
begin
  if Initialized then FBrowser.Host.StartDownload(aURL);
end;

function TOldFMXChromium.GetIsLoading : boolean;
begin
  Result := Initialized and FBrowser.IsLoading;
end;

function TOldFMXChromium.GetMultithreadApp : boolean;
begin
  Result := (GlobalOldCEFApp <> nil) and GlobalOldCEFApp.MultiThreadedMessageLoop;
end;

function TOldFMXChromium.GetHasDocument : boolean;
begin
  Result := Initialized and FBrowser.HasDocument;
end;

function TOldFMXChromium.GetHasClientHandler : boolean;
begin
  Result := (FHandler <> nil);
end;

function TOldFMXChromium.GetHasBrowser : boolean;
begin
  Result := (FBrowser <> nil);
end;

function TOldFMXChromium.GetWindowHandle : THandle;
begin
  if Initialized then
    Result := FBrowser.Host.WindowHandle
   else
    Result := 0;
end;

function TOldFMXChromium.GetFrameIsFocused : boolean;
begin
  Result := Initialized and (FBrowser.FocusedFrame <> nil);
end;

function TOldFMXChromium.GetWindowlessFrameRate : integer;
begin
  if Initialized then
    Result := FBrowser.Host.GetWindowlessFrameRate
   else
    Result := 0;
end;

function TOldFMXChromium.GetHasValidMainFrame : boolean;
begin
  Result := Initialized and (FBrowser.MainFrame <> nil) and FBrowser.MainFrame.IsValid;
end;

function TOldFMXChromium.GetFrameCount : NativeUInt;
begin
  if Initialized then
    Result := FBrowser.GetFrameCount
   else
    Result := 0;
end;

function TOldFMXChromium.GetRequestContextCache : string;
begin
  if Initialized then
    Result := FBrowser.host.RequestContext.CachePath
   else
    if (GlobalOldCEFApp <> nil) then
      Result := GlobalOldCEFApp.cache
     else
      Result := '';
end;

function TOldFMXChromium.GetRequestContextIsGlobal : boolean;
begin
  Result := Initialized and FBrowser.host.RequestContext.IsGlobal;
end;

procedure TOldFMXChromium.SetWindowlessFrameRate(aValue : integer);
begin
  if Initialized then FBrowser.Host.SetWindowlessFrameRate(aValue);
end;

function TOldFMXChromium.GetCanGoBack : boolean;
begin
  Result := Initialized and FBrowser.CanGoBack;
end;

function TOldFMXChromium.GetCanGoForward : boolean;
begin
  Result := Initialized and FBrowser.CanGoForward;
end;

function TOldFMXChromium.GetIsPopUp : boolean;
begin
  Result := Initialized and FBrowser.IsPopUp;
end;

function TOldFMXChromium.GetInitialized : boolean;
begin
  Result := FInitialized and not(FClosing) and (FBrowser <> nil);
end;

function TOldFMXChromium.GetDocumentURL : string;
var
  TempFrame : IOldCefFrame;
begin
  Result := '';

  if Initialized then
    begin
      TempFrame := FBrowser.MainFrame;
      if (TempFrame <> nil) then Result := TempFrame.URL;
    end;
end;

function TOldFMXChromium.GetZoomLevel : double;
begin
  Result := 0;

  if Initialized then Result := FBrowser.Host.ZoomLevel;
end;

procedure TOldFMXChromium.SetZoomLevel(const aValue : double);
begin
  if Initialized then FBrowser.Host.ZoomLevel := aValue;
end;

function TOldFMXChromium.GetZoomPct : double;
begin
  Result := power(1.2, ZoomLevel) * 100;
end;

procedure TOldFMXChromium.SetZoomPct(const aValue : double);
begin
  if Initialized and (aValue > 0) then ZoomLevel := LogN(1.2, aValue / 100);
end;

procedure TOldFMXChromium.ApplyZoomStep;
begin
  case FZoomStep of
    ZOOM_STEP_25  : ZoomPct := 25;
    ZOOM_STEP_33  : ZoomPct := 33;
    ZOOM_STEP_50  : ZoomPct := 50;
    ZOOM_STEP_67  : ZoomPct := 67;
    ZOOM_STEP_75  : ZoomPct := 75;
    ZOOM_STEP_90  : ZoomPct := 90;
    ZOOM_STEP_100 : ZoomPct := 100;
    ZOOM_STEP_110 : ZoomPct := 110;
    ZOOM_STEP_125 : ZoomPct := 125;
    ZOOM_STEP_150 : ZoomPct := 150;
    ZOOM_STEP_175 : ZoomPct := 175;
    ZOOM_STEP_200 : ZoomPct := 200;
    ZOOM_STEP_250 : ZoomPct := 250;
    ZOOM_STEP_300 : ZoomPct := 300;
    ZOOM_STEP_400 : ZoomPct := 400;
    ZOOM_STEP_500 : ZoomPct := 500;
  end;
end;

procedure TOldFMXChromium.SetZoomStep(aValue : byte);
begin
  if Initialized and (aValue in [ZOOM_STEP_MIN..ZOOM_STEP_MAX]) then
    begin
      FZoomStep := aValue;
      ApplyZoomStep;
    end;
end;

procedure TOldFMXChromium.IncZoomStep;
begin
  if Initialized and (FZoomStep < ZOOM_STEP_MAX) then
    begin
      inc(FZoomStep);
      ApplyZoomStep;
    end;
end;

procedure TOldFMXChromium.DecZoomStep;
begin
  if Initialized and (FZoomStep > ZOOM_STEP_MIN) then
    begin
      dec(FZoomStep);
      ApplyZoomStep;
    end;
end;

procedure TOldFMXChromium.ResetZoomStep;
begin
  ZoomStep := ZOOM_STEP_DEF;
end;

procedure TOldFMXChromium.SetDoNotTrack(aValue : boolean);
begin
  if (FDoNotTrack <> aValue) then
    begin
      FDoNotTrack        := aValue;
      FUpdatePreferences := True;
    end;
end;

procedure TOldFMXChromium.SetSendReferrer(aValue : boolean);
begin
  if (FSendReferrer <> aValue) then
    begin
      FSendReferrer      := aValue;
      FUpdatePreferences := True;
    end;
end;

procedure TOldFMXChromium.SetHyperlinkAuditing(aValue : boolean);
begin
  if (FHyperlinkAuditing <> aValue) then
    begin
      FHyperlinkAuditing := aValue;
      FUpdatePreferences := True;
    end;
end;

procedure TOldFMXChromium.SetRunAllFlashInAllowMode(aValue : boolean);
begin
  if (FRunAllFlashInAllowMode <> aValue) then
    begin
      FRunAllFlashInAllowMode := aValue;
      FUpdatePreferences      := True;
    end;
end;

procedure TOldFMXChromium.SetAllowOutdatedPlugins(aValue : boolean);
begin
  if (FAllowOutdatedPlugins <> aValue) then
    begin
      FAllowOutdatedPlugins := aValue;
      FUpdatePreferences    := True;
    end;
end;

procedure TOldFMXChromium.SetAlwaysAuthorizePlugins(aValue : boolean);
begin
  if (FAlwaysAuthorizePlugins <> aValue) then
    begin
      FAlwaysAuthorizePlugins := aValue;
      FUpdatePreferences      := True;
    end;
end;

procedure TOldFMXChromium.SetSpellChecking(aValue : boolean);
begin
  if (FSpellChecking <> aValue) then
    begin
      FSpellChecking     := aValue;
      FUpdatePreferences := True;
    end;
end;

procedure TOldFMXChromium.SetSpellCheckerDicts(const aValue : string);
begin
  if (FSpellCheckerDicts <> aValue) then
    begin
      FSpellCheckerDicts := aValue;
      FUpdatePreferences := True;
    end;
end;

procedure TOldFMXChromium.SetWebRTCIPHandlingPolicy(aValue : TOldCefWebRTCHandlingPolicy);
begin
  if (FWebRTCIPHandlingPolicy <> aValue) then
    begin
      FWebRTCIPHandlingPolicy := aValue;
      FUpdatePreferences      := True;
    end;
end;

procedure TOldFMXChromium.SetWebRTCMultipleRoutes(aValue : TOldCefState);
begin
  if (FWebRTCMultipleRoutes <> aValue) then
    begin
      FWebRTCMultipleRoutes := aValue;
      FUpdatePreferences    := True;
    end;
end;

procedure TOldFMXChromium.SetWebRTCNonProxiedUDP(aValue : TOldCefState);
begin
  if (FWebRTCNonProxiedUDP <> aValue) then
    begin
      FWebRTCNonProxiedUDP := aValue;
      FUpdatePreferences   := True;
    end;
end;

procedure TOldFMXChromium.SetCookiePrefs(aValue : integer);
begin
  if (FCookiePrefs <> aValue) then
    begin
      FCookiePrefs       := aValue;
      FUpdatePreferences := True;
    end;
end;

procedure TOldFMXChromium.SetImagesPrefs(aValue : integer);
begin
  if (FImagesPrefs <> aValue) then
    begin
      FImagesPrefs       := aValue;
      FUpdatePreferences := True;
    end;
end;

procedure TOldFMXChromium.SetProxyType(aValue : integer);
begin
  if (FProxyType <> aValue) then
    begin
      FProxyType         := aValue;
      FUpdatePreferences := True;
    end;
end;

procedure TOldFMXChromium.SetProxyScheme(aValue : TOldCefProxyScheme);
begin
  if (FProxyScheme <> aValue) then
    begin
      FProxyScheme       := aValue;
      FUpdatePreferences := True;
    end;
end;

procedure TOldFMXChromium.SetProxyServer(const aValue : string);
begin
  if (FProxyServer <> aValue) then
    begin
      FProxyServer       := aValue;
      FUpdatePreferences := True;
    end;
end;

procedure TOldFMXChromium.SetProxyPort(aValue : integer);
begin
  if (FProxyPort <> aValue) then
    begin
      FProxyPort         := aValue;
      FUpdatePreferences := True;
    end;
end;

procedure TOldFMXChromium.SetProxyUsername(const aValue : string);
begin
  if (FProxyUsername <> aValue) then
    begin
      FProxyUsername     := aValue;
      FUpdatePreferences := True;
    end;
end;

procedure TOldFMXChromium.SetProxyPassword(const aValue : string);
begin
  if (FProxyPassword <> aValue) then
    begin
      FProxyPassword     := aValue;
      FUpdatePreferences := True;
    end;
end;

procedure TOldFMXChromium.SetProxyScriptURL(const aValue : string);
begin
  if (FProxyScriptURL <> aValue) then
    begin
      FProxyScriptURL    := aValue;
      FUpdatePreferences := True;
    end;
end;

procedure TOldFMXChromium.SetProxyByPassList(const aValue : string);
begin
  if (FProxyByPassList <> aValue) then
    begin
      FProxyByPassList   := aValue;
      FUpdatePreferences := True;
    end;
end;

procedure TOldFMXChromium.SetCustomHeaderName(const aValue : string);
begin
  if (FCustomHeaderName <> aValue) then
    begin
      FCustomHeaderName := aValue;
      FAddCustomHeader  := (length(FCustomHeaderName) > 0) and (length(FCustomHeaderValue) > 0);
    end;
end;

procedure TOldFMXChromium.SetCustomHeaderValue(const aValue : string);
begin
  if (FCustomHeaderValue <> aValue) then
    begin
      FCustomHeaderValue := aValue;
      FAddCustomHeader   := (length(FCustomHeaderName) > 0) and (length(FCustomHeaderValue) > 0);
    end;
end;

function TOldFMXChromium.DeleteCookies : boolean;
var
  TempManager  : IOldCefCookieManager;
  TempCallback : IOldCefDeleteCookiesCallback;
begin
  Result := False;

  if Initialized and (FBrowser.Host <> nil) and (FBrowser.Host.RequestContext <> nil) then
    begin
      TempManager := FBrowser.Host.RequestContext.GetDefaultCookieManager(nil);

      if (TempManager <> nil) then
        begin
          TempCallback := TOldCefCustomDeleteCookiesCallback.Create(self);
          Result       := TempManager.DeleteCookies('', '', TempCallback);
        end;
    end;
end;

// Leave aFrameName empty to get the HTML source from the main frame
procedure TOldFMXChromium.RetrieveHTML(const aFrameName : oldustring);
var
  TempFrame   : IOldCefFrame;
  TempVisitor : IOldCefStringVisitor;
begin
  if Initialized then
    begin
      if (length(aFrameName) > 0) then
        TempFrame := FBrowser.GetFrame(aFrameName)
       else
        TempFrame := FBrowser.MainFrame;

      if (TempFrame <> nil) then
        begin
          TempVisitor := TOldCustomCefStringVisitor.Create(self);
          TempFrame.GetSource(TempVisitor);
        end;
    end;
end;

procedure TOldFMXChromium.RetrieveHTML(const aFrame : IOldCefFrame);
var
  TempVisitor : IOldCefStringVisitor;
begin
  if Initialized and (aFrame <> nil) then
    begin
      TempVisitor := TOldCustomCefStringVisitor.Create(self);
      aFrame.GetSource(TempVisitor);
    end;
end;

procedure TOldFMXChromium.RetrieveHTML(const aFrameIdentifier : int64);
var
  TempFrame   : IOldCefFrame;
  TempVisitor : IOldCefStringVisitor;
begin
  if Initialized then
    begin
      if (aFrameIdentifier <> 0) then
        TempFrame := FBrowser.GetFrameByident(aFrameIdentifier)
       else
        TempFrame := FBrowser.MainFrame;

      if (TempFrame <> nil) then
        begin
          TempVisitor := TOldCustomCefStringVisitor.Create(self);
          TempFrame.GetSource(TempVisitor);
        end;
    end;
end;

// Leave aFrameName empty to get the HTML source from the main frame
procedure TOldFMXChromium.RetrieveText(const aFrameName : oldustring);
var
  TempFrame   : IOldCefFrame;
  TempVisitor : IOldCefStringVisitor;
begin
  if Initialized then
    begin
      if (length(aFrameName) > 0) then
        TempFrame := FBrowser.GetFrame(aFrameName)
       else
        TempFrame := FBrowser.MainFrame;

      if (TempFrame <> nil) then
        begin
          TempVisitor := TOldCustomCefStringVisitor.Create(self);
          TempFrame.GetText(TempVisitor);
        end;
    end;
end;

procedure TOldFMXChromium.RetrieveText(const aFrame : IOldCefFrame);
var
  TempVisitor : IOldCefStringVisitor;
begin
  if Initialized and (aFrame <> nil) then
    begin
      TempVisitor := TOldCustomCefStringVisitor.Create(self);
      aFrame.GetText(TempVisitor);
    end;
end;

procedure TOldFMXChromium.RetrieveText(const aFrameIdentifier : int64);
var
  TempFrame   : IOldCefFrame;
  TempVisitor : IOldCefStringVisitor;
begin
  if Initialized then
    begin
      if (aFrameIdentifier <> 0) then
        TempFrame := FBrowser.GetFrameByident(aFrameIdentifier)
       else
        TempFrame := FBrowser.MainFrame;

      if (TempFrame <> nil) then
        begin
          TempVisitor := TOldCustomCefStringVisitor.Create(self);
          TempFrame.GetText(TempVisitor);
        end;
    end;
end;

function TOldFMXChromium.GetFrameNames(var aFrameNames : TStrings) : boolean;
begin
  Result := Initialized and FBrowser.GetFrameNames(aFrameNames);
end;

function TOldFMXChromium.GetFrameIdentifiers(var aFrameCount : NativeUInt; var aFrameIdentifierArray : TOldCefFrameIdentifierArray) : boolean;
begin
  Result := Initialized and FBrowser.GetFrameIdentifiers(aFrameCount, aFrameIdentifierArray);
end;

procedure TOldFMXChromium.UpdatePreferences;
var
  TempTask: IOldCefTask;
begin
  if Initialized then
    begin
      TempTask := TOldCefUpdatePrefsTask.Create(self);
      CefPostTask(TID_UI, TempTask);
    end;
end;

procedure TOldFMXChromium.SavePreferences(const aFileName : string);
var
  TempTask: IOldCefTask;
begin
  if Initialized and (length(aFileName) > 0) then
    begin
      FPrefsFileName := aFileName;
      TempTask       := TOldCefSavePrefsTask.Create(self);
      CefPostTask(TID_UI, TempTask);
    end;
end;

procedure TOldFMXChromium.ResolveHost(const aURL : oldustring);
var
  TempCallback : IOldCefResolveCallback;
begin
  // Results will be received in the OnResolvedHostAvailable event of this class
  if Initialized and (length(aURL) > 0) then
    begin
      TempCallback := TOldCefCustomResolveCallback.Create(self);
      FBrowser.Host.RequestContext.ResolveHost(aURL, TempCallback);
    end;
end;

function TOldFMXChromium.IsSameBrowser(const aBrowser : IOldCefBrowser) : boolean;
begin
  Result := Initialized and (aBrowser <> nil) and FBrowser.IsSame(aBrowser);
end;

procedure TOldFMXChromium.SimulateMouseWheel(aDeltaX, aDeltaY : integer);
var
  TempEvent : TOldCefMouseEvent;
begin
  if Initialized then
    begin
      TempEvent.x         := 0;
      TempEvent.y         := 0;
      TempEvent.modifiers := EVENTFLAG_NONE;
      FBrowser.Host.SendMouseWheelEvent(@TempEvent, aDeltaX, aDeltaY);
    end;
end;

procedure TOldFMXChromium.doUpdatePreferences(const aBrowser: IOldCefBrowser);
begin
  FUpdatePreferences := False;

  UpdateProxyPrefs(aBrowser);
  UpdatePreference(aBrowser, 'enable_do_not_track',                  FDoNotTrack);
  UpdatePreference(aBrowser, 'enable_referrers',                     FSendReferrer);
  UpdatePreference(aBrowser, 'enable_a_ping',                        FHyperlinkAuditing);
  UpdatePreference(aBrowser, 'plugins.run_all_flash_in_allow_mode',  FRunAllFlashInAllowMode);
  UpdatePreference(aBrowser, 'plugins.allow_outdated',               FAllowOutdatedPlugins);
  UpdatePreference(aBrowser, 'plugins.always_authorize',             FAlwaysAuthorizePlugins);
  UpdatePreference(aBrowser, 'browser.enable_spellchecking',         FSpellChecking);
  UpdateStringListPref(aBrowser, 'spellcheck.dictionaries',          FSpellCheckerDicts);

  if FRunAllFlashInAllowMode then
    UpdatePreference(aBrowser, 'profile.default_content_setting_values.plugins', 1);

  case FWebRTCIPHandlingPolicy of
    hpDefaultPublicAndPrivateInterfaces :
      UpdatePreference(aBrowser, 'webrtc.ip_handling_policy', 'default_public_and_private_interfaces');

    hpDefaultPublicInterfaceOnly :
      UpdatePreference(aBrowser, 'webrtc.ip_handling_policy', 'default_public_interface_only');

    hpDisableNonProxiedUDP :
      UpdatePreference(aBrowser, 'webrtc.ip_handling_policy', 'disable_non_proxied_udp');
  end;

  if (FWebRTCMultipleRoutes <> STATE_DEFAULT) then
    UpdatePreference(aBrowser, 'webrtc.multiple_routes_enabled', (FWebRTCMultipleRoutes = STATE_ENABLED));

  if (FWebRTCNonProxiedUDP <> STATE_DEFAULT) then
    UpdatePreference(aBrowser, 'webrtc.nonproxied_udp_enabled', (FWebRTCNonProxiedUDP = STATE_ENABLED));
end;

procedure TOldFMXChromium.doUpdateOwnPreferences;
begin
  if Initialized then doUpdatePreferences(FBrowser);
end;

function TOldFMXChromium.UpdateProxyPrefs(const aBrowser: IOldCefBrowser) : boolean;
var
  TempError : oldustring;
  TempProxy : IOldCefValue;
  TempValue : IOldCefValue;
  TempDict  : IOldCefDictionaryValue;
begin
  Result := False;

  try
    if (aBrowser      <> nil) and
       (aBrowser.Host <> nil) and
       aBrowser.Host.RequestContext.CanSetPreference('proxy') then
      begin
        TempProxy := TOldCefValueRef.New;
        TempValue := TOldCefValueRef.New;
        TempDict  := TOldCefDictionaryValueRef.New;

        case FProxyType of
          CEF_PROXYTYPE_AUTODETECT :
            begin
              TempValue.SetString('auto_detect');
              TempDict.SetValue('mode', TempValue);
            end;

          CEF_PROXYTYPE_SYSTEM :
            begin
              TempValue.SetString('system');
              TempDict.SetValue('mode', TempValue);
            end;

          CEF_PROXYTYPE_FIXED_SERVERS :
            begin
              TempValue.SetString('fixed_servers');
              TempDict.SetValue('mode', TempValue);

              case FProxyScheme of
                psSOCKS4 : TempDict.SetString('server', 'socks4://' + FProxyServer + ':' + inttostr(FProxyPort));
                psSOCKS5 : TempDict.SetString('server', 'socks5://' + FProxyServer + ':' + inttostr(FProxyPort));
                else       TempDict.SetString('server', FProxyServer + ':' + inttostr(FProxyPort));
              end;

              if (length(FProxyByPassList) > 0) then TempDict.SetString('bypass_list', FProxyByPassList);
            end;

          CEF_PROXYTYPE_PAC_SCRIPT :
            begin
              TempValue.SetString('pac_script');
              TempDict.SetValue('mode', TempValue);
              TempDict.SetString('pac_url', FProxyScriptURL);
            end;

          else    // CEF_PROXYTYPE_DIRECT
            begin
              TempValue.SetString('direct');
              TempDict.SetValue('mode', TempValue);
            end;
        end;

        Result := TempProxy.SetDictionary(TempDict) and
                  aBrowser.Host.RequestContext.SetPreference('proxy', TempProxy, TempError);

        if not(Result) then
          OutputDebugMessage('TFMXChromium.UpdateProxyPrefs error : ' + quotedstr(TempError));
      end;
  except
    on e : exception do
      if CustomExceptionHandler('TFMXChromium.UpdateProxyPrefs', e) then raise;
  end;
end;

function TOldFMXChromium.UpdatePreference(const aBrowser: IOldCefBrowser; const aName : string; aValue : boolean) : boolean;
var
  TempError : oldustring;
  TempValue : IOldCefValue;
begin
  Result := False;

  try
    if (aBrowser      <> nil) and
       (aBrowser.Host <> nil) and
       aBrowser.Host.RequestContext.CanSetPreference(aName) then
      begin
        TempValue := TOldCefValueRef.New;

        if aValue then
          TempValue.SetBool(1)
         else
          TempValue.SetBool(0);

        Result := aBrowser.Host.RequestContext.SetPreference(aName, TempValue, TempError);

        if not(Result) then
          OutputDebugMessage('TFMXChromium.UpdatePreference error : ' + quotedstr(TempError));
      end;
  except
    on e : exception do
      if CustomExceptionHandler('TFMXChromium.UpdatePreference', e) then raise;
  end;
end;

function TOldFMXChromium.UpdatePreference(const aBrowser: IOldCefBrowser; const aName : string; aValue : integer) : boolean;
var
  TempError : oldustring;
  TempValue : IOldCefValue;
begin
  Result := False;

  try
    if (aBrowser      <> nil) and
       (aBrowser.Host <> nil) and
       aBrowser.Host.RequestContext.CanSetPreference(aName) then
      begin
        TempValue := TOldCefValueRef.New;
        TempValue.SetInt(aValue);
        Result := aBrowser.Host.RequestContext.SetPreference(aName, TempValue, TempError);

        if not(Result) then
          OutputDebugMessage('TFMXChromium.UpdatePreference error : ' + quotedstr(TempError));
      end;
  except
    on e : exception do
      if CustomExceptionHandler('TFMXChromium.UpdatePreference', e) then raise;
  end;
end;

function TOldFMXChromium.UpdatePreference(const aBrowser: IOldCefBrowser; const aName : string; const aValue : double) : boolean;
var
  TempError : oldustring;
  TempValue : IOldCefValue;
begin
  Result := False;

  try
    if (aBrowser      <> nil) and
       (aBrowser.Host <> nil) and
       aBrowser.Host.RequestContext.CanSetPreference(aName) then
      begin
        TempValue := TOldCefValueRef.New;
        TempValue.SetDouble(aValue);
        Result := aBrowser.Host.RequestContext.SetPreference(aName, TempValue, TempError);

        if not(Result) then
          OutputDebugMessage('TFMXChromium.UpdatePreference error : ' + quotedstr(TempError));
      end;
  except
    on e : exception do
      if CustomExceptionHandler('TFMXChromium.UpdatePreference', e) then raise;
  end;
end;

function TOldFMXChromium.UpdatePreference(const aBrowser: IOldCefBrowser; const aName, aValue : string) : boolean;
var
  TempError : oldustring;
  TempValue : IOldCefValue;
begin
  Result := False;

  try
    if (aBrowser      <> nil) and
       (aBrowser.Host <> nil) and
       aBrowser.Host.RequestContext.CanSetPreference(aName) then
      begin
        TempValue := TOldCefValueRef.New;
        TempValue.SetString(aValue);
        Result := aBrowser.Host.RequestContext.SetPreference(aName, TempValue, TempError);

        if not(Result) then
          OutputDebugMessage('TFMXChromium.UpdatePreference error : ' + quotedstr(TempError));
      end;
  except
    on e : exception do
      if CustomExceptionHandler('TFMXChromium.UpdatePreference', e) then raise;
  end;
end;

function TOldFMXChromium.UpdatePreference(const aBrowser: IOldCefBrowser; const aName : string; const aValue : TStringList) : boolean;
var
  TempError : oldustring;
  TempValue : IOldCefValue;
  TempList  : IOldCefListValue;
  i         : NativeUInt;
  TempSize  : NativeUInt;
begin
  Result := False;

  try
    if (aValue        <> nil) and
       (aValue.Count   > 0)   and
       (aBrowser      <> nil) and
       (aBrowser.Host <> nil) and
       aBrowser.Host.RequestContext.CanSetPreference(aName) then
      begin
        TempSize := aValue.Count;
        TempList := TOldCefListValueRef.New;

        if TempList.SetSize(TempSize) then
          begin
            i := 0;
            while (i < TempSize) do
              begin
                TempList.SetString(i, aValue[i]);
                inc(i);
              end;

            TempValue := TOldCefValueRef.New;
            Result    := TempValue.SetList(TempList) and
                         aBrowser.Host.RequestContext.SetPreference(aName, TempValue, TempError);

            if not(Result) then
              OutputDebugMessage('TChromium.UpdatePreference error : ' + quotedstr(TempError));
          end;
      end;
  except
    on e : exception do
      if CustomExceptionHandler('TFMXChromium.UpdatePreference', e) then raise;
  end;
end;

function TOldFMXChromium.UpdateStringListPref(const aBrowser: IOldCefBrowser; const aName, aValue : string) : boolean;
var
  TempSL : TStringList;
begin
  Result := False;
  TempSL := nil;

  try
    if (length(aName) > 0) and (length(aValue) > 0) then
      begin
        TempSL           := TStringList.Create;
        TempSL.CommaText := aValue;
        Result           := UpdatePreference(aBrowser, aName, TempSL);
      end;
  finally
    if (TempSL <> nil) then FreeAndNil(TempSL);
  end;
end;

procedure TOldFMXChromium.HandleNull(const aValue : IOldCefValue; var aResultSL : TStringList; const aRoot, aKey : string);
var
  TempKey : string;
begin
  if (aRoot <> '') then
    TempKey := aRoot + '.' + aKey
   else
    TempKey := aKey;

  if (length(TempKey) > 0) then
    aResultSL.Add(TempKey + ' : -null-')
   else
    aResultSL.Add('-null-');
end;

procedure TOldFMXChromium.HandleBool(const aValue : IOldCefValue; var aResultSL : TStringList; const aRoot, aKey : string);
var
  TempKey : string;
begin
  if (aRoot <> '') then
    TempKey := aRoot + '.' + aKey
   else
    TempKey := aKey;

  if (length(TempKey) > 0) then
    aResultSL.Add(TempKey + ' : ' + BoolToStr(aValue.GetBool, true))
   else
    aResultSL.Add(BoolToStr(aValue.GetBool, true));
end;

procedure TOldFMXChromium.HandleInteger(const aValue : IOldCefValue; var aResultSL : TStringList; const aRoot, aKey : string);
var
  TempKey : string;
begin
  if (aRoot <> '') then
    TempKey := aRoot + '.' + aKey
   else
    TempKey := aKey;

  if (length(TempKey) > 0) then
    aResultSL.Add(TempKey + ' : ' + IntToStr(aValue.GetInt))
   else
    aResultSL.Add(IntToStr(aValue.GetInt));
end;

procedure TOldFMXChromium.HandleDouble(const aValue : IOldCefValue; var aResultSL : TStringList; const aRoot, aKey : string);
var
  TempKey : string;
begin
  if (aRoot <> '') then
    TempKey := aRoot + '.' + aKey
   else
    TempKey := aKey;

  if (length(TempKey) > 0) then
    aResultSL.Add(TempKey + ' : ' + FloatToStr(aValue.GetDouble))
   else
    aResultSL.Add(FloatToStr(aValue.GetDouble));
end;

procedure TOldFMXChromium.HandleString(const aValue : IOldCefValue; var aResultSL : TStringList; const aRoot, aKey : string);
var
  TempKey : string;
begin
  if (aRoot <> '') then
    TempKey := aRoot + '.' + aKey
   else
    TempKey := aKey;

  if (length(TempKey) > 0) then
    aResultSL.Add(TempKey + ' : ' + aValue.GetString)
   else
    aResultSL.Add(aValue.GetString);
end;

procedure TOldFMXChromium.HandleBinary(const aValue : IOldCefValue; var aResultSL : TStringList; const aRoot, aKey : string);
var
  TempKey : string;
begin
  if (aRoot <> '') then
    TempKey := aRoot + '.' + aKey
   else
    TempKey := aKey;

  if (length(TempKey) > 0) then
    aResultSL.Add(TempKey + ' : -binary-')
   else
    aResultSL.Add('-binary-');
end;

procedure TOldFMXChromium.HandleList(const aValue : IOldCefValue; var aResultSL : TStringList; const aRoot, aKey : string);
var
  TempKey, TempResult : string;
  i, j : integer;
  TempList : IOldCefListValue;
  TempValue : IOldCefValue;
  TempSL : TStringList;
begin
  if (aRoot <> '') then
    TempKey := aRoot + '.' + aKey
   else
    TempKey := aKey;

  TempList := aValue.GetList;
  TempSL   := TStringList.Create;

  i := 0;
  j := TempList.GetSize;

  TempResult := '(' + inttostr(j) + '){';

  while (i < j) do
    begin
      TempValue := TempList.GetValue(i);

      case TempValue.GetType of
        VTYPE_NULL       : TempResult := TempResult + '-null-,';
        VTYPE_BOOL       : TempResult := TempResult + BoolToStr(TempValue.GetBool, true) + ',';
        VTYPE_INT        : TempResult := TempResult + IntToStr(TempValue.GetInt) + ',';
        VTYPE_DOUBLE     : TempResult := TempResult + FloatToStr(TempValue.GetDouble) + ',';
        VTYPE_STRING     : TempResult := TempResult + TempValue.GetString + ',';
        VTYPE_BINARY     : TempResult := TempResult + '-binary-,';
        VTYPE_DICTIONARY :
          begin
            TempSL.Clear;
            HandleDictionary(TempValue.GetDictionary, TempSL, '');
            TempResult := TempResult + TempSL.CommaText + ',';
          end;

        VTYPE_LIST       :
          begin
            TempSL.Clear;
            HandleList(TempValue, TempSL, '', '');
            TempResult := TempResult + TempSL.CommaText + ',';
          end;

        else TempResult := TempResult + '-invalid-,';
      end;

      inc(i);
    end;

  i := length(TempResult);
  if (i > 0) and (TempResult[i] = ',') then TempResult := copy(TempResult, 1, pred(i));
  TempResult := TempResult + '}';

  if (length(TempKey) > 0) then
    aResultSL.Add(TempKey + ' : ' + TempResult)
   else
    aResultSL.Add(TempResult);

  TempSL.Free;
end;

procedure TOldFMXChromium.HandleInvalid(const aValue : IOldCefValue; var aResultSL : TStringList; const aRoot, aKey : string);
var
  TempKey : string;
begin
  if (aRoot <> '') then
    TempKey := aRoot + '.' + aKey
   else
    TempKey := aKey;

  if (length(TempKey) > 0) then
    aResultSL.Add(TempKey + ' : -invalid-')
   else
    aResultSL.Add('-invalid-');
end;

procedure TOldFMXChromium.HandleDictionary(const aDict : IOldCefDictionaryValue; var aResultSL : TStringList; const aRoot : string);
var
  TempKeys : TStringList;
  i, j : integer;
  TempValue : IOldCefValue;
  TempNewKey : string;
begin
  TempKeys := nil;

  try
    try
      if (aDict <> nil) then
        begin
          TempKeys := TStringList.Create;
          aDict.GetKeys(TempKeys);

          i := 0;
          j := TempKeys.Count;

          while (i < j) do
            begin
              TempValue := aDict.GetValue(TempKeys[i]);

              case TempValue.GetType of
                VTYPE_NULL       : HandleNull(TempValue, aResultSL, aRoot, TempKeys[i]);
                VTYPE_BOOL       : HandleBool(TempValue, aResultSL, aRoot, TempKeys[i]);
                VTYPE_INT        : HandleInteger(TempValue, aResultSL, aRoot, TempKeys[i]);
                VTYPE_DOUBLE     : HandleDouble(TempValue, aResultSL, aRoot, TempKeys[i]);
                VTYPE_STRING     : HandleString(TempValue, aResultSL, aRoot, TempKeys[i]);
                VTYPE_BINARY     : HandleBinary(TempValue, aResultSL, aRoot, TempKeys[i]);
                VTYPE_LIST       : HandleList(TempValue, aResultSL, aRoot, TempKeys[i]);
                VTYPE_DICTIONARY :
                  begin
                    if (length(aRoot) > 0) then
                      TempNewKey := aRoot + '.' + TempKeys[i]
                     else
                      TempNewKey := TempKeys[i];

                    HandleDictionary(TempValue.GetDictionary, aResultSL, TempNewKey);
                  end;

                else
                  HandleInvalid(TempValue, aResultSL, aRoot, TempKeys[i]);
              end;

              inc(i);
            end;

        end;
    except
      on e : exception do
        if CustomExceptionHandler('TFMXChromium.HandleDictionary', e) then raise;
    end;
  finally
    if (TempKeys <> nil) then TempKeys.Free;
  end;
end;

function TOldFMXChromium.doSavePreferences : boolean;
var
  TempDict  : IOldCefDictionaryValue;
  TempPrefs : TStringList;
begin
  Result    := False;
  TempPrefs := nil;

  try
    try
      if Initialized then
        begin
          TempPrefs := TStringList.Create;
          TempDict  := FBrowser.Host.RequestContext.GetAllPreferences(True);
          HandleDictionary(TempDict, TempPrefs, '');
          TempPrefs.SaveToFile(FPrefsFileName);
          Result    := True;
        end;
    except
      on e : exception do
        if CustomExceptionHandler('TFMXChromium.Internal_SavePreferences', e) then raise;
    end;
  finally
    if (TempPrefs <> nil) then FreeAndNil(TempPrefs);
  end;
end;

procedure TOldFMXChromium.doResolvedHostAvailable(result: TOldCefErrorCode; const resolvedIps: TStrings);
begin
  if assigned(FOnResolvedHostAvailable) then FOnResolvedHostAvailable(self, result, resolvedIps);
end;

function TOldFMXChromium.MustCreateLoadHandler : boolean;
begin
  Result := assigned(FOnLoadStart) or
            assigned(FOnLoadEnd)   or
            assigned(FOnLoadError) or
            assigned(FOnLoadingStateChange);
end;

function TOldFMXChromium.MustCreateFocusHandler : boolean;
begin
  Result := assigned(FOnTakeFocus) or
            assigned(FOnSetFocus)  or
            assigned(FOnGotFocus);
end;

function TOldFMXChromium.MustCreateContextMenuHandler : boolean;
begin
  Result := assigned(FOnBeforeContextMenu)  or
            assigned(FOnRunContextMenu)     or
            assigned(FOnContextMenuCommand) or
            assigned(FOnContextMenuDismissed);
end;

function TOldFMXChromium.MustCreateDialogHandler : boolean;
begin
  Result := assigned(FOnFileDialog);
end;

function TOldFMXChromium.MustCreateKeyboardHandler : boolean;
begin
  Result := assigned(FOnPreKeyEvent) or
            assigned(FOnKeyEvent);
end;

function TOldFMXChromium.MustCreateDisplayHandler : boolean;
begin
  Result := assigned(FOnAddressChange)        or
            assigned(FOnTitleChange)          or
            assigned(FOnFavIconUrlChange)     or
            assigned(FOnFullScreenModeChange) or
            assigned(FOnTooltip)              or
            assigned(FOnStatusMessage)        or
            assigned(FOnConsoleMessage);
end;

function TOldFMXChromium.MustCreateDownloadHandler : boolean;
begin
  Result := assigned(FOnBeforeDownload) or
            assigned(FOnDownloadUpdated);
end;

function TOldFMXChromium.MustCreateGeolocationHandler : boolean;
begin
  Result := assigned(FOnRequestGeolocationPermission) or
            assigned(FOnCancelGeolocationPermission);
end;

function TOldFMXChromium.MustCreateJsDialogHandler : boolean;
begin
  Result := assigned(FOnJsdialog)           or
            assigned(FOnBeforeUnloadDialog) or
            assigned(FOnResetDialogState)   or
            assigned(FOnDialogClosed);
end;

function TOldFMXChromium.MustCreateDragHandler : boolean;
begin
  Result := assigned(FOnDragEnter) or
            assigned(FOnDraggableRegionsChanged);
end;

function TOldFMXChromium.MustCreateFindHandler : boolean;
begin
  Result := assigned(FOnFindResult);
end;

procedure TOldFMXChromium.doTextResultAvailable(const aText : string);
begin
  if assigned(FOnTextResultAvailable) then FOnTextResultAvailable(self, aText);
end;

procedure TOldFMXChromium.ExecuteJavaScript(const aCode, aScriptURL, aFrameName : oldustring; aStartLine : integer);
var
  TempFrame : IOldCefFrame;
begin
  try
    if Initialized then
      begin
        if (length(aFrameName) > 0) then
          TempFrame := FBrowser.GetFrame(aFrameName)
         else
          TempFrame := FBrowser.MainFrame;

        if (TempFrame <> nil) then
          TempFrame.ExecuteJavaScript(aCode, aScriptURL, aStartLine);
      end;
  except
    on e : exception do
      if CustomExceptionHandler('TFMXChromium.ExecuteJavaScript', e) then raise;
  end;
end;

procedure TOldFMXChromium.ExecuteJavaScript(const aCode, aScriptURL : oldustring; const aFrame : IOldCefFrame; aStartLine : integer);
begin
  try
    if Initialized and (aFrame <> nil) then
      aFrame.ExecuteJavaScript(aCode, aScriptURL, aStartLine);
  except
    on e : exception do
      if CustomExceptionHandler('TFMXChromium.ExecuteJavaScript', e) then raise;
  end;
end;

procedure TOldFMXChromium.ExecuteJavaScript(const aCode, aScriptURL : oldustring; const aFrameIdentifier : int64; aStartLine : integer = 0);
var
  TempFrame : IOldCefFrame;
begin
  try
    if Initialized then
      begin
        if (aFrameIdentifier <> 0) then
          TempFrame := FBrowser.GetFrameByident(aFrameIdentifier)
         else
          TempFrame := FBrowser.MainFrame;

        if (TempFrame <> nil) then
          TempFrame.ExecuteJavaScript(aCode, aScriptURL, aStartLine);
      end;
  except
    on e : exception do
      if CustomExceptionHandler('TFMXChromium.ExecuteJavaScript', e) then raise;
  end;
end;

procedure TOldFMXChromium.doCookiesDeleted(numDeleted : integer);
begin
  if assigned(FOnCookiesDeleted) then FOnCookiesDeleted(self, numDeleted);
end;

procedure TOldFMXChromium.doPdfPrintFinished(aResultOK : boolean);
begin
  if assigned(FOnPdfPrintFinished) then FOnPdfPrintFinished(self, aResultOK);
end;

function TOldFMXChromium.doOnClose(const browser: IOldCefBrowser): Boolean;
var
  TempAction : TOldCefCloseBrowserAction;
begin
  Result     := False;
  TempAction := cbaClose;

  // TempAction values
  // -----------------
  // cbaCancel : stop closing the browser
  // cbaClose  : continue closing the browser
  // cbaDelay  : stop closing the browser momentarily. Used when the application
  //             needs to execute some custom processes before closing the
  //             browser. This is usually needed to destroy a TOldCefWindowParent
  //             in the main thread before closing the browser.
  if Assigned(FOnClose) then FOnClose(Self, browser, TempAction);

  case TempAction of
    cbaCancel : Result := True;
    cbaClose  : if (browser <> nil) and (FBrowserId = browser.Identifier) then FClosing := True;
    cbaDelay  :
      begin
        Result := True;
        if (browser <> nil) and (FBrowserId = browser.Identifier) then FClosing := True;
      end;
  end;
end;

procedure TOldFMXChromium.doOnBeforeClose(const browser: IOldCefBrowser);
begin
  if (browser <> nil) and (FBrowserId = browser.Identifier) then
    begin
      FInitialized := False;
      ClearBrowserReference;
      DestroyClientHandler;
    end;

  if Assigned(FOnBeforeClose) then FOnBeforeClose(Self, browser);
end;

procedure TOldFMXChromium.doOnAddressChange(const browser: IOldCefBrowser; const frame: IOldCefFrame; const url: oldustring);
begin
  if Assigned(FOnAddressChange) then FOnAddressChange(Self, browser, frame, url);
end;

procedure TOldFMXChromium.doOnAfterCreated(const browser: IOldCefBrowser);
begin
  if MultithreadApp and (FBrowser = nil) and (browser <> nil) then
    begin
      FBrowser     := browser;
      FBrowserId   := browser.Identifier;
      FInitialized := (FBrowserId <> 0);
    end;

  doUpdatePreferences(browser);

  if Assigned(FOnAfterCreated) then FOnAfterCreated(Self, browser);
end;

function TOldFMXChromium.doRunModal(const browser: IOldCefBrowser): Boolean;
begin
  Result := False;

  if assigned(FOnRunModal) then FOnRunModal(self, browser, Result);
end;

function TOldFMXChromium.doOnBeforeBrowse(const browser    : IOldCefBrowser;
                                       const frame      : IOldCefFrame;
                                       const request    : IOldCefRequest;
                                             isRedirect : Boolean): Boolean;
begin
  Result := False;

  if FUpdatePreferences then doUpdatePreferences(browser);

  if Assigned(FOnBeforeBrowse) then FOnBeforeBrowse(Self, browser, frame, request, isRedirect, Result);
end;

procedure TOldFMXChromium.doOnBeforeContextMenu(const browser : IOldCefBrowser;
                                             const frame   : IOldCefFrame;
                                             const params  : IOldCefContextMenuParams;
                                             const model   : IOldCefMenuModel);
begin
  if Assigned(FOnBeforeContextMenu) then FOnBeforeContextMenu(Self, browser, frame, params, model);
end;

function TOldFMXChromium.doRunContextMenu(const browser  : IOldCefBrowser;
                                       const frame    : IOldCefFrame;
                                       const params   : IOldCefContextMenuParams;
                                       const model    : IOldCefMenuModel;
                                       const callback : IOldCefRunContextMenuCallback): Boolean;
begin
  Result := False;

  if Assigned(FOnRunContextMenu) then FOnRunContextMenu(Self, browser, frame, params, model, callback, Result);
end;

procedure TOldFMXChromium.doOnBeforeDownload(const browser       : IOldCefBrowser;
                                          const downloadItem  : IOldCefDownloadItem;
                                          const suggestedName : oldustring;
                                          const callback      : IOldCefBeforeDownloadCallback);
begin
  if Assigned(FOnBeforeDownload) then FOnBeforeDownload(Self, browser, downloadItem, suggestedName, callback);
end;

function TOldFMXChromium.doOnBeforePopup(const browser            : IOldCefBrowser;
                                      const frame              : IOldCefFrame;
                                      const targetUrl          : oldustring;
                                      const targetFrameName    : oldustring;
                                            targetDisposition  : TOldCefWindowOpenDisposition;
                                            userGesture        : Boolean;
                                      const popupFeatures      : TOldCefPopupFeatures;
                                      var   windowInfo         : TOldCefWindowInfo;
                                      var   client             : IOldCefClient;
                                      var   settings           : TOldCefBrowserSettings;
                                      var   noJavascriptAccess : Boolean): Boolean;
begin
  Result := False;

  if Assigned(FOnBeforePopup) then
    FOnBeforePopup(Self, browser, frame, targetUrl, targetFrameName,
                   targetDisposition, userGesture, popupFeatures, windowInfo, client,
                   settings, noJavascriptAccess, Result);
end;

function TOldFMXChromium.doOnBeforeResourceLoad(const browser  : IOldCefBrowser;
                                             const frame    : IOldCefFrame;
                                             const request  : IOldCefRequest;
                                             const callback : IOldCefRequestCallback): TOldCefReturnValue;
var
  TempHeaderMap : IOldCefStringMultimap;
begin
  if FAddCustomHeader then
    try
      TempHeaderMap := TOldCefStringMultimapOwn.Create;
      request.GetHeaderMap(TempHeaderMap);
      TempHeaderMap.Append(FCustomHeaderName, FCustomHeaderValue);
      request.SetHeaderMap(TempHeaderMap);
    finally
      TempHeaderMap := nil;
    end;

  if not(FSendReferrer) then request.SetReferrer('', REFERRER_POLICY_NEVER);

  Result := RV_CONTINUE;

  if Assigned(FOnBeforeResourceLoad) then FOnBeforeResourceLoad(Self, browser, frame, request, callback, Result);
end;

function TOldFMXChromium.doOnBeforeUnloadDialog(const browser     : IOldCefBrowser;
                                             const messageText : oldustring;
                                                   isReload    : Boolean;
                                             const callback    : IOldCefJsDialogCallback): Boolean;
begin
  Result := False;

  if Assigned(FOnBeforeUnloadDialog) then FOnBeforeUnloadDialog(Self, browser, messageText, isReload, callback, Result);
end;

function TOldFMXChromium.doOnCertificateError(const browser    : IOldCefBrowser;
                                                 certError  : TOldCefErrorcode;
                                           const requestUrl : oldustring;
                                           const sslInfo    : IOldCefSslInfo;
                                           const callback   : IOldCefRequestCallback): Boolean;
begin
  Result := False;

  if Assigned(FOnCertificateError) then
    FOnCertificateError(Self, browser, certError, requestUrl, sslInfo, callback, Result);
end;

function TOldFMXChromium.doOnConsoleMessage(const browser  : IOldCefBrowser;
                                         const aMessage : oldustring;
                                         const source   : oldustring;
                                               line     : Integer): Boolean;
begin
  Result := False;

  if Assigned(FOnConsoleMessage) then FOnConsoleMessage(Self, browser, aMessage, source, line, Result);
end;

function TOldFMXChromium.doOnContextMenuCommand(const browser    : IOldCefBrowser;
                                             const frame      : IOldCefFrame;
                                             const params     : IOldCefContextMenuParams;
                                                   commandId  : Integer;
                                                   eventFlags : TOldCefEventFlags): Boolean;
begin
  Result := False;

  if Assigned(FOnContextMenuCommand) then
    FOnContextMenuCommand(Self, browser, frame, params, commandId, eventFlags, Result);
end;

procedure TOldFMXChromium.doOnContextMenuDismissed(const browser: IOldCefBrowser; const frame: IOldCefFrame);
begin
  if Assigned(FOnContextMenuDismissed) then FOnContextMenuDismissed(Self, browser, frame);
end;

procedure TOldFMXChromium.doOnCursorChange(const browser          : IOldCefBrowser;
                                              cursor           : TOldCefCursorHandle;
                                              cursorType       : TOldCefCursorType;
                                        const customCursorInfo : POldCefCursorInfo);
begin
  if assigned(FOnCursorChange) then FOnCursorChange(self, browser, cursor, cursorType, customCursorInfo);
end;

procedure TOldFMXChromium.doOnDialogClosed(const browser: IOldCefBrowser);
begin
  if Assigned(FOnDialogClosed) then FOnDialogClosed(Self, browser);
end;

procedure TOldFMXChromium.doOnDownloadUpdated(const browser      : IOldCefBrowser;
                                           const downloadItem : IOldCefDownloadItem;
                                           const callback     : IOldCefDownloadItemCallback);
begin
  if Assigned(FOnDownloadUpdated) then FOnDownloadUpdated(Self, browser, downloadItem, callback);
end;

function TOldFMXChromium.doOnRequestGeolocationPermission(const browser       : IOldCefBrowser;
                                                       const requestingUrl : oldustring;
                                                             requestId     : Integer;
                                                       const callback      : IOldCefGeolocationCallback): Boolean;
begin
  Result := False;

  if Assigned(FOnRequestGeolocationPermission) then
    FOnRequestGeolocationPermission(Self, browser, requestingUrl, requestId, callback, Result);
end;

procedure TOldFMXChromium.doOnCancelGeolocationPermission(const browser : IOldCefBrowser; requestId : Integer);
begin
  if Assigned(FOnCancelGeolocationPermission) then
    FOnCancelGeolocationPermission(Self, browser, requestId);
end;

function TOldFMXChromium.doOnDragEnter(const browser  : IOldCefBrowser;
                                    const dragData : IOldCefDragData;
                                          mask     : TOldCefDragOperations): Boolean;
begin
  Result := False;

  if Assigned(FOnDragEnter) then FOnDragEnter(Self, browser, dragData, mask, Result);
end;

procedure TOldFMXChromium.doOnDraggableRegionsChanged(const browser      : IOldCefBrowser;
                                                         regionsCount : NativeUInt;
                                                         regions      : POldCefDraggableRegionArray);
begin
  if Assigned(FOnDraggableRegionsChanged) then FOnDraggableRegionsChanged(Self, browser, regionsCount, regions);
end;

procedure TOldFMXChromium.doOnFaviconUrlChange(const browser: IOldCefBrowser; const iconUrls: TStrings);
begin
  if Assigned(FOnFavIconUrlChange) then FOnFavIconUrlChange(Self, browser, iconUrls);
end;

function TOldFMXChromium.doOnFileDialog(const browser              : IOldCefBrowser;
                                           mode                 : TOldCefFileDialogMode;
                                     const title                : oldustring;
                                     const defaultFilePath      : oldustring;
                                     const acceptFilters        : TStrings;
                                           selectedAcceptFilter : Integer;
                                     const callback             : IOldCefFileDialogCallback): Boolean;
begin
  Result := False;

  if Assigned(FOnFileDialog) then
    FOnFileDialog(Self, browser, mode, title, defaultFilePath, acceptFilters,
                  selectedAcceptFilter, callback, Result);
end;

procedure TOldFMXChromium.doOnFindResult(const browser            : IOldCefBrowser;
                                            identifier         : integer;
                                            count              : Integer;
                                      const selectionRect      : POldCefRect;
                                            activeMatchOrdinal : Integer;
                                            finalUpdate        : Boolean);
begin
  if Assigned(FOnFindResult) then
    FOnFindResult(Self, browser, identifier, count, selectionRect, activeMatchOrdinal, finalUpdate);
end;

procedure TOldFMXChromium.doOnFullScreenModeChange(const browser: IOldCefBrowser; fullscreen: Boolean);
begin
  if Assigned(FOnFullScreenModeChange) then FOnFullScreenModeChange(Self, browser, fullscreen);
end;

function TOldFMXChromium.doOnGetAuthCredentials(const browser  : IOldCefBrowser;
                                             const frame    : IOldCefFrame;
                                                   isProxy  : Boolean;
                                             const host     : oldustring;
                                                   port     : Integer;
                                             const realm    : oldustring;
                                             const scheme   : oldustring;
                                             const callback : IOldCefAuthCallback): Boolean;
begin
  Result := False;

  if isProxy then
    begin
      if (FProxyType = CEF_PROXYTYPE_FIXED_SERVERS) and (callback <> nil) then
        begin
          Result := True;
          callback.cont(FProxyUsername, FProxyPassword);
        end;
    end
   else
    if (frame <> nil) and frame.IsMain and Assigned(FOnGetAuthCredentials) then
      FOnGetAuthCredentials(Self, browser, frame, isProxy, host, port, realm, scheme, callback, Result);
end;

function TOldFMXChromium.doOnGetResourceHandler(const browser : IOldCefBrowser;
                                             const frame   : IOldCefFrame;
                                             const request : IOldCefRequest): IOldCefResourceHandler;
begin
  Result := nil;

  if Assigned(FOnGetResourceHandler) then
    FOnGetResourceHandler(Self, browser, frame, request, Result);
end;

function TOldFMXChromium.doOnGetRootScreenRect(const browser: IOldCefBrowser; var rect: TOldCefRect): Boolean;
begin
  Result := False;

  if Assigned(FOnGetRootScreenRect) then FOnGetRootScreenRect(Self, browser, rect, Result);
end;

function TOldFMXChromium.doOnGetScreenInfo(const browser: IOldCefBrowser; var screenInfo: TOldCefScreenInfo): Boolean;
begin
  Result := False;

  if Assigned(FOnGetScreenInfo) then FOnGetScreenInfo(Self, browser, screenInfo, Result);
end;

function TOldFMXChromium.doOnGetScreenPoint(const browser: IOldCefBrowser; viewX, viewY: Integer; var screenX, screenY: Integer): Boolean;
begin
  Result := False;

  if Assigned(FOnGetScreenPoint) then FOnGetScreenPoint(Self, browser, viewX, viewY, screenX, screenY, Result);
end;

function TOldFMXChromium.doOnGetViewRect(const browser: IOldCefBrowser; var rect: TOldCefRect): Boolean;
begin
  Result := False;

  if Assigned(FOnGetViewRect) then FOnGetViewRect(Self, browser, rect, Result);
end;

procedure TOldFMXChromium.doOnGotFocus(const browser: IOldCefBrowser);
begin
  if Assigned(FOnGotFocus) then FOnGotFocus(Self, browser)
end;

function TOldFMXChromium.doOnJsdialog(const browser           : IOldCefBrowser;
                                   const originUrl         : oldustring;
                                   const accept_lang       : oldustring;
                                         dialogType        : TOldCefJsDialogType;
                                   const messageText       : oldustring;
                                   const defaultPromptText : oldustring;
                                   const callback          : IOldCefJsDialogCallback;
                                   out   suppressMessage   : Boolean): Boolean;
begin
  Result := False;

  if not(Initialized) then
    suppressMessage := True
   else
    begin
      suppressMessage := False;

      if Assigned(FOnJsdialog) then
        FOnJsdialog(Self, browser, originUrl, accept_lang, dialogType, messageText,
                    defaultPromptText, callback, suppressMessage, Result);
    end;
end;

function TOldFMXChromium.doOnKeyEvent(const browser : IOldCefBrowser;
                                   const event   : POldCefKeyEvent;
                                         osEvent : TOldCefEventHandle): Boolean;
begin
  Result := False;

  if Assigned(FOnKeyEvent) then FOnKeyEvent(Self, browser, event, osEvent, Result);
end;

procedure TOldFMXChromium.doOnLoadEnd(const browser        : IOldCefBrowser;
                                   const frame          : IOldCefFrame;
                                         httpStatusCode : Integer);
begin
  if Assigned(FOnLoadEnd) then FOnLoadEnd(Self, browser, frame, httpStatusCode);
end;

procedure TOldFMXChromium.doOnLoadError(const browser   : IOldCefBrowser;
                                     const frame     : IOldCefFrame;
                                           errorCode : TOldCefErrorCode;
                                     const errorText : oldustring;
                                     const failedUrl : oldustring);
begin
  if Assigned(FOnLoadError) then FOnLoadError(Self, browser, frame, errorCode, errorText, failedUrl);
end;

procedure TOldFMXChromium.doOnLoadingStateChange(const browser: IOldCefBrowser; isLoading, canGoBack, canGoForward: Boolean);
begin
  if Assigned(FOnLoadingStateChange) then FOnLoadingStateChange(Self, browser, isLoading, canGoBack, canGoForward);
end;

procedure TOldFMXChromium.doOnLoadStart(const browser: IOldCefBrowser; const frame: IOldCefFrame);
begin
  if Assigned(FOnLoadStart) then FOnLoadStart(Self, browser, frame);
end;

function TOldFMXChromium.doOnOpenUrlFromTab(const browser           : IOldCefBrowser;
                                         const frame             : IOldCefFrame;
                                         const targetUrl         : oldustring;
                                               targetDisposition : TOldCefWindowOpenDisposition;
                                               userGesture       : Boolean): Boolean;
begin
  Result := False;

  if Assigned(FOnOpenUrlFromTab) then
    FOnOpenUrlFromTab(Self, browser, frame, targetUrl, targetDisposition, userGesture, Result);
end;

procedure TOldFMXChromium.doOnPaint(const browser         : IOldCefBrowser;
                                       kind            : TOldCefPaintElementType;
                                       dirtyRectsCount : NativeUInt;
                                 const dirtyRects      : POldCefRectArray;
                                 const buffer          : Pointer;
                                       width           : Integer;
                                       height          : Integer);
begin
  if Assigned(FOnPaint) then FOnPaint(Self, browser, kind, dirtyRectsCount, dirtyRects, buffer, width, height);
end;

procedure TOldFMXChromium.doOnPluginCrashed(const browser: IOldCefBrowser; const pluginPath: oldustring);
begin
  if Assigned(FOnPluginCrashed) then FOnPluginCrashed(Self, browser, pluginPath);
end;

procedure TOldFMXChromium.doOnPopupShow(const browser: IOldCefBrowser; show: Boolean);
begin
  if assigned(FOnPopupShow) then FOnPopupShow(self, browser, show);
end;

procedure TOldFMXChromium.doOnPopupSize(const browser: IOldCefBrowser; const rect: POldCefRect);
begin
  if assigned(FOnPopupSize) then FOnPopupSize(self, browser, rect);
end;

function TOldFMXChromium.doOnPreKeyEvent(const browser            : IOldCefBrowser;
                                      const event              : POldCefKeyEvent;
                                            osEvent            : TOldCefEventHandle;
                                      out   isKeyboardShortcut : Boolean): Boolean;
begin
  Result := False;

  if Assigned(FOnPreKeyEvent) then FOnPreKeyEvent(Self, browser, event, osEvent, isKeyboardShortcut, Result);
end;

function TOldFMXChromium.doOnProcessMessageReceived(const browser       : IOldCefBrowser;
                                                       sourceProcess : TOldCefProcessId;
                                                 const aMessage      : IOldCefProcessMessage): Boolean;
begin
  Result := False;

  if Assigned(FOnProcessMessageReceived) then
    FOnProcessMessageReceived(Self, browser, sourceProcess, aMessage, Result);
end;

procedure TOldFMXChromium.doOnProtocolExecution(const browser          : IOldCefBrowser;
                                             const url              : oldustring;
                                             out   allowOsExecution : Boolean);
begin
  if Assigned(FOnProtocolExecution) then FOnProtocolExecution(Self, browser, url, allowOsExecution);
end;

function TOldFMXChromium.doOnQuotaRequest(const browser   : IOldCefBrowser;
                                       const originUrl : oldustring;
                                             newSize   : Int64;
                                       const callback  : IOldCefRequestCallback): Boolean;
begin
  Result := False;

  if Assigned(FOnQuotaRequest) then FOnQuotaRequest(Self, browser, originUrl, newSize, callback, Result);
end;

procedure TOldFMXChromium.doOnRenderProcessTerminated(const browser: IOldCefBrowser; status: TOldCefTerminationStatus);
begin
  if Assigned(FOnRenderProcessTerminated) then FOnRenderProcessTerminated(Self, browser, status);
end;

procedure TOldFMXChromium.doOnRenderViewReady(const browser: IOldCefBrowser);
begin
  {$IFDEF MSWINDOWS}
  if (browser            <> nil)        and
     (browser.Host       <> nil)        and
     (browser.Identifier =  FBrowserId) then
    begin
      FBrowserCompHWND := browser.Host.WindowHandle;

      if (FBrowserCompHWND <> 0) then
        FWidgetCompHWND := FindWindowEx(FBrowserCompHWND, 0, 'Chrome_WidgetWin_0', '');

      if (FWidgetCompHWND <> 0) then
        FRenderCompHWND := FindWindowEx(FWidgetCompHWND, 0, 'Chrome_RenderWidgetHostHWND', 'Chrome Legacy Window');

      if assigned(FOnBrowserCompMsg) and (FBrowserCompHWND <> 0) and (FOldBrowserCompWndPrc = nil) then
        begin
          CreateStub(BrowserCompWndProc, FBrowserCompStub);
          FOldBrowserCompWndPrc := TFNWndProc(SetWindowLongPtr(FBrowserCompHWND,
                                                               GWL_WNDPROC,
                                                               NativeInt(FBrowserCompStub)));
        end;

      if assigned(FOnWidgetCompMsg) and (FWidgetCompHWND <> 0) and (FOldWidgetCompWndPrc = nil) then
        begin
          CreateStub(WidgetCompWndProc, FWidgetCompStub);
          FOldWidgetCompWndPrc := TFNWndProc(SetWindowLongPtr(FWidgetCompHWND,
                                                              GWL_WNDPROC,
                                                              NativeInt(FWidgetCompStub)));
        end;

      if assigned(FOnRenderCompMsg) and (FRenderCompHWND <> 0) and (FOldRenderCompWndPrc = nil) then
        begin
          CreateStub(RenderCompWndProc, FRenderCompStub);
          FOldRenderCompWndPrc := TFNWndProc(SetWindowLongPtr(FRenderCompHWND,
                                                              GWL_WNDPROC,
                                                              NativeInt(FRenderCompStub)));
        end;
    end;
  {$ENDIF}

  if Assigned(FOnRenderViewReady) then FOnRenderViewReady(Self, browser);
end;

procedure TOldFMXChromium.doOnResetDialogState(const browser: IOldCefBrowser);
begin
  if Assigned(FOnResetDialogState) then FOnResetDialogState(Self, browser);
end;

procedure TOldFMXChromium.doOnResourceRedirect(const browser  : IOldCefBrowser;
                                            const frame    : IOldCefFrame;
                                            const request  : IOldCefRequest;
                                            var   newUrl   : oldustring);
begin
  if Assigned(FOnResourceRedirect) then FOnResourceRedirect(Self, browser, frame, request, newUrl);
end;

function TOldFMXChromium.doOnResourceResponse(const browser  : IOldCefBrowser;
                                           const frame    : IOldCefFrame;
                                           const request  : IOldCefRequest;
                                           const response : IOldCefResponse): Boolean;
begin
  Result := False;

  if Assigned(FOnResourceResponse) then FOnResourceResponse(Self, browser, frame, request, response, Result);
end;
function TOldFMXChromium.doOnGetResourceResponseFilter(const browser  : IOldCefBrowser;
                                                    const frame    : IOldCefFrame;
                                                    const request  : IOldCefRequest;
                                                    const response : IOldCefResponse) : IOldCefResponseFilter;
begin
  Result := nil;

  if Assigned(FOnGetResourceResponseFilter) then
    FOnGetResourceResponseFilter(self, browser, frame, request, response, Result);
end;

procedure TOldFMXChromium.doOnResourceLoadComplete(const browser               : IOldCefBrowser;
                                                const frame                 : IOldCefFrame;
                                                const request               : IOldCefRequest;
                                                const response              : IOldCefResponse;
                                                      status                : TOldCefUrlRequestStatus;
                                                      receivedContentLength : Int64);
begin
  if Assigned(FOnResourceLoadComplete) then
    FOnResourceLoadComplete(self, browser, frame, request, response, status, receivedContentLength);
end;

procedure TOldFMXChromium.doOnScrollOffsetChanged(const browser: IOldCefBrowser; x, y: Double);
begin
  if Assigned(FOnScrollOffsetChanged) then FOnScrollOffsetChanged(Self, browser, x, y);
end;

function TOldFMXChromium.doOnSetFocus(const browser: IOldCefBrowser; source: TOldCefFocusSource): Boolean;
begin
  Result := False;

  if Assigned(FOnSetFocus) then FOnSetFocus(Self, browser, source, Result);
end;

function TOldFMXChromium.doOnStartDragging(const browser    : IOldCefBrowser;
                                        const dragData   : IOldCefDragData;
                                              allowedOps : TOldCefDragOperations;
                                              x          : integer;
                                              y          : Integer): Boolean;
begin
  Result := False;
end;

procedure TOldFMXChromium.doOnStatusMessage(const browser: IOldCefBrowser; const value: oldustring);
begin
  if Assigned(FOnStatusMessage) then FOnStatusMessage(Self, browser, value);
end;

procedure TOldFMXChromium.doOnTakeFocus(const browser: IOldCefBrowser; next: Boolean);
begin
  if Assigned(FOnTakeFocus) then FOnTakeFocus(Self, browser, next);
end;

procedure TOldFMXChromium.doOnTitleChange(const browser: IOldCefBrowser; const title: oldustring);
begin
  if Assigned(FOnTitleChange) then FOnTitleChange(Self, browser, title);
end;

function TOldFMXChromium.doOnTooltip(const browser: IOldCefBrowser; var text: oldustring): Boolean;
begin
  Result := False;

  if Assigned(FOnTooltip) then FOnTooltip(Self, browser, text, Result);
end;

procedure TOldFMXChromium.doOnUpdateDragCursor(const browser: IOldCefBrowser; operation: TOldCefDragOperation);
begin
  //
end;

function TOldFMXChromium.GetParentForm : TCustomForm;
var
  TempComp : TComponent;
begin
  Result   := nil;
  TempComp := Owner;

  while (TempComp <> nil) do
    if (TempComp is TCustomForm) then
      begin
        Result := TCustomForm(TempComp);
        exit;
      end
     else
      TempComp := TempComp.owner;
end;

{$IFDEF MSWINDOWS}
procedure TOldFMXChromium.CreateStub(const aMethod : TWndMethod; var aStub : Pointer);
begin
  if (aStub = nil) then aStub := MakeObjectInstance(aMethod);
end;

procedure TOldFMXChromium.FreeAndNilStub(var aStub : pointer);
begin
  if (aStub <> nil) then
    begin
      FreeObjectInstance(aStub);
      aStub := nil;
    end;
end;

procedure TOldFMXChromium.BrowserCompWndProc(var aMessage: TMessage);
var
  TempHandled : boolean;
begin
  try
    TempHandled := False;

    if assigned(FOnBrowserCompMsg) then
      FOnBrowserCompMsg(aMessage, TempHandled);

    if not(TempHandled)               and
       (FOldBrowserCompWndPrc <> nil) and
       (FBrowserCompHWND      <> 0)   then
      aMessage.Result := CallWindowProc(FOldBrowserCompWndPrc,
                                        FBrowserCompHWND,
                                        aMessage.Msg,
                                        aMessage.wParam,
                                        aMessage.lParam);
  except
    on e : exception do
      if CustomExceptionHandler('TFMXChromium.BrowserCompWndProc', e) then raise;
  end;
end;

procedure TOldFMXChromium.WidgetCompWndProc(var aMessage: TMessage);
var
  TempHandled : boolean;
begin
  try
    TempHandled := False;

    if assigned(FOnWidgetCompMsg) then
      FOnWidgetCompMsg(aMessage, TempHandled);

    if not(TempHandled)              and
       (FOldWidgetCompWndPrc <> nil) and
       (FWidgetCompHWND      <> 0)   then
      aMessage.Result := CallWindowProc(FOldWidgetCompWndPrc,
                                        FWidgetCompHWND,
                                        aMessage.Msg,
                                        aMessage.wParam,
                                        aMessage.lParam);
  except
    on e : exception do
      if CustomExceptionHandler('TFMXChromium.WidgetCompWndProc', e) then raise;
  end;
end;

procedure TOldFMXChromium.RenderCompWndProc(var aMessage: TMessage);
var
  TempHandled : boolean;
begin
  try
    TempHandled := False;

    if assigned(FOnRenderCompMsg) then
      FOnRenderCompMsg(aMessage, TempHandled);

    if not(TempHandled)              and
       (FOldRenderCompWndPrc <> nil) and
       (FRenderCompHWND      <> 0)   then
      aMessage.Result := CallWindowProc(FOldRenderCompWndPrc,
                                        FRenderCompHWND,
                                        aMessage.Msg,
                                        aMessage.wParam,
                                        aMessage.lParam);
  except
    on e : exception do
      if CustomExceptionHandler('TFMXChromium.RenderCompWndProc', e) then raise;
  end;
end;
{$ENDIF}

procedure TOldFMXChromium.MoveFormTo(const x, y: Integer);
var
  TempForm : TCustomForm;
  {$IFDEF DELPHI17_UP}
  TempRect : TRect;
  {$ENDIF}
begin
  TempForm := GetParentForm;
  {$IFDEF DELPHI17_UP}
  if (TempForm <> nil) then
    begin
      TempRect.Left   := min(max(x, max(screen.DesktopLeft, 0)), screen.DesktopWidth  - TempForm.Width);
      TempRect.Top    := min(max(y, max(screen.DesktopTop,  0)), screen.DesktopHeight - TempForm.Height);
      TempRect.Right  := TempRect.Left + TempForm.Width  - 1;
      TempRect.Bottom := TempRect.Top  + TempForm.Height - 1;

      TempForm.SetBounds(TempRect.Left, TempRect.Top, TempRect.Right - TempRect.Left + 1, TempRect.Bottom - TempRect.Top + 1);
    end;
  {$ELSE}
  TempForm.SetBounds(x, y, TempForm.Width, TempForm.Height);
  {$ENDIF}
end;

procedure TOldFMXChromium.MoveFormBy(const x, y: Integer);
var
  TempForm : TCustomForm;
  {$IFDEF DELPHI17_UP}
  TempRect : TRect;
  {$ENDIF}
begin
  TempForm := GetParentForm;
  {$IFDEF DELPHI17_UP}
  if (TempForm <> nil) then
    begin
      TempRect.Left   := min(max(TempForm.Left + x, max(screen.DesktopLeft, 0)), screen.DesktopWidth  - TempForm.Width);
      TempRect.Top    := min(max(TempForm.Top  + y, max(screen.DesktopTop,  0)), screen.DesktopHeight - TempForm.Height);
      TempRect.Right  := TempRect.Left + TempForm.Width  - 1;
      TempRect.Bottom := TempRect.Top  + TempForm.Height - 1;

      TempForm.SetBounds(TempRect.Left, TempRect.Top, TempRect.Right - TempRect.Left + 1, TempRect.Bottom - TempRect.Top + 1);
    end;
  {$ELSE}
  TempForm.SetBounds(TempForm.Left + x, TempForm.Top + y, TempForm.Width, TempForm.Height);
  {$ENDIF}
end;

procedure TOldFMXChromium.ResizeFormWidthTo(const x : Integer);
var
  TempForm : TCustomForm;
  TempX, TempDeltaX : integer;
begin
  TempForm := GetParentForm;

  if (TempForm <> nil) then
    begin
      TempX          := max(x, 100);
      TempDeltaX     := TempForm.Width  - TempForm.ClientWidth;
      TempForm.Width := TempX + TempDeltaX;
    end;
end;

procedure TOldFMXChromium.ResizeFormHeightTo(const y : Integer);
var
  TempForm : TCustomForm;
  TempY, TempDeltaY : integer;
begin
  TempForm := GetParentForm;

  if (TempForm <> nil) then
    begin
      TempY           := max(y, 100);
      TempDeltaY      := TempForm.Height - TempForm.ClientHeight;
      TempForm.Height := TempY + TempDeltaY;
    end;
end;

procedure TOldFMXChromium.SetFormLeftTo(const x : Integer);
var
  TempForm : TCustomForm;
begin
  TempForm := GetParentForm;

  if (TempForm <> nil) then
    {$IFDEF DELPHI17_UP}
    TempForm.Left := min(max(x, max(screen.DesktopLeft, 0)), screen.DesktopWidth  - TempForm.Width);
    {$ELSE}
    TempForm.Left := x;
    {$ENDIF}
end;

procedure TOldFMXChromium.SetFormTopTo(const y : Integer);
var
  TempForm : TCustomForm;
begin
  TempForm := GetParentForm;

  if (TempForm <> nil) then
    {$IFDEF DELPHI17_UP}
    TempForm.Top := min(max(y, max(screen.DesktopTop, 0)), screen.DesktopHeight - TempForm.Height);
    {$ELSE}
    TempForm.Top := y;
    {$ENDIF}
end;

procedure TOldFMXChromium.WasResized;
begin
  if Initialized then FBrowser.Host.WasResized;
end;

procedure TOldFMXChromium.WasHidden(hidden: Boolean);
begin
  if Initialized then FBrowser.Host.WasHidden(hidden);
end;

procedure TOldFMXChromium.NotifyScreenInfoChanged;
begin
  if Initialized then FBrowser.Host.NotifyScreenInfoChanged;
end;

procedure TOldFMXChromium.NotifyMoveOrResizeStarted;
begin
  if Initialized then FBrowser.Host.NotifyMoveOrResizeStarted;
end;

procedure TOldFMXChromium.Invalidate(kind: TOldCefPaintElementType);
begin
  if Initialized then
    begin
      if FIsOSR then
        FBrowser.Host.Invalidate(kind)
       else
        if (RenderHandle <> 0) then
          InvalidateRect(RenderHandle, nil, False)
         else
          InvalidateRect(WindowHandle, nil, False);
    end;
end;

procedure TOldFMXChromium.SendKeyEvent(const event: POldCefKeyEvent);
begin
  if Initialized then FBrowser.Host.SendKeyEvent(event);
end;

procedure TOldFMXChromium.SendMouseClickEvent(const event      : POldCefMouseEvent;
                                                 kind       : TOldCefMouseButtonType;
                                                 mouseUp    : Boolean;
                                                 clickCount : Integer);
begin
  if Initialized then FBrowser.Host.SendMouseClickEvent(event, kind, mouseUp, clickCount);
end;

procedure TOldFMXChromium.SendMouseMoveEvent(const event: POldCefMouseEvent; mouseLeave: Boolean);
begin
  if Initialized then FBrowser.Host.SendMouseMoveEvent(event, mouseLeave);
end;

procedure TOldFMXChromium.SendMouseWheelEvent(const event: POldCefMouseEvent; deltaX, deltaY: Integer);
begin
  if Initialized then FBrowser.Host.SendMouseWheelEvent(event, deltaX, deltaY);
end;

procedure TOldFMXChromium.SendFocusEvent(setFocus: Boolean);
begin
  if Initialized then FBrowser.Host.SendFocusEvent(setFocus);
end;

procedure TOldFMXChromium.SendCaptureLostEvent;
begin
  if Initialized then FBrowser.Host.SendCaptureLostEvent;
end;

procedure TOldFMXChromium.SetFocus(focus: Boolean);
begin
  if Initialized then FBrowser.Host.SetFocus(focus);
end;

function TOldFMXChromium.SendProcessMessage(targetProcess: TOldCefProcessId; const ProcMessage: IOldCefProcessMessage): Boolean;
begin
  Result := Initialized and FBrowser.SendProcessMessage(targetProcess, ProcMessage);
end;

procedure TOldFMXChromium.DragTargetDragEnter(const dragData: IOldCefDragData; const event: POldCefMouseEvent; allowedOps: TOldCefDragOperations);
begin
  if Initialized then FBrowser.Host.DragTargetDragEnter(dragData, event, allowedOps);
end;

procedure TOldFMXChromium.DragTargetDragOver(const event: POldCefMouseEvent; allowedOps: TOldCefDragOperations);
begin
  if Initialized then FBrowser.Host.DragTargetDragOver(event, allowedOps);
end;

procedure TOldFMXChromium.DragTargetDragLeave;
begin
  if Initialized then FBrowser.Host.DragTargetDragLeave;
end;

procedure TOldFMXChromium.DragTargetDrop(event: POldCefMouseEvent);
begin
  if Initialized then FBrowser.Host.DragTargetDrop(event);
end;

procedure TOldFMXChromium.DragSourceEndedAt(x, y: Integer; op: TOldCefDragOperation);
begin
  if Initialized then FBrowser.Host.DragSourceEndedAt(x, y, op);
end;

procedure TOldFMXChromium.DragSourceSystemDragEnded;
begin
  if Initialized then FBrowser.Host.DragSourceSystemDragEnded;
end;

end.
