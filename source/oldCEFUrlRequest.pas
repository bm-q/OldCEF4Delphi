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

unit oldCEFUrlRequest;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefUrlRequestRef = class(TOldCefBaseRef, IOldCefUrlRequest)
  protected
    function  GetRequest: IOldCefRequest;
    function  GetRequestStatus: TOldCefUrlRequestStatus;
    function  GetRequestError: Integer;
    function  GetResponse: IOldCefResponse;
    procedure Cancel;

  public
    class function UnWrap(data: Pointer): IOldCefUrlRequest;
    class function New(const request: IOldCefRequest; const client: IOldCefUrlrequestClient; const requestContext: IOldCefRequestContext): IOldCefUrlRequest;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFRequest, oldCEFResponse;

procedure TOldCefUrlRequestRef.Cancel;
begin
  POldCefUrlRequest(FData).cancel(POldCefUrlRequest(FData));
end;

class function TOldCefUrlRequestRef.New(const request        : IOldCefRequest;
                                     const client         : IOldCefUrlrequestClient;
                                     const requestContext : IOldCefRequestContext): IOldCefUrlRequest;
begin
  Result := UnWrap(cef_urlrequest_create(CefGetData(request), CefGetData(client), CefGetData(requestContext)));
end;

function TOldCefUrlRequestRef.GetRequest: IOldCefRequest;
begin
  Result := TOldCefRequestRef.UnWrap(POldCefUrlRequest(FData).get_request(POldCefUrlRequest(FData)));
end;

function TOldCefUrlRequestRef.GetRequestError: Integer;
begin
  Result := POldCefUrlRequest(FData).get_request_error(POldCefUrlRequest(FData));
end;

function TOldCefUrlRequestRef.GetRequestStatus: TOldCefUrlRequestStatus;
begin
  Result := POldCefUrlRequest(FData).get_request_status(POldCefUrlRequest(FData));
end;

function TOldCefUrlRequestRef.GetResponse: IOldCefResponse;
begin
  Result := TOldCefResponseRef.UnWrap(POldCefUrlRequest(FData).get_response(POldCefUrlRequest(FData)));
end;

class function TOldCefUrlRequestRef.UnWrap(data: Pointer): IOldCefUrlRequest;
begin
  if (data <> nil) then
    Result := Create(data) as IOldCefUrlRequest
   else
    Result := nil;
end;

end.
