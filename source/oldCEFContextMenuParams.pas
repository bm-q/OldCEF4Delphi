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

unit oldCEFContextMenuParams;

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
  TOldCefContextMenuParamsRef = class(TOldCefBaseRef, IOldCefContextMenuParams)
  protected
    function GetXCoord: Integer;
    function GetYCoord: Integer;
    function GetTypeFlags: TOldCefContextMenuTypeFlags;
    function GetLinkUrl: oldustring;
    function GetUnfilteredLinkUrl: oldustring;
    function GetSourceUrl: oldustring;
    function HasImageContents: Boolean;
    function GetPageUrl: oldustring;
    function GetFrameUrl: oldustring;
    function GetFrameCharset: oldustring;
    function GetMediaType: TOldCefContextMenuMediaType;
    function GetMediaStateFlags: TOldCefContextMenuMediaStateFlags;
    function GetSelectionText: oldustring;
    function GetMisspelledWord: oldustring;
    function GetDictionarySuggestions(const suggestions: TStringList): Boolean;
    function IsEditable: Boolean;
    function IsSpellCheckEnabled: Boolean;
    function GetEditStateFlags: TOldCefContextMenuEditStateFlags;
    function IsCustomMenu: Boolean;
    function IsPepperMenu: Boolean;
  public
    class function UnWrap(data: Pointer): IOldCefContextMenuParams;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFStringList;


function TOldCefContextMenuParamsRef.GetDictionarySuggestions(const suggestions : TStringList): Boolean;
var
  TempSL : IOldCefStringList;
begin
  Result := False;

  if (suggestions <> nil) then
    begin
      TempSL := TOldCefStringListOwn.Create;

      if (POldCefContextMenuParams(FData).get_dictionary_suggestions(POldCefContextMenuParams(FData), TempSL.Handle) <> 0) then
        begin
          TempSL.CopyToStrings(suggestions);
          Result := True;
        end;
    end;
end;

function TOldCefContextMenuParamsRef.GetEditStateFlags: TOldCefContextMenuEditStateFlags;
begin
  Result := POldCefContextMenuParams(FData).get_edit_state_flags(POldCefContextMenuParams(FData));
end;

function TOldCefContextMenuParamsRef.GetFrameCharset: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefContextMenuParams(FData).get_frame_charset(POldCefContextMenuParams(FData)));
end;

function TOldCefContextMenuParamsRef.GetFrameUrl: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefContextMenuParams(FData).get_frame_url(POldCefContextMenuParams(FData)));
end;

function TOldCefContextMenuParamsRef.GetLinkUrl: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefContextMenuParams(FData).get_link_url(POldCefContextMenuParams(FData)));
end;

function TOldCefContextMenuParamsRef.GetMediaStateFlags: TOldCefContextMenuMediaStateFlags;
begin
  Result := POldCefContextMenuParams(FData).get_media_state_flags(POldCefContextMenuParams(FData));
end;

function TOldCefContextMenuParamsRef.GetMediaType: TOldCefContextMenuMediaType;
begin
  Result := POldCefContextMenuParams(FData).get_media_type(POldCefContextMenuParams(FData));
end;

function TOldCefContextMenuParamsRef.GetMisspelledWord: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefContextMenuParams(FData).get_misspelled_word(POldCefContextMenuParams(FData)));
end;

function TOldCefContextMenuParamsRef.GetPageUrl: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefContextMenuParams(FData).get_page_url(POldCefContextMenuParams(FData)));
end;

function TOldCefContextMenuParamsRef.GetSelectionText: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefContextMenuParams(FData).get_selection_text(POldCefContextMenuParams(FData)));
end;

function TOldCefContextMenuParamsRef.GetSourceUrl: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefContextMenuParams(FData).get_source_url(POldCefContextMenuParams(FData)));
end;

function TOldCefContextMenuParamsRef.GetTypeFlags: TOldCefContextMenuTypeFlags;
begin
  Result := POldCefContextMenuParams(FData).get_type_flags(POldCefContextMenuParams(FData));
end;

function TOldCefContextMenuParamsRef.GetUnfilteredLinkUrl: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefContextMenuParams(FData).get_unfiltered_link_url(POldCefContextMenuParams(FData)));
end;

function TOldCefContextMenuParamsRef.GetXCoord: Integer;
begin
  Result := POldCefContextMenuParams(FData).get_xcoord(POldCefContextMenuParams(FData));
end;

function TOldCefContextMenuParamsRef.GetYCoord: Integer;
begin
  Result := POldCefContextMenuParams(FData).get_ycoord(POldCefContextMenuParams(FData));
end;

function TOldCefContextMenuParamsRef.IsCustomMenu: Boolean;
begin
  Result := POldCefContextMenuParams(FData).is_custom_menu(POldCefContextMenuParams(FData)) <> 0;
end;

function TOldCefContextMenuParamsRef.IsEditable: Boolean;
begin
  Result := POldCefContextMenuParams(FData).is_editable(POldCefContextMenuParams(FData)) <> 0;
end;

function TOldCefContextMenuParamsRef.IsPepperMenu: Boolean;
begin
  Result := POldCefContextMenuParams(FData).is_pepper_menu(POldCefContextMenuParams(FData)) <> 0;
end;

function TOldCefContextMenuParamsRef.IsSpellCheckEnabled: Boolean;
begin
  Result := POldCefContextMenuParams(FData).is_spell_check_enabled(POldCefContextMenuParams(FData)) <> 0;
end;

function TOldCefContextMenuParamsRef.HasImageContents: Boolean;
begin
  Result := POldCefContextMenuParams(FData).has_image_contents(POldCefContextMenuParams(FData)) <> 0;
end;

class function TOldCefContextMenuParamsRef.UnWrap(data: Pointer): IOldCefContextMenuParams;
begin
  if (data <> nil) then
    Result := Create(data) as IOldCefContextMenuParams
   else
    Result := nil;
end;

end.
