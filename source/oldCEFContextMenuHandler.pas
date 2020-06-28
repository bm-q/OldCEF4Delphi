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

unit oldCEFContextMenuHandler;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefContextMenuHandlerOwn = class(TOldCefBaseOwn, IOldCefContextMenuHandler)
    protected
      procedure OnBeforeContextMenu(const browser: IOldCefBrowser; const frame: IOldCefFrame; const params: IOldCefContextMenuParams; const model: IOldCefMenuModel); virtual;
      function  RunContextMenu(const browser: IOldCefBrowser; const frame: IOldCefFrame; const params: IOldCefContextMenuParams; const model: IOldCefMenuModel; const callback: IOldCefRunContextMenuCallback): Boolean; virtual;
      function  OnContextMenuCommand(const browser: IOldCefBrowser; const frame: IOldCefFrame; const params: IOldCefContextMenuParams; commandId: Integer; eventFlags: TOldCefEventFlags): Boolean; virtual;
      procedure OnContextMenuDismissed(const browser: IOldCefBrowser; const frame: IOldCefFrame); virtual;

      procedure RemoveReferences; virtual;

    public
      constructor Create; virtual;
  end;

  TOldCustomContextMenuHandler = class(TOldCefContextMenuHandlerOwn)
    protected
      FEvents : Pointer;

      procedure OnBeforeContextMenu(const browser: IOldCefBrowser; const frame: IOldCefFrame; const params: IOldCefContextMenuParams; const model: IOldCefMenuModel); override;
      function  RunContextMenu(const browser: IOldCefBrowser; const frame: IOldCefFrame; const params: IOldCefContextMenuParams; const model: IOldCefMenuModel; const callback: IOldCefRunContextMenuCallback): Boolean; override;
      function  OnContextMenuCommand(const browser: IOldCefBrowser; const frame: IOldCefFrame; const params: IOldCefContextMenuParams; commandId: Integer; eventFlags: TOldCefEventFlags): Boolean; override;
      procedure OnContextMenuDismissed(const browser: IOldCefBrowser; const frame: IOldCefFrame); override;

      procedure RemoveReferences; override;

    public
      constructor Create(const events: Pointer); reintroduce; virtual;
      destructor  Destroy; override;
  end;

implementation

uses
  {$IFDEF DELPHI16_UP}
  System.SysUtils,
  {$ELSE}
  SysUtils,
  {$ENDIF}
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFBrowser, oldCEFFrame, oldCEFContextMenuParams,
  oldCEFMenuModel, oldCEFRunContextMenuCallback;

procedure cef_context_menu_handler_on_before_context_menu(self    : POldCefContextMenuHandler;
                                                          browser : POldCefBrowser;
                                                          frame   : POldCefFrame;
                                                          params  : POldCefContextMenuParams;
                                                          model   : POldCefMenuModel); stdcall;
var
  TempObject  : TObject;
begin
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefContextMenuHandlerOwn) then
    TOldCefContextMenuHandlerOwn(TempObject).OnBeforeContextMenu(TOldCefBrowserRef.UnWrap(browser),
                                                              TOldCefFrameRef.UnWrap(frame),
                                                              TOldCefContextMenuParamsRef.UnWrap(params),
                                                              TOldCefMenuModelRef.UnWrap(model));
end;

function cef_context_menu_handler_run_context_menu(self     : POldCefContextMenuHandler;
                                                   browser  : POldCefBrowser;
                                                   frame    : POldCefFrame;
                                                   params   : POldCefContextMenuParams;
                                                   model    : POldCefMenuModel;
                                                   callback : POldCefRunContextMenuCallback): Integer; stdcall;
var
  TempObject  : TObject;
begin
  Result      := Ord(False);
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefContextMenuHandlerOwn) then
    Result := Ord(TOldCefContextMenuHandlerOwn(TempObject).RunContextMenu(TOldCefBrowserRef.UnWrap(browser),
                                                                       TOldCefFrameRef.UnWrap(frame),
                                                                       TOldCefContextMenuParamsRef.UnWrap(params),
                                                                       TOldCefMenuModelRef.UnWrap(model),
                                                                       TOldCefRunContextMenuCallbackRef.UnWrap(callback)));
end;

function cef_context_menu_handler_on_context_menu_command(self        : POldCefContextMenuHandler;
                                                          browser     : POldCefBrowser;
                                                          frame       : POldCefFrame;
                                                          params      : POldCefContextMenuParams;
                                                          command_id  : Integer;
                                                          event_flags : TOldCefEventFlags): Integer; stdcall;
var
  TempObject  : TObject;
begin
  Result      := Ord(False);
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefContextMenuHandlerOwn) then
    Result := Ord(TOldCefContextMenuHandlerOwn(TempObject).OnContextMenuCommand(TOldCefBrowserRef.UnWrap(browser),
                                                                             TOldCefFrameRef.UnWrap(frame),
                                                                             TOldCefContextMenuParamsRef.UnWrap(params),
                                                                             command_id,
                                                                             event_flags));
end;

procedure cef_context_menu_handler_on_context_menu_dismissed(self    : POldCefContextMenuHandler;
                                                             browser : POldCefBrowser;
                                                             frame   : POldCefFrame); stdcall;
var
  TempObject  : TObject;
begin
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefContextMenuHandlerOwn) then
    TOldCefContextMenuHandlerOwn(TempObject).OnContextMenuDismissed(TOldCefBrowserRef.UnWrap(browser),
                                                                 TOldCefFrameRef.UnWrap(frame));
end;

constructor TOldCefContextMenuHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefContextMenuHandler));

  with POldCefContextMenuHandler(FData)^ do
    begin
      on_before_context_menu    := cef_context_menu_handler_on_before_context_menu;
      run_context_menu          := cef_context_menu_handler_run_context_menu;
      on_context_menu_command   := cef_context_menu_handler_on_context_menu_command;
      on_context_menu_dismissed := cef_context_menu_handler_on_context_menu_dismissed;
    end;
end;

procedure TOldCefContextMenuHandlerOwn.OnBeforeContextMenu(const browser : IOldCefBrowser;
                                                        const frame   : IOldCefFrame;
                                                        const params  : IOldCefContextMenuParams;
                                                        const model   : IOldCefMenuModel);
begin
  //
end;

function TOldCefContextMenuHandlerOwn.OnContextMenuCommand(const browser    : IOldCefBrowser;
                                                        const frame      : IOldCefFrame;
                                                        const params     : IOldCefContextMenuParams;
                                                              commandId  : Integer;
                                                              eventFlags : TOldCefEventFlags): Boolean;
begin
  Result := False;
end;

procedure TOldCefContextMenuHandlerOwn.OnContextMenuDismissed(const browser : IOldCefBrowser;
                                                           const frame   : IOldCefFrame);
begin
  //
end;

function TOldCefContextMenuHandlerOwn.RunContextMenu(const browser  : IOldCefBrowser;
                                                  const frame    : IOldCefFrame;
                                                  const params   : IOldCefContextMenuParams;
                                                  const model    : IOldCefMenuModel;
                                                  const callback : IOldCefRunContextMenuCallback): Boolean;
begin
  Result := False;
end;

procedure TOldCefContextMenuHandlerOwn.RemoveReferences;
begin
  //
end;

// TCustomContextMenuHandler

constructor TOldCustomContextMenuHandler.Create(const events: Pointer);
begin
  inherited Create;

  FEvents := events;
end;

destructor TOldCustomContextMenuHandler.Destroy;
begin
  RemoveReferences;

  inherited Destroy;
end;

procedure TOldCustomContextMenuHandler.RemoveReferences;
begin
  FEvents := nil;
end;

procedure TOldCustomContextMenuHandler.OnBeforeContextMenu(const browser : IOldCefBrowser;
                                                        const frame   : IOldCefFrame;
                                                        const params  : IOldCefContextMenuParams;
                                                        const model   : IOldCefMenuModel);
begin
  if (FEvents <> nil) then IOldChromiumEvents(FEvents).doOnBeforeContextMenu(browser, frame, params, model);
end;

function TOldCustomContextMenuHandler.RunContextMenu(const browser  : IOldCefBrowser;
                                                  const frame    : IOldCefFrame;
                                                  const params   : IOldCefContextMenuParams;
                                                  const model    : IOldCefMenuModel;
                                                  const callback : IOldCefRunContextMenuCallback): Boolean;
begin
  if (FEvents <> nil) then
    Result := IOldChromiumEvents(FEvents).doRunContextMenu(browser, frame, params, model, callback)
   else
    Result := inherited RunContextMenu(browser, frame, params, model, callback);
end;

function TOldCustomContextMenuHandler.OnContextMenuCommand(const browser    : IOldCefBrowser;
                                                        const frame      : IOldCefFrame;
                                                        const params     : IOldCefContextMenuParams;
                                                              commandId  : Integer;
                                                              eventFlags : TOldCefEventFlags): Boolean;
begin
  if (FEvents <> nil) then
    Result := IOldChromiumEvents(FEvents).doOnContextMenuCommand(browser, frame, params, commandId, eventFlags)
   else
    Result := inherited OnContextMenuCommand(browser, frame, params, commandId, eventFlags);
end;

procedure TOldCustomContextMenuHandler.OnContextMenuDismissed(const browser : IOldCefBrowser;
                                                           const frame   : IOldCefFrame);
begin
  if (FEvents <> nil) then IOldChromiumEvents(FEvents).doOnContextMenuDismissed(browser, frame);
end;

end.
