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

unit oldCEFDownLoadItem;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefDownLoadItemRef = class(TOldCefBaseRef, IOldCefDownloadItem)
  protected
    function IsValid: Boolean;
    function IsInProgress: Boolean;
    function IsComplete: Boolean;
    function IsCanceled: Boolean;
    function GetCurrentSpeed: Int64;
    function GetPercentComplete: Integer;
    function GetTotalBytes: Int64;
    function GetReceivedBytes: Int64;
    function GetStartTime: TDateTime;
    function GetEndTime: TDateTime;
    function GetFullPath: oldustring;
    function GetId: Cardinal;
    function GetUrl: oldustring;
    function GetOriginalUrl: oldustring;
    function GetSuggestedFileName: oldustring;
    function GetContentDisposition: oldustring;
    function GetMimeType: oldustring;
  public
    class function UnWrap(data: Pointer): IOldCefDownloadItem;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions;

function TOldCefDownLoadItemRef.GetContentDisposition: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefDownloadItem(FData)^.get_content_disposition(POldCefDownloadItem(FData)));
end;

function TOldCefDownLoadItemRef.GetCurrentSpeed: Int64;
begin
  Result := POldCefDownloadItem(FData)^.get_current_speed(POldCefDownloadItem(FData));
end;

function TOldCefDownLoadItemRef.GetEndTime: TDateTime;
begin
  Result := CefTimeToDateTime(POldCefDownloadItem(FData)^.get_end_time(POldCefDownloadItem(FData)));
end;

function TOldCefDownLoadItemRef.GetFullPath: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefDownloadItem(FData)^.get_full_path(POldCefDownloadItem(FData)));
end;

function TOldCefDownLoadItemRef.GetId: Cardinal;
begin
  Result := POldCefDownloadItem(FData)^.get_id(POldCefDownloadItem(FData));
end;

function TOldCefDownLoadItemRef.GetMimeType: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefDownloadItem(FData)^.get_mime_type(POldCefDownloadItem(FData)));
end;

function TOldCefDownLoadItemRef.GetOriginalUrl: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefDownloadItem(FData)^.get_original_url(POldCefDownloadItem(FData)));
end;

function TOldCefDownLoadItemRef.GetPercentComplete: Integer;
begin
  Result := POldCefDownloadItem(FData)^.get_percent_complete(POldCefDownloadItem(FData));
end;

function TOldCefDownLoadItemRef.GetReceivedBytes: Int64;
begin
  Result := POldCefDownloadItem(FData)^.get_received_bytes(POldCefDownloadItem(FData));
end;

function TOldCefDownLoadItemRef.GetStartTime: TDateTime;
begin
  Result := CefTimeToDateTime(POldCefDownloadItem(FData)^.get_start_time(POldCefDownloadItem(FData)));
end;

function TOldCefDownLoadItemRef.GetSuggestedFileName: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefDownloadItem(FData)^.get_suggested_file_name(POldCefDownloadItem(FData)));
end;

function TOldCefDownLoadItemRef.GetTotalBytes: Int64;
begin
  Result := POldCefDownloadItem(FData)^.get_total_bytes(POldCefDownloadItem(FData));
end;

function TOldCefDownLoadItemRef.GetUrl: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefDownloadItem(FData)^.get_url(POldCefDownloadItem(FData)));
end;

function TOldCefDownLoadItemRef.IsCanceled: Boolean;
begin
  Result := POldCefDownloadItem(FData)^.is_canceled(POldCefDownloadItem(FData)) <> 0;
end;

function TOldCefDownLoadItemRef.IsComplete: Boolean;
begin
  Result := POldCefDownloadItem(FData)^.is_complete(POldCefDownloadItem(FData)) <> 0;
end;

function TOldCefDownLoadItemRef.IsInProgress: Boolean;
begin
  Result := POldCefDownloadItem(FData)^.is_in_progress(POldCefDownloadItem(FData)) <> 0;
end;

function TOldCefDownLoadItemRef.IsValid: Boolean;
begin
  Result := POldCefDownloadItem(FData)^.is_valid(POldCefDownloadItem(FData)) <> 0;
end;

class function TOldCefDownLoadItemRef.UnWrap(data: Pointer): IOldCefDownloadItem;
begin
  if data <> nil then
    Result := Create(data) as IOldCefDownloadItem else
    Result := nil;
end;

end.
