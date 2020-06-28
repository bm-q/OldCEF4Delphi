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

unit oldCEFUrlrequestClient;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefUrlrequestClientOwn = class(TOldCefBaseOwn, IOldCefUrlrequestClient)
  protected
    procedure OnRequestComplete(const request: IOldCefUrlRequest); virtual;
    procedure OnUploadProgress(const request: IOldCefUrlRequest; current, total: Int64); virtual;
    procedure OnDownloadProgress(const request: IOldCefUrlRequest; current, total: Int64); virtual;
    procedure OnDownloadData(const request: IOldCefUrlRequest; data: Pointer; dataLength: NativeUInt); virtual;
    function  OnGetAuthCredentials(isProxy: Boolean; const host: oldustring; port: Integer; const realm, scheme: oldustring; const callback: IOldCefAuthCallback): Boolean; virtual;

    procedure RemoveReferences; virtual;

  public
    constructor Create; virtual;
  end;

  TOldCustomCefUrlrequestClient = class(TOldCefUrlrequestClientOwn)
    protected
      FEvents : Pointer;

      procedure OnRequestComplete(const request: IOldCefUrlRequest); override;
      procedure OnUploadProgress(const request: IOldCefUrlRequest; current, total: Int64); override;
      procedure OnDownloadProgress(const request: IOldCefUrlRequest; current, total: Int64); override;
      procedure OnDownloadData(const request: IOldCefUrlRequest; data: Pointer; dataLength: NativeUInt); override;
      function  OnGetAuthCredentials(isProxy: Boolean; const host: oldustring; port: Integer; const realm, scheme: oldustring; const callback: IOldCefAuthCallback): Boolean; override;

      procedure RemoveReferences; override;

    public
      constructor Create(const events: IOldCEFUrlRequestClientEvents); reintroduce;
      destructor  Destroy; override;
  end;

implementation

uses
  {$IFDEF DELPHI16_UP}
  System.SysUtils,
  {$ELSE}
  SysUtils,
  {$ENDIF}
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFUrlRequest, oldCEFAuthCallback;


// TOldCefUrlrequestClientOwn

procedure cef_url_request_client_on_request_complete(self    : POldCefUrlRequestClient;
                                                     request : POldCefUrlRequest); stdcall;
var
  TempObject  : TObject;
begin
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefUrlrequestClientOwn) then
    TOldCefUrlrequestClientOwn(TempObject).OnRequestComplete(TOldCefUrlRequestRef.UnWrap(request));
end;

procedure cef_url_request_client_on_upload_progress(self    : POldCefUrlRequestClient;
                                                    request : POldCefUrlRequest;
                                                    current : Int64;
                                                    total   : Int64); stdcall;
var
  TempObject  : TObject;
begin
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefUrlrequestClientOwn) then
    TOldCefUrlrequestClientOwn(TempObject).OnUploadProgress(TOldCefUrlRequestRef.UnWrap(request),
                                                         current,
                                                         total);
end;

procedure cef_url_request_client_on_download_progress(self    : POldCefUrlRequestClient;
                                                      request : POldCefUrlRequest;
                                                      current : Int64;
                                                      total   : Int64); stdcall;
var
  TempObject  : TObject;
begin
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefUrlrequestClientOwn) then
    TOldCefUrlrequestClientOwn(TempObject).OnDownloadProgress(TOldCefUrlRequestRef.UnWrap(request),
                                                           current,
                                                           total);
end;

procedure cef_url_request_client_on_download_data(      self        : POldCefUrlRequestClient;
                                                        request     : POldCefUrlRequest;
                                                  const data        : Pointer;
                                                        data_length : NativeUInt); stdcall;
var
  TempObject  : TObject;
begin
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefUrlrequestClientOwn) then
    TOldCefUrlrequestClientOwn(TempObject).OnDownloadData(TOldCefUrlRequestRef.UnWrap(request),
                                                       data,
                                                       data_length);
end;

function cef_url_request_client_get_auth_credentials(      self     : POldCefUrlRequestClient;
                                                           isProxy  : Integer;
                                                     const host     : POldCefString;
                                                           port     : Integer;
                                                     const realm    : POldCefString;
                                                     const scheme   : POldCefString;
                                                           callback : POldCefAuthCallback): Integer; stdcall;
var
  TempObject  : TObject;
begin
  Result      := Ord(False);
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefUrlrequestClientOwn) then
    Result := Ord(TOldCefUrlrequestClientOwn(TempObject).OnGetAuthCredentials(isProxy <> 0,
                                                                           CefString(host),
                                                                           port,
                                                                           CefString(realm),
                                                                           CefString(scheme),
                                                                           TOldCefAuthCallbackRef.UnWrap(callback)));
end;


constructor TOldCefUrlrequestClientOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefUrlrequestClient));

  with POldCefUrlrequestClient(FData)^ do
    begin
      on_request_complete  := cef_url_request_client_on_request_complete;
      on_upload_progress   := cef_url_request_client_on_upload_progress;
      on_download_progress := cef_url_request_client_on_download_progress;
      on_download_data     := cef_url_request_client_on_download_data;
      get_auth_credentials := cef_url_request_client_get_auth_credentials;
    end;
end;

procedure TOldCefUrlrequestClientOwn.OnDownloadData(const request: IOldCefUrlRequest; data: Pointer; dataLength: NativeUInt);
begin
  //
end;

procedure TOldCefUrlrequestClientOwn.OnDownloadProgress(const request: IOldCefUrlRequest; current, total: Int64);
begin
  //
end;

function TOldCefUrlrequestClientOwn.OnGetAuthCredentials(isProxy: Boolean; const host: oldustring; port: Integer; const realm, scheme: oldustring; const callback: IOldCefAuthCallback): Boolean;
begin
  Result := False;
end;

procedure TOldCefUrlrequestClientOwn.RemoveReferences;
begin
  //
end;

procedure TOldCefUrlrequestClientOwn.OnRequestComplete(const request: IOldCefUrlRequest);
begin
  //
end;

procedure TOldCefUrlrequestClientOwn.OnUploadProgress(const request: IOldCefUrlRequest; current, total: Int64);
begin
  //
end;


// TCustomCefUrlrequestClient

constructor TOldCustomCefUrlrequestClient.Create(const events: IOldCEFUrlRequestClientEvents);
begin
  inherited Create;

  FEvents := Pointer(events);
end;

destructor TOldCustomCefUrlrequestClient.Destroy;
begin
  RemoveReferences;

  inherited Destroy;
end;

procedure TOldCustomCefUrlrequestClient.OnRequestComplete(const request: IOldCefUrlRequest);
begin
  try
    if (FEvents <> nil) then
      IOldCEFUrlRequestClientEvents(FEvents).doOnRequestComplete(request);
  except
    on e : exception do
      if CustomExceptionHandler('TCustomCefUrlrequestClient.OnRequestComplete', e) then raise;
  end;
end;

procedure TOldCustomCefUrlrequestClient.OnUploadProgress(const request: IOldCefUrlRequest; current, total: Int64);
begin
  try
    if (FEvents <> nil) then
      IOldCEFUrlRequestClientEvents(FEvents).doOnUploadProgress(request, current, total);
  except
    on e : exception do
      if CustomExceptionHandler('TCustomCefUrlrequestClient.OnUploadProgress', e) then raise;
  end;
end;

procedure TOldCustomCefUrlrequestClient.OnDownloadProgress(const request: IOldCefUrlRequest; current, total: Int64);
begin
  try
    if (FEvents <> nil) then
      IOldCEFUrlRequestClientEvents(FEvents).doOnDownloadProgress(request, current, total);
  except
    on e : exception do
      if CustomExceptionHandler('TCustomCefUrlrequestClient.OnDownloadProgress', e) then raise;
  end;
end;

procedure TOldCustomCefUrlrequestClient.OnDownloadData(const request: IOldCefUrlRequest; data: Pointer; dataLength: NativeUInt);
begin
  try
    if (FEvents <> nil) then
      IOldCEFUrlRequestClientEvents(FEvents).doOnDownloadData(request, data, dataLength);
  except
    on e : exception do
      if CustomExceptionHandler('TCustomCefUrlrequestClient.OnDownloadData', e) then raise;
  end;
end;

function TOldCustomCefUrlrequestClient.OnGetAuthCredentials(isProxy: Boolean; const host: oldustring; port: Integer; const realm, scheme: oldustring; const callback: IOldCefAuthCallback): Boolean;
begin
  Result := False;
  try
    if (FEvents <> nil) then
      Result := IOldCEFUrlRequestClientEvents(FEvents).doOnGetAuthCredentials(isProxy, host, port, realm, scheme, callback);
  except
    on e : exception do
      if CustomExceptionHandler('TCustomCefUrlrequestClient.OnGetAuthCredentials', e) then raise;
  end;
end;

procedure TOldCustomCefUrlrequestClient.RemoveReferences;
begin
  FEvents := nil;
end;

end.
