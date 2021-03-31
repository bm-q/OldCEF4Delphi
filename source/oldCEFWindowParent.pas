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

unit oldCEFWindowParent;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
  {$IFDEF MSWINDOWS}WinApi.Windows, WinApi.Messages, Vcl.Controls, Vcl.Graphics,{$ENDIF} System.Classes,
  {$ELSE}
  Windows, Messages, Classes, Controls, Graphics,
  {$ENDIF}
  oldCEFTypes, oldCEFInterfaces;

type
  {$IFNDEF FPC}{$IFDEF DELPHI16_UP}[ComponentPlatformsAttribute(pidWin32 or pidWin64)]{$ENDIF}{$ENDIF}
  TOldCEFWindowParent = class(TWinControl)
    protected
      function  GetChildWindowHandle : THandle; virtual;

      procedure WndProc(var aMessage: TMessage); override;

    public
      procedure UpdateSize;
      function  TakeSnapshot(var aBitmap : TBitmap) : boolean;
      function  DestroyChildWindow : boolean;
      procedure CreateHandle; override;
      procedure InvalidateChildren;
      procedure Resize; override;

      property  ChildWindowHandle : THandle   read GetChildWindowHandle;

    published
      property  Align;
      property  Anchors;
      property  Color;
      property  Constraints;
      property  TabStop;
      property  TabOrder;
      property  Visible;
      property  Enabled;
      property  ShowHint;
      property  Hint;
      property  DoubleBuffered;
      {$IFDEF DELPHI12_UP}
      property  ParentDoubleBuffered;
      {$ENDIF}
  end;

implementation

uses
  oldCEFMiscFunctions, oldCEFClient, oldCEFConstants;

function TOldCEFWindowParent.GetChildWindowHandle : THandle;
begin
  Result := GetWindow(Handle, GW_CHILD);
end;

procedure TOldCEFWindowParent.Resize;
begin
  inherited Resize;

  UpdateSize;
end;

procedure TOldCEFWindowParent.CreateHandle;
begin
  inherited;
end;

procedure TOldCEFWindowParent.InvalidateChildren;
begin
  if HandleAllocated then RedrawWindow(Handle, nil, 0, RDW_INVALIDATE or RDW_ALLCHILDREN);
end;

procedure TOldCEFWindowParent.UpdateSize;
var
  TempRect : TRect;
  hdwp: THandle;
  TempHandle : THandle;
begin
  TempHandle := ChildWindowHandle;
  if (TempHandle = 0) then Exit;

  TempRect := GetClientRect;
  hdwp     := BeginDeferWindowPos(1);

  try
    hdwp := DeferWindowPos(hdwp, TempHandle, HWND_TOP,
                           TempRect.left, TempRect.top, TempRect.right - TempRect.left, TempRect.bottom - TempRect.top,
                           SWP_NOZORDER);
  finally
    EndDeferWindowPos(hdwp);
  end;
end;

procedure TOldCEFWindowParent.WndProc(var aMessage: TMessage);
var
  TempHandle : THandle;
begin
  case aMessage.Msg of
    WM_SETFOCUS:
      begin
        TempHandle := ChildWindowHandle;
        if (TempHandle <> 0) then PostMessage(TempHandle, WM_SETFOCUS, aMessage.WParam, 0);
        inherited WndProc(aMessage);
      end;

    WM_ERASEBKGND:
      begin
        TempHandle := ChildWindowHandle;
        if (csDesigning in ComponentState) or (TempHandle = 0) then inherited WndProc(aMessage);
      end;

    CM_WANTSPECIALKEY:
      if not(TWMKey(aMessage).CharCode in [VK_LEFT .. VK_DOWN, VK_RETURN, VK_ESCAPE]) then
        aMessage.Result := 1
       else
        inherited WndProc(aMessage);

    WM_GETDLGCODE : aMessage.Result := DLGC_WANTARROWS or DLGC_WANTCHARS;

    else inherited WndProc(aMessage);
  end;
end;

function TOldCEFWindowParent.TakeSnapshot(var aBitmap : TBitmap) : boolean;
var
  TempHWND   : HWND;
  TempDC     : HDC;
  TempRect   : TRect;
  TempWidth  : Integer;
  TempHeight : Integer;
begin
  Result   := False;
  TempHWND := ChildWindowHandle;

  if (TempHWND <> 0) then
    begin
      {$IFDEF DELPHI16_UP}Winapi.{$ENDIF}Windows.GetClientRect(TempHWND, TempRect);
      TempDC     := GetDC(TempHWND);
      TempWidth  := TempRect.Right  - TempRect.Left;
      TempHeight := TempRect.Bottom - TempRect.Top;

      aBitmap        := TBitmap.Create;
      aBitmap.Height := TempHeight;
      aBitmap.Width  := TempWidth;

      Result := BitBlt(aBitmap.Canvas.Handle, 0, 0, TempWidth, TempHeight,
                       TempDC, 0, 0, SRCCOPY);

      ReleaseDC(TempHWND, TempDC);
    end;
end;

function TOldCEFWindowParent.DestroyChildWindow : boolean;
var
  TempHWND : HWND;
begin
  TempHWND := ChildWindowHandle;
  Result   := (TempHWND <> 0) and DestroyWindow(TempHWND);
end;

end.