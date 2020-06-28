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

unit oldCEFJsDialogHandler;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefJsDialogHandlerOwn = class(TOldCefBaseOwn, IOldCefJsDialogHandler)
    protected
      function  OnJsdialog(const browser: IOldCefBrowser; const originUrl, accept_lang: oldustring; dialogType: TOldCefJsDialogType; const messageText, defaultPromptText: oldustring; const callback: IOldCefJsDialogCallback; out suppressMessage: Boolean): Boolean; virtual;
      function  OnBeforeUnloadDialog(const browser: IOldCefBrowser; const messageText: oldustring; isReload: Boolean; const callback: IOldCefJsDialogCallback): Boolean; virtual;
      procedure OnResetDialogState(const browser: IOldCefBrowser); virtual;
      procedure OnDialogClosed(const browser: IOldCefBrowser); virtual;

      procedure RemoveReferences; virtual;

    public
      constructor Create; virtual;
  end;

  TOldCustomJsDialogHandler = class(TOldCefJsDialogHandlerOwn)
    protected
      FEvents : Pointer;

      function  OnJsdialog(const browser: IOldCefBrowser; const originUrl, accept_lang: oldustring; dialogType: TOldCefJsDialogType; const messageText, defaultPromptText: oldustring; const callback: IOldCefJsDialogCallback; out suppressMessage: Boolean): Boolean; override;
      function  OnBeforeUnloadDialog(const browser: IOldCefBrowser; const messageText: oldustring; isReload: Boolean; const callback: IOldCefJsDialogCallback): Boolean; override;
      procedure OnResetDialogState(const browser: IOldCefBrowser); override;
      procedure OnDialogClosed(const browser: IOldCefBrowser); override;

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
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFBrowser, oldCEFJsDialogCallback;

function cef_jsdialog_handler_on_jsdialog(      self                : POldCefJsDialogHandler;
                                                browser             : POldCefBrowser;
                                          const origin_url          : POldCefString;
                                          const accept_lang         : POldCefString;
                                                dialog_type         : TOldCefJsDialogType;
                                          const message_text        : POldCefString;
                                          const default_prompt_text : POldCefString;
                                                callback            : POldCefJsDialogCallback;
                                                suppress_message    : PInteger): Integer; stdcall;
var
  TempSuppress : Boolean;
  TempObject   : TObject;
begin
  Result       := Ord(False);
  TempSuppress := suppress_message^ <> 0;
  TempObject   := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefJsDialogHandlerOwn) then
    Result := Ord(TOldCefJsDialogHandlerOwn(TempObject).OnJsdialog(TOldCefBrowserRef.UnWrap(browser),
                                                                CefString(origin_url),
                                                                CefString(accept_lang),
                                                                dialog_type,
                                                                CefString(message_text),
                                                                CefString(default_prompt_text),
                                                                TOldCefJsDialogCallbackRef.UnWrap(callback),
                                                                TempSuppress));

  suppress_message^ := Ord(TempSuppress);
end;

function cef_jsdialog_handler_on_before_unload_dialog(      self         : POldCefJsDialogHandler;
                                                            browser      : POldCefBrowser;
                                                      const message_text : POldCefString;
                                                            is_reload    : Integer;
                                                            callback     : POldCefJsDialogCallback): Integer; stdcall;
var
  TempObject : TObject;
begin
  Result     := Ord(False);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefJsDialogHandlerOwn) then
    Result := Ord(TOldCefJsDialogHandlerOwn(TempObject).OnBeforeUnloadDialog(TOldCefBrowserRef.UnWrap(browser),
                                                                          CefString(message_text),
                                                                          is_reload <> 0,
                                                                          TOldCefJsDialogCallbackRef.UnWrap(callback)));
end;

procedure cef_jsdialog_handler_on_reset_dialog_state(self    : POldCefJsDialogHandler;
                                                     browser : POldCefBrowser); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefJsDialogHandlerOwn) then
    TOldCefJsDialogHandlerOwn(TempObject).OnResetDialogState(TOldCefBrowserRef.UnWrap(browser));
end;

procedure cef_jsdialog_handler_on_dialog_closed(self    : POldCefJsDialogHandler;
                                                browser : POldCefBrowser); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefJsDialogHandlerOwn) then
    TOldCefJsDialogHandlerOwn(TempObject).OnDialogClosed(TOldCefBrowserRef.UnWrap(browser));
end;

constructor TOldCefJsDialogHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefJsDialogHandler));

  with POldCefJsDialogHandler(FData)^ do
    begin
      on_jsdialog             := cef_jsdialog_handler_on_jsdialog;
      on_before_unload_dialog := cef_jsdialog_handler_on_before_unload_dialog;
      on_reset_dialog_state   := cef_jsdialog_handler_on_reset_dialog_state;
      on_dialog_closed        := cef_jsdialog_handler_on_dialog_closed;
    end;
end;

function TOldCefJsDialogHandlerOwn.OnJsdialog(const browser           : IOldCefBrowser;
                                           const originUrl         : oldustring;
                                           const accept_lang       : oldustring;
                                                 dialogType        : TOldCefJsDialogType;
                                           const messageText       : oldustring;
                                           const defaultPromptText : oldustring;
                                           const callback          : IOldCefJsDialogCallback;
                                           out   suppressMessage   : Boolean): Boolean;
begin
  Result          := False;
  suppressMessage := False;
end;

function TOldCefJsDialogHandlerOwn.OnBeforeUnloadDialog(const browser     : IOldCefBrowser;
                                                     const messageText : oldustring;
                                                           isReload    : Boolean;
                                                     const callback    : IOldCefJsDialogCallback): Boolean;
begin
  Result := False;
end;

procedure TOldCefJsDialogHandlerOwn.OnDialogClosed(const browser: IOldCefBrowser);
begin
  //
end;

procedure TOldCefJsDialogHandlerOwn.OnResetDialogState(const browser: IOldCefBrowser);
begin
  //
end;

procedure TOldCefJsDialogHandlerOwn.RemoveReferences;
begin
  //
end;

// TCustomJsDialogHandler

constructor TOldCustomJsDialogHandler.Create(const events: Pointer);
begin
  inherited Create;

  FEvents := events;
end;

destructor TOldCustomJsDialogHandler.Destroy;
begin
  RemoveReferences;

  inherited Destroy;
end;

procedure TOldCustomJsDialogHandler.RemoveReferences;
begin
  FEvents := nil;
end;

function TOldCustomJsDialogHandler.OnBeforeUnloadDialog(const browser     : IOldCefBrowser;
                                                     const messageText : oldustring;
                                                           isReload    : Boolean;
                                                     const callback    : IOldCefJsDialogCallback): Boolean;
begin
  if (FEvents <> nil) then
    Result := IOldChromiumEvents(FEvents).doOnBeforeUnloadDialog(browser, messageText, isReload, callback)
   else
    Result := inherited OnBeforeUnloadDialog(browser, messageText, isReload, callback);
end;

procedure TOldCustomJsDialogHandler.OnDialogClosed(const browser: IOldCefBrowser);
begin
  if (FEvents <> nil) then IOldChromiumEvents(FEvents).doOnDialogClosed(browser);
end;

function TOldCustomJsDialogHandler.OnJsdialog(const browser           : IOldCefBrowser;
                                           const originUrl         : oldustring;
                                           const accept_lang       : oldustring;
                                                 dialogType        : TOldCefJsDialogType;
                                           const messageText       : oldustring;
                                           const defaultPromptText : oldustring;
                                           const callback          : IOldCefJsDialogCallback;
                                           out   suppressMessage   : Boolean): Boolean;
begin
  suppressMessage := False;

  if (FEvents <> nil) then
    Result := IOldChromiumEvents(FEvents).doOnJsdialog(browser, originUrl, accept_lang, dialogType, messageText, defaultPromptText, callback, suppressMessage)
   else
    Result := inherited OnJsdialog(browser, originUrl, accept_lang, dialogType, messageText, defaultPromptText, callback, suppressMessage);
end;

procedure TOldCustomJsDialogHandler.OnResetDialogState(const browser: IOldCefBrowser);
begin
  if (FEvents <> nil) then IOldChromiumEvents(FEvents).doOnResetDialogState(browser);
end;

end.
