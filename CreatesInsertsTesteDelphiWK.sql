-- Tabela de Clientes
CREATE TABLE clientes (
    codigo INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cidade VARCHAR(50),
    uf CHAR(2)
);

-- Tabela de Produtos
CREATE TABLE produtos (
    codigo INT PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL,
    preco_venda DECIMAL(10, 2) NOT NULL
);

-- Tabela de Pedidos (Dados Gerais)
CREATE TABLE pedidos (
    numero_pedido INT PRIMARY KEY AUTO_INCREMENT,
    data_emissao DATE NOT NULL,
    codigo_cliente INT NOT NULL,
    valor_total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (codigo_cliente) REFERENCES clientes(codigo)
);

-- Tabela de Produtos do Pedido
CREATE TABLE pedidos_produtos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    numero_pedido INT NOT NULL,
    codigo_produto INT NOT NULL,
    quantidade INT NOT NULL,
    valor_unitario DECIMAL(10, 2) NOT NULL,
    valor_total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (numero_pedido) REFERENCES pedidos(numero_pedido),
    FOREIGN KEY (codigo_produto) REFERENCES produtos(codigo)
);

-- Índices adicionais
CREATE INDEX idx_pedidos_cliente ON pedidos(codigo_cliente);
CREATE INDEX idx_pedidos_produtos_pedido ON pedidos_produtos(numero_pedido);
CREATE INDEX idx_pedidos_produtos_produto ON pedidos_produtos(codigo_produto);



-- Inserir dados na tabela de Clientes
INSERT INTO clientes (codigo, nome, cidade, uf) VALUES
(1, 'João Silva', 'Passo Fundo', 'RS'),
(2, 'Maria Santos', 'Rio de Janeiro', 'RJ'),
(3, 'Pedro Oliveira', 'Belo Horizonte', 'MG'),
(4, 'Ana Rodrigues', 'Salvador', 'BA'),
(5, 'Carlos Ferreira', 'Porto Alegre', 'RS'),
(6, 'Juliana Lima', 'Curitiba', 'PR'),
(7, 'Fernando Costa', 'Fortaleza', 'CE'),
(8, 'Mariana Alves', 'Recife', 'PE'),
(9, 'Roberto Souza', 'Brasília', 'DF'),
(10, 'Camila Pereira', 'Manaus', 'AM'),
(11, 'Lucas Martins', 'Belém', 'PA'),
(12, 'Beatriz Gomes', 'Goiânia', 'GO'),
(13, 'Rodrigo Santos', 'Florianópolis', 'SC'),
(14, 'Patrícia Oliveira', 'Vitória', 'ES'),
(15, 'Marcelo Lima', 'Natal', 'RN'),
(16, 'Fernanda Silva', 'João Pessoa', 'PB'),
(17, 'Gustavo Pereira', 'Maceió', 'AL'),
(18, 'Aline Rodrigues', 'Teresina', 'PI'),
(19, 'Ricardo Almeida', 'São Luís', 'MA'),
(20, 'Cristina Ferreira', 'Aracaju', 'SE');

-- Inserir dados na tabela de Produtos
INSERT INTO produtos (codigo, descricao, preco_venda) VALUES
(1, 'Notebook', 3500.00),
(2, 'Smartphone', 1800.00),
(3, 'TV LED 50"', 2500.00),
(4, 'Geladeira', 3000.00),
(5, 'Máquina de Lavar', 2200.00),
(6, 'Microondas', 500.00),
(7, 'Ar Condicionado', 1800.00),
(8, 'Fogão', 1200.00),
(9, 'Liquidificador', 150.00),
(10, 'Cafeteira', 200.00),
(11, 'Aspirador de Pó', 350.00),
(12, 'Ferro de Passar', 100.00),
(13, 'Ventilador', 180.00),
(14, 'Forno Elétrico', 400.00),
(15, 'Mixer', 80.00),
(16, 'Batedeira', 250.00),
(17, 'Sanduicheira', 120.00),
(18, 'Torradeira', 90.00),
(19, 'Panela Elétrica', 180.00),
(20, 'Purificador de Água', 500.00);



