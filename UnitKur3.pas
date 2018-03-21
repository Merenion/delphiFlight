unit UnitKur3;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ComCtrls,  Dialogs, StdCtrls, Buttons, jpeg, ExtCtrls, Math, Menus;

type
  TFormKur3 = class(TForm)
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label48: TLabel;
    Label53: TLabel;
    Label30: TLabel;
    Label54: TLabel;
    Button2: TSpeedButton;
    Button4: TSpeedButton;
    Label58: TLabel;
    Label59: TLabel;
    Label61: TLabel;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    Button6: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    Image1: TImage;
    Edit1: TEdit;
    Label7: TLabel;
    CheckBox4: TCheckBox;
    Edit2: TEdit;
    CheckBox15: TCheckBox;
    Edit3: TEdit;
    Label2: TLabel;
    CheckBox16: TCheckBox;
    Edit4: TEdit;
    CheckBox17: TCheckBox;
    CheckBox18: TCheckBox;
    CheckBox19: TCheckBox;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Label3: TLabel;
    CheckBox6: TCheckBox;
    CheckBox20: TCheckBox;
    Edit8: TEdit;
    Edit9: TEdit;
    Button22: TSpeedButton;
    CheckBox21: TCheckBox;
    CheckBox22: TCheckBox;
    PopupMenu1: TPopupMenu;
    CheckBox23: TCheckBox;
    Edit10: TEdit;
    Label1: TLabel;
    CheckBox3: TCheckBox;
    Edit11: TEdit;
    Button1: TButton;
    Button5: TButton;
    CheckBox9: TCheckBox;

    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
   
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//  type
//    mp=array[0..999] of real;

var
  FormKur3: TFormKur3;
  Figa:real;         //Широта точки трассы полета
  Flag1:boolean;    //Флаг прерывания счета
  FlagSut:boolean;    //Событие наступления каждых суток полета
  FlagChas:boolean;    //Событие наступления каждого целого часа
  FlagVit:boolean;    //Событие наступления каждого начала витка полета КА
  FlagMinut:boolean;    //Событие наступления каждого начала витка полета КА
  i_per:integer;
  LambdaGd:real;             //Геодезическая широта подспутниковой точки 
  massiv_t_per:array[0..999] of real; //Массив периодичности
  r,                      //радиус-вектор орбиты
  t_per:real;//Переменная периодичности
  t_per_sr:real;//Среднее время оперативности   
  t_per_sum:real;//Суммарное время оперативности
  t:longint;        //Текущее время

const
  Rs=6371;                 {Радиус Земли, км}
  rGSO=42371;//Радиус геостационарной орбитыж
 
 //procedure F_and_f_Periodichnoct(massiv_t_per:mp);

implementation

uses UnitKur2;

{$R *.dfm}

//type
//    mp=array[0..999] of real;

const
//  Rs=6371;                 {Радиус Земли, км}
  ee=0.00006672;           {Квадратный км/кг в квадрате}
  my=398700;               {Кубический км/с в квадрате}
  dc=23.343*pi/180;        {Угол между эклиптикой и эквтором}
  OmegaSemli=0.0000729211; {Угловая скорость вращения Земли, рад/с}
  OmegaSolnza=0.000000199106;{Средняя скорость вращ. Земли вокруг Солнца, рад/c}

var
  //Глобальные переменные
  alfa_Obzor:real;    //Центральный угол Земли, соответствующий углу обзора КА
  alfa_Radio_Vidimost:real;   //Центральный угол Земли для зоны радиовидимости КА
  alfa_Svetovoe_Pjatno:real;  //Центральный угол Земли для светового пятна
  alfa_Ten_Semli:real;//Центральный угол пятна тени
  argperT0grad:real; //Аргумент перигея начальный
  argPer,         {Текущее значение аргумента перигея}
  Betta_konus_Vid_Semli:real;  //Угол полураствора конуса видимости Земли с КА

  cosA:real;//Значения текущего косинуса угла альфа
  cosA_sr:real;//Среднесуточное значение косинуса альфа
  Cos_Dolgota_Zenitn_Tochki:real;//Косинус широты зенитной точки поверхности Земли
  cos_ZD_S:real;//Косинус угла между вектором направления на Солнце
                //и вектором направления звёздного датчика (в базовой СК)

  Dolgota_Zentra_Teti:real;//Долгота центральной точки пятна тени
  Dolgota_Zenitn_Tochki:real;//Долгота зенитной точки поверхности Земли
  eHx,eHy,eHz:real;//Координаты единичного вектора оптической оси звёздн.датч-ка
//  Figa:real;                 {Широта точки трассы полета}
//  Flag1:boolean;    //Флаг прерывания счета
//  FlagSut:boolean;    //Событие наступления каждых суток полета
//  FlagChas:boolean;    //Событие наступления каждого целого часа
  FlagPerenazel:boolean;    //Событие наступления каждого начала перенацеливания
//  FlagVit:boolean;    //Событие наступления каждого начала витка полета КА
//  FlagMinut:boolean;    //Событие наступления каждого начала витка полета КА
  Flag_KA_v_Teni:boolean;  //КА в тени
  Flag_per1:boolean;  //Флаг нахождения ОН в зоне обзора КА
  Flag_SvetovoePjatno:boolean;//Флаг нахождения КА в световом пятне
  Flag_per1_1:boolean;  //Флаг первого попадания ОН в ону обзора КА
  GammaPanelSB:real;//Угол установки панели СБ
  Ha,              //Высота апогея орбиты
  Hp,              //Высота перигея орбиты
  H:real;         //ВЫсота полета КА
  hV:real;                   {Максимальный угол поворота КА относительно надира}
//  i_per:integer;//Переменная цикла для оперативности
  iGrad:real;           //Угол наклонения орбиты, град
  irad:real;           //Угол наклона плоскости орбиты, рад
//  i_per:integer; //Переменная в массиве периодичности
  k_konus_Vid_Semli:real; //Коэффициент в уравнении конуса видимости Земли с КА
  Koord_Fi_ObjektNabL:real;     //Геогрич. коорд. широты объекта наблюдения, град
  Koord_Ld_ObjektNabL:real;     //Геогрич. коорд. долготы объекта наблюдения, град
  kSB:real;            //Коэффициент незатенения солнечных батарей
//  LambdaGd:real;             //Геодезическая широта
//  massiv_t_per:mp; //Массив периодичности
  Nchas:integer;      //Число часов полета
  NSut_1:real;      {Число полных суток, прошедших с 21 марта (с начала полета)}
  Nvit:integer;   {Число полных витков, прошедших с начала полета (с 21 марта)}   
  Nchas_1,              //Количество целых часов полета минус единица
  Nzsut,                {Количество целых суток полета}
  Nvit_1:integer; //Предыдущее число полных витков, прошедших с начала полета (с 21 марта)}
  NMinut:integer; //Число полных минут, прошедших с начала полета (с 21 марта)}
  Nminut_1:integer; //Предыдущее число полных минут, прошедших с начала полета (с 21 марта)}
//  massiv_t_per:array[0..999] of real;
  Msr,            {Средняя аномалия}
  Msr1,                 {Приближение угла средней аномалии}
  nsr,                  {‘Среднее движение}
  Omega0grad,      //Долгота восходящего узла орбиты
  Omega0,         {Начальное значение угла восходящего узла орбиты}
  Omega:real;          {Текущий угол восходящего узла орбиты}
  ProisvSut,            {Суточная производительность КА}
  ProisvVit:integer;            {Производительность КА за виток}
//  r,                      //радиус-вектор орбиты
  Ra,                   {Радиус апогея орбиты}
  Rp,                   {Радиус перигея орбиты}
  sCxb,sCyb,sCzb: real;//Элементы матрицы направления на Солнце  в базовой СК КА
  sinLambda,            {Синус геодезической долготы}
  summacosa1,      {Сумма косинусов угла альфа, умноженная на приращение времени}
  summacosa2,      {Сумма косинусов угла альфа, умноженная на приращение времени} 
  sum_cosA:real;        //Сумма косинуса альфа (промежуточная переменная)
  sinTeta,cosTeta,{CСинус и косинус угла истинной аномалии}
  sinfiga,              {Синус геодезической широты}
  sinfi,                {Синус широты}
  sinL,                 {Синус долготы}
  Shirota_Zentra_Teti:real;//Широта точки центра теневого пятна на поверхности Земли
  Shirota_Zenitn_Tochki:real;//Широта зенитной точки поверхности Земли
  Sin_Dolgota_Zenitn_Tochki:real;//Косинус долготы зенитной точки поверхности Земли
//  t:longint;        //Текущее время
//  t_per:real;//Переменная периодичности
//  t_per_sr:real;//Среднее время оперативности
//  t_per_sum:real;//Суммарное время оперативности
  Teta:real;           {Угол истинной аномалии}
  TettaPanelSB:real;//Угол установки панели СБ по тангажу
  tetasb,tetasb1:real;  {Угол поворота панели СБ по крену}
  t0:longint;          //Начальное время расчета
  Tpsv,           {Период обращения звездный}
  Tpdr,           {Период обращения драконический}
  tsv:real;            {Звездное время}   
  tperigei,             {Время первого прохождения перигея}
  tsad,                 {Время задержки}
  u:real;                    {Аргумент широты}
  xR,
  yR,                {Вертикальная и горизонтальная оси эллипса обзора КА}
  Ygol_ZD_S:real;  //Угол между вектором направления на Солнце и вектором
                   //направления звёздного датчика
  x,y:integer; {Координты сетки экрана}
   xEkranKoordLdObjektNabL,  //Экранные координаты Х широты наблюдаемого объекта
  yEkranKoordFiObjektNabL:integer;  //Экранные координаты Y долготы наблюдаемого
                                    // объекта
//  i,
  j,k1:integer;
  yS:real;          //Минимальная высота Солнца над горизонтом для съемки, град         

  tngKA,                //Угол тангажа КА
  krnKA:real;           //Угол крена КА



//  i_per:integer;
//  t_per_sum:real;   
//  massiv_t_per:array[0..999] of real;



//  t_per_sr:real;
  Summa_Rasnosti_Kvadratov_Per:real;
  SumPer:real;
  Dispersija_Per:real;
  SrKvOtklonenie_Per:real;

  //Переменные по ИД звёздного датчика
  CosZD_alfaX_bCK:real;   //Косинусы угла альфа в баз. СК
  CosZD_alfaY_bCK:real;
  CosZD_alfaZ_bCK:real;
  //Угол  раствора конуса поля зрения оптического блока, град
  Ygol_kon_ZD_My:real;
  t_ZD:longint;//Время нахождения звёздного датчика в поле зрения звёзд
  t_otn_ZD:real;//Относительное время нахождения поля зрения звёздного датчика
                // на звёздном небе

  t_ZD_S:longint;//Время нахождения звёздного датчика в поле зрения звёзд
                 //без учёта экранирования Землёй
  t_otn_ZD_S:real;//Относительное время нахождения поля зрения звёздного датчика
                // на звёздном небе без учёта экранирования Землёй
  t_ZD_Z:longint;//Время нахождения звёздного датчика в поле зрения звёзд
                  //с экранированим Землёй без учёта засветки Солнцем
  t_otn_ZD_Z:real;//Относительное время нахождения поля зрения ЗДна звёздном
                  //небе с экранированим Землёй без учёта засветки Солнцем
  t_ZD_Z_S:real; //Время нахождения поля зрения ЗД на звёздном
                  //небе с экранированим Землёй и засветкой Солнцем
  t_otn_ZD_Z_S:real; //Относительное время нахождения поля зрения ЗД на звёздном
                     //небе с экранированим Землёй и засветкой Солнцем


{******************************************************************************}
// procedure  F_and_f_Periodichnoct(massiv_t_Per:mp);


procedure TFormKur3.Button1Click(Sender: TObject);
begin
  FormKur2.Show;
end;

procedure TFormKur3.Button2Click(Sender: TObject);  //Основная программа

var
  Sx,Sy,Sz:real;  //Проекции вектора S
  tN1:real;    //Вспомогательный параметр времени (для определения периодичности
  tN1_0:real;  //Вспомогательный параметр времени (время захвата первого ОН)
  t1:Integer;     {Начальное время разворота КА}
  Xga,            {Координата КА в абсолютной геоцентрической СК}
  Yga,            {Координата КА в абсолютной геоцентрической СК}
  Zga,            {Координата КА в абсолютной геоцентрической СК}
  a,              {Большая полуось орбиты}
  p,              {Фокальный параметр орбиты}
  dtsr,           {Промежуток среднего времени}
  Tpsv,           {Период обращения звездный}
  tsv,            {Звездное время}
  Nsut:real;      {Число полных суток, прошедших с 21 марта (с начала полета)}
  Msr,            {Средняя аномалия}
  ac,             {Угол между направлением на точку весенего равноденствия
                   и линией Земля-Солнце}
//  Omega0,         {Начальное значение угла восходящего узла орбиты}
//  Omega,          {Текущий угол восходящего узла орбиты}
  DeltaOmega,     {Приращение угла восходящего узла орбиты}
//  Teta,           {Угол истинной аномалии}
  Ea,             {Эксцентрическая аномалия}
  Ea0,            {Эксцентрическая аномалия, приведенная к одному витку}
  e,              {Эксцентриситет орбиты}
  argperT0,       {Начальное значение аргумента перигея}
//  argPer,         {Текущее значение аргумента перигея}
  dargper,        {Приращение значение аргумента перигея от векового возмущения}

  E01,E02,E03,E04,E05,  {Члены ряда разложения угла эксцентрической аномалии}
  Msr1,                 {Приближение угла средней аномалии}
  cosfiga,              {Косинус геодезической широты}
  Lambda,               {Геодезическая долгота}
  cosLambda,            {Косинус геодезической долготы}
  hS,                   {Угол между нормалью к поверхности Земли в точке надира
                         и направлением на Солнце}
  kMy,                  {Масштабный коэффициент по оси Y}
  kMx:real;                  {Масштабный коэффициент по оси X} 
  Npr:longint;                  {Производительность КА (количество отснятых объектов)}
  Zkx,Zky:integer;          //Координаты центра картинки
  kNO:integer;                 //Количество наблюдений объекта 
  KoordFiNPPI:real;            //Геогрич. коорд. широты НППИ
  KoordLdNPPI:real;            //Геогрич. коорд. долготы НППИ     
  dt:integer;            //Шаг расчета по времени   
//  iPeriodishnost:integer;   //Переменная массива периодичности без статиспытаний
  dl:real;//размер жлемента линейки ПЗС
  FocusZA:real;//Фокус ОЭТК
  ParOH:integer;//Количество пар элементов ПЗС, необходимое для идентификации объекта
  LineikaPZS:integer;  //Размер линейки ПЗС
  PerSRt: double;//Периодичность средняя (вспомогательная переменная)
  Tx1:string;
  iStringGrid:integer;//Переменная цикла захвата ОН методом статиспытаний
  hVgrad:integer;       //Угол наклона КА относительно надира (максимальный)
  nPNZ:integer;     //Количество циклов перенацеливания
  nPNZ_1:integer;   //Количество циклов перенацеливания предыдущее
  tPNZ:integer;     //Время перенацеливния

  //Радиатор охлаждения
  v1_RO:integer;//Начальный угол геометрии радиатора охлаждения (РО), град (схема 1)
  v2_RO:integer;//Конечный угол геометрии радиатора охлаждения, град  (схема 1)
  m_RO:integer;//Количество элементов разбиения РО по окружности
  k_RO:integer;//Количество элементов разбиения РО по высоте
  t_RO_Solnze:Extended;        //Время нахождения РО на Солнце
  r_RO_1:real;//Радиус панели радиатора охлаждения
  r_RO_2:real;//Радиус панели радиатора охлаждения
  my_RO:real;//Угол полураствора конуса корпуса КА
  L_RO:real;//Высота панели радиатора охлаждения
  F_RO:real;//Площадь поверхности панели радиатора охлаждения
  F_ij_RO:real;//Площадь элементарной площадки радиатора охлаждения
  F_Eff_RO_otn:real;//Эффективная относительная площадь РО
  t_RO_Solnze_otn:real;  //Осредённое относительное время действия Солнца на РО
  krnKA_RO,tngKA_RO:real;//Углы поворота КА при перенацеливании

////////////////////////////////////////////////////////////////////////////////

Procedure  VVodID;        {Ввод исходных данных}
  var
    code:integer;

  begin
    t0:=StrToInt(FormKur2.SpinEdit6.Text);          //Начальное время расчета
    dt:=1;                                            //Шаг расчета по времени
    Hp:=StrToFloat(FormKur2.SpinEdit1.Text);          //Высота перигея орбиты
    Ha:=StrToFloat(FormKur2.SpinEdit2.Text);          //Высота апогея
    Omega0grad:=StrToFloat(FormKur2.SpinEdit4.Text);  //Долгота восходящего узла
    Omega0:=Omega0grad*pi/180;                    //Пересчет градусов в радианы
    argperT0Grad:=StrToFloat(FormKur2.SpinEdit5.Text);//Начальный аргумент перигея
    argperT0:=argperT0grad*pi/180;                 //Пересчет градусов в радианы
    tperigei:=0;                             //Время первого прохождения перигея
    t:=t0;                                                     //Начальное время
    Val(FormKur2.Edit1.Text, Igrad, Code);            //Наклонение орбиты, град
    if Code <> 0 then
      begin
        MessageDlg('неправильно введено значение угла наклонения ',
        mtWarning, [mbOk], 0);
        FormKur2.edit1.SetFocus;
      end;
    irad:=igrad*pi/180;                          //Пересчет градусов в радианы
    yS:=StrToFloat(FormKur2.SpinEdit18.Text);//Минимальный угол Солнца над горизонтом

    Val(FormKur2.Edit2.Text, kSb, Code);    //Ввод коэффициента незатенения СБ
    if Code <> 0 then
      begin
        MessageDlg('неправильно введено значение коэфициента' , mtWarning, [mbOk], 0);
        FormKur2.edit2.SetFocus;
      end;
    Zkx:=510;  Zky:=360; //Координаты центра графика
    kMx:=2.7;
    kMy:=kMx;          //Масштабный коэффициент по осям Y и X равны
    hS:=pi/2-yS*pi/180;                      //Угол между направлением на Солнце
                                             //и направлением в зенит
    t1:=0;                {Начальное время разворота КА в каждом цикле}

    k1:=1;                {Циклы изменения временит}
    summacosa1:=0;         //Начальное значение суммыкосинусов угла альфа,
                          //умноженной на приращение времени
    summacosa2:=0;         //Начальное значение суммыкосинусов угла альфа,
                          //умноженной на приращение времени
    LambdaGd:=0;
    ProisvSut:=450;

    // Ввод ИД по по максимальному углу отклонения оптической оси КА от надира
    Val(FormKur2.SpinEdit11.Text, hVgrad, Code);
    if Code <> 0 then
      begin
        MessageDlg('неправильно введено значение ',
        mtWarning, [mbOk], 0);
        FormKur2.SpinEdit11.SetFocus;
      end;
//    hVgrad:=StrToInt(FormKur2.SpinEdit11.Text);
    //Максимальный угол отклоения КА от надира, рад
    hV:=hVgrad*pi/180;
    ProisvVit:=trunc(ProisvSut/14);
    Npr:=0;
    Val(FormKur2.Edit3.Text, KoordFiNPPI, Code);    //Установка координат НППИ
      if Code <> 0 then
        begin
          MessageDlg('Ошибка ввода' , mtWarning, [mbOk], 0);
          FormKur2.edit3.SetFocus;
        end;
    Val(FormKur2.Edit4.Text, KoordLdNPPI, Code);    //Установка координат НППИ
      if Code <> 0 then
        begin
          MessageDlg('Ошибка ввода' , mtWarning, [mbOk], 0);
          FormKur2.edit4.SetFocus;
        end;

      //Установка координат единичного объект наблюдения, град
      //Геогрич. коорд. широты объекта наблюдения, град
      Val(FormKur2.Edit5.Text, Koord_Fi_ObjektNabL, Code);
      if Code <> 0 then
        begin
          MessageDlg('Ошибка ввода' , mtWarning, [mbOk], 0);
          FormKur2.edit5.SetFocus;
        end;
      //Геогрич. коорд. долготы объекта наблюдения, град
      Val(FormKur2.Edit6.Text, Koord_Ld_ObjektNabL, Code);
      if Code <> 0 then
        begin
          MessageDlg('Ошибка ввода' , mtWarning, [mbOk], 0);
          FormKur2.edit6.SetFocus;
        end;

    dl:=StrToInt(FormKur2.SpinEdit14.Text);           //Размер элементарного
    Val(FormKur2.SpinEdit14.Text, FocusZA, Code);     //приемника линейки ПЗС
    if Code <> 0 then
      begin
        MessageDlg('неправильно введено значение фокусного расстояния ',
        mtWarning, [mbOk], 0);
        FormKur2.SpinEdit14.SetFocus;
      end;
    Val(FormKur2.SpinEdit3.Text, tPNZ, Code);     //Время перенацеливания
    if Code <> 0 then
      begin
        MessageDlg('неправильно введено значение ',
        mtWarning, [mbOk], 0);
        FormKur2.SpinEdit3.SetFocus;
      end;

    // Ввод ИД по параметрам объекта наблюдения
    //Количество пар элементов ПЗС, необходимое для идентификации объекта
    If FormKur2.RadioGroup4.ItemIndex=0 then  ParOH:=1;
    If FormKur2.RadioGroup4.ItemIndex=1 then  ParOH:=2;
    If FormKur2.RadioGroup4.ItemIndex=2 then  ParOH:=3;
     // Ввод ИД по размеру линейки ПЗС
    LineikaPZS:=StrToInt(FormKur2.SpinEdit13.Text);

    kNO:=0;//Количество ОН, захваченных КА
//    iPeriodishnost:=0;                   //ПНачальное значение еременной массива
                                         //периодичности без статиспытаний
    tN1:=0;    //Вспомогательный параметр времени для определения периодичности
    tN1_0:=0;  //Вспомогательный параметр времени (время захвата первого ОН)
    tN1:=0;                     //Начальные значение вспомогательного параметра
                                //времени для расчета периодичности
    tN1_0:=0;         //Начальные значения вспомогательного параметра времени
                      //для расчета захвата первого вхождения ОН в зону обора КА
    PerSRt:=0;                  //Начальноее значение периодичности средней
    iStringGrid:=1; //Начальноее значение переменной цикла расчета периодичности
                    //попадания ОН в зону обзора КА методом статиспытаний

    //Ввод ИД по спутнику -ретранслятору, град
    Val(FormKur2.Edit29.Text, Dolgota_Sputn_Retr_1, Code);
    if Code <> 0 then
      begin
        MessageDlg('неправильно введено значение ',
        mtWarning, [mbOk], 0);
        FormKur2.edit29.SetFocus;
      end;

    tngKA:=0;           //Начальные значения угла тангажа КА, рад
    krnKA:=0;           //Начальные значения угла крена КА, рад
    cosA_sr:=0;//Средний косинус

  end;

////////////////////////////////////////////////////////////////////////////

Procedure  Vvod_ID_ZD;//Вводи ИД по звёздным датчикам
  var
    code:integer;
  begin
    //Косинус угла альфаX в баз. СК
    Val(FormKur2.Edit34.Text, CosZD_alfaX_bCK, Code);
    if Code <> 0 then
      begin
        MessageDlg('неправильно введено значение',
        mtWarning, [mbOk], 0);
        FormKur2.edit34.SetFocus;
      end;
    //Косинус угла альфаY в баз. СК
    Val(FormKur2.Edit35.Text, CosZD_alfaY_bCK, Code);
    if Code <> 0 then
      begin
        MessageDlg('неправильно введено значение',
        mtWarning, [mbOk], 0);
        FormKur2.edit35.SetFocus;
      end;
      //Расчёт третьего косинуса
      CosZD_alfaZ_bCK:=sqrt(1-sqr(CosZD_alfaX_bCK)-sqr(CosZD_alfaY_bCK));
      //Вывод в окно Edit
      FormKur2.Edit36.Text:=FloatTostr(CosZD_alfaZ_bCK);
      //Ввод угла  раствора конуса поля зрения оптического блока, град
      Ygol_kon_ZD_My:=StrToFloat(FormKur2.SpinEdit20.Text);

      //Расчёт коэффициента уравнения конуса видимости Земли с КА
     Betta_konus_Vid_Semli:=arcsin(Rs/(Rs+h));
     k_konus_Vid_Semli:=1/tan(Betta_konus_Vid_Semli);
      t_ZD:=0;//Обнуление переменной относительного времени нахождения
              //звёздного датчика на звёздном небе
    t_ZD_Z_S:=0;
    t_ZD_Z:=0;
  end;

{******************************************************************************}  

 Procedure  RashetPorb; //Расчет начальных параметров орбиты}
  begin
    Ra:=Rs+Ha;                       //Радиус апогея
    Rp:=Rs+Hp;                       //радиус перигея
    e:=(Ra-Rp)/(Ra+Rp);              //Эксцентриситет орбиты
    a:=(Rp+Ra)/2;                    //Большая полурсь
    p:=a*(1-sqr(e));                 //Расчет фокального параметра орбиты
    r:=p/(1+e*cos(teta));            //Радиус-вектор КА (от центра Земли)
    H:=r-Rs;                         //Высота полета КА
    Tpsv:=2*pi*sqrt(a*a*a/my);       //Период обращения звездный      
    //Расчет векового возмущения первого порядка
    DeltaOmega:=-35.052/60*pi/180*sqr(Rs/p)*cos(irad);
    //Расчет векового возмущения аргумента перигея орбиты первого порядка
    dargper:=-17.526/60*pi/180*sqr(Rs/p)*(1-5*sqr(cos(irad)));
  end;

{******************************************************************************}

  Procedure  RashetPorbTek; //Расчет текущих значений параметров орбиты
  begin
      //Текущий угол восходящего узла орбиты, рад
     Omega:=Omega0{*pi/180}+t/Tpsv*DeltaOmega;
     //Текущее значение аргумента перигея, рад
     argPer:=argperT0*pi/180+t/Tpsv*dargper;
     nsr:=sqrt(my/(a*a*a));               //Определение среднего движения nsr
     dtsr:=t-tperigei;       //Определение промежутка среднего времени с момента
                             //прохождения перигея до момента наблюдения
     tsv:=1.00273791*dtsr;                //Определение звездного времени
     Msr:=tsv*nsr;                        //Определение средней аномалии
     //Определение эксцентрической аномалии с помощью ряда разложения
     E01:=Msr+e*sin(Msr)+(e*e/2)*sin(2*Msr);  //Первый член разложения уравнения
                                              //Кеплера (E-e*sin(E)=M
     E02:=e*e*e/24*(9*sin(3*Msr)-3*sin(Msr)); //Второй член разложения и т.д.
     E03:=e*e*e*e/(24*8)*(64*sin(4*Msr)-32*sin(2*Msr));
     E04:=e*e*e*e*e/(120*16)*(625*sin(5*Msr)+5*81*sin(3*Msr)+10*sin(Msr));
     E05:=e*e*e*e*e*e/(720*32)*(36*36*6*sin(6*Msr)
         -6*256*4*sin(4*Msr)+15*32*sin(2*Msr));
     Ea:=E01+E02+E03+E04+E05;     //Эксцентрическая аномалия
     Ea0:=Ea-2*Pi*trunc(Ea/(2*Pi));                 //Эксцентрическая аномалия,
                                                    //приведенная к одному витку
     //Расчет синуса и косинуса угла истинной аномалии
     sinTeta:=sqrt(1-e*e)*sin(Ea)/(1-e*cos(Ea));
     cosTeta:=(cos(Ea)-e)/(1-e*cos(Ea));
     //Расчет угла истинной аномалии, рад
     teta:=arctan(sqrt(1-sqr(cosTeta))/cosTeta);
       If (sinTeta>0) and (cosTeta<0) then Teta:=Teta+Pi;
       If (sinTeta<0) and (cosTeta<0) then Teta:=Pi-Teta;
       If (sinTeta<0) and (cosTeta>0) then Teta:=2*Pi-Teta;
  end;

////////////////////////////////////////////////////////////////////////////////

{Определениен координат КА в абсолютной геоцентрической СК (переход от оскулирующей СК)}
Procedure  KoordKAxyzGa;
  begin
    Xga:=r*(cos(Omega)*cos(u)-sin(Omega)*sin(u)*cos(irad));
    Yga:=r*(sin(Omega)*cos(u)+cos(Omega)*sin(u)*cos(irad));
    Zga:=r*sin(u)*sin(irad);
  end;

{******************************************************************************}

Procedure VS;   {Вычисление проекции вектора S в неподвижной геоцентрической СК}
  begin
      ac:=2*pi*t/(365*24*3600);{Nsut/365;}
      Sx:=cos(ac);
      Sy:=sin(ac)*cos(dc);
      Sz:=sin(ac)*sin(dc);
  end;

{******************************************************************************}

Procedure GeogrKoord;      {Расчет географических координат трассы полета КА}
  label 1;
  begin
      u:=argPer+teta;                               //Расчет аргумента широты
    {Расчет широты и долготы (старая версия)}
    sinfiga:=sin(irad)*sin(u);
    cosfiga:=sqrt(1-sqr(sinfiga));
    figa:=arctan(sinfiga/sqrt(1-sqr(sinfiga)));
    sinLambda:=(sin(Omega)*cos(u)+cos(Omega)*cos(irad)*sin(u))/cos(figa);
    cosLambda:=(cos(Omega)*cos(u)-sin(Omega)*cos(irad)*sin(u))/cos(figa);
    if (sinLambda>0) and (cosLambda>0) then
       Lambda:=arctan(sinLambda/sqrt(1-sqr(sinLambda)));
    if (sinLambda>0) and (cosLambda<0) then
       Lambda:=pi+arctan(sqrt(1-sqr(cosLambda))/cosLambda);
    if (sinLambda<0) and (cosLambda<0) then
       Lambda:=pi-arctan(sinLambda/sqrt(1-sqr(sinLambda)));
    if (sinLambda<0) and (cosLambda>0) then
       Lambda:=-arctan(sqrt(1-sqr(cosLambda))/cosLambda);
LambdaGd:=Lambda-OmegaSemli*(t-(24*3600)*trunc(t/(24*3600)))-t/Tpsv*deltaOmega;
    if lambdaGd<-pi then LambdaGd:=LambdaGd+2*pi;
    if lambdaGd<-pi then LambdaGd:=LambdaGd+2*pi;    //Повтор сдвига
    if lambdaGd>pi then LambdaGd:=LambdaGd-2*pi;
    if lambdaGd>pi then LambdaGd:=LambdaGd-2*pi;     //Повтор сдвига
    if lambdaGd>pi then LambdaGd:=LambdaGd-2*pi;     //Повтор сдвига
    if lambdaGd>pi then LambdaGd:=LambdaGd-2*pi;     //Повтор сдвига
  end;

{******************************************************************************}

Procedure RisTrassa;            //Процедура прорисовки трассы КА
  begin;
    //Расчет текущих координат трассы на карте часовых поясов
    x:=ZkX+trunc(kMx*LambdaGd*180/pi);
    y:=ZkY-trunc(kMy*fiGa*180/pi);
    //Прорисовка трассы
      begin
        FormKur3.Canvas.Pen.Width:=2;
        FormKur3.Canvas.Pen.Color:=ClAqua;
        FormKur3.Canvas.MoveTo(x,y);
        FormKur3.Canvas.LineTo(x,y);
      end;
  end;

{******************************************************************************}

Procedure   Vivod_Resultatov_Rascheta;     //Вывод результатов расчета на формы
  begin
    //Если включена галочка, то:
    if FormKur3.CheckBox1.Checked then RisTrassa;        //Прорисовки трассы КА

    if checkBox5.Checked then  Edit1.Text:=IntToStr(t);//Вывод времени полета, с
    if checkBox16.Checked and FlagMinut then Edit4.Text:=IntToStr(Trunc(t/60));       //Минут
    if checkBox17.Checked and FlagChas=true then Edit5.Text:=IntToStr(Trunc(t/3600)); //Часов

    if checkBox18.Checked and FlagChas then Edit6.Text:=IntToStr(Trunc(t/Tpsv));     //Витков
    if checkBox19.Checked and FlagSut then Edit7.Text:=IntToStr(Trunc(t/(24*3600))); //Суток

    if checkBox4.Checked then  Edit2.Text:=FloatTostr(argPer/pi*180);//Аргумент перигея
    if checkBox15.Checked then Edit3.Text:=FloatTostr(teta/pi*180);//Угол ист.аном.

    if checkBox6.Checked then Edit8.Text:=FloatTostr(figa/pi*180);//Угол широты, град
    if checkBox20.Checked then Edit9.Text:=FloatTostr(LambdaGd/pi*180);//Угол олготы, град
  end;

/////////////////////////////////////////////////////////////////////////////////

Procedure Ris_Krug_alfa_Zemli(alfa,shirota,dolgota:real;Width_Lin:integer);
//Прорисовка круга на поверхности Земли, соотвтествующего центральному углу альфа
  var
    Sirota_Graniza_kruga:real;//Текущая широта точек границы круга
    Dolgota_Graniza_kruga:real;//Текущая долгота точек границы круга
    Sin_Sirota_Graniza_kruga:real;//Синус текущаей широты точек границы круга
    Sin_Dolgota_Graniza_kruga:real;//Синус текущей долготы точек границы круга
    Cos_Dolgota_Graniza_kruga:real;//Косинус текущей долготы точек границы круга
    x_Graniza_kruga:integer;           //Текущие координаты границы зоны захвата
    y_Graniza_kruga:integer;           //Текущие координаты границы зоны захвата
    x_Graniza_kruga_1:integer;//Вспомогательная перемкнная для "пррыжков" пера
    y_Graniza_kruga_1:integer;//Вспомогательная перемкнная для "пррыжков" пера
    betta:real;    //Вспомогательный угол бетта для прорисовки границы круга
    ibetta:integer;  //Переменная цикла по углу бетта

  begin
    FormKur3.Canvas.Pen.Width:=Width_Lin;
    FormKur3.Canvas.MoveTo(x_Graniza_kruga,y_Graniza_kruga);
    //Расчет текущих координат границы зоны захвата
    betta:=0;
    for ibetta:=0 to 72 do
      begin
       if (cos(Sirota_Graniza_kruga)>0.0001) or (cos(Sirota_Graniza_kruga)<-0.0001) then
         begin
           Sin_Sirota_Graniza_kruga:=cos(alfa)*sin(shirota)-sin(alfa)*sin(betta)*cos(shirota);
           Sirota_Graniza_kruga:=arcsin( Sin_Sirota_Graniza_kruga);
           Sin_Dolgota_Graniza_kruga:=(cos(alfa)*cos(shirota)*sin(dolgota)
                      +sin(alfa)*sin(betta)*sin(shirota)*sin(dolgota)
                      -sin(alfa)*cos(betta)*cos(dolgota))/cos(Sirota_Graniza_kruga);
           Cos_Dolgota_Graniza_kruga:=(cos(alfa)*cos(shirota)*cos(dolgota)
                     +sin(alfa)*sin(betta)*sin(shirota)*cos(dolgota)
                     +sin(alfa)*cos(betta)*sin(dolgota))/cos(Sirota_Graniza_kruga);
         end;
       if (Sin_Dolgota_Graniza_kruga>1) then  Sin_Dolgota_Graniza_kruga:=1;
       if (Sin_Dolgota_Graniza_kruga<-1) then  Sin_Dolgota_Graniza_kruga:=-1;
       if (Cos_Dolgota_Graniza_kruga>1) then  Cos_Dolgota_Graniza_kruga:=1;
       if (Cos_Dolgota_Graniza_kruga<-1) then Cos_Dolgota_Graniza_kruga:=-1;

       if (Sin_Dolgota_Graniza_kruga>0) and (Cos_Dolgota_Graniza_kruga>0)
         then Dolgota_Graniza_kruga:=arcsin(Sin_Dolgota_Graniza_kruga);
       if (Sin_Dolgota_Graniza_kruga>0) and (Cos_Dolgota_Graniza_kruga<0)
         then Dolgota_Graniza_kruga:=pi-arcsin(Sin_Dolgota_Graniza_kruga);
       if (Sin_Dolgota_Graniza_kruga<0) and (Cos_Dolgota_Graniza_kruga<0)
         then Dolgota_Graniza_kruga:=-pi-arcsin(Sin_Dolgota_Graniza_kruga);
       if (Sin_Dolgota_Graniza_kruga<0) and (Cos_Dolgota_Graniza_kruga>0)
         then Dolgota_Graniza_kruga:=arcsin(Sin_Dolgota_Graniza_kruga);

       //Расчет текущих координат трассы на карте часовых поясов
       x_Graniza_kruga:=510+trunc(kMx*Dolgota_Graniza_kruga*180/pi);
       y_Graniza_kruga:=363-trunc(kMy*Sirota_Graniza_kruga*180/pi);

       //Прорисовка текущих координат границы зоны захвата
       //Проверки перепрыгивания по x и по y
       if (abs(x_Graniza_kruga-x_Graniza_kruga_1)>trunc(kMx*90))
          or (abs(y_Graniza_kruga-y_Graniza_kruga_1)>trunc(kMy*90))
         then  FormKur3.Canvas.MoveTo(x_Graniza_kruga,y_Graniza_kruga);
       FormKur3.Canvas.LineTo(x_Graniza_kruga,y_Graniza_kruga);

         //Расчет вершин многоугольника для закрашивания
       betta:=betta+2*pi/72;    //Приращение угла бетта

       //Переприсваивание координаты для проверки перепрыгивания
       //при рисовании графика с одной стороны на другую
       x_Graniza_kruga_1:=x_Graniza_kruga;
       y_Graniza_kruga_1:=y_Graniza_kruga;
     end;
  end;

/////////////////////////////////////////////////////////////////////////////////

Procedure Ris_Objekt_Nabl;                       //Прорисовка объекта наблюдения
  begin
    FormKur3.Canvas.Pen.Width:=2;
    FormKur3.Canvas.Pen.Color:=ClRed;

    //Расчет экранных коорд. широты, град
    xEkranKoordLdObjektNabL:=510+trunc(kMx*Koord_Ld_ObjektNabL);

    //Расчет экранных коорд. долготы, град
    yEkranKoordFiObjektNabL:=363-trunc(kMy*Koord_Fi_ObjektNabL);
    FormKur3.Canvas.Ellipse(xEkranKoordLdObjektNabL-5,yEkranKoordFiObjektNabL-5,
                  xEkranKoordLdObjektNabL+5,yEkranKoordFiObjektNabL+5);
  end;

/////////////////////////////////////////////////////////////////////////////////

//Процедура выделения событий о целом количестве суток, витков,часов, минут,
//времени перенацеливания и времени перересовывания
Procedure Rashet_Kol_Zel_Min_Chas_Sut_Vit_Perenazel_Pereris;
  begin
    //Минуты
    FlagMinut:=False;      //Событие наступления каждой минуты
    NMinut:=trunc(t/60);  //Целое количество минут с начала полета (с 21 марта)

    if Nminut=Nminut_1+1 then   //Если число минут прибавляется на единицу
      begin
        Nminut_1:=Nminut;
        FlagMinut:=true;   //Событие наступления каждой минуты
      end;

    //Часы
    FlagChas:=False;      //Событие наступления каждого целого часа
    Nchas:=trunc(t/3600);  //Целое количество витков с начала полета (с 21 марта)
    if Nchas=Nchas_1+1 then   //Если число витков прибавляется на единицу
      begin
        Nchas_1:=Nchas;
        FlagChas:=true;   //Событие наступления каждого целого часа
      end;

    //Витки
    FlagVit:=False;      //Событие наступления каждого целого часа
    Nvit:=trunc(t/Tpsv);  //Целое количество витков с начала полета (с 21 марта)
    if Nvit=Nvit_1+1 then   //Если число витков прибавляется на единицу
      begin
        Nvit_1:=Nvit;
        FlagVit:=true;   //Событие наступления каждого целого часа
      end;

     //Сутки   FlagSut
    FlagSut:=False;      //Событие наступления каждого целого часа
    NSut:=trunc(t/(24*3600));  //Целое количество витков с начала полета (с 21 марта)
    if NSut=NSut_1+1 then   //Если число витков прибавляется на единицу
      begin
        NSut_1:=NSut;
        FlagSut:=true;   //Событие наступления каждого целого часа
      end;   

    //Время перенацеливания
    FlagPerenazel:=False;   //Событие наступления каждого начала перенацеливания
    nPNZ:=trunc(t/tPNZ);
    if nPNZ=nPNZ_1+1 then   //Если начало перенацеливания
      begin
        nPNZ_1:=nPNZ;
        FlagPerenazel:=true;   //Событие наступления каждого целого часа
      end;
   end;

////////////////////////////////////////////////////////////////////////////////

//Процедура расчета координат единичного вектора направлени на Солнце
//в неподвижной геоцентрической системе координат
Procedure Rashet_Ed_Vekt_Napravl_Na_Solnz_V_Nepodv_Sist_Koord;
  begin
    //Расчет угла между направлением на точку весеннего равноденствия
    // и направлением на Солнце
    ac:=2*pi/(365.2422*24*3600)*t;

    //Расчет проекций вектора
    Sx:=cos(ac);
    Sy:=sin(ac)*cos(dc);
    Sz:=sin(ac)*sin(dc);

    //Расчет координат центра светового пятна
    // Расчет широты точки поверхности Земли, в которой Солнце нахдится в зените
    Shirota_Zenitn_Tochki:=arcsin(Sz);                                                //Ранее была ошибка arctan(Sz) (Науменко);

   // Расчет долготы точки поверхности Земли, в которой Солнце нахдится в зените
    Cos_Dolgota_Zenitn_Tochki:=Sx/cos(Shirota_Zenitn_Tochki);
    Sin_Dolgota_Zenitn_Tochki:=Sy/cos(Shirota_Zenitn_Tochki);

    //Предожранение от неточностей расчета
    if (Sin_Dolgota_Zenitn_Tochki>1)  then  Sin_Dolgota_Zenitn_Tochki:=1;
    if (Sin_Dolgota_Zenitn_Tochki<-1) then  Sin_Dolgota_Zenitn_Tochki:=-1;
    if (Cos_Dolgota_Zenitn_Tochki>1)  then  Cos_Dolgota_Zenitn_Tochki:=1;
    if (Cos_Dolgota_Zenitn_Tochki<-1) then  Cos_Dolgota_Zenitn_Tochki:=-1;

    //Определение квадранта, в котором находится Зенитна точка
    //в неподвижной системе координат
    if (Sin_Dolgota_Zenitn_Tochki>0) and (Cos_Dolgota_Zenitn_Tochki>0)
       then Dolgota_Zenitn_Tochki:=arcsin(Sin_Dolgota_Zenitn_Tochki);
    if (Sin_Dolgota_Zenitn_Tochki>0) and (Cos_Dolgota_Zenitn_Tochki<0)
       then Dolgota_Zenitn_Tochki:=pi-arcsin(Sin_Dolgota_Zenitn_Tochki);
    if (Sin_Dolgota_Zenitn_Tochki<0) and (Cos_Dolgota_Zenitn_Tochki<0)
       then Dolgota_Zenitn_Tochki:=-pi-arcsin(Sin_Dolgota_Zenitn_Tochki);
    if (Sin_Dolgota_Zenitn_Tochki<0) and (Cos_Dolgota_Zenitn_Tochki>0)
       then Dolgota_Zenitn_Tochki:=arcsin(Sin_Dolgota_Zenitn_Tochki);
     //Учет скорости вращения Земли
    Dolgota_Zenitn_Tochki:={Omega0}+Dolgota_Zenitn_Tochki
                 -OmegaSemli*(t-(24*3600)*trunc(t/(24*3600)))-t/Tpsv*deltaOmega;
  end;

////////////////////////////////////////////////////////////////////////////////

//Определение "КА на Сонце или в тени?"
Procedure KA_na_Solnze;
begin
        //Определение центрального угла для КА, находящегося на границе тени
        alfa_Ten_Semli:=arccos(Rs/(Rs+H));                                         //Ранее была ошибка (Науменко) arcsin(Rs/(Rs+H));
        //Определение широты центра теневого пятна
        Shirota_Zentra_Teti:=-Shirota_Zenitn_Tochki;
       //Определение долготы центра теневого пятна
       if (Dolgota_Zenitn_Tochki>=0) and (Dolgota_Zenitn_Tochki<=pi)
         then Dolgota_Zentra_Teti:=-pi-Dolgota_Zenitn_Tochki;
       if (Dolgota_Zenitn_Tochki>-pi) and (Dolgota_Zenitn_Tochki<0)
         then Dolgota_Zentra_Teti:=pi+Dolgota_Zenitn_Tochki;

       if (abs(arccos(sin(Shirota_Zentra_Teti)*sin(FiGa)
          +cos(Shirota_Zentra_Teti)*cos(FiGa)*cos(LambdaGd-Dolgota_Zentra_Teti)))
          <alfa_Ten_Semli)  //Условие вхождения КА в тень Земли
          then
            begin
              Flag_KA_v_Teni:=True; //КА в тени
              if checkBox13.Checked then
                begin
                  label37.Color:=clSkyBlue;
                  label37.Font.Color:=clBlack;
                  label37.Caption:='КА в тени';
                end;
            end
          else
            begin
              Flag_KA_v_Teni:=False; //КА на Солнце
               if checkBox13.Checked then
                begin
                  label37.Color:=clYellow;
                  label37.Font.Color:=clRed;
                  label37.Caption:='КА на Солнце';
                end;
            end;
      end;

////////////////////////////////////////////////////////////////////////////////

  procedure CosAlpha;  //Процедура расчета текущего значенния косинуса альфа
    var
      nbx, nby, nbz: real;  //Проекции единичного вектора нормали к поверхности
                            //панелей СБ в базовой системе координат
      m11,m12,m13,m21,m22,m23,m31,m32,m33:real;//Элементы матрицы направляющих
                                               //косинусов
      sCx1,sCy1,sCz1: real; //Элементы матрицы направления на Солнце
      sCx2,sCy2,sCz2: real; //Элементы матрицы направления на Солнце
      sCxH,sCyH,sCzH: real; //Элементы матрицы направления на Солнце
//      sCxb,sCyb,sCzb: real; //Элементы матрицы направления на Солнце
//      tngKA,                //Угол тангажа КА
//      krnKA:real;           //Угол крена КА


    begin
//      tngKA:=0;           //Начальные значения угла тангажа КА, рад
//      krnKA:=0;           //Начальные значения угла крена КА, рад

      //Если выбрана схема ОЭТК и расположения панелей СБ в базовой СК, то
      //определяется матрица направления единичного вектора нормали к поверхности
      //панелей СБ в базовой системе координат:
      if FormKur2.RadioGroup1.ItemIndex=0 then begin nbx:=0; nby:=-1; nbz:=0; end;
      if FormKur2.RadioGroup1.ItemIndex=1 then
      begin
        nbx:=-cos(TettaPanelSB*pi/180)*cos(GammaPanelSB*pi/180);
        nby:=-sin(TettaPanelSB*pi/180)*cos(GammaPanelSB*pi/180);
        nbz:=-sin(TettaPanelSB*pi/180)*cos(GammaPanelSB*pi/180)
             +sin(GammaPanelSB*pi/180);
      end;
      if FormKur2.RadioGroup1.ItemIndex=2 then begin nbx:=0; nby:=0; nbz:=1; end;

      //Пересчет координат единичного вектора направлени на Солнце из неподвижной
      //геоцентрической СК в геоцентрическую орбитальнуб СК,
      //связанную с перицентром орбиты
      m11:=cos(argPer)*cos(Omega)-sin(argPer)*cos(irad)*sin(Omega);
      m12:=cos(argPer)*sin(Omega)+sin(argPer)*cos(irad)*cos(Omega);
      m13:=sin(argPer)*sin(irad);
      m21:=-sin(argPer)*cos(Omega)-cos(argPer)*cos(irad)*sin(Omega);
      m22:=-sin(argPer)*sin(Omega)+cos(argPer)*cos(irad)*cos(Omega);
      m23:=cos(argPer)*sin(irad);
      m31:=sin(irad)*sin(Omega);
      m32:=-sin(irad)*cos(Omega);
      m33:=cos(irad);
      //Координаты единичного вектора направления на Солнце
      //в геоцентрической СК, связанной с перицентром орбиты
      sCx1:=m11*sx+m12*sy+m13*sz;
      sCy1:=m21*sx+m22*sy+m23*sz;
      sCz1:=m31*sx+m32*sy+m33*sz;

      //Пересчет координат единичного вектора направлени на Солнце
      // из геоцентрической орбитальной СК, связанной с перицентром орбиты,
      // в бароцентрическую орбитальную СК
      sCx2:=cos(teta)*sCx1+sin(teta)*sCy1;
      sCy2:=-sin(teta)*sCx1+cos(teta)*sCy1;
      sCz2:=sCz1;

      //Пересчет координат единичного вектора направлени на Солнце из бароцентрической
      //орбитальной СК в СК, связанную с центром масс КА и центром Земли
      sCxH:=-sCx2;
      sCyH:=-sCy2;
      sCzH:= sCz2;

      //Пересчет координат единичного вектора направлени на Солнце из СК, связанной
      //с центром масс КА и центром Земли, в базовую СК КА
       if FormKur2.RadioGroup1.ItemIndex=0 then
         begin
           sCxb:=sin(tngKA)*cos(krnKA)*sCxH-cos(tngKA)*sCyH-sin(tngKA)*sin(krnKA)*sCzH;
           sCyb:=cos(tngKA)*cos(krnKA)*sCxH+sin(tngKA)*sCyH-cos(tngKA)*sin(krnKA)*sCzH;
           sCzb:=sin(krnKA)*sCxH+cos(krnKA)*sCzH;
         end;
       if FormKur2.RadioGroup1.ItemIndex=1 then
         begin
           sCxb:=cos(krnKA)*cos(tngKA)*sCxH+sin(tngKA)*sCyH-cos(tngKA)*sin(krnKA)*sCzH;
           sCyb:=-sin(tngKA)*cos(krnKA)*sCxH+cos(tngKA)*sCyH+sin(tngKA)*sin(krnKA)*sCzH;
           sCzb:=sin(krnKA)*sCxH+cos(krnKA)*sCzH;
         end;
       if FormKur2.RadioGroup1.ItemIndex=2 then
         begin
        //   sCxb:=cos(tngKA)*cos(krnKA)*sCxH+sin(tngKA)*sCyH-cos(tngKA)*sin(krnKA)*sCzH;
       //    sCyb:=-sin(tngKA)*cos(krnKA)*sCxH-cos(tngKA)*sCyH+sin(tngKA)*sin(krnKA)*sCzH;
       //    sCzb:=sin(krnKA)*sCxH+cos(krnKA)*sCzH;
         end;

      //Расчет косинуса угла между направлением на Солнце и нормалю к панели СБ
      //в базовой СК
//      nbx:=-0.866; nby:=0; nbz:=-0.5;  //поворот панели СБ на угол минус 30 град по крену
//      nbx:=-1; nby:=0; nbz:=0;         //поворот панели СБ на угол 0 град
//      nbx:=-0.866; nby:=0; nbz:=0.5;   //поворот панели СБ на угол плюс 30 град по крену

      cosA:=sCxb*nbx+sCyb*nby+sCzb*nbz;
      //Вывод текущего значения косинуса угла между направлением на Солнце
      //и нормалю к панели СБ в базовой СК
      if cosA<0 then cosA:=0;
       if Flag_KA_v_Teni=True  then cosA:=0;//КА в тени
      if ((Flag_SvetovoePjatno=False) and (Flag_KA_v_Teni=False)) then  cosA:=1;
      //КА вне светового пятна, но на Солнце
     
      if CheckBox23.Checked and FlagMinut=true
        then FormKur3.Edit10.Text:=FloatToStr(cosA);
      sum_cosA:=sum_cosA+cosA*dt;
      cosA_sr:=sum_cosA/(t-t0+1);   //Значение седнесуточного косинуса альфа
      if FormKur3.CheckBox9.Checked then
         FormKur3.Button5.Visible:=true
        else
         FormKur3.Button5.Visible:=False;
       if CheckBox3.Checked and FlagMinut=true then
           FormKur3.Edit11.Text:=FloatToStr(cosA_sr);  
    end;

////////////////////////////////////////////////////////////////////////////////

Procedure Periodichnoct; //Процедура расчета периодичности

begin
  //Флаг первого попадания ОН в зону обхора КА
  if ((Flag_Per1=false) and (abs(arccos(sin(FiGa)*sin(Koord_Fi_ObjektNabL*pi/180)
      +cos(FiGa)*cos(Koord_Fi_ObjektNabL*pi/180)*cos(Koord_Ld_ObjektNabL*pi/180
      -LambdaGd)))  <alfa_Obzor))
    then
      begin
        Flag_Per1_1:=true;
        massiv_t_Per[i_per]:=t_Per;
        t_Per:=0;
        i_per:=i_per+1;
        if i_per=999 then i_per:=0;
      end;

  t_Per:=t_per+dt/3600; //Расчет нового значения периодичности

  //Флаг нахождения ОН в зоне обхора КА
  //Пока ОН находится в зоне обзора КА, то Flag_Oper1:=true
  if (abs(arccos(sin(FiGa)*sin(Koord_Fi_ObjektNabL*pi/180)
     +cos(FiGa)*cos(Koord_Fi_ObjektNabL*pi/180)*cos(Koord_Ld_ObjektNabL*pi/180
     -LambdaGd)))  <alfa_Obzor)
    then Flag_per1:=true
      else Flag_per1:=False;

  if FormKur3.checkBox9.Checked and  FlagMinut=true then
//   F_and_f_Periodichnoct(i_per,massiv_t_per{:array of real});
     F_and_f_Periodichnoct;
end;

///////////////////////////////////////////////////////////////////////////////

Procedure Operativnost; //Процедура расчета оперативности
  begin
                             //Оперативность с учетом спутника ретранслятора № 1
    if FormKur2.CheckBox14.Checked then Oper__Sputn_Retr_1;
   

  end;

////////////////////////////////////////////////////////////////////////////

Procedure Vvod_ID_RO;
  var
    code:integer;
    RO_i,RO_j:integer;//Переменные цикла
  begin
    //Ввод ИД по геометрии радиатора охлаждения (РО), град
    v1_RO:=StrToInt(FormKur2.SpinEdit7.Text);//Начальный угол РО
    v2_RO:=StrToInt(FormKur2.SpinEdit10.Text);//Конечный угол РО
    m_RO:=StrToInt(FormKur2.SpinEdit12.Text);//Количество элементов по окружности
    k_RO:=StrToInt(FormKur2.SpinEdit15.Text);//Количество элементов по окружности
    my_RO:=StrToInt(FormKur2.SpinEdit16.Text);//Угол порураствора конуса РО
    t_RO_Solnze:=0; //Начальное время нахождения РО на Солнце

    Val(FormKur2.Edit31.Text, r_RO_1, Code);
      if Code <> 0 then
        begin
          MessageDlg('Ошибка ввода' , mtWarning, [mbOk], 0);
          FormKur2.edit31.SetFocus;
        end;

    Val(FormKur2.Edit32.Text, L_RO, Code);
      if Code <> 0 then
        begin
          MessageDlg('Ошибка ввода' , mtWarning, [mbOk], 0);
          FormKur2.edit32.SetFocus;
        end;

//     r_RO_2:=r_RO_1-L_RO*tan(my_RO/180*pi);  //Радиус нижней кромки РО
     //Расчёт площади поверхности РО
     F_RO:=pi*L_RO*(2*r_RO_1-L_RO*sin(my_RO))*(v2_RO-v1_RO)/360;
     krnKA_RO:=0;
     tngKA_RO:=0;
  end;

///////////////////////////////////////////////////////////////////////////////
 Procedure RO_Solnze;
   var
     i_RO,j_RO:integer;//Переменные цикла
     r_RO_j:real;//Радиус верхней кромки элементарной площадки РО
     F_yk_j:real;//Площадь боковой поверхности усечённого конуса
     //с длиной образующей, равной высоте элементарной площадки
     //Проекции единичного вектора нормали к i-му элементу РО в базовой СК
     n_xb_RO, n_yb_RO, n_zb_RO:real;
     //Члены матрицы преобразования
     m11_RO,m12_RO,m13_RO,m21_RO,m22_RO,m23_RO,m31_RO,m32_RO,m33_RO:real;
     //Проекции единичного вектора направления на Солнце в геоцентрической
     // орбитальной СК, связянной с перицентром орбиты
     sCx1_RO,sCy1_RO,sCz1_RO:real;

     //Проекции координат единичного вектора направлени на Солнце
     // в бароцентрической орбитальной СК
     sCx2_RO,sCy2_RO,sCz2_RO:real;

     //Проекции координат единичного вектора направлени на Солнце
     // в СК, связаннjq с центром масс КА и центром Земли
     sCxH_RO, sCyH_RO,sCzH_RO:real;

     //Проекции координат единичного вектора направлени на Солнце
     //в базовой СК КА
     sCxb_RO,sCyb_RO,sCzb_RO:real;

     //Углы поворота КА при перенацеливании
//     krnKA_RO,tngKA_RO:real;

     //Косинус угла между направлением на Солнце и нормалю к элементарной
     // площадке панели радиатора охлаждения
     cosA_RO:real;

     F_ij_RO_Eff:real;//Эффективная площадь элементарной площадки РО
     F_Eff_RO:real;//Значение эффективной площади радщиатора охлаждения
     label metka1;

   begin
     if Flag_KA_v_Teni=False then  //Если КА на Солнце
       begin
         F_ij_RO_Eff:=0;//Начальное значение
         F_Eff_RO:=0;//Начальное значение эффективной площади РО
         for j_RO:= 1 to k_RO do
           begin
             for i_RO:= 1 to m_RO do
               begin
                 //Расчёт проектций единичного вектора нормали к i-му элементу РО
                 n_xb_RO:=0;
                 n_yb_RO:=cos(v1_RO*pi/180+v2_RO*pi/180*(i_RO-0.5)/m_RO);
                 n_zb_RO:=sin(v1_RO*pi/180+v2_RO*pi/180*(i_RO-0.5)/m_RO);
                 //Расчёт координат единичного вектора направления на Солнце
                 //sx,sy,sz заимствуется из подпрограммы
                 //Rashet_Ed_Vekt_Napravl_Na_Solnz_V_Nepodv_Sist_Koord

                  //Пересчет координат единичного вектора направлени на Солнце
                  //из неподвижной геоцентрической СК в геоцентрическую орбитальнуб
                  //СК, связанную с перицентром орбиты
                  m11_RO:=cos(argPer)*cos(Omega)-sin(argPer)*cos(irad)*sin(Omega);
                  m12_RO:=cos(argPer)*sin(Omega)+sin(argPer)*cos(irad)*cos(Omega);
                  m13_RO:=sin(argPer)*sin(irad);
                  m21_RO:=-sin(argPer)*cos(Omega)-cos(argPer)*cos(irad)*sin(Omega);
                  m22_RO:=-sin(argPer)*sin(Omega)+cos(argPer)*cos(irad)*cos(Omega);
                  m23_RO:=cos(argPer)*sin(irad);
                  m31_RO:=sin(irad)*sin(Omega);
                  m32_RO:=-sin(irad)*cos(Omega);
                  m33_RO:=cos(irad);
                 //Координаты единичного вектора направления на Солнце
                 //в геоцентрической СК, связанной с перицентром орбиты
                 sCx1_RO:=m11_RO*sx+m12_RO*sy+m13_RO*sz;
                 sCy1_RO:=m21_RO*sx+m22_RO*sy+m23_RO*sz;
                 sCz1_RO:=m31_RO*sx+m32_RO*sy+m33_RO*sz;

                 //Пересчет координат единичного вектора направлени на Солнце
                 // из геоцентрической орбитальной СК, связанной с перицентром
                 //орбиты, в бароцентрическую орбитальную СК
                 sCx2_RO:=cos(teta)*sCx1_RO+sin(teta)*sCy1_RO;
                 sCy2_RO:=-sin(teta)*sCx1_RO+cos(teta)*sCy1_RO;
                 sCz2_RO:=sCz1_RO;

                 //Пересчет координат единичного вектора направлени на Солнце
                 //из бароцентрической орбитальной СК в СК, связанную с центром
                 //масс КА и центром Земли
                 sCxH_RO:=-sCx2_RO;
                 sCyH_RO:=-sCy2_RO;
                 sCzH_RO:= sCz2_RO;
{
                 //Проверка условия нахождения подспутниковой точки КА
                 //в световом пятне
                 if Flag_SvetovoePjatno=true then //Если подспутниковая точка
                                                  //КА в световом пятне, то
                   begin
                     //Имитация поворотов КА через время перенацеливания
                      randomize;
  //                    if FlagPerenazel=true then
                        begin
metka1:                   krnKA_RO:=-hVgrad/180*pi+2*(hVgrad/180*pi)*random;
                          tngKA_RO:=-hVgrad/180*pi+2*(hVgrad/180*pi)*random;
                          if sqrt(sqr(h*tan(krnKA_RO))
                                          +sqr(h*tan(tngKA_RO)))>h*tan(hVgrad/180*pi)
                            then goto metka1;
                        end;
                   end;
}
                 //Пересчет координат единичного вектора направлени на Солнце из
                 //СК, связанной с центром масс КА и центром Земли, в базовую СК
                 if FormKur2.RadioGroup1.ItemIndex=1  //Если включена галочка
                   then
                     begin
                       sCxb_RO:=cos(krnKA_RO)*cos(tngKA_RO)*sCxH_RO
                     +sin(tngKA_RO)*sCyH_RO-cos(tngKA_RO)*sin(krnKA_RO)*sCzH_RO;
                       sCyb_RO:=-sin(tngKA_RO)*cos(krnKA_RO)*sCxH_RO
                     +cos(tngKA_RO)*sCyH_RO+sin(tngKA_RO)*sin(krnKA_RO)*sCzH_RO;
                       sCzb_RO:=sin(krnKA_RO)*sCxH_RO+cos(krnKA_RO)*sCzH_RO;
                     end;
                 if Flag_SvetovoePjatno=False then //Если подспутниковая точка
                                                  //КА не в световом пятне, то
                   begin
                     sCxb_RO:=-1;
                     sCyb_RO:=0;
                     sCzb_RO:=0;
                   end;

                 //Расчет косинуса угла между направлением на Солнце и нормалю
                 //к панели РО в базовой СК
                 cosA_RO:=sCxb_RO*n_xb_RO+sCyb_RO*n_yb_RO+sCzb_RO*n_zb_RO;

                 //Расчёт элементарной площадки РО
                 r_RO_j:=r_RO_1*(1-L_RO/k_RO*(j_RO-1)*tan(my_RO));
                 F_yk_j:=2*pi*r_RO_j*L_RO/k_RO-pi*sqr(L_RO/k_RO)*sin(my_RO);
                 F_ij_RO:=F_yk_j*(v2_RO-v1_RO)/360/m_RO;

                 if cosA_RO>0.000001 then
                   begin
                     //Расчёт эффективной площади для элементарной площадки РО
                     F_ij_RO_Eff:=F_ij_RO*cosA_RO;
                     //Расчёт эффективной площади для всего радиатора охлаждения
                     F_Eff_RO:=F_Eff_RO+F_ij_RO_Eff;
                   end;
               end;
           end;

         //Расчёт относительной эффективной площади для всего РО
         F_Eff_RO_otn:=F_Eff_RO/F_RO;
         //Осредённое время действия Солнца на РО
         t_RO_Solnze:= t_RO_Solnze+ F_Eff_RO_otn*dt;
         //Осредённое относительное время действия Солнца на РО
          t_RO_Solnze_otn:= t_RO_Solnze/t;
         //Вывод результатов
         if (FormKur2.checkBox16.Checked and FlagChas=true)
           then  FormKur2.Edit33.Text:=FloatToStrF(t_RO_Solnze_otn,ffFixed,12,11);

       end;
   end;

///////////////////////////////////////////////////////////////////////////////

procedure Vvod_ID_SB;
  var
    code:integer;
  begin
     //Ввод ИД по спутнику углу установки панели СБ, град
    Val(FormKur2.SpinEdit17.Text, GammaPanelSB, Code);
    if Code <> 0 then
      begin
        MessageDlg('неправильно введено значение ',
        mtWarning, [mbOk], 0);
        FormKur2.SpinEdit17.SetFocus;
      end;

      Val(FormKur2.SpinEdit19.Text, TettaPanelSB, Code);
    if Code <> 0 then
      begin
        MessageDlg('неправильно введено значение ',
        mtWarning, [mbOk], 0);
        FormKur2.SpinEdit19.SetFocus;
      end;

  end;

///////////////////////////////////////////////////////////////////////////////

Procedure Perenazel_KA;

 label
   metka1;

  begin
    //Проверка условия нахождения подспутниковой точки КА в световом пятне
    if Flag_SvetovoePjatno=true then //Если подспутниковая точка
                                                  //КА в световом пятне, то
      begin
        //Имитация поворотов КА через время перенацеливания
        randomize;
        if FlagPerenazel=true then
        //Имитация поворотов КА через время перенацеливания
          begin
metka1:     krnKA:=-hVgrad/180*pi+2*(hVgrad/180*pi)*random;
            tngKA:=-hVgrad/180*pi+2*(hVgrad/180*pi)*random;
            if sqrt(sqr(h*tan(krnKA))+sqr(h*tan(tngKA)))>h*tan(hVgrad/180*pi)
              then goto metka1;
          end;
      end;  

    //Если подспутниковая точка КА не в световом пятне, то

//    if ((Flag_SvetovoePjatno=False) and (Flag_KA_v_Teni=False)) then  cosA:=1;
//     if (Flag_KA_v_Teni=True) then  cosA:=0;
  end;

 ////////////////////////////////////////////////////////////////////////

 Procedure t_otn_ZD_Astra;  //Расчёт относительного времени направления ЗД
                            //на звёздное небо
 begin
   //Координаты единичного вектора направлени на Солнце в базовой СК КА
   //заимствуются из процедуры CosAlpha (sCxb, sCyb, sCzb)
   //Расчёт косинуса угла между вектором направления на Солнце и вектором
   //направления звёздного датчика (в базовой СК)
   cos_ZD_S:=sCxb*CosZD_alfaX_bCK+sCyb*CosZD_alfaY_bCK+sCzb*CosZD_alfaZ_bCK;
   //Если угол между вектором направления на Солнце и вектором направления
   //звёздного датчика меньще угла раствора конуса поля зрения оптического блока
   Ygol_ZD_S:=arccos(cos_ZD_S);
   if (Ygol_ZD_S>(Ygol_kon_ZD_My/2/180*pi))
    then  t_ZD_S:=t_ZD_S+dt; //ЗД не засвечен Солнцем;
 {
   if cos_ZD_S<0 then  t_ZD:=t_ZD+dt; //ЗД не засвечен Солнцем;
   if ((cos_ZD_S>0) and (cos_ZD_S>cos(Ygol_kon_ZD_My/180*pi)))
     then  t_ZD_S:=t_ZD_S; //ЗД не засвечен Солнцем;
   if ((cos_ZD_S>0) and (cos_ZD_S<cos(Ygol_kon_ZD_My/180*pi)))
     then  t_ZD_S:=t_ZD_S+dt; //ЗД не засвечен Солнцем;
 }
   t_otn_ZD_S:=t_ZD_S/t;
      //Вывод результатов
   if (FormKur2.checkBox17.Checked and FlagChas=true)
      then  FormKur2.Edit37.Text:=FloatToStrF(t_otn_ZD_S,ffFixed,12,11);
   //Пересчёт координат вектора направления оптич. оси звёздного координатора
   //из базовой СК в  СК, связянную с центом масс КА и направлением в надир
   if FormKur2.RadioGroup1.ItemIndex=0 then   //Если ККС типа 1
     begin
       eHx:=CosZD_alfaX_bCK*sin(tngKA)*cos(krnKA)+CosZD_alfaY_bCK*cos(tngKA)*
            cos(krnKA)+CosZD_alfaZ_bCK*sin(krnKA);
       eHy:=-CosZD_alfaX_bCK*cos(tngKA)+CosZD_alfaY_bCK*sin(tngKA)+
             CosZD_alfaZ_bCK*0;
       eHz:=CosZD_alfaX_bCK*sin(tngKA)*sin(krnKA)-CosZD_alfaY_bCK*
            cos(tngKA)*sin(krnKA)+CosZD_alfaZ_bCK*cos(krnKA);
     end;

   if FormKur2.RadioGroup1.ItemIndex=1 then   //Если ККС типа 2
     begin
       eHx:=CosZD_alfaX_bCK*cos(tngKA)*cos(krnKA)-CosZD_alfaY_bCK*sin(tngKA)*
            cos(krnKA)+CosZD_alfaZ_bCK*sin(krnKA);
       eHy:=-CosZD_alfaX_bCK*sin(tngKA)+CosZD_alfaY_bCK*cos(tngKA)+
             CosZD_alfaZ_bCK*0;
       eHz:=-CosZD_alfaX_bCK*cos(tngKA)*sin(krnKA)+CosZD_alfaY_bCK*
            sin(tngKA)*sin(krnKA)+CosZD_alfaZ_bCK*cos(krnKA);
     end; 

  if FormKur2.RadioGroup1.ItemIndex=2 then   //Если ККС типа 3
     begin
// Не сделано
     end;

   //Провека условия попадания координат конца единичного вектора оптической
   //оси звёздеого датчика в конус затенения его поля зрения Землёй
   if eHx<k_konus_Vid_Semli*sqrt(sqr(eHy)+sqr(eHz))
     then
       begin
         t_ZD_Z:=t_ZD_Z+dt; //ЗД не экранирован Землёй
         t_otn_ZD_Z:=t_ZD_Z/t;
       end;

   //Вывод результатов
   if (FormKur2.checkBox17.Checked and FlagChas=true)
      then  FormKur2.Edit38.Text:=FloatToStrF(t_otn_ZD_Z,ffFixed,12,11);

   //Провека условия попадания координат конца единичного вектора оптической
   //оси звёздеого датчика в конус затенения его поля зрения Землёй и Солнцем
   if ((eHx<k_konus_Vid_Semli*sqrt(sqr(eHy)+sqr(eHz))) and
      (Ygol_ZD_S>(Ygol_kon_ZD_My/2/180*pi)))
      then
        begin
          t_ZD_Z_S:=t_ZD_Z_S+dt; //ЗД не экранирован Землёй
          t_otn_ZD_Z_S:=t_ZD_Z_S/t;
        end;

   //Вывод результатов
   if (FormKur2.checkBox17.Checked and FlagChas=true)
      then  FormKur2.Edit39.Text:=FloatToStrF(t_otn_ZD_Z_S,ffFixed,12,11);


 end;


////////////////////////////////////////////////////////////////////////

BEGIN                                                       //Основная программа
//  t:=0;
//  i_per:=0;//начальныйпоказательпериодичности
//  massiv_t_Per[0]:=0;//Обнуление первого элемента массива периодичности
  FormKur3.Image1.Picture.LoadFromFile('karts\KartaZifr2.bmp');
  VVodID;
  cosA_sr:=0;//Начальные значения среднесуточного косинуса альфа
//  RashetPorb; //Расчет начальных параметров орбиты
  //Вычисление центрального угла Земли обзора КА
  alfa_Obzor:=arcsin((H+Rs)/Rs*tan(HV)/sqrt(1+sqr(tan(HV))))
                                                -arccos(1/sqrt(1+sqr(tan(HV))));
  //Вычисление центрального угла Земли радиовидтмости КА с НППИ
  alfa_Radio_Vidimost:=arcsin(sqrt(1-sqr(Rs)/sqr(H+Rs)));

  //Вычисление центрального угла Земли для светового пятна
  alfa_Svetovoe_Pjatno:=pi/2-yS/180*pi;
  //Начальные значения
  Flag_KA_v_Teni:=False;   //КА на Солнце
  Flag_per1:=false; //Флаг нахождения ОН в зоне обзора КА
  Flag_per1_1:=false;//Флаг первого попадания ОН в зону обзора КА
  t_per:=0; //Начальное значение оперативности
  //Начальное значение количества циклов перенацеливания
  nPNZ_1:=trunc(t/tPNZ);
  Nminut_1:=trunc(t/60);
  Nchas_1:=trunc(t/3600);
  RashetPorb; //Расчет начальных параметров орбиты}
  Nvit_1:=trunc(t/Tpsv);  //Целое количество витков с начала полета (с 21 марта)
  NSut_1:=trunc(t/(24*3600));//Целое количество витков с начала полета (с 21 марта)
  NSut:=trunc(t/(24*3600));//Целое количество витков с начала полета (с 21 марта)

  //ВВод ИД по радиатору охлаждения
  Vvod_ID_RO;

  //ВВод ИД по углам установки панели СБ
  Vvod_ID_SB;

  //Ввод ИД по звёздным датчикам
  Vvod_ID_ZD;

  //расчет исходных данных по надежности
  ID_Nadegnoct;
  ////////////////
  
  repeat  //ЦИКЛ ОСНОВНОЙ ПРОГРАММЫ
    Flag1:=False;   //Флаг для продолжения или остановки циклов

    RashetPorbTek;        //Процедура расчета текущих значений параметров орбиты
    //Процедура выделения событий о целом количестве суток, витков,часов, минут,
    //времени перенацеливания и времени перересовывания
    Rashet_Kol_Zel_Min_Chas_Sut_Vit_Perenazel_Pereris;
    GeogrKoord;           //Процедура расчета географических координат трассы КА

     //Освежить рисунок
    if checkBox22.Checked and FlagVit=true then FormKur3.Image1.Refresh;
    
    //Если подспутниковая точка КА находится в световом пятне,
    if (abs(arccos(sin(Shirota_Zenitn_Tochki)*sin(FiGa)
      +cos(Shirota_Zenitn_Tochki)*cos(FiGa)*cos(LambdaGd-Dolgota_Zenitn_Tochki)))
      <alfa_Svetovoe_Pjatno) then   //то прорисовка зоны обзора КА
      begin
        Flag_SvetovoePjatno:=true;   //Флаг нахождения КА в световом пятне
        if checkBox7.Checked and FlagPerenazel=true  then
          begin
            FormKur3.Canvas.Pen.Color:=ClFuchsia;
            Ris_Krug_alfa_Zemli(alfa_Obzor,FiGa,LambdaGd,1);
          end;
       end
         else Flag_SvetovoePjatno:=False; //Флаг нахождения КА в световом пятне

    //Процедура расчета координат единичного вектора направлени на Солнце
    //в неподвижной геоцентрической системе координат
    Rashet_Ed_Vekt_Napravl_Na_Solnz_V_Nepodv_Sist_Koord;

    //Прорисовка светового пятна
    if checkBox21.Checked and FlagVit=true then
      begin  
        FormKur3.Canvas.Pen.Color:=ClYellow;
        Ris_Krug_alfa_Zemli(alfa_Svetovoe_Pjatno,Shirota_Zenitn_Tochki,Dolgota_Zenitn_Tochki,5);
      end;

 //Прорисовка зоны радиовидимости
    if checkBox12.Checked and FlagVit=true then
      begin
        FormKur3.Canvas.Pen.Color:=ClLime;
        Ris_Krug_alfa_Zemli(alfa_Radio_Vidimost,KoordFiNPPI/180*pi,KoordLdNPPI/180*pi,2);
      end;       

    //Прорисовка объекта наблюдения
    if checkBox14.Checked and FlagVit=true then Ris_Objekt_Nabl;
 
    //Прорисовка границы тени
    if checkBox8.Checked and FlagVit=true then
      begin
        FormKur3.Canvas.Pen.Color:=ClBlack;
        Ris_Krug_alfa_Zemli(89.999/180*pi,Shirota_Zenitn_Tochki,Dolgota_Zenitn_Tochki,3);
      end;

    KA_na_Solnze;//Определение "КА на Сонце или в тени?"

    //Имитация поворотов КА при перенацеливании
    Perenazel_KA;

    CosAlpha; //Процедура расчета текущего значенния косинуса альфа
    //Вычисление центрального угла Земли обзора КА
    alfa_Obzor:=arcsin((H+Rs)/Rs*tan(HV)/sqrt(1+sqr(tan(HV))))
                                                -arccos(1/sqrt(1+sqr(tan(HV))));
    Periodichnoct; //Процедура расчета периодичности
    Operativnost; //Процедура расчета оперативности

    if FormKur2.CheckBox9.Checked then Nadegnoct;//Процедура учета надежности

  

     //Расчёт средего времени нахождения радиатора охлаждения на Солнце
    if FormKur2.checkBox16.Checked then RO_Solnze;

    //Процедура расчёта относительного времени направления ЗД на звёздное небо
     if FormKur2.checkBox17.Checked then t_otn_ZD_Astra;

    Vivod_Resultatov_Rascheta;            //Процедура вывода результатов расчета

    t:=t+1;                               //Приращение времени в цикле
//    if FormKur2.CheckBox7.Checked then FormKur2.Button20.Click;
    
    Application.ProcessMessages;
  until Flag1;
END;

procedure TFormKur3.Button3Click(Sender: TObject);
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

procedure TFormKur3.Button6Click(Sender: TObject);
begin
    Flag1:=true;
end;
 

procedure TFormKur3.Button22Click(Sender: TObject);
begin
   FormKur2.Show;
end;

procedure TFormKur3.Button4Click(Sender: TObject);
begin
   MessageDlg('Для продолжения работы програмы нажмите кнопку [Ok]',
              mtWarning, [mbOk], 0);
end;

procedure TFormKur3.Button5Click(Sender: TObject);
begin
  FormKur2.Show; 
  FormKur2.TabSheet3.Show;
end;

end.


