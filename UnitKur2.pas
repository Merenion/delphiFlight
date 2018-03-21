unit UnitKur2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, ExtCtrls, Spin, jpeg, TeEngine, Series,
  TeeProcs, Chart, Math;

type
  TFormKur2 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label71: TLabel;
    Edit10: TEdit;
    Edit16: TEdit;
    Edit17: TEdit;
    Edit18: TEdit;
    Edit23: TEdit;
    CheckBox8: TCheckBox;
    Label15: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label9: TLabel;
    SpinEdit8: TSpinEdit;
    SpinEdit9: TSpinEdit;
    Label8: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Edit3: TEdit;
    Edit4: TEdit;
    Label10: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label18: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label72: TLabel;
    Edit24: TEdit;
    Edit25: TEdit;
    Button51: TButton;
    RadioGroup7: TRadioGroup;
    CheckBox11: TCheckBox;
    TabSheet9: TTabSheet;
    Button24: TSpeedButton;
    Button22: TSpeedButton;
    Button28: TSpeedButton;
    Edit2: TEdit;
    Label1: TLabel;
    PageControl2: TPageControl;
    TabSheet10: TTabSheet;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit4: TSpinEdit;
    SpinEdit5: TSpinEdit;
    Edit1: TEdit;
    TabSheet11: TTabSheet;
    Label7: TLabel;
    SpinEdit6: TSpinEdit;
    TabSheet12: TTabSheet;
    Label54: TLabel;
    Label55: TLabel;
    Label56: TLabel;
    SpinEdit13: TSpinEdit;
    SpinEdit14: TSpinEdit;
    Edit22: TEdit;
    TabSheet13: TTabSheet;
    Label16: TLabel;
    Label74: TLabel;
    SpinEdit11: TSpinEdit;
    SpinEdit18: TSpinEdit;
    RadioGroup4: TRadioGroup;
    Label29: TLabel;
    SpinEdit3: TSpinEdit;
    TabSheet14: TTabSheet;
    Image1: TImage;
    Image2: TImage;
    RadioGroup1: TRadioGroup;
    Label34: TLabel;
    Label35: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Label50: TLabel;
    Button36: TButton;
    Button35: TButton;
    Button29: TButton;
    Chart2: TChart;
    Series2: TLineSeries;
    Edit15: TEdit;
    Chart1: TChart;
    Series1: TLineSeries;
    Label51: TLabel;
    Label49: TLabel;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    TabSheet15: TTabSheet;
    Label17: TLabel;
    Edit13: TEdit;
    CheckBox9: TCheckBox;
    Label33: TLabel;
    Edit14: TEdit;
    Edit19: TEdit;
    Label36: TLabel;
    Label37: TLabel;
    Edit20: TEdit;
    Label38: TLabel;
    Edit21: TEdit;
    Edit26: TEdit;
    Edit27: TEdit;
    CheckBox10: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    Edit28: TEdit;
    PageControl3: TPageControl;
    TabSheet16: TTabSheet;
    TabSheet17: TTabSheet;
    Edit29: TEdit;
    CheckBox14: TCheckBox;
    CheckBox15: TCheckBox;
    Edit30: TEdit;
    Image3: TImage;
    TabSheet18: TTabSheet;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    PageControl4: TPageControl;
    TabSheet19: TTabSheet;
    TabSheet20: TTabSheet;
    Label42: TLabel;
    Edit33: TEdit;
    Edit32: TEdit;
    Edit31: TEdit;
    CheckBox16: TCheckBox;
    SpinEdit12: TSpinEdit;
    SpinEdit10: TSpinEdit;
    SpinEdit7: TSpinEdit;
    Label47: TLabel;
    Label46: TLabel;
    Label45: TLabel;
    Label44: TLabel;
    Label43: TLabel;
    Label32: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Image6: TImage;
    Image7: TImage;
    Label52: TLabel;
    SpinEdit15: TSpinEdit;
    Label53: TLabel;
    SpinEdit16: TSpinEdit;
    TabSheet21: TTabSheet;
    Label48: TLabel;
    SpinEdit17: TSpinEdit;
    Label57: TLabel;
    Label63: TLabel;
    SpinEdit19: TSpinEdit;
    TabSheet22: TTabSheet;
    Label64: TLabel;
    Label65: TLabel;
    SpinEdit20: TSpinEdit;
    Label67: TLabel;
    Edit34: TEdit;
    Label66: TLabel;
    Edit35: TEdit;
    Label68: TLabel;
    Edit36: TEdit;
    Image4: TImage;
    CheckBox17: TCheckBox;
    Edit37: TEdit;
    Label69: TLabel;
    Label70: TLabel;
    Label73: TLabel;
    Edit38: TEdit;
    Label75: TLabel;
    Edit39: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure Button24Click(Sender: TObject);
    procedure Button28Click(Sender: TObject);
    procedure Button39Click(Sender: TObject);
  
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var     
  FormKur2: TFormKur2;
  t_per_sr:real;
  t_per_sum:real;
  Dolgota_Sputn_Retr_1:real;//������� ������� �������� ������������� �1


procedure F_and_f_Periodichnoct;
procedure ID_Nadegnoct; //������ �������� ������ �� ����������
Procedure Oper__Sputn_Retr_1;//������������� � ������ �������� ������������� � 1
Procedure Nadegnoct;

implementation

uses UnitKur1, UnitKur3;

{$R *.dfm}

var
  Dispersija_Per:real;
  Flag_Nad_VRL:boolean;
  i:integer;
  j:integer;
  Summa_Rasnosti_Kvadratov_Per:real;
  SumPer:real;
  SrKvOtklonenie_Per:real;
  t_AC_sek:longInt; //����� ��������� �������������, ���
  t_sl_otk_VRL:longInt;  //����� ���������� ������ ���
  t_zadergki_VRL:integer;   //����� ������� (��������) ���

procedure TFormKur2.Button1Click(Sender: TObject);
begin
  FormKur1.Show;
end;


procedure F_and_f_Periodichnoct;   
  Var
    nIntPer:integer;
    mi:integer;
    BuferPer:real;
    F_Per:array[0..999] of real;
    mhf:array[0..999] of real;
    dnIntPer:real;

  begin
    if FormKur2.CheckBox1.Checked and FlagChas=true
      then FormKur2.Edit7.Text:=IntToStr(i_per);
    if FormKur2.CheckBox3.Checked and FlagMinut=true
      then FormKur2.Edit9.Text:=FloatToStr(t_per);

    t_per_sum:=0;
    //������ ���������� �������
    for i:=0 to i_per do
      t_per_sum:=t_per_sum+massiv_t_per[i];
      //������ ������� �������������
    if ((i_per>1)  and (FlagChas=true)) then
      begin
        t_per_sr:=t_per_sum/i_per;
        if FormKur2.CheckBox2.Checked then
          FormKur2.Edit8.Text:=FloatToStr(t_per_sr);
      end;

    if ((i_per>=1)  and (FlagSut=true)) then
      begin
        //������ ��������������������� ����������
        Summa_Rasnosti_Kvadratov_Per:=0;
        for i:=0 to i_Per-1 do Summa_Rasnosti_Kvadratov_Per:=
                   Summa_Rasnosti_Kvadratov_Per+sqr(massiv_t_per[i]-t_per_sr);
        if i_per>1 then Dispersija_Per:=Summa_Rasnosti_Kvadratov_Per/(i_Per-1);
        SrKvOtklonenie_Per:=sqrt(Dispersija_Per);
        if FormKur2.CheckBox6.Checked
          then FormKur2.Edit15.Text:=FloatToStrF(SrKvOtklonenie_Per,ffFixed,6,3);

        //���������� ��� ������� ������� ������������� ���������� �������������
        //��� ����� ���������� �����

        //���������� �������
        For j:=1 to i_Per do
          For i:=0 to i_Per-2 do
            if massiv_t_per[i] > massiv_t_per[i+1]
              then
                begin
                  BuferPer:=massiv_t_per[i];
                  massiv_t_per[i]:=massiv_t_per[i+1];
                  massiv_t_per[i+1]:=BuferPer;
                end;
        if FormKur2.CheckBox4.Checked
          then FormKur2.Edit11.Text:=FloatToStrF(massiv_t_per[0],ffFixed,6,3);
        if FormKur2.CheckBox5.Checked
          then FormKur2.Edit12.Text:=FloatToStrF(massiv_t_per[i_per-1],ffFixed,6,3);

        if FormKur2.CheckBox7.Checked then
          begin
            //������ ������� ������������� ���������� �������������
            For i:=0 to i_Per-1 do F_Per[i]:=(i+1)/(i_Per);
            //���������� ������� ������� �������������
            FormKur2.Chart1.SeriesList[0].Clear;
            For i:=0 to i_Per-1 do
            FormKur2.Chart1.SeriesList[0].AddXY(massiv_t_per[i],F_Per[i],'',clRed);

            //���������� ������ ��� ������� ��������� ����������� � �������
            //������������� ��� iRer>30;
            if ((i_Per>30) and (FlagSut=true)) then
              begin
                nIntPer:=trunc(5*ln(i_Per)/ln(10)); //����������� ���������� ����������
                //������ ���� �������:
                dnIntPer:=(massiv_t_per[i_Per-1]-massiv_t_per[0])/nIntPer;
                //������ ������� ��������� �� �������� �������
                for i:=0 to i_Per+2 do mhf[i]:=0; //��������� �������
                i:=0;      //��������� �������� ������ �������� ������� �������������
                j:=1;                       //��������� �������� ������ ���������
                while j<=nIntPer do         //���� ����� ��������� ������ �����������
                  begin
                    mi:=0;    //��������� �������� ���������� ��������� � ��������� j
                    while ((massiv_t_per[i]<massiv_t_per[0]+dnIntPer*j) and (i<i_Per-1)) do
                      begin
                        mi:=mi+1;
                        mhf[j]:=mi;     //���������� ��������� ������� � ��������� j
                        i:=i+1;         //������� � ������� �������� �������
                      end;
                    j:=j+1;             //������� � ������� ���������
                  end;

                //���������� ������� ��������� �������������
                FormKur2.Chart2.SeriesList[0].Clear;
                For i:=0 to nIntPer+1 do FormKur2.Chart2.SeriesList[0].AddXY((massiv_t_per[0]+
                dnIntPer*i),mhf[i]/((i_Per-1)*dnIntPer),'',clRed);
              end;
          end;
      end;
  end;

/////////////////////////////////////////////////////////////////////////////

Procedure ID_Nadegnoct; //������ �������� ������ �� ����������
  var
     Code:integer;
     t_AC_let:Integer; //����� ��������� �������������, ���
     P_VRL:real;       //���������� ���������� ��� �� ���� ��
     Lambda_VRL:real;  //������������� ������� ���;
     ksi_VRL:real;//���������� ��������� ����� � ����������� �������
                  //������������� �� ������� �� 0 �� 1

  begin
    //������ �� �� ������������� �������
    Val(FormKur2.Edit14.Text, t_AC_let, Code);            //���������� ������, ����
    if Code <> 0 then
      begin
        MessageDlg('����������� ������� �������� ����� �� ',
        mtWarning, [mbOk], 0);
        FormKur2.edit14.SetFocus;
      end;

    Val(FormKur2.Edit13.Text, P_VRL, Code);            //���������� ������, ����
    if Code <> 0 then
      begin
        MessageDlg('����������� ������� �������� ���������� ',
        mtWarning, [mbOk], 0);
        FormKur2.edit13.SetFocus;
      end;

    t_AC_sek:=t_AC_let*365*24*3600;
    Lambda_VRL:=-ln(P_VRL)/t_AC_sek;
    //������ ���������� ������� ������
    ksi_VRL:=random;
    Randomize;
    ksi_VRL:=random;
    t_sl_otk_VRL:=trunc(-ln(ksi_VRL)/Lambda_VRL);
    FormKur2.Edit19.Text:=FloatToStr(t_sl_otk_VRL);
    FormKur2.Edit20.Text:=FloatToStrF(t_sl_otk_VRL/(365*24*3600),ffFixed,6,3);
    if t_sl_otk_VRL >= t_AC_sek then
      begin
        //Flag_Nad_VRL_AC:=True;
        FormKur2.Edit21.Color:=clGreen;
        FormKur2.Edit21.Text:='�� �����';
      end;
    if t_sl_otk_VRL < t_AC_sek then
      begin
        //Flag_Nad_VRL_AC:=False;
        FormKur2.Edit21.Color:=clRed;
        FormKur2.Edit21.Text:='�����';
      end;
    Flag_Nad_VRL:=False;//��������� ��������
  end;

//////////////////////////////////////////////////////////////////////////////

Procedure Oper__Sputn_Retr_1;//������������� � ������ �������� ������������� � 1
  var
   Betta:real;//����������� ���� ����� �� ��� �� ���������
   gamma:real;//����������� ���� ����� �� �� �� ���������
   Lambda_B:real;//������� ����� �����, �������� �� ��������� � ������� ��
   alpha_SP:real;//���� ��������-������������� ��� ����������� ��������� ���
   Flag_Vid_CP_KAN:boolean;//���� ��������� �������� ������������� � ���
   L_CP_KAN:real;//���������� ����� �� � ���

  begin
    Betta:=arccos(Rs/r);
    gamma:=arcsin(Rs/rGSO);
    alpha_SP:=pi/2+gamma-Betta;

      //���� ������� ������� �������� ������������� �1
    if ((Dolgota_Sputn_Retr_1*pi/180>=0) and (Dolgota_Sputn_Retr_1*pi/180<=pi))
      //�� ������� �������� �����
      then Lambda_B:=Dolgota_Sputn_Retr_1*pi/180-pi;
    if ((Dolgota_Sputn_Retr_1*pi/180>-pi) and (Dolgota_Sputn_Retr_1*pi/180<0))
      //�� ������� �������� �����
      then Lambda_B:=pi+Dolgota_Sputn_Retr_1*pi/180;

    //������ ���������� ����� �� � ��
    L_CP_KAN:=50000;//����� ���� ���

    //������� ��������� ��� � ���� �����
    if ((L_CP_KAN>rGSO) and (abs(arccos(sin(0)*sin(Figa)
      +cos(0)*cos(Figa)*cos(LambdaGd-Lambda_B)))
      < alpha_SP))
      then
        begin
          Flag_Vid_CP_KAN:=False;
          {if FormKur2.CheckBox15.Checked then} FormKur2.Edit30.Text:='���'
        end
      else
         begin
           Flag_Vid_CP_KAN:=true;
           FormKur2.Edit30.Text:='��'
         end;
     

  end;


//////////////////////////////////////////////////////////////////////////////

Procedure Nadegnoct;//��������� ����� ����������
  var
    ksi_VRL_zadergki:real;    //���������� ��������� ����� � ����������� �������
                              //������������� �� ������� �� 0 �� 1
  begin
    //���� ������� ����� ����� ������� ������
    if t=t_sl_otk_VRL then
      begin
        randomize; //��������� ���������� ��������� �����
        ksi_VRL_zadergki:=random;
        randomize;  //���������� ��� ������ ���������� ��������� ����� �� �����
        ksi_VRL_zadergki:=random;
        //���������� ������� �������
        if ((ksi_VRL_zadergki>0) and (ksi_VRL_zadergki<=0.2))
          then  t_zadergki_VRL:=60000;
        if ((ksi_VRL_zadergki>0.2) and (ksi_VRL_zadergki<=0.5))
          then  t_zadergki_VRL:=300000;
        if ((ksi_VRL_zadergki>0.5) and (ksi_VRL_zadergki<=1))
          then  t_zadergki_VRL:=700000;
      end;
     //����� �����������
     If FormKur2.CheckBox10.Checked
       then FormKur2.Edit26.Text:=IntToStr(t_zadergki_VRL);

    if ((t>=t_sl_otk_VRL) and (t<=t_sl_otk_VRL+t_zadergki_VRL))
      then Flag_Nad_VRL:=False
        else Flag_Nad_VRL:=True;  
    //����� �����������
      If FormKur2.CheckBox12.Checked then
        begin
          if Flag_Nad_VRL=False then FormKur2.Edit27.Text:='�����';
          if Flag_Nad_VRL=True then FormKur2.Edit27.Text:='��� �������';
        end;
     If ((FormKur2.CheckBox13.Checked) and (t > t_sl_otk_VRL))
       then FormKur2.Edit28.Text:='���������';
  end;

//////////////////////////////////////////////////////////////////////////////





procedure TFormKur2.Button22Click(Sender: TObject);
begin
  FormKur1.Show;
end;

procedure TFormKur2.Button24Click(Sender: TObject);
begin
  FormKur3.Show;
end;

procedure TFormKur2.Button28Click(Sender: TObject);
begin
   if MessageDlg('�� ������������� ������ ��������� ������?',
     mtConfirmation,[mbYes,mbNo],0)=mrYes then
     begin
         FormKur3.Button6Click(Sender);
       if MessageDlg('�������� ���������� �������� ������',
         mtConfirmation,[mbYes,mbNo],0)=mrYes then
         begin
           Application.Terminate;
         end else Application.Terminate;
     end;
end;

procedure TFormKur2.Button39Click(Sender: TObject);
begin
    FormKur3.Button6Click(Sender);
end;


end.
