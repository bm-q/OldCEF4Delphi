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

unit oldCEFXmlReader;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefXmlReaderRef = class(TOldCefBaseRef, IOldCefXmlReader)
  protected
    function MoveToNextNode: Boolean;
    function Close: Boolean;
    function HasError: Boolean;
    function GetError: oldustring;
    function GetType: TOldCefXmlNodeType;
    function GetDepth: Integer;
    function GetLocalName: oldustring;
    function GetPrefix: oldustring;
    function GetQualifiedName: oldustring;
    function GetNamespaceUri: oldustring;
    function GetBaseUri: oldustring;
    function GetXmlLang: oldustring;
    function IsEmptyElement: Boolean;
    function HasValue: Boolean;
    function GetValue: oldustring;
    function HasAttributes: Boolean;
    function GetAttributeCount: NativeUInt;
    function GetAttributeByIndex(index: Integer): oldustring;
    function GetAttributeByQName(const qualifiedName: oldustring): oldustring;
    function GetAttributeByLName(const localName, namespaceURI: oldustring): oldustring;
    function GetInnerXml: oldustring;
    function GetOuterXml: oldustring;
    function GetLineNumber: Integer;
    function MoveToAttributeByIndex(index: Integer): Boolean;
    function MoveToAttributeByQName(const qualifiedName: oldustring): Boolean;
    function MoveToAttributeByLName(const localName, namespaceURI: oldustring): Boolean;
    function MoveToFirstAttribute: Boolean;
    function MoveToNextAttribute: Boolean;
    function MoveToCarryingElement: Boolean;
  public
    class function UnWrap(data: Pointer): IOldCefXmlReader;
    class function New(const stream: IOldCefStreamReader;
      encodingType: TOldCefXmlEncodingType; const URI: oldustring): IOldCefXmlReader;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions;

function TOldCefXmlReaderRef.Close: Boolean;
begin
  Result := POldCefXmlReader(FData).close(FData) <> 0;
end;

class function TOldCefXmlReaderRef.New(const stream: IOldCefStreamReader;
  encodingType: TOldCefXmlEncodingType; const URI: oldustring): IOldCefXmlReader;
var
  u: TOldCefString;
begin
  u := CefString(URI);
  Result := UnWrap(cef_xml_reader_create(CefGetData(stream), encodingType, @u));
end;

function TOldCefXmlReaderRef.GetAttributeByIndex(index: Integer): oldustring;
begin
  Result := CefStringFreeAndGet(POldCefXmlReader(FData).get_attribute_byindex(FData, index));
end;

function TOldCefXmlReaderRef.GetAttributeByLName(const localName,
  namespaceURI: oldustring): oldustring;
var
  l, n: TOldCefString;
begin
  l := CefString(localName);
  n := CefString(namespaceURI);
  Result := CefStringFreeAndGet(POldCefXmlReader(FData).get_attribute_bylname(FData, @l, @n));
end;

function TOldCefXmlReaderRef.GetAttributeByQName(
  const qualifiedName: oldustring): oldustring;
var
  q: TOldCefString;
begin
  q := CefString(qualifiedName);
  Result := CefStringFreeAndGet(POldCefXmlReader(FData).get_attribute_byqname(FData, @q));
end;

function TOldCefXmlReaderRef.GetAttributeCount: NativeUInt;
begin
  Result := POldCefXmlReader(FData).get_attribute_count(FData);
end;

function TOldCefXmlReaderRef.GetBaseUri: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefXmlReader(FData).get_base_uri(FData));
end;

function TOldCefXmlReaderRef.GetDepth: Integer;
begin
  Result := POldCefXmlReader(FData).get_depth(FData);
end;

function TOldCefXmlReaderRef.GetError: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefXmlReader(FData).get_error(FData));
end;

function TOldCefXmlReaderRef.GetInnerXml: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefXmlReader(FData).get_inner_xml(FData));
end;

function TOldCefXmlReaderRef.GetLineNumber: Integer;
begin
  Result := POldCefXmlReader(FData).get_line_number(FData);
end;

function TOldCefXmlReaderRef.GetLocalName: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefXmlReader(FData).get_local_name(FData));
end;

function TOldCefXmlReaderRef.GetNamespaceUri: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefXmlReader(FData).get_namespace_uri(FData));
end;

function TOldCefXmlReaderRef.GetOuterXml: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefXmlReader(FData).get_outer_xml(FData));
end;

function TOldCefXmlReaderRef.GetPrefix: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefXmlReader(FData).get_prefix(FData));
end;

function TOldCefXmlReaderRef.GetQualifiedName: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefXmlReader(FData).get_qualified_name(FData));
end;

function TOldCefXmlReaderRef.GetType: TOldCefXmlNodeType;
begin
  Result := POldCefXmlReader(FData).get_type(FData);
end;

function TOldCefXmlReaderRef.GetValue: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefXmlReader(FData).get_value(FData));
end;

function TOldCefXmlReaderRef.GetXmlLang: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefXmlReader(FData).get_xml_lang(FData));
end;

function TOldCefXmlReaderRef.HasAttributes: Boolean;
begin
  Result := POldCefXmlReader(FData).has_attributes(FData) <> 0;
end;

function TOldCefXmlReaderRef.HasError: Boolean;
begin
  Result := POldCefXmlReader(FData).has_error(FData) <> 0;
end;

function TOldCefXmlReaderRef.HasValue: Boolean;
begin
  Result := POldCefXmlReader(FData).has_value(FData) <> 0;
end;

function TOldCefXmlReaderRef.IsEmptyElement: Boolean;
begin
  Result := POldCefXmlReader(FData).is_empty_element(FData) <> 0;
end;

function TOldCefXmlReaderRef.MoveToAttributeByIndex(index: Integer): Boolean;
begin
  Result := POldCefXmlReader(FData).move_to_attribute_byindex(FData, index) <> 0;
end;

function TOldCefXmlReaderRef.MoveToAttributeByLName(const localName,
  namespaceURI: oldustring): Boolean;
var
  l, n: TOldCefString;
begin
  l := CefString(localName);
  n := CefString(namespaceURI);
  Result := POldCefXmlReader(FData).move_to_attribute_bylname(FData, @l, @n) <> 0;
end;

function TOldCefXmlReaderRef.MoveToAttributeByQName(
  const qualifiedName: oldustring): Boolean;
var
  q: TOldCefString;
begin
  q := CefString(qualifiedName);
  Result := POldCefXmlReader(FData).move_to_attribute_byqname(FData, @q) <> 0;
end;

function TOldCefXmlReaderRef.MoveToCarryingElement: Boolean;
begin
  Result := POldCefXmlReader(FData).move_to_carrying_element(FData) <> 0;
end;

function TOldCefXmlReaderRef.MoveToFirstAttribute: Boolean;
begin
  Result := POldCefXmlReader(FData).move_to_first_attribute(FData) <> 0;
end;

function TOldCefXmlReaderRef.MoveToNextAttribute: Boolean;
begin
  Result := POldCefXmlReader(FData).move_to_next_attribute(FData) <> 0;
end;

function TOldCefXmlReaderRef.MoveToNextNode: Boolean;
begin
  Result := POldCefXmlReader(FData).move_to_next_node(FData) <> 0;
end;

class function TOldCefXmlReaderRef.UnWrap(data: Pointer): IOldCefXmlReader;
begin
  if data <> nil then
    Result := Create(data) as IOldCefXmlReader else
    Result := nil;
end;

end.
