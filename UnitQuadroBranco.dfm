object FrmQuadroBranco: TFrmQuadroBranco
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Quadro Branco'
  ClientHeight = 581
  ClientWidth = 651
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = PopupMenu
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PagQuadroBranco: TPageControl
    Left = 0
    Top = 345
    Width = 651
    Height = 236
    Align = alClient
    MultiLine = True
    TabOrder = 0
  end
  object MemoConteudo: TMemo
    Left = 0
    Top = 0
    Width = 651
    Height = 345
    Align = alTop
    Lines.Strings = (
      'MemoConteudo')
    TabOrder = 1
    Visible = False
  end
  object OpenDialog: TOpenDialog
    FileName = '*.txt'
    Filter = '*.txt'
    Left = 524
    Top = 48
  end
  object PopupMenu: TPopupMenu
    Left = 312
    Top = 280
    object Abrir1: TMenuItem
      Caption = 'Abrir'
      OnClick = Abrir1Click
    end
    object Apresentar1: TMenuItem
      Caption = 'Apresentar'
      OnClick = Apresentar1Click
    end
    object Minimizar1: TMenuItem
      Caption = 'Minimizar'
      OnClick = Minimizar1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Sair1: TMenuItem
      Caption = 'Sair'
      OnClick = Sair1Click
    end
  end
end
