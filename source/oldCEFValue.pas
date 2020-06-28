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

unit oldCEFValue;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefValueRef = class(TOldCefBaseRef, IOldCefValue)
    protected
      function IsValid: Boolean;
      function IsOwned: Boolean;
      function IsReadOnly: Boolean;
      function IsSame(const that: IOldCefValue): Boolean;
      function IsEqual(const that: IOldCefValue): Boolean;
      function Copy: IOldCefValue;
      function GetType: TOldCefValueType;
      function GetBool: Boolean;
      function GetInt: Integer;
      function GetDouble: Double;
      function GetString: oldustring;
      function GetBinary: IOldCefBinaryValue;
      function GetDictionary: IOldCefDictionaryValue;
      function GetList: IOldCefListValue;
      function SetNull: Boolean;
      function SetBool(value: Integer): Boolean;
      function SetInt(value: Integer): Boolean;
      function SetDouble(value: Double): Boolean;
      function SetString(const value: oldustring): Boolean;
      function SetBinary(const value: IOldCefBinaryValue): Boolean;
      function SetDictionary(const value: IOldCefDictionaryValue): Boolean;
      function SetList(const value: IOldCefListValue): Boolean;

    public
      class function UnWrap(data: Pointer): IOldCefValue;
      class function New: IOldCefValue;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFBinaryValue, oldCEFListValue, oldCEFDictionaryValue;

function TOldCefValueRef.Copy: IOldCefValue;
begin
  Result := UnWrap(POldCefValue(FData).copy(POldCefValue(FData)));
end;

function TOldCefValueRef.GetBinary: IOldCefBinaryValue;
begin
  Result := TOldCefBinaryValueRef.UnWrap(POldCefValue(FData).get_binary(POldCefValue(FData)));
end;

function TOldCefValueRef.GetBool: Boolean;
begin
  Result := POldCefValue(FData).get_bool(POldCefValue(FData)) <> 0;
end;

function TOldCefValueRef.GetDictionary: IOldCefDictionaryValue;
begin
  Result := TOldCefDictionaryValueRef.UnWrap(POldCefValue(FData).get_dictionary(POldCefValue(FData)));
end;

function TOldCefValueRef.GetDouble: Double;
begin
  Result := POldCefValue(FData).get_double(POldCefValue(FData));
end;

function TOldCefValueRef.GetInt: Integer;
begin
  Result := POldCefValue(FData).get_int(POldCefValue(FData));
end;

function TOldCefValueRef.GetList: IOldCefListValue;
begin
  Result := TOldCefListValueRef.UnWrap(POldCefValue(FData).get_list(POldCefValue(FData)));
end;

function TOldCefValueRef.GetString: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefValue(FData).get_string(POldCefValue(FData)));
end;

function TOldCefValueRef.GetType: TOldCefValueType;
begin
  Result := POldCefValue(FData).get_type(POldCefValue(FData));
end;

function TOldCefValueRef.IsEqual(const that: IOldCefValue): Boolean;
begin
  Result := POldCefValue(FData).is_equal(POldCefValue(FData), CefGetData(that)) <> 0;
end;

function TOldCefValueRef.IsOwned: Boolean;
begin
  Result := POldCefValue(FData).is_owned(POldCefValue(FData)) <> 0;
end;

function TOldCefValueRef.IsReadOnly: Boolean;
begin
  Result := POldCefValue(FData).is_read_only(POldCefValue(FData)) <> 0;
end;

function TOldCefValueRef.IsSame(const that: IOldCefValue): Boolean;
begin
  Result := POldCefValue(FData).is_same(POldCefValue(FData), CefGetData(that)) <> 0;
end;

function TOldCefValueRef.IsValid: Boolean;
begin
  Result := POldCefValue(FData).is_valid(POldCefValue(FData)) <> 0;
end;

class function TOldCefValueRef.New: IOldCefValue;
begin
  Result := UnWrap(cef_value_create);
end;

function TOldCefValueRef.SetBinary(const value: IOldCefBinaryValue): Boolean;
begin
  Result := POldCefValue(FData).set_binary(POldCefValue(FData), CefGetData(value)) <> 0;
end;

function TOldCefValueRef.SetBool(value: Integer): Boolean;
begin
  Result := POldCefValue(FData).set_bool(POldCefValue(FData), value) <> 0;
end;

function TOldCefValueRef.SetDictionary(const value: IOldCefDictionaryValue): Boolean;
begin
  Result := POldCefValue(FData).set_dictionary(POldCefValue(FData), CefGetData(value)) <> 0;
end;

function TOldCefValueRef.SetDouble(value: Double): Boolean;
begin
  Result := POldCefValue(FData).set_double(POldCefValue(FData), value) <> 0;
end;

function TOldCefValueRef.SetInt(value: Integer): Boolean;
begin
  Result := POldCefValue(FData).set_int(POldCefValue(FData), value) <> 0;
end;

function TOldCefValueRef.SetList(const value: IOldCefListValue): Boolean;
begin
  Result := POldCefValue(FData).set_list(POldCefValue(FData), CefGetData(value)) <> 0;
end;

function TOldCefValueRef.SetNull: Boolean;
begin
  Result := POldCefValue(FData).set_null(POldCefValue(FData)) <> 0;
end;

function TOldCefValueRef.SetString(const value: oldustring): Boolean;
var
  TempValue : TOldCefString;
begin
  TempValue := CefString(value);
  Result    := POldCefValue(FData).set_string(POldCefValue(FData), @TempValue) <> 0;
end;

class function TOldCefValueRef.UnWrap(data: Pointer): IOldCefValue;
begin
  if (data <> nil) then
    Result := Create(data) as IOldCefValue
   else
    Result := nil;
end;

end.
