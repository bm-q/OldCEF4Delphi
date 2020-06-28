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

unit oldCEFRunFileDialogCallback;

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
  oldCEFBase, oldCEFInterfaces;

type
  TOldCefRunFileDialogCallbackOwn = class(TOldCefBaseOwn, IOldCefRunFileDialogCallback)
    protected
      procedure OnFileDialogDismissed(selectedAcceptFilter: Integer; const filePaths: TStrings); virtual;

    public
      constructor Create;
  end;

  TOldCefFastRunFileDialogCallback = class(TOldCefRunFileDialogCallbackOwn)
    protected
      FCallback: TOldCefRunFileDialogCallbackProc;

      procedure OnFileDialogDismissed(selectedAcceptFilter: Integer; const filePaths: TStrings); override;

    public
      constructor Create(callback: TOldCefRunFileDialogCallbackProc); reintroduce; virtual;
  end;

implementation

uses
  oldCEFTypes, oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFStringList;

procedure cef_run_file_dialog_callback_on_file_dialog_dismissed(self                   : POldCefRunFileDialogCallback;
                                                                selected_accept_filter : Integer;
                                                                file_paths             : TOldCefStringList); stdcall;
var
  TempSL     : TStringList;
  TemPOldCefSL  : IOldCefStringList;
  TempObject : TObject;
begin
  TempSL     := nil;
  TempObject := CefGetObject(self);

  try
    try
      if (TempObject <> nil) and (TempObject is TOldCefRunFileDialogCallbackOwn) then
        begin
          TempSL    := TStringList.Create;
          TemPOldCefSL := TOldCefStringListRef.Create(file_paths);
          TemPOldCefSL.CopyToStrings(TempSL);

          TOldCefRunFileDialogCallbackOwn(TempObject).OnFileDialogDismissed(selected_accept_filter, TempSL);
        end;
    except
      on e : exception do
        if CustomExceptionHandler('cef_run_file_dialog_callback_on_file_dialog_dismissed', e) then raise;
    end;
  finally
    if (TempSL <> nil) then FreeAndNil(TempSL);
  end;
end;

// TOldCefRunFileDialogCallbackOwn

constructor TOldCefRunFileDialogCallbackOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefRunFileDialogCallback));

  POldCefRunFileDialogCallback(FData).on_file_dialog_dismissed := cef_run_file_dialog_callback_on_file_dialog_dismissed;
end;

procedure TOldCefRunFileDialogCallbackOwn.OnFileDialogDismissed(selectedAcceptFilter: Integer; const filePaths: TStrings);
begin
 //
end;

// TOldCefFastRunFileDialogCallback

procedure TOldCefFastRunFileDialogCallback.OnFileDialogDismissed(selectedAcceptFilter: Integer; const filePaths: TStrings);
begin
  FCallback(selectedAcceptFilter, filePaths);
end;

constructor TOldCefFastRunFileDialogCallback.Create(callback: TOldCefRunFileDialogCallbackProc);
begin
  inherited Create;

  FCallback := callback;
end;

end.
