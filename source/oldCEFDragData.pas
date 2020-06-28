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

unit oldCEFDragData;

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
  TOldCefDragDataRef = class(TOldCefBaseRef, IOldCefDragData)
  protected
    function Clone: IOldCefDragData;
    function IsReadOnly: Boolean;
    function IsLink: Boolean;
    function IsFragment: Boolean;
    function IsFile: Boolean;
    function GetLinkUrl: oldustring;
    function GetLinkTitle: oldustring;
    function GetLinkMetadata: oldustring;
    function GetFragmentText: oldustring;
    function GetFragmentHtml: oldustring;
    function GetFragmentBaseUrl: oldustring;
    function GetFileName: oldustring;
    function GetFileContents(const writer: IOldCefStreamWriter): NativeUInt;
    function GetFileNames(var names: TStrings): Integer;
    procedure SetLinkUrl(const url: oldustring);
    procedure SetLinkTitle(const title: oldustring);
    procedure SetLinkMetadata(const data: oldustring);
    procedure SetFragmentText(const text: oldustring);
    procedure SetFragmentHtml(const html: oldustring);
    procedure SetFragmentBaseUrl(const baseUrl: oldustring);
    procedure ResetFileContents;
    procedure AddFile(const path, displayName: oldustring);
  public
    class function UnWrap(data: Pointer): IOldCefDragData;
    class function New: IOldCefDragData;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFStringList;

procedure TOldCefDragDataRef.AddFile(const path, displayName: oldustring);
var
  p, d: TOldCefString;
begin
  p := CefString(path);
  d := CefString(displayName);
  POldCefDragData(FData).add_file(FData, @p, @d);
end;

function TOldCefDragDataRef.Clone: IOldCefDragData;
begin
  Result := UnWrap(POldCefDragData(FData).clone(FData));
end;

function TOldCefDragDataRef.GetFileContents(
  const writer: IOldCefStreamWriter): NativeUInt;
begin
  Result := POldCefDragData(FData).get_file_contents(FData, CefGetData(writer))
end;

function TOldCefDragDataRef.GetFileName: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefDragData(FData).get_file_name(FData));
end;

function TOldCefDragDataRef.GetFileNames(var names: TStrings): Integer;
var
  TempSL : IOldCefStringList;
begin
  Result := 0;

  if (names <> nil) then
    begin
      TempSL := TOldCefStringListOwn.Create;

      if (POldCefDragData(FData).get_file_names(FData, TempSL.Handle) <> 0) then
        begin
          TempSL.CopyToStrings(names);
          Result := names.Count;
        end;
    end;
end;

function TOldCefDragDataRef.GetFragmentBaseUrl: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefDragData(FData).get_fragment_base_url(FData));
end;

function TOldCefDragDataRef.GetFragmentHtml: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefDragData(FData).get_fragment_html(FData));
end;

function TOldCefDragDataRef.GetFragmentText: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefDragData(FData).get_fragment_text(FData));
end;

function TOldCefDragDataRef.GetLinkMetadata: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefDragData(FData).get_link_metadata(FData));
end;

function TOldCefDragDataRef.GetLinkTitle: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefDragData(FData).get_link_title(FData));
end;

function TOldCefDragDataRef.GetLinkUrl: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefDragData(FData).get_link_url(FData));
end;

function TOldCefDragDataRef.IsFile: Boolean;
begin
  Result := POldCefDragData(FData).is_file(FData) <> 0;
end;

function TOldCefDragDataRef.IsFragment: Boolean;
begin
  Result := POldCefDragData(FData).is_fragment(FData) <> 0;
end;

function TOldCefDragDataRef.IsLink: Boolean;
begin
  Result := POldCefDragData(FData).is_link(FData) <> 0;
end;

function TOldCefDragDataRef.IsReadOnly: Boolean;
begin
  Result := POldCefDragData(FData).is_read_only(FData) <> 0;
end;

class function TOldCefDragDataRef.New: IOldCefDragData;
begin
  Result := UnWrap(cef_drag_data_create());
end;

procedure TOldCefDragDataRef.ResetFileContents;
begin
  POldCefDragData(FData).reset_file_contents(FData);
end;

procedure TOldCefDragDataRef.SetFragmentBaseUrl(const baseUrl: oldustring);
var
  s: TOldCefString;
begin
  s := CefString(baseUrl);
  POldCefDragData(FData).set_fragment_base_url(FData, @s);
end;

procedure TOldCefDragDataRef.SetFragmentHtml(const html: oldustring);
var
  s: TOldCefString;
begin
  s := CefString(html);
  POldCefDragData(FData).set_fragment_html(FData, @s);
end;

procedure TOldCefDragDataRef.SetFragmentText(const text: oldustring);
var
  s: TOldCefString;
begin
  s := CefString(text);
  POldCefDragData(FData).set_fragment_text(FData, @s);
end;

procedure TOldCefDragDataRef.SetLinkMetadata(const data: oldustring);
var
  s: TOldCefString;
begin
  s := CefString(data);
  POldCefDragData(FData).set_link_metadata(FData, @s);
end;

procedure TOldCefDragDataRef.SetLinkTitle(const title: oldustring);
var
  s: TOldCefString;
begin
  s := CefString(title);
  POldCefDragData(FData).set_link_title(FData, @s);
end;

procedure TOldCefDragDataRef.SetLinkUrl(const url: oldustring);
var
  s: TOldCefString;
begin
  s := CefString(url);
  POldCefDragData(FData).set_link_url(FData, @s);
end;

class function TOldCefDragDataRef.UnWrap(data: Pointer): IOldCefDragData;
begin
  if data <> nil then
    Result := Create(data) as IOldCefDragData else
    Result := nil;
end;


end.
