object Form2: TForm2
  Left = 346
  Top = 114
  Width = 364
  Height = 184
  Caption = 'TLinksLabel Demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object LinksLabel1: TLinksLabel
    Left = 144
    Top = 62
    Width = 54
    Height = 29
    TextFlick.Enable = True
    Launch.AsHttp.Address = 'bsalsa.com'
    Images = ImageList1
    ImageIndex = 1
    OnLaunch = LinksLabel1Launch
    Caption = 'Home Page'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
  end
  object LinksLabel2: TLinksLabel
    Left = 240
    Top = 62
    Width = 32
    Height = 29
    AutoSize = False
    Launch.AsMail.Address = 'bsalsa@bsalsa.com'
    Launch.AsMail.Subject = 'EmbeddedWB'
    Launch.AsMail.Body = 'About Link Label..'
    Launch.Options = MailTo
    Images = ImageList1
    ImageIndex = 2
    OnLaunch = LinksLabel1Launch
    Alignment = taCenter
    LinkColor = clGreen
    DownColor = clGreen
    UpColor = clMaroon
    Caption = 'MailMe'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
  end
  object LinksLabel3: TLinksLabel
    Left = 72
    Top = 62
    Width = 41
    Height = 29
    AutoSize = False
    Launch.AsApplication.Path = 'notepad.exe'
    Launch.Options = Application
    Images = ImageList1
    ImageIndex = 0
    OnLaunch = LinksLabel1Launch
    Caption = 'Notepad'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
  end
  object LinksLabel4: TLinksLabel
    Left = 0
    Top = 121
    Width = 356
    Height = 29
    AutoSize = False
    TextRun.Enable = True
    Launch.AsApplication.Path = 'bad App'
    Launch.Options = Application
    OnLaunch = LinksLabel1Launch
    Align = alBottom
    Caption = 'Launch Error Demo'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
  end
  object LinksLabel5: TLinksLabel
    Left = 0
    Top = 0
    Width = 356
    Height = 29
    AutoSize = False
    TextRun.Enable = True
    TextRun.Direction = diRightToLeft
    TextStyle = ts3D_F
    Launch.AsHttp.Address = 'bsalsa.com/forum/'
    OnLaunch = LinksLabel1Launch
    Layout = tlTop
    Align = alTop
    Caption = 'Forum'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsUnderline]
  end
  object ImageList1: TImageList
    Left = 400
    Top = 16
    Bitmap = {
      494C010103000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      00000000000000000000000000000000000000000000A15E5D00A5848300947D
      79009E8B8B00A48B8C00AC8C8B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000626262006262620062626200626262000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BF868000D7B39A00D7B3
      9A00C68E6500B57C6300B57C63008F766F008977760097838200A48B8C000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00000073009E9E9E009E9E9E00FFFFFF0048FFFF00FFFFFF0048FFFF00FFFF
      FF0048FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BC7F7500D3DECB00D5FC
      D700E0F2CB00D8E8B100B0CD7600D8D38B00DCB99500C7A17D00A57050009783
      8200000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00000073009E9E9E009E9E9E00FFFFFF00FFFFFF0048FFFF00FFFFFF0048FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BC7F7500D5DBC700E0FD
      E300E5E2B000D0B25D00BDB95B00E3D07900D8D38B00E2E59600CAB57800746C
      65009E8B8B00A68F910000000000000000000000000000000000FFFFFF00FFFF
      FF00000073009E9E9E009E9E9E00FFFFFF0048FFFF00FFFFFF0048FFFF00FFFF
      FF0048FFFF000000000000000000000000000000000080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BC7F7500DDDCCE00D5FC
      D700E3D07900C9964300BD904100CC974C00D2944D00D69D5200D2944D00C896
      6800C8966800B28F66009A878600000000000000000000000000FFFFFF00FFFF
      FF00000073009E9E9E009E9E9E00FFFFFF00FFFFFF0062626200626262006262
      6200FFFFFF0000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BC7F7500C2D7B600B6EF
      B100DBBD6900DDAC4C00C49B4200CC9B4B00CC974C00CC974C00BD7B3600C68E
      6500D4946500DAA56F00AC8C8B00000000000000000000000000FFFFFF00FFFF
      FF00000073009E9E9E009E9E9E00FFFFFF0048FFFF00626262009E9E9E006262
      620048FFFF0000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BC7F7500C2D7B600D8E8
      B100ECB75E00DDAC4C00CDA64000DDAC4C00DDAC4C00CD9E4600C7923800D494
      6500DF9F6800D2AC7C0000000000000000000000000000000000FFFFFF00FFFF
      FF0000007300000073000000730000007300FFFFFF00626262009E9E9E006262
      6200FFFFFF0000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C0C0C000C0C0C000C0C0C000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BC7F7500D3DECB00E2D9
      9700F1BB5200F1BB5200DCB14600EDBA4D00DDAC4C00CDA64000C7923800E1A1
      6100E3AB6A00B399870000000000000000000000000000000000CECECE00FFFF
      FF0048FFFF00FFFFFF0048FFFF00FFFFFF0048FFFF0062626200626262006262
      620048FFFF0000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C000FFFFFF00FFFFFF00FFFFFF00C0C0C000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BC7F7500C2D7B600E3D0
      7900F4C15D00F4C15D00E4B94800EDBA4D00EDBA4D00E2B14700DCA03D00EDAC
      6000E3AB6A00AA918F000000000000000000000000000000000062626200CECE
      CE00FFFFFF0048FFFF00FFFFFF0048FFFF00FFFFFF0048FFFF00FFFFFF0048FF
      FF006262620062626200000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00C0C0C000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0C000FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BB837D00DAD6BB00F2D3
      8200F2CC7500EEC76900E2C05200EDBE5800F1BB5200EDBA4D00E3AE3D00FDBC
      6300D2AC7C00AE8485000000000000000000000000002525FF002525FF006262
      6200CECECE00FFFFFF0048FFFF00FFFFFF0048FFFF00FFFFFF0048FFFF00CECE
      CE002525FF002525FF00000000000000000000000000FFFFFF00FFFFFF00C0C0
      C000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0
      C000FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BB837D00E0C59D00F2D3
      8200ECD88800EED07C00E1C96600F3C66B00ECC56200E2C05200E3AE3D00FDBC
      6300B8A38B0000000000000000000000000000000000000000002525FF002525
      FF0062626200CECECE00FFFFFF0048FFFF00FFFFFF0048FFFF00CECECE002525
      FF002525FF0000000000000000000000000000000000FFFFFF00C0C0C000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00C0C0C000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BB837D00E4B98100F0DC
      9700F0DC9700F0DC9700E3D07900E3D07900E1CB6C00E1C96600EDBE5800E8B3
      6C00AA918F000000000000000000000000000000000000000000000000002525
      FF002525FF0062626200CECECE00FFFFFF0048FFFF00CECECE002525FF002525
      FF000000000000000000000000000000000000000000C0C0C000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BC7F7500EDC49600FDEC
      C200FCE9B900F6E2AA00D8D38B00ECD88800ECD88800F2D38200F3C66B00D3A9
      7500AE84850000000000000000000000000000000000000000000000DC000000
      00002525FF002525FF0062626200CECECE00CECECE002525FF002525FF000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0817600D0968E00B8B6
      AD00E9CDB200D0D0C300D9BDAD00D8CCAD00E9CDB200DAD6BB00EDC49600B8A3
      8B000000000000000000000000000000000000000000000000000000DC000000
      7300000000002525FF002525FF002525FF002525FF002525FF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000AB6C61009D8D9300788C
      9C009D8D93007E8C9500A09198008A9AA3009D9BA4006DA6B900B19DA000839F
      AB000000000000000000000000000000000000000000000000000000DC000000
      730000000000000000002525FF002525FF000000FF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000009563
      65008E7C81008E5E5E007E8C9500A58483008A9AA300939097006DA6B9000000
      00000000000000000000000000000000000000000000000000000000DC000000
      7300000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF0081FF8003FFFF0000801F8003FFFF0000
      800F8003FFFF0000800380038001000080018003800100008001800380010000
      8003800380010000800380038001000080030001800100008003000180010000
      80078003800100008007C007800100008007C00F80010000800FC01FFFFF0000
      800FC83FFFFF0000E01FCC7FFFFF000000000000000000000000000000000000
      000000000000}
  end
end
