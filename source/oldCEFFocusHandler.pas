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

unit oldCEFFocusHandler;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefFocusHandlerOwn = class(TOldCefBaseOwn, IOldCefFocusHandler)
    protected
      procedure OnTakeFocus(const browser: IOldCefBrowser; next: Boolean); virtual;
      function  OnSetFocus(const browser: IOldCefBrowser; source: TOldCefFocusSource): Boolean; virtual;
      procedure OnGotFocus(const browser: IOldCefBrowser); virtual;

      procedure RemoveReferences; virtual;

    public
      constructor Create; virtual;
  end;

  TOldCustomFocusHandler = class(TOldCefFocusHandlerOwn)
    protected
      FEvents : Pointer;

      procedure OnTakeFocus(const browser: IOldCefBrowser; next: Boolean); override;
      function  OnSetFocus(const browser: IOldCefBrowser; source: TOldCefFocusSource): Boolean; override;
      procedure OnGotFocus(const browser: IOldCefBrowser); override;

      procedure RemoveReferences; override;

    public
      constructor Create(const events : Pointer); reintroduce; virtual;
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

procedure cef_focus_handler_on_take_focus(self    : POldCefFocusHandler;
                                          browser : POldCefBrowser;
                                          next    : Integer); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefFocusHandlerOwn) then
    TOldCefFocusHandlerOwn(TempObject).OnTakeFocus(TOldCefBrowserRef.UnWrap(browser),
                                                next <> 0);
end;

function cef_focus_handler_on_set_focus(self    : POldCefFocusHandler;
                                        browser : POldCefBrowser;
                                        source  : TOldCefFocusSource): Integer; stdcall;
var
  TempObject : TObject;
begin
  Result     := Ord(False);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefFocusHandlerOwn) then
    Result := Ord(TOldCefFocusHandlerOwn(TempObject).OnSetFocus(TOldCefBrowserRef.UnWrap(browser),
                                                             source))
end;

procedure cef_focus_handler_on_got_focus(self    : POldCefFocusHandler;
                                         browser : POldCefBrowser); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefFocusHandlerOwn) then
    TOldCefFocusHandlerOwn(TempObject).OnGotFocus(TOldCefBrowserRef.UnWrap(browser));
end;

constructor TOldCefFocusHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefFocusHandler));

  with POldCefFocusHandler(FData)^ do
    begin
      on_take_focus := cef_focus_handler_on_take_focus;
      on_set_focus  := cef_focus_handler_on_set_focus;
      on_got_focus  := cef_focus_handler_on_got_focus;
    end;
end;

function TOldCefFocusHandlerOwn.OnSetFocus(const browser: IOldCefBrowser; source: TOldCefFocusSource): Boolean;
begin
  Result := False;
end;

procedure TOldCefFocusHandlerOwn.OnGotFocus(const browser: IOldCefBrowser);
begin
  //
end;

procedure TOldCefFocusHandlerOwn.OnTakeFocus(const browser: IOldCefBrowser; next: Boolean);
begin
  //
end;

procedure TOldCefFocusHandlerOwn.RemoveReferences;
begin
  //
end;

// TCustomFocusHandler

constructor TOldCustomFocusHandler.Create(const events: Pointer);
begin
  inherited Create;

  FEvents := events;
end;

destructor TOldCustomFocusHandler.Destroy;
begin
  RemoveReferences;

  inherited Destroy;
end;

procedure TOldCustomFocusHandler.RemoveReferences;
begin
  FEvents := nil;
end;

procedure TOldCustomFocusHandler.OnGotFocus(const browser: IOldCefBrowser);
begin
  if (FEvents <> nil) then IOldChromiumEvents(FEvents).doOnGotFocus(browser);
end;

function TOldCustomFocusHandler.OnSetFocus(const browser: IOldCefBrowser; source: TOldCefFocusSource): Boolean;
begin
  if (FEvents <> nil) then
    Result := IOldChromiumEvents(FEvents).doOnSetFocus(browser, source)
   else
    Result := inherited OnSetFocus(browser, source);
end;

procedure TOldCustomFocusHandler.OnTakeFocus(const browser: IOldCefBrowser; next: Boolean);
begin
  if (FEvents <> nil) then IOldChromiumEvents(FEvents).doOnTakeFocus(browser, next);
end;

end.

