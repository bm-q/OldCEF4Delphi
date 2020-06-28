// ************************************************************************
// *************************** OldCEF4Delphi ******************************
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
//        Copyright � 2019 Salvador D�az Fau. All rights reserved.
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

unit OldCEF4Delphi_Register;

{$R chromium.dcr}

{$I oldcef.inc}

interface

procedure Register;

implementation

uses
  {$IFDEF DELPHI16_UP}
  System.Classes,
  {$ELSE}
  Classes,
  {$ENDIF}
  oldCEFChromium, oldCEFWindowParent, oldCEFChromiumWindow, oldBufferPanel,
  oldCEFWorkScheduler, oldCEFUrlRequestClientComponent;

procedure Register;
begin
  RegisterComponents('OldChromium', [TOldChromium, TOldCEFWindowParent, TOldChromiumWindow, TOldBufferPanel,
                                  TOldCEFWorkScheduler, TOldCEFUrlRequestClientComponent]);
end;

end.
