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
    OpenDialog: TOpenDialog;
    PopupMenu: TPopupMenu;
    Abrir1: TMenuItem;
    Apresentar1: TMenuItem;
    Minimizar1: TMenuItem;
    N1: TMenuItem;
    Sair1: TMenuItem;
    Abas1: TMenuItem;
    Fundo: TPanel;
    PagQuadroBranco: TPageControl;
    MemoConteudo: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure proximoTab(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Abrir1Click(Sender: TObject);
    procedure Apresentar1Click(Sender: TObject);
    procedure Minimizar1Click(Sender: TObject);
    procedure Sair1Click(Sender: TObject);
    procedure Apresentar;
    procedure Abas1Click(Sender: TObject);
  private
    { Private declarations }
    corletra, corsombra : Tcolor;
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
  i,j : integer;
  linha, fonte : String;
  TabSheet: TTabSheet;
  Image : TImage;
  llabel, llabelSombra : Tlabel;
  Panel, PanelL: Tpanel;
  imagem : boolean;

begin
   Panel := Tpanel.Create(self);
   PanelL := Tpanel.Create(self);
   llabel := nil;
   fonte := 'Verdana';

   if arquivo <> '' then
   begin
     PagQuadroBranco.Visible := true;
     MemoConteudo.Lines.LoadFromFile(OpenDialog.FileName);
     TabSheet := TTabSheet.Create(PagQuadroBranco);
     i := 0;

     while PagQuadroBranco.PageCount > 0 do
       PagQuadroBranco.Pages[PagQuadroBranco.PageCount - 1].Free;

     for linha in  MemoConteudo.Lines do
     begin
         if not linha.IsEmpty  then
         begin
             imagem := false;
             if linha.StartsWith('*F') then
             begin
               fonte := Copy(linha,3,linha.Length);
             end
             else
             if linha.StartsWith('*C') then
             begin
               corletra := StringToColor(Copy(linha,3,linha.Length));
             end
             else
             if linha.StartsWith('*S') then
             begin
               corsombra :=  StringToColor(Copy(linha,3,linha.Length));
             end
             else
             if linha.StartsWith('@') then
             begin
                if Panel <> nil then
                begin
                  for j := Panel.ComponentCount -1 downto 0 do
                  begin
                     if (Panel.Components[j] is TLabel) then
                     begin
                        TLabel(Panel.Components[j]).BringToFront;
                     end;
                  end;
                end;

                i := 30;
                TabSheet := TTabSheet.Create(PagQuadroBranco);
                TabSheet.Caption := Copy(linha,2,linha.Length);
                TabSheet.PageControl := PagQuadroBranco;
                TabSheet.TabVisible := False;
                TabSheet.BorderWidth := 0;
                TabSheet.DoubleBuffered := True;
                Panel := Tpanel.Create(TabSheet);
                Panel.DoubleBuffered := true;
                Panel.Align := alClient;
                Panel.Parent := TabSheet;
                Panel.Color := clGreen;
                Panel.ParentBackground := False;
                Panel.BorderWidth := 0;
                Panel.BevelOuter:= bvNone;
                Panel.BorderStyle := bsNone;
                Panel.Tag := 0;
                Panel.OnMouseDown := proximoTab;

                PanelL := TPanel.Create(TabSheet);
                PanelL.Visible := false;
                PanelL.Color := ClGreen;
                PanelL.ParentBackground := False;
                PanelL.BorderWidth := 0;
                PanelL.BevelOuter := bvNone;
                PanelL.BorderStyle := bsNone;
                PanelL.Top := 0;
                PanelL.Left := 0;
                PanelL.Width := Trunc((TabSheet.Width/3)*2);
                PanelL.BringToFront;
                PanelL.Height := 0;
                PanelL.Tag := 2;
                PanelL.DoubleBuffered := true;
                PanelL.Parent := TabSheet;
            end
            else
            begin
                if linha.StartsWith('IM') then
                begin
                  Panel := Tpanel.Create(TabSheet);
                  Panel.DoubleBuffered := true;
                  Panel.Align := alClient;
                  Panel.Parent := TabSheet;
                  Panel.Color := clGreen;
                  Panel.ParentBackground := False;
                  Panel.BorderWidth := 0;
                  Panel.BevelOuter := bvNone;
                  Panel.BorderStyle := bsNone;
                  Panel.Tag := 1;
                  Panel.OnMouseDown := proximoTab;
                  Image := TImage.Create(Panel);
                  Image.Parent := Panel;
                  Image.top := 0;
                  Image.Left := 0;
                  Image.AutoSize := true;
                  Image.Picture.LoadFromFile(trim(Copy(linha,3,linha.Length)));
                  imagem := true;
                end
                else
                begin
                  llabel := TLabel.Create(Panel);
                  llabel.Font.Name := fonte;
                  llabel.Font.Style := [fsBold];
                  llabel.Font.Color := clLime;
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
                  llabel.Visible := not (trim(llabel.Caption) = '');
                  llabel.Caption := llabel.Caption + ' ';
                  i := i + trunc(llabel.Font.Size*1.5);

                  llabelSombra := TLabel.Create(Panel);
                  llabelSombra.Font := llabel.Font;
                  llabelSombra.Top := llabel.top + 4;
                  llabelSombra.left := llabel.left + 3;
                  llabelSombra.Font.Color := clGreen;
                  llabelSombra.caption := llabel.Caption;
                  llabelSombra.Parent := Panel;
                  llabelSombra.SendToBack;
                  imagem := false;
                end;
            end;

            if imagem then
            begin
              PanelL.Height := TabSheet.Height;
            end
            else
            begin
            if not (llabel = nil) then
              PanelL.Height := llabel.Top + llabel.Height;
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
    corletra := clwhite;
    corsombra := clGray;
end;

procedure TFrmQuadroBranco.Minimizar1Click(Sender: TObject);
begin
   FrmQuadroBranco.WindowState := wsMinimized;
end;

procedure TFrmQuadroBranco.proximoTab(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i, l, j, h : integer;
  fim : boolean;
  texto : string;
  PanelL : Tpanel;

begin
  PanelL := nil;
  h := 0;
  if Button = mbLeft then
  begin
  if Shift = [ssShift,ssLeft] then
     TTabsheet(TPanel(Sender).Parent).PageControl.SelectNextPage(false, false)
  else
    if TPanel(Sender).Tag = 1 then
    begin
      for j:=0 to TTabsheet(TPanel(Sender).Parent).ComponentCount-1 do
      begin
         if TTabsheet(TPanel(Sender).Parent).Components[j].Tag = 2 then
         begin
           PanelL := Tpanel(TTabsheet(TPanel(Sender).Parent).Components[j]);
           PanelL.BringToFront;
           h := PanelL.Height;
           PanelL.Height := 1;
           PanelL.Visible := true;
           break;
         end;
      end;

      if Assigned(PanelL) then
      begin
        while PanelL.Height < h do
        begin
          PanelL.Height := PanelL.Height + 3;
          PanelL.Repaint;
        end;
      end;
      TTabsheet(TPanel(Sender).Parent).Repaint;
      TTabsheet(TPanel(Sender).Parent).PageControl.SelectNextPage(true, false);
      PanelL.Visible := false;
    end
    else
    begin
       fim := true;
       i := 0;
       while i <= TPanel(Sender).ComponentCount - 1  do
       begin
         if (TPanel(Sender).Components[i] is TLabel) and
            (Tlabel(TPanel(Sender).Components[i]).Font.Color = clLime) and
            (Tlabel(TPanel(Sender).Components[i]).Visible) then
         begin
           texto := Tlabel(TPanel(Sender).Components[i]).Caption;
           if texto.StartsWith('>') then
           begin
              Delete(texto,1,1);
              Tlabel(TPanel(Sender).Components[i]).Caption := texto;
              Tlabel(TPanel(Sender).Components[i+1]).Caption := texto;

              l := Tlabel(TPanel(Sender).Components[i]).Left;

              Tlabel(TPanel(Sender).Components[i]).Left := Tlabel(TPanel(Sender).Components[i]).Left  - Tlabel(TPanel(Sender).Components[i]).Width - 50;
              Tlabel(TPanel(Sender).Components[i+1]).Left := Tlabel(TPanel(Sender).Components[i]).Left + 3;
              Tlabel(TPanel(Sender).Components[i]).Font.Color := corletra;
              Tlabel(TPanel(Sender).Components[i+1]).Font.Color := corsombra;

              while Tlabel(TPanel(Sender).Components[i]).Left < l do
              begin
                Tlabel(TPanel(Sender).Components[i]).Left := Tlabel(TPanel(Sender).Components[i]).Left + 2;
                Tlabel(TPanel(Sender).Components[i+1]).Left := Tlabel(TPanel(Sender).Components[i]).Left + 3;
                Tlabel(TPanel(Sender).Components[i]).Repaint;
                Tlabel(TPanel(Sender).Components[i+1]).Repaint;
                Application.ProcessMessages;
              end;
           end
           else
           if texto.StartsWith('^') then
           begin
              Delete(texto,1,1);
              Tlabel(TPanel(Sender).Components[i]).Caption := texto;
              Tlabel(TPanel(Sender).Components[i+1]).Caption := texto;

              l := Tlabel(TPanel(Sender).Components[i]).Top;

              Tlabel(TPanel(Sender).Components[i]).Top := TPanel(Sender).Height + Tlabel(TPanel(Sender).Components[i]).Height + 5;
              Tlabel(TPanel(Sender).Components[i+1]).Top := Tlabel(TPanel(Sender).Components[i]).Top + 6;
              Tlabel(TPanel(Sender).Components[i]).Font.Color := corletra;
              Tlabel(TPanel(Sender).Components[i+1]).Font.Color := corsombra;

              while Tlabel(TPanel(Sender).Components[i]).Top > l do
              begin
                Tlabel(TPanel(Sender).Components[i]).top := Tlabel(TPanel(Sender).Components[i]).top - 2;
                Tlabel(TPanel(Sender).Components[i+1]).top := Tlabel(TPanel(Sender).Components[i]).top + 4;
                Tlabel(TPanel(Sender).Components[i]).Repaint;
                Tlabel(TPanel(Sender).Components[i+1]).Repaint;

              end;
           end
           else
           begin
             Tlabel(TPanel(Sender).Components[i]).Font.Color := corletra;
             Tlabel(TPanel(Sender).Components[i+1]).Font.Color := corsombra;
           end;
           fim := i = TPanel(Sender).ComponentCount - 2;
           if Tlabel(TPanel(Sender).Components[i]).Tag = 0 then
             break;
         end;
         i := i + 2;
       end;

       if (fim) or (TPanel(Sender).ComponentCount = 1) then
       begin
          TPanel(Sender).tag := 1;
       end;
    end;
  end;
end;


procedure TFrmQuadroBranco.Sair1Click(Sender: TObject);
begin
  Application.Terminate;
end;

end.
