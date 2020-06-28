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

unit oldCEFTask;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefTaskOwn = class(TOldCefBaseOwn, IOldCefTask)
    protected
      procedure Execute; virtual;

    public
      constructor Create; virtual;
  end;

  TOldCefTaskRef = class(TOldCefBaseRef, IOldCefTask)
    protected
      procedure Execute; virtual;

    public
      class function UnWrap(data: Pointer): IOldCefTask;
  end;

  TOldCefFastTaskProc = {$IFDEF DELPHI12_UP}reference to{$ENDIF} procedure;

  TOldCefFastTask = class(TOldCefTaskOwn)
    protected
      FMethod: TOldCefFastTaskProc;

      procedure Execute; override;

    public
      class procedure New(threadId: TOldCefThreadId; const method: TOldCefFastTaskProc);
      class procedure NewDelayed(threadId: TOldCefThreadId; Delay: Int64; const method: TOldCefFastTaskProc);
      constructor Create(const method: TOldCefFastTaskProc); reintroduce;
  end;

  TOldCefUpdatePrefsTask = class(TOldCefTaskOwn)
    protected
      FEvents : Pointer;

      procedure Execute; override;

    public
      constructor Create(const aEvents : IOldChromiumEvents); reintroduce;
      destructor  Destroy; override;
  end;

  TOldCefSavePrefsTask = class(TOldCefTaskOwn)
    protected
      FEvents : Pointer;

      procedure Execute; override;

    public
      constructor Create(const aEvents : IOldChromiumEvents); reintroduce;
      destructor  Destroy; override;
  end;

  TOldCefURLRequestTask = class(TOldCefTaskOwn)
    protected
      FEvents : Pointer;

      procedure Execute; override;

    public
      constructor Create(const aEvents : IOldCEFUrlRequestClientEvents); reintroduce;
      destructor  Destroy; override;
  end;

implementation

uses
  {$IFDEF DELPHI16_UP}
  System.SysUtils,
  {$ELSE}
  SysUtils,
  {$ENDIF}
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFCookieManager, oldCEFUrlRequest;

procedure cef_task_execute(self: POldCefTask); stdcall;
var
  TempObject  : TObject;
begin
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefTaskOwn) then
    TOldCefTaskOwn(TempObject).Execute;
end;

constructor TOldCefTaskOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefTask));

  POldCefTask(FData).execute := cef_task_execute;
end;

procedure TOldCefTaskOwn.Execute;
begin
  //
end;


// TOldCefTaskRef


procedure TOldCefTaskRef.Execute;
begin
  POldCefTask(FData).execute(FData);
end;

class function TOldCefTaskRef.UnWrap(data: Pointer): IOldCefTask;
begin
  if (data <> nil) then
    Result := Create(data) as IOldCefTask
   else
    Result := nil;
end;


// TOldCefFastTask


constructor TOldCefFastTask.Create(const method: TOldCefFastTaskProc);
begin
  inherited Create;

  FMethod := method;
end;

procedure TOldCefFastTask.Execute;
begin
  FMethod();
end;

class procedure TOldCefFastTask.New(threadId: TOldCefThreadId; const method: TOldCefFastTaskProc);
begin
  CefPostTask(threadId, Create(method));
end;

class procedure TOldCefFastTask.NewDelayed(threadId: TOldCefThreadId; Delay: Int64; const method: TOldCefFastTaskProc);
begin
  CefPostDelayedTask(threadId, Create(method), Delay);
end;


// TOldCefUpdatePrefsTask


constructor TOldCefUpdatePrefsTask.Create(const aEvents : IOldChromiumEvents);
begin
  inherited Create;

  FEvents := Pointer(aEvents);
end;

destructor TOldCefUpdatePrefsTask.Destroy;
begin
  FEvents := nil;

  inherited Destroy;
end;

procedure TOldCefUpdatePrefsTask.Execute;
begin
  try
    try
      if (FEvents <> nil) then IOldChromiumEvents(FEvents).doUpdateOwnPreferences;
    except
      on e : exception do
        if CustomExceptionHandler('TOldCefUpdatePrefsTask.Execute', e) then raise;
    end;
  finally
    FEvents := nil;
  end;
end;


// TOldCefSavePrefsTask


constructor TOldCefSavePrefsTask.Create(const aEvents : IOldChromiumEvents);
begin
  inherited Create;

  FEvents := Pointer(aEvents);
end;

destructor TOldCefSavePrefsTask.Destroy;
begin
  FEvents := nil;

  inherited Destroy;
end;

procedure TOldCefSavePrefsTask.Execute;
begin
  try
    try
      if (FEvents <> nil) then IOldChromiumEvents(FEvents).doSavePreferences;
    except
      on e : exception do
        if CustomExceptionHandler('TOldCefSavePrefsTask.Execute', e) then raise;
    end;
  finally
    FEvents := nil;
  end;
end;


// TOldCefURLRequestTask

procedure TOldCefURLRequestTask.Execute;
begin
  try
    try
      if (FEvents <> nil) then IOldCEFUrlRequestClientEvents(FEvents).doOnCreateURLRequest;
    except
      on e : exception do
        if CustomExceptionHandler('TOldCefURLRequestTask.Execute', e) then raise;
    end;
  finally
    FEvents := nil;
  end;
end;

constructor TOldCefURLRequestTask.Create(const aEvents : IOldCEFUrlRequestClientEvents);
begin
  inherited Create;

  FEvents := Pointer(aEvents);
end;

destructor TOldCefURLRequestTask.Destroy;
begin
  FEvents := nil;

  inherited Destroy;
end;

end.
