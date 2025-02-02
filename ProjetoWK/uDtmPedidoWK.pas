unit uDtmPedidoWK;

interface

uses
    System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
    FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
    FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
    FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, FireDAC.Comp.Client, Data.DB,
    FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
    FireDAC.Comp.DataSet, System.IniFiles;

type
  TdtmPedidoWK = class(TDataModule)
    Connection: TFDConnection;
    qryProdutos: TFDQuery;
    qryPedidos: TFDQuery;
    qryPedidosProdutos: TFDQuery;
    qryClientes: TFDQuery;
    mtItensPedido: TFDMemTable;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    procedure ConfigurarConexao;
    procedure ConfigurarTabelas;
  public
    function BuscarCliente(Codigo: Integer): Boolean;
    function BuscarProduto(Codigo: Integer): Boolean;
    function GravarPedido(Codigo_Cliente: Integer; ValorTotal: Double): Integer;
    procedure GravarItensPedido(NumeroPedido: Integer);
    function CarregarPedido(NumeroPedido: Integer): Boolean;
    function CancelarPedido(NumeroPedido: Integer): Boolean;
  end;

var
   dtmPedidoWK: TdtmPedidoWK;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TdtmPedidoWK.DataModuleCreate(Sender: TObject);
begin
     try
        ConfigurarConexao;
        ConfigurarTabelas;
     except
           //
     end;
end;

procedure TdtmPedidoWK.DataModuleDestroy(Sender: TObject);
begin
     if Connection.Connected then
     begin
          Connection.Connected := False;
     end;
end;

procedure TdtmPedidoWK.ConfigurarConexao;
var
   IniFile: TIniFile;
begin
     //IniFile := TIniFile.Create('C:\Users\Bruno\Documents\GitHub\PedidoVendaWK\config.ini');
     IniFile := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'config.ini');

     try
        Connection.Params.Clear;
        Connection.Params.DriverID := 'MySQL';
        Connection.LoginPrompt := False;
        Connection.Params.Database := IniFile.ReadString('Database', 'Database', '');
        Connection.Params.UserName := IniFile.ReadString('Database', 'Username', '');
        Connection.Params.Password := IniFile.ReadString('Database', 'Password', '');
        Connection.Params.Values['Server'] := IniFile.ReadString('Database', 'Server', '');
        Connection.Params.Values['Port'] := IniFile.ReadString('Database', 'Port', '3306');
        Connection.Params.Values['Library'] := IniFile.ReadString('Database', 'Library', '');

        if not Connection.Connected then
        begin
             Connection.Connected := True;
        end;
     finally
            IniFile.Free;
     end;
end;

procedure TdtmPedidoWK.ConfigurarTabelas;
begin
     with mtItensPedido do
     begin
          if Active then
          begin
               Close;
          end;

          FieldDefs.Clear;
          FieldDefs.Add('CODIGO', ftInteger);
          FieldDefs.Add('DESCRICAO', ftString, 100);
          FieldDefs.Add('QUANTIDADE', ftFloat);
          FieldDefs.Add('VALOR_UNITARIO', ftFloat);
          FieldDefs.Add('VALOR_TOTAL', ftFloat);
          CreateDataSet;
     end;
end;

function TdtmPedidoWK.BuscarCliente(Codigo: Integer): Boolean;
begin
     qryClientes.Close;
     qryClientes.SQL.Text := 'SELECT codigo, nome, cidade, uf FROM clientes WHERE codigo = :codigo';
     qryClientes.ParamByName('codigo').AsInteger := Codigo;
     qryClientes.Open;

     Result := not qryClientes.IsEmpty;
end;

function TdtmPedidoWK.BuscarProduto(Codigo: Integer): Boolean;
begin
     qryProdutos.Close;
     qryProdutos.SQL.Text := 'SELECT codigo, descricao, preco_venda FROM produtos WHERE codigo = :codigo';
     qryProdutos.ParamByName('codigo').AsInteger := Codigo;
     qryProdutos.Open;

     Result := not qryProdutos.IsEmpty;
end;

function TdtmPedidoWK.GravarPedido(Codigo_Cliente: Integer; ValorTotal: Double): Integer;
begin
     qryPedidos.Close;
     qryPedidos.SQL.Text := 'INSERT INTO pedidos (data_emissao, codigo_cliente, valor_total) '+
                            'VALUES (:data, :cliente, :total)';
     qryPedidos.ParamByName('data').AsDate := Date;
     qryPedidos.ParamByName('cliente').AsInteger := Codigo_Cliente;
     qryPedidos.ParamByName('total').AsFloat := ValorTotal;
     qryPedidos.ExecSQL;

     Result := Connection.GetLastAutoGenValue('');
end;

procedure TdtmPedidoWK.GravarItensPedido(NumeroPedido: Integer);
begin
     mtItensPedido.First;
     while not mtItensPedido.Eof do
     begin
          qryPedidosProdutos.Close;
          qryPedidosProdutos.SQL.Text := 'INSERT INTO pedidos_produtos (numero_pedido, codigo_produto, quantidade, ' +
                                         'valor_unitario, valor_total) VALUES (:pedido, :produto, :qtd, :valor, :total)';
          qryPedidosProdutos.ParamByName('pedido').AsInteger := NumeroPedido;
          qryPedidosProdutos.ParamByName('produto').AsInteger := mtItensPedido.FieldByName('CODIGO').AsInteger;
          qryPedidosProdutos.ParamByName('qtd').AsFloat := mtItensPedido.FieldByName('QUANTIDADE').AsFloat;
          qryPedidosProdutos.ParamByName('valor').AsFloat := mtItensPedido.FieldByName('VALOR_UNITARIO').AsFloat;
          qryPedidosProdutos.ParamByName('total').AsFloat := mtItensPedido.FieldByName('VALOR_TOTAL').AsFloat;
          qryPedidosProdutos.ExecSQL;

          mtItensPedido.Next;
     end;
end;

function TdtmPedidoWK.CarregarPedido(NumeroPedido: Integer): Boolean;
begin
     Result := False;
     qryPedidos.Close;
     qryPedidos.SQL.Text := 'SELECT p.*, c.nome FROM pedidos p ' +
                            'INNER JOIN clientes c ON c.codigo = p.codigo_cliente ' +
                            'WHERE p.numero_pedido = :numero';
     qryPedidos.ParamByName('numero').AsInteger := NumeroPedido;
     qryPedidos.Open;

     if qryPedidos.IsEmpty then
     begin
          Exit;
     end;

     mtItensPedido.EmptyDataSet;

     qryPedidosProdutos.Close;
     qryPedidosProdutos.SQL.Text := 'SELECT pp.*, p.descricao FROM pedidos_produtos pp ' +
                                    'INNER JOIN produtos p ON p.codigo = pp.codigo_produto ' +
                                    'WHERE pp.numero_pedido = :numero';
     qryPedidosProdutos.ParamByName('numero').AsInteger := NumeroPedido;
     qryPedidosProdutos.Open;

     while not qryPedidosProdutos.Eof do
     begin
          mtItensPedido.Append;
          mtItensPedido.FieldByName('CODIGO').AsInteger := qryPedidosProdutos.FieldByName('codigo_produto').AsInteger;
          mtItensPedido.FieldByName('DESCRICAO').AsString := qryPedidosProdutos.FieldByName('descricao').AsString;
          mtItensPedido.FieldByName('QUANTIDADE').AsFloat := qryPedidosProdutos.FieldByName('quantidade').AsFloat;
          mtItensPedido.FieldByName('VALOR_UNITARIO').AsFloat := qryPedidosProdutos.FieldByName('valor_unitario').AsFloat;
          mtItensPedido.FieldByName('VALOR_TOTAL').AsFloat := qryPedidosProdutos.FieldByName('valor_total').AsFloat;
          mtItensPedido.Post;

          qryPedidosProdutos.Next;
     end;

     Result := True;
end;

function TdtmPedidoWK.CancelarPedido(NumeroPedido: Integer): Boolean;
begin
     Result := False;
     Connection.StartTransaction;

     try
        qryPedidosProdutos.Close;
        qryPedidosProdutos.SQL.Text := 'DELETE FROM pedidos_produtos WHERE numero_pedido = :numero';
        qryPedidosProdutos.ParamByName('numero').AsInteger := NumeroPedido;
        qryPedidosProdutos.ExecSQL;

        qryPedidos.Close;
        qryPedidos.SQL.Text := 'DELETE FROM pedidos WHERE numero_pedido = :numero';
        qryPedidos.ParamByName('numero').AsInteger := NumeroPedido;
        qryPedidos.ExecSQL;

        Connection.Commit;
        Result := True;
     except
           on E: Exception do
           begin
                Connection.Rollback;
           end;
     end;
end;

end.
