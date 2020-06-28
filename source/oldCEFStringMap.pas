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

unit oldCEFStringMap;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefCustomStringMap = class(TInterfacedObject, IOldCefStringMap)
    protected
      FHandle : TOldCefStringMap;

      function  GetHandle: TOldCefStringMap; virtual;
      function  GetSize: integer; virtual;
      function  Find(const key: oldustring): oldustring; virtual;
      function  GetKey(index: integer): oldustring; virtual;
      function  GetValue(index: integer): oldustring; virtual;
      function  Append(const key, value: oldustring) : boolean; virtual;
      procedure Clear; virtual;

    public
      constructor Create; virtual;
  end;

  TOldCefStringMapOwn = class(TOldCefCustomStringMap)
    public
      constructor Create; override;
      destructor  Destroy; override;
  end;

  TOldCefStringMapRef = class(TOldCefCustomStringMap)
    public
      constructor Create(aHandle : TOldCefStringMap); reintroduce;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions;


// ****************************************
// ********* TOldCefCustomStringMap **********
// ****************************************


constructor TOldCefCustomStringMap.Create;
begin
  inherited Create;

  FHandle := nil;
end;

function TOldCefCustomStringMap.Append(const key, value: oldustring) : boolean;
var
  TempKey, TempValue : TOldCefString;
begin
  if (FHandle <> nil) then
    begin
      TempKey   := CefString(key);
      TempValue := CefString(value);
      Result    := cef_string_map_append(FHandle, @TempKey, @TempValue) <> 0;
    end
   else
    Result := False;
end;

procedure TOldCefCustomStringMap.Clear;
begin
  if (FHandle <> nil) then cef_string_map_clear(FHandle);
end;

function TOldCefCustomStringMap.Find(const key: oldustring): oldustring;
var
  TempKey, TempValue : TOldCefString;
begin
  Result := '';

  if (FHandle <> nil) then
    begin
      FillChar(TempValue, SizeOf(TempValue), 0);
      TempKey := CefString(key);

      if (cef_string_map_find(FHandle, @TempKey, TempValue) <> 0) then
        Result := CefString(@TempValue);
    end;
end;

function TOldCefCustomStringMap.GetHandle: TOldCefStringMap;
begin
  Result := FHandle;
end;

function TOldCefCustomStringMap.GetKey(index: integer): oldustring;
var
  TempKey : TOldCefString;
begin
  Result := '';

  if (FHandle <> nil) then
    begin
      FillChar(TempKey, SizeOf(TempKey), 0);

      if (cef_string_map_key(FHandle, index, TempKey) <> 0) then
        Result := CefString(@TempKey);
    end;
end;

function TOldCefCustomStringMap.GetSize: integer;
begin
  if (FHandle <> nil) then
    Result := cef_string_map_size(FHandle)
   else
    Result := 0;
end;

function TOldCefCustomStringMap.GetValue(index: integer): oldustring;
var
  TempValue : TOldCefString;
begin
  Result := '';

  if (FHandle <> nil) then
    begin
      FillChar(TempValue, SizeOf(TempValue), 0);

      if (cef_string_map_value(FHandle, index, TempValue) <> 0) then
        Result := CefString(@TempValue);
    end;
end;


// **************************************
// ********* TOldCefStringMapOwn ***********
// **************************************


constructor TOldCefStringMapOwn.Create;
begin
  inherited Create;

  FHandle := cef_string_map_alloc;
end;

destructor TOldCefStringMapOwn.Destroy;
begin
  if (FHandle <> nil) then cef_string_map_free(FHandle);

  inherited Destroy;
end;


// **************************************
// ********* TOldCefStringMapRef ***********
// **************************************


constructor TOldCefStringMapRef.Create(aHandle : TOldCefStringMap);
begin
  inherited Create;

  FHandle := aHandle;
end;

end.
