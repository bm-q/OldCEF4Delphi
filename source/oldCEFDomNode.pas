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

unit oldCEFDomNode;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefDomNodeRef = class(TOldCefBaseRef, IOldCefDomNode)
    protected
      function GetType: TOldCefDomNodeType;
      function IsText: Boolean;
      function IsElement: Boolean;
      function IsEditable: Boolean;
      function IsFormControlElement: Boolean;
      function GetFormControlElementType: oldustring;
      function IsSame(const that: IOldCefDomNode): Boolean;
      function GetName: oldustring;
      function GetValue: oldustring;
      function SetValue(const value: oldustring): Boolean;
      function GetAsMarkup: oldustring;
      function GetDocument: IOldCefDomDocument;
      function GetParent: IOldCefDomNode;
      function GetPreviousSibling: IOldCefDomNode;
      function GetNextSibling: IOldCefDomNode;
      function HasChildren: Boolean;
      function GetFirstChild: IOldCefDomNode;
      function GetLastChild: IOldCefDomNode;
      function GetElementTagName: oldustring;
      function HasElementAttributes: Boolean;
      function HasElementAttribute(const attrName: oldustring): Boolean;
      function GetElementAttribute(const attrName: oldustring): oldustring;
      procedure GetElementAttributes(const attrMap: IOldCefStringMap);
      function SetElementAttribute(const attrName, value: oldustring): Boolean;
      function GetElementInnerText: oldustring;

    public
      class function UnWrap(data: Pointer): IOldCefDomNode;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFDomDocument;

function TOldCefDomNodeRef.GetAsMarkup: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefDomNode(FData)^.get_as_markup(POldCefDomNode(FData)));
end;

function TOldCefDomNodeRef.GetDocument: IOldCefDomDocument;
begin
  Result := TOldCefDomDocumentRef.UnWrap(POldCefDomNode(FData)^.get_document(POldCefDomNode(FData)));
end;

function TOldCefDomNodeRef.GetElementAttribute(const attrName: oldustring): oldustring;
var
  p: TOldCefString;
begin
  p := CefString(attrName);
  Result := CefStringFreeAndGet(POldCefDomNode(FData)^.get_element_attribute(POldCefDomNode(FData), @p));
end;

procedure TOldCefDomNodeRef.GetElementAttributes(const attrMap: IOldCefStringMap);
begin
  POldCefDomNode(FData)^.get_element_attributes(POldCefDomNode(FData), attrMap.Handle);
end;

function TOldCefDomNodeRef.GetElementInnerText: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefDomNode(FData)^.get_element_inner_text(POldCefDomNode(FData)));
end;

function TOldCefDomNodeRef.GetElementTagName: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefDomNode(FData)^.get_element_tag_name(POldCefDomNode(FData)));
end;

function TOldCefDomNodeRef.GetFirstChild: IOldCefDomNode;
begin
  Result := TOldCefDomNodeRef.UnWrap(POldCefDomNode(FData)^.get_first_child(POldCefDomNode(FData)));
end;

function TOldCefDomNodeRef.GetFormControlElementType: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefDomNode(FData)^.get_form_control_element_type(POldCefDomNode(FData)));
end;

function TOldCefDomNodeRef.GetLastChild: IOldCefDomNode;
begin
  Result := TOldCefDomNodeRef.UnWrap(POldCefDomNode(FData)^.get_last_child(POldCefDomNode(FData)));
end;

function TOldCefDomNodeRef.GetName: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefDomNode(FData)^.get_name(POldCefDomNode(FData)));
end;

function TOldCefDomNodeRef.GetNextSibling: IOldCefDomNode;
begin
  Result := TOldCefDomNodeRef.UnWrap(POldCefDomNode(FData)^.get_next_sibling(POldCefDomNode(FData)));
end;

function TOldCefDomNodeRef.GetParent: IOldCefDomNode;
begin
  Result := TOldCefDomNodeRef.UnWrap(POldCefDomNode(FData)^.get_parent(POldCefDomNode(FData)));
end;

function TOldCefDomNodeRef.GetPreviousSibling: IOldCefDomNode;
begin
  Result := TOldCefDomNodeRef.UnWrap(POldCefDomNode(FData)^.get_previous_sibling(POldCefDomNode(FData)));
end;

function TOldCefDomNodeRef.GetType: TOldCefDomNodeType;
begin
  Result := POldCefDomNode(FData)^.get_type(POldCefDomNode(FData));
end;

function TOldCefDomNodeRef.GetValue: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefDomNode(FData)^.get_value(POldCefDomNode(FData)));
end;

function TOldCefDomNodeRef.HasChildren: Boolean;
begin
  Result := POldCefDomNode(FData)^.has_children(POldCefDomNode(FData)) <> 0;
end;

function TOldCefDomNodeRef.HasElementAttribute(const attrName: oldustring): Boolean;
var
  p: TOldCefString;
begin
  p := CefString(attrName);
  Result := POldCefDomNode(FData)^.has_element_attribute(POldCefDomNode(FData), @p) <> 0;
end;

function TOldCefDomNodeRef.HasElementAttributes: Boolean;
begin
  Result := POldCefDomNode(FData)^.has_element_attributes(POldCefDomNode(FData)) <> 0;
end;

function TOldCefDomNodeRef.IsEditable: Boolean;
begin
  Result := POldCefDomNode(FData)^.is_editable(POldCefDomNode(FData)) <> 0;
end;

function TOldCefDomNodeRef.IsElement: Boolean;
begin
  Result := POldCefDomNode(FData)^.is_element(POldCefDomNode(FData)) <> 0;
end;

function TOldCefDomNodeRef.IsFormControlElement: Boolean;
begin
  Result := POldCefDomNode(FData)^.is_form_control_element(POldCefDomNode(FData)) <> 0;
end;

function TOldCefDomNodeRef.IsSame(const that: IOldCefDomNode): Boolean;
begin
  Result := POldCefDomNode(FData)^.is_same(POldCefDomNode(FData), CefGetData(that)) <> 0;
end;

function TOldCefDomNodeRef.IsText: Boolean;
begin
  Result := POldCefDomNode(FData)^.is_text(POldCefDomNode(FData)) <> 0;
end;

function TOldCefDomNodeRef.SetElementAttribute(const attrName,
  value: oldustring): Boolean;
var
  p1, p2: TOldCefString;
begin
  p1 := CefString(attrName);
  p2 := CefString(value);
  Result := POldCefDomNode(FData)^.set_element_attribute(POldCefDomNode(FData), @p1, @p2) <> 0;
end;

function TOldCefDomNodeRef.SetValue(const value: oldustring): Boolean;
var
  p: TOldCefString;
begin
  p := CefString(value);
  Result := POldCefDomNode(FData)^.set_value(POldCefDomNode(FData), @p) <> 0;
end;

class function TOldCefDomNodeRef.UnWrap(data: Pointer): IOldCefDomNode;
begin
  if data <> nil then
    Result := Create(data) as IOldCefDomNode else
    Result := nil;
end;


end.
