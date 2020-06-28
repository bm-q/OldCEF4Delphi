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

unit uJSSimpleWindowBinding;

{$I oldcef.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  {$ELSE}
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls, ComCtrls,
  {$ENDIF}
  oldCEFChromium, oldCEFWindowParent, oldCEFInterfaces, oldCEFApplication, oldCEFTypes,
  oldCEFConstants, oldCEFv8Value;

type
  TJSSimpleWindowBindingFrm = class(TForm)
    NavControlPnl: TPanel;
    Edit1: TEdit;
    GoBtn: TButton;
    CEFWindowParent1: TOldCefWindowParent;
    Chromium1: TOldChromium;
    Timer1: TTimer;
    procedure FormShow(Sender: TObject);
    procedure GoBtnClick(Sender: TObject);
    procedure Chromium1AfterCreated(Sender: TObject; const browser: IOldCefBrowser);
    procedure Timer1Timer(Sender: TObject);
    procedure Chromium1BeforePopup(Sender: TObject;
      const browser: IOldCefBrowser; const frame: IOldCefFrame; const targetUrl,
      targetFrameName: oldustring;
      targetDisposition: TOldCefWindowOpenDisposition; userGesture: Boolean;
      const popupFeatures: TOldCefPopupFeatures; var windowInfo: TOldCefWindowInfo;
      var client: IOldCefClient; var settings: TOldCefBrowserSettings;
      var noJavascriptAccess: Boolean; var Result: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Chromium1Close(Sender: TObject; const browser: IOldCefBrowser;
      var aAction : TOldCefCloseBrowserAction);
    procedure Chromium1BeforeClose(Sender: TObject;
      const browser: IOldCefBrowser);
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
  JSSimpleWindowBindingFrm: TJSSimpleWindowBindingFrm;

procedure CreateGlobalOldCEFApp;

implementation

{$R *.dfm}

// The CEF3 document describing JavaScript integration is here :
// https://bitbucket.org/chromiumembedded/cef/wiki/JavaScriptIntegration.md

// The HTML file in this demo has a button that shows the contents of 'window.myval'
// which was set in the GlobalOldCEFApp.OnContextCreated event.

// Destruction steps
// =================
// 1. FormCloseQuery sets CanClose to FALSE calls TOldChromium.CloseBrowser which triggers the TOldChromium.OnClose event.
// 2. TOldChromium.OnClose sends a CEFBROWSER_DESTROY message to destroy CEFWindowParent1 in the main thread, which triggers the TOldChromium.OnBeforeClose event.
// 3. TOldChromium.OnBeforeClose sets FCanClose := True and sends WM_CLOSE to the form.

procedure GlobalOldCEFApp_OnContextCreated(const browser: IOldCefBrowser; const frame: IOldCefFrame; const context: IOldCefv8Context);
var
  TempValue : IOldCefv8Value;
begin
  // This is the first JS Window Binding example in the "JavaScript Integration" wiki page at
  // https://bitbucket.org/chromiumembedded/cef/wiki/JavaScriptIntegration.md

  TempValue := TOldCefv8ValueRef.NewString('My Value!');

  context.Global.SetValueByKey('myval', TempValue, V8_PROPERTY_ATTRIBUTE_NONE);
end;

procedure CreateGlobalOldCEFApp;
begin
  GlobalOldCEFApp                  := TOldCefApplication.Create;
  GlobalOldCEFApp.OnContextCreated := GlobalOldCEFApp_OnContextCreated;
end;

procedure TJSSimpleWindowBindingFrm.GoBtnClick(Sender: TObject);
begin
  Chromium1.LoadURL(Edit1.Text);
end;

procedure TJSSimpleWindowBindingFrm.Chromium1AfterCreated(Sender: TObject; const browser: IOldCefBrowser);
begin
  PostMessage(Handle, CEF_AFTERCREATED, 0, 0);
end;

procedure TJSSimpleWindowBindingFrm.Chromium1BeforePopup(Sender: TObject;
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

procedure TJSSimpleWindowBindingFrm.FormShow(Sender: TObject);
begin
  // GlobalOldCEFApp.GlobalContextInitialized has to be TRUE before creating any browser
  // If it's not initialized yet, we use a simple timer to create the browser later.
  if not(Chromium1.CreateBrowser(CEFWindowParent1, '')) then Timer1.Enabled := True;
end;

procedure TJSSimpleWindowBindingFrm.WMMove(var aMessage : TWMMove);
begin
  inherited;

  if (Chromium1 <> nil) then Chromium1.NotifyMoveOrResizeStarted;
end;

procedure TJSSimpleWindowBindingFrm.WMMoving(var aMessage : TMessage);
begin
  inherited;

  if (Chromium1 <> nil) then Chromium1.NotifyMoveOrResizeStarted;
end;

procedure TJSSimpleWindowBindingFrm.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  if not(Chromium1.CreateBrowser(CEFWindowParent1, '')) and not(Chromium1.Initialized) then
    Timer1.Enabled := True;
end;

procedure TJSSimpleWindowBindingFrm.BrowserCreatedMsg(var aMessage : TMessage);
begin
  Caption := 'JSSimpleWindowBinding';
  CEFWindowParent1.UpdateSize;
  NavControlPnl.Enabled := True;
  GoBtn.Click;
end;

procedure TJSSimpleWindowBindingFrm.WMEnterMenuLoop(var aMessage: TMessage);
begin
  inherited;

  if (aMessage.wParam = 0) and (GlobalOldCEFApp <> nil) then GlobalOldCEFApp.OsmodalLoop := True;
end;

procedure TJSSimpleWindowBindingFrm.WMExitMenuLoop(var aMessage: TMessage);
begin
  inherited;

  if (aMessage.wParam = 0) and (GlobalOldCEFApp <> nil) then GlobalOldCEFApp.OsmodalLoop := False;
end;

procedure TJSSimpleWindowBindingFrm.Chromium1BeforeClose(
  Sender: TObject; const browser: IOldCefBrowser);
begin
  FCanClose := True;
  PostMessage(Handle, WM_CLOSE, 0, 0);
end;

procedure TJSSimpleWindowBindingFrm.Chromium1Close(
  Sender: TObject; const browser: IOldCefBrowser; var aAction : TOldCefCloseBrowserAction);
begin
  PostMessage(Handle, CEF_DESTROY, 0, 0);
  aAction := cbaDelay;
end;

procedure TJSSimpleWindowBindingFrm.FormCloseQuery(
  Sender: TObject; var CanClose: Boolean);
begin
  CanClose := FCanClose;

  if not(FClosing) then
    begin
      FClosing := True;
      Visible  := False;
      Chromium1.CloseBrowser(True);
    end;
end;

procedure TJSSimpleWindowBindingFrm.FormCreate(Sender: TObject);
begin
  FCanClose := False;
  FClosing  := False;
end;

procedure TJSSimpleWindowBindingFrm.BrowserDestroyMsg(var aMessage : TMessage);
begin
  CEFWindowParent1.Free;
end;

end.
