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

unit oldCEFRequestHandler;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefRequestHandlerOwn = class(TOldCefBaseOwn, IOldCefRequestHandler)
    protected
      function  OnBeforeBrowse(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; isRedirect: Boolean): Boolean; virtual;
      function  OnOpenUrlFromTab(const browser: IOldCefBrowser; const frame: IOldCefFrame; const targetUrl: oldustring; targetDisposition: TOldCefWindowOpenDisposition; userGesture: Boolean): Boolean; virtual;
      function  OnBeforeResourceLoad(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; const callback: IOldCefRequestCallback): TOldCefReturnValue; virtual;
      function  GetResourceHandler(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest): IOldCefResourceHandler; virtual;
      procedure OnResourceRedirect(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; var newUrl: oldustring); virtual;
      function  OnResourceResponse(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; const response: IOldCefResponse): Boolean; virtual;
      function  GetResourceResponseFilter(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; const response: IOldCefResponse): IOldCefResponseFilter; virtual;
      procedure OnResourceLoadComplete(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; const response: IOldCefResponse; status: TOldCefUrlRequestStatus; receivedContentLength: Int64); virtual;
      function  GetAuthCredentials(const browser: IOldCefBrowser; const frame: IOldCefFrame; isProxy: Boolean; const host: oldustring; port: Integer; const realm, scheme: oldustring; const callback: IOldCefAuthCallback): Boolean; virtual;
      function  OnQuotaRequest(const browser: IOldCefBrowser; const originUrl: oldustring; newSize: Int64; const callback: IOldCefRequestCallback): Boolean; virtual;
      function  GetCookieManager(const browser: IOldCefBrowser; const mainUrl: oldustring): IOldCefCookieManager; virtual;
      procedure OnProtocolExecution(const browser: IOldCefBrowser; const url: oldustring; out allowOsExecution: Boolean); virtual;
      function  OnCertificateError(const browser: IOldCefBrowser; certError: TOldCefErrorcode; const requestUrl: oldustring; const sslInfo: IOldCefSslInfo; const callback: IOldCefRequestCallback): Boolean; virtual;
      procedure OnPluginCrashed(const browser: IOldCefBrowser; const pluginPath: oldustring); virtual;
      procedure OnRenderViewReady(const browser: IOldCefBrowser); virtual;
      procedure OnRenderProcessTerminated(const browser: IOldCefBrowser; status: TOldCefTerminationStatus); virtual;

      procedure RemoveReferences; virtual;

    public
      constructor Create; virtual;
  end;

  TOldCustomRequestHandler = class(TOldCefRequestHandlerOwn)
    protected
      FEvents : Pointer;

      function  OnBeforeBrowse(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; isRedirect: Boolean): Boolean; override;
      function  OnOpenUrlFromTab(const browser: IOldCefBrowser; const frame: IOldCefFrame; const targetUrl: oldustring; targetDisposition: TOldCefWindowOpenDisposition; userGesture: Boolean): Boolean; override;
      function  OnBeforeResourceLoad(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; const callback: IOldCefRequestCallback): TOldCefReturnValue; override;
      function  GetResourceHandler(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest): IOldCefResourceHandler; override;
      procedure OnResourceRedirect(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; var newUrl: oldustring); override;
      function  OnResourceResponse(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; const response: IOldCefResponse): Boolean; override;
      function  GetResourceResponseFilter(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; const response: IOldCefResponse): IOldCefResponseFilter; override;
      procedure OnResourceLoadComplete(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; const response: IOldCefResponse; status: TOldCefUrlRequestStatus; receivedContentLength: Int64); override;
      function  GetAuthCredentials(const browser: IOldCefBrowser; const frame: IOldCefFrame; isProxy: Boolean; const host: oldustring; port: Integer; const realm, scheme: oldustring; const callback: IOldCefAuthCallback): Boolean; override;
      function  OnQuotaRequest(const browser: IOldCefBrowser; const originUrl: oldustring; newSize: Int64; const callback: IOldCefRequestCallback): Boolean; override;
      procedure OnProtocolExecution(const browser: IOldCefBrowser; const url: oldustring; out allowOsExecution: Boolean); override;
      function  OnCertificateError(const browser: IOldCefBrowser; certError: TOldCefErrorcode; const requestUrl: oldustring; const sslInfo: IOldCefSslInfo; const callback: IOldCefRequestCallback): Boolean; override;
      procedure OnPluginCrashed(const browser: IOldCefBrowser; const pluginPath: oldustring); override;
      procedure OnRenderViewReady(const browser: IOldCefBrowser); override;
      procedure OnRenderProcessTerminated(const browser: IOldCefBrowser; status: TOldCefTerminationStatus); override;

      procedure RemoveReferences; override;

    public
      constructor Create(const events: Pointer); reintroduce; virtual;
      destructor  Destroy; override;
  end;

implementation

uses
  {$IFDEF DELPHI16_UP}
  {$IFDEF MSWINDOWS}WinApi.Windows,{$ENDIF} System.SysUtils,
  {$ELSE}
  Windows, SysUtils,
  {$ENDIF}
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFBrowser, oldCEFFrame, oldCEFRequest, oldCEFRequestCallback,
  oldCEFResponse, oldCEFAuthCallback, oldCEFSslInfo, oldCEFApplication;

function cef_request_handler_on_before_browse(self       : POldCefRequestHandler;
                                              browser    : POldCefBrowser;
                                              frame      : POldCefFrame;
                                              request    : POldCefRequest;
                                              isRedirect : Integer): Integer; stdcall;
var
  TempObject : TObject;
begin
  Result     := Ord(False);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRequestHandlerOwn) then
    Result := Ord(TOldCefRequestHandlerOwn(TempObject).OnBeforeBrowse(TOldCefBrowserRef.UnWrap(browser),
                                                                   TOldCefFrameRef.UnWrap(frame),
                                                                   TOldCefRequestRef.UnWrap(request),
                                                                   isRedirect <> 0));
end;

function cef_request_handler_on_open_urlfrom_tab(      self               : POldCefRequestHandler;
                                                       browser            : POldCefBrowser;
                                                       frame              : POldCefFrame;
                                                 const target_url         : POldCefString;
                                                       target_disposition : TOldCefWindowOpenDisposition;
                                                       user_gesture       : Integer): Integer; stdcall;
var
  TempObject : TObject;
begin
  Result     := Ord(False);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRequestHandlerOwn) then
    Result := Ord(TOldCefRequestHandlerOwn(TempObject).OnOpenUrlFromTab(TOldCefBrowserRef.UnWrap(browser),
                                                                     TOldCefFrameRef.UnWrap(frame),
                                                                     CefString(target_url),
                                                                     target_disposition,
                                                                     user_gesture <> 0));
end;

function cef_request_handler_on_before_resource_load(self     : POldCefRequestHandler;
                                                     browser  : POldCefBrowser;
                                                     frame    : POldCefFrame;
                                                     request  : POldCefRequest;
                                                     callback : POldCefRequestCallback): TOldCefReturnValue; stdcall;
var
  TempObject : TObject;
begin
  Result     := RV_CONTINUE;
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRequestHandlerOwn) then
    Result := TOldCefRequestHandlerOwn(TempObject).OnBeforeResourceLoad(TOldCefBrowserRef.UnWrap(browser),
                                                                     TOldCefFrameRef.UnWrap(frame),
                                                                     TOldCefRequestRef.UnWrap(request),
                                                                     TOldCefRequestCallbackRef.UnWrap(callback));
end;

function cef_request_handler_get_resource_handler(self    : POldCefRequestHandler;
                                                  browser : POldCefBrowser;
                                                  frame   : POldCefFrame;
                                                  request : POldCefRequest): POldCefResourceHandler; stdcall;
var
  TempObject : TObject;
begin
  Result     := nil;
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRequestHandlerOwn) then
    Result := CefGetData(TOldCefRequestHandlerOwn(TempObject).GetResourceHandler(TOldCefBrowserRef.UnWrap(browser),
                                                                              TOldCefFrameRef.UnWrap(frame),
                                                                              TOldCefRequestRef.UnWrap(request)));
end;

procedure cef_request_handler_on_resource_redirect(self     : POldCefRequestHandler;
                                                   browser  : POldCefBrowser;
                                                   frame    : POldCefFrame;
                                                   request  : POldCefRequest;
                                                   new_url  : POldCefString); stdcall;
var
  TempURL    : oldustring;
  TempObject : TObject;
begin
  TempURL    := CefString(new_url);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRequestHandlerOwn) then
    TOldCefRequestHandlerOwn(TempObject).OnResourceRedirect(TOldCefBrowserRef.UnWrap(browser),
                                                         TOldCefFrameRef.UnWrap(frame),
                                                         TOldCefRequestRef.UnWrap(request),
                                                         TempURL);

  if (TempURL <> '') then CefStringSet(new_url, TempURL);
end;

function cef_request_handler_on_resource_response(self     : POldCefRequestHandler;
                                                  browser  : POldCefBrowser;
                                                  frame    : POldCefFrame;
                                                  request  : POldCefRequest;
                                                  response : POldCefResponse): Integer; stdcall;
var
  TempObject : TObject;
begin
  Result     := Ord(False);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRequestHandlerOwn) then
    Result := Ord(TOldCefRequestHandlerOwn(TempObject).OnResourceResponse(TOldCefBrowserRef.UnWrap(browser),
                                                                       TOldCefFrameRef.UnWrap(frame),
                                                                       TOldCefRequestRef.UnWrap(request),
                                                                       TOldCefResponseRef.UnWrap(response)));
end;

function cef_request_handler_get_resource_response_filter(self     : POldCefRequestHandler;
                                                          browser  : POldCefBrowser;
                                                          frame    : POldCefFrame;
                                                          request  : POldCefRequest;
                                                          response : POldCefResponse): POldCefResponseFilter; stdcall;
var
  TempObject : TObject;
begin
  Result     := nil;
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRequestHandlerOwn) then
    Result := CefGetData(TOldCefRequestHandlerOwn(TempObject).GetResourceResponseFilter(TOldCefBrowserRef.UnWrap(browser),
                                                                                     TOldCefFrameRef.UnWrap(frame),
                                                                                     TOldCefRequestRef.UnWrap(request),
                                                                                     TOldCefResponseRef.UnWrap(response)));
end;

procedure cef_request_handler_on_resource_load_complete(self                    : POldCefRequestHandler;
                                                        browser                 : POldCefBrowser;
                                                        frame                   : POldCefFrame;
                                                        request                 : POldCefRequest;
                                                        response                : POldCefResponse;
                                                        status                  : TOldCefUrlRequestStatus;
                                                        received_content_length : Int64); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRequestHandlerOwn) then
    TOldCefRequestHandlerOwn(TempObject).OnResourceLoadComplete(TOldCefBrowserRef.UnWrap(browser),
                                                             TOldCefFrameRef.UnWrap(frame),
                                                             TOldCefRequestRef.UnWrap(request),
                                                             TOldCefResponseRef.UnWrap(response),
                                                             status,
                                                             received_content_length);
end;

function cef_request_handler_get_auth_credentials(      self     : POldCefRequestHandler;
                                                        browser  : POldCefBrowser;
                                                        frame    : POldCefFrame;
                                                        isProxy  : Integer;
                                                  const host     : POldCefString;
                                                        port     : Integer;
                                                  const realm    : POldCefString;
                                                  const scheme   : POldCefString;
                                                        callback : POldCefAuthCallback): Integer; stdcall;
var
  TempObject : TObject;
begin
  Result     := Ord(False);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRequestHandlerOwn) then
    Result := Ord(TOldCefRequestHandlerOwn(TempObject).GetAuthCredentials(TOldCefBrowserRef.UnWrap(browser),
                                                                       TOldCefFrameRef.UnWrap(frame),
                                                                       isProxy <> 0,
                                                                       CefString(host),
                                                                       port,
                                                                       CefString(realm),
                                                                       CefString(scheme),
                                                                       TOldCefAuthCallbackRef.UnWrap(callback)));
end;

function cef_request_handler_on_quota_request(      self       : POldCefRequestHandler;
                                                    browser    : POldCefBrowser;
                                              const origin_url : POldCefString;
                                                    new_size   : Int64;
                                                    callback   : POldCefRequestCallback): Integer; stdcall;
var
  TempObject : TObject;
begin
  Result     := Ord(False);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRequestHandlerOwn) then
    Result := Ord(TOldCefRequestHandlerOwn(TempObject).OnQuotaRequest(TOldCefBrowserRef.UnWrap(browser),
                                                                   CefString(origin_url),
                                                                   new_size,
                                                                   TOldCefRequestCallbackRef.UnWrap(callback)));
end;

procedure cef_request_handler_on_protocol_execution(      self               : POldCefRequestHandler;
                                                          browser            : POldCefBrowser;
                                                    const url                : POldCefString;
                                                          allow_os_execution : PInteger); stdcall;
var
  allow : Boolean;
  TempObject : TObject;
begin
  allow      := allow_os_execution^ <> 0;
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRequestHandlerOwn) then
    TOldCefRequestHandlerOwn(TempObject).OnProtocolExecution(TOldCefBrowserRef.UnWrap(browser),
                                                          CefString(url),
                                                          allow);

  allow_os_execution^ := Ord(allow);
end;

function cef_request_handler_on_certificate_error(      self        : POldCefRequestHandler;
                                                        browser     : POldCefBrowser;
                                                        cert_error  : TOldCefErrorcode;
                                                  const request_url : POldCefString;
                                                        ssl_info    : POldCefSslInfo;
                                                        callback    : POldCefRequestCallback): Integer; stdcall;
var
  TempObject : TObject;
begin
  Result     := Ord(False);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRequestHandlerOwn) then
    Result := Ord(TOldCefRequestHandlerOwn(TempObject).OnCertificateError(TOldCefBrowserRef.UnWrap(browser),
                                                                       cert_error,
                                                                       CefString(request_url),
                                                                       TOldCefSslInfoRef.UnWrap(ssl_info),
                                                                       TOldCefRequestCallbackRef.UnWrap(callback)));
end;

procedure cef_request_handler_on_plugin_crashed(      self        : POldCefRequestHandler;
                                                      browser     : POldCefBrowser;
                                                const plugin_path : POldCefString); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRequestHandlerOwn) then
    TOldCefRequestHandlerOwn(TempObject).OnPluginCrashed(TOldCefBrowserRef.UnWrap(browser),
                                                      CefString(plugin_path));
end;

procedure cef_request_handler_on_render_view_ready(self    : POldCefRequestHandler;
                                                   browser : POldCefBrowser); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRequestHandlerOwn) then
    TOldCefRequestHandlerOwn(TempObject).OnRenderViewReady(TOldCefBrowserRef.UnWrap(browser));
end;

procedure cef_request_handler_on_render_process_terminated(self    : POldCefRequestHandler;
                                                           browser : POldCefBrowser;
                                                           status  : TOldCefTerminationStatus); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRequestHandlerOwn) then
    TOldCefRequestHandlerOwn(TempObject).OnRenderProcessTerminated(TOldCefBrowserRef.UnWrap(browser),
                                                                status);
end;

constructor TOldCefRequestHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefRequestHandler));

  with POldCefRequestHandler(FData)^ do
    begin
      on_before_browse              := cef_request_handler_on_before_browse;
      on_open_urlfrom_tab           := cef_request_handler_on_open_urlfrom_tab;
      on_before_resource_load       := cef_request_handler_on_before_resource_load;
      get_resource_handler          := cef_request_handler_get_resource_handler;
      on_resource_redirect          := cef_request_handler_on_resource_redirect;
      on_resource_response          := cef_request_handler_on_resource_response;
      get_resource_response_filter  := cef_request_handler_get_resource_response_filter;
      on_resource_load_complete     := cef_request_handler_on_resource_load_complete;
      get_auth_credentials          := cef_request_handler_get_auth_credentials;
      on_quota_request              := cef_request_handler_on_quota_request;
      on_protocol_execution         := cef_request_handler_on_protocol_execution;
      on_certificate_error          := cef_request_handler_on_certificate_error;
      on_plugin_crashed             := cef_request_handler_on_plugin_crashed;
      on_render_view_ready          := cef_request_handler_on_render_view_ready;
      on_render_process_terminated  := cef_request_handler_on_render_process_terminated;
    end;
end;

function TOldCefRequestHandlerOwn.GetAuthCredentials(const browser: IOldCefBrowser; const frame: IOldCefFrame;
  isProxy: Boolean; const host: oldustring; port: Integer; const realm, scheme: oldustring;
  const callback: IOldCefAuthCallback): Boolean;
begin
  Result := False;
end;

function TOldCefRequestHandlerOwn.GetCookieManager(const browser: IOldCefBrowser;
  const mainUrl: oldustring): IOldCefCookieManager;
begin
  Result := nil;
end;

function TOldCefRequestHandlerOwn.OnBeforeBrowse(const browser: IOldCefBrowser;
  const frame: IOldCefFrame; const request: IOldCefRequest;
  isRedirect: Boolean): Boolean;
begin
  Result := False;
end;

function TOldCefRequestHandlerOwn.OnBeforeResourceLoad(const browser: IOldCefBrowser;
  const frame: IOldCefFrame; const request: IOldCefRequest;
  const callback: IOldCefRequestCallback): TOldCefReturnValue;
begin
  Result := RV_CONTINUE;
end;

function TOldCefRequestHandlerOwn.OnCertificateError(const browser: IOldCefBrowser;
  certError: TOldCefErrorcode; const requestUrl: oldustring; const sslInfo: IOldCefSslInfo;
  const callback: IOldCefRequestCallback): Boolean;
begin
  Result := False;
end;

function TOldCefRequestHandlerOwn.OnOpenUrlFromTab(const browser: IOldCefBrowser;
  const frame: IOldCefFrame; const targetUrl: oldustring;
  targetDisposition: TOldCefWindowOpenDisposition; userGesture: Boolean): Boolean;
begin
  Result := False;
end;

function TOldCefRequestHandlerOwn.GetResourceHandler(const browser: IOldCefBrowser;
  const frame: IOldCefFrame; const request: IOldCefRequest): IOldCefResourceHandler;
begin
  Result := nil;
end;

procedure TOldCefRequestHandlerOwn.OnPluginCrashed(const browser: IOldCefBrowser;
  const pluginPath: oldustring);
begin

end;

procedure TOldCefRequestHandlerOwn.OnProtocolExecution(const browser: IOldCefBrowser;
  const url: oldustring; out allowOsExecution: Boolean);
begin

end;

function TOldCefRequestHandlerOwn.OnQuotaRequest(const browser: IOldCefBrowser;
  const originUrl: oldustring; newSize: Int64;
  const callback: IOldCefRequestCallback): Boolean;
begin
  Result := False;
end;

procedure TOldCefRequestHandlerOwn.OnRenderProcessTerminated(
  const browser: IOldCefBrowser; status: TOldCefTerminationStatus);
begin

end;

procedure TOldCefRequestHandlerOwn.OnRenderViewReady(const browser: IOldCefBrowser);
begin

end;

procedure TOldCefRequestHandlerOwn.OnResourceRedirect(const browser: IOldCefBrowser;
  const frame: IOldCefFrame; const request: IOldCefRequest; var newUrl: oldustring);
begin

end;

function TOldCefRequestHandlerOwn.OnResourceResponse(const browser: IOldCefBrowser;
  const frame: IOldCefFrame; const request: IOldCefRequest;
  const response: IOldCefResponse): Boolean;
begin
  Result := False;
end;

function TOldCefRequestHandlerOwn.GetResourceResponseFilter(
  const browser: IOldCefBrowser; const frame: IOldCefFrame;
  const request: IOldCefRequest; const response: IOldCefResponse): IOldCefResponseFilter;
begin
  Result := nil;
end;

procedure TOldCefRequestHandlerOwn.OnResourceLoadComplete(
  const browser: IOldCefBrowser; const frame: IOldCefFrame;
  const request: IOldCefRequest; const response: IOldCefResponse;
  status: TOldCefUrlRequestStatus; receivedContentLength: Int64);
begin

end;

procedure TOldCefRequestHandlerOwn.RemoveReferences;
begin
  //
end;

// TCustomRequestHandler

constructor TOldCustomRequestHandler.Create(const events: Pointer);
begin
  inherited Create;

  FEvents := events;
end;

destructor TOldCustomRequestHandler.Destroy;
begin
  RemoveReferences;

  inherited Destroy;
end;

procedure TOldCustomRequestHandler.RemoveReferences;
begin
  FEvents := nil;
end;

function TOldCustomRequestHandler.GetAuthCredentials(const browser  : IOldCefBrowser;
                                                  const frame    : IOldCefFrame;
                                                        isProxy  : Boolean;
                                                  const host     : oldustring;
                                                        port     : Integer;
                                                  const realm    : oldustring;
                                                  const scheme   : oldustring;
                                                  const callback : IOldCefAuthCallback): Boolean;
begin
  if (FEvents <> nil) then
    Result := IOldChromiumEvents(FEvents).doOnGetAuthCredentials(browser, frame, isProxy, host, port, realm, scheme, callback)
   else
    Result := inherited GetAuthCredentials(browser, frame, isProxy, host, port, realm, scheme, callback);
end;

function TOldCustomRequestHandler.GetResourceHandler(const browser : IOldCefBrowser;
                                                  const frame   : IOldCefFrame;
                                                  const request : IOldCefRequest): IOldCefResourceHandler;
begin
  if (FEvents <> nil) then
    Result := IOldChromiumEvents(FEvents).doOnGetResourceHandler(browser, frame, request)
   else
    Result := inherited GetResourceHandler(browser, frame, request);
end;

function TOldCustomRequestHandler.OnBeforeBrowse(const browser    : IOldCefBrowser;
                                              const frame      : IOldCefFrame;
                                              const request    : IOldCefRequest;
                                                    isRedirect : Boolean): Boolean;
begin
  if (FEvents <> nil) then
    Result := IOldChromiumEvents(FEvents).doOnBeforeBrowse(browser, frame, request, isRedirect)
   else
    Result := inherited OnBeforeBrowse(browser, frame, request, isRedirect);
end;

function TOldCustomRequestHandler.OnBeforeResourceLoad(const browser  : IOldCefBrowser;
                                                    const frame    : IOldCefFrame;
                                                    const request  : IOldCefRequest;
                                                    const callback : IOldCefRequestCallback): TOldCefReturnValue;
begin
  if (FEvents <> nil) then
    Result := IOldChromiumEvents(FEvents).doOnBeforeResourceLoad(browser, frame, request, callback)
   else
    Result := inherited OnBeforeResourceLoad(browser, frame, request, callback);
end;

function TOldCustomRequestHandler.OnCertificateError(const browser    : IOldCefBrowser;
                                                        certError  : TOldCefErrorcode;
                                                  const requestUrl : oldustring;
                                                  const sslInfo    : IOldCefSslInfo;
                                                  const callback   : IOldCefRequestCallback): Boolean;
begin
  if (FEvents <> nil) then
    Result := IOldChromiumEvents(FEvents).doOnCertificateError(browser, certError, requestUrl, sslInfo, callback)
   else
    Result := inherited OnCertificateError(browser, certError, requestUrl, sslInfo, callback);
end;

function TOldCustomRequestHandler.OnOpenUrlFromTab(const browser           : IOldCefBrowser;
                                                const frame             : IOldCefFrame;
                                                const targetUrl         : oldustring;
                                                      targetDisposition : TOldCefWindowOpenDisposition;
                                                      userGesture       : Boolean): Boolean;
begin
  if (FEvents <> nil) then
    Result := IOldChromiumEvents(FEvents).doOnOpenUrlFromTab(browser, frame, targetUrl, targetDisposition, userGesture)
   else
    Result := inherited OnOpenUrlFromTab(browser, frame, targetUrl, targetDisposition, userGesture);
end;

procedure TOldCustomRequestHandler.OnPluginCrashed(const browser: IOldCefBrowser; const pluginPath: oldustring);
begin
  if (FEvents <> nil) then IOldChromiumEvents(FEvents).doOnPluginCrashed(browser, pluginPath);
end;

procedure TOldCustomRequestHandler.OnProtocolExecution(const browser          : IOldCefBrowser;
                                                    const url              : oldustring;
                                                      out allowOsExecution : Boolean);
begin
  if (FEvents <> nil) then IOldChromiumEvents(FEvents).doOnProtocolExecution(browser, url, allowOsExecution);
end;

function TOldCustomRequestHandler.OnQuotaRequest(const browser   : IOldCefBrowser;
                                              const originUrl : oldustring;
                                                    newSize   : Int64;
                                              const callback  : IOldCefRequestCallback): Boolean;
begin
  if (FEvents <> nil) then
    Result := IOldChromiumEvents(FEvents).doOnQuotaRequest(browser, originUrl, newSize, callback)
   else
    Result := inherited OnQuotaRequest(browser, originUrl, newSize, callback);
end;

procedure TOldCustomRequestHandler.OnRenderProcessTerminated(const browser: IOldCefBrowser; status: TOldCefTerminationStatus);
begin
  if (FEvents <> nil) then IOldChromiumEvents(FEvents).doOnRenderProcessTerminated(browser, status);
end;

procedure TOldCustomRequestHandler.OnRenderViewReady(const browser: IOldCefBrowser);
begin
  if (FEvents <> nil) then IOldChromiumEvents(FEvents).doOnRenderViewReady(browser);
end;

procedure TOldCustomRequestHandler.OnResourceRedirect(const browser  : IOldCefBrowser;
                                                   const frame    : IOldCefFrame;
                                                   const request  : IOldCefRequest;
                                                   var   newUrl   : oldustring);
begin
  if (FEvents <> nil) then IOldChromiumEvents(FEvents).doOnResourceRedirect(browser, frame, request, newUrl);
end;

function TOldCustomRequestHandler.OnResourceResponse(const browser  : IOldCefBrowser;
                                                  const frame    : IOldCefFrame;
                                                  const request  : IOldCefRequest;
                                                  const response : IOldCefResponse): Boolean;
begin
  if (FEvents <> nil) then
    Result := IOldChromiumEvents(FEvents).doOnResourceResponse(browser, frame, request, response)
   else
    Result := inherited OnResourceResponse(browser, frame, request, response);
end;

function TOldCustomRequestHandler.GetResourceResponseFilter(const browser: IOldCefBrowser;
                                                         const frame: IOldCefFrame;
                                                         const request: IOldCefRequest;
                                                         const response: IOldCefResponse): IOldCefResponseFilter;
begin
  if (FEvents <> nil) then
    Result := IOldChromiumEvents(FEvents).doOnGetResourceResponseFilter(browser, frame, request, response)
   else
    Result := inherited GetResourceResponseFilter(browser, frame, request, response);
end;

procedure TOldCustomRequestHandler.OnResourceLoadComplete(const browser               : IOldCefBrowser;
                                                       const frame                 : IOldCefFrame;
                                                       const request               : IOldCefRequest;
                                                       const response              : IOldCefResponse;
                                                             status                : TOldCefUrlRequestStatus;
                                                             receivedContentLength : Int64);
begin
  if (FEvents <> nil) then IOldChromiumEvents(FEvents).doOnResourceLoadComplete(browser, frame, request, response, status, receivedContentLength);
end;

end.
