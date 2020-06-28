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
//        Copyright © 2019 Salvador Diaz Fau. All rights reserved.
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

unit oldCEFUrlRequestClientComponent;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    {$IFDEF MSWINDOWS}WinApi.Windows, WinApi.Messages, WinApi.ActiveX,{$ENDIF}
    System.Classes, Vcl.Controls, Vcl.Graphics, Vcl.Forms, System.Math,
  {$ELSE}
    {$IFDEF MSWINDOWS}Windows,{$ENDIF} Classes, Forms, Controls, Graphics, ActiveX, Math,
    {$IFDEF FPC}
    LCLProc, LCLType, LCLIntf, LResources, LMessages, InterfaceBase,
    {$ELSE}
    Messages,
    {$ENDIF}
  {$ENDIF}
  oldCEFTypes, oldCEFInterfaces, oldCEFUrlRequestClientEvents, oldCEFUrlrequestClient, oldCEFUrlRequest;

type
  {$IFNDEF FPC}{$IFDEF DELPHI16_UP}[ComponentPlatformsAttribute(pidWin32 or pidWin64)]{$ENDIF}{$ENDIF}
  TOldCEFUrlRequestClientComponent = class(TComponent, IOldCEFUrlRequestClientEvents)
    protected
      FClient               : IOldCefUrlrequestClient;
      FThreadID             : TOldCefThreadId;

      FOnRequestComplete    : TOnRequestComplete;
      FOnUploadProgress     : TOnUploadProgress;
      FOnDownloadProgress   : TOnDownloadProgress;
      FOnDownloadData       : TOnDownloadData;
      FOnGetAuthCredentials : TOnGetAuthCredentials;
      FOnCreateURLRequest   : TNotifyEvent;

      // ICefUrlrequestClient
      procedure doOnRequestComplete(const request: IOldCefUrlRequest);
      procedure doOnUploadProgress(const request: IOldCefUrlRequest; current, total: Int64);
      procedure doOnDownloadProgress(const request: IOldCefUrlRequest; current, total: Int64);
      procedure doOnDownloadData(const request: IOldCefUrlRequest; data: Pointer; dataLength: NativeUInt);
      function  doOnGetAuthCredentials(isProxy: Boolean; const host: oldustring; port: Integer; const realm, scheme: oldustring; const callback: IOldCefAuthCallback): Boolean;

      // Custom
      procedure doOnCreateURLRequest;

      procedure DestroyRequestClient;

    public
      constructor Create(AOwner: TComponent); override;
      procedure   AfterConstruction; override;
      procedure   BeforeDestruction; override;

      procedure   AddURLRequest;

      property Client               : IOldCefUrlrequestClient   read FClient;
      property ThreadID             : TOldCefThreadId           read FThreadID              write FThreadID;

    published
      property OnRequestComplete    : TOnRequestComplete     read FOnRequestComplete     write FOnRequestComplete;
      property OnUploadProgress     : TOnUploadProgress      read FOnUploadProgress      write FOnUploadProgress;
      property OnDownloadProgress   : TOnDownloadProgress    read FOnDownloadProgress    write FOnDownloadProgress;
      property OnDownloadData       : TOnDownloadData        read FOnDownloadData        write FOnDownloadData;
      property OnGetAuthCredentials : TOnGetAuthCredentials  read FOnGetAuthCredentials  write FOnGetAuthCredentials;
      property OnCreateURLRequest   : TNotifyEvent           read FOnCreateURLRequest    write FOnCreateURLRequest;
  end;

{$IFDEF FPC}
procedure Register;
{$ENDIF}

implementation

uses
  {$IFDEF DELPHI16_UP}
  System.SysUtils,
  {$ELSE}
  SysUtils,
  {$ENDIF}
  oldCEFRequest, oldCEFTask, oldCEFMiscFunctions;


constructor TOldCEFUrlRequestClientComponent.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FClient               := nil;
  FThreadID             := TID_UI;
  FOnRequestComplete    := nil;
  FOnUploadProgress     := nil;
  FOnDownloadProgress   := nil;
  FOnDownloadData       := nil;
  FOnGetAuthCredentials := nil;
  FOnCreateURLRequest   := nil;
end;

procedure TOldCEFUrlRequestClientComponent.AfterConstruction;
begin
  inherited AfterConstruction;

  if not(csDesigning in ComponentState) then
    FClient := TOldCustomCefUrlrequestClient.Create(self);
end;

procedure TOldCEFUrlRequestClientComponent.BeforeDestruction;
begin
  DestroyRequestClient;

  inherited BeforeDestruction;
end;

procedure TOldCEFUrlRequestClientComponent.DestroyRequestClient;
begin
  try
    if (FClient <> nil) then
      begin
        FClient.RemoveReferences;
        FClient := nil;
      end;
  except
    on e : exception do
      if CustomExceptionHandler('TOldCefUrlRequestClientComponent.DestroyRequestClient', e) then raise;
  end;
end;

procedure TOldCEFUrlRequestClientComponent.doOnRequestComplete(const request: IOldCefUrlRequest);
begin
  if assigned(FOnRequestComplete) then FOnRequestComplete(self, request);
end;

procedure TOldCEFUrlRequestClientComponent.doOnUploadProgress(const request: IOldCefUrlRequest; current, total: Int64);
begin
  if assigned(FOnUploadProgress) then FOnUploadProgress(self, request, current, total);
end;

procedure TOldCEFUrlRequestClientComponent.doOnDownloadProgress(const request: IOldCefUrlRequest; current, total: Int64);
begin
  if assigned(FOnDownloadProgress) then FOnDownloadProgress(self, request, current, total);
end;

procedure TOldCEFUrlRequestClientComponent.doOnDownloadData(const request: IOldCefUrlRequest; data: Pointer; dataLength: NativeUInt);
begin
  if assigned(FOnDownloadData) then FOnDownloadData(self, request, data, datalength);
end;

function TOldCEFUrlRequestClientComponent.doOnGetAuthCredentials(isProxy: Boolean; const host: oldustring; port: Integer; const realm, scheme: oldustring; const callback: IOldCefAuthCallback): Boolean;
begin
  Result := False;

  if assigned(FOnGetAuthCredentials) then FOnGetAuthCredentials(self, isProxy, host, port, realm, scheme, callback, Result);
end;

procedure TOldCEFUrlRequestClientComponent.doOnCreateURLRequest;
begin
  if assigned(FOnCreateURLRequest) then FOnCreateURLRequest(self);
end;

procedure TOldCEFUrlRequestClientComponent.AddURLRequest;
var
  TempTask : IOldCefTask;
begin
  TempTask := TOldCefURLRequestTask.Create(self);
  CefPostTask(FThreadID, TempTask);
end;

{$IFDEF FPC}
procedure Register;
begin
  {$I res/TOldCefurlrequestclientcomponent.lrs}
  RegisterComponents('Chromium', [TOldCefUrlRequestClientComponent]);
end;
{$ENDIF}

end.
