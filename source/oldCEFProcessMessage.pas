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

unit oldCEFProcessMessage;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefProcessMessageRef = class(TOldCefBaseRef, IOldCefProcessMessage)
    protected
      function IsValid: Boolean;
      function IsReadOnly: Boolean;
      function Copy: IOldCefProcessMessage;
      function GetName: oldustring;
      function GetArgumentList: IOldCefListValue;

    public
      class function UnWrap(data: Pointer): IOldCefProcessMessage;
      class function New(const name: oldustring): IOldCefProcessMessage;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFListValue;

function TOldCefProcessMessageRef.Copy: IOldCefProcessMessage;
begin
  Result := UnWrap(POldCefProcessMessage(FData)^.copy(POldCefProcessMessage(FData)));
end;

function TOldCefProcessMessageRef.GetArgumentList: IOldCefListValue;
begin
  Result := TOldCefListValueRef.UnWrap(POldCefProcessMessage(FData)^.get_argument_list(POldCefProcessMessage(FData)));
end;

function TOldCefProcessMessageRef.GetName: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefProcessMessage(FData)^.get_name(POldCefProcessMessage(FData)));
end;

function TOldCefProcessMessageRef.IsReadOnly: Boolean;
begin
  Result := POldCefProcessMessage(FData)^.is_read_only(POldCefProcessMessage(FData)) <> 0;
end;

function TOldCefProcessMessageRef.IsValid: Boolean;
begin
  Result := POldCefProcessMessage(FData)^.is_valid(POldCefProcessMessage(FData)) <> 0;
end;

class function TOldCefProcessMessageRef.New(const name: oldustring): IOldCefProcessMessage;
var
  TempString : TOldCefString;
begin
  TempString := CefString(name);
  Result     := UnWrap(cef_process_message_create(@TempString));
end;

class function TOldCefProcessMessageRef.UnWrap(data: Pointer): IOldCefProcessMessage;
begin
  if (data <> nil) then
    Result := Create(data) as IOldCefProcessMessage
   else
    Result := nil;
end;

end.
