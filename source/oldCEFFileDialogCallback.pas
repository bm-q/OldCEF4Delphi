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

unit oldCEFFileDialogCallback;

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
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefFileDialogCallbackRef = class(TOldCefBaseRef, IOldCefFileDialogCallback)
  protected
    procedure Cont(selectedAcceptFilter: Integer; const filePaths: TStrings);
    procedure Cancel;
  public
    class function UnWrap(data: Pointer): IOldCefFileDialogCallback;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFStringList;

procedure TOldCefFileDialogCallbackRef.Cancel;
begin
  POldCefFileDialogCallback(FData).cancel(FData);
end;

procedure TOldCefFileDialogCallbackRef.Cont(selectedAcceptFilter: Integer; const filePaths: TStrings);
var
  TempSL : IOldCefStringList;
begin
  try
    TempSL := TOldCefStringListOwn.Create;
    TempSL.AddStrings(filePaths);

    POldCefFileDialogCallback(FData).cont(POldCefFileDialogCallback(FData),
                                       selectedAcceptFilter,
                                       TempSL.Handle);
  finally
    TempSL := nil;
  end;
end;

class function TOldCefFileDialogCallbackRef.UnWrap(data: Pointer): IOldCefFileDialogCallback;
begin
  if (data <> nil) then
    Result := Create(data) as IOldCefFileDialogCallback
   else
    Result := nil;
end;

end.
