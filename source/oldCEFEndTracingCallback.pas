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

unit oldCEFEndTracingCallback;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefEndTracingCallbackProc = {$IFDEF DELPHI12_UP}reference to{$ENDIF} procedure(const tracingFile: oldustring);

  TOldCefEndTracingCallbackOwn = class(TOldCefBaseOwn, IOldCefEndTracingCallback)
    protected
      procedure OnEndTracingComplete(const tracingFile: oldustring); virtual;
    public
      constructor Create; virtual;
  end;

  TOldCefFastEndTracingCallback = class(TOldCefEndTracingCallbackOwn)
    protected
      FCallback: TOldCefEndTracingCallbackProc;
      procedure OnEndTracingComplete(const tracingFile: oldustring); override;
    public
      constructor Create(const callback: TOldCefEndTracingCallbackProc); reintroduce;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions;

// TOldCefEndTracingCallbackOwn

procedure cef_end_tracing_callback_on_end_tracing_complete(      self         : POldCefEndTracingCallback;
                                                           const tracing_file : POldCefString); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefEndTracingCallbackOwn) then
    TOldCefEndTracingCallbackOwn(TempObject).OnEndTracingComplete(CefString(tracing_file));
end;

constructor TOldCefEndTracingCallbackOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefEndTracingCallback));

  POldCefEndTracingCallback(FData).on_end_tracing_complete := cef_end_tracing_callback_on_end_tracing_complete;
end;

procedure TOldCefEndTracingCallbackOwn.OnEndTracingComplete(const tracingFile: oldustring);
begin
  //
end;

// TOldCefFastEndTracingCallback

constructor TOldCefFastEndTracingCallback.Create(const callback: TOldCefEndTracingCallbackProc);
begin
  inherited Create;

  FCallback := callback;
end;

procedure TOldCefFastEndTracingCallback.OnEndTracingComplete(const tracingFile: oldustring);
begin
  FCallback(tracingFile);
end;

end.
