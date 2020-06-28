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

unit oldCEFPostDataElement;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefPostDataElementRef = class(TOldCefBaseRef, IOldCefPostDataElement)
    protected
      function  IsReadOnly: Boolean;
      procedure SetToEmpty;
      procedure SetToFile(const fileName: oldustring);
      procedure SetToBytes(size: NativeUInt; const bytes: Pointer);
      function  GetType: TOldCefPostDataElementType;
      function  GetFile: oldustring;
      function  GetBytesCount: NativeUInt;
      function  GetBytes(size: NativeUInt; bytes: Pointer): NativeUInt;

    public
      class function UnWrap(data: Pointer): IOldCefPostDataElement;
      class function New: IOldCefPostDataElement;
  end;

  TOldCefPostDataElementOwn = class(TOldCefBaseOwn, IOldCefPostDataElement)
    protected
      FDataType  : TOldCefPostDataElementType;
      FValueByte : Pointer;
      FValueStr  : TOldCefString;
      FSize      : NativeUInt;
      FReadOnly  : Boolean;

      procedure Clear;
      function  IsReadOnly: Boolean; virtual;
      procedure SetToEmpty; virtual;
      procedure SetToFile(const fileName: oldustring); virtual;
      procedure SetToBytes(size: NativeUInt; const bytes: Pointer); virtual;
      function  GetType: TOldCefPostDataElementType; virtual;
      function  GetFile: oldustring; virtual;
      function  GetBytesCount: NativeUInt; virtual;
      function  GetBytes(size: NativeUInt; bytes: Pointer): NativeUInt; virtual;

    public
      constructor Create(readonly: Boolean); virtual;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions;


// **************************************************
// ************* TOldCefPostDataElementRef *************
// **************************************************


function TOldCefPostDataElementRef.IsReadOnly: Boolean;
begin
  Result := POldCefPostDataElement(FData)^.is_read_only(POldCefPostDataElement(FData)) <> 0;
end;

function TOldCefPostDataElementRef.GetBytes(size: NativeUInt; bytes: Pointer): NativeUInt;
begin
  Result := POldCefPostDataElement(FData)^.get_bytes(POldCefPostDataElement(FData), size, bytes);
end;

function TOldCefPostDataElementRef.GetBytesCount: NativeUInt;
begin
  Result := POldCefPostDataElement(FData)^.get_bytes_count(POldCefPostDataElement(FData));
end;

function TOldCefPostDataElementRef.GetFile: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefPostDataElement(FData)^.get_file(POldCefPostDataElement(FData)));
end;

function TOldCefPostDataElementRef.GetType: TOldCefPostDataElementType;
begin
  Result := POldCefPostDataElement(FData)^.get_type(POldCefPostDataElement(FData));
end;

class function TOldCefPostDataElementRef.New: IOldCefPostDataElement;
begin
  Result := UnWrap(cef_post_data_element_create);
end;

procedure TOldCefPostDataElementRef.SetToBytes(size: NativeUInt; const bytes: Pointer);
begin
  POldCefPostDataElement(FData)^.set_to_bytes(POldCefPostDataElement(FData), size, bytes);
end;

procedure TOldCefPostDataElementRef.SetToEmpty;
begin
  POldCefPostDataElement(FData)^.set_to_empty(POldCefPostDataElement(FData));
end;

procedure TOldCefPostDataElementRef.SetToFile(const fileName: oldustring);
var
  TempFileName : TOldCefString;
begin
  TempFileName := CefString(fileName);
  POldCefPostDataElement(FData)^.set_to_file(POldCefPostDataElement(FData), @TempFileName);
end;

class function TOldCefPostDataElementRef.UnWrap(data: Pointer): IOldCefPostDataElement;
begin
  if (data <> nil) then
    Result := Create(data) as IOldCefPostDataElement
   else
    Result := nil;
end;


// **************************************************
// ************* TOldCefPostDataElementOwn *************
// **************************************************


function cef_post_data_element_is_read_only(self: POldCefPostDataElement): Integer; stdcall;
var
  TempObject : TObject;
begin
  Result     := Ord(False);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefPostDataElementOwn) then
    Result := Ord(TOldCefPostDataElementOwn(TempObject).IsReadOnly);
end;

procedure cef_post_data_element_set_to_empty(self: POldCefPostDataElement); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefPostDataElementOwn) then
    TOldCefPostDataElementOwn(TempObject).SetToEmpty;
end;

procedure cef_post_data_element_set_to_file(      self     : POldCefPostDataElement;
                                            const fileName : POldCefString); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefPostDataElementOwn) then
    TOldCefPostDataElementOwn(TempObject).SetToFile(CefString(fileName));
end;

procedure cef_post_data_element_set_to_bytes(      self  : POldCefPostDataElement;
                                                   size  : NativeUInt;
                                             const bytes : Pointer); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefPostDataElementOwn) then
    TOldCefPostDataElementOwn(TempObject).SetToBytes(size, bytes);
end;

function cef_post_data_element_get_type(self: POldCefPostDataElement): TOldCefPostDataElementType; stdcall;
var
  TempObject : TObject;
begin
  Result     := PDE_TYPE_EMPTY;
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefPostDataElementOwn) then
    Result := TOldCefPostDataElementOwn(TempObject).GetType;
end;

function cef_post_data_element_get_file(self: POldCefPostDataElement): POldCefStringUserFree; stdcall;
var
  TempObject : TObject;
begin
  Result     := nil;
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefPostDataElementOwn) then
    Result := CefUserFreeString(TOldCefPostDataElementOwn(TempObject).GetFile);
end;

function cef_post_data_element_get_bytes_count(self: POldCefPostDataElement): NativeUInt; stdcall;
var
  TempObject : TObject;
begin
  Result     := 0;
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefPostDataElementOwn) then
    Result := TOldCefPostDataElementOwn(TempObject).GetBytesCount;
end;

function cef_post_data_element_get_bytes(self: POldCefPostDataElement; size: NativeUInt; bytes: Pointer): NativeUInt; stdcall;
var
  TempObject : TObject;
begin
  Result     := 0;
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefPostDataElementOwn) then
    Result := TOldCefPostDataElementOwn(TempObject).GetBytes(size, bytes)
end;

procedure TOldCefPostDataElementOwn.Clear;
begin
  case FDataType of
    PDE_TYPE_FILE  : CefStringFree(@FValueStr);

    PDE_TYPE_BYTES :
      if (FValueByte <> nil) then
        begin
          FreeMem(FValueByte);
          FValueByte := nil;
        end;
  end;

  FDataType := PDE_TYPE_EMPTY;
  FSize     := 0;
end;

constructor TOldCefPostDataElementOwn.Create(readonly: Boolean);
begin
  inherited CreateData(SizeOf(TOldCefPostDataElement));

  FReadOnly  := readonly;
  FDataType  := PDE_TYPE_EMPTY;
  FValueByte := nil;
  FillChar(FValueStr, SizeOf(FValueStr), 0);
  FSize      := 0;

  with POldCefPostDataElement(FData)^ do
    begin
      is_read_only    := cef_post_data_element_is_read_only;
      set_to_empty    := cef_post_data_element_set_to_empty;
      set_to_file     := cef_post_data_element_set_to_file;
      set_to_bytes    := cef_post_data_element_set_to_bytes;
      get_type        := cef_post_data_element_get_type;
      get_file        := cef_post_data_element_get_file;
      get_bytes_count := cef_post_data_element_get_bytes_count;
      get_bytes       := cef_post_data_element_get_bytes;
    end;
end;

function TOldCefPostDataElementOwn.GetBytes(size: NativeUInt; bytes: Pointer): NativeUInt;
begin
  if (FDataType = PDE_TYPE_BYTES) and (FValueByte <> nil) then
    begin
      if (size > FSize) then
        Result := FSize
       else
        Result := size;

      Move(FValueByte^, bytes^, Result);
    end
   else
    Result := 0;
end;

function TOldCefPostDataElementOwn.GetBytesCount: NativeUInt;
begin
  if (FDataType = PDE_TYPE_BYTES) then
    Result := FSize
   else
    Result := 0;
end;

function TOldCefPostDataElementOwn.GetFile: oldustring;
begin
  if (FDataType = PDE_TYPE_FILE) then
    Result := CefString(@FValueStr)
   else
    Result := '';
end;

function TOldCefPostDataElementOwn.GetType: TOldCefPostDataElementType;
begin
  Result := FDataType;
end;

function TOldCefPostDataElementOwn.IsReadOnly: Boolean;
begin
  Result := FReadOnly;
end;

procedure TOldCefPostDataElementOwn.SetToBytes(size: NativeUInt; const bytes: Pointer);
begin
  Clear;

  if (size > 0) and (bytes <> nil) then
    begin
      GetMem(FValueByte, size);
      Move(bytes^, FValueByte, size);
      FSize := size;
    end
   else
    begin
      FValueByte := nil;
      FSize      := 0;
    end;

  FDataType := PDE_TYPE_BYTES;
end;

procedure TOldCefPostDataElementOwn.SetToEmpty;
begin
  Clear;
end;

procedure TOldCefPostDataElementOwn.SetToFile(const fileName: oldustring);
begin
  Clear;

  FSize     := 0;
  FValueStr := CefStringAlloc(fileName);
  FDataType := PDE_TYPE_FILE;
end;

end.
