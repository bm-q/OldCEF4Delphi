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

unit oldCEFWriteHandler;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
  {$IFDEF MSWINDOWS}WinApi.Windows,{$ENDIF}
  {$ELSE}
  Windows,
  {$ENDIF}
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefWriteHandlerOwn = class(TOldCefBaseOwn, IOldCefWriteHandler)
    protected
      function Write(const ptr: Pointer; size, n: NativeUInt): NativeUInt; virtual;
      function Seek(offset: Int64; whence: Integer): Integer; virtual;
      function Tell: Int64; virtual;
      function Flush: Integer; virtual;
      function MayBlock: Boolean; virtual;
    public
      constructor Create; virtual;
  end;

  TOldCefBytesWriteHandler = class(TOldCefWriteHandlerOwn)
    protected
      FCriticalSection : TRTLCriticalSection;

      FGrow       : NativeUInt;
      FBuffer     : Pointer;
      FBufferSize : int64;
      FOffset     : int64;

      function Grow(size : NativeUInt) : NativeUInt;

    public
      constructor Create(aGrow : NativeUInt); reintroduce;
      destructor  Destroy; override;

      function Write(const ptr: Pointer; size, n: NativeUInt): NativeUInt; override;
      function Seek(offset: Int64; whence: Integer): Integer; override;
      function Tell: Int64; override;
      function Flush: Integer; override;
      function MayBlock: Boolean; override;

      function GetData : pointer;
      function GetDataSize : int64;
  end;

implementation

uses
  {$IFDEF DELPHI16_UP}
  System.Math,
  {$ELSE}
  Math,
  {$ENDIF}
  oldCEFMiscFunctions, oldCEFLibFunctions;


// *******************************************
// *********** TOldCefWriteHandlerOwn ***********
// *******************************************

function cef_write_handler_write(      self : POldCefWriteHandler;
                                 const ptr  : Pointer;
                                       size : NativeUInt;
                                       n    : NativeUInt): NativeUInt; stdcall;
var
  TempObject : TObject;
begin
  Result     := 0;
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefWriteHandlerOwn) then
    Result:= TOldCefWriteHandlerOwn(TempObject).Write(ptr,
                                                   size,
                                                   n);
end;

function cef_write_handler_seek(self   : POldCefWriteHandler;
                                offset : Int64;
                                whence : Integer): Integer; stdcall;
var
  TempObject : TObject;
begin
  Result     := 0;
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefWriteHandlerOwn) then
    Result:= TOldCefWriteHandlerOwn(TempObject).Seek(offset,
                                                  whence);
end;

function cef_write_handler_tell(self: POldCefWriteHandler): Int64; stdcall;
var
  TempObject : TObject;
begin
  Result     := 0;
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefWriteHandlerOwn) then
    Result:= TOldCefWriteHandlerOwn(TempObject).Tell;
end;

function cef_write_handler_flush(self: POldCefWriteHandler): Integer; stdcall;
var
  TempObject : TObject;
begin
  Result     := 0;
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefWriteHandlerOwn) then
    Result:= TOldCefWriteHandlerOwn(TempObject).Flush;
end;

function cef_write_handler_may_block(self: POldCefWriteHandler): Integer; stdcall;
var
  TempObject : TObject;
begin
  Result     := Ord(False);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefWriteHandlerOwn) then
    Result := Ord(TOldCefWriteHandlerOwn(TempObject).MayBlock);
end;

constructor TOldCefWriteHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefWriteHandler));

  with POldCefWriteHandler(FData)^ do
    begin
      write     := cef_write_handler_write;
      seek      := cef_write_handler_seek;
      tell      := cef_write_handler_tell;
      flush     := cef_write_handler_flush;
      may_block := cef_write_handler_may_block;
    end;
end;

function TOldCefWriteHandlerOwn.Flush: Integer;
begin
  Result := 0;
end;

function TOldCefWriteHandlerOwn.MayBlock: Boolean;
begin
  Result := False;
end;

function TOldCefWriteHandlerOwn.Seek(offset: Int64; whence: Integer): Integer;
begin
  Result := 0;
end;

function TOldCefWriteHandlerOwn.Tell: Int64;
begin
  Result := 0;
end;

function TOldCefWriteHandlerOwn.Write(const ptr: Pointer; size, n: NativeUInt): NativeUInt;
begin
  Result := 0;
end;


// *******************************************
// ********** TOldCefBytesWriteHandler **********
// *******************************************

constructor TOldCefBytesWriteHandler.Create(aGrow : NativeUInt);
begin
  inherited Create;

  InitializeCriticalSection(FCriticalSection);

  FGrow       := aGrow;
  FBufferSize := aGrow;
  FOffset     := 0;

  GetMem(FBuffer, aGrow);
end;

destructor TOldCefBytesWriteHandler.Destroy;
begin
  if (FBuffer <> nil) then FreeMem(FBuffer);

  DeleteCriticalSection(FCriticalSection);

  FCriticalSection.DebugInfo      := nil;
  FCriticalSection.LockCount      := 0;
  FCriticalSection.RecursionCount := 0;
  FCriticalSection.OwningThread   := 0;
  FCriticalSection.LockSemaphore  := 0;
  FCriticalSection.Reserved       := 0;

  inherited Destroy;
end;

function TOldCefBytesWriteHandler.Write(const ptr: Pointer; size, n: NativeUInt): NativeUInt;
var
  TempPointer : pointer;
  TempSize    : int64;
begin
  EnterCriticalSection(FCriticalSection);

  TempSize := size * n;

  if ((FOffset + TempSize) >= FBufferSize) and (Grow(TempSize) = 0) then
    Result := 0
   else
    begin
      TempPointer := Pointer(cardinal(FBuffer) + FOffset);

      CopyMemory(TempPointer, ptr, TempSize);

      FOffset := FOffset + TempSize;
      Result  := n;
    end;

  LeaveCriticalSection(FCriticalSection);
end;

function TOldCefBytesWriteHandler.Seek(offset: Int64; whence: Integer): Integer;
const
  SEEK_SET = 0;
  SEEK_CUR = 1;
  SEEK_END = 2;
var
  TempAbsOffset : int64;
begin
  EnterCriticalSection(FCriticalSection);

  Result := -1;

  case whence of
    SEEK_CUR :
      if not((FOffset + offset > FBufferSize) or (FOffset + offset < 0)) then
        begin
          FOffset := FOffset + offset;
          Result  := 0;
        end;

    SEEK_END:
      begin
        TempAbsOffset := abs(offset);

        if not(TempAbsOffset > FBufferSize) then
          begin
            FOffset := FBufferSize - TempAbsOffset;
            Result  := 0;
          end;
      end;

    SEEK_SET:
      if not((offset > FBufferSize) or (offset < 0)) then
        begin
          FOffset := offset;
          Result  := 0;
        end;
  end;

  LeaveCriticalSection(FCriticalSection);
end;

function TOldCefBytesWriteHandler.Tell: Int64;
begin
  EnterCriticalSection(FCriticalSection);

  Result := FOffset;

  LeaveCriticalSection(FCriticalSection);
end;

function TOldCefBytesWriteHandler.Flush: Integer;
begin
  Result := 0;
end;

function TOldCefBytesWriteHandler.MayBlock: Boolean;
begin
  Result := False;
end;

function TOldCefBytesWriteHandler.GetData : pointer;
begin
  Result := FBuffer;
end;

function TOldCefBytesWriteHandler.GetDataSize : int64;
begin
  Result := FBufferSize;
end;

function TOldCefBytesWriteHandler.Grow(size : NativeUInt) : NativeUInt;
var
  TempTotal : int64;
begin
  try
    EnterCriticalSection(FCriticalSection);

    TempTotal := max(size, FGrow);
    inc(TempTotal, FBufferSize);

    ReallocMem(FBuffer, TempTotal);

    FBufferSize := TempTotal;
    Result      := FBufferSize;
  finally
    LeaveCriticalSection(FCriticalSection);
  end;
end;

end.
