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

unit oldCEFSetCookieCallback;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefSetCookieCallbackOwn = class(TOldCefBaseOwn, IOldCefSetCookieCallback)
    protected
      procedure OnComplete(success: Boolean); virtual; abstract;

    public
      constructor Create; virtual;
  end;

  TOldCefFastSetCookieCallback = class(TOldCefSetCookieCallbackOwn)
    protected
      FCallback: TOldCefSetCookieCallbackProc;

      procedure OnComplete(success: Boolean); override;

    public
      constructor Create(const callback: TOldCefSetCookieCallbackProc); reintroduce;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions;

procedure cef_set_cookie_callback_on_complete(self    : POldCefSetCookieCallback;
                                              success : Integer); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefSetCookieCallbackOwn) then
    TOldCefSetCookieCallbackOwn(TempObject).OnComplete(success <> 0);
end;

constructor TOldCefSetCookieCallbackOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefSetCookieCallback));

  POldCefSetCookieCallback(FData).on_complete := cef_set_cookie_callback_on_complete;
end;

// TOldCefFastSetCookieCallback

constructor TOldCefFastSetCookieCallback.Create(const callback: TOldCefSetCookieCallbackProc);
begin
  inherited Create;

  FCallback := callback;
end;

procedure TOldCefFastSetCookieCallback.OnComplete(success: Boolean);
begin
  FCallback(success);
end;

end.
