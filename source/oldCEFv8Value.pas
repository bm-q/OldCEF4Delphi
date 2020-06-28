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

unit oldCEFv8Value;

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
  oldCEFBase, oldCEFInterfaces, oldCEFTypes, oldCEFv8Types;

type
  TOldCefv8ValueRef = class(TOldCefBaseRef, IOldCefv8Value)
    protected
      function IsValid: Boolean;
      function IsUndefined: Boolean;
      function IsNull: Boolean;
      function IsBool: Boolean;
      function IsInt: Boolean;
      function IsUInt: Boolean;
      function IsDouble: Boolean;
      function IsDate: Boolean;
      function IsString: Boolean;
      function IsObject: Boolean;
      function IsArray: Boolean;
      function IsFunction: Boolean;
      function IsSame(const that: IOldCefv8Value): Boolean;
      function GetBoolValue: Boolean;
      function GetIntValue: Integer;
      function GetUIntValue: Cardinal;
      function GetDoubleValue: Double;
      function GetDateValue: TDateTime;
      function GetStringValue: oldustring;
      function IsUserCreated: Boolean;
      function HasException: Boolean;
      function GetException: IOldCefV8Exception;
      function ClearException: Boolean;
      function WillRethrowExceptions: Boolean;
      function SetRethrowExceptions(rethrow: Boolean): Boolean;
      function HasValueByKey(const key: oldustring): Boolean;
      function HasValueByIndex(index: Integer): Boolean;
      function DeleteValueByKey(const key: oldustring): Boolean;
      function DeleteValueByIndex(index: Integer): Boolean;
      function GetValueByKey(const key: oldustring): IOldCefv8Value;
      function GetValueByIndex(index: Integer): IOldCefv8Value;
      function SetValueByKey(const key: oldustring; const value: IOldCefv8Value; attribute: TOldCefV8PropertyAttributes): Boolean;
      function SetValueByIndex(index: Integer; const value: IOldCefv8Value): Boolean;
      function SetValueByAccessor(const key: oldustring; settings: TOldCefV8AccessControls; attribute: TOldCefV8PropertyAttributes): Boolean;
      function GetKeys(const keys: TStrings): Integer;
      function SetUserData(const data: IOldCefv8Value): Boolean;
      function GetUserData: IOldCefv8Value;
      function GetExternallyAllocatedMemory: Integer;
      function AdjustExternallyAllocatedMemory(changeInBytes: Integer): Integer;
      function GetArrayLength: Integer;
      function GetFunctionName: oldustring;
      function GetFunctionHandler: IOldCefv8Handler;
      function ExecuteFunction(const obj: IOldCefv8Value; const arguments: TOldCefv8ValueArray): IOldCefv8Value;
      function ExecuteFunctionWithContext(const context: IOldCefv8Context; const obj: IOldCefv8Value; const arguments: TOldCefv8ValueArray): IOldCefv8Value;

    public
      class function UnWrap(data: Pointer): IOldCefv8Value;
      class function NewUndefined: IOldCefv8Value;
      class function NewNull: IOldCefv8Value;
      class function NewBool(value: Boolean): IOldCefv8Value;
      class function NewInt(value: Integer): IOldCefv8Value;
      class function NewUInt(value: Cardinal): IOldCefv8Value;
      class function NewDouble(value: Double): IOldCefv8Value;
      class function NewDate(value: TDateTime): IOldCefv8Value;
      class function NewString(const str: oldustring): IOldCefv8Value;
      class function NewObject(const Accessor: IOldCefV8Accessor): IOldCefv8Value;
      class function NewObjectProc(const getter: TOldCefV8AccessorGetterProc; const setter: TOldCefV8AccessorSetterProc): IOldCefv8Value;
      class function NewArray(len: Integer): IOldCefv8Value;
      class function NewFunction(const name: oldustring; const handler: IOldCefv8Handler): IOldCefv8Value;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFv8Accessor, oldCEFv8Handler, oldCEFv8Exception,
  oldCEFStringList;

function TOldCefv8ValueRef.AdjustExternallyAllocatedMemory(changeInBytes: Integer): Integer;
begin
  Result := POldCefV8Value(FData)^.adjust_externally_allocated_memory(POldCefV8Value(FData), changeInBytes);
end;

class function TOldCefv8ValueRef.NewArray(len: Integer): IOldCefv8Value;
begin
  Result := UnWrap(cef_v8value_create_array(len));
end;

class function TOldCefv8ValueRef.NewBool(value: Boolean): IOldCefv8Value;
begin
  Result := UnWrap(cef_v8value_create_bool(Ord(value)));
end;

class function TOldCefv8ValueRef.NewDate(value: TDateTime): IOldCefv8Value;
var
  dt: TOldCefTime;
begin
  dt := DateTimeToCefTime(value);
  Result := UnWrap(cef_v8value_create_date(@dt));
end;

class function TOldCefv8ValueRef.NewDouble(value: Double): IOldCefv8Value;
begin
  Result := UnWrap(cef_v8value_create_double(value));
end;

class function TOldCefv8ValueRef.NewFunction(const name: oldustring;
  const handler: IOldCefv8Handler): IOldCefv8Value;
var
  n: TOldCefString;
begin
  n := CefString(name);
  Result := UnWrap(cef_v8value_create_function(@n, CefGetData(handler)));
end;

class function TOldCefv8ValueRef.NewInt(value: Integer): IOldCefv8Value;
begin
  Result := UnWrap(cef_v8value_create_int(value));
end;

class function TOldCefv8ValueRef.NewUInt(value: Cardinal): IOldCefv8Value;
begin
  Result := UnWrap(cef_v8value_create_uint(value));
end;

class function TOldCefv8ValueRef.NewNull: IOldCefv8Value;
begin
  Result := UnWrap(cef_v8value_create_null);
end;

class function TOldCefv8ValueRef.NewObject(const Accessor: IOldCefV8Accessor): IOldCefv8Value;
begin
  Result := UnWrap(cef_v8value_create_object(CefGetData(Accessor)));
end;

class function TOldCefv8ValueRef.NewObjectProc(const getter: TOldCefV8AccessorGetterProc;
                                            const setter: TOldCefV8AccessorSetterProc): IOldCefv8Value;
begin
  Result := NewObject(TOldCefFastV8Accessor.Create(getter, setter) as IOldCefV8Accessor);
end;

class function TOldCefv8ValueRef.NewString(const str: oldustring): IOldCefv8Value;
var
  s: TOldCefString;
begin
  s := CefString(str);
  Result := UnWrap(cef_v8value_create_string(@s));
end;

class function TOldCefv8ValueRef.NewUndefined: IOldCefv8Value;
begin
  Result := UnWrap(cef_v8value_create_undefined);
end;

function TOldCefv8ValueRef.DeleteValueByIndex(index: Integer): Boolean;
begin
  Result := POldCefV8Value(FData)^.delete_value_byindex(POldCefV8Value(FData), index) <> 0;
end;

function TOldCefv8ValueRef.DeleteValueByKey(const key: oldustring): Boolean;
var
  k: TOldCefString;
begin
  k      := CefString(key);
  Result := POldCefV8Value(FData)^.delete_value_bykey(POldCefV8Value(FData), @k) <> 0;
end;

function TOldCefv8ValueRef.ExecuteFunction(const obj: IOldCefv8Value; const arguments: TOldCefv8ValueArray): IOldCefv8Value;
var
  args : PPOldCefV8Value;
  i, j : NativeUInt;
begin
  Result := nil;
  args   := nil;

  try
    try
      if (arguments <> nil) then
        begin
          i := 0;
          j := Length(arguments);

          GetMem(args, SizeOf(POldCefV8Value) * j);

          while (i < j) do
            begin
              args[i] := CefGetData(arguments[i]);
              inc(i);
            end;
        end
       else
        j := 0;

      Result := TOldCefv8ValueRef.UnWrap(POldCefV8Value(FData).execute_function(POldCefV8Value(FData),
                                                                          CefGetData(obj),
                                                                          j,
                                                                          args));
    except
      on e : exception do
        if CustomExceptionHandler('TOldCefv8ValueRef.ExecuteFunction', e) then raise;
    end;
  finally
    if (args <> nil) then FreeMem(args);
  end;
end;

function TOldCefv8ValueRef.ExecuteFunctionWithContext(const context   : IOldCefv8Context;
                                                   const obj       : IOldCefv8Value;
                                                   const arguments : TOldCefv8ValueArray): IOldCefv8Value;
var
  args : PPOldCefV8Value;
  i, j : NativeUInt;
begin
  Result := nil;
  args   := nil;

  try
    try
      if (arguments <> nil) then
        begin
          i := 0;
          j := Length(arguments);

          GetMem(args, SizeOf(POldCefV8Value) * j);

          while (i < j) do
            begin
              args[i] := CefGetData(arguments[i]);
              inc(i);
            end;
        end
       else
        j := 0;

      Result := TOldCefv8ValueRef.UnWrap(POldCefV8Value(FData).execute_function_with_context(POldCefV8Value(FData),
                                                                                       CefGetData(context),
                                                                                       CefGetData(obj),
                                                                                       j,
                                                                                       args));
    except
      on e : exception do
        if CustomExceptionHandler('TOldCefv8ValueRef.ExecuteFunctionWithContext', e) then raise;
    end;
  finally
    if (args <> nil) then FreeMem(args);
  end;
end;

function TOldCefv8ValueRef.GetArrayLength: Integer;
begin
  Result := POldCefV8Value(FData)^.get_array_length(POldCefV8Value(FData));
end;

function TOldCefv8ValueRef.GetBoolValue: Boolean;
begin
  Result := POldCefV8Value(FData)^.get_bool_value(POldCefV8Value(FData)) <> 0;
end;

function TOldCefv8ValueRef.GetDateValue: TDateTime;
begin
  Result := CefTimeToDateTime(POldCefV8Value(FData)^.get_date_value(POldCefV8Value(FData)));
end;

function TOldCefv8ValueRef.GetDoubleValue: Double;
begin
  Result := POldCefV8Value(FData)^.get_double_value(POldCefV8Value(FData));
end;

function TOldCefv8ValueRef.GetExternallyAllocatedMemory: Integer;
begin
  Result := POldCefV8Value(FData)^.get_externally_allocated_memory(POldCefV8Value(FData));
end;

function TOldCefv8ValueRef.GetFunctionHandler: IOldCefv8Handler;
begin
  Result := TOldCefv8HandlerRef.UnWrap(POldCefV8Value(FData)^.get_function_handler(POldCefV8Value(FData)));
end;

function TOldCefv8ValueRef.GetFunctionName: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefV8Value(FData)^.get_function_name(POldCefV8Value(FData)))
end;

function TOldCefv8ValueRef.GetIntValue: Integer;
begin
  Result := POldCefV8Value(FData)^.get_int_value(POldCefV8Value(FData))
end;

function TOldCefv8ValueRef.GetUIntValue: Cardinal;
begin
  Result := POldCefV8Value(FData)^.get_uint_value(POldCefV8Value(FData))
end;

function TOldCefv8ValueRef.GetKeys(const keys: TStrings): Integer;
var
  TempSL : IOldCefStringList;
begin
  Result := 0;
  TempSL := TOldCefStringListOwn.Create;

  if (POldCefV8Value(FData).get_keys(POldCefV8Value(FData), TempSL.Handle) <> 0) then
    begin
      TempSL.CopyToStrings(keys);
      Result := keys.Count;
    end;
end;

function TOldCefv8ValueRef.SetUserData(const data: IOldCefv8Value): Boolean;
begin
  Result := POldCefV8Value(FData)^.set_user_data(POldCefV8Value(FData), CefGetData(data)) <> 0;
end;

function TOldCefv8ValueRef.GetStringValue: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefV8Value(FData)^.get_string_value(POldCefV8Value(FData)));
end;

function TOldCefv8ValueRef.IsUserCreated: Boolean;
begin
  Result := POldCefV8Value(FData)^.is_user_created(POldCefV8Value(FData)) <> 0;
end;

function TOldCefv8ValueRef.IsValid: Boolean;
begin
  Result := POldCefV8Value(FData)^.is_valid(POldCefV8Value(FData)) <> 0;
end;

function TOldCefv8ValueRef.HasException: Boolean;
begin
  Result := POldCefV8Value(FData)^.has_exception(POldCefV8Value(FData)) <> 0;
end;

function TOldCefv8ValueRef.GetException: IOldCefV8Exception;
begin
   Result := TOldCefV8ExceptionRef.UnWrap(POldCefV8Value(FData)^.get_exception(POldCefV8Value(FData)));
end;

function TOldCefv8ValueRef.ClearException: Boolean;
begin
  Result := POldCefV8Value(FData)^.clear_exception(POldCefV8Value(FData)) <> 0;
end;

function TOldCefv8ValueRef.WillRethrowExceptions: Boolean;
begin
  Result := POldCefV8Value(FData)^.will_rethrow_exceptions(POldCefV8Value(FData)) <> 0;
end;

function TOldCefv8ValueRef.SetRethrowExceptions(rethrow: Boolean): Boolean;
begin
  Result := POldCefV8Value(FData)^.set_rethrow_exceptions(POldCefV8Value(FData), Ord(rethrow)) <> 0;
end;

function TOldCefv8ValueRef.GetUserData: IOldCefv8Value;
begin
  Result := TOldCefv8ValueRef.UnWrap(POldCefV8Value(FData)^.get_user_data(POldCefV8Value(FData)));
end;

function TOldCefv8ValueRef.GetValueByIndex(index: Integer): IOldCefv8Value;
begin
  Result := TOldCefv8ValueRef.UnWrap(POldCefV8Value(FData)^.get_value_byindex(POldCefV8Value(FData), index))
end;

function TOldCefv8ValueRef.GetValueByKey(const key: oldustring): IOldCefv8Value;
var
  k: TOldCefString;
begin
  k      := CefString(key);
  Result := TOldCefv8ValueRef.UnWrap(POldCefV8Value(FData)^.get_value_bykey(POldCefV8Value(FData), @k))
end;

function TOldCefv8ValueRef.HasValueByIndex(index: Integer): Boolean;
begin
  Result := POldCefV8Value(FData)^.has_value_byindex(POldCefV8Value(FData), index) <> 0;
end;

function TOldCefv8ValueRef.HasValueByKey(const key: oldustring): Boolean;
var
  k: TOldCefString;
begin
  k      := CefString(key);
  Result := POldCefV8Value(FData)^.has_value_bykey(POldCefV8Value(FData), @k) <> 0;
end;

function TOldCefv8ValueRef.IsArray: Boolean;
begin
  Result := POldCefV8Value(FData)^.is_array(POldCefV8Value(FData)) <> 0;
end;

function TOldCefv8ValueRef.IsBool: Boolean;
begin
  Result := POldCefV8Value(FData)^.is_bool(POldCefV8Value(FData)) <> 0;
end;

function TOldCefv8ValueRef.IsDate: Boolean;
begin
  Result := POldCefV8Value(FData)^.is_date(POldCefV8Value(FData)) <> 0;
end;

function TOldCefv8ValueRef.IsDouble: Boolean;
begin
  Result := POldCefV8Value(FData)^.is_double(POldCefV8Value(FData)) <> 0;
end;

function TOldCefv8ValueRef.IsFunction: Boolean;
begin
  Result := POldCefV8Value(FData)^.is_function(POldCefV8Value(FData)) <> 0;
end;

function TOldCefv8ValueRef.IsInt: Boolean;
begin
  Result := POldCefV8Value(FData)^.is_int(POldCefV8Value(FData)) <> 0;
end;

function TOldCefv8ValueRef.IsUInt: Boolean;
begin
  Result := POldCefV8Value(FData)^.is_uint(POldCefV8Value(FData)) <> 0;
end;

function TOldCefv8ValueRef.IsNull: Boolean;
begin
  Result := POldCefV8Value(FData)^.is_null(POldCefV8Value(FData)) <> 0;
end;

function TOldCefv8ValueRef.IsObject: Boolean;
begin
  Result := POldCefV8Value(FData)^.is_object(POldCefV8Value(FData)) <> 0;
end;

function TOldCefv8ValueRef.IsSame(const that: IOldCefv8Value): Boolean;
begin
  Result := POldCefV8Value(FData)^.is_same(POldCefV8Value(FData), CefGetData(that)) <> 0;
end;

function TOldCefv8ValueRef.IsString: Boolean;
begin
  Result := POldCefV8Value(FData)^.is_string(POldCefV8Value(FData)) <> 0;
end;

function TOldCefv8ValueRef.IsUndefined: Boolean;
begin
  Result := POldCefV8Value(FData)^.is_undefined(POldCefV8Value(FData)) <> 0;
end;

function TOldCefv8ValueRef.SetValueByAccessor(const key: oldustring; settings: TOldCefV8AccessControls; attribute: TOldCefV8PropertyAttributes): Boolean;
var
  k: TOldCefString;
begin
  k      := CefString(key);
  Result := POldCefV8Value(FData)^.set_value_byaccessor(POldCefV8Value(FData), @k, PByte(@settings)^, PByte(@attribute)^) <> 0;
end;

function TOldCefv8ValueRef.SetValueByIndex(index: Integer; const value: IOldCefv8Value): Boolean;
begin
  Result:= POldCefV8Value(FData)^.set_value_byindex(POldCefV8Value(FData), index, CefGetData(value)) <> 0;
end;

function TOldCefv8ValueRef.SetValueByKey(const key: oldustring; const value: IOldCefv8Value; attribute: TOldCefV8PropertyAttributes): Boolean;
var
  k: TOldCefString;
begin
  k      := CefString(key);
  Result := POldCefV8Value(FData)^.set_value_bykey(POldCefV8Value(FData), @k, CefGetData(value), PByte(@attribute)^) <> 0;
end;

class function TOldCefv8ValueRef.UnWrap(data: Pointer): IOldCefv8Value;
begin
  if (data <> nil) then
    Result := Create(data) as IOldCefv8Value
   else
    Result := nil;
end;

end.
