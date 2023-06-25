unit Notes_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Imaging.jpeg, Vcl.Samples.Spin, Vcl.Imaging.pngimage, Vcl.ComCtrls,
  Vcl.Menus, Vcl.ActnMan, Vcl.ActnColorMaps, VCLTee.TeCanvas, Vcl.ColorGrd;

type
  TfrmNotes = class(TForm)
    pnlTools: TPanel;
    imgSave: TImage;
    pnlSave: TPanel;
    pnlExit: TPanel;
    imgExit: TImage;
    pnlFont: TPanel;
    pnlBold: TPanel;
    imgBold: TImage;
    pnlItalic: TPanel;
    imgItalic: TImage;
    pnlUnderline: TPanel;
    imgUnderline: TImage;
    pnlBigFont: TPanel;
    imgBigFont: TImage;
    spnSize: TSpinEdit;
    pnlSmallFont: TPanel;
    imgSmallFont: TImage;
    pnlColour: TPanel;
    imgColour: TImage;
    redNotes: TRichEdit;
    btnColor: TButtonColor;
    pnlAlignLeft: TPanel;
    imgAlignLeft: TImage;
    pnlAlignCenter: TPanel;
    imgAlignCenter: TImage;
    pnlAlignRight: TPanel;
    imgAlignRight: TImage;
    procedure FormCreate(Sender: TObject);
    procedure spnSizeChange(Sender: TObject);
    procedure imgBigFontClick(Sender: TObject);
    procedure imgSmallFontClick(Sender: TObject);
    procedure imgBoldClick(Sender: TObject);
    procedure pnlBigFontMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlBigFontMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlSmallFontMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlSmallFontMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgItalicClick(Sender: TObject);
    procedure imgUnderlineClick(Sender: TObject);
    procedure btnColorClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure imgAlignLeftClick(Sender: TObject);
    procedure imgAlignCenterClick(Sender: TObject);
    procedure imgAlignRightClick(Sender: TObject);
    procedure ClickBold;
    procedure ClickItalic;
    procedure ClickUnderline;
    procedure redNotesChange(Sender: TObject);
    procedure imgExitClick(Sender: TObject);
    procedure imgSaveClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { Private declarations }
    iSize: Integer;
    bChanged: boolean;
    bBoldClicked: boolean;
    bItalicClicked: boolean;
    bUnderClicked: boolean;
    sRecordName: string;
    bUpdated: boolean;      //Used to see if notes have been changed/needs to be saved
  public
    { Public declarations }
  end;

var
  frmNotes: TfrmNotes;

implementation

uses
  Main_u;

{$R *.dfm}

procedure TfrmNotes.btnColorClick(Sender: TObject);
begin
  redNotes.SelAttributes.Color := btnColor.SymbolColor;
  redNotes.SetFocus;
end;

procedure TfrmNotes.Button1Click(Sender: TObject);
begin
  redNotes.Lines.Add(redNotes.SelText);
end;

procedure TfrmNotes.FormCreate(Sender: TObject);
begin
  frmNotes.Parent := frmMain;
  spnSize.Value := redNotes.Font.Size;                 //12
  bChanged := False; // Prevents startup error

 frmNotes.Close;
 redNotes.Clear;
 spnSize.Value := 12;
 pnlBold.ParentBackground := False;
 pnlItalic.ParentBackground := False;
 pnlUnderline.ParentBackground := False;
 btnColor.SymbolColor := clBlack;
end;

procedure TfrmNotes.FormHide(Sender: TObject);
begin
 redNotes.Clear;
end;

procedure TfrmNotes.FormShow(Sender: TObject);
begin
  redNotes.SetFocus;
  bUpdated := False;
end;

procedure TfrmNotes.imgAlignLeftClick(Sender: TObject);
begin
  redNotes.Paragraph.Alignment := taLeftJustify;
end;

procedure TfrmNotes.imgAlignCenterClick(Sender: TObject);
begin
  redNotes.Paragraph.Alignment := taCenter;
end;

procedure TfrmNotes.imgAlignRightClick(Sender: TObject);
begin
  redNotes.Paragraph.Alignment := taRightJustify;
end;

// Font Size
procedure TfrmNotes.imgBigFontClick(Sender: TObject);
begin
  redNotes.SelAttributes.Size := redNotes.SelAttributes.Size + 1;
  spnSize.Value := redNotes.SelAttributes.Size;
end;

procedure TfrmNotes.imgSaveClick(Sender: TObject);
var
  NewFile: textfile;
  Textfiles: textfile;
  OldFile: textfile;
  iCount: Integer;
begin
  if frmMain.bNewRecord = True then
  begin
    sRecordName := InputBox('Name your record', 'Record name:', '');

    if sRecordName.Length < 1 then
    begin
      showmessage('PLease enter a valid name');
      exit;
    end;
    if FileExists(sRecordName + '.txt') then
    begin
      showmessage('A record with this name already exists');
      exit;
    end;

    Assignfile(NewFile, sRecordName + '.txt');
    Rewrite(NewFile);

    iCount := 0;
    while redNotes.Lines[iCount].Length > 0 do
    begin
      Writeln(NewFile, redNotes.Lines[iCount]);
      inc(iCount);
    end;

    Closefile(NewFile);

    if FileExists('Textfiles.txt') = True then
    begin
      Assignfile(Textfiles, 'Textfiles.txt');
    end
    else begin
     showmessage('File not found');
     exit;
    end;
    Append(Textfiles);
    Writeln(Textfiles, sRecordName + '.txt');
    Closefile(Textfiles);
    //allow saves after making new record
    frmMain.lbxRecords.AddItem(sRecordName + '.txt', nil);
    frmMain.bNewRecord := False;
  end // if
  else
  begin
    if frmMain.lbxRecords.ItemIndex = -1 then    //Saving newly added record
     begin
      Assignfile(OldFile, sRecordName + '.txt');
     end
     else begin   //aka saving record selected form listbox
      Assignfile(OldFile, frmMain.lbxRecords.Items[frmMain.lbxRecords.ItemIndex]);
     end;

    Rewrite(OldFile);

    iCount := 0;
    while redNotes.Lines[iCount].Length > 0 do
    begin
      Writeln(OldFile, redNotes.Lines[iCount]);
      inc(iCount);
    end;

    CloseFile(OldFile);
  end;

    end;

    procedure TfrmNotes.imgSmallFontClick(Sender: TObject);
    begin redNotes.SelAttributes.Size := redNotes.SelAttributes.Size - 1;
    spnSize.Value := redNotes.SelAttributes.Size; end;

    procedure TfrmNotes.spnSizeChange(Sender: TObject);
    begin redNotes.SelAttributes.Size := spnSize.Value;
    if bChanged = True then
    begin redNotes.SetFocus; end; bChanged := True;
    // Prevents startup error
    end;
    // .

    procedure TfrmNotes.imgBoldClick(Sender: TObject); begin ClickBold; end;

    procedure TfrmNotes.imgExitClick(Sender: TObject);
     begin
      if bUpdated = True then    //if havnt saved yet
       begin
        if MessageDlg('Would you like to save before leaving?', mtConfirmation, [mbYes, mbNo, mbCancel], 0) = mrYes then
         begin
          imgSaveClick(sender);
          frmNotes.Hide;
         end
         else if MessageDlg('Would you like to save before leaving?', mtConfirmation, [mbYes, mbNo, mbCancel], 0) = mrNo then
          begin
             frmNotes.Hide;
          end;
       end
       else begin
        frmNotes.Hide;  //if already saved
       end;
      end;

    procedure TfrmNotes.imgItalicClick(Sender: TObject);
    begin
    ClickItalic
    end;

    procedure TfrmNotes.imgUnderlineClick(Sender: TObject);
    begin
    ClickUnderline
    end;

    // Mouse Up/Down
    procedure TfrmNotes.pnlBigFontMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    begin pnlBigFont.ParentBackground := True; end;
    procedure TfrmNotes.pnlBigFontMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    begin pnlBigFont.ParentBackground := False; end;

    procedure TfrmNotes.pnlSmallFontMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    begin pnlSmallFont.ParentBackground := True; end;
    procedure TfrmNotes.pnlSmallFontMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    begin pnlSmallFont.ParentBackground := False; end;

    procedure TfrmNotes.redNotesChange(Sender: TObject);
    begin
    bUpdated:= True;
    if redNotes.SelAttributes.Style = [fsBold] then begin
    pnlBold.ParentBackground := True;
    end
    else if redNotes.SelAttributes.Style <> [fsBold] then
    begin
    pnlBold.ParentBackground := False;
    end;

    if redNotes.SelAttributes.Style = [fsItalic]
    then begin pnlItalic.ParentBackground := True;
    end else if redNotes.SelAttributes.Style <> [fsItalic]
    then begin pnlItalic.ParentBackground := False; end;

    if redNotes.SelAttributes.Style = [fsUnderline]
    then begin pnlUnderline.ParentBackground := True;
    end else if redNotes.SelAttributes.Style <> [fsUnderline]
    then begin pnlUnderline.ParentBackground := False; end;

    end;

    /// ////////////Custom Procedures/////////////////////
    procedure TfrmNotes.ClickBold;
    begin if bBoldClicked = False then begin redNotes.SelAttributes.Style :=
      [fsBold]; bBoldClicked := True; pnlBold.ParentBackground := True;
    end else begin redNotes.SelAttributes.Style := []; bBoldClicked := False;
    pnlBold.ParentBackground := False; end;

    bItalicClicked := False; pnlItalic.ParentBackground := False;

    bUnderClicked := False; pnlUnderline.ParentBackground := False; end;

    procedure TfrmNotes.ClickItalic;
    begin if bItalicClicked = False then begin redNotes.SelAttributes.Style :=
      [fsItalic]; bItalicClicked := True; pnlItalic.ParentBackground := True;
    end else begin redNotes.SelAttributes.Style := []; bItalicClicked := False;
    pnlItalic.ParentBackground := False; end;

    bBoldClicked := False; pnlBold.ParentBackground := False;

    bUnderClicked := False; pnlUnderline.ParentBackground := False; end;

    procedure TfrmNotes.ClickUnderline;
    begin if bUnderClicked = False then begin redNotes.SelAttributes.Style :=
      [fsUnderline]; bUnderClicked := True;
    pnlUnderline.ParentBackground := True;
    end else begin redNotes.SelAttributes.Style := []; bUnderClicked := False;
    pnlUnderline.ParentBackground := False; end;

    bBoldClicked := False; pnlBold.ParentBackground := False;

    bItalicClicked := False; pnlItalic.ParentBackground := False; end;

    end.
