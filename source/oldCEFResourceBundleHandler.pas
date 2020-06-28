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

unit oldCEFResourceBundleHandler;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes, oldCEFApplication;

type
  TOldCefResourceBundleHandlerOwn = class(TOldCefBaseOwn, IOldCefResourceBundleHandler)
    protected
      function GetLocalizedString(stringid: Integer; var stringVal: oldustring): Boolean; virtual; abstract;
      function GetDataResource(resourceId: Integer; var data: Pointer; var dataSize: NativeUInt): Boolean; virtual; abstract;
      function GetDataResourceForScale(resourceId: Integer; scaleFactor: TOldCefScaleFactor; var data: Pointer; var dataSize: NativeUInt): Boolean; virtual; abstract;

    public
      constructor Create; virtual;
  end;

  TOldCefCustomResourceBundleHandler = class(TOldCefResourceBundleHandlerOwn)
    protected
      FCefApp : TOldCefApplication;

      function GetLocalizedString(stringid: Integer; var stringVal: oldustring): Boolean; override;
      function GetDataResource(resourceId: Integer; var data: Pointer; var dataSize: NativeUInt): Boolean; override;
      function GetDataResourceForScale(resourceId: Integer; scaleFactor: TOldCefScaleFactor; var data: Pointer; var dataSize: NativeUInt): Boolean; override;

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
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFConstants;

function cef_resource_bundle_handler_get_localized_string(self       : POldCefResourceBundleHandler;
                                                          string_id  : Integer;
                                                          string_val : POldCefString): Integer; stdcall;
var
  TempString : oldustring;
  TempObject : TObject;
begin
  Result     := Ord(False);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefResourceBundleHandlerOwn) then
    begin
      TempString := '';
      Result     := Ord(TOldCefResourceBundleHandlerOwn(TempObject).GetLocalizedString(string_id, TempString));

      if (Result <> 0) then string_val^ := CefString(TempString);
    end;
end;

function cef_resource_bundle_handler_get_data_resource(    self        : POldCefResourceBundleHandler;
                                                           resource_id : Integer;
                                                       var data        : Pointer;
                                                       var data_size   : NativeUInt): Integer; stdcall;
var
  TempObject : TObject;
begin
  Result     := Ord(False);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefResourceBundleHandlerOwn) then
    Result := Ord(TOldCefResourceBundleHandlerOwn(TempObject).GetDataResource(resource_id, data, data_size));
end;

function cef_resource_bundle_handler_get_data_resource_for_scale(    self         : POldCefResourceBundleHandler;
                                                                     resource_id  : Integer;
                                                                     scale_factor : TOldCefScaleFactor;
                                                                 var data         : Pointer;
                                                                 var data_size    : NativeUInt): Integer; stdcall;
var
  TempObject : TObject;
begin
  Result     := Ord(False);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefResourceBundleHandlerOwn) then
    Result := Ord(TOldCefResourceBundleHandlerOwn(TempObject).GetDataResourceForScale(resource_id, scale_factor, data, data_size));
end;

constructor TOldCefResourceBundleHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefResourceBundleHandler));

  with POldCefResourceBundleHandler(FData)^ do
    begin
      get_localized_string        := cef_resource_bundle_handler_get_localized_string;
      get_data_resource           := cef_resource_bundle_handler_get_data_resource;
      get_data_resource_for_scale := cef_resource_bundle_handler_get_data_resource_for_scale;
    end;
end;


// TOldCefCustomResourceBundleHandler


constructor TOldCefCustomResourceBundleHandler.Create(const aCefApp : TOldCefApplication);
begin
  inherited Create;

  FCefApp := aCefApp;
end;

destructor TOldCefCustomResourceBundleHandler.Destroy;
begin
  FCefApp := nil;

  inherited Destroy;
end;

function TOldCefCustomResourceBundleHandler.GetLocalizedString(    stringid  : Integer;
                                                            var stringVal : oldustring): Boolean;
begin
  Result := False;

  try
    Result := (FCefApp <> nil) and FCefApp.Internal_GetLocalizedString(stringid, stringVal);
  except
    on e : exception do
      if CustomExceptionHandler('TOldCefCustomResourceBundleHandler.GetLocalizedString', e) then raise;
  end;
end;

function TOldCefCustomResourceBundleHandler.GetDataResource(    resourceId : Integer;
                                                         var data       : Pointer;
                                                         var dataSize   : NativeUInt): Boolean;
begin
  Result := False;

  try
    Result := (FCefApp <> nil) and FCefApp.Internal_GetDataResource(resourceId, data, dataSize);
  except
    on e : exception do
      if CustomExceptionHandler('TOldCefCustomResourceBundleHandler.GetDataResource', e) then raise;
  end;
end;

function TOldCefCustomResourceBundleHandler.GetDataResourceForScale(    resourceId  : Integer;
                                                                     scaleFactor : TOldCefScaleFactor;
                                                                 var data        : Pointer;
                                                                 var dataSize    : NativeUInt): Boolean;
begin
  Result := False;

  try
    Result := (FCefApp <> nil) and FCefApp.Internal_GetDataResourceForScale(resourceId, scaleFactor, data, dataSize);
  except
    on e : exception do
      if CustomExceptionHandler('TOldCefCustomResourceBundleHandler.GetDataResourceForScale', e) then raise;
  end;
end;

end.
