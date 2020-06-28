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

unit oldCEFCookieManager;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
  System.Classes, System.SysUtils,
  {$ELSE}
  Classes, SysUtils,
  {$ENDIF}
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefCookieManagerRef = class(TOldCefBaseRef, IOldCefCookieManager)
    protected
      procedure SetSupportedSchemes(const schemes: TStrings; const callback: IOldCefCompletionCallback);
      procedure SetSupportedSchemesProc(const schemes: TStrings; const callback: TOldCefCompletionCallbackProc);
      function  VisitAllCookies(const visitor: IOldCefCookieVisitor): Boolean;
      function  VisitAllCookiesProc(const visitor: TOldCefCookieVisitorProc): Boolean;
      function  VisitUrlCookies(const url: oldustring; includeHttpOnly: Boolean; const visitor: IOldCefCookieVisitor): Boolean;
      function  VisitUrlCookiesProc(const url: oldustring; includeHttpOnly: Boolean; const visitor: TOldCefCookieVisitorProc): Boolean;
      function  SetCookie(const url: oldustring; const name, value, domain, path: oldustring; secure, httponly, hasExpires: Boolean; const creation, lastAccess, expires: TDateTime; const callback: IOldCefSetCookieCallback): Boolean;
      function  SetCookieProc(const url: oldustring; const name, value, domain, path: oldustring; secure, httponly, hasExpires: Boolean; const creation, lastAccess, expires: TDateTime; const callback: TOldCefSetCookieCallbackProc): Boolean;
      function  DeleteCookies(const url, cookieName: oldustring; const callback: IOldCefDeleteCookiesCallback): Boolean;
      function  DeleteCookiesProc(const url, cookieName: oldustring; const callback: TOldCefDeleteCookiesCallbackProc): Boolean;
      function  SetStoragePath(const path: oldustring; persistSessionCookies: Boolean; const callback: IOldCefCompletionCallback): Boolean;
      function  SetStoragePathProc(const path: oldustring; persistSessionCookies: Boolean; const callback: TOldCefCompletionCallbackProc): Boolean;
      function  FlushStore(const handler: IOldCefCompletionCallback): Boolean;
      function  FlushStoreProc(const proc: TOldCefCompletionCallbackProc): Boolean;

    public
      class function UnWrap(data: Pointer): IOldCefCookieManager;
      class function Global(const callback: IOldCefCompletionCallback): IOldCefCookieManager;
      class function GlobalProc(const callback: TOldCefCompletionCallbackProc): IOldCefCookieManager;
      class function New(const path: oldustring; persistSessionCookies: Boolean; const callback: IOldCefCompletionCallback): IOldCefCookieManager;
      class function NewProc(const path: oldustring; persistSessionCookies: Boolean; const callback: TOldCefCompletionCallbackProc): IOldCefCookieManager;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFCompletionCallback, oldCEFDeleteCookiesCallback,
  oldCEFSetCookieCallback, oldCEFCookieVisitor, oldCEFStringList;

class function TOldCefCookieManagerRef.New(const path                  : oldustring;
                                              persistSessionCookies : Boolean;
                                        const callback              : IOldCefCompletionCallback): IOldCefCookieManager;
var
  pth: TOldCefString;
begin
  pth := CefString(path);
  Result := UnWrap(cef_cookie_manager_create_manager(@pth, Ord(persistSessionCookies), CefGetData(callback)));
end;

class function TOldCefCookieManagerRef.NewProc(const path                  : oldustring;
                                                  persistSessionCookies : Boolean;
                                            const callback              : TOldCefCompletionCallbackProc): IOldCefCookieManager;
begin
  Result := New(path, persistSessionCookies, TOldCefFastCompletionCallback.Create(callback));
end;

function TOldCefCookieManagerRef.DeleteCookies(const url        : oldustring;
                                            const cookieName : oldustring;
                                            const callback   : IOldCefDeleteCookiesCallback): Boolean;
var
  u, n: TOldCefString;
begin
  u      := CefString(url);
  n      := CefString(cookieName);
  Result := POldCefCookieManager(FData).delete_cookies(POldCefCookieManager(FData), @u, @n, CefGetData(callback)) <> 0;
end;

function TOldCefCookieManagerRef.DeleteCookiesProc(const url        : oldustring;
                                                const cookieName : oldustring;
                                                const callback   : TOldCefDeleteCookiesCallbackProc): Boolean;
begin
  Result := DeleteCookies(url, cookieName, TOldCefFastDeleteCookiesCallback.Create(callback));
end;

function TOldCefCookieManagerRef.FlushStore(const handler: IOldCefCompletionCallback): Boolean;
begin
  Result := POldCefCookieManager(FData).flush_store(POldCefCookieManager(FData), CefGetData(handler)) <> 0;
end;

function TOldCefCookieManagerRef.FlushStoreProc(const proc: TOldCefCompletionCallbackProc): Boolean;
begin
  Result := FlushStore(TOldCefFastCompletionCallback.Create(proc))
end;

class function TOldCefCookieManagerRef.Global(const callback: IOldCefCompletionCallback): IOldCefCookieManager;
begin
  Result := UnWrap(cef_cookie_manager_get_global_manager(CefGetData(callback)));
end;

class function TOldCefCookieManagerRef.GlobalProc(const callback: TOldCefCompletionCallbackProc): IOldCefCookieManager;
begin
  Result := Global(TOldCefFastCompletionCallback.Create(callback));
end;

function TOldCefCookieManagerRef.SetCookie(const url, name, value, domain, path: oldustring;
                                              secure, httponly, hasExpires: Boolean;
                                        const creation, lastAccess, expires: TDateTime;
                                        const callback: IOldCefSetCookieCallback): Boolean;
var
  str  : TOldCefString;
  cook : TOldCefCookie;
begin
  str              := CefString(url);
  cook.name        := CefString(name);
  cook.value       := CefString(value);
  cook.domain      := CefString(domain);
  cook.path        := CefString(path);
  cook.secure      := Ord(secure);
  cook.httponly    := Ord(httponly);
  cook.creation    := DateTimeToCefTime(creation);
  cook.last_access := DateTimeToCefTime(lastAccess);
  cook.has_expires := Ord(hasExpires);

  if hasExpires then
    cook.expires := DateTimeToCefTime(expires)
   else
    FillChar(cook.expires, SizeOf(TOldCefTime), 0);

  Result := POldCefCookieManager(FData).set_cookie(POldCefCookieManager(FData), @str, @cook, CefGetData(callback)) <> 0;
end;

function TOldCefCookieManagerRef.SetCookieProc(const url, name, value, domain, path: oldustring;
                                                  secure, httponly, hasExpires: Boolean;
                                            const creation, lastAccess, expires: TDateTime;
                                            const callback: TOldCefSetCookieCallbackProc): Boolean;
begin
  Result := SetCookie(url, name, value, domain, path,
                      secure, httponly, hasExpires,
                      creation, lastAccess, expires,
                      TOldCefFastSetCookieCallback.Create(callback));
end;

function TOldCefCookieManagerRef.SetStoragePath(const path                  : oldustring;
                                                   persistSessionCookies : Boolean;
                                             const callback              : IOldCefCompletionCallback): Boolean;
var
  p: TOldCefString;
begin
  p      := CefString(path);
  Result := POldCefCookieManager(FData)^.set_storage_path(POldCefCookieManager(FData), @p, Ord(persistSessionCookies), CefGetData(callback)) <> 0;
end;

function TOldCefCookieManagerRef.SetStoragePathProc(const path                  : oldustring;
                                                       persistSessionCookies : Boolean;
                                                 const callback              : TOldCefCompletionCallbackProc): Boolean;
begin
  Result := SetStoragePath(path, persistSessionCookies, TOldCefFastCompletionCallback.Create(callback));
end;

procedure TOldCefCookieManagerRef.SetSupportedSchemes(const schemes: TStrings; const callback: IOldCefCompletionCallback);
var
  TempSL : IOldCefStringList;
begin
  try
    TempSL := TOldCefStringListOwn.Create;
    TempSL.AddStrings(schemes);

    POldCefCookieManager(FData).set_supported_schemes(POldCefCookieManager(FData),
                                                   TempSL.Handle,
                                                   CefGetData(callback));
  finally
    TempSL := nil;
  end;
end;

procedure TOldCefCookieManagerRef.SetSupportedSchemesProc(const schemes: TStrings; const callback: TOldCefCompletionCallbackProc);
begin
  SetSupportedSchemes(schemes, TOldCefFastCompletionCallback.Create(callback));
end;

class function TOldCefCookieManagerRef.UnWrap(data: Pointer): IOldCefCookieManager;
begin
  if (data <> nil) then
    Result := Create(data) as IOldCefCookieManager
   else
    Result := nil;
end;

function TOldCefCookieManagerRef.VisitAllCookies(const visitor: IOldCefCookieVisitor): Boolean;
begin
  Result := POldCefCookieManager(FData).visit_all_cookies(POldCefCookieManager(FData), CefGetData(visitor)) <> 0;
end;

function TOldCefCookieManagerRef.VisitAllCookiesProc(const visitor: TOldCefCookieVisitorProc): Boolean;
begin
  Result := VisitAllCookies(TOldCefFastCookieVisitor.Create(visitor) as IOldCefCookieVisitor);
end;

function TOldCefCookieManagerRef.VisitUrlCookies(const url             : oldustring;
                                                    includeHttpOnly : Boolean;
                                              const visitor         : IOldCefCookieVisitor): Boolean;
var
  str : TOldCefString;
begin
  str    := CefString(url);
  Result := POldCefCookieManager(FData).visit_url_cookies(POldCefCookieManager(FData), @str, Ord(includeHttpOnly), CefGetData(visitor)) <> 0;
end;

function TOldCefCookieManagerRef.VisitUrlCookiesProc(const url             : oldustring;
                                                        includeHttpOnly : Boolean;
                                                  const visitor         : TOldCefCookieVisitorProc): Boolean;
begin
  Result := VisitUrlCookies(url, includeHttpOnly, TOldCefFastCookieVisitor.Create(visitor) as IOldCefCookieVisitor);
end;

end.
