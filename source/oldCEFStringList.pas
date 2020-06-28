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

unit oldCEFStringList;

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
  TOldCefCustomStringList = class(TInterfacedObject, IOldCefStringList)
    protected
      FHandle : TOldCefStringList;

      function  GetHandle: TOldCefStringMap; virtual;
      function  GetSize: integer; virtual;
      function  GetValue(index: integer): oldustring; virtual;
      procedure Append(const value: oldustring); virtual;
      procedure Clear; virtual;
      function  Copy : TOldCefStringList; virtual;
      procedure CopyToStrings(const aStrings : TStrings); virtual;
      procedure AddStrings(const aStrings : TStrings); virtual;

    public
      constructor Create; virtual;
  end;

  TOldCefStringListOwn = class(TOldCefCustomStringList)
    public
      constructor Create; override;
      destructor  Destroy; override;
  end;

  TOldCefStringListRef = class(TOldCefCustomStringList)
    public
      constructor Create(aHandle : TOldCefStringList); reintroduce;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions;


// *****************************************
// ********* TOldCefCustomStringList **********
// *****************************************


constructor TOldCefCustomStringList.Create;
begin
  inherited Create;

  FHandle := nil;
end;

procedure TOldCefCustomStringList.Append(const value: oldustring);
var
  TempValue : TOldCefString;
begin
  if (FHandle <> nil) then
    begin
      TempValue := CefString(value);
      cef_string_list_append(FHandle, @TempValue);
    end;
end;

procedure TOldCefCustomStringList.Clear;
begin
  if (FHandle <> nil) then cef_string_list_clear(FHandle);
end;

function TOldCefCustomStringList.GetHandle: TOldCefStringMap;
begin
  Result := FHandle;
end;

function TOldCefCustomStringList.GetSize: integer;
begin
  if (FHandle <> nil) then
    Result := cef_string_list_size(FHandle)
   else
    Result := 0;
end;

function TOldCefCustomStringList.Copy : TOldCefStringList;
begin
  if (FHandle <> nil) then
    Result := cef_string_list_copy(FHandle)
   else
    Result := nil;
end;

function TOldCefCustomStringList.GetValue(index: integer): oldustring;
var
  TempValue : TOldCefString;
begin
  Result := '';

  if (FHandle <> nil) then
    begin
      FillChar(TempValue, SizeOf(TempValue), 0);

      if (cef_string_list_value(FHandle, index, @TempValue) <> 0) then
        Result := CefString(@TempValue);
    end;
end;

procedure TOldCefCustomStringList.CopyToStrings(const aStrings : TStrings);
var
  i, j : integer;
  TempString : TOldCefString;
begin
  if (aStrings <> nil) and (FHandle <> nil) then
    begin
      i := 0;
      j := GetSize;

      while (i < j) do
        begin
          FillChar(TempString, SizeOf(TOldCefString), 0);

          if (cef_string_list_value(FHandle, i, @TempString) <> 0) then
            aStrings.Add(CefStringClearAndGet(TempString));

          inc(i);
        end;
    end;
end;

procedure TOldCefCustomStringList.AddStrings(const aStrings : TStrings);
var
  i : integer;
begin
  if (FHandle <> nil) and (aStrings <> nil) and (aStrings.Count > 0) then
    for i := 0 to aStrings.Count - 1 do Append(aStrings[i]);
end;



// *****************************************
// *********** TOldCefStringListOwn ***********
// *****************************************


constructor TOldCefStringListOwn.Create;
begin
  inherited Create;

  FHandle := cef_string_list_alloc;
end;

destructor TOldCefStringListOwn.Destroy;
begin
  if (FHandle <> nil) then cef_string_list_free(FHandle);

  inherited Destroy;
end;


// *****************************************
// *********** TOldCefStringListRef ***********
// *****************************************


constructor TOldCefStringListRef.Create(aHandle : TOldCefStringList);
begin
  inherited Create;

  FHandle := aHandle;
end;

end.
