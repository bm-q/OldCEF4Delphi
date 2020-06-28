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
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  System.SyncObjs, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls,
  {$ELSE}
  Windows, Messages, SysUtils, Variants, Classes, SyncObjs,
  Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
  {$ENDIF}
  oldCEFChromium, oldCEFTypes, oldCEFInterfaces, oldCEFConstants, oldBufferPanel,
  oldCEFWindowParent;

type
  TChildForm = class(TForm)
    Chromium1: TOldChromium;
    CEFWindowParent1: TOldCefWindowParent;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);

    procedure Chromium1BeforePopup(Sender: TObject; const browser: IOldCefBrowser; const frame: IOldCefFrame; const targetUrl, targetFrameName: oldustring; targetDisposition: TOldCefWindowOpenDisposition; userGesture: Boolean; const popupFeatures: TOldCefPopupFeatures; var windowInfo: TOldCefWindowInfo; var client: IOldCefClient; var settings: TOldCefBrowserSettings; var noJavascriptAccess: Boolean; var Result: Boolean);
    procedure Chromium1TitleChange(Sender: TObject; const browser: IOldCefBrowser; const title: oldustring);
    procedure Chromium1Close(Sender: TObject; const browser: IOldCefBrowser; var aAction : TOldCefCloseBrowserAction);
    procedure Chromium1BeforeClose(Sender: TObject; const browser: IOldCefBrowser);

  protected
    FCanClose          : boolean;
    FClosing           : boolean;
    FClientInitialized : boolean;
    FPopupFeatures     : TOldCefPopupFeatures;

    procedure WMMove(var aMessage : TWMMove); message WM_MOVE;
    procedure WMMoving(var aMessage : TMessage); message WM_MOVING;
    procedure WMEnterMenuLoop(var aMessage: TMessage); message WM_ENTERMENULOOP;
    procedure WMExitMenuLoop(var aMessage: TMessage); message WM_EXITMENULOOP;
    procedure BrowserDestroyMsg(var aMessage : TMessage); message CEF_DESTROY;

  public
    procedure AfterConstruction; override;
    function  CreateClientHandler(var windowInfo : TOldCefWindowInfo; var client : IOldCefClient; const targetFrameName : string; const popupFeatures : TOldCefPopupFeatures) : boolean;
    procedure ApplyPopupFeatures;

    property  ClientInitialized : boolean   read FClientInitialized;
    property  Closing           : boolean   read FClosing;
  end;

implementation

{$R *.dfm}

uses
  {$IFDEF DELPHI16_UP}
  System.Math,
  {$ELSE}
  Math,
  {$ENDIF}
  oldCEFMiscFunctions, oldCEFApplication, uMainForm;

// Destruction steps
// =================
// 1. FormCloseQuery sets CanClose to FALSE calls TOldChromium.CloseBrowser which triggers the TOldChromium.OnClose event.
// 2. TOldChromium.OnClose sends a CEFBROWSER_DESTROY message to destroy CEFWindowParent1 in the main thread, which triggers the TOldChromium.OnBeforeClose event.
// 3. TOldChromium.OnBeforeClose sets FCanClose := True and sends WM_CLOSE to the form.

procedure TChildForm.AfterConstruction;
begin
  inherited AfterConstruction;

  CreateHandle;

  CEFWindowParent1.CreateHandle;
end;

function TChildForm.CreateClientHandler(var   windowInfo      : TOldCefWindowInfo;
                                        var   client          : IOldCefClient;
                                        const targetFrameName : string;
                                        const popupFeatures   : TOldCefPopupFeatures) : boolean;
var
  TempRect : TRect;
begin
  if CEFWindowParent1.HandleAllocated and
     Chromium1.CreateClientHandler(client, False) then
    begin
      Result             := True;
      FClientInitialized := True;
      FPopupFeatures     := popupFeatures;
      TempRect           := CEFWindowParent1.ClientRect;

      if (FPopupFeatures.widthset  <> 0) then TempRect.Right  := max(FPopupFeatures.width,  100);
      if (FPopupFeatures.heightset <> 0) then TempRect.Bottom := max(FPopupFeatures.height, 100);

      WindowInfoAsChild(windowInfo, CEFWindowParent1.Handle, TempRect, '');
    end
   else
    Result := False;
end;

procedure TChildForm.ApplyPopupFeatures;
begin
  if (FPopupFeatures.xset      <> 0) then Chromium1.SetFormLeftTo(FPopupFeatures.x);
  if (FPopupFeatures.yset      <> 0) then Chromium1.SetFormTopTo(FPopupFeatures.y);
  if (FPopupFeatures.widthset  <> 0) then Chromium1.ResizeFormWidthTo(FPopupFeatures.width);
  if (FPopupFeatures.heightset <> 0) then Chromium1.ResizeFormHeightTo(FPopupFeatures.height);
end;

procedure TChildForm.Chromium1BeforeClose(Sender: TObject; const browser: IOldCefBrowser);
begin
  FCanClose := True;
  PostMessage(Handle, WM_CLOSE, 0, 0);
end;

procedure TChildForm.Chromium1BeforePopup(Sender : TObject;
                                          const browser            : IOldCefBrowser;
                                          const frame              : IOldCefFrame;
                                          const targetUrl          : oldustring;
                                          const targetFrameName    : oldustring;
                                                targetDisposition  : TOldCefWindowOpenDisposition;
                                                userGesture        : Boolean;
                                          const popupFeatures      : TOldCefPopupFeatures;
                                          var   windowInfo         : TOldCefWindowInfo;
                                          var   client             : IOldCefClient;
                                          var   settings           : TOldCefBrowserSettings;
                                          var   noJavascriptAccess : Boolean;
                                          var   Result             : Boolean);
begin
  case targetDisposition of
    WOD_NEW_FOREGROUND_TAB,
    WOD_NEW_BACKGROUND_TAB,
    WOD_NEW_WINDOW : Result := True;  // For simplicity, this demo blocks new tabs and new windows.

    WOD_NEW_POPUP : Result := not(TMainForm(Owner).CreateClientHandler(windowInfo, client, targetFrameName, popupFeatures));

    else Result := False;
  end;
end;

procedure TChildForm.Chromium1Close(Sender: TObject; const browser: IOldCefBrowser; var aAction : TOldCefCloseBrowserAction);
begin
  PostMessage(Handle, CEF_DESTROY, 0, 0);
  aAction := cbaDelay;
end;

procedure TChildForm.Chromium1TitleChange(Sender: TObject; const browser: IOldCefBrowser; const title: oldustring);
begin
  Caption := title;
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

procedure TChildForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TChildForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := FCanClose;

  if not(FClosing) then
    begin
      FClosing := True;
      Visible  := False;
      Chromium1.CloseBrowser(True);
    end;
end;

procedure TChildForm.FormCreate(Sender: TObject);
begin
  FCanClose          := False;
  FClosing           := False;
  FClientInitialized := False;
end;

procedure TChildForm.FormDestroy(Sender: TObject);
begin
  if FClientInitialized and TMainForm(Owner).HandleAllocated then
    PostMessage(TMainForm(Owner).Handle, CEF_CHILDDESTROYED, 0, 0);
end;

procedure TChildForm.BrowserDestroyMsg(var aMessage : TMessage);
begin
  CEFWindowParent1.Free;
end;

end.
