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

unit oldCEFDialogHandler;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
  System.Classes,
  {$ELSE}
  Classes,
  {$ENDIF}
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefDialogHandlerOwn = class(TOldCefBaseOwn, IOldCefDialogHandler)
    protected
      function  OnFileDialog(const browser: IOldCefBrowser; mode: TOldCefFileDialogMode; const title, defaultFilePath: oldustring; const acceptFilters: TStrings; selectedAcceptFilter: Integer; const callback: IOldCefFileDialogCallback): Boolean; virtual;

      procedure RemoveReferences; virtual;

    public
      constructor Create; virtual;
  end;

  TOldCustomDialogHandler = class(TOldCefDialogHandlerOwn)
    protected
      FEvents : Pointer;

      function  OnFileDialog(const browser: IOldCefBrowser; mode: TOldCefFileDialogMode; const title: oldustring; const defaultFilePath: oldustring; const acceptFilters: TStrings; selectedAcceptFilter: Integer; const callback: IOldCefFileDialogCallback): Boolean; override;

      procedure RemoveReferences; override;

    public
      constructor Create(const events: Pointer); reintroduce; virtual;
      destructor  Destroy; override;
  end;

implementation

uses
  {$IFDEF DELPHI16_UP}
  System.SysUtils,
  {$ELSE}
  SysUtils,
  {$ENDIF}
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFBrowser, oldCEFFileDialogCallback, oldCEFStringList;

function cef_dialog_handler_on_file_dialog(self                    : POldCefDialogHandler;
                                           browser                 : POldCefBrowser;
                                           mode                    : TOldCefFileDialogMode;
                                           const title             : POldCefString;
                                           const default_file_path : POldCefString;
                                           accept_filters          : TOldCefStringList;
                                           selected_accept_filter  : Integer;
                                           callback                : POldCefFileDialogCallback): Integer; stdcall;
var
  TempSL     : TStringList;
  TemPOldCefSL  : IOldCefStringList;
  TempObject : TObject;
begin
  TempSL := nil;
  Result := Ord(False);

  try
    try
      TempObject := CefGetObject(self);

      if (TempObject <> nil) and (TempObject is TOldCefDialogHandlerOwn) then
        begin
          TempSL    := TStringList.Create;
          TemPOldCefSL := TOldCefStringListRef.Create(accept_filters);
          TemPOldCefSL.CopyToStrings(TempSL);

          Result := Ord(TOldCefDialogHandlerOwn(TempObject).OnFileDialog(TOldCefBrowserRef.UnWrap(browser),
                                                                      mode,
                                                                      CefString(title),
                                                                      CefString(default_file_path),
                                                                      TempSL,
                                                                      selected_accept_filter,
                                                                      TOldCefFileDialogCallbackRef.UnWrap(callback)));
        end;
    except
      on e : exception do
        if CustomExceptionHandler('cef_dialog_handler_on_file_dialog', e) then raise;
    end;
  finally
    if (TempSL <> nil) then FreeAndNil(TempSL);
  end;
end;

constructor TOldCefDialogHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefDialogHandler));

  POldCefDialogHandler(FData).on_file_dialog := cef_dialog_handler_on_file_dialog;
end;

function TOldCefDialogHandlerOwn.OnFileDialog(const browser                : IOldCefBrowser;
                                                 mode                   : TOldCefFileDialogMode;
                                           const title                  : oldustring;
                                           const defaultFilePath        : oldustring;
                                           const acceptFilters          : TStrings;
                                                 selectedAcceptFilter   : Integer;
                                           const callback               : IOldCefFileDialogCallback): Boolean;
begin
  Result := False;
end;

procedure TOldCefDialogHandlerOwn.RemoveReferences;
begin
  //
end;

// TCustomDialogHandler

constructor TOldCustomDialogHandler.Create(const events: Pointer);
begin
  inherited Create;

  FEvents := events;
end;

destructor TOldCustomDialogHandler.Destroy;
begin
  RemoveReferences;

  inherited Destroy;
end;

procedure TOldCustomDialogHandler.RemoveReferences;
begin
  FEvents := nil;
end;

function TOldCustomDialogHandler.OnFileDialog(const browser              : IOldCefBrowser;
                                                 mode                 : TOldCefFileDialogMode;
                                           const title                : oldustring;
                                           const defaultFilePath      : oldustring;
                                           const acceptFilters        : TStrings;
                                                 selectedAcceptFilter : Integer;
                                           const callback             : IOldCefFileDialogCallback): Boolean;
begin
  if (FEvents <> nil) then
    Result := IOldChromiumEvents(FEvents).doOnFileDialog(browser, mode, title, defaultFilePath,
                                                      acceptFilters, selectedAcceptFilter, callback)
   else
    Result := inherited OnFileDialog(browser, mode, title, defaultFilePath,
                                     acceptFilters, selectedAcceptFilter, callback);
end;

end.

