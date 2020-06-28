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

unit oldCEFPrintSettings;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefPrintSettingsRef = class(TOldCefBaseRef, IOldCefPrintSettings)
  protected
    function  IsValid: Boolean;
    function  IsReadOnly: Boolean;
    function  Copy: IOldCefPrintSettings;
    procedure SetOrientation(landscape: Boolean);
    function  IsLandscape: Boolean;
    procedure SetPrinterPrintableArea(const physicalSizeDeviceUnits: POldCefSize; const printableAreaDeviceUnits: POldCefRect; landscapeNeedsFlip: Boolean);
    procedure SetDeviceName(const name: oldustring);
    function  GetDeviceName: oldustring;
    procedure SetDpi(dpi: Integer);
    function  GetDpi: Integer;
    procedure SetPageRanges(const ranges: TOldCefPageRangeArray);
    function  GetPageRangesCount: NativeUInt;
    procedure GetPageRanges(out ranges: TOldCefPageRangeArray);
    procedure SetSelectionOnly(selectionOnly: Boolean);
    function  IsSelectionOnly: Boolean;
    procedure SetCollate(collate: Boolean);
    function  WillCollate: Boolean;
    procedure SetColorModel(model: TOldCefColorModel);
    function  GetColorModel: TOldCefColorModel;
    procedure SetCopies(copies: Integer);
    function  GetCopies: Integer;
    procedure SetDuplexMode(mode: TOldCefDuplexMode);
    function  GetDuplexMode: TOldCefDuplexMode;
  public
    class function New: IOldCefPrintSettings;
    class function UnWrap(data: Pointer): IOldCefPrintSettings;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions;


function TOldCefPrintSettingsRef.Copy: IOldCefPrintSettings;
begin
  Result := UnWrap(POldCefPrintSettings(FData).copy(FData))
end;

function TOldCefPrintSettingsRef.GetColorModel: TOldCefColorModel;
begin
  Result := POldCefPrintSettings(FData).get_color_model(FData);
end;

function TOldCefPrintSettingsRef.GetCopies: Integer;
begin
  Result := POldCefPrintSettings(FData).get_copies(FData);
end;

function TOldCefPrintSettingsRef.GetDeviceName: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefPrintSettings(FData).get_device_name(FData));
end;

function TOldCefPrintSettingsRef.GetDpi: Integer;
begin
  Result := POldCefPrintSettings(FData).get_dpi(FData);
end;

function TOldCefPrintSettingsRef.GetDuplexMode: TOldCefDuplexMode;
begin
  Result := POldCefPrintSettings(FData).get_duplex_mode(FData);
end;

procedure TOldCefPrintSettingsRef.GetPageRanges(out ranges: TOldCefPageRangeArray);
var
  len: NativeUInt;
begin
  len := GetPageRangesCount;
  SetLength(ranges, len);
  if len > 0 then
    POldCefPrintSettings(FData).get_page_ranges(FData, @len, @ranges[0]);
end;

function TOldCefPrintSettingsRef.GetPageRangesCount: NativeUInt;
begin
  Result := POldCefPrintSettings(FData).get_page_ranges_count(FData);
end;

function TOldCefPrintSettingsRef.IsLandscape: Boolean;
begin
  Result := POldCefPrintSettings(FData).is_landscape(FData) <> 0;
end;

function TOldCefPrintSettingsRef.IsReadOnly: Boolean;
begin
  Result := POldCefPrintSettings(FData).is_read_only(FData) <> 0;
end;

function TOldCefPrintSettingsRef.IsSelectionOnly: Boolean;
begin
  Result := POldCefPrintSettings(FData).is_selection_only(FData) <> 0;
end;

function TOldCefPrintSettingsRef.IsValid: Boolean;
begin
  Result := POldCefPrintSettings(FData).is_valid(FData) <> 0;
end;

class function TOldCefPrintSettingsRef.New: IOldCefPrintSettings;
begin
  Result := UnWrap(cef_print_settings_create);
end;

procedure TOldCefPrintSettingsRef.SetCollate(collate: Boolean);
begin
  POldCefPrintSettings(FData).set_collate(FData, Ord(collate));
end;

procedure TOldCefPrintSettingsRef.SetColorModel(model: TOldCefColorModel);
begin
  POldCefPrintSettings(FData).set_color_model(FData, model);
end;

procedure TOldCefPrintSettingsRef.SetCopies(copies: Integer);
begin
  POldCefPrintSettings(FData).set_copies(FData, copies);
end;

procedure TOldCefPrintSettingsRef.SetDeviceName(const name: oldustring);
var
  s: TOldCefString;
begin
  s := CefString(name);
  POldCefPrintSettings(FData).set_device_name(FData, @s);
end;

procedure TOldCefPrintSettingsRef.SetDpi(dpi: Integer);
begin
  POldCefPrintSettings(FData).set_dpi(FData, dpi);
end;

procedure TOldCefPrintSettingsRef.SetDuplexMode(mode: TOldCefDuplexMode);
begin
  POldCefPrintSettings(FData).set_duplex_mode(FData, mode);
end;

procedure TOldCefPrintSettingsRef.SetOrientation(landscape: Boolean);
begin
  POldCefPrintSettings(FData).set_orientation(FData, Ord(landscape));
end;

procedure TOldCefPrintSettingsRef.SetPageRanges(const ranges: TOldCefPageRangeArray);
var
  len: NativeUInt;
begin
  len := Length(ranges);
  if len > 0 then
    POldCefPrintSettings(FData).set_page_ranges(FData, len, @ranges[0]) else
    POldCefPrintSettings(FData).set_page_ranges(FData, 0, nil);
end;

procedure TOldCefPrintSettingsRef.SetPrinterPrintableArea(
  const physicalSizeDeviceUnits: POldCefSize;
  const printableAreaDeviceUnits: POldCefRect; landscapeNeedsFlip: Boolean);
begin
  POldCefPrintSettings(FData).set_printer_printable_area(FData, physicalSizeDeviceUnits,
    printableAreaDeviceUnits, Ord(landscapeNeedsFlip));
end;

procedure TOldCefPrintSettingsRef.SetSelectionOnly(selectionOnly: Boolean);
begin
  POldCefPrintSettings(FData).set_selection_only(FData, Ord(selectionOnly));
end;

class function TOldCefPrintSettingsRef.UnWrap(
  data: Pointer): IOldCefPrintSettings;
begin
  if data <> nil then
    Result := Create(data) as IOldCefPrintSettings else
    Result := nil;
end;

function TOldCefPrintSettingsRef.WillCollate: Boolean;
begin
  Result := POldCefPrintSettings(FData).will_collate(FData) <> 0;
end;

end.
