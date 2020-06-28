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

unit oldCEFPostData;

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
  TOldCefPostDataRef = class(TOldCefBaseRef, IOldCefPostData)
    protected
      function  IsReadOnly: Boolean;
      function  HasExcludedElements: Boolean;
      function  GetCount: NativeUInt;
      function  GetElements(Count: NativeUInt): IInterfaceList; // ICefPostDataElement
      function  RemoveElement(const element: IOldCefPostDataElement): Integer;
      function  AddElement(const element: IOldCefPostDataElement): Integer;
      procedure RemoveElements;

    public
      class function UnWrap(data: Pointer): IOldCefPostData;
      class function New: IOldCefPostData;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFPostDataElement;


function TOldCefPostDataRef.IsReadOnly: Boolean;
begin
  Result := POldCefPostData(FData)^.is_read_only(POldCefPostData(FData)) <> 0;
end;

function TOldCefPostDataRef.HasExcludedElements: Boolean;
begin
  Result := POldCefPostData(FData)^.has_excluded_elements(POldCefPostData(FData)) <> 0;
end;

function TOldCefPostDataRef.AddElement(const element: IOldCefPostDataElement): Integer;
begin
  Result := POldCefPostData(FData)^.add_element(POldCefPostData(FData), CefGetData(element));
end;

function TOldCefPostDataRef.GetCount: NativeUInt;
begin
  Result := POldCefPostData(FData)^.get_element_count(POldCefPostData(FData))
end;

function TOldCefPostDataRef.GetElements(Count: NativeUInt): IInterfaceList;
var
  items : POldCefPostDataElementArray;
  i     : NativeUInt;
begin
  Result := nil;
  items  := nil;

  try
    try
      GetMem(items, SizeOf(POldCefPostDataElement) * Count);
      FillChar(items^, SizeOf(POldCefPostDataElement) * Count, 0);

      POldCefPostData(FData)^.get_elements(POldCefPostData(FData), @Count, items);

      Result := TInterfaceList.Create;
      i      := 0;

      while (i < Count) do
        begin
          Result.Add(TOldCefPostDataElementRef.UnWrap(items[i]));
          inc(i);
        end;
    except
      on e : exception do
        if CustomExceptionHandler('TOldCefPostDataRef.GetElements', e) then raise;
    end;
  finally
    if (items <> nil) then FreeMem(items);
  end;
end;

class function TOldCefPostDataRef.New: IOldCefPostData;
begin
  Result := UnWrap(cef_post_data_create);
end;

function TOldCefPostDataRef.RemoveElement(
  const element: IOldCefPostDataElement): Integer;
begin
  Result := POldCefPostData(FData)^.remove_element(POldCefPostData(FData), CefGetData(element));
end;

procedure TOldCefPostDataRef.RemoveElements;
begin
  POldCefPostData(FData)^.remove_elements(POldCefPostData(FData));
end;

class function TOldCefPostDataRef.UnWrap(data: Pointer): IOldCefPostData;
begin
  if data <> nil then
    Result := Create(data) as IOldCefPostData else
    Result := nil;
end;

end.
