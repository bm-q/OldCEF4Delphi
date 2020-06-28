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

unit oldCEFZipReader;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefZipReaderRef = class(TOldCefBaseRef, IOldCefZipReader)
  protected
    function MoveToFirstFile: Boolean;
    function MoveToNextFile: Boolean;
    function MoveToFile(const fileName: oldustring; caseSensitive: Boolean): Boolean;
    function Close: Boolean;
    function GetFileName: oldustring;
    function GetFileSize: Int64;
    function GetFileLastModified: TOldCefTime;
    function OpenFile(const password: oldustring): Boolean;
    function CloseFile: Boolean;
    function ReadFile(buffer: Pointer; bufferSize: NativeUInt): Integer;
    function Tell: Int64;
    function Eof: Boolean;
  public
    class function UnWrap(data: Pointer): IOldCefZipReader;
    class function New(const stream: IOldCefStreamReader): IOldCefZipReader;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions;

function TOldCefZipReaderRef.Close: Boolean;
begin
  Result := POldCefZipReader(FData).close(FData) <> 0;
end;

function TOldCefZipReaderRef.CloseFile: Boolean;
begin
  Result := POldCefZipReader(FData).close_file(FData) <> 0;
end;

class function TOldCefZipReaderRef.New(const stream: IOldCefStreamReader): IOldCefZipReader;
begin
  Result := UnWrap(cef_zip_reader_create(CefGetData(stream)));
end;

function TOldCefZipReaderRef.Eof: Boolean;
begin
  Result := POldCefZipReader(FData).eof(FData) <> 0;
end;

function TOldCefZipReaderRef.GetFileLastModified: TOldCefTime;
begin
  Result := POldCefZipReader(FData).get_file_last_modified(FData);
end;

function TOldCefZipReaderRef.GetFileName: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefZipReader(FData).get_file_name(FData));
end;

function TOldCefZipReaderRef.GetFileSize: Int64;
begin
  Result := POldCefZipReader(FData).get_file_size(FData);
end;

function TOldCefZipReaderRef.MoveToFile(const fileName: oldustring;
  caseSensitive: Boolean): Boolean;
var
  f: TOldCefString;
begin
  f := CefString(fileName);
  Result := POldCefZipReader(FData).move_to_file(FData, @f, Ord(caseSensitive)) <> 0;
end;

function TOldCefZipReaderRef.MoveToFirstFile: Boolean;
begin
  Result := POldCefZipReader(FData).move_to_first_file(FData) <> 0;
end;

function TOldCefZipReaderRef.MoveToNextFile: Boolean;
begin
  Result := POldCefZipReader(FData).move_to_next_file(FData) <> 0;
end;

function TOldCefZipReaderRef.OpenFile(const password: oldustring): Boolean;
var
  p: TOldCefString;
begin
  p := CefString(password);
  Result := POldCefZipReader(FData).open_file(FData, @p) <> 0;
end;

function TOldCefZipReaderRef.ReadFile(buffer: Pointer;
  bufferSize: NativeUInt): Integer;
begin
    Result := POldCefZipReader(FData).read_file(FData, buffer, buffersize);
end;

function TOldCefZipReaderRef.Tell: Int64;
begin
  Result := POldCefZipReader(FData).tell(FData);
end;

class function TOldCefZipReaderRef.UnWrap(data: Pointer): IOldCefZipReader;
begin
  if data <> nil then
    Result := Create(data) as IOldCefZipReader else
    Result := nil;
end;

end.
