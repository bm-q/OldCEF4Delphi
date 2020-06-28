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

unit oldCEFResponse;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefResponseRef = class(TOldCefBaseRef, IOldCefResponse)
  protected
    function IsReadOnly: Boolean;
    function GetStatus: Integer;
    procedure SetStatus(status: Integer);
    function GetStatusText: oldustring;
    procedure SetStatusText(const StatusText: oldustring);
    function GetMimeType: oldustring;
    procedure SetMimeType(const mimetype: oldustring);
    function GetHeader(const name: oldustring): oldustring;
    procedure GetHeaderMap(const headerMap: IOldCefStringMultimap);
    procedure SetHeaderMap(const headerMap: IOldCefStringMultimap);
  public
    class function UnWrap(data: Pointer): IOldCefResponse;
    class function New: IOldCefResponse;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions;


class function TOldCefResponseRef.New: IOldCefResponse;
begin
  Result := UnWrap(cef_response_create);
end;

function TOldCefResponseRef.GetHeader(const name: oldustring): oldustring;
var
  n: TOldCefString;
begin
  n := CefString(name);
  Result := CefStringFreeAndGet(POldCefResponse(FData)^.get_header(POldCefResponse(FData), @n));
end;

procedure TOldCefResponseRef.GetHeaderMap(const headerMap: IOldCefStringMultimap);
begin
  POldCefResponse(FData)^.get_header_map(POldCefResponse(FData), headermap.Handle);
end;

function TOldCefResponseRef.GetMimeType: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefResponse(FData)^.get_mime_type(POldCefResponse(FData)));
end;

function TOldCefResponseRef.GetStatus: Integer;
begin
  Result := POldCefResponse(FData)^.get_status(POldCefResponse(FData));
end;

function TOldCefResponseRef.GetStatusText: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefResponse(FData)^.get_status_text(POldCefResponse(FData)));
end;

function TOldCefResponseRef.IsReadOnly: Boolean;
begin
  Result := POldCefResponse(FData)^.is_read_only(POldCefResponse(FData)) <> 0;
end;

procedure TOldCefResponseRef.SetHeaderMap(const headerMap: IOldCefStringMultimap);
begin
  POldCefResponse(FData)^.set_header_map(POldCefResponse(FData), headerMap.Handle);
end;

procedure TOldCefResponseRef.SetMimeType(const mimetype: oldustring);
var
  txt: TOldCefString;
begin
  txt := CefString(mimetype);
  POldCefResponse(FData)^.set_mime_type(POldCefResponse(FData), @txt);
end;

procedure TOldCefResponseRef.SetStatus(status: Integer);
begin
  POldCefResponse(FData)^.set_status(POldCefResponse(FData), status);
end;

procedure TOldCefResponseRef.SetStatusText(const StatusText: oldustring);
var
  txt: TOldCefString;
begin
  txt := CefString(StatusText);
  POldCefResponse(FData)^.set_status_text(POldCefResponse(FData), @txt);
end;

class function TOldCefResponseRef.UnWrap(data: Pointer): IOldCefResponse;
begin
  if data <> nil then
    Result := Create(data) as IOldCefResponse else
    Result := nil;
end;

end.
