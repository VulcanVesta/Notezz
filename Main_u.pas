unit Main_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Vcl.ComCtrls, Notes_u;

type
  TfrmMain = class(TForm)
    Image1: TImage;
    lblTitle: TLabel;
    lbxRecords: TListBox;
    lblRecall: TLabel;
    btnCreate: TButton;
    lblNote: TLabel;
    procedure btnCreateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lbxRecordsDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    bNewRecord: boolean;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.btnCreateClick(Sender: TObject);
begin
 frmNotes.Show;
 bNewRecord := True;
 lbxRecords.ItemIndex := -1;    //Incase a record is selected but not double-clicked
end;

procedure TfrmMain.FormCreate(Sender: TObject);
var
 Textfiles: Textfile;
 sLine: string;
 iCount: integer;
begin
 if FileExists ('Textfiles.txt') = True then
  begin
   Assignfile(Textfiles, 'Textfiles.txt');
  end
  else begin
   Showmessage('File no found');
   Exit;
  end;

 Reset(Textfiles);
 iCount := 1;
 while not EOF (Textfiles) do
  begin
   Readln(TextFiles, sLine);
    if FileExists(sLine) then
    begin
     lbxRecords.AddItem(sLine, nil);
    end;
  end;
 CLosefile(Textfiles);
end;

procedure TfrmMain.lbxRecordsDblClick(Sender: TObject);
 var
  tRecord: textfile;
  sLine: string;
  iCount: integer;
begin
 Assignfile(tRecord, lbxRecords.Items[lbxRecords.ItemIndex]);
 Reset(tRecord);
 iCount := 1;

 frmNotes.redNotes.Clear;
 while not EOF (tRecord) do
  begin
   Readln(tRecord, sLine);
   frmNotes.redNotes.Lines.Add(sLine);
   Inc(iCount);
  end;

 CloseFile(tRecord);

 frmNotes.Show;
 bNewRecord := False;
end;

end.
