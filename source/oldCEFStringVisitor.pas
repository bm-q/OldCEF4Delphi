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

unit oldCEFStringVisitor;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  oldCEFBase, oldCEFInterfaces, oldCEFTypes;

type
  TOldCefStringVisitorOwn = class(TOldCefBaseOwn, IOldCefStringVisitor)
    protected
      procedure Visit(const str: oldustring); virtual;

    public
      constructor Create; virtual;
  end;

  TOldCefFastStringVisitor = class(TOldCefStringVisitorOwn)
    protected
      FVisit: TOldCefStringVisitorProc;

      procedure Visit(const str: oldustring); override;

    public
      constructor Create(const callback: TOldCefStringVisitorProc); reintroduce;
  end;

  TOldCustomCefStringVisitor = class(TOldCefStringVisitorOwn)
    protected
      FEvents : Pointer;

      procedure Visit(const str: oldustring); override;

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

procedure cef_string_visitor_visit(      self : POldCefStringVisitor;
                                   const str  : POldCefString); stdcall;
var
  TempObject : TObject;
begin
  TempObject := CefGetObject(self);

  if (TempObject <> nil) and (TempObject is TOldCefStringVisitorOwn) then
    TOldCefStringVisitorOwn(TempObject).Visit(CefString(str));
end;

// TOldCefStringVisitorOwn

constructor TOldCefStringVisitorOwn.Create;
begin
  inherited CreateData(SizeOf(TOldCefStringVisitor));

  with POldCefStringVisitor(FData)^ do visit := cef_string_visitor_visit;
end;

procedure TOldCefStringVisitorOwn.Visit(const str: oldustring);
begin
  //
end;

// TOldCefFastStringVisitor

constructor TOldCefFastStringVisitor.Create(const callback: TOldCefStringVisitorProc);
begin
  inherited Create;

  FVisit := callback;
end;

procedure TOldCefFastStringVisitor.Visit(const str: oldustring);
begin
  FVisit(str);
end;

// TCustomCefStringVisitor

constructor TOldCustomCefStringVisitor.Create(const aEvents : IOldChromiumEvents);
begin
  inherited Create;

  FEvents := Pointer(aEvents);
end;

destructor TOldCustomCefStringVisitor.Destroy;
begin
  FEvents := nil;

  inherited Destroy;
end;

procedure TOldCustomCefStringVisitor.Visit(const str: oldustring);
begin
  try
    try
      if (FEvents <> nil) then IOldChromiumEvents(FEvents).doTextResultAvailable(str);
    except
      on e : exception do
        if CustomExceptionHandler('TCustomCefStringVisitor.Visit', e) then raise;
    end;
  finally
    FEvents := nil;
  end;
end;

end.
