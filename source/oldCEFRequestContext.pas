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

unit oldCEFRequestContext;

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
  TOldCefRequestContextRef = class(TOldCefBaseRef, IOldCefRequestContext)
    protected
      function  IsSame(const other: IOldCefRequestContext): Boolean;
      function  IsSharingWith(const other: IOldCefRequestContext): Boolean;
      function  IsGlobal: Boolean;
      function  GetHandler: IOldCefRequestContextHandler;
      function  GetCachePath: oldustring;
      function  GetDefaultCookieManager(const callback: IOldCefCompletionCallback): IOldCefCookieManager;
      function  GetDefaultCookieManagerProc(const callback: TOldCefCompletionCallbackProc): IOldCefCookieManager;
      function  RegisterSchemeHandlerFactory(const schemeName, domainName: oldustring; const factory: IOldCefSchemeHandlerFactory): Boolean;
      function  ClearSchemeHandlerFactories: Boolean;
      procedure PurgePluginListCache(reloadPages: Boolean);
      function  HasPreference(const name: oldustring): Boolean;
      function  GetPreference(const name: oldustring): IOldCefValue;
      function  GetAllPreferences(includeDefaults: Boolean): IOldCefDictionaryValue;
      function  CanSetPreference(const name: oldustring): Boolean;
      function  SetPreference(const name: oldustring; const value: IOldCefValue; out error: oldustring): Boolean;
      procedure ClearCertificateExceptions(const callback: IOldCefCompletionCallback);
      procedure CloseAllConnections(const callback: IOldCefCompletionCallback);
      procedure ResolveHost(const origin: oldustring; const callback: IOldCefResolveCallback);
      function  ResolveHostCached(const origin: oldustring; const resolvedIps: TStrings): TOldCefErrorCode;

    public
      class function UnWrap(data: Pointer): IOldCefRequestContext;
      class function Global: IOldCefRequestContext;
      class function New(const settings: POldCefRequestContextSettings; const handler: IOldCefRequestContextHandler = nil): IOldCefRequestContext; overload;
      class function New(const aCache, aAcceptLanguageList : oldustring; aPersistSessionCookies, aPersistUserPreferences, aIgnoreCertificateErrors : boolean; const handler: IOldCefRequestContextHandler = nil): IOldCefRequestContext; overload;
      class function Shared(const other: IOldCefRequestContext; const handler: IOldCefRequestContextHandler): IOldCefRequestContext;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFValue, oldCEFDictionaryValue, oldCEFCookieManager,
  oldCEFCompletionCallback, oldCEFRequestContextHandler, oldCEFStringList;

function TOldCefRequestContextRef.ClearSchemeHandlerFactories: Boolean;
begin
  Result := POldCefRequestContext(FData).clear_scheme_handler_factories(FData) <> 0;
end;

function TOldCefRequestContextRef.GetCachePath: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefRequestContext(FData).get_cache_path(FData));
end;

function TOldCefRequestContextRef.GetDefaultCookieManager(const callback: IOldCefCompletionCallback): IOldCefCookieManager;
begin
  Result := TOldCefCookieManagerRef.UnWrap(POldCefRequestContext(FData).get_default_cookie_manager(FData, CefGetData(callback)));
end;

function TOldCefRequestContextRef.GetDefaultCookieManagerProc(const callback: TOldCefCompletionCallbackProc): IOldCefCookieManager;
begin
  Result := GetDefaultCookieManager(TOldCefFastCompletionCallback.Create(callback));
end;

function TOldCefRequestContextRef.GetHandler: IOldCefRequestContextHandler;
begin
  Result := TOldCefRequestContextHandlerRef.UnWrap(POldCefRequestContext(FData).get_handler(FData));
end;

class function TOldCefRequestContextRef.Global: IOldCefRequestContext;
begin
  Result := UnWrap(cef_request_context_get_global_context());
end;

function TOldCefRequestContextRef.IsGlobal: Boolean;
begin
  Result := POldCefRequestContext(FData).is_global(FData) <> 0;
end;

function TOldCefRequestContextRef.IsSame(const other: IOldCefRequestContext): Boolean;
begin
  Result := POldCefRequestContext(FData).is_same(FData, CefGetData(other)) <> 0;
end;

function TOldCefRequestContextRef.IsSharingWith(const other: IOldCefRequestContext): Boolean;
begin
  Result := POldCefRequestContext(FData).is_sharing_with(FData, CefGetData(other)) <> 0;
end;

class function TOldCefRequestContextRef.New(const settings : POldCefRequestContextSettings;
                                         const handler  : IOldCefRequestContextHandler): IOldCefRequestContext;
begin
  Result := UnWrap(cef_request_context_create_context(settings, CefGetData(handler)));
end;

class function TOldCefRequestContextRef.New(const aCache                       : oldustring;
                                         const aAcceptLanguageList          : oldustring;
                                               aPersistSessionCookies       : boolean;
                                               aPersistUserPreferences      : boolean;
                                               aIgnoreCertificateErrors     : boolean;
                                         const handler                      : IOldCefRequestContextHandler): IOldCefRequestContext;
var
  TempSettings : TOldCefRequestContextSettings;
begin
  TempSettings.size                           := SizeOf(TOldCefRequestContextSettings);
  TempSettings.cache_path                     := CefString(aCache);
  TempSettings.persist_session_cookies        := Ord(aPersistSessionCookies);
  TempSettings.persist_user_preferences       := Ord(aPersistUserPreferences);
  TempSettings.ignore_certificate_errors      := Ord(aIgnoreCertificateErrors);
  TempSettings.accept_language_list           := CefString(aAcceptLanguageList);

  Result := UnWrap(cef_request_context_create_context(@TempSettings, CefGetData(handler)));
end;

procedure TOldCefRequestContextRef.PurgePluginListCache(reloadPages: Boolean);
begin
  POldCefRequestContext(FData).purge_plugin_list_cache(FData, Ord(reloadPages));
end;

function TOldCefRequestContextRef.HasPreference(const name: oldustring): Boolean;
var
  n : TOldCefString;
begin
  n      := CefString(name);
  Result := POldCefRequestContext(FData).has_preference(FData, @n) <> 0;
end;

function TOldCefRequestContextRef.GetPreference(const name: oldustring): IOldCefValue;
var
  n : TOldCefString;
begin
  n      := CefString(name);
  Result :=  TOldCefValueRef.UnWrap(POldCefRequestContext(FData).get_preference(FData, @n));
end;

function TOldCefRequestContextRef.GetAllPreferences(includeDefaults: Boolean): IOldCefDictionaryValue;
begin
  Result := TOldCefDictionaryValueRef.UnWrap(POldCefRequestContext(FData).get_all_preferences(FData, Ord(includeDefaults)));
end;

function TOldCefRequestContextRef.CanSetPreference(const name: oldustring): Boolean;
var
  n: TOldCefString;
begin
  n      := CefString(name);
  Result := POldCefRequestContext(FData).can_set_preference(FData, @n) <> 0;
end;

function TOldCefRequestContextRef.SetPreference(const name  : oldustring;
                                             const value : IOldCefValue;
                                             out   error : oldustring): Boolean;
var
  n, e: TOldCefString;
begin
  n := CefString(name);
  FillChar(e, SizeOf(e), 0);
  Result := POldCefRequestContext(FData).set_preference(FData, @n, CefGetData(value), @e) <> 0;
  error  := CefString(@e);
end;

procedure TOldCefRequestContextRef.ClearCertificateExceptions(const callback: IOldCefCompletionCallback);
begin
  POldCefRequestContext(FData).clear_certificate_exceptions(FData, CefGetData(callback));
end;

procedure TOldCefRequestContextRef.CloseAllConnections(const callback: IOldCefCompletionCallback);
begin
  POldCefRequestContext(FData).close_all_connections(FData, CefGetData(callback));
end;

procedure TOldCefRequestContextRef.ResolveHost(const origin   : oldustring;
                                            const callback : IOldCefResolveCallback);
var
  o: TOldCefString;
begin
  o := CefString(origin);
  POldCefRequestContext(FData).resolve_host(FData, @o, CefGetData(callback));
end;

function TOldCefRequestContextRef.ResolveHostCached(const origin      : oldustring;
                                                 const resolvedIps : TStrings): TOldCefErrorCode;
var
  TempSL     : IOldCefStringList;
  TempOrigin : TOldCefString;
begin
  TempSL     := TOldCefStringListOwn.Create;
  TempOrigin := CefString(origin);
  Result     := POldCefRequestContext(FData).resolve_host_cached(FData, @TempOrigin, TempSL.Handle);
  TempSL.CopyToStrings(resolvedIps);
end;

function TOldCefRequestContextRef.RegisterSchemeHandlerFactory(const schemeName : oldustring;
                                                            const domainName : oldustring;
                                                            const factory    : IOldCefSchemeHandlerFactory): Boolean;
var
  s, d: TOldCefString;
begin
  s      := CefString(schemeName);
  d      := CefString(domainName);
  Result := POldCefRequestContext(FData).register_scheme_handler_factory(FData, @s, @d, CefGetData(factory)) <> 0;
end;

class function TOldCefRequestContextRef.Shared(const other   : IOldCefRequestContext;
                                            const handler : IOldCefRequestContextHandler): IOldCefRequestContext;
begin
  Result := UnWrap(create_context_shared(CefGetData(other), CefGetData(handler)));
end;

class function TOldCefRequestContextRef.UnWrap(data: Pointer): IOldCefRequestContext;
begin
  if (data <> nil) then
    Result := Create(data) as IOldCefRequestContext
   else
    Result := nil;
end;

end.
