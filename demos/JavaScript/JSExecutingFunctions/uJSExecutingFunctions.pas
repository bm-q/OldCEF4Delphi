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

unit uJSExecutingFunctions;

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

const
  JSDEMO_CONTEXTMENU_EXECFUNCTION = MENU_ID_USER_FIRST + 1;

  EXECFUNCTION_MSGNAME = 'execfunction';

type
  TJSExecutingFunctionsFrm = class(TForm)
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
    procedure Chromium1BeforeContextMenu(Sender: TObject;
      const browser: IOldCefBrowser; const frame: IOldCefFrame;
      const params: IOldCefContextMenuParams; const model: IOldCefMenuModel);
    procedure Chromium1ContextMenuCommand(Sender: TObject;
      const browser: IOldCefBrowser; const frame: IOldCefFrame;
      const params: IOldCefContextMenuParams; commandId: Integer;
      eventFlags: Cardinal; out Result: Boolean);
    procedure Chromium1BeforePopup(Sender: TObject;
      const browser: IOldCefBrowser; const frame: IOldCefFrame; const targetUrl,
      targetFrameName: oldustring;
      targetDisposition: TOldCefWindowOpenDisposition; userGesture: Boolean;
      const popupFeatures: TOldCefPopupFeatures; var windowInfo: TOldCefWindowInfo;
      var client: IOldCefClient; var settings: TOldCefBrowserSettings;
      var noJavascriptAccess: Boolean; var Result: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
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
  JSExecutingFunctionsFrm  : TJSExecutingFunctionsFrm;
  GlobalCallbackFunc       : IOldCefv8Value = nil;
  GlobalCallbackContext    : IOldCefv8Context = nil;

procedure CreateGlobalOldCEFApp;

implementation

{$R *.dfm}

// The CEF3 document describing JavaScript integration is here :
// https://bitbucket.org/chromiumembedded/cef/wiki/JavaScriptIntegration.md

// The HTML file in this demo has a button that registers 'myfunc()' using
// a "register" function we previously binded to the window in the
// GlobalOldCEFApp.OnContextCreated event.

// After registering the function you can right-click over the demo and
// select "Execute registered JS function" to execute the function.

// This will send a process message to the "render" where the function can
// be executed.

// Destruction steps
// =================
// 1. FormCloseQuery sets CanClose to FALSE calls TOldChromium.CloseBrowser which triggers the TOldChromium.OnClose event.
// 2. TOldChromium.OnClose sends a CEFBROWSER_DESTROY message to destroy CEFWindowParent1 in the main thread, which triggers the TOldChromium.OnBeforeClose event.
// 3. TOldChromium.OnBeforeClose sets FCanClose := True and sends WM_CLOSE to the form.

uses
  oldCEFProcessMessage, uMyV8Handler;

procedure GlobalOldCEFApp_OnContextCreated(const browser: IOldCefBrowser; const frame: IOldCefFrame; const context: IOldCefv8Context);
var
  TempHandler  : IOldCefv8Handler;
  TempFunction : IOldCefv8Value;
begin
  TempHandler  := TMyV8Handler.Create;
  TempFunction := TOldCefv8ValueRef.NewFunction('register', TempHandler);

  context.Global.SetValueByKey('register', TempFunction, V8_PROPERTY_ATTRIBUTE_NONE);
end;

procedure GlobalOldCEFApp_OnProcessMessageReceived(const browser       : IOldCefBrowser;
                                                      sourceProcess : TOldCefProcessId;
                                                const aMessage      : IOldCefProcessMessage;
                                                var   aHandled      : boolean);
var
  arguments: TOldCefv8ValueArray;
begin
  if (aMessage.name = EXECFUNCTION_MSGNAME) then
    begin
      if (GlobalCallbackFunc <> nil) then
        GlobalCallbackFunc.ExecuteFunctionWithContext(GlobalCallbackContext, nil, arguments);

      aHandled := True;
    end
   else
    aHandled := False;
end;

procedure CreateGlobalOldCEFApp;
begin
  GlobalOldCEFApp                          := TOldCefApplication.Create;
  GlobalOldCEFApp.OnContextCreated         := GlobalOldCEFApp_OnContextCreated;
  GlobalOldCEFApp.OnProcessMessageReceived := GlobalOldCEFApp_OnProcessMessageReceived;
end;

procedure TJSExecutingFunctionsFrm.GoBtnClick(Sender: TObject);
begin
  Chromium1.LoadURL(Edit1.Text);
end;

procedure TJSExecutingFunctionsFrm.Chromium1AfterCreated(Sender: TObject; const browser: IOldCefBrowser);
begin
  PostMessage(Handle, CEF_AFTERCREATED, 0, 0);
end;

procedure TJSExecutingFunctionsFrm.Chromium1BeforeClose(Sender: TObject;
  const browser: IOldCefBrowser);
begin
  FCanClose := True;
  PostMessage(Handle, WM_CLOSE, 0, 0);
end;

procedure TJSExecutingFunctionsFrm.Chromium1BeforeContextMenu(
  Sender: TObject; const browser: IOldCefBrowser; const frame: IOldCefFrame;
  const params: IOldCefContextMenuParams; const model: IOldCefMenuModel);
begin
  model.AddSeparator;
  model.AddItem(JSDEMO_CONTEXTMENU_EXECFUNCTION, 'Execute registered JS function');
end;

procedure TJSExecutingFunctionsFrm.Chromium1BeforePopup(Sender: TObject;
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

procedure TJSExecutingFunctionsFrm.Chromium1Close(Sender: TObject; const browser: IOldCefBrowser; var aAction : TOldCefCloseBrowserAction);
begin
  PostMessage(Handle, CEF_DESTROY, 0, 0);
  aAction := cbaDelay;
end;

procedure TJSExecutingFunctionsFrm.Chromium1ContextMenuCommand(
  Sender: TObject; const browser: IOldCefBrowser; const frame: IOldCefFrame;
  const params: IOldCefContextMenuParams; commandId: Integer;
  eventFlags: Cardinal; out Result: Boolean);
var
  TempMsg : IOldCefProcessMessage;
begin
  Result := False;

  case commandId of
    JSDEMO_CONTEXTMENU_EXECFUNCTION :
      begin
        TempMsg := TOldCefProcessMessageRef.New(EXECFUNCTION_MSGNAME);
        Chromium1.SendProcessMessage(PID_RENDERER, TempMsg);
      end;
  end;
end;

procedure TJSExecutingFunctionsFrm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := FCanClose;

  if not(FClosing) then
    begin
      FClosing := True;
      Visible  := False;
      Chromium1.CloseBrowser(True);
    end;
end;

procedure TJSExecutingFunctionsFrm.FormCreate(Sender: TObject);
begin
  FCanClose := False;
  FClosing  := False;
end;

procedure TJSExecutingFunctionsFrm.FormDestroy(Sender: TObject);
begin
  GlobalCallbackFunc       := nil;
  GlobalCallbackContext    := nil;
end;

procedure TJSExecutingFunctionsFrm.FormShow(Sender: TObject);
begin
  // GlobalOldCEFApp.GlobalContextInitialized has to be TRUE before creating any browser
  // If it's not initialized yet, we use a simple timer to create the browser later.
  if not(Chromium1.CreateBrowser(CEFWindowParent1, '')) then Timer1.Enabled := True;
end;

procedure TJSExecutingFunctionsFrm.WMMove(var aMessage : TWMMove);
begin
  inherited;

  if (Chromium1 <> nil) then Chromium1.NotifyMoveOrResizeStarted;
end;

procedure TJSExecutingFunctionsFrm.WMMoving(var aMessage : TMessage);
begin
  inherited;

  if (Chromium1 <> nil) then Chromium1.NotifyMoveOrResizeStarted;
end;

procedure TJSExecutingFunctionsFrm.WMEnterMenuLoop(var aMessage: TMessage);
begin
  inherited;

  if (aMessage.wParam = 0) and (GlobalOldCEFApp <> nil) then GlobalOldCEFApp.OsmodalLoop := True;
end;

procedure TJSExecutingFunctionsFrm.WMExitMenuLoop(var aMessage: TMessage);
begin
  inherited;

  if (aMessage.wParam = 0) and (GlobalOldCEFApp <> nil) then GlobalOldCEFApp.OsmodalLoop := False;
end;

procedure TJSExecutingFunctionsFrm.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  if not(Chromium1.CreateBrowser(CEFWindowParent1, '')) and not(Chromium1.Initialized) then
    Timer1.Enabled := True;
end;

procedure TJSExecutingFunctionsFrm.BrowserCreatedMsg(var aMessage : TMessage);
begin
  Caption := 'JSExecutingFunctions';
  CEFWindowParent1.UpdateSize;
  NavControlPnl.Enabled := True;
  GoBtn.Click;
end;

procedure TJSExecutingFunctionsFrm.BrowserDestroyMsg(var aMessage : TMessage);
begin
  CEFWindowParent1.Free;
end;

end.
