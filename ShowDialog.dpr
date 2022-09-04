program ShowDialog;

uses
  System.StartUpCopy,
  FMX.Forms,
  ShowDialog.Home in 'ShowDialog.Home.pas' {FormHome},
  uMensagemDlg in 'uMensagemDlg.pas',
  uMensagemDlgTypes in 'uMensagemDlgTypes.pas',
  ShowDialog.RSP.RSP37704 in 'ShowDialog.RSP.RSP37704.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.CreateForm(TFormHome, FormHome);
  Application.Run;

  // Disponibilizada por Dêividy Alcântara
  // https://github.com/deividyalcantara/show-message-fmx
  // https://www.linkedin.com/in/deividy-alcantara-590889177/
end.
