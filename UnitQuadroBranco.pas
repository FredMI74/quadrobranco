unit UnitQuadroBranco;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Menus,
  System.ImageList, Vcl.ImgList, Vcl.ExtCtrls, Vcl.Imaging.pngimage,StrUtils,
  CommCtrl;

type
  TPageControl = class(Vcl.ComCtrls.TPageControl)
  private
    procedure TCMAdjustRect(var Msg: TMessage); message TCM_ADJUSTRECT;
  end;

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
    Abas1: TMenuItem;
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
    procedure Abas1Click(Sender: TObject);
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


procedure TPageControl.TCMAdjustRect(var Msg: TMessage);
begin
  inherited;
  if Msg.WParam = 0 then
    InflateRect(PRect(Msg.LParam)^, 4, 4)
  else
    InflateRect(PRect(Msg.LParam)^, -4, -4)
end;

procedure TFrmQuadroBranco.WMEraseBkgnd(var Message: TWMEraseBkgnd);
begin
  Message.Result:=0;
end;

procedure TFrmQuadroBranco.Abas1Click(Sender: TObject);
var
  i : integer;
begin
  for i := 0 to PagQuadroBranco.PageCount - 1 do
  begin
     PagQuadroBranco.Pages[i].TabVisible := True;
  end;
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
  Panel : Tpanel;
begin
   Panel := Tpanel.Create(self);

   if arquivo <> '' then
   begin
     MemoConteudo.Lines.LoadFromFile(OpenDialog.FileName);
     TabSheet := TTabSheet.Create(PagQuadroBranco);
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
              TabSheet.TabVisible := False;
              TabSheet.BorderWidth := 0;
              Panel := Tpanel.Create(TabSheet);
              Panel.DoubleBuffered := true;
              Panel.Align := alClient;
              Panel.Parent := TabSheet;
              Panel.Color := clGreen; // RGB(153, 255, 102);
              Panel.ParentBackground := False;
              Panel.BorderWidth := 0;
              Panel.BevelOuter:= bvNone;
              Panel.BorderStyle := bsNone;
              Panel.OnClick := proximoLabel;
          end
          else
          begin
              if linha.StartsWith('IM') then
              begin
                Panel := Tpanel.Create(TabSheet);
                Panel.DoubleBuffered := true;
                Panel.Align := alClient;
                Panel.Parent := TabSheet;
                Panel.Color := clGreen; // RGB(153, 255, 102);
                Panel.ParentBackground := False;
                Panel.BorderWidth := 0;
                Panel.BevelOuter := bvNone;
                Panel.BorderStyle := bsNone;
                Panel.OnClick := proximoLabel;
                Image := TImage.Create(Panel);
                Image.Parent := Panel;
                Image.top := 0;
                Image.Left := 0;
                Image.AutoSize := true;
                Image.Picture.LoadFromFile(trim(Copy(linha,3,linha.Length)));
              end
              else
              begin
                llabel := TLabel.Create(Panel);
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
  TTabsheet(TPanel(TLabel(Sender).Parent).Parent).PageControl.SelectNextPage(true, false);
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
   for i := 0 to TPanel(Sender).ComponentCount - 1 do
   begin
     if (TPanel(Sender).Components[i] is TLabel) and
        (not Tlabel(TPanel(Sender).Components[i]).Visible) then
     begin
       alterou := true;
       Tlabel(TPanel(Sender).Components[i]).Visible := true;
       fim := i = TPanel(Sender).ComponentCount - 1;
       if Tlabel(TPanel(Sender).Components[i]).Tag = 0 then
         break;
     end;
   end;

   if ((fim) and (alterou)) or (TPanel(Sender).ComponentCount = 1)then
   begin
      proximo := Tlabel.Create(TPanel(Sender));
      proximo.Font.Name := 'Arial';
      proximo.Font.Color := clNavy;
      proximo.Font.Size := 20;
      proximo.AutoSize := True;
      proximo.Top := TPanel(Sender).Height - 40;
      proximo.Left := 20;
      proximo.OnClick := proximoTab;
      proximo.Parent := TPanel(Sender);
      if (TTabsheet(TPanel(Sender).Parent).TabIndex =
          TTabsheet(TPanel(Sender).Parent).PageControl.PageCount - 1) then
      begin
        proximo.Caption := 'Fim';
      end
      else
      begin
        proximo.Caption := 'Próximo';
      end;
   end;
end;

end.
