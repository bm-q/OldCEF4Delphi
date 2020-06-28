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

unit oldCEFDictionaryValue;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
  System.Classes, System.SysUtils,
  {$ELSE}
  Classes, SysUtils,
  {$ENDIF}
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefDictionaryValueRef = class(TOldCefBaseRef, IOldCefDictionaryValue)
    protected
      function IsValid: Boolean;
      function isOwned: Boolean;
      function IsReadOnly: Boolean;
      function IsSame(const that: IOldCefDictionaryValue): Boolean;
      function IsEqual(const that: IOldCefDictionaryValue): Boolean;
      function Copy(excludeEmptyChildren: Boolean): IOldCefDictionaryValue;
      function GetSize: NativeUInt;
      function Clear: Boolean;
      function HasKey(const key: oldustring): Boolean;
      function GetKeys(const keys: TStrings): Boolean;
      function Remove(const key: oldustring): Boolean;
      function GetType(const key: oldustring): TOldCefValueType;
      function GetValue(const key: oldustring): IOldCefValue;
      function GetBool(const key: oldustring): Boolean;
      function GetInt(const key: oldustring): Integer;
      function GetDouble(const key: oldustring): Double;
      function GetString(const key: oldustring): oldustring;
      function GetBinary(const key: oldustring): IOldCefBinaryValue;
      function GetDictionary(const key: oldustring): IOldCefDictionaryValue;
      function GetList(const key: oldustring): IOldCefListValue;
      function SetValue(const key: oldustring; const value: IOldCefValue): Boolean;
      function SetNull(const key: oldustring): Boolean;
      function SetBool(const key: oldustring; value: Boolean): Boolean;
      function SetInt(const key: oldustring; value: Integer): Boolean;
      function SetDouble(const key: oldustring; value: Double): Boolean;
      function SetString(const key, value: oldustring): Boolean;
      function SetBinary(const key: oldustring; const value: IOldCefBinaryValue): Boolean;
      function SetDictionary(const key: oldustring; const value: IOldCefDictionaryValue): Boolean;
      function SetList(const key: oldustring; const value: IOldCefListValue): Boolean;

    public
      class function UnWrap(data: Pointer): IOldCefDictionaryValue;
      class function New: IOldCefDictionaryValue;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFBinaryValue, oldCEFListValue, oldCEFValue, oldCEFStringList;

function TOldCefDictionaryValueRef.Clear: Boolean;
begin
  Result := POldCefDictionaryValue(FData).clear(POldCefDictionaryValue(FData)) <> 0;
end;

function TOldCefDictionaryValueRef.Copy(excludeEmptyChildren: Boolean): IOldCefDictionaryValue;
begin
  Result := UnWrap(POldCefDictionaryValue(FData).copy(POldCefDictionaryValue(FData), Ord(excludeEmptyChildren)));
end;

function TOldCefDictionaryValueRef.GetBinary(const key: oldustring): IOldCefBinaryValue;
var
  k: TOldCefString;
begin
  k := CefString(key);
  Result := TOldCefBinaryValueRef.UnWrap(POldCefDictionaryValue(FData).get_binary(POldCefDictionaryValue(FData), @k));
end;

function TOldCefDictionaryValueRef.GetBool(const key: oldustring): Boolean;
var
  k: TOldCefString;
begin
  k := CefString(key);
  Result := POldCefDictionaryValue(FData).get_bool(POldCefDictionaryValue(FData), @k) <> 0;
end;

function TOldCefDictionaryValueRef.GetDictionary(const key: oldustring): IOldCefDictionaryValue;
var
  k: TOldCefString;
begin
  k := CefString(key);
  Result := UnWrap(POldCefDictionaryValue(FData).get_dictionary(POldCefDictionaryValue(FData), @k));
end;

function TOldCefDictionaryValueRef.GetDouble(const key: oldustring): Double;
var
  k: TOldCefString;
begin
  k := CefString(key);
  Result := POldCefDictionaryValue(FData).get_double(POldCefDictionaryValue(FData), @k);
end;

function TOldCefDictionaryValueRef.GetInt(const key: oldustring): Integer;
var
  k: TOldCefString;
begin
  k := CefString(key);
  Result := POldCefDictionaryValue(FData).get_int(POldCefDictionaryValue(FData), @k);
end;

function TOldCefDictionaryValueRef.GetKeys(const keys : TStrings): Boolean;
var
  TempSL : IOldCefStringList;
begin
  Result := False;

  if (keys <> nil) then
    begin
      TempSL := TOldCefStringListOwn.Create;

      if (POldCefDictionaryValue(FData).get_keys(POldCefDictionaryValue(FData), TempSL.Handle) <> 0) then
        begin
          TempSL.CopyToStrings(keys);
          Result := True;
        end;
    end;
end;

function TOldCefDictionaryValueRef.GetList(const key: oldustring): IOldCefListValue;
var
  k: TOldCefString;
begin
  k := CefString(key);
  Result := TOldCefListValueRef.UnWrap(POldCefDictionaryValue(FData).get_list(POldCefDictionaryValue(FData), @k));
end;

function TOldCefDictionaryValueRef.GetSize: NativeUInt;
begin
  Result := POldCefDictionaryValue(FData).get_size(POldCefDictionaryValue(FData));
end;

function TOldCefDictionaryValueRef.GetString(const key: oldustring): oldustring;
var
  k: TOldCefString;
begin
  k := CefString(key);
  Result := CefStringFreeAndGet(POldCefDictionaryValue(FData).get_string(POldCefDictionaryValue(FData), @k));
end;

function TOldCefDictionaryValueRef.GetType(const key: oldustring): TOldCefValueType;
var
  k: TOldCefString;
begin
  k := CefString(key);
  Result := POldCefDictionaryValue(FData).get_type(POldCefDictionaryValue(FData), @k);
end;

function TOldCefDictionaryValueRef.GetValue(const key: oldustring): IOldCefValue;
var
  k: TOldCefString;
begin
  k := CefString(key);
  Result := TOldCefValueRef.UnWrap(POldCefDictionaryValue(FData).get_value(POldCefDictionaryValue(FData), @k));
end;

function TOldCefDictionaryValueRef.HasKey(const key: oldustring): Boolean;
var
  k: TOldCefString;
begin
  k := CefString(key);
  Result := POldCefDictionaryValue(FData).has_key(POldCefDictionaryValue(FData), @k) <> 0;
end;

function TOldCefDictionaryValueRef.IsEqual(
  const that: IOldCefDictionaryValue): Boolean;
begin
  Result := POldCefDictionaryValue(FData).is_equal(POldCefDictionaryValue(FData), CefGetData(that)) <> 0;
end;

function TOldCefDictionaryValueRef.isOwned: Boolean;
begin
  Result := POldCefDictionaryValue(FData).is_owned(POldCefDictionaryValue(FData)) <> 0;
end;

function TOldCefDictionaryValueRef.IsReadOnly: Boolean;
begin
  Result := POldCefDictionaryValue(FData).is_read_only(POldCefDictionaryValue(FData)) <> 0;
end;

function TOldCefDictionaryValueRef.IsSame(
  const that: IOldCefDictionaryValue): Boolean;
begin
  Result := POldCefDictionaryValue(FData).is_same(POldCefDictionaryValue(FData), CefGetData(that)) <> 0;
end;

function TOldCefDictionaryValueRef.IsValid: Boolean;
begin
  Result := POldCefDictionaryValue(FData).is_valid(POldCefDictionaryValue(FData)) <> 0;
end;

class function TOldCefDictionaryValueRef.New: IOldCefDictionaryValue;
begin
  Result := UnWrap(cef_dictionary_value_create);
end;

function TOldCefDictionaryValueRef.Remove(const key: oldustring): Boolean;
var
  k: TOldCefString;
begin
  k := CefString(key);
  Result := POldCefDictionaryValue(FData).remove(POldCefDictionaryValue(FData), @k) <> 0;
end;

function TOldCefDictionaryValueRef.SetBinary(const key: oldustring; const value: IOldCefBinaryValue): Boolean;
var
  k: TOldCefString;
begin
  k := CefString(key);
  Result := POldCefDictionaryValue(FData).set_binary(POldCefDictionaryValue(FData), @k, CefGetData(value)) <> 0;
end;

function TOldCefDictionaryValueRef.SetBool(const key: oldustring; value: Boolean): Boolean;
var
  k: TOldCefString;
begin
  k := CefString(key);
  Result := POldCefDictionaryValue(FData).set_bool(POldCefDictionaryValue(FData), @k, Ord(value)) <> 0;
end;

function TOldCefDictionaryValueRef.SetDictionary(const key: oldustring; const value: IOldCefDictionaryValue): Boolean;
var
  k: TOldCefString;
begin
  k := CefString(key);
  Result := POldCefDictionaryValue(FData).set_dictionary(POldCefDictionaryValue(FData), @k, CefGetData(value)) <> 0;
end;

function TOldCefDictionaryValueRef.SetDouble(const key: oldustring;
  value: Double): Boolean;
var
  k: TOldCefString;
begin
  k := CefString(key);
  Result := POldCefDictionaryValue(FData).set_double(POldCefDictionaryValue(FData), @k, value) <> 0;
end;

function TOldCefDictionaryValueRef.SetInt(const key: oldustring; value: Integer): Boolean;
var
  k: TOldCefString;
begin
  k := CefString(key);
  Result := POldCefDictionaryValue(FData).set_int(POldCefDictionaryValue(FData), @k, value) <> 0;
end;

function TOldCefDictionaryValueRef.SetList(const key: oldustring; const value: IOldCefListValue): Boolean;
var
  k: TOldCefString;
begin
  k := CefString(key);
  Result := POldCefDictionaryValue(FData).set_list(POldCefDictionaryValue(FData), @k, CefGetData(value)) <> 0;
end;

function TOldCefDictionaryValueRef.SetNull(const key: oldustring): Boolean;
var
  k: TOldCefString;
begin
  k := CefString(key);
  Result := POldCefDictionaryValue(FData).set_null(POldCefDictionaryValue(FData), @k) <> 0;
end;

function TOldCefDictionaryValueRef.SetString(const key, value: oldustring): Boolean;
var
  k, v: TOldCefString;
begin
  k := CefString(key);
  v := CefString(value);
  Result := POldCefDictionaryValue(FData).set_string(POldCefDictionaryValue(FData), @k, @v) <> 0;
end;

function TOldCefDictionaryValueRef.SetValue(const key: oldustring;
  const value: IOldCefValue): Boolean;
var
  k: TOldCefString;
begin
  k := CefString(key);
  Result := POldCefDictionaryValue(FData).set_value(POldCefDictionaryValue(FData), @k, CefGetData(value)) <> 0;
end;

class function TOldCefDictionaryValueRef.UnWrap(
  data: Pointer): IOldCefDictionaryValue;
begin
  if data <> nil then
    Result := Create(data) as IOldCefDictionaryValue else
    Result := nil;
end;

end.
