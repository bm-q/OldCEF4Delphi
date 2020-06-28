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

unit oldCEFLoadHandler;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes, oldCEFApplication;

type
  TOldCefLoadHandlerOwn = class(TOldCefBaseOwn, IOldCefLoadHandler)
    protected
      procedure OnLoadingStateChange(const browser: IOldCefBrowser; isLoading, canGoBack, canGoForward: Boolean); virtual;
      procedure OnLoadStart(const browser: IOldCefBrowser; const frame: IOldCefFrame); virtual;
      procedure OnLoadEnd(const browser: IOldCefBrowser; const frame: IOldCefFrame; httpStatusCode: Integer); virtual;
      procedure OnLoadError(const browser: IOldCefBrowser; const frame: IOldCefFrame; errorCode: TOldCefErrorCode; const errorText, failedUrl: oldustring); virtual;

      procedure RemoveReferences; virtual;

    public
      constructor Create; virtual;
  end;

  TOldCustomLoadHandler = class(TOldCefLoadHandlerOwn)
    protected
      FEvents : Pointer;

      procedure OnLoadingStateChange(const browser: IOldCefBrowser; isLoading, canGoBack, canGoForward: Boolean); override;
      procedure OnLoadStart(const browser: IOldCefBrowser; const frame: IOldCefFrame); override;
      procedure OnLoadEnd(const browser: IOldCefBrowser; const frame: IOldCefFrame; httpStatusCode: Integer); override;
      procedure OnLoadError(const browser: IOldCefBrowser; const frame: IOldCefFrame; errorCode: TOldCefErrorCode; const errorText, failedUrl: oldustring); override;

      procedure RemoveReferences; override;

    public
      constructor Create(const events: Pointer); reintroduce; virtual;
      destructor  Destroy; override;
  end;

  TOldCustomRenderLoadHandler = class(TOldCefLoadHandlerOwn)
    protected
       FCefApp : TOldCefApplication;
       procedure OnLoadingStateChange(const browser: IOldCefBrowser; isLoading, canGoBack, canGoForward: Boolean); override;
       procedure OnLoadStart(const browser: IOldCefBrowser; const frame: IOldCefFrame); override;
       procedure OnLoadEnd(const browser: IOldCefBrowser; const frame: IOldCefFrame; httpStatusCode: Integer); override;
       procedure OnLoadError(const browser: IOldCefBrowser; const frame: IOldCefFrame; errorCode: TOldCefErrorCode; const errorText, failedUrl: oldustring); override;
     public
       constructor Create(const aCefApp : TOldCefApplication); reintroduce; virtual;
       destructor  Destroy; override;
  end;

implementation

uses
  {$IFDEF DELPHI16_UP}
  System.SysUtils,
  {$ELSE}
  SysUtils,
  {$ENDIF}
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFBrowser, oldCEFFrame;

procedure cef_load_handler_on_loading_state_change(self         : POldCefLoadHandler;
                                                   browser      : POldCefBrowser;
                                                   isLoading    : integer;
                                                   canGoBack    : integer;
                                                   canGoForward : Integer); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefLoadHandlerOwn) then
    TOldCefLoadHandlerOwn(TempObject).OnLoadingStateChange(TOldCefBrowserRef.UnWrap(browser),
                                                        isLoading <> 0,
                                                        canGoBack <> 0,
                                                        canGoForward <> 0);
end;

procedure cef_load_handler_on_load_start(self            : POldCefLoadHandler;
                                         browser         : POldCefBrowser;
                                         frame           : POldCefFrame); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefLoadHandlerOwn) then
    TOldCefLoadHandlerOwn(TempObject).OnLoadStart(TOldCefBrowserRef.UnWrap(browser),
                                               TOldCefFrameRef.UnWrap(frame));
end;

procedure cef_load_handler_on_load_end(self           : POldCefLoadHandler;
                                       browser        : POldCefBrowser;
                                       frame          : POldCefFrame;
                                       httpStatusCode : Integer); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefLoadHandlerOwn) then
    TOldCefLoadHandlerOwn(TempObject).OnLoadEnd(TOldCefBrowserRef.UnWrap(browser),
                                             TOldCefFrameRef.UnWrap(frame),
                                             httpStatusCode);
end;

procedure cef_load_handler_on_load_error(      self      : POldCefLoadHandler;
                                               browser   : POldCefBrowser;
                                               frame     : POldCefFrame;
                                               errorCode : TOldCefErrorCode;
                                         const errorText : POldCefString;
                                         const failedUrl : POldCefString); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefLoadHandlerOwn) then
    TOldCefLoadHandlerOwn(TempObject).OnLoadError(TOldCefBrowserRef.UnWrap(browser),
                                               TOldCefFrameRef.UnWrap(frame),
                                               errorCode,
                                               CefString(errorText),
                                               CefString(failedUrl));
end;

constructor TOldCefLoadHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefLoadHandler));

  with POldCefLoadHandler(FData)^ do
    begin
      on_loading_state_change := cef_load_handler_on_loading_state_change;
      on_load_start           := cef_load_handler_on_load_start;
      on_load_end             := cef_load_handler_on_load_end;
      on_load_error           := cef_load_handler_on_load_error;
    end;
end;

procedure TOldCefLoadHandlerOwn.OnLoadEnd(const browser: IOldCefBrowser; const frame: IOldCefFrame; httpStatusCode: Integer);
begin
  //
end;

procedure TOldCefLoadHandlerOwn.OnLoadError(const browser: IOldCefBrowser; const frame: IOldCefFrame; errorCode: TOldCefErrorCode; const errorText, failedUrl: oldustring);
begin
  //
end;

procedure TOldCefLoadHandlerOwn.OnLoadingStateChange(const browser: IOldCefBrowser; isLoading, canGoBack, canGoForward: Boolean);
begin
  //
end;

procedure TOldCefLoadHandlerOwn.OnLoadStart(const browser: IOldCefBrowser; const frame: IOldCefFrame);
begin
  //
end;

procedure TOldCefLoadHandlerOwn.RemoveReferences;
begin
  //
end;

// TCustomLoadHandler

constructor TOldCustomLoadHandler.Create(const events : Pointer);
begin
  inherited Create;

  FEvents := events;
end;

destructor TOldCustomLoadHandler.Destroy;
begin
  RemoveReferences;

  inherited Destroy;
end;

procedure TOldCustomLoadHandler.RemoveReferences;
begin
  FEvents := nil;
end;

procedure TOldCustomLoadHandler.OnLoadEnd(const browser        : IOldCefBrowser;
                                       const frame          : IOldCefFrame;
                                             httpStatusCode : Integer);
begin
  if (FEvents <> nil) then IOldChromiumEvents(FEvents).doOnLoadEnd(browser, frame, httpStatusCode);
end;

procedure TOldCustomLoadHandler.OnLoadError(const browser   : IOldCefBrowser;
                                         const frame     : IOldCefFrame;
                                               errorCode : TOldCefErrorCode;
                                         const errorText : oldustring;
                                         const failedUrl : oldustring);
begin
  if (FEvents <> nil) then IOldChromiumEvents(FEvents).doOnLoadError(browser, frame, errorCode, errorText, failedUrl);
end;

procedure TOldCustomLoadHandler.OnLoadingStateChange(const browser      : IOldCefBrowser;
                                                        isLoading    : Boolean;
                                                        canGoBack    : Boolean;
                                                        canGoForward : Boolean);
begin
  if (FEvents <> nil) then IOldChromiumEvents(FEvents).doOnLoadingStateChange(browser, isLoading, canGoBack, canGoForward);
end;

procedure TOldCustomLoadHandler.OnLoadStart(const browser        : IOldCefBrowser;
                                         const frame          : IOldCefFrame);
begin
  if (FEvents <> nil) then IOldChromiumEvents(FEvents).doOnLoadStart(browser, frame);
end;

// TCustomRenderLoadHandler

constructor TOldCustomRenderLoadHandler.Create(const aCefApp : TOldCefApplication);
begin
  inherited Create;

   FCefApp := aCefApp;
end;

destructor TOldCustomRenderLoadHandler.Destroy;
begin
  FCefApp := nil;

  inherited Destroy;
end;

procedure TOldCustomRenderLoadHandler.OnLoadEnd(const browser        : IOldCefBrowser;
                                             const frame          : IOldCefFrame;
                                                   httpStatusCode : Integer);
begin
  try
    if (FCefApp <> nil) then FCefApp.Internal_OnLoadEnd(browser, frame, httpStatusCode);
  except
    on e : exception do
      if CustomExceptionHandler('TCustomRenderLoadHandler.OnLoadEnd', e) then raise;
  end;
end;

procedure TOldCustomRenderLoadHandler.OnLoadError(const browser   : IOldCefBrowser;
                                               const frame     : IOldCefFrame;
                                                     errorCode : TOldCefErrorCode;
                                               const errorText : oldustring;
                                               const failedUrl : oldustring);
begin
  try
    if (FCefApp <> nil) then FCefApp.Internal_OnLoadError(browser, frame, errorCode, errorText, failedUrl);
  except
    on e : exception do
      if CustomExceptionHandler('TCustomRenderLoadHandler.OnLoadError', e) then raise;
  end;
end;

procedure TOldCustomRenderLoadHandler.OnLoadingStateChange(const browser      : IOldCefBrowser;
                                                              isLoading    : Boolean;
                                                              canGoBack    : Boolean;
                                                              canGoForward : Boolean);
begin
  try
    if (FCefApp <> nil) then FCefApp.Internal_OnLoadingStateChange(browser, isLoading, canGoBack, canGoForward);
  except
    on e : exception do
      if CustomExceptionHandler('TCustomRenderLoadHandler.OnLoadingStateChange', e) then raise;
  end;
end;

procedure TOldCustomRenderLoadHandler.OnLoadStart(const browser        : IOldCefBrowser;
                                               const frame          : IOldCefFrame);
begin
  try
    if (FCefApp <> nil) then FCefApp.Internal_OnLoadStart(browser, frame);
  except
    on e : exception do
      if CustomExceptionHandler('TCustomRenderLoadHandler.OnLoadStart', e) then raise;
  end;
end;

end.
