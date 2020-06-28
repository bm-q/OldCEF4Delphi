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

unit oldCEFApp;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
  System.Classes, System.UITypes,
  {$ELSE}
  Windows, Classes,
  {$ENDIF}
  oldCEFTypes, oldCEFInterfaces, oldCEFBase, oldCEFSchemeRegistrar, oldCEFApplication;

type
  TOldCefAppOwn = class(TOldCefBaseOwn, IOldCefApp)
    protected
      procedure OnBeforeCommandLineProcessing(const processType: oldustring; const commandLine: IOldCefCommandLine); virtual; abstract;
      procedure OnRegisterCustomSchemes(const registrar: IOldCefSchemeRegistrar); virtual; abstract;
      procedure GetResourceBundleHandler(var aHandler : IOldCefResourceBundleHandler); virtual; abstract;
      procedure GetBrowserProcessHandler(var aHandler : IOldCefBrowserProcessHandler); virtual; abstract;
      procedure GetRenderProcessHandler(var aHandler : IOldCefRenderProcessHandler); virtual; abstract;

    public
      constructor Create; virtual;
  end;

  TOldCustomCefApp = class(TOldCefAppOwn)
    protected
      FCefApp                : TOldCefApplication;
      FResourceBundleHandler : IOldCefResourceBundleHandler;
      FBrowserProcessHandler : IOldCefBrowserProcessHandler;
      FRenderProcessHandler  : IOldCefRenderProcessHandler;

      procedure OnBeforeCommandLineProcessing(const processType: oldustring; const commandLine: IOldCefCommandLine); override;
      procedure OnRegisterCustomSchemes(const registrar: IOldCefSchemeRegistrar); override;
      procedure GetResourceBundleHandler(var aHandler : IOldCefResourceBundleHandler); override;
      procedure GetBrowserProcessHandler(var aHandler : IOldCefBrowserProcessHandler); override;
      procedure GetRenderProcessHandler(var aHandler : IOldCefRenderProcessHandler); override;

      procedure InitializeVars;

    public
      constructor Create(const aCefApp : TOldCefApplication); reintroduce;
      procedure   BeforeDestruction; override;
  end;


implementation

uses
  {$IFDEF DELPHI16_UP}
  System.SysUtils,
  {$ELSE}
  SysUtils,
  {$ENDIF}
  oldCEFLibFunctions, oldCEFMiscFunctions, oldCEFCommandLine, oldCEFConstants,
  oldCEFBrowserProcessHandler, oldCEFResourceBundleHandler, oldCEFRenderProcessHandler;


// TOldCefAppOwn

procedure cef_app_on_before_command_line_processing(self: POldCefApp;
                                                    const process_type: POldCefString;
                                                          command_line: POldCefCommandLine); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefAppOwn) then
    TOldCefAppOwn(TempObject).OnBeforeCommandLineProcessing(CefString(process_type),
                                                         TOldCefCommandLineRef.UnWrap(command_line));
end;

procedure cef_app_on_register_custom_schemes(self: POldCefApp; registrar: POldCefSchemeRegistrar); stdcall;
var
  TempObject : TObject;
begin
  try
    TempObject := CefGetObject(self);

    if (TempObject <> nil) and (TempObject is TOldCefAppOwn) then
      TOldCefAppOwn(TempObject).OnRegisterCustomSchemes(TOldCefSchemeRegistrarRef.UnWrap(registrar));
  except
    on e : exception do
      if CustomExceptionHandler('cef_app_on_register_custom_schemes', e) then raise;
  end;
end;

function cef_app_get_resource_bundle_handler(self: POldCefApp): POldCefResourceBundleHandler; stdcall;
var
  TempObject  : TObject;
  TempHandler : IOldCefResourceBundleHandler;
begin
  Result      := nil;
  TempHandler := nil;
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefAppOwn) then
    try
      TOldCefAppOwn(TempObject).GetResourceBundleHandler(TempHandler);
      if (TempHandler <> nil) then Result := TempHandler.Wrap;
    finally
      TempHandler := nil;
    end;
end;

function cef_app_get_browser_process_handler(self: POldCefApp): POldCefBrowserProcessHandler; stdcall;
var
  TempObject  : TObject;
  TempHandler : IOldCefBrowserProcessHandler;
begin
  Result      := nil;
  TempHandler := nil;
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefAppOwn) then
    try
      TOldCefAppOwn(TempObject).GetBrowserProcessHandler(TempHandler);
      if (TempHandler <> nil) then Result := TempHandler.Wrap;
    finally
      TempHandler := nil;
    end;
end;

function cef_app_get_render_process_handler(self: POldCefApp): POldCefRenderProcessHandler; stdcall;
var
  TempObject  : TObject;
  TempHandler : IOldCefRenderProcessHandler;
begin
  Result      := nil;
  TempHandler := nil;
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefAppOwn) then
    try
      TOldCefAppOwn(TempObject).GetRenderProcessHandler(TempHandler);
      if (TempHandler <> nil) then Result := TempHandler.Wrap;
    finally
      TempHandler := nil;
    end;
end;

constructor TOldCefAppOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefApp));

  with POldCefApp(FData)^ do
    begin
      on_before_command_line_processing := cef_app_on_before_command_line_processing;
      on_register_custom_schemes        := cef_app_on_register_custom_schemes;
      get_resource_bundle_handler       := cef_app_get_resource_bundle_handler;
      get_browser_process_handler       := cef_app_get_browser_process_handler;
      get_render_process_handler        := cef_app_get_render_process_handler;
    end;
end;


// TCustomCefApp


constructor TOldCustomCefApp.Create(const aCefApp : TOldCefApplication);
begin
  inherited Create;

  FCefApp := aCefApp;

  InitializeVars;

  if (FCefApp <> nil) then
    begin
      if FCefApp.MustCreateBrowserProcessHandler then
        FBrowserProcessHandler := TOldCefCustomBrowserProcessHandler.Create(FCefApp);

      if FCefApp.MustCreateResourceBundleHandler then
        FResourceBundleHandler := TOldCefCustomResourceBundleHandler.Create(FCefApp);

      if FCefApp.MustCreateRenderProcessHandler then
        FRenderProcessHandler  := TOldCefCustomRenderProcessHandler.Create(FCefApp);
    end;
end;

procedure TOldCustomCefApp.BeforeDestruction;
begin
  FCefApp := nil;

  InitializeVars;

  inherited BeforeDestruction;
end;

procedure TOldCustomCefApp.InitializeVars;
begin
  FResourceBundleHandler := nil;
  FBrowserProcessHandler := nil;
  FRenderProcessHandler  := nil;
end;

procedure TOldCustomCefApp.OnBeforeCommandLineProcessing(const processType: oldustring; const commandLine: IOldCefCommandLine);
begin
  try
    if (FCefApp <> nil) then FCefApp.Internal_OnBeforeCommandLineProcessing(processType, commandLine);
  except
    on e : exception do
      if CustomExceptionHandler('TCustomCefApp.OnBeforeCommandLineProcessing', e) then raise;
  end;
end;

procedure TOldCustomCefApp.OnRegisterCustomSchemes(const registrar: IOldCefSchemeRegistrar);
begin
  try
    if (FCefApp <> nil) then FCefApp.Internal_OnRegisterCustomSchemes(registrar);
  except
    on e : exception do
      if CustomExceptionHandler('TCustomCefApp.OnRegisterCustomSchemes', e) then raise;
  end;
end;

procedure TOldCustomCefApp.GetResourceBundleHandler(var aHandler : IOldCefResourceBundleHandler);
begin
  if (FResourceBundleHandler <> nil) then
    aHandler := FResourceBundleHandler
   else
    aHandler := nil;
end;

procedure TOldCustomCefApp.GetBrowserProcessHandler(var aHandler : IOldCefBrowserProcessHandler);
begin
  if (FBrowserProcessHandler <> nil) then
    aHandler := FBrowserProcessHandler
   else
    aHandler := nil;
end;

procedure TOldCustomCefApp.GetRenderProcessHandler(var aHandler : IOldCefRenderProcessHandler);
begin
  if (FRenderProcessHandler <> nil) then
    aHandler := FRenderProcessHandler
   else
    aHandler := nil;
end;

end.
