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

unit oldCEFGeolocationHandler;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefGeolocationHandlerOwn = class(TOldCefBaseOwn, IOldCefGeolocationHandler)
    protected
      function  OnRequestGeolocationPermission(const browser: IOldCefBrowser; const requestingUrl: oldustring; requestId: Integer; const callback: IOldCefGeolocationCallback): Boolean; virtual;
      procedure OnCancelGeolocationPermission(const browser: IOldCefBrowser; requestId: Integer); virtual;

      procedure RemoveReferences; virtual;

    public
      constructor Create; virtual;
  end;

  TOldCustomGeolocationHandler = class(TOldCefGeolocationHandlerOwn)
    protected
      FEvents : Pointer;

      function  OnRequestGeolocationPermission(const browser: IOldCefBrowser; const requestingUrl: oldustring; requestId: Integer; const callback: IOldCefGeolocationCallback): Boolean; override;
      procedure OnCancelGeolocationPermission(const browser: IOldCefBrowser; requestId: Integer); override;

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
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFBrowser, oldCEFGeolocationCallback;

function cef_geolocation_handler_on_request_geolocation_permission(self: POldCefGeolocationHandler;
  browser: POldCefBrowser; const requesting_url: POldCefString; request_id: Integer;
  callback: POldCefGeolocationCallback): Integer; stdcall;
begin
  with TOldCefGeolocationHandlerOwn(CefGetObject(self)) do
    Result := Ord(OnRequestGeolocationPermission(TOldCefBrowserRef.UnWrap(browser), CefString(requesting_url),
      request_id, TOldCefGeolocationCallbackRef.UnWrap(callback)));
end;

procedure cef_geolocation_handler_on_cancel_geolocation_permission(self: POldCefGeolocationHandler;
  browser: POldCefBrowser; request_id: Integer); stdcall;
begin
  with TOldCefGeolocationHandlerOwn(CefGetObject(self)) do
    OnCancelGeolocationPermission(TOldCefBrowserRef.UnWrap(browser), request_id);
end;

// TOldCefGeolocationHandlerOwn

constructor TOldCefGeolocationHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefGeolocationHandler));

  with POldCefGeolocationHandler(FData)^ do
    begin
      on_request_geolocation_permission := cef_geolocation_handler_on_request_geolocation_permission;
      on_cancel_geolocation_permission  := cef_geolocation_handler_on_cancel_geolocation_permission;
    end;
end;


function TOldCefGeolocationHandlerOwn.OnRequestGeolocationPermission(
  const browser: IOldCefBrowser; const requestingUrl: oldustring; requestId: Integer;
  const callback: IOldCefGeolocationCallback): Boolean;
begin
  Result := False;
end;

procedure TOldCefGeolocationHandlerOwn.OnCancelGeolocationPermission(const browser: IOldCefBrowser; requestId: Integer);
begin

end;

procedure TOldCefGeolocationHandlerOwn.RemoveReferences;
begin
  //
end;

// TCustomGeolocationHandler

constructor TOldCustomGeolocationHandler.Create(const events: Pointer);
begin
  inherited Create;

  FEvents := events;
end;

destructor TOldCustomGeolocationHandler.Destroy;
begin
  RemoveReferences;

  inherited Destroy;
end;

procedure TOldCustomGeolocationHandler.RemoveReferences;
begin
  FEvents := nil;
end;

procedure TOldCustomGeolocationHandler.OnCancelGeolocationPermission(const browser: IOldCefBrowser; requestId: Integer);
begin
  if (FEvents <> nil) then IOldChromiumEvents(FEvents).doOnCancelGeolocationPermission(browser, requestId);
end;

function TOldCustomGeolocationHandler.OnRequestGeolocationPermission(const browser       : IOldCefBrowser;
                                                                  const requestingUrl : oldustring;
                                                                        requestId     : Integer;
                                                                  const callback      : IOldCefGeolocationCallback): Boolean;
begin
  if (FEvents <> nil) then
    Result := IOldChromiumEvents(FEvents).doOnRequestGeolocationPermission(browser, requestingUrl, requestId, callback)
   else
    Result := inherited OnRequestGeolocationPermission(browser, requestingUrl, requestId, callback);
end;

end.
