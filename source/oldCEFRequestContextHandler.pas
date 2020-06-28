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

unit oldCEFRequestContextHandler;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefRequestContextHandlerProc = {$IFDEF DELPHI12_UP}reference to{$ENDIF} function: IOldCefCookieManager;

  TOldCefRequestContextHandlerRef = class(TOldCefBaseRef, IOldCefRequestContextHandler)
    protected
      function  GetCookieManager: IOldCefCookieManager;
      function  OnBeforePluginLoad(const mimeType, pluginUrl: oldustring; const topOriginUrl: oldustring; const pluginInfo: IOldCefWebPluginInfo; pluginPolicy: POldCefPluginPolicy): Boolean;

    public
      class function UnWrap(data: Pointer): IOldCefRequestContextHandler;
  end;

  TOldCefRequestContextHandlerOwn = class(TOldCefBaseOwn, IOldCefRequestContextHandler)
    protected
      function  GetCookieManager: IOldCefCookieManager; virtual;
      function  OnBeforePluginLoad(const mimeType, pluginUrl: oldustring; const topOriginUrl: oldustring; const pluginInfo: IOldCefWebPluginInfo; pluginPolicy: POldCefPluginPolicy): Boolean; virtual;

    public
      constructor Create; virtual;
  end;

  TOldCefFastRequestContextHandler = class(TOldCefRequestContextHandlerOwn)
    protected
      FProc: TOldCefRequestContextHandlerProc;

      function GetCookieManager: IOldCefCookieManager; override;

    public
      constructor Create(const proc: TOldCefRequestContextHandlerProc); reintroduce;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFCookieManager, oldCEFWebPluginInfo, oldCEFRequestContext;

// TOldCefRequestContextHandlerOwn

function cef_request_context_handler_get_cookie_manager(self: POldCefRequestContextHandler): POldCefCookieManager; stdcall;
var
  TempObject : TObject;
begin
  Result     := nil;
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRequestContextHandlerOwn) then
    Result := CefGetData(TOldCefRequestContextHandlerOwn(TempObject).GetCookieManager());
end;

function cef_request_context_handler_on_before_plugin_load(      self           : POldCefRequestContextHandler;
                                                           const mime_type      : POldCefString;
                                                           const plugin_url     : POldCefString;
                                                           const top_origin_url : POldCefString;
                                                                 plugin_info    : POldCefWebPluginInfo;
                                                                 plugin_policy  : POldCefPluginPolicy): Integer; stdcall;
var
  TempObject : TObject;
begin
  Result     := Ord(False);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRequestContextHandlerOwn) then
    Result := Ord(TOldCefRequestContextHandlerOwn(TempObject).OnBeforePluginLoad(CefString(mime_type),
                                                                              CefString(plugin_url),
                                                                              CefString(top_origin_url),
                                                                              TOldCefWebPluginInfoRef.UnWrap(plugin_info),
                                                                              plugin_policy));
end;

constructor TOldCefRequestContextHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefRequestContextHandler));

  with POldCefRequestContextHandler(FData)^ do
    begin
      get_cookie_manager             := cef_request_context_handler_get_cookie_manager;
      on_before_plugin_load          := cef_request_context_handler_on_before_plugin_load;
    end;
end;

function TOldCefRequestContextHandlerOwn.GetCookieManager: IOldCefCookieManager;
begin
  Result:= nil;
end;

function TOldCefRequestContextHandlerOwn.OnBeforePluginLoad(const mimeType, pluginUrl : oldustring;
                                                         const topOriginUrl: oldustring;
                                                         const pluginInfo: IOldCefWebPluginInfo;
                                                               pluginPolicy: POldCefPluginPolicy): Boolean;
begin
  Result := False;
end;

// TOldCefRequestContextHandlerRef

function TOldCefRequestContextHandlerRef.GetCookieManager: IOldCefCookieManager;
begin
  Result := TOldCefCookieManagerRef.UnWrap(POldCefRequestContextHandler(FData).get_cookie_manager(FData));
end;

function TOldCefRequestContextHandlerRef.OnBeforePluginLoad(const mimeType, pluginUrl : oldustring;
                                                         const topOriginUrl: oldustring;
                                                         const pluginInfo: IOldCefWebPluginInfo;
                                                               pluginPolicy: POldCefPluginPolicy): Boolean;
var
  mt, pu, ou: TOldCefString;
begin
  mt := CefString(mimeType);
  pu := CefString(pluginUrl);
  ou := CefString(topOriginUrl);

  Result := POldCefRequestContextHandler(FData).on_before_plugin_load(FData, @mt, @pu, @ou, CefGetData(pluginInfo), pluginPolicy) <> 0;
end;

class function TOldCefRequestContextHandlerRef.UnWrap(data: Pointer): IOldCefRequestContextHandler;
begin
  if (data <> nil) then
    Result := Create(data) as IOldCefRequestContextHandler
   else
    Result := nil;
end;

// TOldCefFastRequestContextHandler

constructor TOldCefFastRequestContextHandler.Create(const proc: TOldCefRequestContextHandlerProc);
begin
  FProc := proc;

  inherited Create;
end;

function TOldCefFastRequestContextHandler.GetCookieManager: IOldCefCookieManager;
begin
  Result := FProc();
end;

end.
