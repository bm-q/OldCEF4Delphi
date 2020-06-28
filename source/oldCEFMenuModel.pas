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

unit oldCEFMenuModel;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefMenuModelRef = class(TOldCefBaseRef, IOldCefMenuModel)
  protected
    function Clear: Boolean;
    function GetCount: Integer;
    function AddSeparator: Boolean;
    function AddItem(commandId: Integer; const text: oldustring): Boolean;
    function AddCheckItem(commandId: Integer; const text: oldustring): Boolean;
    function AddRadioItem(commandId: Integer; const text: oldustring; groupId: Integer): Boolean;
    function AddSubMenu(commandId: Integer; const text: oldustring): IOldCefMenuModel;
    function InsertSeparatorAt(index: Integer): Boolean;
    function InsertItemAt(index, commandId: Integer; const text: oldustring): Boolean;
    function InsertCheckItemAt(index, commandId: Integer; const text: oldustring): Boolean;
    function InsertRadioItemAt(index, commandId: Integer; const text: oldustring; groupId: Integer): Boolean;
    function InsertSubMenuAt(index, commandId: Integer; const text: oldustring): IOldCefMenuModel;
    function Remove(commandId: Integer): Boolean;
    function RemoveAt(index: Integer): Boolean;
    function GetIndexOf(commandId: Integer): Integer;
    function GetCommandIdAt(index: Integer): Integer;
    function SetCommandIdAt(index, commandId: Integer): Boolean;
    function GetLabel(commandId: Integer): oldustring;
    function GetLabelAt(index: Integer): oldustring;
    function SetLabel(commandId: Integer; const text: oldustring): Boolean;
    function SetLabelAt(index: Integer; const text: oldustring): Boolean;
    function GetType(commandId: Integer): TOldCefMenuItemType;
    function GetTypeAt(index: Integer): TOldCefMenuItemType;
    function GetGroupId(commandId: Integer): Integer;
    function GetGroupIdAt(index: Integer): Integer;
    function SetGroupId(commandId, groupId: Integer): Boolean;
    function SetGroupIdAt(index, groupId: Integer): Boolean;
    function GetSubMenu(commandId: Integer): IOldCefMenuModel;
    function GetSubMenuAt(index: Integer): IOldCefMenuModel;
    function IsVisible(commandId: Integer): Boolean;
    function isVisibleAt(index: Integer): Boolean;
    function SetVisible(commandId: Integer; visible: Boolean): Boolean;
    function SetVisibleAt(index: Integer; visible: Boolean): Boolean;
    function IsEnabled(commandId: Integer): Boolean;
    function IsEnabledAt(index: Integer): Boolean;
    function SetEnabled(commandId: Integer; enabled: Boolean): Boolean;
    function SetEnabledAt(index: Integer; enabled: Boolean): Boolean;
    function IsChecked(commandId: Integer): Boolean;
    function IsCheckedAt(index: Integer): Boolean;
    function setChecked(commandId: Integer; checked: Boolean): Boolean;
    function setCheckedAt(index: Integer; checked: Boolean): Boolean;
    function HasAccelerator(commandId: Integer): Boolean;
    function HasAcceleratorAt(index: Integer): Boolean;
    function SetAccelerator(commandId, keyCode: Integer; shiftPressed, ctrlPressed, altPressed: Boolean): Boolean;
    function SetAcceleratorAt(index, keyCode: Integer; shiftPressed, ctrlPressed, altPressed: Boolean): Boolean;
    function RemoveAccelerator(commandId: Integer): Boolean;
    function RemoveAcceleratorAt(index: Integer): Boolean;
    function GetAccelerator(commandId: Integer; out keyCode: Integer; out shiftPressed, ctrlPressed, altPressed: Boolean): Boolean;
    function GetAcceleratorAt(index: Integer; out keyCode: Integer; out shiftPressed, ctrlPressed, altPressed: Boolean): Boolean;
  public
    class function UnWrap(data: Pointer): IOldCefMenuModel;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions;


function TOldCefMenuModelRef.AddCheckItem(commandId: Integer;
  const text: oldustring): Boolean;
var
  t: TOldCefString;
begin
  t := CefString(text);
  Result := POldCefMenuModel(FData).add_check_item(POldCefMenuModel(FData), commandId, @t) <> 0;
end;

function TOldCefMenuModelRef.AddItem(commandId: Integer;
  const text: oldustring): Boolean;
var
  t: TOldCefString;
begin
  t := CefString(text);
  Result := POldCefMenuModel(FData).add_item(POldCefMenuModel(FData), commandId, @t) <> 0;
end;

function TOldCefMenuModelRef.AddRadioItem(commandId: Integer; const text: oldustring;
  groupId: Integer): Boolean;
var
  t: TOldCefString;
begin
  t := CefString(text);
  Result := POldCefMenuModel(FData).add_radio_item(POldCefMenuModel(FData), commandId, @t, groupId) <> 0;
end;

function TOldCefMenuModelRef.AddSeparator: Boolean;
begin
  Result := POldCefMenuModel(FData).add_separator(POldCefMenuModel(FData)) <> 0;
end;

function TOldCefMenuModelRef.AddSubMenu(commandId: Integer;
  const text: oldustring): IOldCefMenuModel;
var
  t: TOldCefString;
begin
  t := CefString(text);
  Result := TOldCefMenuModelRef.UnWrap(POldCefMenuModel(FData).add_sub_menu(POldCefMenuModel(FData), commandId, @t));
end;

function TOldCefMenuModelRef.Clear: Boolean;
begin
  Result := POldCefMenuModel(FData).clear(POldCefMenuModel(FData)) <> 0;
end;

function TOldCefMenuModelRef.GetAccelerator(commandId: Integer;
  out keyCode: Integer; out shiftPressed, ctrlPressed,
  altPressed: Boolean): Boolean;
var
  sp, cp, ap: Integer;
begin
  Result := POldCefMenuModel(FData).get_accelerator(POldCefMenuModel(FData),
    commandId, @keyCode, @sp, @cp, @ap) <> 0;
  shiftPressed := sp <> 0;
  ctrlPressed := cp <> 0;
  altPressed := ap <> 0;
end;

function TOldCefMenuModelRef.GetAcceleratorAt(index: Integer; out keyCode: Integer;
  out shiftPressed, ctrlPressed, altPressed: Boolean): Boolean;
var
  sp, cp, ap: Integer;
begin
  Result := POldCefMenuModel(FData).get_accelerator_at(POldCefMenuModel(FData),
    index, @keyCode, @sp, @cp, @ap) <> 0;
  shiftPressed := sp <> 0;
  ctrlPressed := cp <> 0;
  altPressed := ap <> 0;
end;

function TOldCefMenuModelRef.GetCommandIdAt(index: Integer): Integer;
begin
  Result := POldCefMenuModel(FData).get_command_id_at(POldCefMenuModel(FData), index);
end;

function TOldCefMenuModelRef.GetCount: Integer;
begin
  Result := POldCefMenuModel(FData).get_count(POldCefMenuModel(FData));
end;

function TOldCefMenuModelRef.GetGroupId(commandId: Integer): Integer;
begin
  Result := POldCefMenuModel(FData).get_group_id(POldCefMenuModel(FData), commandId);
end;

function TOldCefMenuModelRef.GetGroupIdAt(index: Integer): Integer;
begin
  Result := POldCefMenuModel(FData).get_group_id(POldCefMenuModel(FData), index);
end;

function TOldCefMenuModelRef.GetIndexOf(commandId: Integer): Integer;
begin
  Result := POldCefMenuModel(FData).get_index_of(POldCefMenuModel(FData), commandId);
end;

function TOldCefMenuModelRef.GetLabel(commandId: Integer): oldustring;
begin
  Result := CefStringFreeAndGet(POldCefMenuModel(FData).get_label(POldCefMenuModel(FData), commandId));
end;

function TOldCefMenuModelRef.GetLabelAt(index: Integer): oldustring;
begin
  Result := CefStringFreeAndGet(POldCefMenuModel(FData).get_label_at(POldCefMenuModel(FData), index));
end;

function TOldCefMenuModelRef.GetSubMenu(commandId: Integer): IOldCefMenuModel;
begin
  Result := TOldCefMenuModelRef.UnWrap(POldCefMenuModel(FData).get_sub_menu(POldCefMenuModel(FData), commandId));
end;

function TOldCefMenuModelRef.GetSubMenuAt(index: Integer): IOldCefMenuModel;
begin
  Result := TOldCefMenuModelRef.UnWrap(POldCefMenuModel(FData).get_sub_menu_at(POldCefMenuModel(FData), index));
end;

function TOldCefMenuModelRef.GetType(commandId: Integer): TOldCefMenuItemType;
begin
  Result := POldCefMenuModel(FData).get_type(POldCefMenuModel(FData), commandId);
end;

function TOldCefMenuModelRef.GetTypeAt(index: Integer): TOldCefMenuItemType;
begin
  Result := POldCefMenuModel(FData).get_type_at(POldCefMenuModel(FData), index);
end;

function TOldCefMenuModelRef.HasAccelerator(commandId: Integer): Boolean;
begin
  Result := POldCefMenuModel(FData).has_accelerator(POldCefMenuModel(FData), commandId) <> 0;
end;

function TOldCefMenuModelRef.HasAcceleratorAt(index: Integer): Boolean;
begin
  Result := POldCefMenuModel(FData).has_accelerator_at(POldCefMenuModel(FData), index) <> 0;
end;

function TOldCefMenuModelRef.InsertCheckItemAt(index, commandId: Integer;
  const text: oldustring): Boolean;
var
  t: TOldCefString;
begin
  t := CefString(text);
  Result := POldCefMenuModel(FData).insert_check_item_at(POldCefMenuModel(FData), index, commandId, @t) <> 0;
end;

function TOldCefMenuModelRef.InsertItemAt(index, commandId: Integer;
  const text: oldustring): Boolean;
var
  t: TOldCefString;
begin
  t := CefString(text);
  Result := POldCefMenuModel(FData).insert_item_at(POldCefMenuModel(FData), index, commandId, @t) <> 0;
end;

function TOldCefMenuModelRef.InsertRadioItemAt(index, commandId: Integer;
  const text: oldustring; groupId: Integer): Boolean;
var
  t: TOldCefString;
begin
  t := CefString(text);
  Result := POldCefMenuModel(FData).insert_radio_item_at(POldCefMenuModel(FData),
    index, commandId, @t, groupId) <> 0;
end;

function TOldCefMenuModelRef.InsertSeparatorAt(index: Integer): Boolean;
begin
  Result := POldCefMenuModel(FData).insert_separator_at(POldCefMenuModel(FData), index) <> 0;
end;

function TOldCefMenuModelRef.InsertSubMenuAt(index, commandId: Integer;
  const text: oldustring): IOldCefMenuModel;
var
  t: TOldCefString;
begin
  t := CefString(text);
  Result := TOldCefMenuModelRef.UnWrap(POldCefMenuModel(FData).insert_sub_menu_at(
    POldCefMenuModel(FData), index, commandId, @t));
end;

function TOldCefMenuModelRef.IsChecked(commandId: Integer): Boolean;
begin
  Result := POldCefMenuModel(FData).is_checked(POldCefMenuModel(FData), commandId) <> 0;
end;

function TOldCefMenuModelRef.IsCheckedAt(index: Integer): Boolean;
begin
  Result := POldCefMenuModel(FData).is_checked_at(POldCefMenuModel(FData), index) <> 0;
end;

function TOldCefMenuModelRef.IsEnabled(commandId: Integer): Boolean;
begin
  Result := POldCefMenuModel(FData).is_enabled(POldCefMenuModel(FData), commandId) <> 0;
end;

function TOldCefMenuModelRef.IsEnabledAt(index: Integer): Boolean;
begin
  Result := POldCefMenuModel(FData).is_enabled_at(POldCefMenuModel(FData), index) <> 0;
end;

function TOldCefMenuModelRef.IsVisible(commandId: Integer): Boolean;
begin
  Result := POldCefMenuModel(FData).is_visible(POldCefMenuModel(FData), commandId) <> 0;
end;

function TOldCefMenuModelRef.isVisibleAt(index: Integer): Boolean;
begin
  Result := POldCefMenuModel(FData).is_visible_at(POldCefMenuModel(FData), index) <> 0;
end;

function TOldCefMenuModelRef.Remove(commandId: Integer): Boolean;
begin
  Result := POldCefMenuModel(FData).remove(POldCefMenuModel(FData), commandId) <> 0;
end;

function TOldCefMenuModelRef.RemoveAccelerator(commandId: Integer): Boolean;
begin
  Result := POldCefMenuModel(FData).remove_accelerator(POldCefMenuModel(FData), commandId) <> 0;
end;

function TOldCefMenuModelRef.RemoveAcceleratorAt(index: Integer): Boolean;
begin
  Result := POldCefMenuModel(FData).remove_accelerator_at(POldCefMenuModel(FData), index) <> 0;
end;

function TOldCefMenuModelRef.RemoveAt(index: Integer): Boolean;
begin
  Result := POldCefMenuModel(FData).remove_at(POldCefMenuModel(FData), index) <> 0;
end;

function TOldCefMenuModelRef.SetAccelerator(commandId, keyCode: Integer;
  shiftPressed, ctrlPressed, altPressed: Boolean): Boolean;
begin
  Result := POldCefMenuModel(FData).set_accelerator(POldCefMenuModel(FData),
    commandId, keyCode, Ord(shiftPressed), Ord(ctrlPressed), Ord(altPressed)) <> 0;
end;

function TOldCefMenuModelRef.SetAcceleratorAt(index, keyCode: Integer;
  shiftPressed, ctrlPressed, altPressed: Boolean): Boolean;
begin
  Result := POldCefMenuModel(FData).set_accelerator_at(POldCefMenuModel(FData),
    index, keyCode, Ord(shiftPressed), Ord(ctrlPressed), Ord(altPressed)) <> 0;
end;

function TOldCefMenuModelRef.setChecked(commandId: Integer;
  checked: Boolean): Boolean;
begin
  Result := POldCefMenuModel(FData).set_checked(POldCefMenuModel(FData),
    commandId, Ord(checked)) <> 0;
end;

function TOldCefMenuModelRef.setCheckedAt(index: Integer;
  checked: Boolean): Boolean;
begin
  Result := POldCefMenuModel(FData).set_checked_at(POldCefMenuModel(FData), index, Ord(checked)) <> 0;
end;

function TOldCefMenuModelRef.SetCommandIdAt(index, commandId: Integer): Boolean;
begin
  Result := POldCefMenuModel(FData).set_command_id_at(POldCefMenuModel(FData), index, commandId) <> 0;
end;

function TOldCefMenuModelRef.SetEnabled(commandId: Integer;
  enabled: Boolean): Boolean;
begin
  Result := POldCefMenuModel(FData).set_enabled(POldCefMenuModel(FData), commandId, Ord(enabled)) <> 0;
end;

function TOldCefMenuModelRef.SetEnabledAt(index: Integer;
  enabled: Boolean): Boolean;
begin
  Result := POldCefMenuModel(FData).set_enabled_at(POldCefMenuModel(FData), index, Ord(enabled)) <> 0;
end;

function TOldCefMenuModelRef.SetGroupId(commandId, groupId: Integer): Boolean;
begin
  Result := POldCefMenuModel(FData).set_group_id(POldCefMenuModel(FData), commandId, groupId) <> 0;
end;

function TOldCefMenuModelRef.SetGroupIdAt(index, groupId: Integer): Boolean;
begin
  Result := POldCefMenuModel(FData).set_group_id_at(POldCefMenuModel(FData), index, groupId) <> 0;
end;

function TOldCefMenuModelRef.SetLabel(commandId: Integer;
  const text: oldustring): Boolean;
var
  t: TOldCefString;
begin
  t := CefString(text);
  Result := POldCefMenuModel(FData).set_label(POldCefMenuModel(FData), commandId, @t) <> 0;
end;

function TOldCefMenuModelRef.SetLabelAt(index: Integer;
  const text: oldustring): Boolean;
var
  t: TOldCefString;
begin
  t := CefString(text);
  Result := POldCefMenuModel(FData).set_label_at(POldCefMenuModel(FData), index, @t) <> 0;
end;

function TOldCefMenuModelRef.SetVisible(commandId: Integer;
  visible: Boolean): Boolean;
begin
  Result := POldCefMenuModel(FData).set_visible(POldCefMenuModel(FData), commandId, Ord(visible)) <> 0;
end;

function TOldCefMenuModelRef.SetVisibleAt(index: Integer;
  visible: Boolean): Boolean;
begin
  Result := POldCefMenuModel(FData).set_visible_at(POldCefMenuModel(FData), index, Ord(visible)) <> 0;
end;

class function TOldCefMenuModelRef.UnWrap(data: Pointer): IOldCefMenuModel;
begin
  if data <> nil then
    Result := Create(data) as IOldCefMenuModel else
    Result := nil;
end;


end.
