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

unit oldCEFLifeSpanHandler;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefLifeSpanHandlerOwn = class(TOldCefBaseOwn, IOldCefLifeSpanHandler)
    protected
      function  OnBeforePopup(const browser: IOldCefBrowser; const frame: IOldCefFrame; const targetUrl, targetFrameName: oldustring; targetDisposition: TOldCefWindowOpenDisposition; userGesture: Boolean; const popupFeatures: TOldCefPopupFeatures; var windowInfo: TOldCefWindowInfo; var client: IOldCefClient; var settings: TOldCefBrowserSettings; var noJavascriptAccess: Boolean): Boolean; virtual;
      procedure OnAfterCreated(const browser: IOldCefBrowser); virtual;
      function  RunModal(const browser: IOldCefBrowser): Boolean; virtual;
      function  DoClose(const browser: IOldCefBrowser): Boolean; virtual;
      procedure OnBeforeClose(const browser: IOldCefBrowser); virtual;

      procedure RemoveReferences; virtual;

    public
      constructor Create; virtual;
  end;

  TOldCustomLifeSpanHandler = class(TOldCefLifeSpanHandlerOwn)
    protected
      FEvents : Pointer;

      function  OnBeforePopup(const browser: IOldCefBrowser; const frame: IOldCefFrame; const targetUrl, targetFrameName: oldustring; targetDisposition: TOldCefWindowOpenDisposition; userGesture: Boolean; const popupFeatures: TOldCefPopupFeatures; var windowInfo: TOldCefWindowInfo; var client: IOldCefClient; var settings: TOldCefBrowserSettings; var noJavascriptAccess: Boolean): Boolean; override;
      procedure OnAfterCreated(const browser: IOldCefBrowser); override;
      function  RunModal(const browser: IOldCefBrowser): Boolean; override;
      function  DoClose(const browser: IOldCefBrowser): Boolean; override;
      procedure OnBeforeClose(const browser: IOldCefBrowser); override;

      procedure RemoveReferences; override;

    public
      constructor Create(const events: Pointer); reintroduce; virtual;
      destructor  Destroy; override;
  end;

implementation

uses
  {$IFDEF DELPHI16_UP}
  System.SysUtils,
  {$ELSE}
  SysUtils,
  {$ENDIF}
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFClient, oldCEFBrowser, oldCEFFrame;

function cef_life_span_handler_on_before_popup(      self                 : POldCefLifeSpanHandler;
                                                     browser              : POldCefBrowser;
                                                     frame                : POldCefFrame;
                                               const target_url           : POldCefString;
                                               const target_frame_name    : POldCefString;
                                                     target_disposition   : TOldCefWindowOpenDisposition;
                                                     user_gesture         : Integer;
                                               const popupFeatures        : POldCefPopupFeatures;
                                                     windowInfo           : POldCefWindowInfo;
                                                 var client               : POldCefClient;
                                                     settings             : POldCefBrowserSettings;
                                                     no_javascript_access : PInteger): Integer; stdcall;
var
  TempClient : IOldCefClient;
  TempNoJS   : Boolean;
  TempObject : TObject;
begin
  try
    Result     := Ord(False);
    TempObject := CefGetObject(self);

    if (TempObject <> nil) and (TempObject is TOldCefLifeSpanHandlerOwn) then
      begin
        TempNoJS   := (no_javascript_access^ <> 0);
        TempClient := TOldCefClientRef.UnWrap(client);
        Result     := Ord(TOldCefLifeSpanHandlerOwn(TempObject).OnBeforePopup(TOldCefBrowserRef.UnWrap(browser),
                                                                           TOldCefFrameRef.UnWrap(frame),
                                                                           CefString(target_url),
                                                                           CefString(target_frame_name),
                                                                           target_disposition,
                                                                           user_gesture <> 0,
                                                                           popupFeatures^,
                                                                           windowInfo^,
                                                                           TempClient,
                                                                           settings^,
                                                                           TempNoJS));

        no_javascript_access^ := Ord(TempNoJS);

        if (TempClient = nil) then
          client := nil
         else
          if not(TempClient.SameAs(client)) then
            client := TempClient.Wrap;
      end;
  finally
    TempClient := nil;
  end;
end;

procedure cef_life_span_handler_on_after_created(self    : POldCefLifeSpanHandler;
                                                 browser : POldCefBrowser); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefLifeSpanHandlerOwn) then
    TOldCefLifeSpanHandlerOwn(TempObject).OnAfterCreated(TOldCefBrowserRef.UnWrap(browser));
end;

function cef_life_span_handler_run_modal(self: POldCefLifeSpanHandler; browser: POldCefBrowser): Integer; stdcall;
var
  TempObject : TObject;
begin
  Result     := Ord(False);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefLifeSpanHandlerOwn) then
    Result := Ord(TOldCefLifeSpanHandlerOwn(TempObject).RunModal(TOldCefBrowserRef.UnWrap(browser)));
end;

procedure cef_life_span_handler_on_before_close(self    : POldCefLifeSpanHandler;
                                                browser : POldCefBrowser); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefLifeSpanHandlerOwn) then
    TOldCefLifeSpanHandlerOwn(TempObject).OnBeforeClose(TOldCefBrowserRef.UnWrap(browser));
end;

function cef_life_span_handler_do_close(self    : POldCefLifeSpanHandler;
                                        browser : POldCefBrowser): Integer; stdcall;
var
  TempObject : TObject;
begin
  Result     := Ord(False);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefLifeSpanHandlerOwn) then
    Result := Ord(TOldCefLifeSpanHandlerOwn(TempObject).DoClose(TOldCefBrowserRef.UnWrap(browser)));
end;

constructor TOldCefLifeSpanHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefLifeSpanHandler));

  with POldCefLifeSpanHandler(FData)^ do
    begin
      on_before_popup  := cef_life_span_handler_on_before_popup;
      on_after_created := cef_life_span_handler_on_after_created;
      run_modal        := cef_life_span_handler_run_modal;
      do_close         := cef_life_span_handler_do_close;
      on_before_close  := cef_life_span_handler_on_before_close;
    end;
end;

procedure TOldCefLifeSpanHandlerOwn.OnAfterCreated(const browser: IOldCefBrowser);
begin
  //
end;

function TOldCefLifeSpanHandlerOwn.RunModal(const browser: IOldCefBrowser): Boolean;
begin
  Result := False;
end;

procedure TOldCefLifeSpanHandlerOwn.OnBeforeClose(const browser: IOldCefBrowser);
begin
  //
end;

function TOldCefLifeSpanHandlerOwn.OnBeforePopup(const browser            : IOldCefBrowser;
                                              const frame              : IOldCefFrame;
                                              const targetUrl          : oldustring;
                                              const targetFrameName    : oldustring;
                                                    targetDisposition  : TOldCefWindowOpenDisposition;
                                                    userGesture        : Boolean;
                                              const popupFeatures      : TOldCefPopupFeatures;
                                              var   windowInfo         : TOldCefWindowInfo;
                                              var   client             : IOldCefClient;
                                              var   settings           : TOldCefBrowserSettings;
                                              var   noJavascriptAccess : Boolean): Boolean;
begin
  Result := False;
end;

function TOldCefLifeSpanHandlerOwn.DoClose(const browser: IOldCefBrowser): Boolean;
begin
  Result := False;
end;

procedure TOldCefLifeSpanHandlerOwn.RemoveReferences;
begin
  //
end;

// TCustomLifeSpanHandler

constructor TOldCustomLifeSpanHandler.Create(const events: Pointer);
begin
  inherited Create;

  FEvents := events;
end;

destructor TOldCustomLifeSpanHandler.Destroy;
begin
  RemoveReferences;

  inherited Destroy;
end;

procedure TOldCustomLifeSpanHandler.RemoveReferences;
begin
  FEvents := nil;
end;

function TOldCustomLifeSpanHandler.DoClose(const browser: IOldCefBrowser): Boolean;
begin
  if (FEvents <> nil) then
    Result := IOldChromiumEvents(FEvents).doOnClose(browser)
   else
    Result := inherited DoClose(browser);
end;

procedure TOldCustomLifeSpanHandler.OnAfterCreated(const browser: IOldCefBrowser);
begin
  if (FEvents <> nil) then IOldChromiumEvents(FEvents).doOnAfterCreated(browser);
end;

function TOldCustomLifeSpanHandler.RunModal(const browser: IOldCefBrowser): Boolean;
begin
  if (FEvents <> nil) then
    Result := IOldChromiumEvents(FEvents).doRunModal(browser)
   else
    Result := inherited RunModal(browser);
end;

procedure TOldCustomLifeSpanHandler.OnBeforeClose(const browser: IOldCefBrowser);
begin
  if (FEvents <> nil) then IOldChromiumEvents(FEvents).doOnBeforeClose(browser);
end;

function TOldCustomLifeSpanHandler.OnBeforePopup(const browser            : IOldCefBrowser;
                                              const frame              : IOldCefFrame;
                                              const targetUrl          : oldustring;
                                              const targetFrameName    : oldustring;
                                                    targetDisposition  : TOldCefWindowOpenDisposition;
                                                    userGesture        : Boolean;
                                              const popupFeatures      : TOldCefPopupFeatures;
                                              var   windowInfo         : TOldCefWindowInfo;
                                              var   client             : IOldCefClient;
                                              var   settings           : TOldCefBrowserSettings;
                                              var   noJavascriptAccess : Boolean): Boolean;
begin
  if (FEvents <> nil) then
    Result := IOldChromiumEvents(FEvents).doOnBeforePopup(browser, frame, targetUrl, targetFrameName,
                                                       targetDisposition, userGesture, popupFeatures,
                                                       windowInfo, client, settings, noJavascriptAccess)
   else
    Result := inherited OnBeforePopup(browser, frame, targetUrl, targetFrameName,
                                      targetDisposition, userGesture, popupFeatures,
                                      windowInfo, client, settings, noJavascriptAccess);
end;

end.
