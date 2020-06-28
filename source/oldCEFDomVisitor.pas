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

unit oldCEFDomVisitor;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces;

type
  TOldCefDomVisitorOwn = class(TOldCefBaseOwn, IOldCefDomVisitor)
    protected
      procedure visit(const document: IOldCefDomDocument); virtual;

    public
      constructor Create; virtual;
  end;

  TOldCefFastDomVisitor = class(TOldCefDomVisitorOwn)
    protected
      FProc    : TOldCefDomVisitorProc;

      procedure visit(const document: IOldCefDomDocument); override;

    public
      constructor Create(const proc: TOldCefDomVisitorProc); reintroduce; virtual;
  end;

  TOldCefFastDomVisitor2 = class(TOldCefDomVisitorOwn)
    protected
      FProc    : TOldCefDomVisitorProc2;
      FBrowser : IOldCefBrowser;

      procedure visit(const document: IOldCefDomDocument); override;

    public
      constructor Create(const browser: IOldCefBrowser; const proc: TOldCefDomVisitorProc2); reintroduce; virtual;
      destructor  Destroy; override;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFTypes, oldCEFDomDocument;

procedure cef_dom_visitor_visite(self: POldCefDomVisitor; document: POldCefDomDocument); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefDomVisitorOwn) then
    TOldCefDomVisitorOwn(TempObject).visit(TOldCefDomDocumentRef.UnWrap(document));
end;

// TOldCefDomVisitorOwn

constructor TOldCefDomVisitorOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefDomVisitor));

  POldCefDomVisitor(FData).visit := cef_dom_visitor_visite;
end;

procedure TOldCefDomVisitorOwn.visit(const document: IOldCefDomDocument);
begin

end;

// TOldCefFastDomVisitor

constructor TOldCefFastDomVisitor.Create(const proc: TOldCefDomVisitorProc);
begin
  inherited Create;

  FProc := proc;
end;

procedure TOldCefFastDomVisitor.visit(const document: IOldCefDomDocument);
begin
  FProc(document);
end;


// TOldCefFastDomVisitor2

constructor TOldCefFastDomVisitor2.Create(const browser: IOldCefBrowser; const proc: TOldCefDomVisitorProc2);
begin
  inherited Create;

  FBrowser := browser;
  FProc    := proc;
end;

destructor TOldCefFastDomVisitor2.Destroy;
begin
  FBrowser := nil;

  inherited Destroy;
end;

procedure TOldCefFastDomVisitor2.visit(const document: IOldCefDomDocument);
begin
  FProc(FBrowser, document);
end;

end.
