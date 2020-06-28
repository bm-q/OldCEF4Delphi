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

unit oldCEFCompletionCallback;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces;

type
  TOldCefCompletionCallbackOwn = class(TOldCefBaseOwn, IOldCefCompletionCallback)
    protected
      procedure OnComplete; virtual;

    public
      constructor Create; virtual;
  end;

  TOldCefFastCompletionCallback = class(TOldCefCompletionCallbackOwn)
    protected
      FProc: TOldCefCompletionCallbackProc;

      procedure OnComplete; override;

    public
      constructor Create(const proc: TOldCefCompletionCallbackProc); reintroduce;
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFLibFunctions, oldCEFTypes;

procedure cef_completion_callback_on_complete(self: POldCefCompletionCallback); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefCompletionCallbackOwn) then
    TOldCefCompletionCallbackOwn(TempObject).OnComplete;
end;

// TOldCefCompletionHandlerOwn

constructor TOldCefCompletionCallbackOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefCompletionCallback));

  POldCefCompletionCallback(FData).on_complete := cef_completion_callback_on_complete;
end;

procedure TOldCefCompletionCallbackOwn.OnComplete;
begin
  //
end;

// TOldCefFastCompletionHandler

constructor TOldCefFastCompletionCallback.Create(const proc: TOldCefCompletionCallbackProc);
begin
  inherited Create;

  FProc := proc;
end;

procedure TOldCefFastCompletionCallback.OnComplete;
begin
  FProc();
end;

end.
