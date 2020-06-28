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
//        Copyright � 2019 Salvador D�az Fau. All rights reserved.
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

unit uMyV8Handler;

{$I oldcef.inc}

interface

uses
  oldCEFTypes, oldCEFInterfaces, oldCEFv8Value, oldCEFv8Handler;

type
  TMyV8Handler = class(TOldCefv8HandlerOwn)
    protected
      FMyParam : string;

      function Execute(const name: oldustring; const obj: IOldCefv8Value; const arguments: TOldCefv8ValueArray; var retval: IOldCefv8Value; var exception: oldustring): Boolean; override;
  end;

implementation

function TMyV8Handler.Execute(const name      : oldustring;
                              const obj       : IOldCefv8Value;
                              const arguments : TOldCefv8ValueArray;
                              var   retval    : IOldCefv8Value;
                              var   exception : oldustring): Boolean;
begin
  if (name = 'GetMyParam') then
    begin
      retval := TOldCefv8ValueRef.NewString(FMyParam);
      Result := True;
    end
   else
    if (name = 'SetMyParam') then
      begin
        if (length(arguments) > 0) and arguments[0].IsString then
          FMyParam := arguments[0].GetStringValue;

        Result := True;
      end
     else
      Result := False;
end;


end.
