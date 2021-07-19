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
    BtnMinimizar: TButton;
    Shape1: TShape;
    procedure BtnApresentarClick(Sender: TObject);
    procedure BtnSairClick(Sender: TObject);
    procedure BtnAbrirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure proximoLabel(Sender: TObject);
    procedure proximoTab(Sender: TObject);
    procedure BtnMinimizarClick(Sender: TObject);
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
                Image.OnClick := proximoLabel;
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
                llabel.Caption := llabel.Caption + ' ';
                i := i + trunc(llabel.Font.Size*1.4);
              end;
          end;
         end;
     end;
     PagQuadroBranco.ActivePageIndex := 1;
   end;
end;

procedure TFrmQuadroBranco.BtnMinimizarClick(Sender: TObject);
begin
   FrmQuadroBranco.WindowState := wsMinimized;
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

procedure TFrmQuadroBranco.proximoTab(Sender: TObject);
begin
  TTabsheet(TShape(Sender).Parent).PageControl.ActivePageIndex := TShape(Sender).Tag;
end;

procedure TFrmQuadroBranco.proximoLabel(Sender: TObject);
var
  i : integer;
  fim, alterou : boolean;
  proximo : Tlabel;
begin
   fim := true;
   alterou := false;
   for i := 0 to TImage(Sender).ComponentCount - 1 do
   begin
     if (TImage(Sender).Components[i] is TLabel) and
        (not Tlabel(TImage(Sender).Components[i]).Visible) then
     begin
       alterou := true;
       Tlabel(TImage(Sender).Components[i]).Visible := true;
       fim := i = TImage(Sender).ComponentCount - 1;
       if Tlabel(TImage(Sender).Components[i]).Tag = 0 then
         break;
     end;
   end;

   if ((fim) and (alterou)) or (TImage(Sender).ComponentCount = 0)then
   begin
      proximo := Tlabel.Create(TTabsheet(TImage(Sender).Parent));
      proximo.Font.Name := 'Permanent Marker';
      proximo.Font.Color := clBlue;
      proximo.Font.Size := 20;
      proximo.Tag := TTabsheet(TImage(Sender).Parent).TabIndex + 1;
      proximo.Top := TImage(Sender).Height - 80;

      proximo.Parent := TTabsheet(TImage(Sender).Parent);
      if (TTabsheet(TImage(Sender).Parent).TabIndex = TTabsheet(TImage(Sender).Parent).PageControl.PageCount - 1) then
      begin
        proximo.Left := TImage(Sender).Width - 90;
        proximo.Caption := 'Fim';
      end
      else
      begin
        proximo.Left := TImage(Sender).Width - 150;
        proximo.Caption := 'Próximo';
        proximo.OnClick := proximoTab;
      end;
   end;
end;

end.
