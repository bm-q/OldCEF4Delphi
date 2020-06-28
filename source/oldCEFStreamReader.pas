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

unit oldCEFStreamReader;

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
  TOldCefStreamReaderRef = class(TOldCefBaseRef, IOldCefStreamReader)
  protected
    function Read(ptr: Pointer; size, n: NativeUInt): NativeUInt;
    function Seek(offset: Int64; whence: Integer): Integer;
    function Tell: Int64;
    function Eof: Boolean;
    function MayBlock: Boolean;
  public
    class function UnWrap(data: Pointer): IOldCefStreamReader;
    class function CreateForFile(const filename: oldustring): IOldCefStreamReader;
    class function CreateForCustomStream(const stream: IOldCefCustomStreamReader): IOldCefStreamReader;
    class function CreateForStream(const stream: TSTream; owned: Boolean): IOldCefStreamReader;
    class function CreateForData(data: Pointer; size: NativeUInt): IOldCefStreamReader;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFCustomStreamReader;

class function TOldCefStreamReaderRef.CreateForCustomStream(
  const stream: IOldCefCustomStreamReader): IOldCefStreamReader;
begin
  Result := UnWrap(cef_stream_reader_create_for_handler(CefGetData(stream)))
end;

class function TOldCefStreamReaderRef.CreateForData(data: Pointer; size: NativeUInt): IOldCefStreamReader;
begin
  Result := UnWrap(cef_stream_reader_create_for_data(data, size))
end;

class function TOldCefStreamReaderRef.CreateForFile(const filename: oldustring): IOldCefStreamReader;
var
  f: TOldCefString;
begin
  f := CefString(filename);
  Result := UnWrap(cef_stream_reader_create_for_file(@f))
end;

class function TOldCefStreamReaderRef.CreateForStream(const stream: TSTream;
  owned: Boolean): IOldCefStreamReader;
begin
  Result := CreateForCustomStream(TOldCefCustomStreamReader.Create(stream, owned) as IOldCefCustomStreamReader);
end;

function TOldCefStreamReaderRef.Eof: Boolean;
begin
  Result := POldCefStreamReader(FData)^.eof(POldCefStreamReader(FData)) <> 0;
end;

function TOldCefStreamReaderRef.MayBlock: Boolean;
begin
  Result := POldCefStreamReader(FData)^.may_block(FData) <> 0;
end;

function TOldCefStreamReaderRef.Read(ptr: Pointer; size, n: NativeUInt): NativeUInt;
begin
  Result := POldCefStreamReader(FData)^.read(POldCefStreamReader(FData), ptr, size, n);
end;

function TOldCefStreamReaderRef.Seek(offset: Int64; whence: Integer): Integer;
begin
  Result := POldCefStreamReader(FData)^.seek(POldCefStreamReader(FData), offset, whence);
end;

function TOldCefStreamReaderRef.Tell: Int64;
begin
  Result := POldCefStreamReader(FData)^.tell(POldCefStreamReader(FData));
end;

class function TOldCefStreamReaderRef.UnWrap(data: Pointer): IOldCefStreamReader;
begin
  if data <> nil then
    Result := Create(data) as IOldCefStreamReader else
    Result := nil;
end;

end.
