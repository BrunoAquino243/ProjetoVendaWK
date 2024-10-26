object dtmPedidoWK: TdtmPedidoWK
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 174
  Width = 395
  object Connection: TFDConnection
    Params.Strings = (
      'User_Name=root'
      'ConnectionDef=MSSQL_Demo')
    Left = 40
    Top = 24
  end
  object qryClientes: TFDQuery
    Connection = Connection
    Left = 40
    Top = 88
  end
  object qryProdutos: TFDQuery
    Connection = Connection
    Left = 128
    Top = 88
  end
  object qryPedidos: TFDQuery
    Connection = Connection
    Left = 208
    Top = 88
  end
  object qryPedidosProdutos: TFDQuery
    Connection = Connection
    Left = 304
    Top = 88
  end
  object mtItensPedido: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 144
    Top = 24
  end
end
