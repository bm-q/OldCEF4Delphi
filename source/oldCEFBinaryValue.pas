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

unit oldCEFBinaryValue;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefBinaryValueRef = class(TOldCefBaseRef, IOldCefBinaryValue)
    protected
      function IsValid: Boolean;
      function IsOwned: Boolean;
      function IsSame(const that: IOldCefBinaryValue): Boolean;
      function IsEqual(const that: IOldCefBinaryValue): Boolean;
      function Copy: IOldCefBinaryValue;
      function GetSize: NativeUInt;
      function GetData(buffer: Pointer; bufferSize, dataOffset: NativeUInt): NativeUInt;

    public
      class function UnWrap(data: Pointer): IOldCefBinaryValue;
      class function New(const data: Pointer; dataSize: NativeUInt): IOldCefBinaryValue;
  end;

  TOldCefBinaryValueOwn = class(TOldCefBaseOwn, IOldCefBinaryValue)
    protected
      function IsValid: Boolean;
      function IsOwned: Boolean;
      function IsSame(const that: IOldCefBinaryValue): Boolean;
      function IsEqual(const that: IOldCefBinaryValue): Boolean;
      function Copy: IOldCefBinaryValue;
      function GetSize: NativeUInt;
      function GetData(buffer: Pointer; bufferSize, dataOffset: NativeUInt): NativeUInt;

    public
      constructor Create;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions;


// **********************************************
// **********  TOldCefBinaryValueRef  **************
// **********************************************


function TOldCefBinaryValueRef.Copy: IOldCefBinaryValue;
begin
  Result := UnWrap(POldCefBinaryValue(FData).copy(POldCefBinaryValue(FData)));
end;

function TOldCefBinaryValueRef.GetData(buffer: Pointer; bufferSize,
  dataOffset: NativeUInt): NativeUInt;
begin
  Result := POldCefBinaryValue(FData).get_data(POldCefBinaryValue(FData), buffer, bufferSize, dataOffset);
end;

function TOldCefBinaryValueRef.GetSize: NativeUInt;
begin
  Result := POldCefBinaryValue(FData).get_size(POldCefBinaryValue(FData));
end;

function TOldCefBinaryValueRef.IsEqual(const that: IOldCefBinaryValue): Boolean;
begin
  Result := POldCefBinaryValue(FData).is_equal(POldCefBinaryValue(FData), CefGetData(that)) <> 0;
end;

function TOldCefBinaryValueRef.IsOwned: Boolean;
begin
  Result := POldCefBinaryValue(FData).is_owned(POldCefBinaryValue(FData)) <> 0;
end;

function TOldCefBinaryValueRef.IsSame(const that: IOldCefBinaryValue): Boolean;
begin
  Result := POldCefBinaryValue(FData).is_same(POldCefBinaryValue(FData), CefGetData(that)) <> 0;
end;

function TOldCefBinaryValueRef.IsValid: Boolean;
begin
  Result := POldCefBinaryValue(FData).is_valid(POldCefBinaryValue(FData)) <> 0;
end;

class function TOldCefBinaryValueRef.New(const data: Pointer; dataSize: NativeUInt): IOldCefBinaryValue;
begin
  Result := UnWrap(cef_binary_value_create(data, dataSize));
end;

class function TOldCefBinaryValueRef.UnWrap(data: Pointer): IOldCefBinaryValue;
begin
  if data <> nil then
    Result := Create(data) as IOldCefBinaryValue else
    Result := nil;
end;


// **********************************************
// **********  TOldCefBinaryValueOwn  **************
// **********************************************

function cef_binary_value_is_valid(self: POldCefBinaryValue): Integer; stdcall;
var
  TempObject  : TObject;
begin
  Result      := Ord(False);
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefBinaryValueOwn) then
    Result := Ord(TOldCefBinaryValueOwn(TempObject).IsValid);
end;

function cef_binary_value_is_owned(self: POldCefBinaryValue): Integer; stdcall;
var
  TempObject  : TObject;
begin
  Result      := Ord(False);
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefBinaryValueOwn) then
    Result := Ord(TOldCefBinaryValueOwn(TempObject).IsOwned);
end;

function cef_binary_value_is_same(self, that: POldCefBinaryValue):Integer; stdcall;
var
  TempObject  : TObject;
begin
  Result      := Ord(False);
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefBinaryValueOwn) then
    Result := Ord(TOldCefBinaryValueOwn(TempObject).IsSame(TOldCefBinaryValueRef.UnWrap(that)));
end;

function cef_binary_value_is_equal(self, that: POldCefBinaryValue): Integer; stdcall;
var
  TempObject  : TObject;
begin
  Result      := Ord(False);
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefBinaryValueOwn) then
    Result := Ord(TOldCefBinaryValueOwn(TempObject).IsEqual(TOldCefBinaryValueRef.UnWrap(that)));
end;

function cef_binary_value_copy(self: POldCefBinaryValue): POldCefBinaryValue; stdcall;
var
  TempObject  : TObject;
begin
  Result      := nil;
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefBinaryValueOwn) then
    Result := CefGetData(TOldCefBinaryValueOwn(TempObject).Copy);
end;

function cef_binary_value_get_size(self: POldCefBinaryValue): NativeUInt; stdcall;
var
  TempObject  : TObject;
begin
  Result      := 0;
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefBinaryValueOwn) then
    Result := TOldCefBinaryValueOwn(TempObject).GetSize;
end;

function cef_binary_value_get_data(self: POldCefBinaryValue; buffer: Pointer; buffer_size, data_offset: NativeUInt): NativeUInt; stdcall;
var
  TempObject  : TObject;
begin
  Result      := 0;
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefBinaryValueOwn) then
    Result := TOldCefBinaryValueOwn(TempObject).GetData(buffer, buffer_size, data_offset);
end;

constructor TOldCefBinaryValueOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefBinaryValue));

  with POldCefBinaryValue(FData)^ do
    begin
      is_valid := cef_binary_value_is_valid;
      is_owned := cef_binary_value_is_owned;
      is_same  := cef_binary_value_is_same;
      is_equal := cef_binary_value_is_equal;
      copy     := cef_binary_value_copy;
      get_size := cef_binary_value_get_size;
      get_data := cef_binary_value_get_data;
    end;
end;

function TOldCefBinaryValueOwn.IsValid: Boolean;
begin
  Result := False;
end;

function TOldCefBinaryValueOwn.IsOwned: Boolean;
begin
  Result := False;
end;

function TOldCefBinaryValueOwn.IsSame(const that: IOldCefBinaryValue): Boolean;
begin
  Result := False;
end;

function TOldCefBinaryValueOwn.IsEqual(const that: IOldCefBinaryValue): Boolean;
begin
  Result := False;
end;

function TOldCefBinaryValueOwn.Copy: IOldCefBinaryValue;
begin
  Result := nil;
end;

function TOldCefBinaryValueOwn.GetSize: NativeUInt;
begin
  Result := 0;
end;

function TOldCefBinaryValueOwn.GetData(buffer: Pointer; bufferSize, dataOffset: NativeUInt): NativeUInt;
begin
  Result := 0;
end;


end.
