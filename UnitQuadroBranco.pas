unit UnitQuadroBranco;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Menus,
  System.ImageList, Vcl.ImgList, Vcl.ExtCtrls, Vcl.Imaging.pngimage,StrUtils;

type
  TFrmQuadroBranco = class(TForm)
    PagQuadroBranco: TPageControl;
    TabConteudo: TTabSheet;
    Panel1: TPanel;
    MemoConteudo: TMemo;
    OpenDialog: TOpenDialog;
    BtnAbrir: TButton;
    BtnSair: TButton;
    BtnApresentar: TButton;
    Image1: TImage;
    procedure BtnApresentarClick(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);
    procedure BtnAbrirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure proximoLabel(Sender: TObject);
  private
    { Private declarations }
    arquivo : string;
  public
    { Public declarations }
  end;

var
  FrmQuadroBranco: TFrmQuadroBranco;

implementation

{$R *.dfm}

procedure TFrmQuadroBranco.BtnAbrirClick(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
      arquivo := OpenDialog.FileName;
      BtnApresentar.Click;
  end
  else
  begin
    arquivo := '';
  end;
end;

procedure TFrmQuadroBranco.BtnApresentarClick(Sender: TObject);
var
  i : integer;
  linha : String;
  TabSheet: TTabSheet;
  Image : TImage;
  llabel : Tlabel;
  nextLabel : TButton;
  t : integer;
begin
   if arquivo <> '' then
   begin
     MemoConteudo.Lines.LoadFromFile(OpenDialog.FileName);

     TabSheet := TTabSheet.Create(PagQuadroBranco);
     Image := TImage.Create(self);
     i := 0;

     while PagQuadroBranco.PageCount > 1 do
       PagQuadroBranco.Pages[PagQuadroBranco.PageCount - 1].Free;
     for linha in MemoConteudo.Lines do
     begin
         if not linha.IsEmpty  then
         begin
           if linha.StartsWith('@') then
           begin
              i := 30;
              TabSheet := TTabSheet.Create(PagQuadroBranco);
              TabSheet.Caption := Copy(linha,2,linha.Length);
              TabSheet.PageControl := PagQuadroBranco;
              TabSheet.DoubleBuffered := true;
              Image := TImage.Create(PagQuadroBranco);
              Image.Parent := TabSheet;
              Image.Align := alClient;
              Image.Stretch := True;
              Image.Picture := Image1.Picture;
              Image.OnClick := proximoLabel;
          end
          else
          begin
              if linha.StartsWith('IM') then
              begin
                Image.Picture.LoadFromFile(trim(Copy(linha,3,linha.Length)));
              end
              else
              begin
                t := t + 1;
                llabel := TLabel.Create(Image);
                llabel.Font.Name := 'Permanent Marker';
                llabel.Font.Color := clBlue;
                llabel.Font.Size := StrToint(Copy(linha,1,2));
                llabel.Top := i;
                llabel.Left := 50;
                llabel.Parent := TabSheet;
                llabel.Caption := Copy(linha,3,linha.Length);
                if linha.EndsWith('+') then
                begin
                  llabel.Caption := Copy(linha,3,linha.Length-3);
                  llabel.Tag := 1;
                end
                else
                begin
                  llabel.Caption := Copy(linha,3,linha.Length);
                  llabel.Tag := 0;
                end;

                llabel.Visible := trim(llabel.Caption) = '';
                i := i + trunc(llabel.Font.Size*1.4);
              end;
          end;
         end;
     end;
     PagQuadroBranco.ActivePageIndex := 1;
   end;
end;

procedure TFrmQuadroBranco.BtnSairClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFrmQuadroBranco.FormCreate(Sender: TObject);
begin
    MemoConteudo.Lines.Clear;
    FrmQuadroBranco.Top := 0;
    FrmQuadroBranco.Height := 1040;
    FrmQuadroBranco.Width := 1000;
    arquivo := '';
end;

procedure TFrmQuadroBranco.proximoLabel(Sender: TObject);
var
  i : integer;
  fim : boolean;
begin
   fim := true;
   for i := 0 to TImage(Sender).ComponentCount - 1 do
   begin
     if (TImage(Sender).Components[i] is TLabel) and
        (not Tlabel(TImage(Sender).Components[i]).Visible) then
     begin
       Tlabel(TImage(Sender).Components[i]).Visible := true;
       fim := i = TImage(Sender).ComponentCount - 1;
       if Tlabel(TImage(Sender).Components[i]).Tag = 0 then
         break;
     end;
   end;

   if (fim) and (not ContainsText(TTabsheet(TImage(Sender).Parent).Caption, '*')) then
      TTabsheet(TImage(Sender).Parent).Caption := TTabsheet(TImage(Sender).Parent).Caption + '*';
end;

end.
