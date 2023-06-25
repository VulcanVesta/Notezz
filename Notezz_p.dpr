program Notezz_p;

uses
  Vcl.Forms,
  Main_u in 'Main_u.pas' {frmMain},
  Notes_u in 'Notes_u.pas' {frmNotes};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmNotes, frmNotes);
  Application.Run;
end.
