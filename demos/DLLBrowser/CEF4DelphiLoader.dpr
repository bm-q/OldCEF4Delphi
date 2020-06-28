program CEF4DelphiLoader;

uses
  Vcl.Forms,
  uCef4DelphiLoader in 'uCef4DelphiLoader.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
