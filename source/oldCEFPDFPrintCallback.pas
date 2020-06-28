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

unit oldCEFPDFPrintCallback;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefPdfPrintCallbackOwn = class(TOldCefBaseOwn, IOldCefPdfPrintCallback)
    protected
      procedure OnPdfPrintFinished(const path: oldustring; ok: Boolean); virtual; abstract;

    public
      constructor Create; virtual;
  end;

  TOldCefFastPdfPrintCallback = class(TOldCefPdfPrintCallbackOwn)
    protected
      FProc: TOnPdfPrintFinishedProc;

      procedure OnPdfPrintFinished(const path: oldustring; ok: Boolean); override;

    public
      constructor Create(const proc: TOnPdfPrintFinishedProc); reintroduce;
      destructor  Destroy; override;
  end;

  TOldCefCustomPDFPrintCallBack = class(TOldCefPdfPrintCallbackOwn)
    protected
      FEvents : Pointer;

      procedure OnPdfPrintFinished(const path: oldustring; aResultOK : Boolean); override;

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

procedure cef_pdf_print_callback_on_pdf_print_finished(      self : POldCefPdfPrintCallback;
                                                       const path : POldCefString;
                                                             ok   : Integer); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefPdfPrintCallbackOwn) then
    TOldCefPdfPrintCallbackOwn(TempObject).OnPdfPrintFinished(CefString(path),
                                                           ok <> 0);
end;

constructor TOldCefPdfPrintCallbackOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefPdfPrintCallback));

  POldCefPdfPrintCallback(FData).on_pdf_print_finished := cef_pdf_print_callback_on_pdf_print_finished;
end;

// TOldCefFastPdfPrintCallback

constructor TOldCefFastPdfPrintCallback.Create(const proc: TOnPdfPrintFinishedProc);
begin
  FProc := proc;

  inherited Create;
end;

procedure TOldCefFastPdfPrintCallback.OnPdfPrintFinished(const path: oldustring; ok: Boolean);
begin
  if assigned(FProc) then FProc(path, ok);
end;

destructor TOldCefFastPdfPrintCallback.Destroy;
begin
  FProc := nil;

  inherited Destroy;
end;

// TOldCefCustomPDFPrintCallBack

constructor TOldCefCustomPDFPrintCallBack.Create(const aEvents : IOldChromiumEvents);
begin
  inherited Create;

  FEvents := Pointer(aEvents);
end;

destructor TOldCefCustomPDFPrintCallBack.Destroy;
begin
  FEvents := nil;

  inherited Destroy;
end;

procedure TOldCefCustomPDFPrintCallBack.OnPdfPrintFinished(const path: oldustring; aResultOK : Boolean);
begin
  try
    try
      if (FEvents <> nil) then IOldChromiumEvents(FEvents).doPdfPrintFinished(aResultOK);
    except
      on e : exception do
        if CustomExceptionHandler('TOldCefCustomPDFPrintCallBack.OnPdfPrintFinished', e) then raise;
    end;
  finally
    FEvents := nil;
  end;
end;

end.
