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
    Left = 729
    Top = 0
    Height = 654
  end
  object FSGrid: TStringGrid
    Left = 0
    Top = 0
    Width = 729
    Height = 654
    Align = alLeft
    TabOrder = 0
    ExplicitLeft = 40
    ExplicitHeight = 505
  end
  object DebugPanel: TValueListEditor
    Left = 732
    Top = 0
    Width = 692
    Height = 654
    Align = alClient
    TabOrder = 1
    TitleCaptions.Strings = (
      'Function'
      'Result')
    ExplicitLeft = 734
    ExplicitWidth = 690
    ColWidths = (
      150
      536)
  end
end
