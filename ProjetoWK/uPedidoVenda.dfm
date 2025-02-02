object frmPedidoVenda: TfrmPedidoVenda
  Left = 0
  Top = 0
  HelpType = htKeyword
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Pedido Venda'
  ClientHeight = 384
  ClientWidth = 541
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 541
    Height = 33
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 599
    object lblCodCliente: TLabel
      Left = 8
      Top = 6
      Width = 68
      Height = 15
      Caption = 'C'#243'd. Cliente:'
    end
    object lblNomeCliente: TLabel
      Left = 212
      Top = 6
      Width = 76
      Height = 15
      Caption = 'Nome Cliente:'
    end
    object edtCodigoCliente: TEdit
      Left = 80
      Top = 4
      Width = 121
      Height = 23
      TabOrder = 1
      OnExit = edtCodigoClienteExit
    end
    object edtNomeCliente: TEdit
      Left = 294
      Top = 4
      Width = 121
      Height = 23
      Enabled = False
      ReadOnly = True
      TabOrder = 0
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 337
    Width = 541
    Height = 47
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 371
    object btnGravarPedido: TBitBtn
      Tag = 16
      Left = 24
      Top = 13
      Width = 105
      Height = 25
      Hint = 'Localizar registros'
      Caption = '&Gravar Pedido'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = btnGravarPedidoClick
    end
    object btnCarregarPedido: TBitBtn
      Tag = 17
      Left = 212
      Top = 13
      Width = 105
      Height = 25
      Hint = 'Pesquisar todos'
      Caption = '&Carregar Pedido'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = btnCarregarPedidoClick
    end
    object btnCancelarPedido: TBitBtn
      Tag = 16
      Left = 413
      Top = 13
      Width = 105
      Height = 25
      Hint = 'Localizar registros'
      Caption = 'Cancelar Pedido'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = btnCancelarPedidoClick
    end
  end
  object pnlGrid: TPanel
    Left = 0
    Top = 33
    Width = 541
    Height = 304
    Align = alTop
    TabOrder = 2
    object lblQuantidade: TLabel
      Left = 252
      Top = 6
      Width = 72
      Height = 15
      Caption = 'Qtd. Produto:'
    end
    object lblValorUnitario: TLabel
      Left = 342
      Top = 6
      Width = 65
      Height = 15
      Caption = 'Vlr. Unit'#225'rio:'
    end
    object lblProduto: TLabel
      Left = 8
      Top = 6
      Width = 71
      Height = 15
      Caption = 'C'#243'd. Produto'
    end
    object lblTotal: TLabel
      Left = 8
      Top = 275
      Width = 48
      Height = 15
      Caption = 'Vlr. Total:'
    end
    object lblDescProduto: TLabel
      Left = 98
      Top = 6
      Width = 97
      Height = 15
      Caption = 'Descri'#231#227'o Produto'
    end
    object edtQuantidade: TEdit
      Left = 252
      Top = 27
      Width = 72
      Height = 23
      TabOrder = 2
      OnExit = edtQuantidadeExit
    end
    object edtValorUnitario: TEdit
      Left = 342
      Top = 27
      Width = 77
      Height = 23
      TabOrder = 4
      OnExit = edtValorUnitarioExit
    end
    object edtCodigoProduto: TEdit
      Left = 8
      Top = 27
      Width = 71
      Height = 23
      TabOrder = 0
      OnExit = edtCodigoProdutoExit
    end
    object edtDescricaoProduto: TEdit
      Left = 98
      Top = 27
      Width = 135
      Height = 23
      Enabled = False
      ReadOnly = True
      TabOrder = 1
    end
    object btnInserirProduto: TBitBtn
      Tag = 16
      Left = 429
      Top = 25
      Width = 105
      Height = 25
      Hint = 'Localizar registros'
      Caption = '&Inserir'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      OnClick = btnInserirProdutoClick
    end
    object gridProdutos: TDBGrid
      Left = 8
      Top = 56
      Width = 526
      Height = 210
      DataSource = dsItensPedido
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
      ReadOnly = True
      TabOrder = 3
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      OnKeyDown = gridProdutosKeyDown
    end
    object edtTotal: TEdit
      Left = 60
      Top = 272
      Width = 69
      Height = 23
      Enabled = False
      ReadOnly = True
      TabOrder = 5
    end
  end
  object dsItensPedido: TDataSource
    Left = 408
    Top = 193
  end
end
