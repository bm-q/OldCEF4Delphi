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

unit uSchemeRegistrationBrowser;

{$I oldcef.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Menus,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.Types, Vcl.ComCtrls, Vcl.ClipBrd,
  System.UITypes,
  {$ELSE}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Menus,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls, Types, ComCtrls, ClipBrd,
  {$ENDIF}
  oldCEFChromium, oldCEFWindowParent, oldCEFInterfaces, oldCEFApplication, oldCEFSchemeRegistrar,
  oldCEFTypes, oldCEFConstants;

const
  MINIBROWSER_CONTEXTMENU_REGSCHEME    = MENU_ID_USER_FIRST + 1;
  MINIBROWSER_CONTEXTMENU_CLEARFACT    = MENU_ID_USER_FIRST + 2;

type
  TSchemeRegistrationBrowserFrm = class(TForm)
    AddressBarPnl: TPanel;
    GoBtn: TButton;
    CEFWindowParent1: TOldCefWindowParent;
    Chromium1: TOldChromium;
    AddressCbx: TComboBox;
    Timer1: TTimer;
    procedure Chromium1AfterCreated(Sender: TObject;
      const browser: IOldCefBrowser);
    procedure Chromium1BeforeContextMenu(Sender: TObject;
      const browser: IOldCefBrowser; const frame: IOldCefFrame;
      const params: IOldCefContextMenuParams; const model: IOldCefMenuModel);
    procedure Chromium1ContextMenuCommand(Sender: TObject;
      const browser: IOldCefBrowser; const frame: IOldCefFrame;
      const params: IOldCefContextMenuParams; commandId: Integer;
      eventFlags: Cardinal; out Result: Boolean);
    procedure GoBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Chromium1BeforePopup(Sender: TObject;
      const browser: IOldCefBrowser; const frame: IOldCefFrame; const targetUrl,
      targetFrameName: oldustring;
      targetDisposition: TOldCefWindowOpenDisposition; userGesture: Boolean;
      const popupFeatures: TOldCefPopupFeatures; var windowInfo: TOldCefWindowInfo;
      var client: IOldCefClient; var settings: TOldCefBrowserSettings;
      var noJavascriptAccess: Boolean; var Result: Boolean);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Chromium1Close(Sender: TObject; const browser: IOldCefBrowser;
      var aAction : TOldCefCloseBrowserAction);
    procedure Chromium1BeforeClose(Sender: TObject;
      const browser: IOldCefBrowser);
  private
    { Private declarations }
  protected
    // Variables to control when can we destroy the form safely
    FCanClose : boolean;  // Set to True in TOldChromium.OnBeforeClose
    FClosing  : boolean;  // Set to True in the CloseQuery event.

    procedure BrowserCreatedMsg(var aMessage : TMessage); message CEF_AFTERCREATED;
    procedure BrowserDestroyMsg(var aMessage : TMessage); message CEF_DESTROY;
    procedure WMMove(var aMessage : TWMMove); message WM_MOVE;
    procedure WMMoving(var aMessage : TMessage); message WM_MOVING;
    procedure WMEnterMenuLoop(var aMessage: TMessage); message WM_ENTERMENULOOP;
    procedure WMExitMenuLoop(var aMessage: TMessage); message WM_EXITMENULOOP;
  public
    { Public declarations }
  end;

var
  SchemeRegistrationBrowserFrm: TSchemeRegistrationBrowserFrm;

procedure CreateGlobalOldCEFApp;

implementation

{$R *.dfm}

uses
  oldCEFSchemeHandlerFactory, oldCEFMiscFunctions, uHelloScheme;

// Destruction steps
// =================
// 1. FormCloseQuery sets CanClose to FALSE calls TOldChromium.CloseBrowser which triggers the TOldChromium.OnClose event.
// 2. TOldChromium.OnClose sends a CEFBROWSER_DESTROY message to destroy CEFWindowParent1 in the main thread, which triggers the TOldChromium.OnBeforeClose event.
// 3. TOldChromium.OnBeforeClose sets FCanClose := True and sends WM_CLOSE to the form.

procedure GlobalOldCEFApp_OnRegCustomSchemes(const registrar: IOldCefSchemeRegistrar);
begin
  registrar.AddCustomScheme('hello', True, True, False);
end;

procedure CreateGlobalOldCEFApp;
begin
  GlobalOldCEFApp                      := TOldCefApplication.Create;
  GlobalOldCEFApp.OnRegCustomSchemes   := GlobalOldCEFApp_OnRegCustomSchemes;
end;

procedure TSchemeRegistrationBrowserFrm.Chromium1AfterCreated(Sender: TObject; const browser: IOldCefBrowser);
begin
  PostMessage(Handle, CEF_AFTERCREATED, 0, 0);
end;

procedure TSchemeRegistrationBrowserFrm.Chromium1BeforeClose(
  Sender: TObject; const browser: IOldCefBrowser);
begin
  FCanClose := True;
  PostMessage(Handle, WM_CLOSE, 0, 0);
end;

procedure TSchemeRegistrationBrowserFrm.Chromium1BeforeContextMenu(
  Sender: TObject; const browser: IOldCefBrowser; const frame: IOldCefFrame;
  const params: IOldCefContextMenuParams; const model: IOldCefMenuModel);
begin
  model.AddItem(MINIBROWSER_CONTEXTMENU_REGSCHEME,   'Register scheme');
  model.AddItem(MINIBROWSER_CONTEXTMENU_CLEARFACT,   'Clear schemes');
end;

procedure TSchemeRegistrationBrowserFrm.Chromium1BeforePopup(
  Sender: TObject; const browser: IOldCefBrowser; const frame: IOldCefFrame;
  const targetUrl, targetFrameName: oldustring;
  targetDisposition: TOldCefWindowOpenDisposition; userGesture: Boolean;
  const popupFeatures: TOldCefPopupFeatures; var windowInfo: TOldCefWindowInfo;
  var client: IOldCefClient; var settings: TOldCefBrowserSettings;
  var noJavascriptAccess: Boolean; var Result: Boolean);
begin
  // For simplicity, this demo blocks all popup windows and new tabs
  Result := (targetDisposition in [WOD_NEW_FOREGROUND_TAB, WOD_NEW_BACKGROUND_TAB, WOD_NEW_POPUP, WOD_NEW_WINDOW]);
end;

procedure TSchemeRegistrationBrowserFrm.Chromium1Close(Sender: TObject;
  const browser: IOldCefBrowser; var aAction : TOldCefCloseBrowserAction);
begin
  PostMessage(Handle, CEF_DESTROY, 0, 0);
  aAction := cbaDelay;
end;

procedure TSchemeRegistrationBrowserFrm.Chromium1ContextMenuCommand(
  Sender: TObject; const browser: IOldCefBrowser; const frame: IOldCefFrame;
  const params: IOldCefContextMenuParams; commandId: Integer;
  eventFlags: Cardinal; out Result: Boolean);
var
  TempFactory: IOldCefSchemeHandlerFactory;
begin
  Result := False;

  case commandId of
    MINIBROWSER_CONTEXTMENU_REGSCHEME :
      if (browser <> nil) and
         (browser.host <> nil) and
         (browser.host.RequestContext <> nil) then
        begin
          // You can register the Scheme Handler Factory in the DPR file or later, for example in a context menu command.
          TempFactory := TOldCefSchemeHandlerFactoryOwn.Create(THelloScheme);
          if not(browser.host.RequestContext.RegisterSchemeHandlerFactory('hello', '', TempFactory)) then
            MessageDlg('RegisterSchemeHandlerFactory error !', mtError, [mbOk], 0);
        end;

    MINIBROWSER_CONTEXTMENU_CLEARFACT :
      if (browser <> nil) and
         (browser.host <> nil) and
         (browser.host.RequestContext <> nil) then
        begin
          if not(browser.host.RequestContext.ClearSchemeHandlerFactories) then
            MessageDlg('ClearSchemeHandlerFactories error !', mtError, [mbOk], 0);
        end;
  end;
end;

procedure TSchemeRegistrationBrowserFrm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := FCanClose;

  if not(FClosing) then
    begin
      FClosing := True;
      Visible  := False;
      Chromium1.CloseBrowser(True);
    end;
end;

procedure TSchemeRegistrationBrowserFrm.FormCreate(Sender: TObject);
begin
  // You can register the Scheme Handler Factory here or later, for example in a context menu command.
  CefRegisterSchemeHandlerFactory('hello', '', THelloScheme);
end;

procedure TSchemeRegistrationBrowserFrm.FormShow(Sender: TObject);
begin
  // GlobalOldCEFApp.GlobalContextInitialized has to be TRUE before creating any browser
  // If it's not initialized yet, we use a simple timer to create the browser later.
  if not(Chromium1.CreateBrowser(CEFWindowParent1, '')) then Timer1.Enabled := True;
end;

procedure TSchemeRegistrationBrowserFrm.GoBtnClick(Sender: TObject);
begin
  Chromium1.LoadURL(AddressCbx.Text);
end;

procedure TSchemeRegistrationBrowserFrm.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  if not(Chromium1.CreateBrowser(CEFWindowParent1, '')) and not(Chromium1.Initialized) then
    Timer1.Enabled := True;
end;

procedure TSchemeRegistrationBrowserFrm.BrowserCreatedMsg(var aMessage : TMessage);
begin
  CEFWindowParent1.UpdateSize;
  AddressBarPnl.Enabled := True;
  GoBtn.Click;
end;

procedure TSchemeRegistrationBrowserFrm.BrowserDestroyMsg(var aMessage : TMessage);
begin
  CEFWindowParent1.Free;
end;

procedure TSchemeRegistrationBrowserFrm.WMMove(var aMessage : TWMMove);
begin
  inherited;

  if (Chromium1 <> nil) then Chromium1.NotifyMoveOrResizeStarted;
end;

procedure TSchemeRegistrationBrowserFrm.WMMoving(var aMessage : TMessage);
begin
  inherited;

  if (Chromium1 <> nil) then Chromium1.NotifyMoveOrResizeStarted;
end;

procedure TSchemeRegistrationBrowserFrm.WMEnterMenuLoop(var aMessage: TMessage);
begin
  inherited;

  if (aMessage.wParam = 0) and (GlobalOldCEFApp <> nil) then GlobalOldCEFApp.OsmodalLoop := True;
end;

procedure TSchemeRegistrationBrowserFrm.WMExitMenuLoop(var aMessage: TMessage);
begin
  inherited;

  if (aMessage.wParam = 0) and (GlobalOldCEFApp <> nil) then GlobalOldCEFApp.OsmodalLoop := False;
end;

end.
