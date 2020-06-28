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

unit uChildForm;

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
  uMainForm, oldCEFChromium, oldCEFWindowParent, oldCEFInterfaces, oldCEFConstants, oldCEFTypes;

type
  TChildForm = class(TForm)
    Panel1: TPanel;
    Edit1: TEdit;
    Button1: TButton;
    Chromium1: TOldChromium;
    CEFWindowParent1: TOldCefWindowParent;
    StatusBar1: TStatusBar;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Chromium1AfterCreated(Sender: TObject; const browser: IOldCefBrowser);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure Chromium1Close(Sender: TObject; const browser: IOldCefBrowser;
      var aAction : TOldCefCloseBrowserAction);
    procedure FormDestroy(Sender: TObject);
    procedure Chromium1BeforeClose(Sender: TObject;
      const browser: IOldCefBrowser);
    procedure Chromium1LoadingStateChange(Sender: TObject;
      const browser: IOldCefBrowser; isLoading, canGoBack,
      canGoForward: Boolean);
    procedure Chromium1StatusMessage(Sender: TObject;
      const browser: IOldCefBrowser; const value: oldustring);
    procedure Chromium1BeforePopup(Sender: TObject;
      const browser: IOldCefBrowser; const frame: IOldCefFrame; const targetUrl,
      targetFrameName: oldustring;
      targetDisposition: TOldCefWindowOpenDisposition; userGesture: Boolean;
      const popupFeatures: TOldCefPopupFeatures; var windowInfo: TOldCefWindowInfo;
      var client: IOldCefClient; var settings: TOldCefBrowserSettings;
      var noJavascriptAccess: Boolean; var Result: Boolean);

  private
    // Variables to control when can we destroy the form safely
    FCanClose : boolean;  // Set to True in TOldChromium.OnBeforeClose
    FClosing  : boolean;  // Set to True in the CloseQuery event.

  protected
    procedure BrowserCreatedMsg(var aMessage : TMessage); message CEFBROWSER_CREATED;
    procedure BrowserDestroyMsg(var aMessage : TMessage); message CEFBROWSER_DESTROY;
    procedure WMMove(var aMessage : TWMMove); message WM_MOVE;
    procedure WMMoving(var aMessage : TMessage); message WM_MOVING;
    procedure WMEnterMenuLoop(var aMessage: TMessage); message WM_ENTERMENULOOP;
    procedure WMExitMenuLoop(var aMessage: TMessage); message WM_EXITMENULOOP;

  public
    property Closing   : boolean    read FClosing;
  end;

implementation

{$R *.dfm}

// Destruction steps
// =================
// 1. FormCloseQuery calls TOldChromium.CloseBrowser
// 2. TOldChromium.OnClose sends a CEFBROWSER_DESTROY message to destroy CEFWindowParent1 in the main thread.
// 3. TOldChromium.OnBeforeClose sets FCanClose := True and sends WM_CLOSE to the form.

uses
  oldCEFRequestContext, oldCEFApplication;

procedure TChildForm.Button1Click(Sender: TObject);
begin
  Chromium1.LoadURL(Edit1.Text);
end;

procedure TChildForm.Chromium1AfterCreated(Sender: TObject; const browser: IOldCefBrowser);
begin
  PostMessage(Handle, CEFBROWSER_CREATED, 0, 0);
end;

procedure TChildForm.Chromium1BeforeClose(Sender: TObject; const browser: IOldCefBrowser);
begin
  FCanClose := True;
  PostMessage(Handle, WM_CLOSE, 0, 0);
end;

procedure TChildForm.Chromium1BeforePopup(Sender: TObject;
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

procedure TChildForm.Chromium1Close(Sender: TObject; const browser: IOldCefBrowser; var aAction : TOldCefCloseBrowserAction);
begin
  PostMessage(Handle, CEFBROWSER_DESTROY, 0, 0);
  aAction := cbaDelay;
end;

procedure TChildForm.Chromium1LoadingStateChange(Sender: TObject; const browser: IOldCefBrowser; isLoading, canGoBack, canGoForward: Boolean);
begin
  if isLoading then
    begin
      StatusBar1.Panels[0].Text := 'Loading...';
      cursor := crAppStart;
    end
   else
    begin
      StatusBar1.Panels[0].Text := '';
      cursor := crDefault;
    end;
end;

procedure TChildForm.Chromium1StatusMessage(Sender: TObject; const browser: IOldCefBrowser; const value: oldustring);
begin
  StatusBar1.Panels[1].Text := value;
end;

procedure TChildForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TChildForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := FCanClose;

  if not(FClosing) and Panel1.Enabled then
    begin
      FClosing       := True;
      Panel1.Enabled := False;
      Chromium1.CloseBrowser(True);
    end;
end;

procedure TChildForm.FormCreate(Sender: TObject);
begin
  FCanClose := False;
  FClosing  := False;
end;

procedure TChildForm.FormDestroy(Sender: TObject);
begin
  // Tell the main form that a child has been destroyed.
  // The main form will check if this was the last child to close itself
  PostMessage(MainForm.Handle, CEFBROWSER_CHILDDESTROYED, 0, 0);
end;

procedure TChildForm.FormShow(Sender: TObject);
var
  TempContext : IOldCefRequestContext;
begin
  // The new request context overrides several GlobalOldCEFApp properties like :
  // cache, AcceptLanguageList, PersistSessionCookies, PersistUserPreferences,
  // IgnoreCertificateErrors and EnableNetSecurityExpiration

  // If you use an empty cache path, CEF will use in-memory cache.

  if MainForm.NewContextChk.Checked then
    TempContext := TOldCefRequestContextRef.New('', '', False, False, False)
   else
    TempContext := nil;

{
  // This would be a good place to set the proxy server settings for all your child
  // browsers if you use a proxy
  Chromium1.ProxyType     := CEF_PROXYTYPE_FIXED_SERVERS;
  Chromium1.ProxyScheme   := psHTTP;
  Chromium1.ProxyServer   := '1.2.3.4';
  Chromium1.ProxyPort     := 1234;
  Chromium1.ProxyUsername := '';
  Chromium1.ProxyPassword := '';
}

  // In case you used a custom cookies path in the GlobalOldCEFApp you can
  // override it in the TOldChromium.CreateBrowser function
  Chromium1.CreateBrowser(CEFWindowParent1, '', TempContext);
end;

procedure TChildForm.WMMove(var aMessage : TWMMove);
begin
  inherited;

  if (Chromium1 <> nil) then Chromium1.NotifyMoveOrResizeStarted;
end;

procedure TChildForm.WMMoving(var aMessage : TMessage);
begin
  inherited;

  if (Chromium1 <> nil) then Chromium1.NotifyMoveOrResizeStarted;
end;

procedure TChildForm.WMEnterMenuLoop(var aMessage: TMessage);
begin
  inherited;

  if (aMessage.wParam = 0) and (GlobalOldCEFApp <> nil) then GlobalOldCEFApp.OsmodalLoop := True;
end;

procedure TChildForm.WMExitMenuLoop(var aMessage: TMessage);
begin
  inherited;

  if (aMessage.wParam = 0) and (GlobalOldCEFApp <> nil) then GlobalOldCEFApp.OsmodalLoop := False;
end;

procedure TChildForm.BrowserCreatedMsg(var aMessage : TMessage);
begin
  CEFWindowParent1.UpdateSize;
  Panel1.Enabled := True;
  Button1.Click;
end;

procedure TChildForm.BrowserDestroyMsg(var aMessage : TMessage);
begin
  CEFWindowParent1.Free;
end;

end.
