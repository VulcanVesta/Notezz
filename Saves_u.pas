unit Saves_u;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.StdCtrls;

type
  TfrmSaves = class(TForm)
    Image1: TImage;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    lblRecall: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSaves: TfrmSaves;

implementation

{$R *.dfm}

end.
