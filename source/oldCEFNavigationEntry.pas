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

unit oldCEFNavigationEntry;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefNavigationEntryRef = class(TOldCefBaseRef, IOldCefNavigationEntry)
    protected
      function IsValid: Boolean;
      function GetUrl: oldustring;
      function GetDisplayUrl: oldustring;
      function GetOriginalUrl: oldustring;
      function GetTitle: oldustring;
      function GetTransitionType: TOldCefTransitionType;
      function HasPostData: Boolean;
      function GetCompletionTime: TDateTime;
      function GetHttpStatusCode: Integer;

    public
      class function UnWrap(data: Pointer): IOldCefNavigationEntry;
  end;

implementation

uses
  oldCEFMiscFunctions;

function TOldCefNavigationEntryRef.IsValid: Boolean;
begin
  Result := POldCefNavigationEntry(FData).is_valid(FData) <> 0;
end;

function TOldCefNavigationEntryRef.GetUrl: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefNavigationEntry(FData).get_url(FData));
end;

function TOldCefNavigationEntryRef.GetDisplayUrl: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefNavigationEntry(FData).get_display_url(FData));
end;

function TOldCefNavigationEntryRef.GetOriginalUrl: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefNavigationEntry(FData).get_original_url(FData));
end;

function TOldCefNavigationEntryRef.GetTitle: oldustring;
begin
  Result := CefStringFreeAndGet(POldCefNavigationEntry(FData).get_title(FData));
end;

function TOldCefNavigationEntryRef.GetTransitionType: TOldCefTransitionType;
begin
  Result := POldCefNavigationEntry(FData).get_transition_type(FData);
end;

function TOldCefNavigationEntryRef.HasPostData: Boolean;
begin
  Result := POldCefNavigationEntry(FData).has_post_data(FData) <> 0;
end;

function TOldCefNavigationEntryRef.GetCompletionTime: TDateTime;
begin
  Result := CefTimeToDateTime(POldCefNavigationEntry(FData).get_completion_time(FData));
end;

function TOldCefNavigationEntryRef.GetHttpStatusCode: Integer;
begin
  Result := POldCefNavigationEntry(FData).get_http_status_code(FData);
end;

class function TOldCefNavigationEntryRef.UnWrap(data: Pointer): IOldCefNavigationEntry;
begin
  if (data <> nil) then
    Result := Create(data) as IOldCefNavigationEntry
   else
    Result := nil;
end;

end.
