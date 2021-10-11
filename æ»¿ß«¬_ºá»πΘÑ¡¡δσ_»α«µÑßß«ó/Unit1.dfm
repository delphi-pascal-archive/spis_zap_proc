object Form1: TForm1
  Left = 218
  Top = 136
  Width = 803
  Height = 615
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #1057#1087#1080#1089#1086#1082' '#1079#1072#1087#1091#1097#1077#1085#1085#1099#1093' '#1087#1088#1086#1094#1077#1089#1089#1086#1074
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  Icon.Data = {
    0000010001002020040000000000E80200001600000028000000200000004000
    0000010004000000000000020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000070000007000000000000000000000700000000000070000000000000
    0007000000077000000000000000000000000000777777770000070000000000
    0003B377777777777733007000000000003BBB777777777777BBB00700000007
    03BBBB777777777777BBBB00000000003BBBBBB7777777777BBBBBB000000000
    BBBBBBB7777777778BBBBBB307000003BBBBBBBB77777777BBBBBBBB3000070B
    BBBBBBBB8777777BBBBBBBBB3000003BBBBBBBBBB777777BBBBBBBBBB070003B
    BBBBBBBBB87777BBBBBBBBBBB30000BBBBBBBBBBBB7778BBBBBBBBBBB30000BB
    BBBBBBBBBB877BBBBBBBBBBBB300003BBBBBBBBBBBB7BBBBBBBBBBBBB3000000
    0000377777777777777100000000000000000777777B77777770000000000000
    00000077777BB77777000000007007000000007777BBB8777700000000000000
    0000000777BBBB777000000000000000000000077BBBBBB70000000007000000
    00000077BBBBBBB7700000000000000100000077BBBBBBBB7700000070000000
    0000077BBBBBBBBB77700000000000007000777BBBBBBBBBB777000000000000
    070077888888888888700100000000000087078888888FF88870700000000000
    000073B88FFFFFF8837700000000000000000077388888737700000000000000
    000000000788888000000000000000000000000000000000000000000000FFF0
    0FFFFF8001FFFE0000FFFC00003FF800001FF000000FE000000FE0000007C000
    0003C00000038000000380000001800000018000000180000001800000018000
    0001800000018000000180000003C0000003C0000003E0000007E0000007F000
    000FF000001FF800003FFC00007FFF0000FFFFC003FFFFF81FFFFFFFFFFF}
  Menu = MainMenu1
  OldCreateOrder = False
  ShowHint = True
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    795
    563)
  PixelsPerInch = 120
  TextHeight = 17
  object StatusBar1: TStatusBar
    Left = 0
    Top = 543
    Width = 795
    Height = 20
    Panels = <
      item
        Alignment = taCenter
        Width = 120
      end
      item
        Width = 50
      end>
  end
  object Button1: TButton
    Left = 8
    Top = 512
    Width = 153
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1089#1087#1080#1089#1086#1082
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button3: TButton
    Left = 624
    Top = 512
    Width = 161
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1047#1072#1074#1077#1088#1096#1080#1090#1100' '#1087#1088#1086#1089#1077#1089#1089
    TabOrder = 2
    OnClick = Button3Click
  end
  object ListView1: TListView
    Left = 0
    Top = 0
    Width = 795
    Height = 505
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = #1055#1088#1086#1094#1077#1089#1089#1099
        Width = 170
      end
      item
        Caption = #1054#1087#1080#1089#1072#1085#1080#1077
        Width = 235
      end
      item
        Alignment = taCenter
        Caption = #1048#1084#1103' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
        Width = 131
      end
      item
        Caption = #1055#1091#1090#1100
        Width = 262
      end
      item
        Alignment = taCenter
        Caption = #1055#1088#1080#1086#1088#1080#1090#1077#1090
        Width = 144
      end
      item
        Alignment = taRightJustify
        Caption = #1055#1072#1084#1103#1090#1100
        Width = 105
      end
      item
        Alignment = taRightJustify
        Caption = 'ID'
        Width = 65
      end>
    ReadOnly = True
    RowSelect = True
    PopupMenu = PopupMenu1
    SmallImages = ImageList1
    TabOrder = 3
    ViewStyle = vsReport
    OnCustomDrawItem = ListView1CustomDrawItem
  end
  object ImageList1: TImageList
    BkColor = clWhite
    Left = 72
    Top = 120
  end
  object MainMenu1: TMainMenu
    Left = 108
    Top = 120
    object N1: TMenuItem
      Caption = #1060#1072#1081#1083
      object N10: TMenuItem
        Caption = #1042#1099#1093#1086#1076
        OnClick = N10Click
      end
    end
    object N2: TMenuItem
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      object N3: TMenuItem
        AutoCheck = True
        Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1089#1087#1080#1089#1086#1082
        Checked = True
        OnClick = N3Click
      end
      object Windows1: TMenuItem
        AutoCheck = True
        Caption = #1047#1072#1075#1088#1091#1078#1072#1090#1100' '#1074#1084#1077#1089#1090#1077' '#1089' Windows'
        OnClick = Windows1Click
      end
    end
    object N5: TMenuItem
      Caption = #1047#1072#1074#1077#1088#1096#1077#1085#1080#1077' '#1088#1072#1073#1086#1090#1099
      object N6: TMenuItem
        Caption = #1055#1077#1088#1077#1093#1086#1076' '#1074' '#1078#1076#1091#1097#1080#1081' '#1088#1077#1078#1080#1084
        OnClick = N6Click
      end
      object N8: TMenuItem
        Caption = #1055#1077#1088#1077#1079#1072#1075#1088#1091#1079#1082#1072
        OnClick = N8Click
      end
      object N9: TMenuItem
        Caption = #1042#1099#1082#1083#1102#1095#1077#1085#1080#1077
        OnClick = N9Click
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 144
    Top = 120
    object N4: TMenuItem
      Caption = #1047#1072#1074#1077#1088#1096#1080#1090#1100' '#1087#1088#1086#1089#1077#1089#1089
      OnClick = N4Click
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 180
    Top = 120
    object N15: TMenuItem
      Caption = #1054#1090#1082#1088#1099#1090#1100' .... ('#1080#1084#1103' '#1087#1088#1086#1075#1088#1072#1084#1084#1099')'
      OnClick = N15Click
    end
    object N16: TMenuItem
      Caption = '-'
    end
    object N12: TMenuItem
      Caption = #1055#1077#1088#1077#1093#1086#1076' '#1074' '#1078#1076#1091#1097#1080#1081' '#1088#1077#1078#1080#1084
      OnClick = N12Click
    end
    object N13: TMenuItem
      Caption = #1055#1077#1088#1077#1079#1072#1075#1088#1091#1079#1082#1072
      OnClick = N13Click
    end
    object N14: TMenuItem
      Caption = #1042#1099#1082#1083#1102#1095#1077#1085#1080#1077
      OnClick = N14Click
    end
    object N11: TMenuItem
      Caption = '-'
    end
    object N7: TMenuItem
      Caption = #1042#1099#1093#1086#1076
      OnClick = N7Click
    end
  end
  object XPManifest1: TXPManifest
    Left = 222
    Top = 120
  end
end
