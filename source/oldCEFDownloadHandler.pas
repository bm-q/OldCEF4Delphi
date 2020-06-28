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

unit oldCEFDownloadHandler;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefDownloadHandlerOwn = class(TOldCefBaseOwn, IOldCefDownloadHandler)
    protected
      procedure OnBeforeDownload(const browser: IOldCefBrowser; const downloadItem: IOldCefDownloadItem; const suggestedName: oldustring; const callback: IOldCefBeforeDownloadCallback); virtual;
      procedure OnDownloadUpdated(const browser: IOldCefBrowser; const downloadItem: IOldCefDownloadItem; const callback: IOldCefDownloadItemCallback); virtual;

      procedure RemoveReferences; virtual;

    public
      constructor Create; virtual;
  end;

  TOldCustomDownloadHandler = class(TOldCefDownloadHandlerOwn)
    protected
      FEvents : Pointer;

      procedure OnBeforeDownload(const browser: IOldCefBrowser; const downloadItem: IOldCefDownloadItem; const suggestedName: oldustring; const callback: IOldCefBeforeDownloadCallback); override;
      procedure OnDownloadUpdated(const browser: IOldCefBrowser; const downloadItem: IOldCefDownloadItem; const callback: IOldCefDownloadItemCallback); override;

      procedure RemoveReferences; override;

    public
      constructor Create(const events: Pointer); reintroduce; virtual;
      destructor  Destroy; override;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFBrowser, oldCEFDownLoadItem, oldCEFBeforeDownloadCallback,
  oldCEFDownloadItemCallback;

procedure cef_download_handler_on_before_download(      self           : POldCefDownloadHandler;
                                                        browser        : POldCefBrowser;
                                                        download_item  : POldCefDownloadItem;
                                                  const suggested_name : POldCefString;
                                                        callback       : POldCefBeforeDownloadCallback); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefDownloadHandlerOwn) then
    TOldCefDownloadHandlerOwn(TempObject).OnBeforeDownload(TOldCefBrowserRef.UnWrap(browser),
                                                        TOldCefDownLoadItemRef.UnWrap(download_item),
                                                        CefString(suggested_name),
                                                        TOldCefBeforeDownloadCallbackRef.UnWrap(callback));
end;

procedure cef_download_handler_on_download_updated(self          : POldCefDownloadHandler;
                                                   browser       : POldCefBrowser;
                                                   download_item : POldCefDownloadItem;
                                                   callback      : POldCefDownloadItemCallback); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefDownloadHandlerOwn) then
    TOldCefDownloadHandlerOwn(TempObject).OnDownloadUpdated(TOldCefBrowserRef.UnWrap(browser),
                                                         TOldCefDownLoadItemRef.UnWrap(download_item),
                                                         TOldCefDownloadItemCallbackRef.UnWrap(callback));
end;

constructor TOldCefDownloadHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefDownloadHandler));

  with POldCefDownloadHandler(FData)^ do
    begin
      on_before_download  := cef_download_handler_on_before_download;
      on_download_updated := cef_download_handler_on_download_updated;
    end;
end;

procedure TOldCefDownloadHandlerOwn.OnBeforeDownload(const browser       : IOldCefBrowser;
                                                  const downloadItem  : IOldCefDownloadItem;
                                                  const suggestedName : oldustring;
                                                  const callback      : IOldCefBeforeDownloadCallback);
begin

end;

procedure TOldCefDownloadHandlerOwn.OnDownloadUpdated(const browser      : IOldCefBrowser;
                                                   const downloadItem : IOldCefDownloadItem;
                                                   const callback     : IOldCefDownloadItemCallback);
begin

end;

procedure TOldCefDownloadHandlerOwn.RemoveReferences;
begin
  //
end;

// TCustomDownloadHandler

constructor TOldCustomDownloadHandler.Create(const events: Pointer);
begin
  inherited Create;

  FEvents := events;
end;

destructor TOldCustomDownloadHandler.Destroy;
begin
  RemoveReferences;

  inherited Destroy;
end;

procedure TOldCustomDownloadHandler.RemoveReferences;
begin
  FEvents := nil;
end;

procedure TOldCustomDownloadHandler.OnBeforeDownload(const browser       : IOldCefBrowser;
                                                  const downloadItem  : IOldCefDownloadItem;
                                                  const suggestedName : oldustring;
                                                  const callback      : IOldCefBeforeDownloadCallback);
begin
  if (FEvents <> nil) then IOldChromiumEvents(FEvents).doOnBeforeDownload(browser, downloadItem, suggestedName, callback);
end;

procedure TOldCustomDownloadHandler.OnDownloadUpdated(const browser      : IOldCefBrowser;
                                                   const downloadItem : IOldCefDownloadItem;
                                                   const callback     : IOldCefDownloadItemCallback);
begin
  if (FEvents <> nil) then IOldChromiumEvents(FEvents).doOnDownloadUpdated(browser, downloadItem, callback);
end;

end.
