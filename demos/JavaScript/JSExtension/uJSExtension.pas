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

unit uJSExtension;

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
  oldCEFChromium, oldCEFWindowParent, oldCEFInterfaces, oldCEFApplication, oldCEFTypes, oldCEFConstants;

const
  MINIBROWSER_SHOWTEXTVIEWER = WM_APP + $100;

  MINIBROWSER_CONTEXTMENU_SETJSEVENT   = MENU_ID_USER_FIRST + 1;
  MINIBROWSER_CONTEXTMENU_JSVISITDOM   = MENU_ID_USER_FIRST + 2;

  MOUSEOVER_MESSAGE_NAME  = 'mouseover';
  CUSTOMNAME_MESSAGE_NAME = 'customname';

type
  TJSExtensionFrm = class(TForm)
    NavControlPnl: TPanel;
    Edit1: TEdit;
    GoBtn: TButton;
    StatusBar1: TStatusBar;
    CEFWindowParent1: TOldCefWindowParent;
    Chromium1: TOldChromium;
    Timer1: TTimer;
    procedure FormShow(Sender: TObject);
    procedure GoBtnClick(Sender: TObject);
    procedure Chromium1BeforeContextMenu(Sender: TObject;
      const browser: IOldCefBrowser; const frame: IOldCefFrame;
      const params: IOldCefContextMenuParams; const model: IOldCefMenuModel);
    procedure Chromium1ContextMenuCommand(Sender: TObject;
      const browser: IOldCefBrowser; const frame: IOldCefFrame;
      const params: IOldCefContextMenuParams; commandId: Integer;
      eventFlags: Cardinal; out Result: Boolean);
    procedure Chromium1ProcessMessageReceived(Sender: TObject;
      const browser: IOldCefBrowser; sourceProcess: TOldCefProcessId;
      const message: IOldCefProcessMessage; out Result: Boolean);
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
    FText : string;
    // Variables to control when can we destroy the form safely
    FCanClose : boolean;  // Set to True in TOldChromium.OnBeforeClose
    FClosing  : boolean;  // Set to True in the CloseQuery event.

    procedure BrowserCreatedMsg(var aMessage : TMessage); message CEF_AFTERCREATED;
    procedure BrowserDestroyMsg(var aMessage : TMessage); message CEF_DESTROY;
    procedure ShowTextViewerMsg(var aMessage : TMessage); message MINIBROWSER_SHOWTEXTVIEWER;
    procedure WMMove(var aMessage : TWMMove); message WM_MOVE;
    procedure WMMoving(var aMessage : TMessage); message WM_MOVING;
    procedure WMEnterMenuLoop(var aMessage: TMessage); message WM_ENTERMENULOOP;
    procedure WMExitMenuLoop(var aMessage: TMessage); message WM_EXITMENULOOP;
  public
    { Public declarations }
  end;

var
  JSExtensionFrm: TJSExtensionFrm;

procedure CreateGlobalOldCEFApp;

implementation

{$R *.dfm}

uses
  uSimpleTextViewer, oldCEFMiscFunctions, uTestExtensionHandler;

// The CEF3 document describing extensions is here :
// https://bitbucket.org/chromiumembedded/cef/wiki/JavaScriptIntegration.md

// This demo has a Javascrit extension class that is registered in the
// GlobalOldCEFApp.OnWebKitInitialized event when the application is initializing.

// TTestExtensionHandler can send information back to the browser with a process message.
// The "mouseover" function do this by calling
// TOldCefv8ContextRef.Current.Browser.SendProcessMessage(PID_BROWSER, msg);

// TOldCefv8ContextRef.Current returns the v8 context for the frame that is currently executing JS,
// TOldCefv8ContextRef.Current.Browser.SendProcessMessage should send a message to the right browser even
// if you have created several browsers in one app.

// That message is received in the TOldChromium.OnProcessMessageReceived event.
// Even if you create several TOldChromium objects you should have no problem because each of them will have its own
// TOldChromium.OnProcessMessageReceived event to receive the messages from the extension.

// Destruction steps
// =================
// 1. FormCloseQuery sets CanClose to FALSE calls TOldChromium.CloseBrowser which triggers the TOldChromium.OnClose event.
// 2. TOldChromium.OnClose sends a CEFBROWSER_DESTROY message to destroy CEFWindowParent1 in the main thread, which triggers the TOldChromium.OnBeforeClose event.
// 3. TOldChromium.OnBeforeClose sets FCanClose := True and sends WM_CLOSE to the form.

procedure GlobalOldCEFApp_OnWebKitInitialized;
var
  TempExtensionCode : string;
  TempHandler       : IOldCefv8Handler;
begin
  // This is a JS extension example with 2 functions and several parameters.
  // Please, read the "JavaScript Integration" wiki page at
  // https://bitbucket.org/chromiumembedded/cef/wiki/JavaScriptIntegration.md

  TempExtensionCode := 'var myextension;' +
                       'if (!myextension)' +
                       '  myextension = {};' +
                       '(function() {' +
                       '  myextension.mouseover = function(a) {' +
                       '    native function mouseover();' +
                       '    mouseover(a);' +
                       '  };' +
                       '  myextension.sendresulttobrowser = function(b,c) {' +
                       '    native function sendresulttobrowser();' +
                       '    sendresulttobrowser(b,c);' +
                       '  };' +
                       '})();';

  TempHandler := TTestExtensionHandler.Create;

  CefRegisterExtension('myextension', TempExtensionCode, TempHandler);
end;

procedure CreateGlobalOldCEFApp;
begin
  GlobalOldCEFApp                     := TOldCefApplication.Create;
  GlobalOldCEFApp.OnWebKitInitialized := GlobalOldCEFApp_OnWebKitInitialized;

  {$IFDEF INTFLOG}
  GlobalOldCEFApp.LogFile             := 'debug.log';
  GlobalOldCEFApp.LogSeverity         := LOGSEVERITY_INFO;
  {$ENDIF}
end;

procedure TJSExtensionFrm.GoBtnClick(Sender: TObject);
begin
  Chromium1.LoadURL(Edit1.Text);
end;

procedure TJSExtensionFrm.Chromium1AfterCreated(Sender: TObject; const browser: IOldCefBrowser);
begin
  PostMessage(Handle, CEF_AFTERCREATED, 0, 0);
end;

procedure TJSExtensionFrm.Chromium1BeforeClose(Sender: TObject;
  const browser: IOldCefBrowser);
begin
  FCanClose := True;
  PostMessage(Handle, WM_CLOSE, 0, 0);
end;

procedure TJSExtensionFrm.Chromium1BeforeContextMenu(Sender: TObject;
  const browser: IOldCefBrowser; const frame: IOldCefFrame;
  const params: IOldCefContextMenuParams; const model: IOldCefMenuModel);
begin
  // Adding some custom context menu entries
  model.AddSeparator;
  model.AddItem(MINIBROWSER_CONTEXTMENU_SETJSEVENT,  'Set mouseover event');
  model.AddItem(MINIBROWSER_CONTEXTMENU_JSVISITDOM,  'Visit DOM in JavaScript');
end;

procedure TJSExtensionFrm.Chromium1BeforePopup(Sender: TObject;
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

procedure TJSExtensionFrm.Chromium1Close(Sender: TObject;
  const browser: IOldCefBrowser; var aAction : TOldCefCloseBrowserAction);
begin
  PostMessage(Handle, CEF_DESTROY, 0, 0);
  aAction := cbaDelay;
end;

procedure TJSExtensionFrm.Chromium1ContextMenuCommand(Sender: TObject;
  const browser: IOldCefBrowser; const frame: IOldCefFrame;
  const params: IOldCefContextMenuParams; commandId: Integer;
  eventFlags: Cardinal; out Result: Boolean);
begin
  Result := False;

  // Here is the code executed for each custom context menu entry

  case commandId of
    MINIBROWSER_CONTEXTMENU_SETJSEVENT :
      if (browser <> nil) and (browser.MainFrame <> nil) then
        browser.MainFrame.ExecuteJavaScript(
          'document.body.addEventListener("mouseover", function(evt){'+
            'function getpath(n){'+
              'var ret = "<" + n.nodeName + ">";'+
              'if (n.parentNode){return getpath(n.parentNode) + ret} else '+
              'return ret'+
            '};'+
            'myextension.mouseover(getpath(evt.target))}'+   // This is the call from JavaScript to the extension with DELPHI code in uTestExtensionHandler.pas
          ')', 'about:blank', 0);

    MINIBROWSER_CONTEXTMENU_JSVISITDOM :
      if (browser <> nil) and (browser.MainFrame <> nil) then
        browser.MainFrame.ExecuteJavaScript(
          'var testhtml = document.body.innerHTML;' +
          'myextension.sendresulttobrowser(testhtml, ' + quotedstr(CUSTOMNAME_MESSAGE_NAME) + ');',  // This is the call from JavaScript to the extension with DELPHI code in uTestExtensionHandler.pas
          'about:blank', 0);
  end;
end;

procedure TJSExtensionFrm.Chromium1ProcessMessageReceived(Sender: TObject;
  const browser: IOldCefBrowser; sourceProcess: TOldCefProcessId;
  const message: IOldCefProcessMessage; out Result: Boolean);
begin
  Result := False;

  if (message = nil) or (message.ArgumentList = nil) then exit;

  // This function receives the messages with the JavaScript results

  // Many of these events are received in different threads and the VCL
  // doesn't like to create and destroy components in different threads.

  // It's safer to store the results and send a message to the main thread to show them.

  // The message names are defined in the extension or in JS code.

  if (message.Name = MOUSEOVER_MESSAGE_NAME) then
    begin
      StatusBar1.Panels[0].Text := message.ArgumentList.GetString(0); // this doesn't create/destroy components
      Result := True;
    end
   else
    if (message.Name = CUSTOMNAME_MESSAGE_NAME) then
      begin
        FText := message.ArgumentList.GetString(0);
        PostMessage(Handle, MINIBROWSER_SHOWTEXTVIEWER, 0, 0);
        Result := True;
      end;
end;

procedure TJSExtensionFrm.FormCloseQuery(Sender: TObject;
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

procedure TJSExtensionFrm.FormCreate(Sender: TObject);
begin
  FCanClose := False;
  FClosing  := False;
end;

procedure TJSExtensionFrm.FormShow(Sender: TObject);
begin
  StatusBar1.Panels[0].Text := 'Initializing browser. Please wait...';

  // GlobalOldCEFApp.GlobalContextInitialized has to be TRUE before creating any browser
  // If it's not initialized yet, we use a simple timer to create the browser later.
  if not(Chromium1.CreateBrowser(CEFWindowParent1, '')) then Timer1.Enabled := True;
end;

procedure TJSExtensionFrm.WMMove(var aMessage : TWMMove);
begin
  inherited;

  if (Chromium1 <> nil) then Chromium1.NotifyMoveOrResizeStarted;
end;

procedure TJSExtensionFrm.WMMoving(var aMessage : TMessage);
begin
  inherited;

  if (Chromium1 <> nil) then Chromium1.NotifyMoveOrResizeStarted;
end;

procedure TJSExtensionFrm.WMEnterMenuLoop(var aMessage: TMessage);
begin
  inherited;

  if (aMessage.wParam = 0) and (GlobalOldCEFApp <> nil) then GlobalOldCEFApp.OsmodalLoop := True;
end;

procedure TJSExtensionFrm.WMExitMenuLoop(var aMessage: TMessage);
begin
  inherited;

  if (aMessage.wParam = 0) and (GlobalOldCEFApp <> nil) then GlobalOldCEFApp.OsmodalLoop := False;
end;

procedure TJSExtensionFrm.ShowTextViewerMsg(var aMessage : TMessage);
begin
  // This form will show the HTML received from JavaScript
  SimpleTextViewerFrm.Memo1.Lines.Text := FText;
  SimpleTextViewerFrm.ShowModal;
end;

procedure TJSExtensionFrm.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  if not(Chromium1.CreateBrowser(CEFWindowParent1, '')) and not(Chromium1.Initialized) then
    Timer1.Enabled := True;
end;

procedure TJSExtensionFrm.BrowserCreatedMsg(var aMessage : TMessage);
begin
  StatusBar1.Panels[0].Text := '';
  CEFWindowParent1.UpdateSize;
  NavControlPnl.Enabled := True;
  GoBtn.Click;
end;

procedure TJSExtensionFrm.BrowserDestroyMsg(var aMessage : TMessage);
begin
  CEFWindowParent1.Free;
end;

end.
