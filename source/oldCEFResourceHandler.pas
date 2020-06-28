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

unit oldCEFResourceHandler;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefResourceHandlerOwn = class(TOldCefBaseOwn, IOldCefResourceHandler)
    protected
      function  ProcessRequest(const request: IOldCefRequest; const callback: IOldCefCallback): Boolean; virtual;
      procedure GetResponseHeaders(const response: IOldCefResponse; out responseLength: Int64; out redirectUrl: oldustring); virtual;
      function  ReadResponse(const dataOut: Pointer; bytesToRead: Integer; var bytesRead: Integer; const callback: IOldCefCallback): Boolean; virtual;
      function  CanGetCookie(const cookie: POldCefCookie): Boolean; virtual;
      function  CanSetCookie(const cookie: POldCefCookie): Boolean; virtual;
      procedure Cancel; virtual;

    public
      constructor Create(const browser: IOldCefBrowser; const frame: IOldCefFrame; const schemeName: oldustring; const request: IOldCefRequest); virtual;
  end;

  TOldCefResourceHandlerClass = class of TOldCefResourceHandlerOwn;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFCallback, oldCEFRequest, oldCEFResponse;

function cef_resource_handler_process_request(self     : POldCefResourceHandler;
                                              request  : POldCefRequest;
                                              callback : POldCefCallback): Integer; stdcall;
var
  TempObject : TObject;
begin
  Result     := Ord(False);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefResourceHandlerOwn) then
    Result := Ord(TOldCefResourceHandlerOwn(TempObject).ProcessRequest(TOldCefRequestRef.UnWrap(request),
                                                                    TOldCefCallbackRef.UnWrap(callback)));
end;

procedure cef_resource_handler_get_response_headers(self            : POldCefResourceHandler;
                                                    response        : POldCefResponse;
                                                    response_length : PInt64;
                                                    redirectUrl     : POldCefString); stdcall;
var
  TempRedirect : oldustring;
  TempObject   : TObject;
begin
  TempRedirect := '';
  TempObject   := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefResourceHandlerOwn) then
    TOldCefResourceHandlerOwn(TempObject).GetResponseHeaders(TOldCefResponseRef.UnWrap(response),
                                                          response_length^,
                                                          TempRedirect);

  if (TempRedirect <> '') then CefStringSet(redirectUrl, TempRedirect);
end;

function cef_resource_handler_read_response(self          : POldCefResourceHandler;
                                            data_out      : Pointer;
                                            bytes_to_read : Integer;
                                            bytes_read    : PInteger;
                                            callback      : POldCefCallback): Integer; stdcall;
var
  TempObject : TObject;
begin
  Result     := Ord(False);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefResourceHandlerOwn) then
    Result := Ord(TOldCefResourceHandlerOwn(TempObject).ReadResponse(data_out,
                                                                  bytes_to_read,
                                                                  bytes_read^,
                                                                  TOldCefCallbackRef.UnWrap(callback)));
end;

function cef_resource_handler_can_get_cookie(      self   : POldCefResourceHandler;
                                             const cookie : POldCefCookie): Integer; stdcall;
var
  TempObject : TObject;
begin
  Result     := Ord(True);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefResourceHandlerOwn) then
    Result := Ord(TOldCefResourceHandlerOwn(TempObject).CanGetCookie(cookie));
end;

function cef_resource_handler_can_set_cookie(      self   : POldCefResourceHandler;
                                             const cookie : POldCefCookie): Integer; stdcall;
var
  TempObject : TObject;
begin
  Result     := Ord(True);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefResourceHandlerOwn) then
    Result := Ord(TOldCefResourceHandlerOwn(TempObject).CanSetCookie(cookie));
end;

procedure cef_resource_handler_cancel(self: POldCefResourceHandler); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefResourceHandlerOwn) then
    TOldCefResourceHandlerOwn(TempObject).Cancel;
end;

procedure TOldCefResourceHandlerOwn.Cancel;
begin

end;

function TOldCefResourceHandlerOwn.CanGetCookie(const cookie: POldCefCookie): Boolean;
begin
  Result := True;
end;

function TOldCefResourceHandlerOwn.CanSetCookie(const cookie: POldCefCookie): Boolean;
begin
  Result := True;
end;

constructor TOldCefResourceHandlerOwn.Create(const browser    : IOldCefBrowser;
                                          const frame      : IOldCefFrame;
                                          const schemeName : oldustring;
                                          const request    : IOldCefRequest);
begin
  inherited CreateData(SizeOf(TOldCefResourceHandler));

  with POldCefResourceHandler(FData)^ do
    begin
      process_request      := cef_resource_handler_process_request;
      get_response_headers := cef_resource_handler_get_response_headers;
      read_response        := cef_resource_handler_read_response;
      can_get_cookie       := cef_resource_handler_can_get_cookie;
      can_set_cookie       := cef_resource_handler_can_set_cookie;
      cancel               := cef_resource_handler_cancel;
    end;
end;

procedure TOldCefResourceHandlerOwn.GetResponseHeaders(const response       : IOldCefResponse;
                                                    out   responseLength : Int64;
                                                    out   redirectUrl    : oldustring);
begin

end;

function TOldCefResourceHandlerOwn.ProcessRequest(const request  : IOldCefRequest;
                                               const callback : IOldCefCallback): Boolean;
begin
  Result := False;
end;

function TOldCefResourceHandlerOwn.ReadResponse(const dataOut     : Pointer;
                                                   bytesToRead : Integer;
                                             var   bytesRead   : Integer;
                                             const callback    : IOldCefCallback): Boolean;
begin
  Result := False;
end;

end.
