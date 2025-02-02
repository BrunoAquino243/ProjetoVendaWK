unit uPedidoVenda;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
    Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls,
    Vcl.Buttons, Vcl.ExtCtrls, Vcl.Grids, Vcl.DBGrids, System.Math;

type
  TfrmPedidoVenda = class(TForm)
    pnlTop: TPanel;
    pnlBottom: TPanel;
    pnlGrid: TPanel;
    lblQuantidade: TLabel;
    edtQuantidade: TEdit;
    edtValorUnitario: TEdit;
    lblValorUnitario: TLabel;
    lblCodCliente: TLabel;
    edtCodigoCliente: TEdit;
    edtNomeCliente: TEdit;
    edtCodigoProduto: TEdit;
    lblProduto: TLabel;
    edtDescricaoProduto: TEdit;
    btnInserirProduto: TBitBtn;
    gridProdutos: TDBGrid;
    dsItensPedido: TDataSource;
    lblTotal: TLabel;
    edtTotal: TEdit;
    btnGravarPedido: TBitBtn;
    btnCarregarPedido: TBitBtn;
    btnCancelarPedido: TBitBtn;
    lblNomeCliente: TLabel;
    lblDescProduto: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtCodigoClienteExit(Sender: TObject);
    procedure edtCodigoProdutoExit(Sender: TObject);
    procedure btnInserirProdutoClick(Sender: TObject);
    procedure gridProdutosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnGravarPedidoClick(Sender: TObject);
    procedure btnCarregarPedidoClick(Sender: TObject);
    procedure btnCancelarPedidoClick(Sender: TObject);
    procedure edtQuantidadeExit(Sender: TObject);
    procedure edtValorUnitarioExit(Sender: TObject);
  private
    { Private declarations }
    FPedidoCarregado: Integer;
    procedure ValidarCamposProduto;
    procedure LimparCampos;
    procedure LimparCamposProduto;
    procedure AtualizarTotal;
    function FormatarValor(const Valor: string): string;
  public
    { Public declarations }
  end;

var
  frmPedidoVenda: TfrmPedidoVenda;

implementation

{$R *.dfm}

uses uDtmPedidoWK;

procedure TfrmPedidoVenda.AtualizarTotal;
var
   Total: Double;
begin
     Total := 0;
     dtmPedidoWK.mtItensPedido.DisableControls;

     try
        dtmPedidoWK.mtItensPedido.First;
        while not dtmPedidoWK.mtItensPedido.Eof do
        begin
             Total := Total + dtmPedidoWK.mtItensPedido.FieldByName('VALOR_TOTAL').AsFloat;
             dtmPedidoWK.mtItensPedido.Next;
        end;
     finally
            dtmPedidoWK.mtItensPedido.EnableControls;
     end;

     edtTotal.Text := FormatFloat('#,##0.00', Total);
end;

procedure TfrmPedidoVenda.btnInserirProdutoClick(Sender: TObject);
var
   ValorTotal: Double;
begin
     try
        ValidarCamposProduto;

        ValorTotal := StrToFloat(edtQuantidade.Text) * StrToFloat(StringReplace(edtValorUnitario.Text, '.', '', [rfReplaceAll]));

        dtmPedidoWK.mtItensPedido.Append;
        dtmPedidoWK.mtItensPedido.FieldByName('CODIGO').AsInteger := StrToInt(edtCodigoProduto.Text);
        dtmPedidoWK.mtItensPedido.FieldByName('DESCRICAO').AsString := edtDescricaoProduto.Text;
        dtmPedidoWK.mtItensPedido.FieldByName('QUANTIDADE').AsFloat := StrToFloat(edtQuantidade.Text);
        dtmPedidoWK.mtItensPedido.FieldByName('VALOR_UNITARIO').AsFloat := StrToFloat(StringReplace(edtValorUnitario.Text, '.', '', [rfReplaceAll]));
        dtmPedidoWK.mtItensPedido.FieldByName('VALOR_TOTAL').AsFloat := ValorTotal;
        dtmPedidoWK.mtItensPedido.Post;

        AtualizarTotal;
        LimparCamposProduto;
        edtCodigoProduto.SetFocus;
     except
           on E: Exception do
           begin
                ShowMessage(E.Message);
           end;
      end;
end;

procedure TfrmPedidoVenda.btnGravarPedidoClick(Sender: TObject);
var
   NumeroPedido: Integer;
begin
     if edtCodigoCliente.Text = '' then
     begin
          ShowMessage('Informe o cliente!');
          edtCodigoCliente.SetFocus;
          Exit;
     end;

     if dtmPedidoWK.mtItensPedido.IsEmpty then
     begin
          ShowMessage('Adicione produtos ao pedido!');
          edtCodigoProduto.SetFocus;
          Exit;
     end;

     try
        NumeroPedido := dtmPedidoWK.GravarPedido(StrToInt(edtCodigoCliente.Text),
                        StrToFloat(StringReplace(edtTotal.Text, '.', '', [rfReplaceAll])));

        dtmPedidoWK.GravarItensPedido(NumeroPedido);

        ShowMessage('Pedido ' + IntToStr(NumeroPedido) + ' gravado com sucesso!');

        LimparCampos;
     except
           on E: Exception do
           begin
                ShowMessage('Erro ao gravar pedido: ' + E.Message);
           end;
     end;
end;

procedure TfrmPedidoVenda.btnCancelarPedidoClick(Sender: TObject);
var
   NumeroPedido: string;
begin
     if InputQuery('Cancelar Pedido', 'N�mero do Pedido:', NumeroPedido) then
     begin
          try
             if dtmPedidoWK.CancelarPedido(StrToInt(NumeroPedido)) then
             begin
                  ShowMessage('Pedido cancelado com sucesso!');

                  if FPedidoCarregado = StrToInt(NumeroPedido) then
                  begin
                       LimparCampos;
                  end;
            end
            else
                begin
                     ShowMessage('Pedido n�o encontrado!');
                end;
          except
                on E: Exception do
                begin
                     ShowMessage('Erro ao cancelar pedido: ' + E.Message);
                end;
          end;
     end;
end;

procedure TfrmPedidoVenda.btnCarregarPedidoClick(Sender: TObject);
var
   NumeroPedido: string;
begin
     if InputQuery('Carregar Pedido', 'N�mero do Pedido:', NumeroPedido) then
     begin
          try
             if dtmPedidoWK.CarregarPedido(StrToInt(NumeroPedido)) then
             begin
                  FPedidoCarregado := StrToInt(NumeroPedido);
                  edtCodigoCliente.Text := dtmPedidoWK.qryPedidos.FieldByName('codigo_cliente').AsString;
                  edtNomeCliente.Text := dtmPedidoWK.qryPedidos.FieldByName('nome').AsString;

                  AtualizarTotal;
             end
             else
                 begin
                      ShowMessage('Pedido n�o encontrado!');
                 end;
          except
                on E: Exception do
                begin
                     ShowMessage('Erro ao carregar pedido: ' + E.Message);
                end;
          end;
     end;
end;

procedure TfrmPedidoVenda.edtCodigoClienteExit(Sender: TObject);
begin
     if edtCodigoCliente.Text = '' then
     begin
          edtNomeCliente.Clear;
          Exit;
     end;

     if dtmPedidoWK.BuscarCliente(StrToIntDef(edtCodigoCliente.Text, 0)) then
     begin
          edtNomeCliente.Text := dtmPedidoWK.qryClientes.FieldByName('nome').AsString;
          edtCodigoProduto.SetFocus;
     end
     else
         begin
              ShowMessage('Cliente n�o encontrado!');
              edtCodigoCliente.Clear;
              edtNomeCliente.Clear;
              edtCodigoCliente.SetFocus;
         end;
end;

procedure TfrmPedidoVenda.edtCodigoProdutoExit(Sender: TObject);
begin
     if edtCodigoProduto.Text = '' then
     begin
          edtDescricaoProduto.Clear;
          edtValorUnitario.Clear;
          Exit;
     end;

     if dtmPedidoWK.BuscarProduto(StrToIntDef(edtCodigoProduto.Text, 0)) then
     begin
          edtDescricaoProduto.Text := dtmPedidoWK.qryProdutos.FieldByName('descricao').AsString;
          //edtValorUnitario.Text := FormatFloat('#,##0.00',dtmPedidoWK.qryProdutos.FieldByName('preco_venda').AsFloat);
          edtQuantidade.SetFocus;
     end
     else
         begin
              ShowMessage('Produto n�o encontrado!');
              edtCodigoProduto.Clear;
              edtDescricaoProduto.Clear;
              edtValorUnitario.Clear;
              edtCodigoProduto.SetFocus;
         end;
end;

procedure TfrmPedidoVenda.edtQuantidadeExit(Sender: TObject);
begin
     if edtQuantidade.Text <> '' then
     begin
          edtQuantidade.Text := FormatFloat('#,##0.00', StrToFloatDef(edtQuantidade.Text, 0));
          edtValorUnitario.SetFocus;
     end;
end;

procedure TfrmPedidoVenda.edtValorUnitarioExit(Sender: TObject);
begin
     if edtValorUnitario.Text <> '' then
     begin
          edtValorUnitario.Text := FormatFloat('#,##0.00',StrToFloatDef(edtValorUnitario.Text, 0));
          btnInserirProduto.SetFocus;
     end;
end;

function TfrmPedidoVenda.FormatarValor(const Valor: string): string;
begin
     Result := FormatFloat('#,##0.00', StrToFloatDef(Valor, 0));
end;

procedure TfrmPedidoVenda.FormCreate(Sender: TObject);
begin
     FPedidoCarregado := 0;
     dsItensPedido.DataSet := dtmPedidoWK.mtItensPedido;
end;

procedure TfrmPedidoVenda.FormDestroy(Sender: TObject);
begin
     dtmPedidoWK.mtItensPedido.EmptyDataSet;
end;

procedure TfrmPedidoVenda.gridProdutosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
   NovaQtd, NovoValor: string;
begin
     if dtmPedidoWK.mtItensPedido.IsEmpty then
     begin
          Exit;
     end;

     case Key of
          VK_RETURN:
          begin
               NovaQtd := FloatToStr(dtmPedidoWK.mtItensPedido.FieldByName('QUANTIDADE').AsFloat);
               NovoValor := FloatToStr(dtmPedidoWK.mtItensPedido.FieldByName('VALOR_UNITARIO').AsFloat);

               if InputQuery('Altera��o', 'Quantidade:', NovaQtd) and
                  InputQuery('Altera��o', 'Valor Unit�rio:', NovoValor) then
               begin
                    dtmPedidoWK.mtItensPedido.Edit;
                    dtmPedidoWK.mtItensPedido.FieldByName('QUANTIDADE').AsFloat := StrToFloat(NovaQtd);
                    dtmPedidoWK.mtItensPedido.FieldByName('VALOR_UNITARIO').AsFloat := StrToFloat(NovoValor);
                    dtmPedidoWK.mtItensPedido.FieldByName('VALOR_TOTAL').AsFloat := StrToFloat(NovaQtd) * StrToFloat(NovoValor);
                    dtmPedidoWK.mtItensPedido.Post;
                    AtualizarTotal;
               end;
          end;
          VK_DELETE:
          begin
               if MessageDlg('Deseja realmente excluir este item?', mtConfirmation,
                  [mbYes, mbNo], 0) = mrYes then
               begin
                    dtmPedidoWK.mtItensPedido.Delete;
                    AtualizarTotal;
               end;
          end;
     end;
end;

procedure TfrmPedidoVenda.LimparCampos;
begin
     edtCodigoCliente.Clear;
     edtNomeCliente.Clear;
     LimparCamposProduto;
     dtmPedidoWK.mtItensPedido.EmptyDataSet;
     edtTotal.Text := '0,00';
     FPedidoCarregado := 0;
     edtCodigoCliente.SetFocus;
end;

procedure TfrmPedidoVenda.LimparCamposProduto;
begin
     edtCodigoProduto.Clear;
     edtDescricaoProduto.Clear;
     edtQuantidade.Clear;
     edtValorUnitario.Clear;
end;

procedure TfrmPedidoVenda.ValidarCamposProduto;
begin
     if edtCodigoProduto.Text = '' then
     begin
          raise Exception.Create('Informe o c�digo do produto!');
     end;

     if edtQuantidade.Text = '' then
     begin
          raise Exception.Create('Informe a quantidade!');
     end;

     if edtValorUnitario.Text = '' then
     begin
          raise Exception.Create('Informe o valor unit�rio!');
     end;

     if StrToFloatDef(edtQuantidade.Text, 0) <= 0 then
     begin
          raise Exception.Create('Quantidade deve ser maior que zero!');
     end;

     if StrToFloatDef(edtValorUnitario.Text, 0) <= 0 then
     begin
          raise Exception.Create('Valor unit�rio deve ser maior que zero!');
     end;
end;

end.
