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

unit oldCEFResolveCallback;

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
  TOldCefResolveCallbackOwn = class(TOldCefBaseOwn, IOldCefResolveCallback)
    protected
      procedure OnResolveCompleted(result: TOldCefErrorCode; const resolvedIps: TStrings); virtual; abstract;

    public
      constructor Create; virtual;
  end;

  TOldCefCustomResolveCallback = class(TOldCefResolveCallbackOwn)
    protected
      FEvents : Pointer;

      procedure OnResolveCompleted(result: TOldCefErrorCode; const resolvedIps: TStrings); override;

    public
      constructor Create(const aEvents : IOldChromiumEvents); reintroduce;
      destructor  Destroy; override;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFStringList;

procedure cef_resolve_callback_on_resolve_completed(self         : POldCefResolveCallback;
                                                    result       : TOldCefErrorCode;
                                                    resolved_ips : TOldCefStringList); stdcall;
var
  TempSL     : TStringList;
  TemPOldCefSL  : IOldCefStringList;
  TempObject : TObject;
begin
  TempSL := nil;

  try
    try
      TempObject := CefGetObject(self);

      if (TempObject <> nil) and (TempObject is TOldCefResolveCallbackOwn) then
        begin
          TempSL    := TStringList.Create;
          TemPOldCefSL := TOldCefStringListRef.Create(resolved_ips);
          TemPOldCefSL.CopyToStrings(TempSL);

          TOldCefResolveCallbackOwn(TempObject).OnResolveCompleted(result, TempSL);
        end;
    except
      on e : exception do
        if CustomExceptionHandler('cef_resolve_callback_on_resolve_completed', e) then raise;
    end;
  finally
    if (TempSL <> nil) then FreeAndNil(TempSL);
  end;
end;

// TOldCefResolveCallbackOwn

constructor TOldCefResolveCallbackOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefResolveCallback));

  POldCefResolveCallback(FData).on_resolve_completed := cef_resolve_callback_on_resolve_completed;
end;

// TOldCefCustomResolveCallback

constructor TOldCefCustomResolveCallback.Create(const aEvents : IOldChromiumEvents);
begin
  inherited Create;

  FEvents := Pointer(aEvents);
end;

destructor TOldCefCustomResolveCallback.Destroy;
begin
  FEvents := nil;

  inherited Destroy;
end;

procedure TOldCefCustomResolveCallback.OnResolveCompleted(result: TOldCefErrorCode; const resolvedIps: TStrings);
begin
  try
    try
      if (FEvents <> nil) then IOldChromiumEvents(FEvents).doResolvedHostAvailable(result, resolvedIps);
    except
      on e : exception do
        if CustomExceptionHandler('TOldCefCustomResolveCallback.OnResolveCompleted', e) then raise;
    end;
  finally
    FEvents := nil;
  end;
end;

end.
