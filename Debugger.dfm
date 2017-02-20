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
  Menu = MainMenu
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object MainSplitter: TSplitter
    Left = 721
    Top = 0
    Height = 654
    ExplicitLeft = 130
    ExplicitTop = 8
  end
  object FileList: TListBox
    Left = 0
    Top = 0
    Width = 721
    Height = 654
    Align = alLeft
    ItemHeight = 13
    TabOrder = 0
  end
  object DebugPanel: TListBox
    Left = 724
    Top = 0
    Width = 700
    Height = 654
    Align = alClient
    ItemHeight = 13
    TabOrder = 1
  end
  object MainMenu: TMainMenu
    Left = 704
    Top = 336
    object LoadItem: TMenuItem
      Caption = 'Load plugin'
      OnClick = LoadItemClick
    end
    object StartItem: TMenuItem
      Caption = 'Start'
      OnClick = StartItemClick
    end
  end
  object LoadPluginDialog: TOpenDialog
    Filter = 
      'Total Commander filesystem plugin|*.wfx|Total Commander filesyst' +
      'em plugin (unicode)|*.uwfx|Total Commander filesystem plugin (64' +
      '-bit)|*.wfx64'
    Left = 736
    Top = 336
  end
end
