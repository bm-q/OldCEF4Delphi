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

unit oldCEFRenderProcessHandler;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
  System.Classes,
  {$ELSE}
  Classes,
  {$ENDIF}
  oldCEFBase, oldCEFInterfaces, oldCEFTypes, oldCEFListValue, oldCEFBrowser, oldCEFFrame, oldCEFRequest,
  oldCEFv8Context, oldCEFv8Exception, oldCEFv8StackTrace, oldCEFDomNode, oldCEFProcessMessage, oldCEFApplication;

type
  TOldCefRenderProcessHandlerOwn = class(TOldCefBaseOwn, IOldCefRenderProcessHandler)
    protected
      procedure OnRenderThreadCreated(const extraInfo: IOldCefListValue); virtual; abstract;
      procedure OnWebKitInitialized; virtual; abstract;
      procedure OnBrowserCreated(const browser: IOldCefBrowser); virtual; abstract;
      procedure OnBrowserDestroyed(const browser: IOldCefBrowser); virtual; abstract;
      function  GetLoadHandler: IOldCefLoadHandler; virtual;
      function  OnBeforeNavigation(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; navigationType: TOldCefNavigationType; isRedirect: Boolean): Boolean; virtual;
      procedure OnContextCreated(const browser: IOldCefBrowser; const frame: IOldCefFrame; const context: IOldCefv8Context); virtual; abstract;
      procedure OnContextReleased(const browser: IOldCefBrowser; const frame: IOldCefFrame; const context: IOldCefv8Context); virtual; abstract;
      procedure OnUncaughtException(const browser: IOldCefBrowser; const frame: IOldCefFrame; const context: IOldCefv8Context; const V8Exception: IOldCefV8Exception; const stackTrace: IOldCefV8StackTrace); virtual; abstract;
      procedure OnFocusedNodeChanged(const browser: IOldCefBrowser; const frame: IOldCefFrame; const node: IOldCefDomNode); virtual; abstract;
      function  OnProcessMessageReceived(const browser: IOldCefBrowser; sourceProcess: TOldCefProcessId; const aMessage: IOldCefProcessMessage): Boolean; virtual;

    public
      constructor Create; virtual;
  end;

  TOldCefCustomRenderProcessHandler = class(TOldCefRenderProcessHandlerOwn)
    protected
      FCefApp      : TOldCefApplication;
      FLoadHandler : IOldCefLoadHandler;

      procedure OnRenderThreadCreated(const extraInfo: IOldCefListValue); override;
      procedure OnWebKitInitialized; override;
      procedure OnBrowserCreated(const browser: IOldCefBrowser); override;
      procedure OnBrowserDestroyed(const browser: IOldCefBrowser); override;
      function  GetLoadHandler: IOldCefLoadHandler; override;
      function  OnBeforeNavigation(const browser: IOldCefBrowser; const frame: IOldCefFrame; const request: IOldCefRequest; navigationType: TOldCefNavigationType; isRedirect: Boolean): Boolean; override;
      procedure OnContextCreated(const browser: IOldCefBrowser; const frame: IOldCefFrame; const context: IOldCefv8Context); override;
      procedure OnContextReleased(const browser: IOldCefBrowser; const frame: IOldCefFrame; const context: IOldCefv8Context); override;
      procedure OnUncaughtException(const browser: IOldCefBrowser; const frame: IOldCefFrame; const context: IOldCefv8Context; const V8Exception: IOldCefV8Exception; const stackTrace: IOldCefV8StackTrace); override;
      procedure OnFocusedNodeChanged(const browser: IOldCefBrowser; const frame: IOldCefFrame; const node: IOldCefDomNode); override;
      function  OnProcessMessageReceived(const browser: IOldCefBrowser; sourceProcess: TOldCefProcessId; const aMessage : IOldCefProcessMessage): Boolean; override;

    public
      constructor Create(const aCefApp : TOldCefApplication); reintroduce;
      destructor  Destroy; override;
  end;

implementation

uses
  {$IFDEF DELPHI16_UP}
  System.SysUtils,
  {$ELSE}
  SysUtils,
  {$ENDIF}
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFConstants, oldCEFLoadHandler;

procedure cef_render_process_handler_on_render_thread_created(self       : POldCefRenderProcessHandler;
                                                              extra_info : POldCefListValue); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRenderProcessHandlerOwn) then
    TOldCefRenderProcessHandlerOwn(TempObject).OnRenderThreadCreated(TOldCefListValueRef.UnWrap(extra_info));
end;

procedure cef_render_process_handler_on_web_kit_initialized(self: POldCefRenderProcessHandler); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRenderProcessHandlerOwn) then
    TOldCefRenderProcessHandlerOwn(TempObject).OnWebKitInitialized;
end;

procedure cef_render_process_handler_on_browser_created(self    : POldCefRenderProcessHandler;
                                                        browser : POldCefBrowser); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRenderProcessHandlerOwn) then
    TOldCefRenderProcessHandlerOwn(TempObject).OnBrowserCreated(TOldCefBrowserRef.UnWrap(browser));
end;

procedure cef_render_process_handler_on_browser_destroyed(self    : POldCefRenderProcessHandler;
                                                          browser : POldCefBrowser); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRenderProcessHandlerOwn) then
    TOldCefRenderProcessHandlerOwn(TempObject).OnBrowserDestroyed(TOldCefBrowserRef.UnWrap(browser));
end;

function cef_render_process_handler_get_load_handler(self: POldCefRenderProcessHandler): POldCefLoadHandler; stdcall;
var
  TempObject : TObject;
begin
  Result     := nil;
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRenderProcessHandlerOwn) then
    Result := CefGetData(TOldCefRenderProcessHandlerOwn(TempObject).GetLoadHandler);
end;

function cef_render_process_handler_on_before_navigation(self            : POldCefRenderProcessHandler;
                                                         browser         : POldCefBrowser;
                                                         frame           : POldCefFrame;
                                                         request         : POldCefRequest;
                                                         navigation_type : TOldCefNavigationType;
                                                         is_redirect     : Integer): Integer; stdcall;
var
  TempObject : TObject;
begin
  Result     := Ord(False);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRenderProcessHandlerOwn) then
    Result := Ord(TOldCefRenderProcessHandlerOwn(TempObject).OnBeforeNavigation(TOldCefBrowserRef.UnWrap(browser),
                                                                             TOldCefFrameRef.UnWrap(frame),
                                                                             TOldCefRequestRef.UnWrap(request),
                                                                             navigation_type,
                                                                             is_redirect <> 0));
end;

procedure cef_render_process_handler_on_context_created(self    : POldCefRenderProcessHandler;
                                                        browser : POldCefBrowser;
                                                        frame   : POldCefFrame;
                                                        context : POldCefv8Context); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRenderProcessHandlerOwn) then
    TOldCefRenderProcessHandlerOwn(TempObject).OnContextCreated(TOldCefBrowserRef.UnWrap(browser),
                                                             TOldCefFrameRef.UnWrap(frame),
                                                             TOldCefv8ContextRef.UnWrap(context));
end;

procedure cef_render_process_handler_on_context_released(self    : POldCefRenderProcessHandler;
                                                         browser : POldCefBrowser;
                                                         frame   : POldCefFrame;
                                                         context : POldCefv8Context); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRenderProcessHandlerOwn) then
    TOldCefRenderProcessHandlerOwn(TempObject).OnContextReleased(TOldCefBrowserRef.UnWrap(browser),
                                                              TOldCefFrameRef.UnWrap(frame),
                                                              TOldCefv8ContextRef.UnWrap(context));
end;

procedure cef_render_process_handler_on_uncaught_exception(self       : POldCefRenderProcessHandler;
                                                           browser    : POldCefBrowser;
                                                           frame      : POldCefFrame;
                                                           context    : POldCefv8Context;
                                                           exception  : POldCefV8Exception;
                                                           stackTrace : POldCefV8StackTrace); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRenderProcessHandlerOwn) then
    TOldCefRenderProcessHandlerOwn(TempObject).OnUncaughtException(TOldCefBrowserRef.UnWrap(browser),
                                                                TOldCefFrameRef.UnWrap(frame),
                                                                TOldCefv8ContextRef.UnWrap(context),
                                                                TOldCefV8ExceptionRef.UnWrap(exception),
                                                                TOldCefV8StackTraceRef.UnWrap(stackTrace));
end;

procedure cef_render_process_handler_on_focused_node_changed(self    : POldCefRenderProcessHandler;
                                                             browser : POldCefBrowser;
                                                             frame   : POldCefFrame;
                                                             node    : POldCefDomNode); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRenderProcessHandlerOwn) then
    TOldCefRenderProcessHandlerOwn(TempObject).OnFocusedNodeChanged(TOldCefBrowserRef.UnWrap(browser),
                                                                 TOldCefFrameRef.UnWrap(frame),
                                                                 TOldCefDomNodeRef.UnWrap(node));
end;

function cef_render_process_handler_on_process_message_received(self           : POldCefRenderProcessHandler;
                                                                browser        : POldCefBrowser;
                                                                source_process : TOldCefProcessId;
                                                                message_       : POldCefProcessMessage): Integer; stdcall;
var
  TempObject : TObject;
begin
  Result     := Ord(False);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRenderProcessHandlerOwn) then
    Result := Ord(TOldCefRenderProcessHandlerOwn(TempObject).OnProcessMessageReceived(TOldCefBrowserRef.UnWrap(browser),
                                                                                   source_process,
                                                                                   TOldCefProcessMessageRef.UnWrap(message_)));
end;


// TOldCefRenderProcessHandlerOwn


constructor TOldCefRenderProcessHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefRenderProcessHandler));

  with POldCefRenderProcessHandler(FData)^ do
    begin
      on_render_thread_created    := cef_render_process_handler_on_render_thread_created;
      on_web_kit_initialized      := cef_render_process_handler_on_web_kit_initialized;
      on_browser_created          := cef_render_process_handler_on_browser_created;
      on_browser_destroyed        := cef_render_process_handler_on_browser_destroyed;
      get_load_handler            := cef_render_process_handler_get_load_handler;
      on_before_navigation        := cef_render_process_handler_on_before_navigation;
      on_context_created          := cef_render_process_handler_on_context_created;
      on_context_released         := cef_render_process_handler_on_context_released;
      on_uncaught_exception       := cef_render_process_handler_on_uncaught_exception;
      on_focused_node_changed     := cef_render_process_handler_on_focused_node_changed;
      on_process_message_received := cef_render_process_handler_on_process_message_received;
    end;
end;

function TOldCefRenderProcessHandlerOwn.GetLoadHandler: IOldCefLoadHandler;
begin
  Result := nil;
end;

function TOldCefRenderProcessHandlerOwn.OnBeforeNavigation(const browser        : IOldCefBrowser;
                                                        const frame          : IOldCefFrame;
                                                        const request        : IOldCefRequest;
                                                              navigationType : TOldCefNavigationType;
                                                              isRedirect     : Boolean): Boolean;
begin
  Result := False;
end;

function TOldCefRenderProcessHandlerOwn.OnProcessMessageReceived(const browser       : IOldCefBrowser;
                                                                    sourceProcess : TOldCefProcessId;
                                                              const aMessage      : IOldCefProcessMessage): Boolean;
begin
  Result := False;
end;


// TOldCefCustomRenderProcessHandler


constructor TOldCefCustomRenderProcessHandler.Create(const aCefApp : TOldCefApplication);
begin
  inherited Create;

  FCefApp := aCefApp;

  if (FCefApp <> nil) and FCefApp.MustCreateLoadHandler then
    FLoadHandler := TOldCustomRenderLoadHandler.Create(FCefApp)
   else
    FLoadHandler := nil;
end;

destructor TOldCefCustomRenderProcessHandler.Destroy;
begin
  FCefApp      := nil;
  FLoadHandler := nil;

  inherited Destroy;
end;

procedure TOldCefCustomRenderProcessHandler.OnRenderThreadCreated(const extraInfo: IOldCefListValue);
begin
  try
    if (FCefApp <> nil) then FCefApp.Internal_OnRenderThreadCreated(extraInfo);
  except
    on e : exception do
      if CustomExceptionHandler('TOldCefCustomRenderProcessHandler.OnRenderThreadCreated', e) then raise;
  end;
end;

procedure TOldCefCustomRenderProcessHandler.OnWebKitInitialized;
begin
  try
    if (FCefApp <> nil) then FCefApp.Internal_OnWebKitInitialized;
  except
    on e : exception do
      if CustomExceptionHandler('TOldCefCustomRenderProcessHandler.OnWebKitInitialized', e) then raise;
  end;
end;

procedure TOldCefCustomRenderProcessHandler.OnBrowserCreated(const browser: IOldCefBrowser);
begin
  try
    if (FCefApp <> nil) then FCefApp.Internal_OnBrowserCreated(browser);
  except
    on e : exception do
      if CustomExceptionHandler('TOldCefCustomRenderProcessHandler.OnBrowserCreated', e) then raise;
  end;
end;

procedure TOldCefCustomRenderProcessHandler.OnBrowserDestroyed(const browser: IOldCefBrowser);
begin
  try
    if (FCefApp <> nil) then FCefApp.Internal_OnBrowserDestroyed(browser);
  except
    on e : exception do
      if CustomExceptionHandler('TOldCefCustomRenderProcessHandler.OnBrowserDestroyed', e) then raise;
  end;
end;

function TOldCefCustomRenderProcessHandler.GetLoadHandler: IOldCefLoadHandler;
begin
  if (FLoadHandler <> nil) then
    Result := FLoadHandler
   else
    Result := inherited GetLoadHandler;
end;

function TOldCefCustomRenderProcessHandler.OnBeforeNavigation(const browser        : IOldCefBrowser;
                                                           const frame          : IOldCefFrame;
                                                           const request        : IOldCefRequest;
                                                                 navigationType : TOldCefNavigationType;
                                                                 isRedirect     : Boolean): Boolean;
begin
  Result := inherited OnBeforeNavigation(browser, frame, request, navigationType, isRedirect);

  try
    if (FCefApp <> nil) then FCefApp.Internal_OnBeforeNavigation(browser, frame, request, navigationType, isRedirect, Result);
  except
    on e : exception do
      if CustomExceptionHandler('TOldCefCustomRenderProcessHandler.OnBeforeNavigation', e) then raise;
  end;
end;

procedure TOldCefCustomRenderProcessHandler.OnContextCreated(const browser : IOldCefBrowser;
                                                          const frame   : IOldCefFrame;
                                                          const context : IOldCefv8Context);
begin
  try
    if (FCefApp <> nil) then FCefApp.Internal_OnContextCreated(browser, frame, context);
  except
    on e : exception do
      if CustomExceptionHandler('TOldCefCustomRenderProcessHandler.OnContextCreated', e) then raise;
  end;
end;

procedure TOldCefCustomRenderProcessHandler.OnContextReleased(const browser : IOldCefBrowser;
                                                           const frame   : IOldCefFrame;
                                                           const context : IOldCefv8Context);
begin
  try
    if (FCefApp <> nil) then FCefApp.Internal_OnContextReleased(browser, frame, context);
  except
    on e : exception do
      if CustomExceptionHandler('TOldCefCustomRenderProcessHandler.OnContextReleased', e) then raise;
  end;
end;

procedure TOldCefCustomRenderProcessHandler.OnUncaughtException(const browser     : IOldCefBrowser;
                                                             const frame       : IOldCefFrame;
                                                             const context     : IOldCefv8Context;
                                                             const V8Exception : IOldCefV8Exception;
                                                             const stackTrace  : IOldCefV8StackTrace);
begin
  try
    if (FCefApp <> nil) then FCefApp.Internal_OnUncaughtException(browser, frame, context, V8Exception, stackTrace);
  except
    on e : exception do
      if CustomExceptionHandler('TOldCefCustomRenderProcessHandler.OnUncaughtException', e) then raise;
  end;
end;

procedure TOldCefCustomRenderProcessHandler.OnFocusedNodeChanged(const browser : IOldCefBrowser;
                                                              const frame   : IOldCefFrame;
                                                              const node    : IOldCefDomNode);
begin
  try
   if (FCefApp <> nil) then FCefApp.Internal_OnFocusedNodeChanged(browser, frame, node);
  except
    on e : exception do
      if CustomExceptionHandler('TOldCefCustomRenderProcessHandler.OnFocusedNodeChanged', e) then raise;
  end;
end;

function  TOldCefCustomRenderProcessHandler.OnProcessMessageReceived(const browser       : IOldCefBrowser;
                                                                        sourceProcess : TOldCefProcessId;
                                                                  const aMessage      : IOldCefProcessMessage): Boolean;
begin
  Result := inherited OnProcessMessageReceived(browser, sourceProcess, aMessage);

  try
    if (FCefApp <> nil) then FCefApp.Internal_OnProcessMessageReceived(browser, sourceProcess, aMessage, Result);
  except
    on e : exception do
      if CustomExceptionHandler('TOldCefCustomRenderProcessHandler.OnProcessMessageReceived', e) then raise;
  end;
end;

end.
