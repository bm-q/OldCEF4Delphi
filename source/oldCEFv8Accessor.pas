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

unit oldCEFv8Accessor;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes, oldCEFv8Types;

type
  TOldCefV8AccessorOwn = class(TOldCefBaseOwn, IOldCefV8Accessor)
    protected
      function Get(const name: oldustring; const obj: IOldCefv8Value; out retval: IOldCefv8Value; var exception: oldustring): Boolean; virtual;
      function Put(const name: oldustring; const obj, value: IOldCefv8Value; var exception: oldustring): Boolean; virtual;

    public
      constructor Create; virtual;
  end;

  TOldCefFastV8Accessor = class(TOldCefV8AccessorOwn)
    protected
      FGetter: TOldCefV8AccessorGetterProc;
      FSetter: TOldCefV8AccessorSetterProc;

      function Get(const name: oldustring; const obj: IOldCefv8Value; out retval: IOldCefv8Value; var exception: oldustring): Boolean; override;
      function Put(const name: oldustring; const obj, value: IOldCefv8Value; var exception: oldustring): Boolean; override;

    public
      constructor Create(const getter: TOldCefV8AccessorGetterProc; const setter: TOldCefV8AccessorSetterProc); reintroduce;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFv8Value;

function cef_v8_accessor_get(      self      : POldCefV8Accessor;
                             const name      : POldCefString;
                                   obj       : POldCefv8Value;
                             out   retval    : POldCefv8Value;
                                   exception : POldCefString): Integer; stdcall;
var
  ret : IOldCefv8Value;
  TempExcept : oldustring;
  TempObject : TObject;
begin
  Result     := Ord(False);
  TempExcept := CefString(exception);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefV8AccessorOwn) then
    Result := Ord(TOldCefV8AccessorOwn(TempObject).Get(CefString(name),
                                                    TOldCefv8ValueRef.UnWrap(obj),
                                                    ret,
                                                    TempExcept));

  retval     := CefGetData(ret);
  exception^ := CefString(TempExcept);
end;

function cef_v8_accessor_put(      self      : POldCefV8Accessor;
                             const name      : POldCefString;
                                   obj       : POldCefv8Value;
                                   value     : POldCefv8Value;
                                   exception : POldCefString): Integer; stdcall;
var
  TempExcept : oldustring;
  TempObject : TObject;
begin
  Result     := Ord(False);
  TempExcept := CefString(exception);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefV8AccessorOwn) then
    Result := Ord(TOldCefV8AccessorOwn(TempObject).Put(CefString(name),
                                                    TOldCefv8ValueRef.UnWrap(obj),
                                                    TOldCefv8ValueRef.UnWrap(value),
                                                    TempExcept));

  exception^ := CefString(TempExcept);
end;

// TOldCefV8AccessorOwn

constructor TOldCefV8AccessorOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefV8Accessor));

  POldCefV8Accessor(FData)^.get := cef_v8_accessor_get;
  POldCefV8Accessor(FData)^.put := cef_v8_accessor_put;
end;

function TOldCefV8AccessorOwn.Get(const name: oldustring; const obj: IOldCefv8Value; out retval: IOldCefv8Value; var exception: oldustring): Boolean;
begin
  Result := False;
end;

function TOldCefV8AccessorOwn.Put(const name: oldustring; const obj, value: IOldCefv8Value; var exception: oldustring): Boolean;
begin
  Result := False;
end;

// TOldCefFastV8Accessor

constructor TOldCefFastV8Accessor.Create(const getter: TOldCefV8AccessorGetterProc; const setter: TOldCefV8AccessorSetterProc);
begin
  FGetter := getter;
  FSetter := setter;
end;

function TOldCefFastV8Accessor.Get(const name: oldustring; const obj: IOldCefv8Value; out retval: IOldCefv8Value; var exception: oldustring): Boolean;
begin
  if Assigned(FGetter) then
    Result := FGetter(name, obj, retval, exception)
   else
    Result := False;
end;

function TOldCefFastV8Accessor.Put(const name: oldustring; const obj, value: IOldCefv8Value; var exception: oldustring): Boolean;
begin
  if Assigned(FSetter) then
    Result := FSetter(name, obj, value, exception)
   else
    Result := False;
end;

end.
