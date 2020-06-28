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

unit oldCEFv8StackFrame;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefV8StackFrameRef = class(TOldCefBaseRef, IOldCefV8StackFrame)
  protected
    function IsValid: Boolean;
    function GetScriptName: oldustring;
    function GetScriptNameOrSourceUrl: oldustring;
    function GetFunctionName: oldustring;
    function GetLineNumber: Integer;
    function GetColumn: Integer;
    function IsEval: Boolean;
    function IsConstructor: Boolean;
  public
    class function UnWrap(data: Pointer): IOldCefV8StackFrame;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions;

function TOldCefV8StackFrameRef.GetColumn: Integer;
begin
  Result := POldCefV8StackFrame(FData).get_column(FData);
end;

function TOldCefV8StackFrameRef.GetFunctionName: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefV8StackFrame(FData).get_function_name(FData));
end;

function TOldCefV8StackFrameRef.GetLineNumber: Integer;
begin
  Result := POldCefV8StackFrame(FData).get_line_number(FData);
end;

function TOldCefV8StackFrameRef.GetScriptName: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefV8StackFrame(FData).get_script_name(FData));
end;

function TOldCefV8StackFrameRef.GetScriptNameOrSourceUrl: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefV8StackFrame(FData).get_script_name_or_source_url(FData));
end;

function TOldCefV8StackFrameRef.IsConstructor: Boolean;
begin
  Result := POldCefV8StackFrame(FData).is_constructor(FData) <> 0;
end;

function TOldCefV8StackFrameRef.IsEval: Boolean;
begin
  Result := POldCefV8StackFrame(FData).is_eval(FData) <> 0;
end;

function TOldCefV8StackFrameRef.IsValid: Boolean;
begin
  Result := POldCefV8StackFrame(FData).is_valid(FData) <> 0;
end;

class function TOldCefV8StackFrameRef.UnWrap(data: Pointer): IOldCefV8StackFrame;
begin
  if data <> nil then
    Result := Create(data) as IOldCefV8StackFrame else
    Result := nil;
end;

end.
