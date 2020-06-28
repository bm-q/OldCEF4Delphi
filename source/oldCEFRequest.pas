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

unit oldCEFRequest;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefRequestRef = class(TOldCefBaseRef, IOldCefRequest)
  protected
    function IsReadOnly: Boolean;
    function GetUrl: oldustring;
    function GetMethod: oldustring;
    function GetPostData: IOldCefPostData;
    procedure GetHeaderMap(const HeaderMap: IOldCefStringMultimap);
    procedure SetUrl(const value: oldustring);
    procedure SetMethod(const value: oldustring);
    procedure SetReferrer(const referrerUrl: oldustring; policy: TOldCefReferrerPolicy);
    function GetReferrerUrl: oldustring;
    function GetReferrerPolicy: TOldCefReferrerPolicy;
    procedure SetPostData(const value: IOldCefPostData);
    procedure SetHeaderMap(const HeaderMap: IOldCefStringMultimap);
    function GetFlags: TOldCefUrlRequestFlags;
    procedure SetFlags(flags: TOldCefUrlRequestFlags);
    function GetFirstPartyForCookies: oldustring;
    procedure SetFirstPartyForCookies(const url: oldustring);
    procedure Assign(const url, method: oldustring; const postData: IOldCefPostData; const headerMap: IOldCefStringMultimap);
    function GetResourceType: TOldCefResourceType;
    function GetTransitionType: TOldCefTransitionType;
    function GetIdentifier: UInt64;
  public
    class function UnWrap(data: Pointer): IOldCefRequest;
    class function New: IOldCefRequest;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFPostData;

function TOldCefRequestRef.IsReadOnly: Boolean;
begin
  Result := POldCefRequest(FData).is_read_only(POldCefRequest(FData)) <> 0;
end;

procedure TOldCefRequestRef.Assign(const url, method: oldustring; const postData: IOldCefPostData; const headerMap: IOldCefStringMultimap);
var
  u, m: TOldCefString;
begin
  u := cefstring(url);
  m := cefstring(method);
  POldCefRequest(FData).set_(POldCefRequest(FData), @u, @m, CefGetData(postData), headerMap.Handle);
end;

function TOldCefRequestRef.GetFirstPartyForCookies: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefRequest(FData).get_first_party_for_cookies(POldCefRequest(FData)));
end;

function TOldCefRequestRef.GetFlags: TOldCefUrlRequestFlags;
begin
  Result := POldCefRequest(FData)^.get_flags(POldCefRequest(FData));
end;

procedure TOldCefRequestRef.GetHeaderMap(const HeaderMap: IOldCefStringMultimap);
begin
  POldCefRequest(FData)^.get_header_map(POldCefRequest(FData), HeaderMap.Handle);
end;

function TOldCefRequestRef.GetIdentifier: UInt64;
begin
  Result := POldCefRequest(FData)^.get_identifier(POldCefRequest(FData));
end;

function TOldCefRequestRef.GetMethod: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefRequest(FData)^.get_method(POldCefRequest(FData)))
end;

function TOldCefRequestRef.GetPostData: IOldCefPostData;
begin
  Result := TOldCefPostDataRef.UnWrap(POldCefRequest(FData)^.get_post_data(POldCefRequest(FData)));
end;

function TOldCefRequestRef.GetResourceType: TOldCefResourceType;
begin
  Result := POldCefRequest(FData).get_resource_type(FData);
end;

function TOldCefRequestRef.GetTransitionType: TOldCefTransitionType;
begin
    Result := POldCefRequest(FData).get_transition_type(FData);
end;

function TOldCefRequestRef.GetUrl: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefRequest(FData)^.get_url(POldCefRequest(FData)))
end;

class function TOldCefRequestRef.New: IOldCefRequest;
begin
  Result := UnWrap(cef_request_create);
end;

procedure TOldCefRequestRef.SetFirstPartyForCookies(const url: oldustring);
var
  str: TOldCefString;
begin
  str := CefString(url);
  POldCefRequest(FData).set_first_party_for_cookies(POldCefRequest(FData), @str);
end;

procedure TOldCefRequestRef.SetFlags(flags: TOldCefUrlRequestFlags);
begin
  POldCefRequest(FData)^.set_flags(POldCefRequest(FData), PByte(@flags)^);
end;

procedure TOldCefRequestRef.SetHeaderMap(const HeaderMap: IOldCefStringMultimap);
begin
  POldCefRequest(FData)^.set_header_map(POldCefRequest(FData), HeaderMap.Handle);
end;

procedure TOldCefRequestRef.SetMethod(const value: oldustring);
var
  v: TOldCefString;
begin
  v := CefString(value);
  POldCefRequest(FData)^.set_method(POldCefRequest(FData), @v);
end;

procedure TOldCefRequestRef.SetReferrer(const referrerUrl: oldustring; policy: TOldCefReferrerPolicy);
var
  u: TOldCefString;
begin
  u := CefString(referrerUrl);
  POldCefRequest(FData)^.set_referrer(POldCefRequest(FData), @u, policy);
end;

function TOldCefRequestRef.GetReferrerUrl: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefRequest(FData)^.get_referrer_url(POldCefRequest(FData)));
end;

function TOldCefRequestRef.GetReferrerPolicy: TOldCefReferrerPolicy;
begin
  Result := POldCefRequest(FData)^.get_referrer_policy(POldCefRequest(FData));
end;

procedure TOldCefRequestRef.SetPostData(const value: IOldCefPostData);
begin
  if value <> nil then
    POldCefRequest(FData)^.set_post_data(POldCefRequest(FData), CefGetData(value));
end;

procedure TOldCefRequestRef.SetUrl(const value: oldustring);
var
  v: TOldCefString;
begin
  v := CefString(value);
  POldCefRequest(FData)^.set_url(POldCefRequest(FData), @v);
end;

class function TOldCefRequestRef.UnWrap(data: Pointer): IOldCefRequest;
begin
  if data <> nil then
    Result := Create(data) as IOldCefRequest else
    Result := nil;
end;


end.
