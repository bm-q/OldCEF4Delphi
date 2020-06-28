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

unit oldCEFChromiumEvents;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
  System.Classes, {$IFDEF MSWINDOWS}WinApi.Messages,{$ENDIF}
  {$ELSE}
  Classes, {$IFDEF MSWINDOWS}Messages,{$ENDIF}
  {$ENDIF}
  oldCEFTypes, oldCEFInterfaces;

type
  // ICefClient
  TOnProcessMessageReceived       = procedure(Sender: TObject; const browser: IOldCefBrowser; sourceProcess: TOldCefProcessId; const message: IOldCefProcessMessage; out Result: Boolean) of object;

  // ICefLoadHandler
  TOnLoadStart                    = procedure(Sender: TObject; const browser: IOldCefBrowser; const frame: IOldCefFrame) of object;
  TOnLoadEnd                      = procedure(Sender: TObject; const browser: IOldCefBrowser; const frame: IOldCefFrame; httpStatusCode: Integer) of object;
  TOnLoadError                    = procedure(Sender: TObject; const browser: IOldCefBrowser; const frame: IOldCefFrame; errorCode: TOldCefErrorCode; const errorText, failedUrl: oldustring) of object;
  TOnLoadingStateChange           = procedure(Sender: TObject; const browser: IOldCefBrowser; isLoading, canGoBack, canGoForward: Boolean) of object;

  // ICefFocusHandler
  TOnTakeFocus                    = procedure(Sender: TObject; const browser: IOldCefBrowser; next: Boolean) of object;
  TOnSetFocus                     = procedure(Sender: TObject; const browser: IOldCefBrowser; source: TOldCefFocusSource; out Result: Boolean) of object;
  TOnGotFocus                     = procedure(Sender: TObject; const browser: IOldCefBrowser) of object;

  // ICefContextMenuHandler
  TOnBeforeContextMenu            = procedure(Sender: TObject; const browser: IOldCefBrowser; const frame: IOldCefFrame; const params: IOldCefContextMenuParams; const model: IOldCefMenuModel) of object;
  TOnRunContextMenu               = procedure(Sender: TObject; const browser: IOldCefBrowser; const frame: IOldCefFrame; const params: IOldCefContextMenuParams; const model: IOldCefMenuModel; const callback: IOldCefRunContextMenuCallback; var aResult : Boolean) of object;
  TOnContextMenuCommand           = procedure(Sender: TObject; const browser: IOldCefBrowser; const frame: IOldCefFrame; const params: IOldCefContextMenuParams; commandId: Integer; eventFlags: TOldCefEventFlags; out Result: Boolean) of object;
  TOnContextMenuDismissed         = procedure(Sender: TObject; const browser: IOldCefBrowser; const frame: IOldCefFrame) of object;

  // ICefKeyboardHandler
  TOnPreKeyEvent                  = procedure(Sender: TObject; const browser: IOldCefBrowser; const event: POldCefKeyEvent; osEvent: TOldCefEventHandle; out isKeyboardShortcut: Boolean; out Result: Boolean) of object;
  TOnKeyEvent                     = procedure(Sender: TObject; const browser: IOldCefBrowser; const event: POldCefKeyEvent; osEvent: TOldCefEventHandle; out Result: Boolean) of object;

  // ICefDisplayHandler
  TOnAddressChange                = procedure(Sender: TObject; const browser: IOldCefBrowser; const frame: IOldCefFrame; const url: oldustring) of object;
  TOnTitleChange                  = procedure(Sender: TObject; const browser: IOldCefBrowser; const title: oldustring) of object;
  TOnFavIconUrlChange             = procedure(Sender: TObject; const browser: IOldCefBrowser; const iconUrls: TStrings) of object;
  TOnFullScreenModeChange         = procedure(Sender: TObject; const browser: IOldCefBrowser; fullscreen: Boolean) of object;
  TOnTooltip                      = procedure(Sender: TObject; const browser: IOldCefBrowser; var text: oldustring; out Result: Boolean) of object;
  TOnStatusMessage                = procedure(Sender: TObject; const browser: IOldCefBrowser; const value: oldustring) of object;
  TOnConsoleMessage               = procedure(Sender: TObject; const browser: IOldCefBrowser; const message, source: oldustring; line: Integer; out Result: Boolean) of object;

  // ICefDownloadHandler
  TOnBeforeDownload               = procedure(Sender: TObject; const browser: IOldCefBrowser; const downloadItem: IOldCefDownloadItem; const suggestedName: oldustring; const callback: IOldCefBeforeDownloadCallback) of object;
  TOnDownloadUpdated              = procedure(Sender: TObject; const browser: IOldCefBrowser; const downloadItem: IOldCefDownloadItem; const callback: IOldCefDownloadItemCallback) of object;

  // ICefGeolocationHandler
  TOnRequestGeolocationPermission = procedure(Sender: TObject; const browser: IOldCefBrowser; const requestingUrl: oldustring; requestId: Integer; const callback: IOldCefGeolocationCallback; out Result: Boolean) of object;
  TOnCancelGeolocationPermission  = procedure(Sender: TObject; const browser: IOldCefBrowser; requestId: Integer) of object;

  // ICefJsDialogHandler
  TOnJsdialog                     = procedure(Sender: TObject; const browser: IOldCefBrowser; const originUrl, accept_lang: oldustring; dialogType: TOldCefJsDialogType; const messageText, defaultPromptText: oldustring; const callback: IOldCefJsDialogCallback; out suppressMessage: Boolean; out Result: Boolean) of object;
  TOnBeforeUnloadDialog           = procedure(Sender: TObject; const browser: IOldCefBrowser; const messageText: oldustring; isReload: Boolean; const callback: IOldCefJsDialogCallback; out Result: Boolean) of object;
  TOnResetDialogState             = procedure(Sender: TObject; const browser: IOldCefBrowser) of object;
  TOnDialogClosed                 = procedure(Sender: TObject; const browser: IOldCefBrowser) of object;

  // ICefLifeSpanHandler
  TOnBeforePopup                  = procedure(Sender: TObject; const browser: IOldCefBrowser; const frame: IOldCefFrame; const targetUrl, targetFrameName: oldustring; targetDisposition: TOldCefWindowOpenDisposition; userGesture: Boolean; const popupFeatures: TOldCefPopupFeatures; var windowInfo: TOldCefWindowInfo; var client: IOldCefClient; var settings: TOldCefBrowserSettings; var noJavascriptAccess: Boolean; var Result: Boolean) of object;
  TOnAfterCreated                 = procedure(Sender: TObject; const browser: IOldCefBrowser) of object;
  TOnRunModal                     = procedure(Sender: TObject; const browser: IOldCefBrowser; var Result : boolean) of object;
  TOnBeforeClose                  = procedure(Sender: TObject; const browser: IOldCefBrowser) of object;
  TOnClose                        = procedure(Sender: TObject; const browser: IOldCefBrowser; var aAction : TOldCefCloseBrowserAction) of object;

  // ICefRequestHandler
  TOnBeforeBrowse                 = procedure(Sender: TObject; const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; isRedirect: Boolean; out Result: Boolean) of object;
  TOnOpenUrlFromTab               = procedure(Sender: TObject; const browser: IOldCefBrowser; const frame: IOldCefFrame; const targetUrl: oldustring; targetDisposition: TOldCefWindowOpenDisposition; userGesture: Boolean; out Result: Boolean) of Object;
  TOnBeforeResourceLoad           = procedure(Sender: TObject; const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; const callback: IOldCefRequestCallback; out Result: TOldCefReturnValue) of object;
  TOnGetResourceHandler           = procedure(Sender: TObject; const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; out Result: IOldCefResourceHandler) of object;
  TOnResourceRedirect             = procedure(Sender: TObject; const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; var newUrl: oldustring) of object;
  TOnResourceResponse             = procedure(Sender: TObject; const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; const response: IOldCefResponse; out Result: Boolean) of Object;
  TOnGetResourceResponseFilter    = procedure(Sender: TObject; const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; const response: IOldCefResponse; out Result: IOldCefResponseFilter) of object;
  TOnResourceLoadComplete         = procedure(Sender: TObject; const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; const response: IOldCefResponse; status: TOldCefUrlRequestStatus; receivedContentLength: Int64) of object;
  TOnGetAuthCredentials           = procedure(Sender: TObject; const browser: IOldCefBrowser; const frame: IOldCefFrame; isProxy: Boolean; const host: oldustring; port: Integer; const realm, scheme: oldustring; const callback: IOldCefAuthCallback; out Result: Boolean) of object;
  TOnQuotaRequest                 = procedure(Sender: TObject; const browser: IOldCefBrowser; const originUrl: oldustring; newSize: Int64; const callback: IOldCefRequestCallback; out Result: Boolean) of object;
  TOnProtocolExecution            = procedure(Sender: TObject; const browser: IOldCefBrowser; const url: oldustring; out allowOsExecution: Boolean) of object;
  TOnCertificateError             = procedure(Sender: TObject; const browser: IOldCefBrowser; certError: TOldCefErrorcode; const requestUrl: oldustring; const sslInfo: IOldCefSslInfo; const callback: IOldCefRequestCallback; out Result: Boolean) of Object;
  TOnPluginCrashed                = procedure(Sender: TObject; const browser: IOldCefBrowser; const pluginPath: oldustring) of object;
  TOnRenderViewReady              = procedure(Sender: Tobject; const browser: IOldCefBrowser) of Object;
  TOnRenderProcessTerminated      = procedure(Sender: TObject; const browser: IOldCefBrowser; status: TOldCefTerminationStatus) of object;

  // ICefDialogHandler
  TOnFileDialog                   = procedure(Sender: TObject; const browser: IOldCefBrowser; mode: TOldCefFileDialogMode; const title, defaultFilePath: oldustring; const acceptFilters: TStrings; selectedAcceptFilter: Integer; const callback: IOldCefFileDialogCallback; out Result: Boolean) of Object;

  // ICefRenderHandler
  TOnGetRootScreenRect            = procedure(Sender: TObject; const browser: IOldCefBrowser; var rect: TOldCefRect; out Result: Boolean) of Object;
  TOnGetViewRect                  = procedure(Sender: TObject; const browser: IOldCefBrowser; var rect: TOldCefRect; out Result: Boolean) of Object;
  TOnGetScreenPoint               = procedure(Sender: TObject; const browser: IOldCefBrowser; viewX, viewY: Integer; var screenX, screenY: Integer; out Result: Boolean) of Object;
  TOnGetScreenInfo                = procedure(Sender: TObject; const browser: IOldCefBrowser; var screenInfo: TOldCefScreenInfo; out Result: Boolean) of Object;
  TOnPopupShow                    = procedure(Sender: TObject; const browser: IOldCefBrowser; show: Boolean) of Object;
  TOnPopupSize                    = procedure(Sender: TObject; const browser: IOldCefBrowser; const rect: POldCefRect) of Object;
  TOnPaint                        = procedure(Sender: TObject; const browser: IOldCefBrowser; kind: TOldCefPaintElementType; dirtyRectsCount: NativeUInt; const dirtyRects: POldCefRectArray; const buffer: Pointer; width, height: Integer) of Object;
  TOnCursorChange                 = procedure(Sender: TObject; const browser: IOldCefBrowser; cursor: TOldCefCursorHandle; cursorType: TOldCefCursorType; const customCursorInfo: POldCefCursorInfo) of Object;
  TOnStartDragging                = procedure(Sender: TObject; const browser: IOldCefBrowser; const dragData: IOldCefDragData; allowedOps: TOldCefDragOperations; x, y: Integer; out Result: Boolean) of Object;
  TOnUpdateDragCursor             = procedure(Sender: TObject; const browser: IOldCefBrowser; operation: TOldCefDragOperation) of Object;
  TOnScrollOffsetChanged          = procedure(Sender: TObject; const browser: IOldCefBrowser; x, y: Double) of Object;

  // ICefDragHandler
  TOnDragEnter                    = procedure(Sender: TObject; const browser: IOldCefBrowser; const dragData: IOldCefDragData; mask: TOldCefDragOperations; out Result: Boolean) of Object;
  TOnDraggableRegionsChanged      = procedure(Sender: TObject; const browser: IOldCefBrowser; regionsCount: NativeUInt; regions: POldCefDraggableRegionArray)of Object;

  // ICefFindHandler
  TOnFindResult                   = procedure(Sender: TObject; const browser: IOldCefBrowser; identifier, count: Integer; const selectionRect: POldCefRect; activeMatchOrdinal: Integer; finalUpdate: Boolean) of Object;

  // Custom
  TOnTextResultAvailableEvent     = procedure(Sender: TObject; const aText : string) of object;
  TOnPdfPrintFinishedEvent        = procedure(Sender: TObject; aResultOK : boolean) of object;
  TOnPrefsAvailableEvent          = procedure(Sender: TObject; aResultOK : boolean) of object;
  TOnCookiesDeletedEvent          = procedure(Sender: TObject; numDeleted : integer) of object;
  TOnResolvedIPsAvailableEvent    = procedure(Sender: TObject; result: TOldCefErrorCode; const resolvedIps: TStrings) of object;
  {$IFDEF MSWINDOWS}
  TOnCompMsgEvent                 = procedure (var aMessage: TMessage; var aHandled: Boolean) of object;
  {$ENDIF}

implementation

end.
