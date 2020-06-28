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

unit oldCEFBrowser;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
  System.Classes, System.SysUtils,
  {$ELSE}
  Classes, SysUtils,
  {$ENDIF}
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefBrowserRef = class(TOldCefBaseRef, IOldCefBrowser)
    protected
      function  GetHost: IOldCefBrowserHost;
      function  CanGoBack: Boolean;
      procedure GoBack;
      function  CanGoForward: Boolean;
      procedure GoForward;
      function  IsLoading: Boolean;
      procedure Reload;
      procedure ReloadIgnoreCache;
      procedure StopLoad;
      function  GetIdentifier: Integer;
      function  IsSame(const that: IOldCefBrowser): Boolean;
      function  IsPopup: Boolean;
      function  HasDocument: Boolean;
      function  GetMainFrame: IOldCefFrame;
      function  GetFocusedFrame: IOldCefFrame;
      function  GetFrameByident(const identifier: Int64): IOldCefFrame;
      function  GetFrame(const name: oldustring): IOldCefFrame;
      function  GetFrameCount: NativeUInt;
      function  GetFrameIdentifiers(var aFrameCount : NativeUInt; var aFrameIdentifierArray : TOldCefFrameIdentifierArray) : boolean;
      function  GetFrameNames(var aFrameNames : TStrings) : boolean;
      function  SendProcessMessage(targetProcess: TOldCefProcessId; const ProcMessage: IOldCefProcessMessage): Boolean;

    public
      class function UnWrap(data: Pointer): IOldCefBrowser;
  end;

  TOldCefBrowserHostRef = class(TOldCefBaseRef, IOldCefBrowserHost)
    protected
      function  GetBrowser: IOldCefBrowser;
      procedure CloseBrowser(forceClose: Boolean);
      procedure SetFocus(focus: Boolean);
      procedure SetWindowVisibility(visible: Boolean);
      function  GetWindowHandle: TOldCefWindowHandle;
      function  GetOpenerWindowHandle: TOldCefWindowHandle;
      function  GetRequestContext: IOldCefRequestContext;
      function  GetZoomLevel: Double;
      procedure SetZoomLevel(const zoomLevel: Double);
      procedure RunFileDialog(mode: TOldCefFileDialogMode; const title, defaultFilePath: oldustring; const acceptFilters: TStrings; selectedAcceptFilter: Integer; const callback: IOldCefRunFileDialogCallback);
      procedure RunFileDialogProc(mode: TOldCefFileDialogMode; const title, defaultFilePath: oldustring; const acceptFilters: TStrings; selectedAcceptFilter: Integer; const callback: TOldCefRunFileDialogCallbackProc);
      procedure StartDownload(const url: oldustring);
      procedure Print;
      procedure PrintToPdf(const path: oldustring; settings: POldCefPdfPrintSettings; const callback: IOldCefPdfPrintCallback);
      procedure PrintToPdfProc(const path: oldustring; settings: POldCefPdfPrintSettings; const callback: TOnPdfPrintFinishedProc);
      procedure Find(identifier: Integer; const searchText: oldustring; forward, matchCase, findNext: Boolean);
      procedure StopFinding(clearSelection: Boolean);
      procedure ShowDevTools(const windowInfo: POldCefWindowInfo; const client: IOldCefClient; const settings: POldCefBrowserSettings; inspectElementAt: POldCefPoint);
      procedure CloseDevTools;
      procedure GetNavigationEntries(const visitor: IOldCefNavigationEntryVisitor; currentOnly: Boolean);
      procedure GetNavigationEntriesProc(const proc: TOldCefNavigationEntryVisitorProc; currentOnly: Boolean);
      procedure SetMouseCursorChangeDisabled(disabled: Boolean);
      function  IsMouseCursorChangeDisabled: Boolean;
      procedure ReplaceMisspelling(const word: oldustring);
      procedure AddWordToDictionary(const word: oldustring);
      function  IsWindowRenderingDisabled: Boolean;
      procedure WasResized;
      procedure NotifyScreenInfoChanged;
      procedure WasHidden(hidden: Boolean);
      procedure Invalidate(kind: TOldCefPaintElementType);
      procedure SendKeyEvent(const event: POldCefKeyEvent);
      procedure SendMouseClickEvent(const event: POldCefMouseEvent; kind: TOldCefMouseButtonType; mouseUp: Boolean; clickCount: Integer);
      procedure SendMouseMoveEvent(const event: POldCefMouseEvent; mouseLeave: Boolean);
      procedure SendMouseWheelEvent(const event: POldCefMouseEvent; deltaX, deltaY: Integer);
      procedure SendFocusEvent(setFocus: Boolean);
      procedure SendCaptureLostEvent;
      procedure NotifyMoveOrResizeStarted;
      function  GetWindowlessFrameRate : Integer;
      procedure SetWindowlessFrameRate(frameRate: Integer);
      function  GetNsTextInputContext: TOldCefTextInputContext;
      procedure HandleKeyEventBeforeTextInputClient(keyEvent: TOldCefEventHandle);
      procedure HandleKeyEventAfterTextInputClient(keyEvent: TOldCefEventHandle);
      procedure DragTargetDragEnter(const dragData: IOldCefDragData; const event: POldCefMouseEvent; allowedOps: TOldCefDragOperations);
      procedure DragTargetDragOver(const event: POldCefMouseEvent; allowedOps: TOldCefDragOperations);
      procedure DragTargetDragLeave;
      procedure DragTargetDrop(event: POldCefMouseEvent);
      procedure DragSourceEndedAt(x, y: Integer; op: TOldCefDragOperation);
      procedure DragSourceSystemDragEnded;

    public
      class function UnWrap(data: Pointer): IOldCefBrowserHost;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFFrame, oldCEFPDFPrintCallback, oldCEFRunFileDialogCallback,
  oldCEFRequestContext, oldCEFNavigationEntryVisitor, oldCEFNavigationEntry, oldCEFStringList;

function TOldCefBrowserRef.GetHost: IOldCefBrowserHost;
begin
  Result := TOldCefBrowserHostRef.UnWrap(POldCefBrowser(FData)^.get_host(POldCefBrowser(FData)));
end;

function TOldCefBrowserRef.CanGoBack: Boolean;
begin
  Result := POldCefBrowser(FData)^.can_go_back(POldCefBrowser(FData)) <> 0;
end;

function TOldCefBrowserRef.CanGoForward: Boolean;
begin
  Result := POldCefBrowser(FData)^.can_go_forward(POldCefBrowser(FData)) <> 0;
end;

function TOldCefBrowserRef.GetFocusedFrame: IOldCefFrame;
begin
  Result := TOldCefFrameRef.UnWrap(POldCefBrowser(FData)^.get_focused_frame(POldCefBrowser(FData)));
end;

function TOldCefBrowserRef.GetFrameByident(const identifier: Int64): IOldCefFrame;
begin
  Result := TOldCefFrameRef.UnWrap(POldCefBrowser(FData)^.get_frame_byident(POldCefBrowser(FData), identifier));
end;

function TOldCefBrowserRef.GetFrame(const name: oldustring): IOldCefFrame;
var
  n: TOldCefString;
begin
  n := CefString(name);
  Result := TOldCefFrameRef.UnWrap(POldCefBrowser(FData)^.get_frame(POldCefBrowser(FData), @n));
end;

function TOldCefBrowserRef.GetFrameCount: NativeUInt;
begin
  Result := POldCefBrowser(FData)^.get_frame_count(POldCefBrowser(FData));
end;

function TOldCefBrowserRef.GetFrameIdentifiers(var aFrameCount : NativeUInt; var aFrameIdentifierArray : TOldCefFrameIdentifierArray) : boolean;
var
  i : NativeUInt;
begin
  Result := False;

  try
    if (aFrameCount > 0) then
      begin
        SetLength(aFrameIdentifierArray, aFrameCount);
        i := 0;
        while (i < aFrameCount) do
          begin
            aFrameIdentifierArray[i] := 0;
            inc(i);
          end;

        POldCefBrowser(FData)^.get_frame_identifiers(POldCefBrowser(FData), aFrameCount, aFrameIdentifierArray[0]);

        Result := True;
      end;
  except
    on e : exception do
      if CustomExceptionHandler('TOldCefBrowserRef.GetFrameIdentifiers', e) then raise;
  end;
end;

function TOldCefBrowserRef.GetFrameNames(var aFrameNames : TStrings) : boolean;
var
  TempSL : IOldCefStringList;
begin
  Result := False;

  if (aFrameNames <> nil) then
    begin
      TempSL := TOldCefStringListOwn.Create;
      POldCefBrowser(FData)^.get_frame_names(POldCefBrowser(FData), TempSL.Handle);
      TempSL.CopyToStrings(aFrameNames);
      Result := True;
    end;
end;

function TOldCefBrowserRef.SendProcessMessage(targetProcess: TOldCefProcessId; const ProcMessage: IOldCefProcessMessage): Boolean;
begin
  Result := POldCefBrowser(FData)^.send_process_message(POldCefBrowser(FData), targetProcess, CefGetData(ProcMessage)) <> 0;
end;

function TOldCefBrowserRef.GetMainFrame: IOldCefFrame;
begin
  Result := TOldCefFrameRef.UnWrap(POldCefBrowser(FData)^.get_main_frame(POldCefBrowser(FData)))
end;

procedure TOldCefBrowserRef.GoBack;
begin
  POldCefBrowser(FData)^.go_back(POldCefBrowser(FData));
end;

procedure TOldCefBrowserRef.GoForward;
begin
  POldCefBrowser(FData)^.go_forward(POldCefBrowser(FData));
end;

function TOldCefBrowserRef.IsLoading: Boolean;
begin
  Result := POldCefBrowser(FData)^.is_loading(POldCefBrowser(FData)) <> 0;
end;

function TOldCefBrowserRef.HasDocument: Boolean;
begin
  Result := POldCefBrowser(FData)^.has_document(POldCefBrowser(FData)) <> 0;
end;

function TOldCefBrowserRef.IsPopup: Boolean;
begin
  Result := POldCefBrowser(FData)^.is_popup(POldCefBrowser(FData)) <> 0;
end;

function TOldCefBrowserRef.IsSame(const that: IOldCefBrowser): Boolean;
begin
  Result := POldCefBrowser(FData)^.is_same(POldCefBrowser(FData), CefGetData(that)) <> 0;
end;

procedure TOldCefBrowserRef.Reload;
begin
  POldCefBrowser(FData)^.reload(POldCefBrowser(FData));
end;

procedure TOldCefBrowserRef.ReloadIgnoreCache;
begin
  POldCefBrowser(FData)^.reload_ignore_cache(POldCefBrowser(FData));
end;

procedure TOldCefBrowserRef.StopLoad;
begin
  POldCefBrowser(FData)^.stop_load(POldCefBrowser(FData));
end;

function TOldCefBrowserRef.GetIdentifier: Integer;
begin
  Result := POldCefBrowser(FData)^.get_identifier(POldCefBrowser(FData));
end;

class function TOldCefBrowserRef.UnWrap(data: Pointer): IOldCefBrowser;
begin
  if (data <> nil) then
    Result := Create(data) as IOldCefBrowser
   else
    Result := nil;
end;

// TOldCefBrowserHostRef

procedure TOldCefBrowserHostRef.CloseDevTools;
begin
  POldCefBrowserHost(FData).close_dev_tools(FData);
end;

procedure TOldCefBrowserHostRef.DragSourceEndedAt(x, y: Integer; op: TOldCefDragOperation);
begin
  POldCefBrowserHost(FData).drag_source_ended_at(FData, x, y, op);
end;

procedure TOldCefBrowserHostRef.DragSourceSystemDragEnded;
begin
  POldCefBrowserHost(FData).drag_source_system_drag_ended(FData);
end;

procedure TOldCefBrowserHostRef.DragTargetDragEnter(const dragData: IOldCefDragData;
  const event: POldCefMouseEvent; allowedOps: TOldCefDragOperations);
begin
  POldCefBrowserHost(FData).drag_target_drag_enter(FData, CefGetData(dragData), event, allowedOps);
end;

procedure TOldCefBrowserHostRef.DragTargetDragLeave;
begin
  POldCefBrowserHost(FData).drag_target_drag_leave(FData);
end;

procedure TOldCefBrowserHostRef.DragTargetDragOver(const event: POldCefMouseEvent;
  allowedOps: TOldCefDragOperations);
begin
  POldCefBrowserHost(FData).drag_target_drag_over(FData, event, allowedOps);
end;

procedure TOldCefBrowserHostRef.DragTargetDrop(event: POldCefMouseEvent);
begin
  POldCefBrowserHost(FData).drag_target_drop(FData, event);
end;

procedure TOldCefBrowserHostRef.Find(identifier: Integer; const searchText: oldustring; forward, matchCase, findNext: Boolean);
var
  s: TOldCefString;
begin
  s := CefString(searchText);
  POldCefBrowserHost(FData).find(FData, identifier, @s, Ord(forward), Ord(matchCase), Ord(findNext));
end;

function TOldCefBrowserHostRef.GetBrowser: IOldCefBrowser;
begin
  Result := TOldCefBrowserRef.UnWrap(POldCefBrowserHost(FData).get_browser(POldCefBrowserHost(FData)));
end;

procedure TOldCefBrowserHostRef.Print;
begin
  POldCefBrowserHost(FData).print(FData);
end;

procedure TOldCefBrowserHostRef.PrintToPdf(const path     : oldustring;
                                              settings : POldCefPdfPrintSettings;
                                        const callback : IOldCefPdfPrintCallback);
var
  str: TOldCefString;
begin
  str := CefString(path);
  POldCefBrowserHost(FData).print_to_pdf(FData, @str, settings, CefGetData(callback));
end;

procedure TOldCefBrowserHostRef.PrintToPdfProc(const path     : oldustring;
                                                  settings : POldCefPdfPrintSettings;
                                            const callback : TOnPdfPrintFinishedProc);
begin
  PrintToPdf(path, settings, TOldCefFastPdfPrintCallback.Create(callback));
end;

procedure TOldCefBrowserHostRef.ReplaceMisspelling(const word: oldustring);
var
  str: TOldCefString;
begin
  str := CefString(word);
  POldCefBrowserHost(FData).replace_misspelling(FData, @str);
end;

procedure TOldCefBrowserHostRef.RunFileDialog(      mode                 : TOldCefFileDialogMode;
                                           const title                : oldustring;
                                           const defaultFilePath      : oldustring;
                                           const acceptFilters        : TStrings;
                                                 selectedAcceptFilter : Integer;
                                           const callback             : IOldCefRunFileDialogCallback);
var
  TempTitle, TempPath : TOldCefString;
  TempAcceptFilters : IOldCefStringList;
begin
  try
    TempTitle := CefString(title);
    TempPath  := CefString(defaultFilePath);

    TempAcceptFilters := TOldCefStringListOwn.Create;
    TempAcceptFilters.AddStrings(acceptFilters);

    POldCefBrowserHost(FData).run_file_dialog(POldCefBrowserHost(FData),
                                           mode,
                                           @TempTitle,
                                           @TempPath,
                                           TempAcceptFilters.Handle,
                                           selectedAcceptFilter,
                                           CefGetData(callback));
  finally
    TempAcceptFilters := nil;
  end;
end;

procedure TOldCefBrowserHostRef.RunFileDialogProc(      mode                 : TOldCefFileDialogMode;
                                               const title                : oldustring;
                                               const defaultFilePath      : oldustring;
                                               const acceptFilters        : TStrings;
                                                     selectedAcceptFilter : Integer;
                                               const callback             : TOldCefRunFileDialogCallbackProc);
begin
  RunFileDialog(mode, title, defaultFilePath, acceptFilters, selectedAcceptFilter, TOldCefFastRunFileDialogCallback.Create(callback));
end;

procedure TOldCefBrowserHostRef.AddWordToDictionary(const word: oldustring);
var
  str: TOldCefString;
begin
  str := CefString(word);
  POldCefBrowserHost(FData).add_word_to_dictionary(FData, @str);
end;

procedure TOldCefBrowserHostRef.CloseBrowser(forceClose: Boolean);
begin
  POldCefBrowserHost(FData).close_browser(POldCefBrowserHost(FData), Ord(forceClose));
end;

procedure TOldCefBrowserHostRef.SendCaptureLostEvent;
begin
  POldCefBrowserHost(FData).send_capture_lost_event(FData);
end;

procedure TOldCefBrowserHostRef.SendFocusEvent(setFocus: Boolean);
begin
  POldCefBrowserHost(FData).send_focus_event(FData, Ord(setFocus));
end;

procedure TOldCefBrowserHostRef.SendKeyEvent(const event: POldCefKeyEvent);
begin
  POldCefBrowserHost(FData).send_key_event(FData, event);
end;

procedure TOldCefBrowserHostRef.SendMouseClickEvent(const event      : POldCefMouseEvent;
                                                       kind       : TOldCefMouseButtonType;
                                                       mouseUp    : Boolean;
                                                       clickCount : Integer);
begin
  POldCefBrowserHost(FData).send_mouse_click_event(FData, event, kind, Ord(mouseUp), clickCount);
end;

procedure TOldCefBrowserHostRef.SendMouseMoveEvent(const event: POldCefMouseEvent; mouseLeave: Boolean);
begin
  POldCefBrowserHost(FData).send_mouse_move_event(FData, event, Ord(mouseLeave));
end;

procedure TOldCefBrowserHostRef.SendMouseWheelEvent(const event: POldCefMouseEvent; deltaX, deltaY: Integer);
begin
  POldCefBrowserHost(FData).send_mouse_wheel_event(FData, event, deltaX, deltaY);
end;

procedure TOldCefBrowserHostRef.SetFocus(focus: Boolean);
begin
  POldCefBrowserHost(FData).set_focus(POldCefBrowserHost(FData), Ord(focus));
end;

procedure TOldCefBrowserHostRef.SetWindowVisibility(visible: Boolean);
begin
  POldCefBrowserHost(FData).set_window_visibility(POldCefBrowserHost(FData), Ord(visible));
end;

procedure TOldCefBrowserHostRef.SetMouseCursorChangeDisabled(disabled: Boolean);
begin
  POldCefBrowserHost(FData).set_mouse_cursor_change_disabled(POldCefBrowserHost(FData), Ord(disabled));
end;

procedure TOldCefBrowserHostRef.SetWindowlessFrameRate(frameRate: Integer);
begin
  POldCefBrowserHost(FData).set_windowless_frame_rate(POldCefBrowserHost(FData), frameRate);
end;

function TOldCefBrowserHostRef.GetNsTextInputContext: TOldCefTextInputContext;
begin
  Result := POldCefBrowserHost(FData).get_nstext_input_context(POldCefBrowserHost(FData));
end;

procedure TOldCefBrowserHostRef.HandleKeyEventBeforeTextInputClient(keyEvent: TOldCefEventHandle);
begin
  POldCefBrowserHost(FData).handle_key_event_before_text_input_client(POldCefBrowserHost(FData), keyEvent);
end;

procedure TOldCefBrowserHostRef.HandleKeyEventAfterTextInputClient(keyEvent: TOldCefEventHandle);
begin
  POldCefBrowserHost(FData).handle_key_event_after_text_input_client(POldCefBrowserHost(FData), keyEvent);
end;

function TOldCefBrowserHostRef.GetWindowHandle: TOldCefWindowHandle;
begin
  Result := POldCefBrowserHost(FData).get_window_handle(POldCefBrowserHost(FData))
end;

function TOldCefBrowserHostRef.GetWindowlessFrameRate: Integer;
begin
  Result := POldCefBrowserHost(FData).get_windowless_frame_rate(POldCefBrowserHost(FData));
end;

function TOldCefBrowserHostRef.GetOpenerWindowHandle: TOldCefWindowHandle;
begin
  Result := POldCefBrowserHost(FData).get_opener_window_handle(POldCefBrowserHost(FData));
end;

function TOldCefBrowserHostRef.GetRequestContext: IOldCefRequestContext;
begin
  Result := TOldCefRequestContextRef.UnWrap(POldCefBrowserHost(FData).get_request_context(FData));
end;

procedure TOldCefBrowserHostRef.GetNavigationEntries(const visitor: IOldCefNavigationEntryVisitor; currentOnly: Boolean);
begin
  POldCefBrowserHost(FData).get_navigation_entries(FData, CefGetData(visitor), Ord(currentOnly));
end;

procedure TOldCefBrowserHostRef.GetNavigationEntriesProc(const proc: TOldCefNavigationEntryVisitorProc; currentOnly: Boolean);
begin
  GetNavigationEntries(TOldCefFastNavigationEntryVisitor.Create(proc), currentOnly);
end;

function TOldCefBrowserHostRef.GetZoomLevel: Double;
begin
  Result := POldCefBrowserHost(FData).get_zoom_level(POldCefBrowserHost(FData));
end;

procedure TOldCefBrowserHostRef.Invalidate(kind: TOldCefPaintElementType);
begin
  POldCefBrowserHost(FData).invalidate(FData, kind);
end;

function TOldCefBrowserHostRef.IsMouseCursorChangeDisabled: Boolean;
begin
  Result := POldCefBrowserHost(FData).is_mouse_cursor_change_disabled(FData) <> 0;
end;

function TOldCefBrowserHostRef.IsWindowRenderingDisabled: Boolean;
begin
  Result := POldCefBrowserHost(FData).is_window_rendering_disabled(FData) <> 0;
end;

procedure TOldCefBrowserHostRef.NotifyMoveOrResizeStarted;
begin
  POldCefBrowserHost(FData).notify_move_or_resize_started(POldCefBrowserHost(FData));
end;

procedure TOldCefBrowserHostRef.NotifyScreenInfoChanged;
begin
  POldCefBrowserHost(FData).notify_screen_info_changed(POldCefBrowserHost(FData));
end;

procedure TOldCefBrowserHostRef.SetZoomLevel(const zoomLevel: Double);
begin
  POldCefBrowserHost(FData).set_zoom_level(POldCefBrowserHost(FData), zoomLevel);
end;

procedure TOldCefBrowserHostRef.ShowDevTools(const windowInfo       : POldCefWindowInfo;
                                          const client           : IOldCefClient;
                                          const settings         : POldCefBrowserSettings;
                                                inspectElementAt : POldCefPoint);
begin
  POldCefBrowserHost(FData).show_dev_tools(FData, windowInfo, CefGetData(client), settings, inspectElementAt);
end;

procedure TOldCefBrowserHostRef.StartDownload(const url: oldustring);
var
  u: TOldCefString;
begin
  u := CefString(url);
  POldCefBrowserHost(FData).start_download(POldCefBrowserHost(FData), @u);
end;

procedure TOldCefBrowserHostRef.StopFinding(clearSelection: Boolean);
begin
  POldCefBrowserHost(FData).stop_finding(FData, Ord(clearSelection));
end;

class function TOldCefBrowserHostRef.UnWrap(data: Pointer): IOldCefBrowserHost;
begin
  if data <> nil then
    Result := Create(data) as IOldCefBrowserHost else
    Result := nil;
end;

procedure TOldCefBrowserHostRef.WasHidden(hidden: Boolean);
begin
  POldCefBrowserHost(FData).was_hidden(FData, Ord(hidden));
end;

procedure TOldCefBrowserHostRef.WasResized;
begin
  POldCefBrowserHost(FData).was_resized(FData);
end;


end.
