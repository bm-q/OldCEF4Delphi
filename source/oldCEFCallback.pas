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

unit oldCEFCallback;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefCallbackRef = class(TOldCefBaseRef, IOldCefCallback)
    protected
      procedure Cont;
      procedure Cancel;

    public
      class function UnWrap(data: Pointer): IOldCefCallback;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions;

procedure TOldCefCallbackRef.Cancel;
begin
  POldCefCallback(FData)^.cancel(POldCefCallback(FData));
end;

procedure TOldCefCallbackRef.Cont;
begin
  POldCefCallback(FData)^.cont(POldCefCallback(FData));
end;

class function TOldCefCallbackRef.UnWrap(data: Pointer): IOldCefCallback;
begin
  if (data <> nil) then
    Result := Create(data) as IOldCefCallback
   else
    Result := nil;
end;

end.