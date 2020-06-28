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

unit oldCEFv8StackTrace;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefV8StackTraceRef = class(TOldCefBaseRef, IOldCefV8StackTrace)
  protected
    function IsValid: Boolean;
    function GetFrameCount: Integer;
    function GetFrame(index: Integer): IOldCefV8StackFrame;
  public
    class function UnWrap(data: Pointer): IOldCefV8StackTrace;
    class function Current(frameLimit: Integer): IOldCefV8StackTrace;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFv8StackFrame;

class function TOldCefV8StackTraceRef.Current(frameLimit: Integer): IOldCefV8StackTrace;
begin
  Result := UnWrap(cef_v8stack_trace_get_current(frameLimit));
end;

function TOldCefV8StackTraceRef.GetFrame(index: Integer): IOldCefV8StackFrame;
begin
  Result := TOldCefV8StackFrameRef.UnWrap(POldCefV8StackTrace(FData).get_frame(FData, index));
end;

function TOldCefV8StackTraceRef.GetFrameCount: Integer;
begin
  Result := POldCefV8StackTrace(FData).get_frame_count(FData);
end;

function TOldCefV8StackTraceRef.IsValid: Boolean;
begin
  Result := POldCefV8StackTrace(FData).is_valid(FData) <> 0;
end;

class function TOldCefV8StackTraceRef.UnWrap(data: Pointer): IOldCefV8StackTrace;
begin
  if data <> nil then
    Result := Create(data) as IOldCefV8StackTrace else
    Result := nil;
end;

end.
