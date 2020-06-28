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

unit oldCEFChromiumWindow;

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

{$I oldcef.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
  {$IFDEF MSWINDOWS}WinApi.Windows, WinApi.Messages,{$ENDIF} System.Classes,
  {$ELSE}
  Windows, Messages, Classes,
  {$ENDIF}
  oldCEFWindowParent, oldCEFChromium, oldCEFInterfaces, oldCEFTypes, oldCEFConstants;

type
  {$IFNDEF FPC}{$IFDEF DELPHI16_UP}[ComponentPlatformsAttribute(pidWin32 or pidWin64)]{$ENDIF}{$ENDIF}
  TOldChromiumWindow = class(TOldCEFWindowParent)
    protected
      FChromium       : TOldChromium;
      FOnClose        : TNotifyEvent;
      FOnBeforeClose  : TNotifyEvent;
      FOnAfterCreated : TNotifyEvent;

      function    GetChildWindowHandle : THandle; override;
      function    GetBrowserInitialized : boolean;

      procedure   OnCloseMsg(var aMessage : TMessage); message CEF_DOONCLOSE;
      procedure   OnAfterCreatedMsg(var aMessage : TMessage); message CEF_AFTERCREATED;

      procedure   WebBrowser_OnClose(Sender: TObject; const browser: IOldCefBrowser; var aAction : TOldCefCloseBrowserAction);
      procedure   WebBrowser_OnBeforeClose(Sender: TObject; const browser: IOldCefBrowser);
      procedure   WebBrowser_OnAfterCreated(Sender: TObject; const browser: IOldCefBrowser);

   public
      constructor Create(AOwner: TComponent); override;
      procedure   AfterConstruction; override;
      function    CreateBrowser : boolean;
      procedure   CloseBrowser(aForceClose : boolean);
      procedure   LoadURL(const aURL : string);
      procedure   NotifyMoveOrResizeStarted;

      property ChromiumBrowser    : TOldChromium       read FChromium;
      property Initialized        : boolean         read GetBrowserInitialized;

    published
      property OnClose          : TNotifyEvent    read FOnClose          write FOnClose;
      property OnBeforeClose    : TNotifyEvent    read FOnBeforeClose    write FOnBeforeClose;
      property OnAfterCreated   : TNotifyEvent    read FOnAfterCreated   write FOnAfterCreated;
  end;

implementation

uses
  {$IFDEF DELPHI16_UP}
  System.SysUtils;
  {$ELSE}
  SysUtils;
  {$ENDIF}

constructor TOldChromiumWindow.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FChromium       := nil;
  FOnClose        := nil;
  FOnBeforeClose  := nil;
  FOnAfterCreated := nil;
end;

procedure TOldChromiumWindow.AfterConstruction;
begin
  inherited AfterConstruction;

  if not(csDesigning in ComponentState) then
    begin
      FChromium                := TOldChromium.Create(self);
      FChromium.OnClose        := WebBrowser_OnClose;
      FChromium.OnBeforeClose  := WebBrowser_OnBeforeClose;
      FChromium.OnAfterCreated := WebBrowser_OnAfterCreated;
    end;
end;

function TOldChromiumWindow.GetChildWindowHandle : THandle;
begin
  Result := 0;

  if (FChromium <> nil) then Result := FChromium.WindowHandle;

  if (Result = 0) then Result := inherited GetChildWindowHandle;
end;

function TOldChromiumWindow.GetBrowserInitialized : boolean;
begin
  Result := (FChromium <> nil) and FChromium.Initialized;
end;

procedure TOldChromiumWindow.WebBrowser_OnClose(Sender: TObject; const browser: IOldCefBrowser; var aAction : TOldCefCloseBrowserAction);
begin
  aAction := cbaClose;

  if assigned(FOnClose) then
    begin
      PostMessage(Handle, CEF_DOONCLOSE, 0, 0);
      aAction := cbaDelay;
    end;
end;

procedure TOldChromiumWindow.WebBrowser_OnBeforeClose(Sender: TObject; const browser: IOldCefBrowser);
begin
  if assigned(FOnBeforeClose) then FOnBeforeClose(self);
end;

procedure TOldChromiumWindow.WebBrowser_OnAfterCreated(Sender: TObject; const browser: IOldCefBrowser);
begin
  PostMessage(Handle, CEF_AFTERCREATED, 0, 0);
end;

procedure TOldChromiumWindow.OnCloseMsg(var aMessage : TMessage);
begin
  if assigned(FOnClose) then FOnClose(self);
end;

procedure TOldChromiumWindow.OnAfterCreatedMsg(var aMessage : TMessage);
begin
  UpdateSize;
  if assigned(FOnAfterCreated) then FOnAfterCreated(self);
end;

function TOldChromiumWindow.CreateBrowser : boolean;
begin
  Result := not(csDesigning in ComponentState) and
            (FChromium <> nil) and
            FChromium.CreateBrowser(self, '');
end;

procedure TOldChromiumWindow.CloseBrowser(aForceClose : boolean);
begin
  if (FChromium <> nil) then FChromium.CloseBrowser(aForceClose);
end;

procedure TOldChromiumWindow.LoadURL(const aURL : string);
begin
  if not(csDesigning in ComponentState) and (FChromium <> nil) then
    FChromium.LoadURL(aURL);
end;

procedure TOldChromiumWindow.NotifyMoveOrResizeStarted;
begin
  if (FChromium <> nil) then FChromium.NotifyMoveOrResizeStarted;
end;

end.
