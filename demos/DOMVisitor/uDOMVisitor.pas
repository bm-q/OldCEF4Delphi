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

unit uDOMVisitor;

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
  oldCEFChromium, oldCEFWindowParent, oldCEFInterfaces, oldCEFApplication, oldCEFTypes, oldCEFConstants;

const
  MINIBROWSER_VISITDOM_PARTIAL            = WM_APP + $101;
  MINIBROWSER_VISITDOM_FULL               = WM_APP + $102;

  MINIBROWSER_CONTEXTMENU_VISITDOM_PARTIAL = MENU_ID_USER_FIRST + 1;
  MINIBROWSER_CONTEXTMENU_VISITDOM_FULL    = MENU_ID_USER_FIRST + 2;

  DOMVISITOR_MSGNAME_PARTIAL  = 'domvisitorpartial';
  DOMVISITOR_MSGNAME_FULL     = 'domvisitorfull';
  RETRIEVEDOM_MSGNAME_PARTIAL = 'retrievedompartial';
  RETRIEVEDOM_MSGNAME_FULL    = 'retrievedomfull';

type
  TDOMVisitorFrm = class(TForm)
    CEFWindowParent1: TOldCefWindowParent;
    Chromium1: TOldChromium;
    AddressBarPnl: TPanel;
    AddressEdt: TEdit;
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    Panel1: TPanel;
    GoBtn: TButton;
    VisitDOMBtn: TButton;
    procedure GoBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Chromium1AfterCreated(Sender: TObject;
      const browser: IOldCefBrowser);
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
    procedure Timer1Timer(Sender: TObject);
    procedure VisitDOMBtnClick(Sender: TObject);
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
  private
    { Private declarations }
  protected
    // Variables to control when can we destroy the form safely
    FCanClose : boolean;  // Set to True in TOldChromium.OnBeforeClose
    FClosing  : boolean;  // Set to True in the CloseQuery event.

    procedure BrowserCreatedMsg(var aMessage : TMessage); message CEF_AFTERCREATED;
    procedure BrowserDestroyMsg(var aMessage : TMessage); message CEF_DESTROY;
    procedure VisitDOMMsg(var aMessage : TMessage); message MINIBROWSER_VISITDOM_PARTIAL;
    procedure VisitDOM2Msg(var aMessage : TMessage); message MINIBROWSER_VISITDOM_FULL;
    procedure WMMove(var aMessage : TWMMove); message WM_MOVE;
    procedure WMMoving(var aMessage : TMessage); message WM_MOVING;

    procedure ShowStatusText(const aText : string);
  public
    { Public declarations }
  end;

var
  DOMVisitorFrm: TDOMVisitorFrm;

procedure CreateGlobalOldCEFApp;

implementation

{$R *.dfm}

uses
  oldCEFProcessMessage, oldCEFMiscFunctions, oldCEFSchemeRegistrar, oldCEFRenderProcessHandler,
  oldCEFv8Handler, oldCEFDomVisitor, oldCEFDomNode, oldCEFTask;

// This demo sends messages from the browser process to the render process,
// and from the render process to the browser process.

// To send a message from the browser process you must use the TOldChromium.SendProcessMessage
// procedure with a PID_RENDERER parameter. The render process receives those messages in
// the GlobalOldCEFApp.OnProcessMessageReceived event.

// To send messages from the render process you must use the browser.SendProcessMessage
// procedure with a PID_BROWSER parameter. The browser process receives those messages in
// the TOldChromium.OnProcessMessageReceived event.

// message.name is used to identify different messages sent with SendProcessMessage.

// The OnProcessMessageReceived event can recognize any number of messages identifying them
// by message.name

// Destruction steps
// =================
// 1. FormCloseQuery sets CanClose to FALSE calls TOldChromium.CloseBrowser which triggers the TOldChromium.OnClose event.
// 2. TOldChromium.OnClose sends a CEFBROWSER_DESTROY message to destroy CEFWindowParent1 in the main thread, which triggers the TOldChromium.OnBeforeClose event.
// 3. TOldChromium.OnBeforeClose sets FCanClose := True and sends WM_CLOSE to the form.

procedure SimpleDOMIteration(const aDocument: IOldCefDomDocument);
var
  TempHead, TempChild : IOldCefDomNode;
begin
  try
    if (aDocument <> nil) then
      begin
        TempHead := aDocument.Head;

        if (TempHead <> nil) then
          begin
            TempChild := TempHead.FirstChild;

            while (TempChild <> nil) do
              begin
                CefLog('CEF4Delphi', 1, CEF_LOG_SEVERITY_ERROR, 'Head child element : ' + TempChild.Name);
                TempChild := TempChild.NextSibling;
              end;
          end;
      end;
  except
    on e : exception do
      if CustomExceptionHandler('SimpleDOMIteration', e) then raise;
  end;
end;

procedure SimpleNodeSearch(const aDocument: IOldCefDomDocument);
const
  NODE_ID = 'lst-ib'; // input box node found in google.com homepage
var
  TempNode : IOldCefDomNode;
begin
  try
    if (aDocument <> nil) then
      begin
        TempNode := aDocument.GetElementById(NODE_ID);

        if (TempNode <> nil) then
          begin
            CefLog('CEF4Delphi', 1, CEF_LOG_SEVERITY_ERROR, NODE_ID + ' element name : ' + TempNode.Name);
            CefLog('CEF4Delphi', 1, CEF_LOG_SEVERITY_ERROR, NODE_ID + ' element value : ' + TempNode.GetValue);
          end;

        TempNode := aDocument.GetFocusedNode;

        if (TempNode <> nil) then
          begin
            CefLog('CEF4Delphi', 1, CEF_LOG_SEVERITY_ERROR, 'Focused element name : ' + TempNode.Name);
            CefLog('CEF4Delphi', 1, CEF_LOG_SEVERITY_ERROR, 'Focused element inner text : ' + TempNode.ElementInnerText);
          end;
      end;
  except
    on e : exception do
      if CustomExceptionHandler('SimpleNodeSearch', e) then raise;
  end;
end;

procedure DOMVisitor_OnDocAvailable(const browser: IOldCefBrowser; const document: IOldCefDomDocument);
var
  msg: IOldCefProcessMessage;
begin
  // This function is called from a different process.
  // document is only valid inside this function.
  // As an example, this function only writes the document title to the 'debug.log' file.
  CefLog('CEF4Delphi', 1, CEF_LOG_SEVERITY_ERROR, 'document.Title : ' + document.Title);

  if document.HasSelection then
    CefLog('CEF4Delphi', 1, CEF_LOG_SEVERITY_ERROR, 'document.SelectionAsText : ' + quotedstr(document.SelectionAsText))
   else
    CefLog('CEF4Delphi', 1, CEF_LOG_SEVERITY_ERROR, 'document.HasSelection : False');

  // Simple DOM iteration example
  SimpleDOMIteration(document);

  // Simple DOM searches
  SimpleNodeSearch(document);

  // Sending back some custom results to the browser process
  // Notice that the DOMVISITOR_MSGNAME_PARTIAL message name needs to be recognized in
  // Chromium1ProcessMessageReceived
  msg := TOldCefProcessMessageRef.New(DOMVISITOR_MSGNAME_PARTIAL);
  msg.ArgumentList.SetString(0, 'document.Title : ' + document.Title);
  browser.SendProcessMessage(PID_BROWSER, msg);
end;

procedure DOMVisitor_OnDocAvailableFullMarkup(const browser: IOldCefBrowser; const document: IOldCefDomDocument);
var
  msg: IOldCefProcessMessage;
begin
  // Sending back some custom results to the browser process
  // Notice that the DOMVISITOR_MSGNAME_FULL message name needs to be recognized in
  // Chromium1ProcessMessageReceived
  msg := TOldCefProcessMessageRef.New(DOMVISITOR_MSGNAME_FULL);
  msg.ArgumentList.SetString(0, document.Body.AsMarkup);
  browser.SendProcessMessage(PID_BROWSER, msg);
end;

procedure GlobalOldCEFApp_OnProcessMessageReceived(const browser       : IOldCefBrowser;
                                                      sourceProcess : TOldCefProcessId;
                                                const message       : IOldCefProcessMessage;
                                                var   aHandled      : boolean);
var
  TempFrame   : IOldCefFrame;
  TempVisitor : TOldCefFastDomVisitor2;
begin
  aHandled := False;

  if (browser <> nil) then
    begin
      if (message.name = RETRIEVEDOM_MSGNAME_PARTIAL) then
        begin
          TempFrame := browser.MainFrame;

          if (TempFrame <> nil) then
            begin
              TempVisitor := TOldCefFastDomVisitor2.Create(browser, DOMVisitor_OnDocAvailable);
              TempFrame.VisitDom(TempVisitor);
            end;

          aHandled := True;
        end
       else
        if (message.name = RETRIEVEDOM_MSGNAME_FULL) then
          begin
            TempFrame := browser.MainFrame;

            if (TempFrame <> nil) then
              begin
                TempVisitor := TOldCefFastDomVisitor2.Create(browser, DOMVisitor_OnDocAvailableFullMarkup);
                TempFrame.VisitDom(TempVisitor);
              end;

            aHandled := True;
          end;
    end;
end;

procedure CreateGlobalOldCEFApp;
begin
  GlobalOldCEFApp                          := TOldCefApplication.Create;
  GlobalOldCEFApp.RemoteDebuggingPort      := 9000;
  GlobalOldCEFApp.OnProcessMessageReceived := GlobalOldCEFApp_OnProcessMessageReceived;

  // Enabling the debug log file for then DOM visitor demo.
  // This adds lots of warnings to the console, specially if you run this inside VirtualBox.
  // Remove it if you don't want to use the DOM visitor
  GlobalOldCEFApp.LogFile              := 'debug.log';
  GlobalOldCEFApp.LogSeverity          := LOGSEVERITY_ERROR;
end;

procedure TDOMVisitorFrm.Chromium1AfterCreated(Sender: TObject; const browser: IOldCefBrowser);
begin
  PostMessage(Handle, CEF_AFTERCREATED, 0, 0);
end;

procedure TDOMVisitorFrm.Chromium1BeforeClose(Sender: TObject;
  const browser: IOldCefBrowser);
begin
  FCanClose := True;
  PostMessage(Handle, WM_CLOSE, 0, 0);
end;

procedure TDOMVisitorFrm.Chromium1BeforeContextMenu(Sender: TObject;
  const browser: IOldCefBrowser; const frame: IOldCefFrame;
  const params: IOldCefContextMenuParams; const model: IOldCefMenuModel);
begin
  model.AddItem(MINIBROWSER_CONTEXTMENU_VISITDOM_PARTIAL,  'Visit DOM in CEF (only Title)');
  model.AddItem(MINIBROWSER_CONTEXTMENU_VISITDOM_FULL,     'Visit DOM in CEF (BODY HTML)');
end;

procedure TDOMVisitorFrm.Chromium1BeforePopup(Sender: TObject;
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

procedure TDOMVisitorFrm.Chromium1Close(Sender: TObject;
  const browser: IOldCefBrowser; var aAction : TOldCefCloseBrowserAction);
begin
  PostMessage(Handle, CEF_DESTROY, 0, 0);
  aAction := cbaDelay;
end;

procedure TDOMVisitorFrm.Chromium1ContextMenuCommand(Sender: TObject;
  const browser: IOldCefBrowser; const frame: IOldCefFrame;
  const params: IOldCefContextMenuParams; commandId: Integer;
  eventFlags: Cardinal; out Result: Boolean);
begin
  Result := False;

  case commandId of
    MINIBROWSER_CONTEXTMENU_VISITDOM_PARTIAL :
      PostMessage(Handle, MINIBROWSER_VISITDOM_PARTIAL, 0, 0);

    MINIBROWSER_CONTEXTMENU_VISITDOM_FULL :
      PostMessage(Handle, MINIBROWSER_VISITDOM_FULL, 0, 0);
  end;
end;

procedure TDOMVisitorFrm.Chromium1ProcessMessageReceived(Sender: TObject;
  const browser: IOldCefBrowser; sourceProcess: TOldCefProcessId;
  const message: IOldCefProcessMessage; out Result: Boolean);
begin
  Result := False;

  if (message = nil) or (message.ArgumentList = nil) then exit;

  // Message received from the DOMVISITOR in CEF

  if (message.Name = DOMVISITOR_MSGNAME_PARTIAL) then
    begin
      ShowStatusText('DOM Visitor result text : ' + message.ArgumentList.GetString(0));
      Result := True;
    end
   else
    if (message.Name = DOMVISITOR_MSGNAME_FULL) then
      begin
        Clipboard.AsText := message.ArgumentList.GetString(0);
        ShowStatusText('HTML copied to the clipboard');
        Result := True;
      end;
end;

procedure TDOMVisitorFrm.FormCloseQuery(Sender: TObject;
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

procedure TDOMVisitorFrm.FormCreate(Sender: TObject);
begin
  FCanClose := False;
  FClosing  := False;
end;

procedure TDOMVisitorFrm.FormShow(Sender: TObject);
begin
  // GlobalOldCEFApp.GlobalContextInitialized has to be TRUE before creating any browser
  // If it's not initialized yet, we use a simple timer to create the browser later.
  if not(Chromium1.CreateBrowser(CEFWindowParent1, '')) then Timer1.Enabled := True;
end;

procedure TDOMVisitorFrm.GoBtnClick(Sender: TObject);
begin
  Chromium1.LoadURL(AddressEdt.Text);
end;

procedure TDOMVisitorFrm.BrowserCreatedMsg(var aMessage : TMessage);
begin
  CEFWindowParent1.UpdateSize;
  AddressBarPnl.Enabled := True;
  GoBtn.Click;
end;

procedure TDOMVisitorFrm.BrowserDestroyMsg(var aMessage : TMessage);
begin
  CEFWindowParent1.Free;
end;

procedure TDOMVisitorFrm.VisitDOMBtnClick(Sender: TObject);
begin
  PostMessage(Handle, MINIBROWSER_VISITDOM_PARTIAL, 0, 0);
end;

procedure TDOMVisitorFrm.VisitDOMMsg(var aMessage : TMessage);
var
  TempMsg : IOldCefProcessMessage;
begin
  // Use the ArgumentList property if you need to pass some parameters.
  TempMsg := TOldCefProcessMessageRef.New(RETRIEVEDOM_MSGNAME_PARTIAL); // Same name than TOldCefCustomRenderProcessHandler.MessageName
  Chromium1.SendProcessMessage(PID_RENDERER, TempMsg);
end;

procedure TDOMVisitorFrm.VisitDOM2Msg(var aMessage : TMessage);
var
  TempMsg : IOldCefProcessMessage;
begin
  // Use the ArgumentList property if you need to pass some parameters.
  TempMsg := TOldCefProcessMessageRef.New(RETRIEVEDOM_MSGNAME_FULL); // Same name than TOldCefCustomRenderProcessHandler.MessageName
  Chromium1.SendProcessMessage(PID_RENDERER, TempMsg);
end;

procedure TDOMVisitorFrm.WMMove(var aMessage : TWMMove);
begin
  inherited;

  if (Chromium1 <> nil) then Chromium1.NotifyMoveOrResizeStarted;
end;

procedure TDOMVisitorFrm.WMMoving(var aMessage : TMessage);
begin
  inherited;

  if (Chromium1 <> nil) then Chromium1.NotifyMoveOrResizeStarted;
end;

procedure TDOMVisitorFrm.ShowStatusText(const aText : string);
begin
  StatusBar1.Panels[0].Text := aText;
end;

procedure TDOMVisitorFrm.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  if not(Chromium1.CreateBrowser(CEFWindowParent1, '')) and not(Chromium1.Initialized) then
    Timer1.Enabled := True;
end;

end.
