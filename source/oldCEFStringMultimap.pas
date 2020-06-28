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

unit oldCEFStringMultimap;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefCustomStringMultimap = class(TInterfacedObject, IOldCefStringMultimap)
    protected
      FHandle : TOldCefStringMultimap;

      function  GetHandle: TOldCefStringMultimap; virtual;
      function  GetSize: integer; virtual;
      function  FindCount(const Key: oldustring): integer; virtual;
      function  GetEnumerate(const Key: oldustring; ValueIndex: integer): oldustring; virtual;
      function  GetKey(Index: integer): oldustring; virtual;
      function  GetValue(Index: integer): oldustring; virtual;
      function  Append(const Key, Value: oldustring) : boolean; virtual;
      procedure Clear; virtual;

    public
      constructor Create; virtual;
  end;

  TOldCefStringMultimapOwn = class(TOldCefCustomStringMultimap)
    public
      constructor Create; override;
      destructor  Destroy; override;
  end;

  TOldCefStringMultimapRef = class(TOldCefCustomStringMultimap)
    public
      constructor Create(aHandle : TOldCefStringMultimap); reintroduce;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions;


// *********************************************
// ********* TOldCefCustomStringMultimap **********
// *********************************************


constructor TOldCefCustomStringMultimap.Create;
begin
  inherited Create;

  FHandle := nil;
end;

function TOldCefCustomStringMultimap.Append(const Key, Value: oldustring) : boolean;
var
  TempKey, TempValue : TOldCefString;
begin
  if (FHandle <> nil) then
    begin
      TempKey   := CefString(key);
      TempValue := CefString(value);
      Result    := (cef_string_multimap_append(FHandle, @TempKey, @TempValue) <> 0);
    end
   else
    Result := False;
end;

procedure TOldCefCustomStringMultimap.Clear;
begin
  if (FHandle <> nil) then cef_string_multimap_clear(FHandle);
end;

function TOldCefCustomStringMultimap.FindCount(const Key: oldustring): integer;
var
  TempKey : TOldCefString;
begin
  if (FHandle <> nil) then
    begin
      TempKey := CefString(Key);
      Result  := cef_string_multimap_find_count(FHandle, @TempKey);
    end
   else
    Result := 0;
end;

function TOldCefCustomStringMultimap.GetEnumerate(const Key: oldustring; ValueIndex: integer): oldustring;
var
  TempKey, TempValue : TOldCefString;
begin
  Result := '';

  if (FHandle <> nil) then
    begin
      TempKey := CefString(Key);
      FillChar(TempValue, SizeOf(TempValue), 0);

      if (cef_string_multimap_enumerate(FHandle, @TempKey, ValueIndex, TempValue) <> 0) then
        Result := CefString(@TempValue);
    end;
end;

function TOldCefCustomStringMultimap.GetHandle: TOldCefStringMultimap;
begin
  Result := FHandle;
end;

function TOldCefCustomStringMultimap.GetKey(Index: integer): oldustring;
var
  TempKey : TOldCefString;
begin
  Result := '';

  if (FHandle <> nil) then
    begin
      FillChar(TempKey, SizeOf(TempKey), 0);

      if (cef_string_multimap_key(FHandle, index, TempKey) <> 0) then
        Result := CefString(@TempKey);
    end;
end;

function TOldCefCustomStringMultimap.GetSize: integer;
begin
  if (FHandle <> nil) then
    Result := cef_string_multimap_size(FHandle)
   else
    Result := 0;
end;

function TOldCefCustomStringMultimap.GetValue(Index: integer): oldustring;
var
  TempValue : TOldCefString;
begin
  Result := '';

  if (FHandle <> nil) then
    begin
      FillChar(TempValue, SizeOf(TempValue), 0);

      if (cef_string_multimap_value(FHandle, index, TempValue) <> 0) then
        Result := CefString(@TempValue);
    end;
end;


// ******************************************
// ********* TOldCefStringMultimapOwn **********
// ******************************************


constructor TOldCefStringMultimapOwn.Create;
begin
  inherited Create;

  FHandle := cef_string_multimap_alloc;
end;

destructor TOldCefStringMultimapOwn.Destroy;
begin
  if (FHandle <> nil) then cef_string_multimap_free(FHandle);

  inherited Destroy;
end;


// ******************************************
// ********* TOldCefStringMultimapRef **********
// ******************************************


constructor TOldCefStringMultimapRef.Create(aHandle : TOldCefStringMultimap);
begin
  inherited Create;

  FHandle := aHandle;
end;

end.
