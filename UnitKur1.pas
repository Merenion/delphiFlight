unit UnitKur1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TFormKur1 = class(TForm)
    Button28: TSpeedButton;
    Button23: TSpeedButton;
    procedure Button1Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure Button28Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormKur1: TFormKur1;

implementation

uses UnitKur2, UnitKur3;

{$R *.dfm}

procedure TFormKur1.Button1Click(Sender: TObject);
begin
  FormKur2.Show;
end;

procedure TFormKur1.Button23Click(Sender: TObject);
begin
   FormKur2.Show;
end;

procedure TFormKur1.Button28Click(Sender: TObject);
begin
   if MessageDlg('Вы действительно хотите закончить работу?',
     mtConfirmation,[mbYes,mbNo],0)=mrYes then
     begin
       FormKur3.Button6Click(Sender);
       if MessageDlg('Записать измененные Исходные данные',
         mtConfirmation,[mbYes,mbNo],0)=mrYes then
         begin    
           Application.Terminate;
         end else Application.Terminate;
     end;
end;

end.
