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

unit oldCEFCookieVisitor;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefCookieVisitorOwn = class(TOldCefBaseOwn, IOldCefCookieVisitor)
    protected
      function visit(const name, value, domain, path: oldustring; secure, httponly, hasExpires: Boolean; const creation, lastAccess, expires: TDateTime; count, total: Integer; out deleteCookie: Boolean): Boolean; virtual;

    public
      constructor Create; virtual;
  end;

  TOldCefFastCookieVisitor = class(TOldCefCookieVisitorOwn)
    protected
      FVisitor: TOldCefCookieVisitorProc;

      function visit(const name, value, domain, path: oldustring; secure, httponly, hasExpires: Boolean; const creation, lastAccess, expires: TDateTime; count, total: Integer; out deleteCookie: Boolean): Boolean; override;

    public
      constructor Create(const visitor: TOldCefCookieVisitorProc); reintroduce;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions;

function cef_cookie_visitor_visit(self: POldCefCookieVisitor;
                                  const cookie: POldCefCookie;
                                  count, total: Integer;
                                  deleteCookie: PInteger): Integer; stdcall;
var
  delete     : Boolean;
  exp        : TDateTime;
  TempObject : TObject;
begin
  delete     := False;
  Result     := Ord(True);
  TempObject := CefGetObject(self);

  if (cookie.has_expires <> 0) then
    exp := CefTimeToDateTime(cookie.expires)
   else
    exp := 0;

  if (TempObject <> nil) and (TempObject is TOldCefCookieVisitorOwn) then
    Result := Ord(TOldCefCookieVisitorOwn(TempObject).visit(CefString(@cookie.name),
                                                         CefString(@cookie.value),
                                                         CefString(@cookie.domain),
                                                         CefString(@cookie.path),
                                                         Boolean(cookie.secure),
                                                         Boolean(cookie.httponly),
                                                         Boolean(cookie.has_expires),
                                                         CefTimeToDateTime(cookie.creation),
                                                         CefTimeToDateTime(cookie.last_access),
                                                         exp,
                                                         count,
                                                         total,
                                                         delete));

  deleteCookie^ := Ord(delete);
end;

// TOldCefCookieVisitorOwn

constructor TOldCefCookieVisitorOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefCookieVisitor));

  POldCefCookieVisitor(FData)^.visit := cef_cookie_visitor_visit;
end;

function TOldCefCookieVisitorOwn.visit(const name, value, domain, path: oldustring;
                                    secure, httponly, hasExpires: Boolean;
                                    const creation, lastAccess, expires: TDateTime;
                                    count, total: Integer;
                                    out deleteCookie: Boolean): Boolean;
begin
  Result := True;
end;

// TOldCefFastCookieVisitor

constructor TOldCefFastCookieVisitor.Create(const visitor: TOldCefCookieVisitorProc);
begin
  inherited Create;

  FVisitor := visitor;
end;

function TOldCefFastCookieVisitor.visit(const name, value, domain, path: oldustring;
                                     secure, httponly, hasExpires: Boolean;
                                     const creation, lastAccess, expires: TDateTime;
                                     count, total: Integer;
                                     out deleteCookie: Boolean): Boolean;
begin
  Result := FVisitor(name, value, domain, path, secure, httponly, hasExpires,
                     creation, lastAccess, expires, count, total, deleteCookie);
end;



end.
