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

unit oldCEFFindHandler;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFTypes, oldCEFInterfaces;

type
  TOldCefFindHandlerOwn = class(TOldCefBaseOwn, IOldCefFindHandler)
    protected
      procedure OnFindResult(const browser: IOldCefBrowser; identifier, count: Integer; const selectionRect: POldCefRect; activeMatchOrdinal: Integer; finalUpdate: Boolean); virtual; abstract;

      procedure RemoveReferences; virtual;

    public
      constructor Create; virtual;
  end;

  TOldCustomFindHandler = class(TOldCefFindHandlerOwn)
    protected
      FEvents : Pointer;

      procedure OnFindResult(const browser: IOldCefBrowser; identifier, count: Integer; const selectionRect: POldCefRect; activeMatchOrdinal: Integer; finalUpdate: Boolean); override;

      procedure RemoveReferences; override;

    public
      constructor Create(const events: Pointer); reintroduce; virtual;
      destructor  Destroy; override;
  end;

implementation

uses
  {$IFDEF DELPHI16_UP}
  System.SysUtils,
  {$ELSE}
  SysUtils,
  {$ENDIF}
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFBrowser;

procedure cef_find_handler_on_find_result(      self                 : POldCefFindHandler;
                                                browser              : POldCefBrowser;
                                                identifier           : Integer;
                                                count                : Integer;
                                          const selection_rect       : POldCefRect;
                                                active_match_ordinal : integer;
                                                final_update         : Integer); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefFindHandlerOwn) then
    TOldCefFindHandlerOwn(TempObject).OnFindResult(TOldCefBrowserRef.UnWrap(browser),
                                                identifier,
                                                count,
                                                selection_rect,
                                                active_match_ordinal,
                                                final_update <> 0);
end;

constructor TOldCefFindHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefFindHandler));

  POldCefFindHandler(FData).on_find_result := cef_find_handler_on_find_result;
end;

procedure TOldCefFindHandlerOwn.RemoveReferences;
begin
  //
end;

// TCustomFindHandler

constructor TOldCustomFindHandler.Create(const events: Pointer);
begin
  inherited Create;

  FEvents := events;
end;

destructor TOldCustomFindHandler.Destroy;
begin
  RemoveReferences;

  inherited Destroy;
end;

procedure TOldCustomFindHandler.RemoveReferences;
begin
  FEvents := nil;
end;

procedure TOldCustomFindHandler.OnFindResult(const browser            : IOldCefBrowser;
                                                identifier         : Integer;
                                                count              : Integer;
                                          const selectionRect      : POldCefRect;
                                                activeMatchOrdinal : Integer;
                                                finalUpdate        : Boolean);
begin
  if (FEvents <> nil) then IOldChromiumEvents(FEvents).doOnFindResult(browser, identifier, count, selectionRect, activeMatchOrdinal, finalUpdate);
end;

end.
