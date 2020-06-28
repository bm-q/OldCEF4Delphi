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

unit oldCEFWebPluginInfoVisitor;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefWebPluginInfoVisitorOwn = class(TOldCefBaseOwn, IOldCefWebPluginInfoVisitor)
    protected
      function Visit(const info: IOldCefWebPluginInfo; count, total: Integer): Boolean; virtual;

    public
      constructor Create; virtual;
  end;

  TOldCefWebPluginInfoVisitorProc = {$IFDEF DELPHI12_UP}reference to{$ENDIF} function(const info: IOldCefWebPluginInfo; count, total: Integer): Boolean;

  TOldCefFastWebPluginInfoVisitor = class(TOldCefWebPluginInfoVisitorOwn)
    protected
      FProc: TOldCefWebPluginInfoVisitorProc;

      function Visit(const info: IOldCefWebPluginInfo; count, total: Integer): Boolean; override;

    public
      constructor Create(const proc: TOldCefWebPluginInfoVisitorProc); reintroduce;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFWebPluginInfo;

function cef_web_plugin_info_visitor_visit(self: POldCefWebPluginInfoVisitor;
                                           info: POldCefWebPluginInfo;
                                           count, total: Integer): Integer; stdcall;
var
  TempObject : TObject;
begin
  Result     := Ord(False);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefWebPluginInfoVisitorOwn) then
    Result := Ord(TOldCefWebPluginInfoVisitorOwn(TempObject).Visit(TOldCefWebPluginInfoRef.UnWrap(info),
                                                                count,
                                                                total));
end;

constructor TOldCefWebPluginInfoVisitorOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefWebPluginInfoVisitor));

  POldCefWebPluginInfoVisitor(FData).visit := cef_web_plugin_info_visitor_visit;
end;

function TOldCefWebPluginInfoVisitorOwn.Visit(const info: IOldCefWebPluginInfo; count, total: Integer): Boolean;
begin
  Result := False;
end;

// TOldCefFastWebPluginInfoVisitor

constructor TOldCefFastWebPluginInfoVisitor.Create(
  const proc: TOldCefWebPluginInfoVisitorProc);
begin
  inherited Create;
  FProc := proc;
end;

function TOldCefFastWebPluginInfoVisitor.Visit(const info: IOldCefWebPluginInfo;
  count, total: Integer): Boolean;
begin
  Result := FProc(info, count, total);
end;

end.
