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

unit oldCEFRenderHandler;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefRenderHandlerOwn = class(TOldCefBaseOwn, IOldCefRenderHandler)
    protected
      function  GetRootScreenRect(const browser: IOldCefBrowser; var rect: TOldCefRect): Boolean; virtual;
      function  GetViewRect(const browser: IOldCefBrowser; var rect: TOldCefRect): Boolean; virtual;
      function  GetScreenPoint(const browser: IOldCefBrowser; viewX, viewY: Integer; var screenX, screenY: Integer): Boolean; virtual;
      function  GetScreenInfo(const browser: IOldCefBrowser; var screenInfo: TOldCefScreenInfo): Boolean; virtual;
      procedure OnPopupShow(const browser: IOldCefBrowser; show: Boolean); virtual;
      procedure OnPopupSize(const browser: IOldCefBrowser; const rect: POldCefRect); virtual;
      procedure OnPaint(const browser: IOldCefBrowser; kind: TOldCefPaintElementType; dirtyRectsCount: NativeUInt; const dirtyRects: POldCefRectArray; const buffer: Pointer; width, height: Integer); virtual;
      procedure OnCursorChange(const browser: IOldCefBrowser; cursor: TOldCefCursorHandle; CursorType: TOldCefCursorType; const customCursorInfo: POldCefCursorInfo); virtual;
      function  OnStartDragging(const browser: IOldCefBrowser; const dragData: IOldCefDragData; allowedOps: TOldCefDragOperations; x, y: Integer): Boolean; virtual;
      procedure OnUpdateDragCursor(const browser: IOldCefBrowser; operation: TOldCefDragOperation); virtual;
      procedure OnScrollOffsetChanged(const browser: IOldCefBrowser; x, y: Double); virtual;

      procedure RemoveReferences; virtual;

    public
      constructor Create; virtual;
  end;

  TOldCustomRenderHandler = class(TOldCefRenderHandlerOwn)
    protected
      FEvents : Pointer;

      function  GetRootScreenRect(const browser: IOldCefBrowser; var rect: TOldCefRect): Boolean; override;
      function  GetViewRect(const browser: IOldCefBrowser; var rect: TOldCefRect): Boolean; override;
      function  GetScreenPoint(const browser: IOldCefBrowser; viewX, viewY: Integer; var screenX, screenY: Integer): Boolean; override;
      procedure OnPopupShow(const browser: IOldCefBrowser; show: Boolean); override;
      procedure OnPopupSize(const browser: IOldCefBrowser; const rect: POldCefRect); override;
      procedure OnPaint(const browser: IOldCefBrowser; kind: TOldCefPaintElementType; dirtyRectsCount: NativeUInt; const dirtyRects: POldCefRectArray; const buffer: Pointer; width, height: Integer); override;
      procedure OnCursorChange(const browser: IOldCefBrowser; cursor: TOldCefCursorHandle; cursorType: TOldCefCursorType; const customCursorInfo: POldCefCursorInfo); override;
      function  GetScreenInfo(const browser: IOldCefBrowser; var screenInfo: TOldCefScreenInfo): Boolean; override;
      function  OnStartDragging(const browser: IOldCefBrowser; const dragData: IOldCefDragData; allowedOps: TOldCefDragOperations; x, y: Integer): Boolean; override;
      procedure OnUpdateDragCursor(const browser: IOldCefBrowser; operation: TOldCefDragOperation); override;
      procedure OnScrollOffsetChanged(const browser: IOldCefBrowser; x, y: Double); override;

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


function cef_render_handler_get_root_screen_rect(self    : POldCefRenderHandler;
                                                 browser : POldCefBrowser;
                                                 rect    : POldCefRect): Integer; stdcall;
var
  TempObject : TObject;
begin
  Result     := Ord(False);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRenderHandlerOwn) then
    Result := Ord(TOldCefRenderHandlerOwn(TempObject).GetRootScreenRect(TOldCefBrowserRef.UnWrap(browser),
                                                                     rect^));
end;

function cef_render_handler_get_view_rect(self    : POldCefRenderHandler;
                                          browser : POldCefBrowser;
                                          rect    : POldCefRect): Integer; stdcall;
var
  TempObject : TObject;
begin
  Result     := Ord(False);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRenderHandlerOwn) then
    Result := Ord(TOldCefRenderHandlerOwn(TempObject).GetViewRect(TOldCefBrowserRef.UnWrap(browser),
                                                               rect^));
end;

function cef_render_handler_get_screen_point(self             : POldCefRenderHandler;
                                             browser          : POldCefBrowser;
                                             viewX, viewY     : Integer;
                                             screenX, screenY : PInteger): Integer; stdcall;
var
  TempObject : TObject;
begin
  Result     := Ord(False);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRenderHandlerOwn) then
    Result := Ord(TOldCefRenderHandlerOwn(TempObject).GetScreenPoint(TOldCefBrowserRef.UnWrap(browser),
                                                                  viewX,
                                                                  viewY,
                                                                  screenX^,
                                                                  screenY^));
end;

function cef_render_handler_get_screen_info(self        : POldCefRenderHandler;
                                            browser     : POldCefBrowser;
                                            screen_info : POldCefScreenInfo): Integer; stdcall;
var
  TempObject : TObject;
begin
  Result     := Ord(False);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRenderHandlerOwn) then
    Result := Ord(TOldCefRenderHandlerOwn(TempObject).GetScreenInfo(TOldCefBrowserRef.UnWrap(browser),
                                                                 screen_info^));
end;

procedure cef_render_handler_on_popup_show(self    : POldCefRenderHandler;
                                           browser : POldCefBrowser;
                                           show    : Integer); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRenderHandlerOwn) then
    TOldCefRenderHandlerOwn(TempObject).OnPopupShow(TOldCefBrowserRef.UnWrap(browser),
                                                 show <> 0);
end;

procedure cef_render_handler_on_popup_size(      self    : POldCefRenderHandler;
                                                 browser : POldCefBrowser;
                                           const rect    : POldCefRect); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRenderHandlerOwn) then
    TOldCefRenderHandlerOwn(TempObject).OnPopupSize(TOldCefBrowserRef.UnWrap(browser),
                                                 rect);
end;

procedure cef_render_handler_on_paint(      self             : POldCefRenderHandler;
                                            browser          : POldCefBrowser;
                                            kind             : TOldCefPaintElementType;
                                            dirtyRectsCount  : NativeUInt;
                                      const dirtyRects       : POldCefRectArray;
                                      const buffer           : Pointer;
                                            width            : Integer;
                                            height           : Integer); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRenderHandlerOwn) then
    TOldCefRenderHandlerOwn(TempObject).OnPaint(TOldCefBrowserRef.UnWrap(browser),
                                             kind,
                                             dirtyRectsCount,
                                             dirtyRects,
                                             buffer,
                                             width,
                                             height);
end;

procedure cef_render_handler_on_cursor_change(      self               : POldCefRenderHandler;
                                                    browser            : POldCefBrowser;
                                                    cursor             : TOldCefCursorHandle;
                                                    type_              : TOldCefCursorType;
                                              const custom_cursor_info : POldCefCursorInfo); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRenderHandlerOwn) then
    TOldCefRenderHandlerOwn(TempObject).OnCursorChange(TOldCefBrowserRef.UnWrap(browser),
                                                    cursor,
                                                    type_,
                                                    custom_cursor_info);
end;

function cef_render_handler_start_dragging(self        : POldCefRenderHandler;
                                           browser     : POldCefBrowser;
                                           drag_data   : POldCefDragData;
                                           allowed_ops : TOldCefDragOperations;
                                           x           : Integer;
                                           y           : Integer): Integer; stdcall;
var
  TempObject : TObject;
begin
  Result     := Ord(False);
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRenderHandlerOwn) then
    Result := Ord(TOldCefRenderHandlerOwn(TempObject).OnStartDragging(TOldCefBrowserRef.UnWrap(browser),
                                                                   TOldCefDragDataRef.UnWrap(drag_data),
                                                                   allowed_ops,
                                                                   x,
                                                                   y));
end;

procedure cef_render_handler_update_drag_cursor(self      : POldCefRenderHandler;
                                                browser   : POldCefBrowser;
                                                operation : TOldCefDragOperation); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRenderHandlerOwn) then
    TOldCefRenderHandlerOwn(TempObject).OnUpdateDragCursor(TOldCefBrowserRef.UnWrap(browser), operation);
end;

procedure cef_render_handler_on_scroll_offset_changed(self    : POldCefRenderHandler;
                                                      browser : POldCefBrowser;
                                                      x       : Double;
                                                      y       : Double); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefRenderHandlerOwn) then
    TOldCefRenderHandlerOwn(TempObject).OnScrollOffsetChanged(TOldCefBrowserRef.UnWrap(browser),
                                                           x,
                                                           y);
end;

constructor TOldCefRenderHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefRenderHandler));

  with POldCefRenderHandler(FData)^ do
    begin
      get_root_screen_rect             := cef_render_handler_get_root_screen_rect;
      get_view_rect                    := cef_render_handler_get_view_rect;
      get_screen_point                 := cef_render_handler_get_screen_point;
      get_screen_info                  := cef_render_handler_get_screen_info;
      on_popup_show                    := cef_render_handler_on_popup_show;
      on_popup_size                    := cef_render_handler_on_popup_size;
      on_paint                         := cef_render_handler_on_paint;
      on_cursor_change                 := cef_render_handler_on_cursor_change;
      start_dragging                   := cef_render_handler_start_dragging;
      update_drag_cursor               := cef_render_handler_update_drag_cursor;
      on_scroll_offset_changed         := cef_render_handler_on_scroll_offset_changed;
    end;
end;

function TOldCefRenderHandlerOwn.GetRootScreenRect(const browser: IOldCefBrowser; var rect: TOldCefRect): Boolean;
begin
  Result := False;
end;

function TOldCefRenderHandlerOwn.GetScreenInfo(const browser: IOldCefBrowser; var screenInfo: TOldCefScreenInfo): Boolean;
begin
  Result := False;
end;

function TOldCefRenderHandlerOwn.GetScreenPoint(const browser: IOldCefBrowser; viewX, viewY: Integer; var screenX, screenY: Integer): Boolean;
begin
  Result := False;
end;

function TOldCefRenderHandlerOwn.GetViewRect(const browser: IOldCefBrowser; var rect: TOldCefRect): Boolean;
begin
  Result := False;
end;

procedure TOldCefRenderHandlerOwn.OnCursorChange(const browser: IOldCefBrowser; cursor: TOldCefCursorHandle; CursorType: TOldCefCursorType; const customCursorInfo: POldCefCursorInfo);
begin

end;

procedure TOldCefRenderHandlerOwn.OnPaint(const browser: IOldCefBrowser; kind: TOldCefPaintElementType; dirtyRectsCount: NativeUInt; const dirtyRects: POldCefRectArray; const buffer: Pointer; width, height: Integer);
begin

end;

procedure TOldCefRenderHandlerOwn.OnPopupShow(const browser: IOldCefBrowser; show: Boolean);
begin

end;

procedure TOldCefRenderHandlerOwn.OnPopupSize(const browser: IOldCefBrowser; const rect: POldCefRect);
begin

end;

procedure TOldCefRenderHandlerOwn.OnScrollOffsetChanged(const browser: IOldCefBrowser; x, y: Double);
begin

end;

function TOldCefRenderHandlerOwn.OnStartDragging(const browser: IOldCefBrowser; const dragData: IOldCefDragData; allowedOps: TOldCefDragOperations; x, y: Integer): Boolean;
begin
  Result := False;
end;

procedure TOldCefRenderHandlerOwn.OnUpdateDragCursor(const browser: IOldCefBrowser; operation: TOldCefDragOperation);
begin

end;

procedure TOldCefRenderHandlerOwn.RemoveReferences;
begin
  //
end;

// TCustomRenderHandler

constructor TOldCustomRenderHandler.Create(const events: Pointer);
begin
  inherited Create;

  FEvents := events;
end;

destructor TOldCustomRenderHandler.Destroy;
begin
  RemoveReferences;

  inherited Destroy;
end;

procedure TOldCustomRenderHandler.RemoveReferences;
begin
  FEvents := nil;
end;

function TOldCustomRenderHandler.GetRootScreenRect(const browser: IOldCefBrowser; var rect: TOldCefRect): Boolean;
begin
  if (FEvents <> nil) then
    Result := IOldChromiumEvents(FEvents).doOnGetRootScreenRect(browser, rect)
   else
    Result := inherited GetRootScreenRect(browser, rect);
end;

function TOldCustomRenderHandler.GetScreenInfo(const browser: IOldCefBrowser; var screenInfo: TOldCefScreenInfo): Boolean;
begin
  if (FEvents <> nil) then
    Result := IOldChromiumEvents(FEvents).doOnGetScreenInfo(browser, screenInfo)
   else
    Result := inherited GetScreenInfo(browser, screenInfo);
end;

function TOldCustomRenderHandler.GetScreenPoint(const browser: IOldCefBrowser; viewX, viewY: Integer; var screenX, screenY: Integer): Boolean;
begin
  if (FEvents <> nil) then
    Result := IOldChromiumEvents(FEvents).doOnGetScreenPoint(browser, viewX, viewY, screenX, screenY)
   else
    Result := inherited GetScreenPoint(browser, viewX, viewY, screenX, screenY);
end;

function TOldCustomRenderHandler.GetViewRect(const browser: IOldCefBrowser; var rect: TOldCefRect): Boolean;
begin
  if (FEvents <> nil) then
    Result := IOldChromiumEvents(FEvents).doOnGetViewRect(browser, rect)
   else
    Result := inherited GetViewRect(browser, rect);
end;

procedure TOldCustomRenderHandler.OnCursorChange(const browser          : IOldCefBrowser;
                                                    cursor           : TOldCefCursorHandle;
                                                    cursorType       : TOldCefCursorType;
                                              const customCursorInfo : POldCefCursorInfo);
begin
  if (FEvents <> nil) then IOldChromiumEvents(FEvents).doOnCursorChange(browser, cursor, cursorType, customCursorInfo);
end;

procedure TOldCustomRenderHandler.OnPaint(const browser         : IOldCefBrowser;
                                             kind            : TOldCefPaintElementType;
                                             dirtyRectsCount : NativeUInt;
                                       const dirtyRects      : POldCefRectArray;
                                       const buffer          : Pointer;
                                             width           : Integer;
                                             height          : Integer);
begin
  if (FEvents <> nil) then IOldChromiumEvents(FEvents).doOnPaint(browser, kind, dirtyRectsCount, dirtyRects, buffer, width, height);
end;

procedure TOldCustomRenderHandler.OnPopupShow(const browser: IOldCefBrowser; show: Boolean);
begin
  if (FEvents <> nil) then IOldChromiumEvents(FEvents).doOnPopupShow(browser, show);
end;

procedure TOldCustomRenderHandler.OnPopupSize(const browser: IOldCefBrowser; const rect: POldCefRect);
begin
  if (FEvents <> nil) then IOldChromiumEvents(FEvents).doOnPopupSize(browser, rect);
end;

procedure TOldCustomRenderHandler.OnScrollOffsetChanged(const browser: IOldCefBrowser; x, y: Double);
begin
  if (FEvents <> nil) then IOldChromiumEvents(FEvents).doOnScrollOffsetChanged(browser, x, y);
end;

function TOldCustomRenderHandler.OnStartDragging(const browser    : IOldCefBrowser;
                                              const dragData   : IOldCefDragData;
                                                    allowedOps : TOldCefDragOperations;
                                                    x          : Integer;
                                                    y          : Integer): Boolean;
begin
  if (FEvents <> nil) then
    Result := IOldChromiumEvents(FEvents).doOnStartDragging(browser, dragData, allowedOps, x, y)
   else
    Result := inherited OnStartDragging(browser, dragData, allowedOps, x, y);
end;

procedure TOldCustomRenderHandler.OnUpdateDragCursor(const browser: IOldCefBrowser; operation: TOldCefDragOperation);
begin
  if (FEvents <> nil) then IOldChromiumEvents(FEvents).doOnUpdateDragCursor(browser, operation);
end;

end.
