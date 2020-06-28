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

unit oldCEFNavigationEntryVisitor;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces;

type
  TOldCefNavigationEntryVisitorOwn = class(TOldCefBaseOwn, IOldCefNavigationEntryVisitor)
    protected
      function Visit(const entry: IOldCefNavigationEntry; current: Boolean; index, total: Integer): Boolean; virtual;

    public
      constructor Create;
  end;

  TOldCefFastNavigationEntryVisitor = class(TOldCefNavigationEntryVisitorOwn)
    protected
      FVisitor: TOldCefNavigationEntryVisitorProc;

      function Visit(const entry: IOldCefNavigationEntry; current: Boolean; index, total: Integer): Boolean; override;

    public
      constructor Create(const proc: TOldCefNavigationEntryVisitorProc); reintroduce;
  end;

implementation

uses
  oldCEFTypes, oldCEFMiscFunctions, oldCEFNavigationEntry;

function cef_navigation_entry_visitor_visit(self    : POldCefNavigationEntryVisitor;
                                            entry   : POldCefNavigationEntry;
                                            current : Integer;
                                            index   : Integer;
                                            total   : Integer): Integer; stdcall;
var
  TempObject : TObject;
begin
  Result     := Ord(False);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefNavigationEntryVisitorOwn) then
    Result := Ord(TOldCefNavigationEntryVisitorOwn(TempObject).Visit(TOldCefNavigationEntryRef.UnWrap(entry),
                                                                  current <> 0,
                                                                  index,
                                                                  total));
end;

// TOldCefNavigationEntryVisitorOwn

constructor TOldCefNavigationEntryVisitorOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefNavigationEntryVisitor));

  with POldCefNavigationEntryVisitor(FData)^ do
    visit := cef_navigation_entry_visitor_visit;
end;

function TOldCefNavigationEntryVisitorOwn.Visit(const entry   : IOldCefNavigationEntry;
                                                   current : Boolean;
                                                   index   : Integer;
                                                   total   : Integer): Boolean;
begin
  Result:= False;
end;

// TOldCefFastNavigationEntryVisitor

constructor TOldCefFastNavigationEntryVisitor.Create(const proc: TOldCefNavigationEntryVisitorProc);
begin
  FVisitor := proc;

  inherited Create;
end;

function TOldCefFastNavigationEntryVisitor.Visit(const entry   : IOldCefNavigationEntry;
                                                    current : Boolean;
                                                    index   : Integer;
                                                    total   : Integer): Boolean;
begin
  Result := FVisitor(entry, current, index, total);
end;

end.
