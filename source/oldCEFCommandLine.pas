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

unit oldCEFCommandLine;

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
  oldCEFBase, oldCEFTypes, oldCEFInterfaces;

type
  TOldCefCommandLineRef = class(TOldCefBaseRef, IOldCefCommandLine)
    protected
      function  IsValid: Boolean;
      function  IsReadOnly: Boolean;
      function  Copy: IOldCefCommandLine;
      procedure InitFromArgv(argc: Integer; const argv: PPAnsiChar);
      procedure InitFromString(const commandLine: oldustring);
      procedure Reset;
      function  GetCommandLineString: oldustring;
      procedure GetArgv(var args: TStrings);
      function  GetProgram: oldustring;
      procedure SetProgram(const prog: oldustring);
      function  HasSwitches: Boolean;
      function  HasSwitch(const name: oldustring): Boolean;
      function  GetSwitchValue(const name: oldustring): oldustring;
      procedure GetSwitches(var switches: TStrings);
      procedure AppendSwitch(const name: oldustring);
      procedure AppendSwitchWithValue(const name, value: oldustring);
      function  HasArguments: Boolean;
      procedure GetArguments(var arguments: TStrings);
      procedure AppendArgument(const argument: oldustring);
      procedure PrependWrapper(const wrapper: oldustring);

    public
      class function UnWrap(data: Pointer): IOldCefCommandLine;
      class function New: IOldCefCommandLine;
      class function Global: IOldCefCommandLine;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFStringMap, oldCEFStringList;

procedure TOldCefCommandLineRef.AppendArgument(const argument: oldustring);
var
  TempArgument : TOldCefString;
begin
  TempArgument := CefString(argument);
  POldCefCommandLine(FData).append_argument(POldCefCommandLine(FData), @TempArgument);
end;

procedure TOldCefCommandLineRef.AppendSwitch(const name: oldustring);
var
  TempName : TOldCefString;
begin
  TempName := CefString(name);
  POldCefCommandLine(FData).append_switch(POldCefCommandLine(FData), @TempName);
end;

procedure TOldCefCommandLineRef.AppendSwitchWithValue(const name, value: oldustring);
var
  TempName, TempValue : TOldCefString;
begin
  TempName  := CefString(name);
  TempValue := CefString(value);
  POldCefCommandLine(FData).append_switch_with_value(POldCefCommandLine(FData), @TempName, @TempValue);
end;

function TOldCefCommandLineRef.Copy: IOldCefCommandLine;
begin
  Result := UnWrap(POldCefCommandLine(FData).copy(POldCefCommandLine(FData)));
end;

procedure TOldCefCommandLineRef.GetArguments(var arguments : TStrings);
var
  TempSL : IOldCefStringList;
begin
  if (arguments <> nil) then
    begin
      TempSL := TOldCefStringListOwn.Create;
      POldCefCommandLine(FData).get_arguments(POldCefCommandLine(FData), TempSL.Handle);
      TempSL.CopyToStrings(arguments);
    end;
end;

procedure TOldCefCommandLineRef.GetArgv(var args: TStrings);
var
  TempSL : IOldCefStringList;
begin
  if (args <> nil) then
    begin
      TempSL := TOldCefStringListOwn.Create;
      POldCefCommandLine(FData).get_argv(POldCefCommandLine(FData), TempSL.Handle);
      TempSL.CopyToStrings(args);
    end;
end;

function TOldCefCommandLineRef.GetCommandLineString: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefCommandLine(FData).get_command_line_string(POldCefCommandLine(FData)));
end;

function TOldCefCommandLineRef.GetProgram: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefCommandLine(FData).get_program(POldCefCommandLine(FData)));
end;

procedure TOldCefCommandLineRef.GetSwitches(var switches: TStrings);
var
  TempStrMap : IOldCefStringMap;
  i, j : NativeUInt;
  TempKey, TempValue : string;
begin
  TempStrMap := nil;

  try
    try
      if (switches <> nil) then
        begin
          TempStrMap := TOldCefStringMapOwn.Create;
          POldCefCommandLine(FData).get_switches(POldCefCommandLine(FData), TempStrMap.Handle);

          i := 0;
          j := TempStrMap.Size;

          while (i < j) do
            begin
              TempKey   := TempStrMap.Key[i];
              TempValue := TempStrMap.Value[i];

              if (length(TempKey) > 0) and (length(TempValue) > 0) then
                switches.Add(TempKey + switches.NameValueSeparator + TempValue)
               else
                if (length(TempKey) > 0) then
                  switches.Add(TempKey)
                 else
                  if (length(TempValue) > 0) then
                    switches.Add(TempValue);

              inc(i);
            end;
        end;
    except
      on e : exception do
        if CustomExceptionHandler('TOldCefCommandLineRef.GetSwitches', e) then raise;
    end;
  finally
    TempStrMap := nil;
  end;
end;

function TOldCefCommandLineRef.GetSwitchValue(const name: oldustring): oldustring;
var
  TempName : TOldCefString;
begin
  TempName := CefString(name);
  Result   := CefStringFreeAndGet(POldCefCommandLine(FData).get_switch_value(POldCefCommandLine(FData), @TempName));
end;

class function TOldCefCommandLineRef.Global: IOldCefCommandLine;
begin
  Result := UnWrap(cef_command_line_get_global);
end;

function TOldCefCommandLineRef.HasArguments: Boolean;
begin
  Result := POldCefCommandLine(FData).has_arguments(POldCefCommandLine(FData)) <> 0;
end;

function TOldCefCommandLineRef.HasSwitch(const name: oldustring): Boolean;
var
  TempName : TOldCefString;
begin
  TempName := CefString(name);
  Result   := POldCefCommandLine(FData).has_switch(POldCefCommandLine(FData), @TempName) <> 0;
end;

function TOldCefCommandLineRef.HasSwitches: Boolean;
begin
  Result := POldCefCommandLine(FData).has_switches(POldCefCommandLine(FData)) <> 0;
end;

procedure TOldCefCommandLineRef.InitFromArgv(argc: Integer; const argv: PPAnsiChar);
begin
  POldCefCommandLine(FData).init_from_argv(POldCefCommandLine(FData), argc, argv);
end;

procedure TOldCefCommandLineRef.InitFromString(const commandLine: oldustring);
var
  TempCommandLine : TOldCefString;
begin
  TempCommandLine := CefString(commandLine);
  POldCefCommandLine(FData).init_from_string(POldCefCommandLine(FData), @TempCommandLine);
end;

function TOldCefCommandLineRef.IsReadOnly: Boolean;
begin
  Result := POldCefCommandLine(FData).is_read_only(POldCefCommandLine(FData)) <> 0;
end;

function TOldCefCommandLineRef.IsValid: Boolean;
begin
  Result := POldCefCommandLine(FData).is_valid(POldCefCommandLine(FData)) <> 0;
end;

class function TOldCefCommandLineRef.New: IOldCefCommandLine;
begin
  Result := UnWrap(cef_command_line_create);
end;

procedure TOldCefCommandLineRef.PrependWrapper(const wrapper: oldustring);
var
  TempWrapper : TOldCefString;
begin
  TempWrapper := CefString(wrapper);
  POldCefCommandLine(FData).prepend_wrapper(POldCefCommandLine(FData), @TempWrapper);
end;

procedure TOldCefCommandLineRef.Reset;
begin
  POldCefCommandLine(FData).reset(POldCefCommandLine(FData));
end;

procedure TOldCefCommandLineRef.SetProgram(const prog: oldustring);
var
  TempProgram : TOldCefString;
begin
  TempProgram := CefString(prog);
  POldCefCommandLine(FData).set_program(POldCefCommandLine(FData), @TempProgram);
end;

class function TOldCefCommandLineRef.UnWrap(data: Pointer): IOldCefCommandLine;
begin
  if (data <> nil) then
    Result := Create(data) as IOldCefCommandLine
   else
    Result := nil;
end;

end.
