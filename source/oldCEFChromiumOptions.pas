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

unit oldCEFChromiumOptions;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
  System.Classes,
  {$ELSE}
  Classes,
  {$ENDIF}
  oldCEFTypes;

type
  TOldChromiumOptions = class(TPersistent)
    protected
      FWindowlessFrameRate         : Integer;
      FJavascript                  : TOldCefState;
      FJavascriptOpenWindows       : TOldCefState;
      FJavascriptCloseWindows      : TOldCefState;
      FJavascriptAccessClipboard   : TOldCefState;
      FJavascriptDomPaste          : TOldCefState;
      FCaretBrowsing               : TOldCefState;
      FPlugins                     : TOldCefState;
      FUniversalAccessFromFileUrls : TOldCefState;
      FFileAccessFromFileUrls      : TOldCefState;
      FWebSecurity                 : TOldCefState;
      FImageLoading                : TOldCefState;
      FImageShrinkStandaloneToFit  : TOldCefState;
      FTextAreaResize              : TOldCefState;
      FTabToLinks                  : TOldCefState;
      FLocalStorage                : TOldCefState;
      FDatabases                   : TOldCefState;
      FApplicationCache            : TOldCefState;
      FWebgl                       : TOldCefState;
      FBackgroundColor             : TOldCefColor;
      FAcceptLanguageList          : oldustring;

    public
      constructor Create; virtual;

    published
      property Javascript                  : TOldCefState read FJavascript                   write FJavascript                  default STATE_DEFAULT;
      property JavascriptOpenWindows       : TOldCefState read FJavascriptOpenWindows        write FJavascriptOpenWindows       default STATE_DEFAULT;
      property JavascriptCloseWindows      : TOldCefState read FJavascriptCloseWindows       write FJavascriptCloseWindows      default STATE_DEFAULT;
      property JavascriptAccessClipboard   : TOldCefState read FJavascriptAccessClipboard    write FJavascriptAccessClipboard   default STATE_DEFAULT;
      property JavascriptDomPaste          : TOldCefState read FJavascriptDomPaste           write FJavascriptDomPaste          default STATE_DEFAULT;
      property CaretBrowsing               : TOldCefState read FCaretBrowsing                write FCaretBrowsing               default STATE_DEFAULT;
      property Plugins                     : TOldCefState read FPlugins                      write FPlugins                     default STATE_DEFAULT;
      property UniversalAccessFromFileUrls : TOldCefState read FUniversalAccessFromFileUrls  write FUniversalAccessFromFileUrls default STATE_DEFAULT;
      property FileAccessFromFileUrls      : TOldCefState read FFileAccessFromFileUrls       write FFileAccessFromFileUrls      default STATE_DEFAULT;
      property WebSecurity                 : TOldCefState read FWebSecurity                  write FWebSecurity                 default STATE_DEFAULT;
      property ImageLoading                : TOldCefState read FImageLoading                 write FImageLoading                default STATE_DEFAULT;
      property ImageShrinkStandaloneToFit  : TOldCefState read FImageShrinkStandaloneToFit   write FImageShrinkStandaloneToFit  default STATE_DEFAULT;
      property TextAreaResize              : TOldCefState read FTextAreaResize               write FTextAreaResize              default STATE_DEFAULT;
      property TabToLinks                  : TOldCefState read FTabToLinks                   write FTabToLinks                  default STATE_DEFAULT;
      property LocalStorage                : TOldCefState read FLocalStorage                 write FLocalStorage                default STATE_DEFAULT;
      property Databases                   : TOldCefState read FDatabases                    write FDatabases                   default STATE_DEFAULT;
      property ApplicationCache            : TOldCefState read FApplicationCache             write FApplicationCache            default STATE_DEFAULT;
      property Webgl                       : TOldCefState read FWebgl                        write FWebgl                       default STATE_DEFAULT;
      property BackgroundColor             : TOldCefColor read FBackgroundColor              write FBackgroundColor             default 0;
      property AcceptLanguageList          : oldustring   read FAcceptLanguageList           write FAcceptLanguageList;
      property WindowlessFrameRate         : Integer   read FWindowlessFrameRate          write FWindowlessFrameRate         default 30;
  end;

implementation

constructor TOldChromiumOptions.Create;
begin
  FWindowlessFrameRate         := 30;
  FJavascript                  := STATE_DEFAULT;
  FJavascriptOpenWindows       := STATE_DEFAULT;
  FJavascriptCloseWindows      := STATE_DEFAULT;
  FJavascriptAccessClipboard   := STATE_DEFAULT;
  FJavascriptDomPaste          := STATE_DEFAULT;
  FCaretBrowsing               := STATE_DEFAULT;
  FPlugins                     := STATE_DEFAULT;
  FUniversalAccessFromFileUrls := STATE_DEFAULT;
  FFileAccessFromFileUrls      := STATE_DEFAULT;
  FWebSecurity                 := STATE_DEFAULT;
  FImageLoading                := STATE_DEFAULT;
  FImageShrinkStandaloneToFit  := STATE_DEFAULT;
  FTextAreaResize              := STATE_DEFAULT;
  FTabToLinks                  := STATE_DEFAULT;
  FLocalStorage                := STATE_DEFAULT;
  FDatabases                   := STATE_DEFAULT;
  FApplicationCache            := STATE_DEFAULT;
  FWebgl                       := STATE_DEFAULT;
  FBackgroundColor             := 0;
end;

end.
