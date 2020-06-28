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

unit oldCEFDeleteCookiesCallback;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefDeleteCookiesCallbackOwn = class(TOldCefBaseOwn, IOldCefDeleteCookiesCallback)
    protected
      procedure OnComplete(numDeleted: Integer); virtual; abstract;

    public
      constructor Create; virtual;
  end;

  TOldCefFastDeleteCookiesCallback = class(TOldCefDeleteCookiesCallbackOwn)
    protected
      FCallback: TOldCefDeleteCookiesCallbackProc;

      procedure OnComplete(numDeleted: Integer); override;

    public
      constructor Create(const callback: TOldCefDeleteCookiesCallbackProc); reintroduce;
      destructor  Destroy; override;
  end;

  TOldCefCustomDeleteCookiesCallback = class(TOldCefDeleteCookiesCallbackOwn)
    protected
      FEvents : Pointer;

      procedure OnComplete(numDeleted: Integer); override;

    public
      constructor Create(const aEvents : IOldChromiumEvents); reintroduce;
      destructor  Destroy; override;
  end;

implementation

uses
  {$IFDEF DELPHI16_UP}
  System.SysUtils,
  {$ELSE}
  SysUtils,
  {$ENDIF}
  oldCEFMiscFunctions, oldCEFLibFunctions;

procedure cef_delete_cookie_callback_on_complete(self: POldCefDeleteCookiesCallback; num_deleted: Integer); stdcall;
var
  TempObject  : TObject;
begin
  TempObject  := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefDeleteCookiesCallbackOwn) then
    TOldCefDeleteCookiesCallbackOwn(TempObject).OnComplete(num_deleted);
end;

// TOldCefDeleteCookiesCallbackOwn

constructor TOldCefDeleteCookiesCallbackOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefDeleteCookiesCallback));

  POldCefDeleteCookiesCallback(FData).on_complete := cef_delete_cookie_callback_on_complete;
end;

// TOldCefFastDeleteCookiesCallback

constructor TOldCefFastDeleteCookiesCallback.Create(const callback: TOldCefDeleteCookiesCallbackProc);
begin
  inherited Create;

  FCallback := callback;
end;

procedure TOldCefFastDeleteCookiesCallback.OnComplete(numDeleted: Integer);
begin
  if assigned(FCallback) then FCallback(numDeleted)
end;

destructor TOldCefFastDeleteCookiesCallback.Destroy;
begin
  FCallback := nil;

  inherited Destroy;
end;

// TOldCefCustomDeleteCookiesCallback

constructor TOldCefCustomDeleteCookiesCallback.Create(const aEvents : IOldChromiumEvents);
begin
  inherited Create;

  FEvents := Pointer(aEvents);
end;

destructor TOldCefCustomDeleteCookiesCallback.Destroy;
begin
  FEvents := nil;

  inherited Destroy;
end;

procedure TOldCefCustomDeleteCookiesCallback.OnComplete(numDeleted: Integer);
begin
  try
    try
      if (FEvents <> nil) then IOldChromiumEvents(FEvents).doCookiesDeleted(numDeleted);
    except
      on e : exception do
        if CustomExceptionHandler('TOldCefCustomDeleteCookiesCallback.OnComplete', e) then raise;
    end;
  finally
    FEvents := nil;
  end;
end;

end.
