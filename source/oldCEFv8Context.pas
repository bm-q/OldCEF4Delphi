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

unit oldCEFv8Context;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefv8ContextRef = class(TOldCefBaseRef, IOldCefv8Context)
    protected
      function GetTaskRunner: IOldCefTaskRunner;
      function IsValid: Boolean;
      function GetBrowser: IOldCefBrowser;
      function GetFrame: IOldCefFrame;
      function GetGlobal: IOldCefv8Value;
      function Enter: Boolean;
      function Exit: Boolean;
      function IsSame(const that: IOldCefv8Context): Boolean;
      function Eval(const code: oldustring; var retval: IOldCefv8Value; var exception: IOldCefV8Exception): Boolean;
    public
      class function UnWrap(data: Pointer): IOldCefv8Context;
      class function Current: IOldCefv8Context;
      class function Entered: IOldCefv8Context;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFBrowser, oldCEFFrame, oldCEFv8Value, oldCEFTaskRunner, oldCEFv8Exception;

class function TOldCefv8ContextRef.Current: IOldCefv8Context;
begin
  Result := UnWrap(cef_v8context_get_current_context)
end;

function TOldCefv8ContextRef.Enter: Boolean;
begin
  Result := POldCefv8Context(FData)^.enter(POldCefv8Context(FData)) <> 0;
end;

class function TOldCefv8ContextRef.Entered: IOldCefv8Context;
begin
  Result := UnWrap(cef_v8context_get_entered_context)
end;

function TOldCefv8ContextRef.Exit: Boolean;
begin
  Result := POldCefv8Context(FData)^.exit(POldCefv8Context(FData)) <> 0;
end;

function TOldCefv8ContextRef.GetBrowser: IOldCefBrowser;
begin
  Result := TOldCefBrowserRef.UnWrap(POldCefv8Context(FData)^.get_browser(POldCefv8Context(FData)));
end;

function TOldCefv8ContextRef.GetFrame: IOldCefFrame;
begin
  Result := TOldCefFrameRef.UnWrap(POldCefv8Context(FData)^.get_frame(POldCefv8Context(FData)))
end;

function TOldCefv8ContextRef.GetGlobal: IOldCefv8Value;
begin
  Result := TOldCefv8ValueRef.UnWrap(POldCefv8Context(FData)^.get_global(POldCefv8Context(FData)));
end;

function TOldCefv8ContextRef.GetTaskRunner: IOldCefTaskRunner;
begin
  Result := TOldCefTaskRunnerRef.UnWrap(POldCefv8Context(FData)^.get_task_runner(POldCefv8Context(FData)));
end;

function TOldCefv8ContextRef.IsSame(const that: IOldCefv8Context): Boolean;
begin
  Result := POldCefv8Context(FData)^.is_same(POldCefv8Context(FData), CefGetData(that)) <> 0;
end;

function TOldCefv8ContextRef.IsValid: Boolean;
begin
  Result := POldCefv8Context(FData)^.is_valid(FData) <> 0;
end;

function TOldCefv8ContextRef.Eval(const code: oldustring;
                               var   retval: IOldCefv8Value;
                               var   exception: IOldCefV8Exception): Boolean;
var
  TempCode : TOldCefString;
  TempValue : POldCefv8Value;
  TempException : POldCefV8Exception;
begin
  TempCode      := CefString(code);
  TempValue     := nil;
  TempException := nil;

  Result := (POldCefv8Context(FData)^.eval(POldCefv8Context(FData), @TempCode, TempValue, TempException) <> 0);

  retval    := TOldCefv8ValueRef.UnWrap(TempValue);
  exception := TOldCefV8ExceptionRef.UnWrap(TempException);
end;

class function TOldCefv8ContextRef.UnWrap(data: Pointer): IOldCefv8Context;
begin
  if (data <> nil) then
    Result := Create(data) as IOldCefv8Context
   else
    Result := nil;
end;

end.
