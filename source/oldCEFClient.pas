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

unit oldCEFClient;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefClientRef = class(TOldCefBaseRef, IOldCefClient)
    protected
      procedure GetContextMenuHandler(var aHandler : IOldCefContextMenuHandler); virtual;
      procedure GetDialogHandler(var aHandler : IOldCefDialogHandler); virtual;
      procedure GetDisplayHandler(var aHandler : IOldCefDisplayHandler); virtual;
      procedure GetDownloadHandler(var aHandler : IOldCefDownloadHandler); virtual;
      procedure GetDragHandler(var aHandler : IOldCefDragHandler); virtual;
      procedure GetFindHandler(var aHandler : IOldCefFindHandler); virtual;
      procedure GetFocusHandler(var aHandler : IOldCefFocusHandler); virtual;
      procedure GetGeolocationHandler(var aHandler : IOldCefGeolocationHandler); virtual;
      procedure GetJsdialogHandler(var aHandler : IOldCefJsDialogHandler); virtual;
      procedure GetKeyboardHandler(var aHandler : IOldCefKeyboardHandler); virtual;
      procedure GetLifeSpanHandler(var aHandler : IOldCefLifeSpanHandler); virtual;
      procedure GetLoadHandler(var aHandler : IOldCefLoadHandler); virtual;
      procedure GetRenderHandler(var aHandler : IOldCefRenderHandler); virtual;
      procedure GetRequestHandler(var aHandler : IOldCefRequestHandler); virtual;
      function  OnProcessMessageReceived(const browser: IOldCefBrowser; sourceProcess: TOldCefProcessId; const message_ : IOldCefProcessMessage): Boolean; virtual;

      procedure RemoveReferences; virtual;

    public
      class function UnWrap(data: Pointer): IOldCefClient;
  end;

  TOldCefClientOwn = class(TOldCefBaseOwn, IOldCefClient)
    protected
      procedure GetContextMenuHandler(var aHandler : IOldCefContextMenuHandler); virtual;
      procedure GetDialogHandler(var aHandler : IOldCefDialogHandler); virtual;
      procedure GetDisplayHandler(var aHandler : IOldCefDisplayHandler); virtual;
      procedure GetDownloadHandler(var aHandler : IOldCefDownloadHandler); virtual;
      procedure GetDragHandler(var aHandler : IOldCefDragHandler); virtual;
      procedure GetFindHandler(var aHandler : IOldCefFindHandler); virtual;
      procedure GetFocusHandler(var aHandler : IOldCefFocusHandler); virtual;
      procedure GetGeolocationHandler(var aHandler : IOldCefGeolocationHandler); virtual;
      procedure GetJsdialogHandler(var aHandler : IOldCefJsDialogHandler); virtual;
      procedure GetKeyboardHandler(var aHandler : IOldCefKeyboardHandler); virtual;
      procedure GetLifeSpanHandler(var aHandler : IOldCefLifeSpanHandler); virtual;
      procedure GetLoadHandler(var aHandler : IOldCefLoadHandler); virtual;
      procedure GetRenderHandler(var aHandler : IOldCefRenderHandler); virtual;
      procedure GetRequestHandler(var aHandler : IOldCefRequestHandler); virtual;
      function  OnProcessMessageReceived(const browser: IOldCefBrowser; sourceProcess: TOldCefProcessId; const message_ : IOldCefProcessMessage): Boolean; virtual;

      procedure RemoveReferences; virtual;

    public
      constructor Create; virtual;
  end;

  TOldCustomClientHandler = class(TOldCefClientOwn)
    protected
      FEvents             : Pointer;
      FLoadHandler        : IOldCefLoadHandler;
      FFocusHandler       : IOldCefFocusHandler;
      FContextMenuHandler : IOldCefContextMenuHandler;
      FDialogHandler      : IOldCefDialogHandler;
      FKeyboardHandler    : IOldCefKeyboardHandler;
      FDisplayHandler     : IOldCefDisplayHandler;
      FDownloadHandler    : IOldCefDownloadHandler;
      FGeolocationHandler : IOldCefGeolocationHandler;
      FJsDialogHandler    : IOldCefJsDialogHandler;
      FLifeSpanHandler    : IOldCefLifeSpanHandler;
      FRenderHandler      : IOldCefRenderHandler;
      FRequestHandler     : IOldCefRequestHandler;
      FDragHandler        : IOldCefDragHandler;
      FFindHandler        : IOldCefFindHandler;

      procedure GetContextMenuHandler(var aHandler : IOldCefContextMenuHandler); override;
      procedure GetDialogHandler(var aHandler : IOldCefDialogHandler); override;
      procedure GetDisplayHandler(var aHandler : IOldCefDisplayHandler); override;
      procedure GetDownloadHandler(var aHandler : IOldCefDownloadHandler); override;
      procedure GetDragHandler(var aHandler : IOldCefDragHandler); override;
      procedure GetFindHandler(var aHandler : IOldCefFindHandler); override;
      procedure GetFocusHandler(var aHandler : IOldCefFocusHandler); override;
      procedure GetGeolocationHandler(var aHandler : IOldCefGeolocationHandler); override;
      procedure GetJsdialogHandler(var aHandler : IOldCefJsDialogHandler); override;
      procedure GetKeyboardHandler(var aHandler : IOldCefKeyboardHandler); override;
      procedure GetLifeSpanHandler(var aHandler : IOldCefLifeSpanHandler); override;
      procedure GetLoadHandler(var aHandler : IOldCefLoadHandler); override;
      procedure GetRenderHandler(var aHandler : IOldCefRenderHandler); override;
      procedure GetRequestHandler(var aHandler : IOldCefRequestHandler); override;
      function  OnProcessMessageReceived(const browser: IOldCefBrowser; sourceProcess: TOldCefProcessId; const message_ : IOldCefProcessMessage): Boolean; override;

      procedure InitializeVars;

    public
      constructor Create(const events: IOldChromiumEvents;
                         aCreateLoadHandler, aCreateFocusHandler, aCreateContextMenuHandler, aCreateDialogHandler,
                         aCreateKeyboardHandler, aCreateDisplayHandler, aCreateDownloadHandler, aCreateGeolocationHandler,
                         aCreateJsDialogHandler, aCreateLifeSpanHandler, aCreateRenderHandler, aCreateRequestHandler,
                         aCreateDragHandler, aCreateFindHandler : boolean); reintroduce; virtual;
      procedure   BeforeDestruction; override;
      procedure   RemoveReferences; override;
  end;

implementation

uses
  {$IFDEF DELPHI16_UP}
  System.SysUtils,
  {$ELSE}
  SysUtils,
  {$ENDIF}
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFProcessMessage, oldCEFBrowser, oldCEFLoadHandler,
  oldCEFFocusHandler, oldCEFContextMenuHandler, oldCEFDialogHandler, oldCEFKeyboardHandler,
  oldCEFDisplayHandler, oldCEFDownloadHandler, oldCEFJsDialogHandler, oldCEFGeolocationHandler,
  oldCEFLifeSpanHandler, oldCEFRequestHandler, oldCEFRenderHandler, oldCEFDragHandler,
  oldCEFFindHandler, oldCEFConstants, oldCEFApplication;


// ******************************************************
// ****************** TOldCefClientRef *********************
// ******************************************************

class function TOldCefClientRef.UnWrap(data: Pointer): IOldCefClient;
begin
  if (data <> nil) then
    Result := Create(data) as IOldCefClient
   else
    Result := nil;
end;

procedure TOldCefClientRef.GetContextMenuHandler(var aHandler : IOldCefContextMenuHandler);
begin
  aHandler := nil;
end;

procedure TOldCefClientRef.GetDialogHandler(var aHandler : IOldCefDialogHandler);
begin
  aHandler := nil;
end;

procedure TOldCefClientRef.GetDisplayHandler(var aHandler : IOldCefDisplayHandler);
begin
  aHandler := nil;
end;

procedure TOldCefClientRef.GetDownloadHandler(var aHandler : IOldCefDownloadHandler);
begin
  aHandler := nil;
end;

procedure TOldCefClientRef.GetGeolocationHandler(var aHandler : IOldCefGeolocationHandler);
begin
  aHandler := nil;
end;

procedure TOldCefClientRef.GetDragHandler(var aHandler : IOldCefDragHandler);
begin
  aHandler := nil;
end;

procedure TOldCefClientRef.GetFindHandler(var aHandler : IOldCefFindHandler);
begin
  aHandler := nil;
end;

procedure TOldCefClientRef.GetFocusHandler(var aHandler : IOldCefFocusHandler);
begin
  aHandler := nil;
end;

procedure TOldCefClientRef.GetJsdialogHandler(var aHandler : IOldCefJsDialogHandler);
begin
  aHandler := nil;
end;

procedure TOldCefClientRef.GetKeyboardHandler(var aHandler : IOldCefKeyboardHandler);
begin
  aHandler := nil;
end;

procedure TOldCefClientRef.GetLifeSpanHandler(var aHandler : IOldCefLifeSpanHandler);
begin
  aHandler := nil;
end;

procedure TOldCefClientRef.GetLoadHandler(var aHandler : IOldCefLoadHandler);
begin
  aHandler := nil;
end;

procedure TOldCefClientRef.GetRenderHandler(var aHandler : IOldCefRenderHandler);
begin
  aHandler := nil;
end;

procedure TOldCefClientRef.GetRequestHandler(var aHandler : IOldCefRequestHandler);
begin
  aHandler := nil;
end;

function TOldCefClientRef.OnProcessMessageReceived(const browser: IOldCefBrowser; sourceProcess: TOldCefProcessId; const message_ : IOldCefProcessMessage): Boolean;
begin
  Result := False;
end;

procedure TOldCefClientRef.RemoveReferences;
begin
  //
end;


// ******************************************************
// ****************** TOldCefClientOwn *********************
// ******************************************************


function cef_client_own_get_context_menu_handler(self: POldCefClient): POldCefContextMenuHandler; stdcall;
var
  TempObject  : TObject;
  TempHandler : IOldCefContextMenuHandler;
begin
  Result      := nil;
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefClientOwn) then
    try
      TOldCefClientOwn(TempObject).GetContextMenuHandler(TempHandler);
      if (TempHandler <> nil) then Result := TempHandler.Wrap;
    finally
      TempHandler := nil;
    end;
end;

function cef_client_own_get_dialog_handler(self: POldCefClient): POldCefDialogHandler; stdcall;
var
  TempObject  : TObject;
  TempHandler : IOldCefDialogHandler;
begin
  Result      := nil;
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefClientOwn) then
    try
      TOldCefClientOwn(TempObject).GetDialogHandler(TempHandler);
      if (TempHandler <> nil) then Result := TempHandler.Wrap;
    finally
      TempHandler := nil;
    end;
end;

function cef_client_own_get_display_handler(self: POldCefClient): POldCefDisplayHandler; stdcall;
var
  TempObject  : TObject;
  TempHandler : IOldCefDisplayHandler;
begin
  Result      := nil;
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefClientOwn) then
    try
      TOldCefClientOwn(TempObject).GetDisplayHandler(TempHandler);
      if (TempHandler <> nil) then Result := TempHandler.Wrap;
    finally
      TempHandler := nil;
    end;
end;

function cef_client_own_get_download_handler(self: POldCefClient): POldCefDownloadHandler; stdcall;
var
  TempObject  : TObject;
  TempHandler : IOldCefDownloadHandler;
begin
  Result      := nil;
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefClientOwn) then
    try
      TOldCefClientOwn(TempObject).GetDownloadHandler(TempHandler);
      if (TempHandler <> nil) then Result := TempHandler.Wrap;
    finally
      TempHandler := nil;
    end;
end;

function cef_client_own_get_geolocation_handler(self: POldCefClient): POldCefGeolocationHandler; stdcall;
var
  TempObject  : TObject;
  TempHandler : IOldCefGeolocationHandler;
begin
  Result      := nil;
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefClientOwn) then
    try
      TOldCefClientOwn(TempObject).GetGeolocationHandler(TempHandler);
      if (TempHandler <> nil) then Result := TempHandler.Wrap;
    finally
      TempHandler := nil;
    end;
end;

function cef_client_own_get_drag_handler(self: POldCefClient): POldCefDragHandler; stdcall;
var
  TempObject  : TObject;
  TempHandler : IOldCefDragHandler;
begin
  Result      := nil;
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefClientOwn) then
    try
      TOldCefClientOwn(TempObject).GetDragHandler(TempHandler);
      if (TempHandler <> nil) then Result := TempHandler.Wrap;
    finally
      TempHandler := nil;
    end;
end;

function cef_client_own_get_find_handler(self: POldCefClient): POldCefFindHandler; stdcall;
var
  TempObject  : TObject;
  TempHandler : IOldCefFindHandler;
begin
  Result      := nil;
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefClientOwn) then
    try
      TOldCefClientOwn(TempObject).GetFindHandler(TempHandler);
      if (TempHandler <> nil) then Result := TempHandler.Wrap;
    finally
      TempHandler := nil;
    end;
end;

function cef_client_own_get_focus_handler(self: POldCefClient): POldCefFocusHandler; stdcall;
var
  TempObject  : TObject;
  TempHandler : IOldCefFocusHandler;
begin
  Result      := nil;
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefClientOwn) then
    try
      TOldCefClientOwn(TempObject).GetFocusHandler(TempHandler);
      if (TempHandler <> nil) then Result := TempHandler.Wrap;
    finally
      TempHandler := nil;
    end;
end;

function cef_client_own_get_jsdialog_handler(self: POldCefClient): POldCefJsDialogHandler; stdcall;
var
  TempObject  : TObject;
  TempHandler : IOldCefJsDialogHandler;
begin
  Result      := nil;
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefClientOwn) then
    try
      TOldCefClientOwn(TempObject).GetJsdialogHandler(TempHandler);
      if (TempHandler <> nil) then Result := TempHandler.Wrap;
    finally
      TempHandler := nil;
    end;
end;

function cef_client_own_get_keyboard_handler(self: POldCefClient): POldCefKeyboardHandler; stdcall;
var
  TempObject  : TObject;
  TempHandler : IOldCefKeyboardHandler;
begin
  Result      := nil;
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefClientOwn) then
    try
      TOldCefClientOwn(TempObject).GetKeyboardHandler(TempHandler);
      if (TempHandler <> nil) then Result := TempHandler.Wrap;
    finally
      TempHandler := nil;
    end;
end;

function cef_client_own_get_life_span_handler(self: POldCefClient): POldCefLifeSpanHandler; stdcall;
var
  TempObject  : TObject;
  TempHandler : IOldCefLifeSpanHandler;
begin
  Result      := nil;
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefClientOwn) then
    try
      TOldCefClientOwn(TempObject).GetLifeSpanHandler(TempHandler);
      if (TempHandler <> nil) then Result := TempHandler.Wrap;
    finally
      TempHandler := nil;
    end;
end;

function cef_client_own_get_load_handler(self: POldCefClient): POldCefLoadHandler; stdcall;
var
  TempObject  : TObject;
  TempHandler : IOldCefLoadHandler;
begin
  Result      := nil;
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefClientOwn) then
    try
      TOldCefClientOwn(TempObject).GetLoadHandler(TempHandler);
      if (TempHandler <> nil) then Result := TempHandler.Wrap;
    finally
      TempHandler := nil;
    end;
end;

function cef_client_own_get_get_render_handler(self: POldCefClient): POldCefRenderHandler; stdcall;
var
  TempObject  : TObject;
  TempHandler : IOldCefRenderHandler;
begin
  Result      := nil;
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefClientOwn) then
    try
      TOldCefClientOwn(TempObject).GetRenderHandler(TempHandler);
      if (TempHandler <> nil) then Result := TempHandler.Wrap;
    finally
      TempHandler := nil;
    end;
end;

function cef_client_own_get_request_handler(self: POldCefClient): POldCefRequestHandler; stdcall;
var
  TempObject  : TObject;
  TempHandler : IOldCefRequestHandler;
begin
  Result      := nil;
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefClientOwn) then
    try
      TOldCefClientOwn(TempObject).GetRequestHandler(TempHandler);
      if (TempHandler <> nil) then Result := TempHandler.Wrap;
    finally
      TempHandler := nil;
    end;
end;

function cef_client_own_on_process_message_received(self           : POldCefClient;
                                                    browser        : POldCefBrowser;
                                                    source_process : TOldCefProcessId;
                                                    message_       : POldCefProcessMessage): Integer; stdcall;
var
  TempObject  : TObject;
begin
  Result      := Ord(False);
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefClientOwn) then
    Result := Ord(TOldCefClientOwn(TempObject).OnProcessMessageReceived(TOldCefBrowserRef.UnWrap(browser),
                                                                     source_process,
                                                                     TOldCefProcessMessageRef.UnWrap(message_)));
end;

constructor TOldCefClientOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefClient));

  with POldCefClient(FData)^ do
    begin
      get_context_menu_handler    := cef_client_own_get_context_menu_handler;
      get_dialog_handler          := cef_client_own_get_dialog_handler;
      get_display_handler         := cef_client_own_get_display_handler;
      get_download_handler        := cef_client_own_get_download_handler;
      get_drag_handler            := cef_client_own_get_drag_handler;
      get_find_handler            := cef_client_own_get_find_handler;
      get_focus_handler           := cef_client_own_get_focus_handler;
      get_geolocation_handler     := cef_client_own_get_geolocation_handler;
      get_jsdialog_handler        := cef_client_own_get_jsdialog_handler;
      get_keyboard_handler        := cef_client_own_get_keyboard_handler;
      get_life_span_handler       := cef_client_own_get_life_span_handler;
      get_load_handler            := cef_client_own_get_load_handler;
      get_render_handler          := cef_client_own_get_get_render_handler;
      get_request_handler         := cef_client_own_get_request_handler;
      on_process_message_received := cef_client_own_on_process_message_received;
    end;
end;

procedure TOldCefClientOwn.GetContextMenuHandler(var aHandler : IOldCefContextMenuHandler);
begin
  aHandler := nil;
end;

procedure TOldCefClientOwn.GetDialogHandler(var aHandler : IOldCefDialogHandler);
begin
  aHandler := nil;
end;

procedure TOldCefClientOwn.GetDisplayHandler(var aHandler : IOldCefDisplayHandler);
begin
  aHandler := nil;
end;

procedure TOldCefClientOwn.GetDownloadHandler(var aHandler : IOldCefDownloadHandler);
begin
  aHandler := nil;
end;

procedure TOldCefClientOwn.GetDragHandler(var aHandler : IOldCefDragHandler);
begin
  aHandler := nil;
end;

procedure TOldCefClientOwn.GetFindHandler(var aHandler : IOldCefFindHandler);
begin
  aHandler := nil;
end;

procedure TOldCefClientOwn.GetFocusHandler(var aHandler : IOldCefFocusHandler);
begin
  aHandler := nil;
end;

procedure TOldCefClientOwn.GetGeolocationHandler(var aHandler : IOldCefGeolocationHandler);
begin
  aHandler := nil;
end;

procedure TOldCefClientOwn.GetJsdialogHandler(var aHandler : IOldCefJsDialogHandler);
begin
  aHandler := nil;
end;

procedure TOldCefClientOwn.GetKeyboardHandler(var aHandler : IOldCefKeyboardHandler);
begin
  aHandler := nil;
end;

procedure TOldCefClientOwn.GetLifeSpanHandler(var aHandler : IOldCefLifeSpanHandler);
begin
  aHandler := nil;
end;

procedure TOldCefClientOwn.GetLoadHandler(var aHandler : IOldCefLoadHandler);
begin
  aHandler := nil;
end;

procedure TOldCefClientOwn.GetRenderHandler(var aHandler : IOldCefRenderHandler);
begin
  aHandler := nil;
end;

procedure TOldCefClientOwn.GetRequestHandler(var aHandler : IOldCefRequestHandler);
begin
  aHandler := nil;
end;

function TOldCefClientOwn.OnProcessMessageReceived(const browser       : IOldCefBrowser;
                                                      sourceProcess : TOldCefProcessId;
                                                const message_      : IOldCefProcessMessage): Boolean;
begin
  Result := False;
end;

procedure TOldCefClientOwn.RemoveReferences;
begin
  //
end;


// ******************************************************
// *************** TCustomClientHandler *****************
// ******************************************************


constructor TOldCustomClientHandler.Create(const events                     : IOldChromiumEvents;
                                              aCreateLoadHandler         : boolean;
                                              aCreateFocusHandler        : boolean;
                                              aCreateContextMenuHandler  : boolean;
                                              aCreateDialogHandler       : boolean;
                                              aCreateKeyboardHandler     : boolean;
                                              aCreateDisplayHandler      : boolean;
                                              aCreateDownloadHandler     : boolean;
                                              aCreateGeolocationHandler  : boolean;
                                              aCreateJsDialogHandler     : boolean;
                                              aCreateLifeSpanHandler     : boolean;
                                              aCreateRenderHandler       : boolean;
                                              aCreateRequestHandler      : boolean;
                                              aCreateDragHandler         : boolean;
                                              aCreateFindHandler         : boolean);
begin
  inherited Create;

  InitializeVars;

  FEvents := Pointer(events);

  if (FEvents <> nil) then
    begin
      if aCreateLoadHandler        then FLoadHandler        := TOldCustomLoadHandler.Create(FEvents);
      if aCreateFocusHandler       then FFocusHandler       := TOldCustomFocusHandler.Create(FEvents);
      if aCreateContextMenuHandler then FContextMenuHandler := TOldCustomContextMenuHandler.Create(FEvents);
      if aCreateDialogHandler      then FDialogHandler      := TOldCustomDialogHandler.Create(FEvents);
      if aCreateKeyboardHandler    then FKeyboardHandler    := TOldCustomKeyboardHandler.Create(FEvents);
      if aCreateDisplayHandler     then FDisplayHandler     := TOldCustomDisplayHandler.Create(FEvents);
      if aCreateDownloadHandler    then FDownloadHandler    := TOldCustomDownloadHandler.Create(FEvents);
      if aCreateGeolocationHandler then FGeolocationHandler := TOldCustomGeolocationHandler.Create(FEvents);
      if aCreateJsDialogHandler    then FJsDialogHandler    := TOldCustomJsDialogHandler.Create(FEvents);
      if aCreateLifeSpanHandler    then FLifeSpanHandler    := TOldCustomLifeSpanHandler.Create(FEvents);
      if aCreateRenderHandler      then FRenderHandler      := TOldCustomRenderHandler.Create(FEvents);
      if aCreateRequestHandler     then FRequestHandler     := TOldCustomRequestHandler.Create(FEvents);
      if aCreateDragHandler        then FDragHandler        := TOldCustomDragHandler.Create(FEvents);
      if aCreateFindHandler        then FFindHandler        := TOldCustomFindHandler.Create(FEvents);
    end;
end;

procedure TOldCustomClientHandler.BeforeDestruction;
begin
  InitializeVars;

  inherited BeforeDestruction;
end;

procedure TOldCustomClientHandler.RemoveReferences;
begin
  FEvents := nil;

  if (FLoadHandler        <> nil) then FLoadHandler.RemoveReferences;
  if (FFocusHandler       <> nil) then FFocusHandler.RemoveReferences;
  if (FContextMenuHandler <> nil) then FContextMenuHandler.RemoveReferences;
  if (FDialogHandler      <> nil) then FDialogHandler.RemoveReferences;
  if (FKeyboardHandler    <> nil) then FKeyboardHandler.RemoveReferences;
  if (FDisplayHandler     <> nil) then FDisplayHandler.RemoveReferences;
  if (FDownloadHandler    <> nil) then FDownloadHandler.RemoveReferences;
  if (FGeolocationHandler <> nil) then FGeolocationHandler.RemoveReferences;
  if (FJsDialogHandler    <> nil) then FJsDialogHandler.RemoveReferences;
  if (FLifeSpanHandler    <> nil) then FLifeSpanHandler.RemoveReferences;
  if (FRequestHandler     <> nil) then FRequestHandler.RemoveReferences;
  if (FRenderHandler      <> nil) then FRenderHandler.RemoveReferences;
  if (FDragHandler        <> nil) then FDragHandler.RemoveReferences;
  if (FFindHandler        <> nil) then FFindHandler.RemoveReferences;
end;

procedure TOldCustomClientHandler.InitializeVars;
begin
  FLoadHandler        := nil;
  FFocusHandler       := nil;
  FContextMenuHandler := nil;
  FDialogHandler      := nil;
  FKeyboardHandler    := nil;
  FDisplayHandler     := nil;
  FDownloadHandler    := nil;
  FGeolocationHandler := nil;
  FJsDialogHandler    := nil;
  FLifeSpanHandler    := nil;
  FRequestHandler     := nil;
  FRenderHandler      := nil;
  FDragHandler        := nil;
  FFindHandler        := nil;
  FEvents             := nil;
end;

procedure TOldCustomClientHandler.GetContextMenuHandler(var aHandler : IOldCefContextMenuHandler);
begin
  if (FContextMenuHandler <> nil) then
    aHandler := FContextMenuHandler
   else
    aHandler := nil;
end;

procedure TOldCustomClientHandler.GetDialogHandler(var aHandler : IOldCefDialogHandler);
begin
  if (FDialogHandler <> nil) then
    aHandler := FDialogHandler
   else
    aHandler := nil;
end;

procedure TOldCustomClientHandler.GetDisplayHandler(var aHandler : IOldCefDisplayHandler);
begin
  if (FDisplayHandler <> nil) then
    aHandler := FDisplayHandler
   else
    aHandler := nil;
end;

procedure TOldCustomClientHandler.GetDownloadHandler(var aHandler : IOldCefDownloadHandler);
begin
  if (FDownloadHandler <> nil) then
    aHandler := FDownloadHandler
   else
    aHandler := nil;
end;

procedure TOldCustomClientHandler.GetGeolocationHandler(var aHandler : IOldCefGeolocationHandler);
begin
  if (FGeolocationHandler <> nil) then
    aHandler := FGeolocationHandler
   else
    aHandler := nil;
end;

procedure TOldCustomClientHandler.GetDragHandler(var aHandler : IOldCefDragHandler);
begin
  if (FDragHandler <> nil) then
    aHandler := FDragHandler
   else
    aHandler := nil;
end;

procedure TOldCustomClientHandler.GetFindHandler(var aHandler : IOldCefFindHandler);
begin
  if (FFindHandler <> nil) then
    aHandler := FFindHandler
   else
    aHandler := nil;
end;

procedure TOldCustomClientHandler.GetFocusHandler(var aHandler : IOldCefFocusHandler);
begin
  if (FFocusHandler <> nil) then
    aHandler := FFocusHandler
   else
    aHandler := nil;
end;

procedure TOldCustomClientHandler.GetJsdialogHandler(var aHandler : IOldCefJsDialogHandler);
begin
  if (FJsDialogHandler <> nil) then
    aHandler := FJsDialogHandler
   else
    aHandler := nil;
end;

procedure TOldCustomClientHandler.GetKeyboardHandler(var aHandler : IOldCefKeyboardHandler);
begin
  if (FKeyboardHandler <> nil) then
    aHandler := FKeyboardHandler
   else
    aHandler := nil;
end;

procedure TOldCustomClientHandler.GetLifeSpanHandler(var aHandler : IOldCefLifeSpanHandler);
begin
  if (FLifeSpanHandler <> nil) then
    aHandler := FLifeSpanHandler
   else
    aHandler := nil;
end;

procedure TOldCustomClientHandler.GetLoadHandler(var aHandler : IOldCefLoadHandler);
begin
  if (FLoadHandler <> nil) then
    aHandler := FLoadHandler
   else
    aHandler := nil;
end;

procedure TOldCustomClientHandler.GetRenderHandler(var aHandler : IOldCefRenderHandler);
begin
  if (FRenderHandler <> nil) then
    aHandler := FRenderHandler
   else
    aHandler := nil;
end;

procedure TOldCustomClientHandler.GetRequestHandler(var aHandler : IOldCefRequestHandler);
begin
  if (FRequestHandler <> nil) then
    aHandler := FRequestHandler
   else
    aHandler := nil;
end;

function TOldCustomClientHandler.OnProcessMessageReceived(const browser       : IOldCefBrowser;
                                                             sourceProcess : TOldCefProcessId;
                                                       const message_      : IOldCefProcessMessage): Boolean;
begin
  if (FEvents <> nil) then
    Result := IOldChromiumEvents(FEvents).doOnProcessMessageReceived(browser, sourceProcess, message_)
   else
    Result := inherited OnProcessMessageReceived(browser, sourceProcess, message_);
end;

end.
