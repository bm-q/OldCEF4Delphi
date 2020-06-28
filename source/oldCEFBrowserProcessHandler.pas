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

unit oldCEFBrowserProcessHandler;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes, oldCEFApplication;

type
  TOldCefBrowserProcessHandlerOwn = class(TOldCefBaseOwn, IOldCefBrowserProcessHandler)
    protected
      procedure OnContextInitialized; virtual; abstract;
      procedure OnBeforeChildProcessLaunch(const commandLine: IOldCefCommandLine); virtual; abstract;
      procedure OnRenderProcessThreadCreated(const extraInfo: IOldCefListValue); virtual; abstract;
      procedure GetPrintHandler(var aHandler : IOldCefPrintHandler); virtual;

    public
      constructor Create; virtual;
  end;

  TOldCefCustomBrowserProcessHandler = class(TOldCefBrowserProcessHandlerOwn)
    protected
      FCefApp : TOldCefApplication;

      procedure OnContextInitialized; override;
      procedure OnBeforeChildProcessLaunch(const commandLine: IOldCefCommandLine); override;
      procedure OnRenderProcessThreadCreated(const extraInfo: IOldCefListValue); override;

    public
      constructor Create(const aCefApp : TOldCefApplication); reintroduce;
      destructor  Destroy; override;
  end;

implementation

uses
  {$IFDEF DELPHI16_UP}
  System.SysUtils,
  {$ELSE}
  SysUtils,
  {$ENDIF}
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFCommandLine, oldCEFListValue, oldCEFConstants;

procedure cef_browser_process_handler_on_context_initialized(self: POldCefBrowserProcessHandler); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefBrowserProcessHandlerOwn) then
    TOldCefBrowserProcessHandlerOwn(TempObject).OnContextInitialized;
end;

procedure cef_browser_process_handler_on_before_child_process_launch(self         : POldCefBrowserProcessHandler;
                                                                     command_line : POldCefCommandLine); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefBrowserProcessHandlerOwn) then
    TOldCefBrowserProcessHandlerOwn(TempObject).OnBeforeChildProcessLaunch(TOldCefCommandLineRef.UnWrap(command_line));
end;

procedure cef_browser_process_handler_on_render_process_thread_created(self       : POldCefBrowserProcessHandler;
                                                                       extra_info : POldCefListValue); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefBrowserProcessHandlerOwn) then
    TOldCefBrowserProcessHandlerOwn(TempObject).OnRenderProcessThreadCreated(TOldCefListValueRef.UnWrap(extra_info));
end;

function cef_browser_process_handler_get_print_handler(self: POldCefBrowserProcessHandler): POldCefPrintHandler; stdcall;
var
  TempObject  : TObject;
  TempHandler : IOldCefPrintHandler;
begin
  Result     := nil;
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefBrowserProcessHandlerOwn) then
    try
      TOldCefBrowserProcessHandlerOwn(TempObject).GetPrintHandler(TempHandler);
      if (TempHandler <> nil) then Result := TempHandler.Wrap;
    finally
      TempHandler := nil;
    end;
end;

constructor TOldCefBrowserProcessHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefBrowserProcessHandler));

  with POldCefBrowserProcessHandler(FData)^ do
    begin
      on_context_initialized           := cef_browser_process_handler_on_context_initialized;
      on_before_child_process_launch   := cef_browser_process_handler_on_before_child_process_launch;
      on_render_process_thread_created := cef_browser_process_handler_on_render_process_thread_created;
      get_print_handler                := cef_browser_process_handler_get_print_handler;
    end;
end;

procedure TOldCefBrowserProcessHandlerOwn.GetPrintHandler(var aHandler : IOldCefPrintHandler);
begin
  aHandler := nil; // only linux
end;


// TOldCefCustomBrowserProcessHandler


constructor TOldCefCustomBrowserProcessHandler.Create(const aCefApp : TOldCefApplication);
begin
  inherited Create;

  FCefApp := aCefApp;
end;

destructor TOldCefCustomBrowserProcessHandler.Destroy;
begin
  FCefApp := nil;

  inherited Destroy;
end;

procedure TOldCefCustomBrowserProcessHandler.OnContextInitialized;
begin
  try
    if (FCefApp <> nil) then FCefApp.Internal_OnContextInitialized;
  except
    on e : exception do
      if CustomExceptionHandler('TOldCefCustomBrowserProcessHandler.OnContextInitialized', e) then raise;
  end;
end;

procedure TOldCefCustomBrowserProcessHandler.OnBeforeChildProcessLaunch(const commandLine: IOldCefCommandLine);
begin
  try
    if (FCefApp <> nil) then FCefApp.Internal_OnBeforeChildProcessLaunch(commandLine);
  except
    on e : exception do
      if CustomExceptionHandler('TOldCefCustomBrowserProcessHandler.OnBeforeChildProcessLaunch', e) then raise;
  end;
end;

procedure TOldCefCustomBrowserProcessHandler.OnRenderProcessThreadCreated(const extraInfo: IOldCefListValue);
begin
  try
    if (FCefApp <> nil) then FCefApp.Internal_OnRenderProcessThreadCreated(extraInfo);
  except
    on e : exception do
      if CustomExceptionHandler('TOldCefCustomBrowserProcessHandler.OnRenderProcessThreadCreated', e) then raise;
  end;
end;

end.
