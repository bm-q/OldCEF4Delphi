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

unit oldCEFSchemeHandlerFactory;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes, oldCEFResourceHandler;

type
  TOldCefSchemeHandlerFactoryOwn = class(TOldCefBaseOwn, IOldCefSchemeHandlerFactory)
    protected
      FClass : TOldCefResourceHandlerClass;

      function New(const browser: IOldCefBrowser; const frame: IOldCefFrame; const schemeName: oldustring; const request: IOldCefRequest): IOldCefResourceHandler; virtual;

    public
      constructor Create(const AClass: TOldCefResourceHandlerClass); virtual;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFBrowser, oldCEFFrame, oldCEFRequest;

function cef_scheme_handler_factory_create(      self        : POldCefSchemeHandlerFactory;
                                                 browser     : POldCefBrowser;
                                                 frame       : POldCefFrame;
                                           const scheme_name : POldCefString;
                                                 request     : POldCefRequest): POldCefResourceHandler; stdcall;
var
  TempObject : TObject;
begin
  Result     := nil;
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefSchemeHandlerFactoryOwn) then
    Result := CefGetData(TOldCefSchemeHandlerFactoryOwn(TempObject).New(TOldCefBrowserRef.UnWrap(browser),
                                                                     TOldCefFrameRef.UnWrap(frame),
                                                                     CefString(scheme_name),
                                                                     TOldCefRequestRef.UnWrap(request)));
end;

constructor TOldCefSchemeHandlerFactoryOwn.Create(const AClass: TOldCefResourceHandlerClass);
begin
  inherited CreateData(SizeOf(TOldCefSchemeHandlerFactory));

  FClass := AClass;

  POldCefSchemeHandlerFactory(FData).create := cef_scheme_handler_factory_create;
end;

function TOldCefSchemeHandlerFactoryOwn.New(const browser    : IOldCefBrowser;
                                         const frame      : IOldCefFrame;
                                         const schemeName : oldustring;
                                         const request    : IOldCefRequest): IOldCefResourceHandler;
begin
  if (FClass <> nil) then
    Result := FClass.Create(browser, frame, schemeName, request)
   else
    Result := nil;
end;


end.
