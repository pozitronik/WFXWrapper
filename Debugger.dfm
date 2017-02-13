object TOTAL_CMD: TTOTAL_CMD
  Left = 0
  Top = 0
  Caption = 'TC Filesystem Plugin Wrapper'
  ClientHeight = 654
  ClientWidth = 1424
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object MainSplitter: TSplitter
    Left = 721
    Top = 0
    Height = 654
    ExplicitLeft = 130
    ExplicitTop = 8
  end
  object DebugPanel: TValueListEditor
    Left = 724
    Top = 0
    Width = 700
    Height = 654
    Align = alClient
    TabOrder = 0
    TitleCaptions.Strings = (
      'Function'
      'Result')
    ColWidths = (
      150
      544)
    RowHeights = (
      18
      18)
  end
  object FileList: TListBox
    Left = 0
    Top = 0
    Width = 721
    Height = 654
    Align = alLeft
    ItemHeight = 13
    TabOrder = 1
  end
end
