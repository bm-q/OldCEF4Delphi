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

unit oldCEFKeyboardHandler;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefKeyboardHandlerOwn = class(TOldCefBaseOwn, IOldCefKeyboardHandler)
    protected
      function OnPreKeyEvent(const browser: IOldCefBrowser; const event: POldCefKeyEvent; osEvent: TOldCefEventHandle; out isKeyboardShortcut: Boolean): Boolean; virtual;
      function OnKeyEvent(const browser: IOldCefBrowser; const event: POldCefKeyEvent; osEvent: TOldCefEventHandle): Boolean; virtual;

      procedure RemoveReferences; virtual;

    public
      constructor Create; virtual;
  end;

  TOldCustomKeyboardHandler = class(TOldCefKeyboardHandlerOwn)
    protected
      FEvents : Pointer;

      function OnPreKeyEvent(const browser: IOldCefBrowser; const event: POldCefKeyEvent; osEvent: TOldCefEventHandle; out isKeyboardShortcut: Boolean): Boolean; override;
      function OnKeyEvent(const browser: IOldCefBrowser; const event: POldCefKeyEvent; osEvent: TOldCefEventHandle): Boolean; override;

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
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFBrowser;

function cef_keyboard_handler_on_pre_key_event(      self                 : POldCefKeyboardHandler;
                                                     browser              : POldCefBrowser;
                                               const event                : POldCefKeyEvent;
                                                     os_event             : TOldCefEventHandle;
                                                     is_keyboard_shortcut : PInteger): Integer; stdcall;
var
  TempShortcut : Boolean;
  TempObject   : TObject;
begin
  Result       := Ord(False);
  TempShortcut := is_keyboard_shortcut^ <> 0;
  TempObject   := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefKeyboardHandlerOwn) then
    Result := Ord(TOldCefKeyboardHandlerOwn(TempObject).OnPreKeyEvent(TOldCefBrowserRef.UnWrap(browser),
                                                                   event,
                                                                   os_event,
                                                                   TempShortcut));

  is_keyboard_shortcut^ := Ord(TempShortcut);
end;

function cef_keyboard_handler_on_key_event(      self     : POldCefKeyboardHandler;
                                                 browser  : POldCefBrowser;
                                           const event    : POldCefKeyEvent;
                                                 os_event : TOldCefEventHandle): Integer; stdcall;
var
  TempObject : TObject;
begin
  Result     := Ord(False);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefKeyboardHandlerOwn) then
    Result := Ord(TOldCefKeyboardHandlerOwn(TempObject).OnKeyEvent(TOldCefBrowserRef.UnWrap(browser),
                                                                event,
                                                                os_event));
end;

constructor TOldCefKeyboardHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefKeyboardHandler));

  with POldCefKeyboardHandler(FData)^ do
    begin
      on_pre_key_event  := cef_keyboard_handler_on_pre_key_event;
      on_key_event      := cef_keyboard_handler_on_key_event;
    end;
end;

function TOldCefKeyboardHandlerOwn.OnPreKeyEvent(const browser: IOldCefBrowser; const event: POldCefKeyEvent; osEvent: TOldCefEventHandle; out isKeyboardShortcut: Boolean): Boolean;
begin
  Result := False;
end;

function TOldCefKeyboardHandlerOwn.OnKeyEvent(const browser: IOldCefBrowser; const event: POldCefKeyEvent; osEvent: TOldCefEventHandle): Boolean;
begin
  Result := False;
end;

procedure TOldCefKeyboardHandlerOwn.RemoveReferences;
begin
  //
end;

// TCustomKeyboardHandler

constructor TOldCustomKeyboardHandler.Create(const events: Pointer);
begin
  inherited Create;

  FEvents := events;
end;

destructor TOldCustomKeyboardHandler.Destroy;
begin
  RemoveReferences;

  inherited Destroy;
end;

procedure TOldCustomKeyboardHandler.RemoveReferences;
begin
  FEvents := nil;
end;

function TOldCustomKeyboardHandler.OnKeyEvent(const browser : IOldCefBrowser;
                                           const event   : POldCefKeyEvent;
                                                 osEvent : TOldCefEventHandle): Boolean;
begin
  if (FEvents <> nil) then
    Result := IOldChromiumEvents(FEvents).doOnKeyEvent(browser, event, osEvent)
   else
    Result := inherited OnKeyEvent(browser, event, osEvent);
end;

function TOldCustomKeyboardHandler.OnPreKeyEvent(const browser            : IOldCefBrowser;
                                              const event              : POldCefKeyEvent;
                                                    osEvent            : TOldCefEventHandle;
                                              out   isKeyboardShortcut : Boolean): Boolean;
begin
  if (FEvents <> nil) then
    Result := IOldChromiumEvents(FEvents).doOnPreKeyEvent(browser, event, osEvent, isKeyboardShortcut)
   else
    Result := inherited OnPreKeyEvent(browser, event, osEvent, isKeyboardShortcut);
end;

end.
