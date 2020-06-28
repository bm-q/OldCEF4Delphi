// ************************************************************************
// ***************************** CEF4Delphi *******************************
// ************************************************************************
//
// CEF4Delphi is based on DCEF3 which uses CEF3 to embed a chromium-based
// browser in Delphi applications.
//
// The original license of DCEF3 still applies to CEF4Delphi.
//
// For more information about CEF4Delphi visit :
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

unit uMyV8Accessor;

{$I oldcef.inc}

interface

uses
  oldCEFV8Value, oldCEFv8Accessor, oldCEFInterfaces, oldCEFTypes;

type
  TMyV8Accessor = class(TOldCefV8AccessorOwn)
    protected
      FMyVal : oldustring;

      function Get(const name: oldustring; const obj: IOldCefv8Value; out retval : IOldCefv8Value; var exception: oldustring): Boolean; override;
      function Put(const name: oldustring; const obj, value: IOldCefv8Value; var exception: oldustring): Boolean; override;
  end;

implementation

function TMyV8Accessor.Get(const name      : oldustring;
                           const obj       : IOldCefv8Value;
                           out   retval    : IOldCefv8Value;
                           var   exception : oldustring): Boolean;
begin
  if (name = 'myval') then
    begin
      retval := TOldCefv8ValueRef.NewString(FMyVal);
      Result := True;
    end
   else
    Result := False;
end;

function TMyV8Accessor.Put(const name      : oldustring;
                           const obj       : IOldCefv8Value;
                           const value     : IOldCefv8Value;
                           var   exception : oldustring): Boolean;
begin
  if (name = 'myval') then
    begin
      if value.IsString then
        FMyVal := value.GetStringValue
       else
        exception := 'Invalid value type';

      Result := True;
    end
   else
    Result := False;
end;

end.
