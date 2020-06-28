// ************************************************************************
// ***************************** OldCEF4Delphi ****************************
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

unit oldCEFWebPluginUnstableCallback;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefWebPluginIsUnstableProc = {$IFDEF DELPHI12_UP}reference to{$ENDIF} procedure(const path: oldustring; unstable: Boolean);

  TOldCefWebPluginUnstableCallbackOwn = class(TOldCefBaseOwn, IOldCefWebPluginUnstableCallback)
    protected
      procedure IsUnstable(const path: oldustring; unstable: Boolean); virtual;

    public
      constructor Create; virtual;
  end;

  TOldCefFastWebPluginUnstableCallback = class(TOldCefWebPluginUnstableCallbackOwn)
    protected
      FCallback: TOldCefWebPluginIsUnstableProc;
      procedure IsUnstable(const path: oldustring; unstable: Boolean); override;

    public
      constructor Create(const callback: TOldCefWebPluginIsUnstableProc); reintroduce;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions;

procedure cef_web_plugin_unstable_callback_is_unstable(self: POldCefWebPluginUnstableCallback;
                                                       const path: POldCefString;
                                                       unstable: Integer); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefWebPluginUnstableCallbackOwn) then
    TOldCefWebPluginUnstableCallbackOwn(TempObject).IsUnstable(CefString(path),
                                                            unstable <> 0);
end;

// TOldCefWebPluginUnstableCallbackOwn

constructor TOldCefWebPluginUnstableCallbackOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefWebPluginUnstableCallback));

  POldCefWebPluginUnstableCallback(FData).is_unstable := cef_web_plugin_unstable_callback_is_unstable;
end;

procedure TOldCefWebPluginUnstableCallbackOwn.IsUnstable(const path: oldustring; unstable: Boolean);
begin
  //
end;

// TOldCefFastWebPluginUnstableCallback

constructor TOldCefFastWebPluginUnstableCallback.Create(const callback: TOldCefWebPluginIsUnstableProc);
begin
  inherited Create;

  FCallback := callback;
end;

procedure TOldCefFastWebPluginUnstableCallback.IsUnstable(const path: oldustring; unstable: Boolean);
begin
  FCallback(path, unstable);
end;


end.
