program ProjetoVendaWK;

uses
    Vcl.Forms,
    uPedidoVenda in 'uPedidoVenda.pas' {frmPedidoVenda},
    uDtmPedidoWK in 'uDtmPedidoWK.pas' {dtmPedidoWK: TDataModule};

{$R *.res}

begin
     Application.Initialize;
     Application.MainFormOnTaskbar := True;
     Application.CreateForm(TdtmPedidoWK, dtmPedidoWK);  // Primeiro cria o DataModule
     Application.CreateForm(TfrmPedidoVenda, frmPedidoVenda);  // Depois cria o Formulário
     Application.Run;
end.
