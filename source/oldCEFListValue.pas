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

unit oldCEFListValue;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefListValueRef = class(TOldCefBaseRef, IOldCefListValue)
    protected
      function IsValid: Boolean;
      function IsOwned: Boolean;
      function IsReadOnly: Boolean;
      function IsSame(const that: IOldCefListValue): Boolean;
      function IsEqual(const that: IOldCefListValue): Boolean;
      function Copy: IOldCefListValue;
      function SetSize(size: NativeUInt): Boolean;
      function GetSize: NativeUInt;
      function Clear: Boolean;
      function Remove(index: Integer): Boolean;
      function GetType(index: Integer): TOldCefValueType;
      function GetValue(index: Integer): IOldCefValue;
      function GetBool(index: Integer): Boolean;
      function GetInt(index: Integer): Integer;
      function GetDouble(index: Integer): Double;
      function GetString(index: Integer): oldustring;
      function GetBinary(index: Integer): IOldCefBinaryValue;
      function GetDictionary(index: Integer): IOldCefDictionaryValue;
      function GetList(index: Integer): IOldCefListValue;
      function SetValue(index: Integer; const value: IOldCefValue): Boolean;
      function SetNull(index: Integer): Boolean;
      function SetBool(index: Integer; value: Boolean): Boolean;
      function SetInt(index: Integer; value: Integer): Boolean;
      function SetDouble(index: Integer; value: Double): Boolean;
      function SetString(index: Integer; const value: oldustring): Boolean;
      function SetBinary(index: Integer; const value: IOldCefBinaryValue): Boolean;
      function SetDictionary(index: Integer; const value: IOldCefDictionaryValue): Boolean;
      function SetList(index: Integer; const value: IOldCefListValue): Boolean;

    public
      class function UnWrap(data: Pointer): IOldCefListValue;
      class function New: IOldCefListValue;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFBinaryValue, oldCEFValue, oldCEFDictionaryValue;

function TOldCefListValueRef.Clear: Boolean;
begin
  Result := POldCefListValue(FData).clear(POldCefListValue(FData)) <> 0;
end;

function TOldCefListValueRef.Copy: IOldCefListValue;
begin
  Result := UnWrap(POldCefListValue(FData).copy(POldCefListValue(FData)));
end;

class function TOldCefListValueRef.New: IOldCefListValue;
begin
  Result := UnWrap(cef_list_value_create);
end;

function TOldCefListValueRef.GetBinary(index: Integer): IOldCefBinaryValue;
begin
  Result := TOldCefBinaryValueRef.UnWrap(POldCefListValue(FData).get_binary(POldCefListValue(FData), index));
end;

function TOldCefListValueRef.GetBool(index: Integer): Boolean;
begin
  Result := POldCefListValue(FData).get_bool(POldCefListValue(FData), index) <> 0;
end;

function TOldCefListValueRef.GetDictionary(index: Integer): IOldCefDictionaryValue;
begin
  Result := TOldCefDictionaryValueRef.UnWrap(POldCefListValue(FData).get_dictionary(POldCefListValue(FData), index));
end;

function TOldCefListValueRef.GetDouble(index: Integer): Double;
begin
  Result := POldCefListValue(FData).get_double(POldCefListValue(FData), index);
end;

function TOldCefListValueRef.GetInt(index: Integer): Integer;
begin
  Result := POldCefListValue(FData).get_int(POldCefListValue(FData), index);
end;

function TOldCefListValueRef.GetList(index: Integer): IOldCefListValue;
begin
  Result := UnWrap(POldCefListValue(FData).get_list(POldCefListValue(FData), index));
end;

function TOldCefListValueRef.GetSize: NativeUInt;
begin
  Result := POldCefListValue(FData).get_size(POldCefListValue(FData));
end;

function TOldCefListValueRef.GetString(index: Integer): oldustring;
begin
  Result := CefStringFreeAndGet(POldCefListValue(FData).get_string(POldCefListValue(FData), index));
end;

function TOldCefListValueRef.GetType(index: Integer): TOldCefValueType;
begin
  Result := POldCefListValue(FData).get_type(POldCefListValue(FData), index);
end;

function TOldCefListValueRef.GetValue(index: Integer): IOldCefValue;
begin
  Result := TOldCefValueRef.UnWrap(POldCefListValue(FData).get_value(POldCefListValue(FData), index));
end;

function TOldCefListValueRef.IsEqual(const that: IOldCefListValue): Boolean;
begin
  Result := POldCefListValue(FData).is_equal(POldCefListValue(FData), CefGetData(that)) <> 0;
end;

function TOldCefListValueRef.IsOwned: Boolean;
begin
  Result := POldCefListValue(FData).is_owned(POldCefListValue(FData)) <> 0;
end;

function TOldCefListValueRef.IsReadOnly: Boolean;
begin
  Result := POldCefListValue(FData).is_read_only(POldCefListValue(FData)) <> 0;
end;

function TOldCefListValueRef.IsSame(const that: IOldCefListValue): Boolean;
begin
  Result := POldCefListValue(FData).is_same(POldCefListValue(FData), CefGetData(that)) <> 0;
end;

function TOldCefListValueRef.IsValid: Boolean;
begin
  Result := POldCefListValue(FData).is_valid(POldCefListValue(FData)) <> 0;
end;

function TOldCefListValueRef.Remove(index: Integer): Boolean;
begin
  Result := POldCefListValue(FData).remove(POldCefListValue(FData), index) <> 0;
end;

function TOldCefListValueRef.SetBinary(index: Integer; const value: IOldCefBinaryValue): Boolean;
begin
  Result := POldCefListValue(FData).set_binary(POldCefListValue(FData), index, CefGetData(value)) <> 0;
end;

function TOldCefListValueRef.SetBool(index: Integer; value: Boolean): Boolean;
begin
  Result := POldCefListValue(FData).set_bool(POldCefListValue(FData), index, Ord(value)) <> 0;
end;

function TOldCefListValueRef.SetDictionary(index: Integer; const value: IOldCefDictionaryValue): Boolean;
begin
  Result := POldCefListValue(FData).set_dictionary(POldCefListValue(FData), index, CefGetData(value)) <> 0;
end;

function TOldCefListValueRef.SetDouble(index: Integer; value: Double): Boolean;
begin
  Result := POldCefListValue(FData).set_double(POldCefListValue(FData), index, value) <> 0;
end;

function TOldCefListValueRef.SetInt(index: Integer; value: Integer): Boolean;
begin
  Result := POldCefListValue(FData).set_int(POldCefListValue(FData), index, value) <> 0;
end;

function TOldCefListValueRef.SetList(index: Integer; const value: IOldCefListValue): Boolean;
begin
  Result := POldCefListValue(FData).set_list(POldCefListValue(FData), index, CefGetData(value)) <> 0;
end;

function TOldCefListValueRef.SetNull(index: Integer): Boolean;
begin
  Result := POldCefListValue(FData).set_null(POldCefListValue(FData), index) <> 0;
end;

function TOldCefListValueRef.SetSize(size: NativeUInt): Boolean;
begin
  Result := POldCefListValue(FData).set_size(POldCefListValue(FData), size) <> 0;
end;

function TOldCefListValueRef.SetString(index: Integer; const value: oldustring): Boolean;
var
  v: TOldCefString;
begin
  v := CefString(value);
  Result := POldCefListValue(FData).set_string(POldCefListValue(FData), index, @v) <> 0;
end;

function TOldCefListValueRef.SetValue(index: Integer; const value: IOldCefValue): Boolean;
begin
  Result := POldCefListValue(FData).set_value(POldCefListValue(FData), index, CefGetData(value)) <> 0;
end;

class function TOldCefListValueRef.UnWrap(data: Pointer): IOldCefListValue;
begin
  if data <> nil then
    Result := Create(data) as IOldCefListValue else
    Result := nil;
end;

end.
