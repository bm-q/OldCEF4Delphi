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

unit uMyV8Handler;

{$I oldcef.inc}

interface

uses
  oldCEFTypes, oldCEFInterfaces, oldCEFv8Value, oldCEFProcessMessage, oldCEFv8Handler, oldCEFv8Context;

const
  TEST_MESSAGE_NAME = 'test_message';

type
  TMyV8Handler = class(TOldCefv8HandlerOwn)
    protected
      function Execute(const name: oldustring; const obj: IOldCefv8Value; const arguments: TOldCefv8ValueArray; var retval: IOldCefv8Value; var exception: oldustring): Boolean; override;
  end;

implementation

function TMyV8Handler.Execute(const name      : oldustring;
                              const obj       : IOldCefv8Value;
                              const arguments : TOldCefv8ValueArray;
                              var   retval    : IOldCefv8Value;
                              var   exception : oldustring): Boolean;
var
  msg: IOldCefProcessMessage;
begin
  if (name = 'myfunc') then
    begin
      msg := TOldCefProcessMessageRef.New(TEST_MESSAGE_NAME);
      msg.ArgumentList.SetString(0, 'Message received!');
      TOldCefv8ContextRef.Current.Browser.SendProcessMessage(PID_BROWSER, msg);

      retval := TOldCefv8ValueRef.NewString('My Value!');
      Result := True;
    end
   else
    Result := False;
end;


end.
