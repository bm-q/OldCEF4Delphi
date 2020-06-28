// ************************************************************************
// ***************************** CEF4Delphi *******************************
// ************************************************************************
//
// CEF4Delphi is based on DCEF3 which uses CEF3 to embed a chromium-based
// browser in Delphi applications.
//
// The original license of DCEF3 still applies to CEF4Delphi.
//
// For more information about CEF4Delphi visit :
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

unit uExternalPumpBrowser;

{$I oldcef.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  {$ELSE}
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
  {$ENDIF}
  oldCEFChromium, oldCEFWindowParent, oldCEFTypes, oldCEFConstants, oldCEFInterfaces, oldCEFWorkScheduler;

type
  TExternalPumpBrowserFrm = class(TForm)
    AddressPnl: TPanel;
    GoBtn: TButton;
    Timer1: TTimer;
    CEFWindowParent1: TOldCefWindowParent;
    Chromium1: TOldChromium;
    URLCbx: TComboBox;

    procedure GoBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);

    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);

    procedure Chromium1AfterCreated(Sender: TObject; const browser: IOldCefBrowser);
    procedure Chromium1Close(Sender: TObject; const browser: IOldCefBrowser; var aAction : TOldCefCloseBrowserAction);
    procedure Chromium1BeforeClose(Sender: TObject; const browser: IOldCefBrowser);
    procedure Chromium1BeforePopup(Sender: TObject;
      const browser: IOldCefBrowser; const frame: IOldCefFrame; const targetUrl,
      targetFrameName: oldustring;
      targetDisposition: TOldCefWindowOpenDisposition; userGesture: Boolean;
      const popupFeatures: TOldCefPopupFeatures; var windowInfo: TOldCefWindowInfo;
      var client: IOldCefClient; var settings: TOldCefBrowserSettings;
      var noJavascriptAccess: Boolean; var Result: Boolean);

  private
    FCanClose : boolean;
    FClosing  : boolean;

    procedure BrowserCreatedMsg(var aMessage : TMessage); message CEF_AFTERCREATED;
    procedure BrowserDestroyMsg(var aMessage : TMessage); message CEF_DESTROY;
    procedure WMMove(var aMessage : TWMMove); message WM_MOVE;
    procedure WMMoving(var aMessage : TMessage); message WM_MOVING;
    procedure WMEnterMenuLoop(var aMessage: TMessage); message WM_ENTERMENULOOP;
    procedure WMExitMenuLoop(var aMessage: TMessage); message WM_EXITMENULOOP;

  public

  end;

var
  ExternalPumpBrowserFrm : TExternalPumpBrowserFrm;

implementation

{$R *.dfm}

uses
  oldCEFApplication;

// This demo has a simple browser with a TOldChromium + TOldCefWindowParent combination
// It was necessary to destroy the browser following the destruction sequence described in the MDIBrowser demo.

procedure TExternalPumpBrowserFrm.FormCreate(Sender: TObject);
begin
  FCanClose := False;
  FClosing  := False;
end;

procedure TExternalPumpBrowserFrm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := FCanClose;

  if not(FClosing) then
    begin
      FClosing           := True;
      Visible            := False;
      AddressPnl.Enabled := False;
      Chromium1.CloseBrowser(True);
    end;
end;

procedure TExternalPumpBrowserFrm.FormShow(Sender: TObject);
begin
  // GlobalOldCEFApp.GlobalContextInitialized has to be TRUE before creating any browser
  // If it's not initialized yet, we use a simple timer to create the browser later.
  if not(Chromium1.CreateBrowser(CEFWindowParent1, '')) then Timer1.Enabled := True;
end;

procedure TExternalPumpBrowserFrm.Chromium1AfterCreated(Sender: TObject; const browser: IOldCefBrowser);
begin
  PostMessage(Handle, CEF_AFTERCREATED, 0, 0);
end;

procedure TExternalPumpBrowserFrm.Chromium1BeforeClose(Sender: TObject; const browser: IOldCefBrowser);
begin
  FCanClose := True;
  PostMessage(Handle, WM_CLOSE, 0, 0);
end;

procedure TExternalPumpBrowserFrm.Chromium1BeforePopup(Sender: TObject;
  const browser: IOldCefBrowser; const frame: IOldCefFrame; const targetUrl,
  targetFrameName: oldustring; targetDisposition: TOldCefWindowOpenDisposition;
  userGesture: Boolean; const popupFeatures: TOldCefPopupFeatures;
  var windowInfo: TOldCefWindowInfo; var client: IOldCefClient;
  var settings: TOldCefBrowserSettings; var noJavascriptAccess: Boolean;
  var Result: Boolean);
begin
  // For simplicity, this demo blocks all popup windows and new tabs
  Result := (targetDisposition in [WOD_NEW_FOREGROUND_TAB, WOD_NEW_BACKGROUND_TAB, WOD_NEW_POPUP, WOD_NEW_WINDOW]);
end;

procedure TExternalPumpBrowserFrm.Chromium1Close(Sender: TObject; const browser: IOldCefBrowser; var aAction : TOldCefCloseBrowserAction);
begin
  PostMessage(Handle, CEF_DESTROY, 0, 0);
  aAction := cbaDelay;
end;

procedure TExternalPumpBrowserFrm.BrowserCreatedMsg(var aMessage : TMessage);
begin
  Caption            := 'External Pump Browser';
  CEFWindowParent1.UpdateSize;
  AddressPnl.Enabled := True;
  GoBtn.Click;
end;

procedure TExternalPumpBrowserFrm.BrowserDestroyMsg(var aMessage : TMessage);
begin
  CEFWindowParent1.Free;
end;

procedure TExternalPumpBrowserFrm.GoBtnClick(Sender: TObject);
begin
  Chromium1.LoadURL(URLCbx.Text);
end;

procedure TExternalPumpBrowserFrm.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  if not(Chromium1.CreateBrowser(CEFWindowParent1, '')) and not(Chromium1.Initialized) then
    Timer1.Enabled := True;
end;

procedure TExternalPumpBrowserFrm.WMMove(var aMessage : TWMMove);
begin
  inherited;

  if (Chromium1 <> nil) then Chromium1.NotifyMoveOrResizeStarted;
end;

procedure TExternalPumpBrowserFrm.WMMoving(var aMessage : TMessage);
begin
  inherited;

  if (Chromium1 <> nil) then Chromium1.NotifyMoveOrResizeStarted;
end;

procedure TExternalPumpBrowserFrm.WMEnterMenuLoop(var aMessage: TMessage);
begin
  inherited;

  if (aMessage.wParam = 0) and (GlobalOldCEFApp <> nil) then GlobalOldCEFApp.OsmodalLoop := True;
end;

procedure TExternalPumpBrowserFrm.WMExitMenuLoop(var aMessage: TMessage);
begin
  inherited;

  if (aMessage.wParam = 0) and (GlobalOldCEFApp <> nil) then GlobalOldCEFApp.OsmodalLoop := False;
end;

end.
