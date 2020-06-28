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

unit oldCEFTaskRunner;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefTaskRunnerRef = class(TOldCefBaseRef, IOldCefTaskRunner)
  protected
    function IsSame(const that: IOldCefTaskRunner): Boolean;
    function BelongsToCurrentThread: Boolean;
    function BelongsToThread(threadId: TOldCefThreadId): Boolean;
    function PostTask(const task: IOldCefTask): Boolean;
    function PostDelayedTask(const task: IOldCefTask; delayMs: Int64): Boolean;
  public
    class function UnWrap(data: Pointer): IOldCefTaskRunner;
    class function GetForCurrentThread: IOldCefTaskRunner;
    class function GetForThread(threadId: TOldCefThreadId): IOldCefTaskRunner;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions;


function TOldCefTaskRunnerRef.BelongsToCurrentThread: Boolean;
begin
  Result := POldCefTaskRunner(FData).belongs_to_current_thread(FData) <> 0;
end;

function TOldCefTaskRunnerRef.BelongsToThread(threadId: TOldCefThreadId): Boolean;
begin
  Result := POldCefTaskRunner(FData).belongs_to_thread(FData, threadId) <> 0;
end;

class function TOldCefTaskRunnerRef.GetForCurrentThread: IOldCefTaskRunner;
begin
  Result := UnWrap(cef_task_runner_get_for_current_thread());
end;

class function TOldCefTaskRunnerRef.GetForThread(threadId: TOldCefThreadId): IOldCefTaskRunner;
begin
  Result := UnWrap(cef_task_runner_get_for_thread(threadId));
end;

function TOldCefTaskRunnerRef.IsSame(const that: IOldCefTaskRunner): Boolean;
begin
  Result := POldCefTaskRunner(FData).is_same(FData, CefGetData(that)) <> 0;
end;

function TOldCefTaskRunnerRef.PostDelayedTask(const task: IOldCefTask; delayMs: Int64): Boolean;
begin
  Result := POldCefTaskRunner(FData).post_delayed_task(FData, CefGetData(task), delayMs) <> 0;
end;

function TOldCefTaskRunnerRef.PostTask(const task: IOldCefTask): Boolean;
begin
  Result := POldCefTaskRunner(FData).post_task(FData, CefGetData(task)) <> 0;
end;

class function TOldCefTaskRunnerRef.UnWrap(data: Pointer): IOldCefTaskRunner;
begin
  if (data <> nil) then
    Result := Create(data) as IOldCefTaskRunner
   else
    Result := nil;
end;

end.
