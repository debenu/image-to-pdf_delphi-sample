object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Debenu Quick PDF Library Sample: Convert Image to PDF'
  ClientHeight = 317
  ClientWidth = 564
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 548
    Height = 161
    Caption = 'Images to Convert'
    TabOrder = 0
    object ListBox1: TListBox
      Left = 11
      Top = 29
      Width = 430
      Height = 129
      ItemHeight = 13
      TabOrder = 0
    end
    object btnAddImage: TButton
      Left = 447
      Top = 29
      Width = 87
      Height = 25
      Caption = 'Add Image'
      TabOrder = 1
      OnClick = btnAddImageClick
    end
    object btnRemoveImage: TButton
      Left = 447
      Top = 60
      Width = 87
      Height = 25
      Caption = 'Remove Image'
      TabOrder = 2
      OnClick = btnRemoveImageClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 175
    Width = 548
    Height = 90
    Caption = 'Output'
    TabOrder = 1
    object lblOutputStatusDesc: TLabel
      Left = 11
      Top = 64
      Width = 43
      Height = 13
      Caption = 'Status: '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblOutputStatus: TLabel
      Left = 60
      Top = 64
      Width = 48
      Height = 13
      Caption = 'Waiting...'
    end
    object btnBrowse: TButton
      Left = 445
      Top = 24
      Width = 89
      Height = 25
      Caption = 'Browse...'
      TabOrder = 0
      OnClick = btnBrowseClick
    end
    object txtOutputLocation: TEdit
      Left = 11
      Top = 26
      Width = 428
      Height = 21
      TabOrder = 1
    end
  end
  object btnConvert: TButton
    Left = 400
    Top = 284
    Width = 75
    Height = 25
    Caption = 'Convert'
    TabOrder = 2
    OnClick = btnConvertClick
  end
  object btnCancel: TButton
    Left = 481
    Top = 284
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object dlgOpen: TOpenDialog
    Left = 296
    Top = 272
  end
end
