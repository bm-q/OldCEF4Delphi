program SimpleFMXBrowser;

uses
  System.StartUpCopy,
  FMX.Forms,
  {$IFDEF MSWINDOWS}
  WinApi.Windows,
  {$ENDIF }
  oldCefApplication,
  uSimpleFMXBrowser in 'uSimpleFMXBrowser.pas' {SimpleFMXBrowserFrm},
  uFMXApplicationService in 'uFMXApplicationService.pas';

{$R *.res}

{$IFDEF MSWINDOWS}
// CEF3 needs to set the LARGEADDRESSAWARE flag which allows 32-bit processes to use up to 3GB of RAM.
{$SetPEFlags IMAGE_FILE_LARGE_ADDRESS_AWARE}
{$ENDIF}

begin
  GlobalOldCEFApp                 := TOldCefApplication.Create;
  GlobalOldCEFApp.MustFreeLibrary := False;

  // In case you want to use custom directories for the CEF3 binaries, cache, cookies and user data.
  // If you don't set a cache directory the browser will use in-memory cache.
{
  GlobalOldCEFApp.FrameworkDirPath     := 'cef';
  GlobalOldCEFApp.ResourcesDirPath     := 'cef';
  GlobalOldCEFApp.LocalesDirPath       := 'cef\locales';
  GlobalOldCEFApp.EnableGPU            := True;      // Enable hardware acceleration
  GlobalOldCEFApp.DisableGPUCache      := True;      // Disable the creation of a 'GPUCache' directory in the hard drive.
  GlobalOldCEFApp.cache                := 'cef\cache';
  GlobalOldCEFApp.cookies              := 'cef\cookies';
  GlobalOldCEFApp.UserDataPath         := 'cef\User Data';
}

  // You *MUST* call GlobalOldCEFApp.StartMainProcess in a if..then clause
  // with the Application initialization inside the begin..end.
  // Read this https://www.briskbard.com/index.php?lang=en&pageid=cef
  if GlobalOldCEFApp.StartMainProcess then
    begin
      Application.Initialize;
      Application.CreateForm(TSimpleFMXBrowserFrm, SimpleFMXBrowserFrm);
      Application.Run;

      SimpleFMXBrowserFrm.Free;
    end;

  GlobalOldCEFApp.Free;
end.
