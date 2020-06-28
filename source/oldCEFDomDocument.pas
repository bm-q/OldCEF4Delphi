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

unit oldCEFDomDocument;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefDomDocumentRef = class(TOldCefBaseRef, IOldCefDomDocument)
    protected
      function GetType: TOldCefDomDocumentType;
      function GetDocument: IOldCefDomNode;
      function GetBody: IOldCefDomNode;
      function GetHead: IOldCefDomNode;
      function GetTitle: oldustring;
      function GetElementById(const id: oldustring): IOldCefDomNode;
      function GetFocusedNode: IOldCefDomNode;
      function HasSelection: Boolean;
      function GetSelectionStartOffset: Integer;
      function GetSelectionEndOffset: Integer;
      function GetSelectionAsMarkup: oldustring;
      function GetSelectionAsText: oldustring;
      function GetBaseUrl: oldustring;
      function GetCompleteUrl(const partialURL: oldustring): oldustring;

    public
      class function UnWrap(data: Pointer): IOldCefDomDocument;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFDomNode;

function TOldCefDomDocumentRef.GetBaseUrl: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefDomDocument(FData)^.get_base_url(POldCefDomDocument(FData)))
end;

function TOldCefDomDocumentRef.GetBody: IOldCefDomNode;
begin
  Result :=  TOldCefDomNodeRef.UnWrap(POldCefDomDocument(FData)^.get_body(POldCefDomDocument(FData)));
end;

function TOldCefDomDocumentRef.GetCompleteUrl(const partialURL: oldustring): oldustring;
var
  p: TOldCefString;
begin
  p := CefString(partialURL);
  Result := CefStringFreeAndGet(POldCefDomDocument(FData)^.get_complete_url(POldCefDomDocument(FData), @p));
end;

function TOldCefDomDocumentRef.GetDocument: IOldCefDomNode;
begin
  Result := TOldCefDomNodeRef.UnWrap(POldCefDomDocument(FData)^.get_document(POldCefDomDocument(FData)));
end;

function TOldCefDomDocumentRef.GetElementById(const id: oldustring): IOldCefDomNode;
var
  i: TOldCefString;
begin
  i := CefString(id);
  Result := TOldCefDomNodeRef.UnWrap(POldCefDomDocument(FData)^.get_element_by_id(POldCefDomDocument(FData), @i));
end;

function TOldCefDomDocumentRef.GetFocusedNode: IOldCefDomNode;
begin
  Result := TOldCefDomNodeRef.UnWrap(POldCefDomDocument(FData)^.get_focused_node(POldCefDomDocument(FData)));
end;

function TOldCefDomDocumentRef.GetHead: IOldCefDomNode;
begin
  Result := TOldCefDomNodeRef.UnWrap(POldCefDomDocument(FData)^.get_head(POldCefDomDocument(FData)));
end;

function TOldCefDomDocumentRef.GetSelectionAsMarkup: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefDomDocument(FData)^.get_selection_as_markup(POldCefDomDocument(FData)));
end;

function TOldCefDomDocumentRef.GetSelectionAsText: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefDomDocument(FData)^.get_selection_as_text(POldCefDomDocument(FData)));
end;

function TOldCefDomDocumentRef.GetSelectionEndOffset: Integer;
begin
  Result := POldCefDomDocument(FData)^.get_selection_end_offset(POldCefDomDocument(FData));
end;

function TOldCefDomDocumentRef.GetSelectionStartOffset: Integer;
begin
  Result := POldCefDomDocument(FData)^.get_selection_start_offset(POldCefDomDocument(FData));
end;

function TOldCefDomDocumentRef.GetTitle: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefDomDocument(FData)^.get_title(POldCefDomDocument(FData)));
end;

function TOldCefDomDocumentRef.GetType: TOldCefDomDocumentType;
begin
  Result := POldCefDomDocument(FData)^.get_type(POldCefDomDocument(FData));
end;

function TOldCefDomDocumentRef.HasSelection: Boolean;
begin
  Result := POldCefDomDocument(FData)^.has_selection(POldCefDomDocument(FData)) <> 0;
end;

class function TOldCefDomDocumentRef.UnWrap(data: Pointer): IOldCefDomDocument;
begin
  if data <> nil then
    Result := Create(data) as IOldCefDomDocument else
    Result := nil;
end;

end.
