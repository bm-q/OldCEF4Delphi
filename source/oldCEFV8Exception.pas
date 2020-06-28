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

unit oldCEFV8Exception;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefV8ExceptionRef = class(TOldCefBaseRef, IOldCefV8Exception)
    protected
      function GetMessage: oldustring;
      function GetSourceLine: oldustring;
      function GetScriptResourceName: oldustring;
      function GetLineNumber: Integer;
      function GetStartPosition: Integer;
      function GetEndPosition: Integer;
      function GetStartColumn: Integer;
      function GetEndColumn: Integer;

    public
      class function UnWrap(data: Pointer): IOldCefV8Exception;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions;


function TOldCefV8ExceptionRef.GetEndColumn: Integer;
begin
  Result := POldCefV8Exception(FData)^.get_end_column(FData);
end;

function TOldCefV8ExceptionRef.GetEndPosition: Integer;
begin
  Result := POldCefV8Exception(FData)^.get_end_position(FData);
end;

function TOldCefV8ExceptionRef.GetLineNumber: Integer;
begin
  Result := POldCefV8Exception(FData)^.get_line_number(FData);
end;

function TOldCefV8ExceptionRef.GetMessage: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefV8Exception(FData)^.get_message(FData));
end;

function TOldCefV8ExceptionRef.GetScriptResourceName: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefV8Exception(FData)^.get_script_resource_name(FData));
end;

function TOldCefV8ExceptionRef.GetSourceLine: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefV8Exception(FData)^.get_source_line(FData));
end;

function TOldCefV8ExceptionRef.GetStartColumn: Integer;
begin
  Result := POldCefV8Exception(FData)^.get_start_column(FData);
end;

function TOldCefV8ExceptionRef.GetStartPosition: Integer;
begin
  Result := POldCefV8Exception(FData)^.get_start_position(FData);
end;

class function TOldCefV8ExceptionRef.UnWrap(data: Pointer): IOldCefV8Exception;
begin
  if (data <> nil) then
    Result := Create(data) as IOldCefV8Exception
   else
    Result := nil;
end;

end.
