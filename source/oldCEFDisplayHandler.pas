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

unit oldCEFDisplayHandler;

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
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefDisplayHandlerOwn = class(TOldCefBaseOwn, IOldCefDisplayHandler)
    protected
      procedure OnAddressChange(const browser: IOldCefBrowser; const frame: IOldCefFrame; const url: oldustring); virtual;
      procedure OnTitleChange(const browser: IOldCefBrowser; const title: oldustring); virtual;
      procedure OnFaviconUrlChange(const browser: IOldCefBrowser; const iconUrls: TStrings); virtual;
      procedure OnFullScreenModeChange(const browser: IOldCefBrowser; fullscreen: Boolean); virtual;
      function  OnTooltip(const browser: IOldCefBrowser; var text: oldustring): Boolean; virtual;
      procedure OnStatusMessage(const browser: IOldCefBrowser; const value: oldustring); virtual;
      function  OnConsoleMessage(const browser: IOldCefBrowser; const message_, source: oldustring; line: Integer): Boolean; virtual;

      procedure RemoveReferences; virtual;

    public
      constructor Create; virtual;
  end;

  TOldCustomDisplayHandler = class(TOldCefDisplayHandlerOwn)
    protected
      FEvents : Pointer;

      procedure OnAddressChange(const browser: IOldCefBrowser; const frame: IOldCefFrame; const url: oldustring); override;
      procedure OnTitleChange(const browser: IOldCefBrowser; const title: oldustring); override;
      procedure OnFaviconUrlChange(const browser: IOldCefBrowser; const iconUrls: TStrings); override;
      procedure OnFullScreenModeChange(const browser: IOldCefBrowser; fullscreen: Boolean); override;
      function  OnTooltip(const browser: IOldCefBrowser; var text: oldustring): Boolean; override;
      procedure OnStatusMessage(const browser: IOldCefBrowser; const value: oldustring); override;
      function  OnConsoleMessage(const browser: IOldCefBrowser; const message_, source: oldustring; line: Integer): Boolean; override;

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
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFBrowser, oldCEFFrame, oldCEFStringList;


procedure cef_display_handler_on_address_change(      self    : POldCefDisplayHandler;
                                                      browser : POldCefBrowser;
                                                      frame   : POldCefFrame;
                                                const url     : POldCefString); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefDisplayHandlerOwn) then
    TOldCefDisplayHandlerOwn(TempObject).OnAddressChange(TOldCefBrowserRef.UnWrap(browser),
                                                      TOldCefFrameRef.UnWrap(frame),
                                                      CefString(url));
end;

procedure cef_display_handler_on_title_change(      self    : POldCefDisplayHandler;
                                                    browser : POldCefBrowser;
                                              const title   : POldCefString); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefDisplayHandlerOwn) then
    TOldCefDisplayHandlerOwn(TempObject).OnTitleChange(TOldCefBrowserRef.UnWrap(browser),
                                                    CefString(title));
end;

procedure cef_display_handler_on_favicon_urlchange(self      : POldCefDisplayHandler;
                                                   browser   : POldCefBrowser;
                                                   icon_urls : TOldCefStringList); stdcall;
var
  TempSL     : TStringList;
  TemPOldCefSL  : IOldCefStringList;
  TempObject : TObject;
begin
  TempSL := nil;

  try
    try
      TempObject := CefGetObject(self);

      if (TempObject <> nil) and (TempObject is TOldCefDisplayHandlerOwn) then
        begin
          TempSL    := TStringList.Create;
          TemPOldCefSL := TOldCefStringListRef.Create(icon_urls);
          TemPOldCefSL.CopyToStrings(TempSL);

          TOldCefDisplayHandlerOwn(TempObject).OnFaviconUrlChange(TOldCefBrowserRef.UnWrap(browser),
                                                               TempSL);
        end;
    except
      on e : exception do
        if CustomExceptionHandler('cef_display_handler_on_favicon_urlchange', e) then raise;
    end;
  finally
    if (TempSL <> nil) then FreeAndNil(TempSL);
  end;
end;

procedure cef_display_handler_on_fullscreen_mode_change(self       : POldCefDisplayHandler;
                                                        browser    : POldCefBrowser;
                                                        fullscreen : Integer); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefDisplayHandlerOwn) then
    TOldCefDisplayHandlerOwn(TempObject).OnFullScreenModeChange(TOldCefBrowserRef.UnWrap(browser),
                                                             fullscreen <> 0);
end;

function cef_display_handler_on_tooltip(self    : POldCefDisplayHandler;
                                        browser : POldCefBrowser;
                                        text    : POldCefString): Integer; stdcall;
var
  TempText   : oldustring;
  TempObject : TObject;
begin
  Result     := Ord(False);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefDisplayHandlerOwn) then
    begin
      TempText := CefStringClearAndGet(text^);
      Result   := Ord(TOldCefDisplayHandlerOwn(TempObject).OnTooltip(TOldCefBrowserRef.UnWrap(browser),
                                                                  TempText));
      text^    := CefStringAlloc(TempText);
    end;
end;

procedure cef_display_handler_on_status_message(      self    : POldCefDisplayHandler;
                                                      browser : POldCefBrowser;
                                                const value   : POldCefString); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefDisplayHandlerOwn) then
    TOldCefDisplayHandlerOwn(TempObject).OnStatusMessage(TOldCefBrowserRef.UnWrap(browser),
                                                      CefString(value));
end;

function cef_display_handler_on_console_message(      self     : POldCefDisplayHandler;
                                                      browser  : POldCefBrowser;
                                                const message_ : POldCefString;
                                                const source   : POldCefString;
                                                      line     : Integer): Integer; stdcall;
var
  TempObject : TObject;
begin
  Result     := Ord(False);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefDisplayHandlerOwn) then
    Result := Ord(TOldCefDisplayHandlerOwn(TempObject).OnConsoleMessage(TOldCefBrowserRef.UnWrap(browser),
                                                                     CefString(message_),
                                                                     CefString(source),
                                                                     line));
end;

constructor TOldCefDisplayHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefDisplayHandler));

  with POldCefDisplayHandler(FData)^ do
    begin
      on_address_change         := cef_display_handler_on_address_change;
      on_title_change           := cef_display_handler_on_title_change;
      on_favicon_urlchange      := cef_display_handler_on_favicon_urlchange;
      on_fullscreen_mode_change := cef_display_handler_on_fullscreen_mode_change;
      on_tooltip                := cef_display_handler_on_tooltip;
      on_status_message         := cef_display_handler_on_status_message;
      on_console_message        := cef_display_handler_on_console_message;
    end;
end;

procedure TOldCefDisplayHandlerOwn.OnAddressChange(const browser: IOldCefBrowser; const frame: IOldCefFrame; const url: oldustring);
begin
  //
end;

function TOldCefDisplayHandlerOwn.OnConsoleMessage(const browser: IOldCefBrowser; const message_, source: oldustring; line: Integer): Boolean;
begin
  Result := False;
end;

procedure TOldCefDisplayHandlerOwn.OnFaviconUrlChange(const browser: IOldCefBrowser; const iconUrls: TStrings);
begin
  //
end;

procedure TOldCefDisplayHandlerOwn.OnFullScreenModeChange(const browser: IOldCefBrowser; fullscreen: Boolean);
begin
  //
end;

procedure TOldCefDisplayHandlerOwn.OnStatusMessage(const browser: IOldCefBrowser; const value: oldustring);
begin
  //
end;

procedure TOldCefDisplayHandlerOwn.OnTitleChange(const browser: IOldCefBrowser; const title: oldustring);
begin
  //
end;

function TOldCefDisplayHandlerOwn.OnTooltip(const browser: IOldCefBrowser; var text: oldustring): Boolean;
begin
  Result := False;
end;

procedure TOldCefDisplayHandlerOwn.RemoveReferences;
begin
  //
end;

// TCustomDisplayHandler

constructor TOldCustomDisplayHandler.Create(const events: Pointer);
begin
  inherited Create;

  FEvents := events;
end;

destructor TOldCustomDisplayHandler.Destroy;
begin
  RemoveReferences;

  inherited Destroy;
end;

procedure TOldCustomDisplayHandler.RemoveReferences;
begin
  FEvents := nil;
end;

procedure TOldCustomDisplayHandler.OnAddressChange(const browser : IOldCefBrowser;
                                                const frame   : IOldCefFrame;
                                                const url     : oldustring);
begin
  if (FEvents <> nil) then IOldChromiumEvents(FEvents).doOnAddressChange(browser, frame, url);
end;

function TOldCustomDisplayHandler.OnConsoleMessage(const browser  : IOldCefBrowser;
                                                const message_ : oldustring;
                                                const source   : oldustring;
                                                      line     : Integer): Boolean;
begin
  if (FEvents <> nil) then
    Result := IOldChromiumEvents(FEvents).doOnConsoleMessage(browser, message_, source, line)
   else
    Result := inherited OnConsoleMessage(browser, message_, source, line);
end;

procedure TOldCustomDisplayHandler.OnFaviconUrlChange(const browser: IOldCefBrowser; const iconUrls: TStrings);
begin
  if (FEvents <> nil) then IOldChromiumEvents(FEvents).doOnFaviconUrlChange(browser, iconUrls);
end;

procedure TOldCustomDisplayHandler.OnFullScreenModeChange(const browser: IOldCefBrowser; fullscreen: Boolean);
begin
  if (FEvents <> nil) then IOldChromiumEvents(FEvents).doOnFullScreenModeChange(browser, fullscreen);
end;

procedure TOldCustomDisplayHandler.OnStatusMessage(const browser: IOldCefBrowser; const value: oldustring);
begin
  if (FEvents <> nil) then IOldChromiumEvents(FEvents).doOnStatusMessage(browser, value);
end;

procedure TOldCustomDisplayHandler.OnTitleChange(const browser: IOldCefBrowser; const title: oldustring);
begin
  if (FEvents <> nil) then IOldChromiumEvents(FEvents).doOnTitleChange(browser, title);
end;

function TOldCustomDisplayHandler.OnTooltip(const browser: IOldCefBrowser; var text: oldustring): Boolean;
begin
  if (FEvents <> nil) then
    Result := IOldChromiumEvents(FEvents).doOnTooltip(browser, text)
   else
    Result := inherited OnTooltip(browser, text);
end;

end.
