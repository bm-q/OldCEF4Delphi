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

unit oldCEFBase;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
  System.SysUtils,
  {$ELSE}
  SysUtils,
  {$ENDIF}
  oldCEFInterfaces;

type
  TOldLoggingInterfacedObject = class(TInterfacedObject)
    protected
      function _AddRef: Integer; reintroduce; stdcall;
      function _Release: Integer; reintroduce; stdcall;
    public
      class function NewInstance: TObject; override;
  end;


  TOldCefBaseOwn = class({$IFDEF INTFLOG}TLoggingInterfacedObject{$ELSE}TInterfacedObject{$ENDIF}, IOldCefBase)
    protected
      FData: Pointer;

    public
      constructor CreateData(size: Cardinal; owned : boolean = False); virtual;
      destructor  Destroy; override;
      function    SameAs(aData : Pointer) : boolean;
      function    Wrap: Pointer;
  end;

  TOldCefBaseRef = class(TInterfacedObject, IOldCefBase)
    protected
      FData: Pointer;

    public
      constructor Create(data: Pointer); virtual;
      destructor  Destroy; override;
      function    SameAs(aData : Pointer) : boolean;
      function    Wrap: Pointer;
      class function UnWrap(data: Pointer): IOldCefBase;
  end;



implementation

uses
  oldCEFTypes, oldCEFMiscFunctions, oldCEFConstants, oldCEFApplication;


// ***********************************************
// ************ TOldCefBaseOwn ************
// ***********************************************


procedure cef_base_add_ref(self: POldCefBase); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefBaseOwn) then
    TOldCefBaseOwn(TempObject)._AddRef;
end;

function cef_base_release_ref(self: POldCefBase): Integer; stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefBaseOwn) then
    Result := TOldCefBaseOwn(TempObject)._Release
   else
    Result := 0;
end;

function cef_base_has_one_ref(self: POldCefBase): Integer; stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefBaseOwn) then
    Result := Ord(TOldCefBaseOwn(TempObject).FRefCount = 1)
   else
    Result := Ord(False);
end;

procedure cef_base_add_ref_owned(self: POldCefBase); stdcall;
begin
  //
end;

function cef_base_release_owned(self: POldCefBase): Integer; stdcall;
begin
  Result := 1;
end;

function cef_base_has_one_ref_owned(self: POldCefBase): Integer; stdcall;
begin
  Result := 1;
end;

constructor TOldCefBaseOwn.CreateData(size: Cardinal; owned : boolean);
begin
  GetMem(FData, size + SizeOf(Pointer));
  PPointer(FData)^ := Self;
  Inc(PByte(FData), SizeOf(Pointer));
  FillChar(FData^, size, 0);
  POldCefBase(FData)^.size := size;

  if owned then
    begin
      POldCefBase(FData)^.add_ref     := cef_base_add_ref_owned;
      POldCefBase(FData)^.release     := cef_base_release_owned;
      POldCefBase(FData)^.has_one_ref := cef_base_has_one_ref_owned;
    end
   else
    begin
      POldCefBase(FData)^.add_ref     := cef_base_add_ref;
      POldCefBase(FData)^.release     := cef_base_release_ref;
      POldCefBase(FData)^.has_one_ref := cef_base_has_one_ref;
    end;
end;

destructor TOldCefBaseOwn.Destroy;
var
  TempPointer : pointer;
begin
  try
    if (FData <> nil) then
      begin
        TempPointer := FData;
        Dec(PByte(TempPointer), SizeOf(Pointer));
        FillChar(TempPointer^, SizeOf(Pointer) + SizeOf(TOldCefBase), 0);
        FreeMem(TempPointer);
      end;
  finally
    FData := nil;
    inherited Destroy;
  end;
end;

function TOldCefBaseOwn.SameAs(aData : Pointer) : boolean;
begin
  Result := (FData = aData);
end;

function TOldCefBaseOwn.Wrap: Pointer;
begin
  Result := FData;

  if (FData <> nil) and Assigned(POldCefBase(FData)^.add_ref) then
    POldCefBase(FData)^.add_ref(POldCefBase(FData));
end;


// ***********************************************
// ************ TOldCefBaseRef ************
// ***********************************************


constructor TOldCefBaseRef.Create(data: Pointer);
begin
  Assert(data <> nil);
  FData := data;
end;

destructor TOldCefBaseRef.Destroy;
begin
  try
    if (FData <> nil) and assigned(POldCefBase(FData)^.release) then
      begin
        {$IFDEF INTFLOG}
        CefDebugLog(ClassName + '.Destroy -> FRefCount = ' +
                    IntToStr(POldCefBaseRefCounted(FData)^.release(POldCefBaseRefCounted(FData))));
        {$ELSE}
        POldCefBase(FData)^.release(POldCefBase(FData));
        {$ENDIF}
      end;
  finally
    FData := nil;
    inherited Destroy;
  end;
end;

function TOldCefBaseRef.SameAs(aData : Pointer) : boolean;
begin
  Result := (FData = aData);
end;

class function TOldCefBaseRef.UnWrap(data: Pointer): IOldCefBase;
begin
  if (data <> nil) then
    Result := Create(data) as IOldCefBase
   else
    Result := nil;
end;

function TOldCefBaseRef.Wrap: Pointer;
begin
  Result := FData;

  if (FData <> nil) and Assigned(POldCefBase(FData)^.add_ref) then
    begin
      POldCefBase(FData)^.add_ref(POldCefBase(FData));
      {$IFDEF INTFLOG}
      CefDebugLog(ClassName + '.Wrap');
      {$ENDIF}
    end;
end;


// ************************************************
// *********** TLoggingInterfacedObject ***********
// ************************************************


function TOldLoggingInterfacedObject._AddRef: Integer;
begin
  Result := inherited _AddRef;
  CefDebugLog(ClassName + '._AddRef -> FRefCount = ' + IntToStr(Result));
end;

function TOldLoggingInterfacedObject._Release: Integer;
begin
  CefDebugLog(ClassName + '._Release -> FRefCount = ' + IntToStr(pred(RefCount)));
  Result := inherited _Release;
end;

class function TOldLoggingInterfacedObject.NewInstance: TObject;
begin
  Result := inherited NewInstance;
  CefDebugLog(ClassName + '.NewInstance -> FRefCount = ' + IntToStr(TInterfacedObject(Result).RefCount));
end;

end.
