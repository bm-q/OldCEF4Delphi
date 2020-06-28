// ************************************************************************
// ***************************** CEF4Delphi *******************************
// ************************************************************************
//
// CEF4Delphi is based on DCEF3 which uses CEF3 to embed a chromium-based
// browser in Delphi applications.
//
// The original license of DCEF3 still applies to CEF4Delphi.
//
// For more information about CEF4Delphi visit :
//         https://www.briskbard.com/index.php?lang=en&pageid=cef
//
//        Copyright � 2018 Salvador D�az Fau. All rights reserved.
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

program OSRSubProcess;

{$I cef.inc}

uses
  {$IFDEF DELPHI16_UP}
  WinApi.Windows,
  {$ELSE}
  Windows,
  {$ENDIF}
  oldCefApplication,
  oldCefConstants;

// CEF3 needs to set the LARGEADDRESSAWARE flag which allows 32-bit processes to use up to 3GB of RAM.
{$SetPEFlags IMAGE_FILE_LARGE_ADDRESS_AWARE}

// To test this demo you need to build the ConsoleLoader, OSRDLLBrowser and OSRSubProcess projects found in this directory.

begin
  GlobalOldCEFApp := TOldCefApplication.Create;

  // The main process and the subprocess *MUST* have the same FrameworkDirPath, ResourcesDirPath,
  // LocalesDirPath, cache, cookies and UserDataPath paths

  // The demos are compiled into the BIN directory. Make sure SubProcess.exe and SimpleBrowser.exe are in that
  // directory or this demo won't work.

  // In case you want to use custom directories for the CEF3 binaries, cache, cookies and user data.
{
  GlobalOldCEFApp.FrameworkDirPath     := 'cef';
  GlobalOldCEFApp.ResourcesDirPath     := 'cef';
  GlobalOldCEFApp.LocalesDirPath       := 'cef\locales';
  GlobalOldCEFApp.cache                := 'cef\cache';
  GlobalOldCEFApp.cookies              := 'cef\cookies';
  GlobalOldCEFApp.UserDataPath         := 'cef\User Data';
  GlobalOldCEFApp.LogFile              := 'debug.log';
  GlobalOldCEFApp.LogSeverity          := LOGSEVERITY_INFO;
}

  GlobalOldCEFApp.WindowlessRenderingEnabled := True;
  GlobalOldCEFApp.EnableHighDPISupport       := True;
  GlobalOldCEFApp.SetCurrentDir              := True;
  GlobalOldCEFApp.MultiThreadedMessageLoop   := False;

  GlobalOldCEFApp.StartSubProcess;
  GlobalOldCEFApp.Free;
  GlobalOldCEFApp := nil;
end.

