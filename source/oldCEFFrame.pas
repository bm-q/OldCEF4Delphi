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

unit oldCEFFrame;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefFrameRef = class(TOldCefBaseRef, IOldCefFrame)
    public
      function IsValid: Boolean;
      procedure Undo;
      procedure Redo;
      procedure Cut;
      procedure Copy;
      procedure Paste;
      procedure Del;
      procedure SelectAll;
      procedure ViewSource;
      procedure GetSource(const visitor: IOldCefStringVisitor);
      procedure GetSourceProc(const proc: TOldCefStringVisitorProc);
      procedure GetText(const visitor: IOldCefStringVisitor);
      procedure GetTextProc(const proc: TOldCefStringVisitorProc);
      procedure LoadRequest(const request: IOldCefRequest);
      procedure LoadUrl(const url: oldustring);
      procedure LoadString(const str, url: oldustring);
      procedure ExecuteJavaScript(const code, scriptUrl: oldustring; startLine: Integer);
      function IsMain: Boolean;
      function IsFocused: Boolean;
      function GetName: oldustring;
      function GetIdentifier: Int64;
      function GetParent: IOldCefFrame;
      function GetUrl: oldustring;
      function GetBrowser: IOldCefBrowser;
      function GetV8Context: IOldCefv8Context;
      procedure VisitDom(const visitor: IOldCefDomVisitor);
      procedure VisitDomProc(const proc: TOldCefDomVisitorProc);

      class function UnWrap(data: Pointer): IOldCefFrame;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFBrowser, oldCEFStringVisitor, oldCEFv8Context, oldCEFDomVisitor;

function TOldCefFrameRef.IsValid: Boolean;
begin
  Result := POldCefFrame(FData)^.is_valid(POldCefFrame(FData)) <> 0;
end;

procedure TOldCefFrameRef.Copy;
begin
  POldCefFrame(FData)^.copy(POldCefFrame(FData));
end;

procedure TOldCefFrameRef.Cut;
begin
  POldCefFrame(FData)^.cut(POldCefFrame(FData));
end;

procedure TOldCefFrameRef.Del;
begin
  POldCefFrame(FData)^.del(POldCefFrame(FData));
end;

procedure TOldCefFrameRef.ExecuteJavaScript(const code, scriptUrl: oldustring;
  startLine: Integer);
var
  j, s: TOldCefString;
begin
  j := CefString(code);
  s := CefString(scriptUrl);
  POldCefFrame(FData)^.execute_java_script(POldCefFrame(FData), @j, @s, startline);
end;

function TOldCefFrameRef.GetBrowser: IOldCefBrowser;
begin
  Result := TOldCefBrowserRef.UnWrap(POldCefFrame(FData)^.get_browser(POldCefFrame(FData)));
end;

function TOldCefFrameRef.GetIdentifier: Int64;
begin
  Result := POldCefFrame(FData)^.get_identifier(POldCefFrame(FData));
end;

function TOldCefFrameRef.GetName: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefFrame(FData)^.get_name(POldCefFrame(FData)));
end;

function TOldCefFrameRef.GetParent: IOldCefFrame;
begin
  Result := TOldCefFrameRef.UnWrap(POldCefFrame(FData)^.get_parent(POldCefFrame(FData)));
end;

procedure TOldCefFrameRef.GetSource(const visitor: IOldCefStringVisitor);
begin
  POldCefFrame(FData)^.get_source(POldCefFrame(FData), CefGetData(visitor));
end;

procedure TOldCefFrameRef.GetSourceProc(const proc: TOldCefStringVisitorProc);
begin
  GetSource(TOldCefFastStringVisitor.Create(proc));
end;

procedure TOldCefFrameRef.getText(const visitor: IOldCefStringVisitor);
begin
  POldCefFrame(FData)^.get_text(POldCefFrame(FData), CefGetData(visitor));
end;

procedure TOldCefFrameRef.GetTextProc(const proc: TOldCefStringVisitorProc);
begin
  GetText(TOldCefFastStringVisitor.Create(proc));
end;

function TOldCefFrameRef.GetUrl: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefFrame(FData)^.get_url(POldCefFrame(FData)));
end;

function TOldCefFrameRef.GetV8Context: IOldCefv8Context;
begin
  Result := TOldCefv8ContextRef.UnWrap(POldCefFrame(FData)^.get_v8context(POldCefFrame(FData)));
end;

function TOldCefFrameRef.IsFocused: Boolean;
begin
  Result := POldCefFrame(FData)^.is_focused(POldCefFrame(FData)) <> 0;
end;

function TOldCefFrameRef.IsMain: Boolean;
begin
  Result := POldCefFrame(FData)^.is_main(POldCefFrame(FData)) <> 0;
end;

procedure TOldCefFrameRef.LoadRequest(const request: IOldCefRequest);
begin
  POldCefFrame(FData)^.load_request(POldCefFrame(FData), CefGetData(request));
end;

procedure TOldCefFrameRef.LoadString(const str, url: oldustring);
var
  s, u: TOldCefString;
begin
  s := CefString(str);
  u := CefString(url);
  POldCefFrame(FData)^.load_string(POldCefFrame(FData), @s, @u);
end;

procedure TOldCefFrameRef.LoadUrl(const url: oldustring);
var
  u: TOldCefString;
begin
  u := CefString(url);
  POldCefFrame(FData)^.load_url(POldCefFrame(FData), @u);

end;

procedure TOldCefFrameRef.Paste;
begin
  POldCefFrame(FData)^.paste(POldCefFrame(FData));
end;

procedure TOldCefFrameRef.Redo;
begin
  POldCefFrame(FData)^.redo(POldCefFrame(FData));
end;

procedure TOldCefFrameRef.SelectAll;
begin
  POldCefFrame(FData)^.select_all(POldCefFrame(FData));
end;

procedure TOldCefFrameRef.Undo;
begin
  POldCefFrame(FData)^.undo(POldCefFrame(FData));
end;

procedure TOldCefFrameRef.ViewSource;
begin
  POldCefFrame(FData)^.view_source(POldCefFrame(FData));
end;

procedure TOldCefFrameRef.VisitDom(const visitor: IOldCefDomVisitor);
begin
  POldCefFrame(FData)^.visit_dom(POldCefFrame(FData), CefGetData(visitor));
end;

procedure TOldCefFrameRef.VisitDomProc(const proc: TOldCefDomVisitorProc);
begin
  VisitDom(TOldCefFastDomVisitor.Create(proc) as IOldCefDomVisitor);
end;

class function TOldCefFrameRef.UnWrap(data: Pointer): IOldCefFrame;
begin
  if data <> nil then
    Result := Create(data) as IOldCefFrame else
    Result := nil;
end;

end.
