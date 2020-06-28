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

unit oldCEFDragHandler;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefDragHandlerOwn = class(TOldCefBaseOwn, IOldCefDragHandler)
    protected
      function  OnDragEnter(const browser: IOldCefBrowser; const dragData: IOldCefDragData; mask: TOldCefDragOperations): Boolean; virtual;
      procedure OnDraggableRegionsChanged(const browser: IOldCefBrowser; regionsCount: NativeUInt; regions: POldCefDraggableRegionArray); virtual;

      procedure RemoveReferences; virtual;

    public
      constructor Create; virtual;
  end;

  TOldCustomDragHandler = class(TOldCefDragHandlerOwn)
    protected
      FEvents : Pointer;

      function  OnDragEnter(const browser: IOldCefBrowser;  const dragData: IOldCefDragData; mask: TOldCefDragOperations): Boolean; override;
      procedure OnDraggableRegionsChanged(const browser: IOldCefBrowser; regionsCount: NativeUInt; regions: POldCefDraggableRegionArray); override;

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
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFBrowser, oldCEFDragData;

function cef_drag_handler_on_drag_enter(self     : POldCefDragHandler;
                                        browser  : POldCefBrowser;
                                        dragData : POldCefDragData;
                                        mask     : TOldCefDragOperations): Integer; stdcall;
var
  TempObject : TObject;
begin
  Result     := Ord(False);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefDragHandlerOwn) then
    Result := Ord(TOldCefDragHandlerOwn(TempObject).OnDragEnter(TOldCefBrowserRef.UnWrap(browser),
                                                             TOldCefDragDataRef.UnWrap(dragData),
                                                             mask));
end;

procedure cef_drag_handler_on_draggable_regions_changed(self         : POldCefDragHandler;
                                                        browser      : POldCefBrowser;
                                                        regionsCount : NativeUInt;
                                                        regions      : POldCefDraggableRegionArray); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefDragHandlerOwn) then
    TOldCefDragHandlerOwn(TempObject).OnDraggableRegionsChanged(TOldCefBrowserRef.UnWrap(browser),
                                                             regionsCount,
                                                             regions);
end;

constructor TOldCefDragHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefDragHandler));

  with POldCefDragHandler(FData)^ do
    begin
      on_drag_enter                := cef_drag_handler_on_drag_enter;
      on_draggable_regions_changed := cef_drag_handler_on_draggable_regions_changed;
    end;
end;

function TOldCefDragHandlerOwn.OnDragEnter(const browser  : IOldCefBrowser;
                                        const dragData : IOldCefDragData;
                                              mask     : TOldCefDragOperations): Boolean;
begin
  Result := False;
end;

procedure TOldCefDragHandlerOwn.OnDraggableRegionsChanged(const browser      : IOldCefBrowser;
                                                             regionsCount : NativeUInt;
                                                             regions      : POldCefDraggableRegionArray);
begin
  //
end;

procedure TOldCefDragHandlerOwn.RemoveReferences;
begin
  //
end;

// TCustomDragHandler

constructor TOldCustomDragHandler.Create(const events: Pointer);
begin
  inherited Create;

  FEvents := events;
end;

destructor TOldCustomDragHandler.Destroy;
begin
  RemoveReferences;

  inherited Destroy;
end;

procedure TOldCustomDragHandler.RemoveReferences;
begin
  FEvents := nil;
end;

function TOldCustomDragHandler.OnDragEnter(const browser  : IOldCefBrowser;
                                        const dragData : IOldCefDragData;
                                              mask     : TOldCefDragOperations): Boolean;
begin
  if (FEvents <> nil) then
    Result := IOldChromiumEvents(FEvents).doOnDragEnter(browser, dragData, mask)
   else
    Result := inherited OnDragEnter(browser, dragData, mask);
end;

procedure TOldCustomDragHandler.OnDraggableRegionsChanged(const browser      : IOldCefBrowser;
                                                             regionsCount : NativeUInt;
                                                             regions      : POldCefDraggableRegionArray);
begin
  if (FEvents <> nil) then IOldChromiumEvents(FEvents).doOnDraggableRegionsChanged(browser, regionsCount, regions);
end;

end.
