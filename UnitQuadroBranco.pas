unit UnitQuadroBranco;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Menus,
  System.ImageList, Vcl.ImgList, Vcl.ExtCtrls, Vcl.Imaging.pngimage,StrUtils;

type
  TFrmQuadroBranco = class(TForm)
    PagQuadroBranco: TPageControl;
    OpenDialog: TOpenDialog;
    PopupMenu: TPopupMenu;
    Abrir1: TMenuItem;
    Apresentar1: TMenuItem;
    Minimizar1: TMenuItem;
    N1: TMenuItem;
    Sair1: TMenuItem;
    MemoConteudo: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure proximoLabel(Sender: TObject);
    procedure proximoTab(Sender: TObject);
    procedure Abrir1Click(Sender: TObject);
    procedure Apresentar1Click(Sender: TObject);
    procedure Minimizar1Click(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
    procedure Apresentar;
    procedure WMEraseBkgnd(var Message: TWMEraseBkgnd);
      message WM_ERASEBKGND;
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

procedure TFrmQuadroBranco.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  Message.Result:=0;
end;

procedure TFrmQuadroBranco.Abrir1Click(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
      arquivo := OpenDialog.FileName;
      Apresentar;
  end
  else
  begin
    arquivo := '';
  end;
end;

procedure TFrmQuadroBranco.Apresentar1Click(Sender: TObject);
begin
  Apresentar;
end;

procedure TFrmQuadroBranco.Apresentar;
var
  i : integer;
  linha : String;
  TabSheet: TTabSheet;
  Image : TImage;
  llabel : Tlabel;
  nextLabel : TButton;
  t : integer;
  Panel : Tpanel;
begin
   if arquivo <> '' then
   begin
     MemoConteudo.Lines.LoadFromFile(OpenDialog.FileName);

     TabSheet := TTabSheet.Create(PagQuadroBranco);
     Image := TImage.Create(self);
     i := 0;

     while PagQuadroBranco.PageCount > 0 do
       PagQuadroBranco.Pages[PagQuadroBranco.PageCount - 1].Free;
     for linha in  MemoConteudo.Lines do
     begin
         if not linha.IsEmpty  then
         begin
           if linha.StartsWith('@') then
           begin
              i := 30;
              TabSheet := TTabSheet.Create(PagQuadroBranco);
              TabSheet.Caption := Copy(linha,2,linha.Length);
              TabSheet.PageControl := PagQuadroBranco;
              //TabSheet.TabVisible := False;
              Panel :=  Tpanel.Create(TabSheet);
              Panel.DoubleBuffered := true;
              Panel.Caption := '';
              Panel.Align := alClient;
              Panel.Parent :=  TabSheet;
              Image := TImage.Create(Panel);
              Image.Parent := Panel;
              Image.Align := alClient;
              Image.Picture.LoadFromFile('D:\QuadroBranco\fundo.png');
              Image.OnClick := proximoLabel;
          end
          else
          begin
              if linha.StartsWith('IM') then
              begin
                Panel :=  Tpanel.Create(TabSheet);
                Panel.DoubleBuffered := true;
                Panel.Caption := '';
                Panel.Align := alClient;
                Panel.Parent :=  TabSheet;
                Image := TImage.Create(Panel);
                Image.Parent := Panel;
                Image.Align := alClient;
                Image.Picture.LoadFromFile(trim(Copy(linha,3,linha.Length)));
                Image.OnClick := proximoLabel;
              end
              else
              begin
                t := t + 1;
                llabel := TLabel.Create(Image);
                llabel.Font.Name := 'Arial';
                llabel.Font.Style := [fsBold];
                llabel.Font.Color := clNavy;
                llabel.Font.Size := StrToint(Copy(linha,1,2));
                llabel.Top := i;
                llabel.Left := 50;
                llabel.Parent := Panel;
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

     PagQuadroBranco.ActivePageIndex := 0;
   end;
end;

procedure TFrmQuadroBranco.FormCreate(Sender: TObject);
begin
    FrmQuadroBranco.Top := 0;
    FrmQuadroBranco.Height := 1040;
    FrmQuadroBranco.Width := 1000;
    arquivo := '';
end;

procedure TFrmQuadroBranco.Minimizar1Click(Sender: TObject);
begin
   FrmQuadroBranco.WindowState := wsMinimized;
end;

procedure TFrmQuadroBranco.proximoTab(Sender: TObject);
begin
  TTabsheet(TPanel(TImage(Sender).Parent).Parent).PageControl.SelectNextPage(true, false);
end;

procedure TFrmQuadroBranco.Sair1Click(Sender: TObject);
begin
  Application.Terminate;
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
      proximo.Font.Name := 'Arial';
      proximo.Font.Color := clBlue;
      proximo.Font.Size := 20;
      proximo.Tag := TTabsheet(TImage(Sender).Parent).TabIndex + 1;
      proximo.Top := TImage(Sender).Height - 80;

      proximo.Parent := TTabsheet(TImage(Sender).Parent);
      if (TTabsheet(TPanel(TImage(Sender).Parent).Parent).TabIndex =
          TTabsheet(TPanel(TImage(Sender).Parent).Parent).PageControl.PageCount - 1) then
      begin
        proximo.Left := TImage(Sender).Width - 90;
        proximo.Caption := 'Fim';
        proximo.OnClick := proximoTab;
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
