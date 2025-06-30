
--------------------------------------------------------------------
-- PARTE 1 BD-Projeto em Trio
--------------------------------------------------------------------

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';



-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;



-- -----------------------------------------------------
-- Table `Categoria_Produto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Categoria_Produto` (
  `idCategoria_Produto` INT NOT NULL AUTO_INCREMENT,
  `Nome_Categoria` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`idCategoria_Produto`),
  UNIQUE INDEX `Nome_Categoria_UNIQUE` (`Nome_Categoria` ASC) VISIBLE) 
  ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `Fornecedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Fornecedor` (
  `idFornecedor` INT NOT NULL AUTO_INCREMENT,
  `Nome_Fornecedor` VARCHAR(100) NOT NULL,
  `CNPJ` VARCHAR(20) NOT NULL,
  `telefone` VARCHAR(15) NULL,
  `Email` VARCHAR(100) NULL,
  PRIMARY KEY (`idFornecedor`),
  UNIQUE INDEX `CNPJ_UNIQUE` (`CNPJ` ASC) VISIBLE
) ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `Produto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Produto` (
  `idProduto` INT NOT NULL AUTO_INCREMENT,
  `Nome_Produto` VARCHAR(100) NOT NULL,
  `Preco` DECIMAL(10,2) NOT NULL,
  `idCategoria_Produto` INT NULL,
  `idFornecedor` INT NULL,
  PRIMARY KEY (`idProduto`),
  CONSTRAINT `fk_Produto_Categoria`
    FOREIGN KEY (`idCategoria_Produto`)
    REFERENCES `Categoria_Produto` (`idCategoria_Produto`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Produto_Fornecedor`
    FOREIGN KEY (`idFornecedor`)
    REFERENCES `Fornecedor` (`idFornecedor`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `Estoque`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Estoque` (
  `idEstoque` INT NOT NULL AUTO_INCREMENT,
  `Quantidade` INT NOT NULL,
  `Data_Entrada` DATE NOT NULL,
  `idProduto` INT NULL,
  PRIMARY KEY (`idEstoque`),
  CONSTRAINT `fk_Estoque_Produto`
    FOREIGN KEY (`idProduto`)
    REFERENCES `Produto` (`idProduto`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `Cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Cliente` (
  `idCliente` INT NOT NULL AUTO_INCREMENT,
  `Nome_Cliente` VARCHAR(100) NOT NULL,
  `CPF` VARCHAR(14) NOT NULL,
  `Email` VARCHAR(100) NULL,
  `Telefone` VARCHAR(15) NULL,
  `Endereco` VARCHAR(200) NULL,
  PRIMARY KEY (`idCliente`),
  UNIQUE INDEX `CPF_UNIQUE` (`CPF` ASC) VISIBLE
) ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `Funcionario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Funcionario` (
  `idFuncionario` INT NOT NULL AUTO_INCREMENT,
  `Nome_Funcionario` VARCHAR(100) NOT NULL,
  `CPF` VARCHAR(14) NOT NULL,
  `Cargo` VARCHAR(50) NULL,
  `Email` VARCHAR(100) NULL,
  PRIMARY KEY (`idFuncionario`),
  UNIQUE INDEX `CPF_UNIQUE` (`CPF` ASC) VISIBLE
) ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `Venda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Venda` (
  `idVenda` INT NOT NULL AUTO_INCREMENT,
  `Data_Venda` DATE NOT NULL,
  `Valor_Total` DECIMAL(10,2) NOT NULL,
  `idCliente` INT NULL,
  `idFuncionario` INT NULL,
  PRIMARY KEY (`idVenda`),
  CONSTRAINT `fk_Venda_Cliente`
    FOREIGN KEY (`idCliente`)
    REFERENCES `Cliente` (`idCliente`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Venda_Funcionario`
    FOREIGN KEY (`idFuncionario`)
    REFERENCES `Funcionario` (`idFuncionario`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `Item_Venda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Item_Venda` (
  `idItem_Venda` INT NOT NULL AUTO_INCREMENT,
  `Quantidade` INT NOT NULL,
  `Preco_Unitario` DECIMAL(10,2) NOT NULL,
  `idProduto` INT NOT NULL,
  `idVenda` INT NOT NULL,
  PRIMARY KEY (`idItem_Venda`),
  CONSTRAINT `fk_ItemVenda_Venda`
    FOREIGN KEY (`idVenda`)
    REFERENCES `Venda` (`idVenda`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_ItemVenda_Produto`
    FOREIGN KEY (`idProduto`)
    REFERENCES `Produto` (`idProduto`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `Promocao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Promocao` (
  `idPromocao` INT NOT NULL AUTO_INCREMENT,
  `Nome_Promocao` VARCHAR(100) NOT NULL,
  `Data_Inicio` DATE NOT NULL,
  `Data_Fim` DATE NOT NULL,
  `Desconto` DECIMAL(5,2) NOT NULL,
  PRIMARY KEY (`idPromocao`)
) ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `Produto_Promocao`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Produto_Promocao` (
  `idProduto_Promocao` INT NOT NULL AUTO_INCREMENT,
  `idProduto` INT NOT NULL,
  `idPromocao` INT NOT NULL,
  PRIMARY KEY (`idProduto_Promocao`),
  CONSTRAINT `fk_ProdutoPromocao_Produto`
    FOREIGN KEY (`idProduto`)
    REFERENCES `Produto` (`idProduto`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_ProdutoPromocao_Promocao`
    FOREIGN KEY (`idPromocao`)
    REFERENCES `Promocao` (`idPromocao`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;



-- -----------------------------------------------------
--Alterações nas estruturas das tabelas
-- -----------------------------------------------------
ALTER TABLE Produto ADD COLUMN Status ENUM('Ativo', 'Inativo') DEFAULT 'Ativo';
ALTER TABLE Cliente MODIFY COLUMN Telefone VARCHAR(20);
ALTER TABLE Cliente ADD COLUMN Data_Cadastro DATE DEFAULT CURRENT_DATE;
ALTER TABLE Cliente CHANGE COLUMN Endereco Endereco_Completo VARCHAR(200);
ALTER TABLE Funcionario DROP COLUMN Cargo;
ALTER TABLE Venda ADD COLUMN Observacao TEXT NULL;
ALTER TABLE Fornecedor MODIFY COLUMN CNPJ CHAR(18);
ALTER TABLE Promocao ADD COLUMN Ativo BOOLEAN DEFAULT TRUE;
ALTER TABLE Fornecedor CHANGE telefone Telefone_Fornecedor VARCHAR(15);
ALTER TABLE Cliente MODIFY Nome_Cliente VARCHAR(150);
ALTER TABLE Venda ADD COLUMN Observacoes TEXT;
ALTER TABLE Item_Venda MODIFY Preco_Unitario DECIMAL(12,2);
ALTER TABLE Funcionario ADD COLUMN Ativo BOOLEAN DEFAULT TRUE;
ALTER TABLE Produto_Promocao ADD COLUMN idFornecedor INT,
ADD CONSTRAINT fk_ProdPromo_Fornecedor FOREIGN KEY (idFornecedor) REFERENCES Fornecedor(idFornecedor);
ALTER TABLE Cliente MODIFY Email VARCHAR(100) NOT NULL;



-- -----------------------------------------------------
--Destruição do banco de dados(segunda)
-- -----------------------------------------------------
DROP VIEW IF EXISTS vw_vendas_por_cliente;
DROP VIEW IF EXISTS vw_estoque_baixo;
DROP VIEW IF EXISTS vw_promocoes_ativas;
DROP VIEW IF EXISTS vw_produtos_promocao;
DROP VIEW IF EXISTS vw_vendas_por_funcionario;
DROP VIEW IF EXISTS vw_total_vendas_diario;
DROP VIEW IF EXISTS vw_clientes_ativos;
DROP VIEW IF EXISTS vw_mais_vendidos;
DROP VIEW IF EXISTS vw_funcionarios_ativos;
DROP VIEW IF EXISTS vw_clientes_compras;

DROP TABLE IF EXISTS Produto_Promocao;
DROP TABLE IF EXISTS Promocao;
DROP TABLE IF EXISTS Item_Venda;
DROP TABLE IF EXISTS Venda;
DROP TABLE IF EXISTS Funcionario;
DROP TABLE IF EXISTS Cliente;
DROP TABLE IF EXISTS Estoque;
DROP TABLE IF EXISTS Produto;
DROP TABLE IF EXISTS Fornecedor;
DROP TABLE IF EXISTS Categoria_Produto;

DROP SCHEMA IF EXISTS mydb;



-- -----------------------------------------------------
--inserts de dados
-- -----------------------------------------------------
INSERT INTO Categoria_Produto (Nome_Categoria) VALUES
('Camisetas'),
('Calças'),
('Saias'),
('Vestidos'),
('Acessórios');

INSERT INTO Fornecedor (Nome_Fornecedor, CNPJ, telefone, Email) VALUES
('EstiloModa', '12.345.678/0001-90', '(11) 98765-4321', 'contato@estilomoda.com.br'),
('FashionWear', '23.456.789/0001-80', '(21) 97890-1234', 'vendas@fashionwear.com.br'),
('Elegance', '34.567.890/0001-70', '(41) 96543-2109', 'pedidos@elegance.com.br'),
('ModaChic', '45.678.901/0001-60', '(31) 95432-1098', 'atendimento@modachic.com.br'),
('BestFashion', '56.789.012/0001-50', '(51) 94321-0987', 'comercial@bestfashion.com.br');

INSERT INTO Produto (Nome_Produto, Preco, idCategoria_Produto, idFornecedor) VALUES
('Camiseta Básica', 29.99, 1, 1),
('Calça Jeans Skinny', 89.99, 2, 2),
('Saia Midi Floral', 59.99, 3, 3),
('Vestido Longo Estampado', 129.99, 4, 4),
('Colar Pedras', 49.99, 5, 5),
('Camiseta Listrada', 39.99, 1, 1),
('Calça Sarja', 79.99, 2, 2),
('Saia Lápis', 69.99, 3, 3),
('Vestido Curto', 99.99, 4, 4),
('Brinco Argola', 29.99, 5, 5);

INSERT INTO Estoque (Quantidade, Data_Entrada, idProduto) VALUES
(100, '2024-01-10', 1),
(200, '2024-01-15', 2),
(150, '2024-01-20', 3),
(50, '2024-02-01', 4),
(30, '2024-02-05', 5),
(120, '2024-02-10', 6),
(180, '2024-02-15', 7),
(250, '2024-02-20', 8),
(60, '2024-03-01', 9),
(40, '2024-03-05', 10);

INSERT INTO Cliente (Nome_Cliente, CPF, Email, Telefone, Endereco) VALUES
('João Silva', '123.456.789-00', 'joao.silva@email.com', '(11) 91234-5678', 'Rua A, 100, Centro'),
('Maria Souza', '234.567.890-11', 'maria.souza@email.com', '(21) 92345-6789', 'Avenida B, 200, Copacabana'),
('Pedro Almeida', '345.678.901-22', 'pedro.almeida@email.com', '(41) 93456-7890', 'Rua C, 300, Batel'),
('Ana Oliveira', '456.789.012-33', 'ana.oliveira@email.com', '(31) 94567-8901', 'Avenida D, 400, Savassi'),
('Carlos Pereira', '567.890.123-44', 'carlos.pereira@email.com', '(51) 95678-9012', 'Rua E, 500, Moinhos de Vento');

INSERT INTO Funcionario (Nome_Funcionario, CPF, Cargo, Email) VALUES
('Roberto Carlos', '678.901.234-55', 'Gerente', 'roberto.carlos@email.com'),
('Fernanda Lima', '789.012.345-66', 'Vendedor', 'fernanda.lima@email.com'),
('Ricardo Pereira', '890.123.456-77', 'Vendedor', 'ricardo.pereira@email.com'),
('Juliana Alves', '901.234.567-88', 'Caixa', 'juliana.alves@email.com'),
('Bruno Gagliasso', '012.345.678-99', 'Estoquista', 'bruno.gagliasso@email.com');

INSERT INTO Venda (Data_Venda, Valor_Total, idCliente, idFuncionario) VALUES
('2024-03-01', 1300.00, 1, 1),
('2024-03-05', 100.00, 2, 2),
('2024-03-10', 75.00, 3, 3),
('2024-03-15', 50.00, 4, 4),
('2024-03-20', 1500.00, 5, 1),
('2024-03-22', 2600.00, 1, 2),
('2024-03-25', 140.00, 2, 3),
('2024-03-28', 20.00, 3, 4),
('2024-04-01', 40.00, 4, 1),
('2024-04-03', 800.00, 5, 2);

INSERT INTO Item_Venda (Quantidade, Preco_Unitario, idProduto, idVenda) VALUES
(1, 29.99, 1, 1),
(1, 89.99, 2, 2),
(1, 59.99, 3, 3),
(1, 129.99, 4, 4),
(1, 49.99, 5, 5),
(2, 29.99, 6, 6),
(1, 39.99, 6, 6),
(2, 79.99, 7, 7),
(4, 69.99, 8, 8),
(1, 99.99, 9, 9),
(1, 29.99, 10, 10);

INSERT INTO Promocao (Nome_Promocao, Data_Inicio, Data_Fim, Desconto) VALUES
('Liquidação Verão', '2024-01-01', '2024-01-31', 0.10),
('Semana da Moda', '2024-03-15', '2024-03-21', 0.05),
('Black Friday', '2024-11-29', '2024-11-29', 0.20),
('Natal Fashion', '2024-12-20', '2024-12-25', 0.15),
('Dia do Estilo', '2024-04-23', '2024-04-23', 0.10);

INSERT INTO Produto_Promocao (idProduto, idPromocao) VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 5),
(5, 4),
(6,1),
(7,1),
(8,2),
(9,5),
(10,4);



-- -----------------------------------------------------
--atualizaçoes e deletes dos inserts
-- -----------------------------------------------------
UPDATE Cliente SET Email = 'joao.silva.novo@email.com' WHERE Nome_Cliente = 'João Silva';
UPDATE Fornecedor SET telefone = '(11) 99887-7654' WHERE Nome_Fornecedor = 'EstiloModa';
UPDATE Produto SET Preco = 34.99 WHERE Nome_Produto = 'Camiseta Básica';
UPDATE Estoque SET Quantidade = 150 WHERE idProduto = 1;
UPDATE Funcionario SET Cargo = 'Gerente de Vendas' WHERE Nome_Funcionario = 'Fernanda Lima';
UPDATE Venda SET Valor_Total = 1400.00 WHERE idVenda = 1;
UPDATE Item_Venda SET Preco_Unitario = 34.99 WHERE idProduto = 1 AND idVenda = 1;
UPDATE Promocao SET Data_Fim = '2024-02-15' WHERE Nome_Promocao = 'Liquidação Verão';
UPDATE Categoria_Produto SET Nome_Categoria = 'Camisas' WHERE Nome_Categoria = 'Camisetas';

DELETE FROM Cliente WHERE Nome_Cliente = 'Carlos Pereira';
DELETE FROM Fornecedor WHERE Nome_Fornecedor = 'BestFashion';
DELETE FROM Produto WHERE Nome_Produto = 'Brinco Argola';
DELETE FROM Estoque WHERE idProduto = 10;
DELETE FROM Funcionario WHERE Nome_Funcionario = 'Bruno Gagliasso';
DELETE FROM Venda WHERE idVenda = 10;
DELETE FROM Item_Venda WHERE idProduto = 10 AND idVenda = 10;
DELETE FROM Promocao WHERE Nome_Promocao = 'Dia do Estilo';
DELETE FROM Produto_Promocao WHERE idProduto = 10 AND idPromocao = 4;
DELETE FROM Categoria_Produto WHERE Nome_Categoria = 'Acessórios';
DELETE FROM Venda WHERE Data_Venda < '2024-03-01';
DELETE FROM Produto WHERE idProduto NOT IN (SELECT DISTINCT idProduto FROM Estoque);



-- -----------------------------------------------------
--Perguntas/Relatórios Importantes para uma Loja de Roupas
-- -----------------------------------------------------
--RELATÓRIOS DE VENDAS
--Total de vendas por período
SELECT 
    DATE(Data_Venda) AS Data, 
    SUM(Valor_Total) AS Total_Vendas
FROM Venda
WHERE Data_Venda BETWEEN '2024-01-01' AND '2024-03-31'  -- Exemplo de período
GROUP BY DATE(Data_Venda)
ORDER BY Data_Venda;

--Vendas por cliente
SELECT 
    c.Nome_Cliente, 
    SUM(v.Valor_Total) AS Total_Gasto
FROM Cliente c
JOIN Venda v ON c.idCliente = v.idCliente
GROUP BY c.Nome_Cliente
ORDER BY Total_Gasto DESC;

--Produtos mais vendidos
SELECT 
    p.Nome_Produto, 
    SUM(iv.Quantidade) AS Total_Vendido
FROM Produto p
JOIN Item_Venda iv ON p.idProduto = iv.idProduto
JOIN Venda v ON iv.idVenda = v.idVenda
WHERE v.Data_Venda BETWEEN '2024-01-01' AND '2024-03-31' -- Exemplo de período
GROUP BY p.Nome_Produto
ORDER BY Total_Vendido DESC
LIMIT 10;

--Vendas por funcionário
SELECT 
    f.Nome_Funcionario, 
    SUM(v.Valor_Total) AS Total_Vendas
FROM Funcionario f
JOIN Venda v ON f.idFuncionario = v.idFuncionario
GROUP BY f.Nome_Funcionario
ORDER BY Total_Vendas DESC;

--Ticket médio por venda
SELECT AVG(Valor_Total) AS Ticket_Medio FROM Venda;


-- -----------------------------------------------------
--RELATÓRIOS DE PRODUTOS
--Produtos por categoria
SELECT 
    cp.Nome_Categoria, 
    COUNT(p.idProduto) AS Total_Produtos
FROM Categoria_Produto cp
LEFT JOIN Produto p ON cp.idCategoria_Produto = p.idCategoria_Produto
GROUP BY cp.Nome_Categoria
ORDER BY Total_Produtos DESC;

--Produtos com estoque baixo
SELECT 
    p.Nome_Produto, 
    e.Quantidade
FROM Produto p
JOIN Estoque e ON p.idProduto = e.idProduto
WHERE e.Quantidade < 50;

--Produtos sem vendas nos últimos X dias
SELECT p.Nome_Produto
FROM Produto p
WHERE NOT EXISTS (
    SELECT 1
    FROM Item_Venda iv
    JOIN Venda v ON iv.idVenda = v.idVenda
    WHERE iv.idProduto = p.idProduto
    AND v.Data_Venda >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
);

--Produtos com maior e menor preço
SELECT Nome_Produto, Preco FROM Produto ORDER BY Preco DESC LIMIT 1;
SELECT Nome_Produto, Preco FROM Produto ORDER BY Preco ASC LIMIT 1;

--Produtos de um determinado fornecedor
SELECT p.Nome_Produto
FROM Produto p
JOIN Fornecedor f ON p.idFornecedor = f.idFornecedor
WHERE f.Nome_Fornecedor = 'Nome do Fornecedor';


-- -----------------------------------------------------
--RELATÓRIO DE CLIENTES
--Clientes por faixa de gasto
SELECT 
    CASE
        WHEN Total_Gasto < 100 THEN 'Menos de R$100'
        WHEN Total_Gasto BETWEEN 100 AND 500 THEN 'Entre R$100 e R$500'
        WHEN Total_Gasto > 500 THEN 'Mais de R$500'
    END AS Faixa_Gasto,
    COUNT(*) AS Total_Clientes
FROM (
    SELECT 
        c.Nome_Cliente, 
        SUM(v.Valor_Total) AS Total_Gasto
    FROM Cliente c
    JOIN Venda v ON c.idCliente = v.idCliente
    GROUP BY c.Nome_Cliente
) AS GastosPorCliente
GROUP BY Faixa_Gasto
ORDE BY Faixa_Gasto;

--Clientes que mais compram
SELECT 
    c.Nome_Cliente, 
    COUNT(v.idVenda) AS Total_Compras
FROM Cliente c
JOIN Venda v ON c.idCliente = v.idCliente
GROUP BY c.Nome_Cliente
ORDER BY Total_Compras DESC
LIMIT 10;

--Clientes que compraram em um determinado período
SELECT DISTINCT c.Nome_Cliente
FROM Cliente c
JOIN Venda v ON c.idCliente = v.idCliente
WHERE v.Data_Venda BETWEEN '2024-01-01' AND '2024-03-31';

--Informações de contato dos clientes
SELECT Nome_Cliente, Email, Telefone FROM Cliente;

--Número de clientes cadastrados por mês
SELECT 
    DATE_FORMAT(Data_Cadastro, '%Y-%m') AS Mes_Cadastro,
    COUNT(*) AS Total_Clientes
FROM Cliente
GROUP BY Mes_Cadastro
ORDER BY Mes_Cadastro;


-- -----------------------------------------------------
--RELATÓRIO DE ESTOQUE
--Valor total do estoque
SELECT SUM(e.Quantidade * p.Preco) AS Valor_Total_Estoque
FROM Estoque e
JOIN Produto p ON e.idProduto = p.idProduto;

--Produtos com maior e menor quantidade em estoque
SELECT p.Nome_Produto, e.Quantidade FROM Produto p JOIN Estoque e ON p.idProduto = e.idProduto ORDER BY e.Quantidade DESC LIMIT 1;
SELECT p.Nome_Produto, e.Quantidade FROM Produto p JOIN Estoque e ON p.idProduto = e.idProduto ORDER BY e.Quantidade ASC LIMIT 1;

--Estoque por categoria de produto
SELECT
    cp.Nome_Categoria,
    SUM(e.Quantidade * p.Preco) AS Valor_Total_Estoque
FROM Categoria_Produto cp
JOIN Produto p ON cp.idCategoria_Produto = p.idCategoria_Produto
JOIN Estoque e ON p.idProduto = e.idProduto
GROUP BY cp.Nome_Categoria
ORDER BY Valor_Total_Estoque DESC;


-- -----------------------------------------------------
--OUTROS RELATÓRIOS
--Promoções ativas
SELECT Nome_Promocao, Data_Inicio, Data_Fim, Desconto
FROM Promocao
WHERE Data_Inicio <= CURDATE() AND Data_Fim >= CURDATE();

--Total de vendas por forma de pagamento
SELECT
    Forma_Pagamento,
    COUNT(*) AS Total_Vendas,
    SUM(Valor_Total) AS Valor_Total
FROM Venda
GROUP BY Forma_Pagamento
ORDER BY Valor_Total DESC;



-- -----------------------------------------------------
--VIEWS
-- -----------------------------------------------------
-- 1. View para Total de vendas por período
CREATE VIEW vw_total_vendas_por_periodo AS
SELECT
    DATE(Data_Venda) AS Data,
    SUM(Valor_Total) AS Total_Vendas
FROM Venda
GROUP BY DATE(Data_Venda);

-- 2. View para Vendas por cliente
CREATE VIEW vw_vendas_por_cliente AS
SELECT
    c.Nome_Cliente,
    SUM(v.Valor_Total) AS Total_Gasto
FROM Cliente c
JOIN Venda v ON c.idCliente = v.idCliente
GROUP BY c.Nome_Cliente;

-- 3. View para Produtos mais vendidos
CREATE VIEW vw_produtos_mais_vendidos AS
SELECT
    p.Nome_Produto,
    SUM(iv.Quantidade) AS Total_Vendido
FROM Produto p
JOIN Item_Venda iv ON p.idProduto = iv.idProduto
JOIN Venda v ON iv.idVenda = v.idVenda
GROUP BY p.Nome_Produto;

-- 4. View para Vendas por funcionário
CREATE VIEW vw_vendas_por_funcionario AS
SELECT
    f.Nome_Funcionario,
    SUM(v.Valor_Total) AS Total_Vendas
FROM Funcionario f
JOIN Venda v ON f.idFuncionario = v.idFuncionario
GROUP BY f.Nome_Funcionario;

-- 5. View para Ticket médio por venda
CREATE VIEW vw_ticket_medio_venda AS
SELECT AVG(Valor_Total) AS Ticket_Medio FROM Venda;

-- 6. View para Produtos por categoria
CREATE VIEW vw_produtos_por_categoria AS
SELECT
    cp.Nome_Categoria,
    COUNT(p.idProduto) AS Total_Produtos
FROM Categoria_Produto cp
LEFT JOIN Produto p ON cp.idCategoria_Produto = p.idCategoria_Produto
GROUP BY cp.Nome_Categoria;

-- 7. View para Produtos com estoque baixo
CREATE VIEW vw_produtos_estoque_baixo AS
SELECT
    p.Nome_Produto,
    e.Quantidade
FROM Produto p
JOIN Estoque e ON p.idProduto = e.idProduto
WHERE e.Quantidade < 50;

-- 8. View para Produtos sem vendas nos últimos 30 dias
CREATE VIEW vw_produtos_sem_vendas_30dias AS
SELECT p.Nome_Produto
FROM Produto p
WHERE NOT EXISTS (
    SELECT 1
    FROM Item_Venda iv
    JOIN Venda v ON iv.idVenda = v.idVenda
    WHERE iv.idProduto = p.idProduto
    AND v.Data_Venda >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
);

-- 9. View para Produtos com maior preço
CREATE VIEW vw_produto_maior_preco AS
SELECT Nome_Produto, Preco FROM Produto ORDER BY Preco DESC LIMIT 1;

-- 10. View para Produtos com menor preço
CREATE VIEW vw_produto_menor_preco AS
SELECT Nome_Produto, Preco FROM Produto ORDER BY Preco ASC LIMIT 1;

-- 11. View para Estoque por categoria de produto
CREATE VIEW vw_estoque_por_categoria AS
    SELECT 
        cp.Nome_Categoria,
        SUM(e.Quantidade * p.Preco) AS Valor_Total_Estoque
    FROM Categoria_Produto cp
    JOIN Produto p ON cp.idCategoria_Produto = p.idCategoria_Produto
    JOIN Estoque e ON p.idProduto = e.idProduto
    GROUP BY cp.Nome_Categoria
    ORDER BY Valor_Total_Estoque DESC;

--------------------------------------------------------------------
-- PARTE 2 BD-Projeto em Trio
--------------------------------------------------------------------
-- Creat Procedure
-------------------------------------------------------------------

DELIMITER $$

-- 1. Procedure para Registrar Nova Venda Completa (Simplificada para um ÚNICO produto por chamada)
-- Esta procedure registra uma nova venda, adiciona UM item da venda e atualiza o estoque do produto vendido.
CREATE PROCEDURE RegistrarNovaVendaCompleta(
    IN p_idCliente INT,
    IN p_idFuncionario INT,
    IN p_DataVenda DATE,
    IN p_Observacao TEXT,
    IN p_idProduto INT,         -- ID do produto
    IN p_quantidade INT,        -- Quantidade deste produto
    IN p_precoUnitario DECIMAL(10,2) -- Preço unitário deste produto
)
BEGIN
    DECLARE v_idVenda INT;
    DECLARE v_estoqueAtual INT;
    DECLARE v_valorTotalVenda DECIMAL(10,2);

    -- Inicia a transação
    START TRANSACTION;

    -- 1. Insere a nova venda com o valor inicial do item (será atualizado)
    INSERT INTO Venda (Data_Venda, Valor_Total, idCliente, idFuncionario, Observacoes)
    VALUES (p_DataVenda, (p_quantidade * p_precoUnitario), p_idCliente, p_idFuncionario, p_Observacao);

    SET v_idVenda = LAST_INSERT_ID();

    -- 2. Insere o item da venda
    INSERT INTO Item_Venda (Quantidade, Preco_Unitario, idProduto, idVenda)
    VALUES (p_quantidade, p_precoUnitario, p_idProduto, v_idVenda);

    -- 3. Obtém a quantidade atual do produto em estoque
    SELECT Quantidade INTO v_estoqueAtual
    FROM Estoque
    WHERE idProduto = p_idProduto;

    -- 4. Atualiza o estoque do produto (diminuindo a quantidade vendida)
    UPDATE Estoque
    SET Quantidade = v_estoqueAtual - p_quantidade
    WHERE idProduto = p_idProduto;

    -- 5. Atualiza o valor total da venda na tabela Venda
    -- (Para uma venda "completa" com vários itens, você chamaria esta procedure para cada item e precisaria de uma lógica de soma externa,
    -- ou aprimorar para uma procedure que adiciona item a uma venda *já existente* e atualiza o total dessa venda.)
    -- Neste formato simplificado, o Valor_Total da Venda é o valor do ÚNICO item inserido por esta chamada.
    SET v_valorTotalVenda = (p_quantidade * p_precoUnitario); -- Calcula o valor total para este item

    UPDATE Venda
    SET Valor_Total = v_valorTotalVenda
    WHERE idVenda = v_idVenda;

    -- Confirma a transação
    COMMIT;

END $$

-- 2. Procedure para Gerenciar Promoções de Produtos (Adicionar/Remover/Atualizar)
-- Esta procedure permite adicionar um produto a uma promoção, remover ou atualizar o desconto.
CREATE PROCEDURE GerenciarPromocaoProduto(
    IN p_idProduto INT,
    IN p_idPromocao INT,
    IN p_acao VARCHAR(10), -- 'ADICIONAR', 'REMOVER', 'ATUALIZAR'
    IN p_novoDesconto DECIMAL(5,2) -- Apenas para 'ATUALIZAR'
)
BEGIN
    DECLARE v_existe INT;

    -- 1. Verifica se a promoção e o produto existem (opcional, mas boa prática)
    SELECT COUNT(*) INTO v_existe FROM Promocao WHERE idPromocao = p_idPromocao;
    IF v_existe = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Promoção não encontrada.';
    END IF;

    SELECT COUNT(*) INTO v_existe FROM Produto WHERE idProduto = p_idProduto;
    IF v_existe = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Produto não encontrado.';
    END IF;

    IF p_acao = 'ADICIONAR' THEN
        -- 2. Adiciona o produto à promoção se ainda não estiver lá
        INSERT IGNORE INTO Produto_Promocao (idProduto, idPromocao)
        VALUES (p_idProduto, p_idPromocao);
        SELECT 'Produto adicionado à promoção com sucesso (se já não existia).' AS Mensagem;

    ELSEIF p_acao = 'REMOVER' THEN
        -- 3. Remove o produto da promoção
        DELETE FROM Produto_Promocao
        WHERE idProduto = p_idProduto AND idPromocao = p_idPromocao;
        SELECT 'Produto removido da promoção com sucesso (se existia).' AS Mensagem;

    ELSEIF p_acao = 'ATUALIZAR' THEN
        -- 4. Atualiza o desconto da promoção (na tabela Promocao)
        UPDATE Promocao
        SET Desconto = p_novoDesconto
        WHERE idPromocao = p_idPromocao;
        SELECT 'Desconto da promoção atualizado com sucesso.' AS Mensagem;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ação inválida. Use ADICIONAR, REMOVER ou ATUALIZAR.';
    END IF;

    -- 5. Consulta o status atual da promoção (para ADICIONAR/ATUALIZAR)
    SELECT Nome_Promocao, Data_Inicio, Data_Fim, Desconto, Ativo
    FROM Promocao
    WHERE idPromocao = p_idPromocao;

END $$

-- 3. Procedure para Atualizar Status de Produtos e Fornecedores
-- Altera o status de um produto (Ativo/Inativo) e o status do fornecedor principal do produto.
CREATE PROCEDURE AtualizarStatusProdutoFornecedor(
    IN p_idProduto INT,
    IN p_statusProduto ENUM('Ativo', 'Inativo')
)
BEGIN
    DECLARE v_idFornecedor INT;

    -- Inicia a transação
    START TRANSACTION;

    -- 1. Obtém o idFornecedor do produto
    SELECT idFornecedor INTO v_idFornecedor
    FROM Produto
    WHERE idProduto = p_idProduto;

    -- 2. Atualiza o status do produto
    UPDATE Produto
    SET Status = p_statusProduto
    WHERE idProduto = p_idProduto;

    -- 3. Verifica se o fornecedor existe e exibe uma mensagem
    -- Nota: A tabela Fornecedor do seu esquema original não tem uma coluna 'Ativo'.
    -- Para uma funcionalidade completa aqui, essa coluna precisaria ser adicionada.
    IF v_idFornecedor IS NOT NULL THEN
        SELECT CONCAT('Status do produto atualizado para ', p_statusProduto, '. Fornecedor associado (ID: ', v_idFornecedor, ') não tem status controlável diretamente por esta procedure.') AS Mensagem;
    END IF;

    -- 4. Registra a ação de atualização de produto
    -- (Este é um exemplo de comando SQL distinto. Para um log real, você precisaria de uma tabela de log.)
    -- SELECT 'Ação de atualização de status do produto registrada.' AS LogStatus;

    -- 5. Seleciona os dados atualizados do produto para confirmação
    SELECT Nome_Produto, Status, idFornecedor
    FROM Produto
    WHERE idProduto = p_idProduto;

    -- Confirma a transação
    COMMIT;

END $$

-- 4. Procedure para Gerar Relatório de Vendas Detalhado por Período e Funcionário
-- Gera um relatório detalhado de vendas incluindo informações do cliente e do produto.
CREATE PROCEDURE GerarRelatorioVendasDetalhado(
    IN p_DataInicio DATE,
    IN p_DataFim DATE,
    IN p_idFuncionario INT
)
BEGIN
    -- 1. Seleciona informações detalhadas da venda
    SELECT
        v.idVenda,
        v.Data_Venda,
        v.Valor_Total,
        c.Nome_Cliente,
        f.Nome_Funcionario,
        iv.Quantidade AS Quantidade_Vendida,
        iv.Preco_Unitario,
        p.Nome_Produto,
        p.Preco AS Preco_Produto_Cadastro
    FROM Venda v
    JOIN Cliente c ON v.idCliente = c.idCliente
    JOIN Funcionario f ON v.idFuncionario = f.idFuncionario
    JOIN Item_Venda iv ON v.idVenda = iv.idVenda
    JOIN Produto p ON iv.idProduto = p.idProduto
    WHERE v.Data_Venda BETWEEN p_DataInicio AND p_DataFim
    AND (p_idFuncionario IS NULL OR f.idFuncionario = p_idFuncionario)
    ORDER BY v.Data_Venda, v.idVenda;

    -- 2. Calcula o total de vendas para o período/funcionário
    SELECT SUM(Valor_Total) AS Total_Vendas_Periodo
    FROM Venda
    WHERE Data_Venda BETWEEN p_DataInicio AND p_DataFim
    AND (p_idFuncionario IS NULL OR idFuncionario = p_idFuncionario);

    -- 3. Conta o número de vendas realizadas
    SELECT COUNT(DISTINCT idVenda) AS Numero_Total_Vendas
    FROM Venda
    WHERE Data_Venda BETWEEN p_DataInicio AND p_DataFim
    AND (p_idFuncionario IS NULL OR idFuncionario = p_idFuncionario);

    -- 4. Identifica o produto mais vendido nesse período/funcionário
    SELECT p.Nome_Produto, SUM(iv.Quantidade) AS Total_Quantidade_Vendida
    FROM Venda v
    JOIN Item_Venda iv ON v.idVenda = iv.idVenda
    JOIN Produto p ON iv.idProduto = p.idProduto
    WHERE v.Data_Venda BETWEEN p_DataInicio AND p_DataFim
    AND (p_idFuncionario IS NULL OR v.idFuncionario = p_idFuncionario)
    GROUP BY p.Nome_Produto
    ORDER BY Total_Quantidade_Vendida DESC
    LIMIT 1;

END $$

-- 5. Procedure para Gerenciar Cadastro de Clientes (Adicionar/Atualizar/Excluir)
-- Permite adicionar, atualizar ou excluir informações de clientes.
CREATE PROCEDURE GerenciarCadastroCliente(
    IN p_acao VARCHAR(10), -- 'ADICIONAR', 'ATUALIZAR', 'EXCLUIR'
    IN p_idCliente INT, -- Necessário para ATUALIZAR/EXCLUIR
    IN p_nomeCliente VARCHAR(150),
    IN p_cpf VARCHAR(14),
    IN p_email VARCHAR(100),
    IN p_telefone VARCHAR(20),
    IN p_enderecoCompleto VARCHAR(200)
)
BEGIN
    IF p_acao = 'ADICIONAR' THEN
        -- 1. Adiciona um novo cliente
        INSERT INTO Cliente (Nome_Cliente, CPF, Email, Telefone, Endereco_Completo, Data_Cadastro)
        VALUES (p_nomeCliente, p_cpf, p_email, p_telefone, p_enderecoCompleto, CURDATE());
        SELECT 'Cliente adicionado com sucesso.' AS Mensagem, LAST_INSERT_ID() AS idNovoCliente;

    ELSEIF p_acao = 'ATUALIZAR' THEN
        -- 2. Atualiza informações de um cliente existente
        UPDATE Cliente
        SET
            Nome_Cliente = p_nomeCliente,
            CPF = p_cpf,
            Email = p_email,
            Telefone = p_telefone,
            Endereco_Completo = p_enderecoCompleto
        WHERE idCliente = p_idCliente;
        SELECT 'Cliente atualizado com sucesso.' AS Mensagem, p_idCliente AS idClienteAtualizado;

        -- 3. Verifica se a atualização afetou alguma linha
        IF ROW_COUNT() = 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nenhum cliente encontrado com o ID fornecido para atualização.';
        END IF;

    ELSEIF p_acao = 'EXCLUIR' THEN
        -- 4. Exclui um cliente (e vendas associadas devido a CASCADE em algumas FKs se aplicável, ou via DELETE manual)
        -- Nota: Cuidado com a integridade referencial. Vendas e outros registros podem ter FKs para Cliente.
        -- Para o seu schema, a FK de Venda para Cliente é ON DELETE RESTRICT, então seria necessário deletar vendas primeiro.
        DELETE FROM Cliente
        WHERE idCliente = p_idCliente;
        SELECT 'Cliente excluído com sucesso.' AS Mensagem, p_idCliente AS idClienteExcluido;

        -- 5. Verifica se a exclusão afetou alguma linha
        IF ROW_COUNT() = 0 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nenhum cliente encontrado com o ID fornecido para exclusão.';
        END IF;

    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ação inválida. Use ADICIONAR, ATUALIZAR ou EXCLUIR.';
    END IF;

    -- 6. Seleciona o registro do cliente após a operação (se ADICIONAR/ATUALIZAR)
    IF p_acao IN ('ADICIONAR', 'ATUALIZAR') THEN
        SELECT * FROM Cliente WHERE idCliente = IF(p_acao = 'ADICIONAR', LAST_INSERT_ID(), p_idCliente);
    END IF;

END $$

-- 6. Procedure para Auditoria de Estoque
-- Registra ajustes de estoque e, se necessário, alerta sobre baixo estoque.
CREATE PROCEDURE AuditoriaEstoque(
    IN p_idProduto INT,
    IN p_ajusteQuantidade INT, -- Quantidade a adicionar (positiva) ou remover (negativa)
    IN p_motivo VARCHAR(255),
    IN p_limiteAlerta INT -- Limite para acionar o alerta de baixo estoque
)
BEGIN
    DECLARE v_quantidadeAtual INT;
    DECLARE v_novaQuantidade INT;

    -- Inicia a transação
    START TRANSACTION;

    -- 1. Obtém a quantidade atual do produto em estoque
    SELECT Quantidade INTO v_quantidadeAtual
    FROM Estoque
    WHERE idProduto = p_idProduto;

    -- Verifica se o produto existe no estoque
    IF v_quantidadeAtual IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Produto não encontrado no estoque.';
    END IF;

    -- 2. Calcula a nova quantidade
    SET v_novaQuantidade = v_quantidadeAtual + p_ajusteQuantidade;

    -- Garante que a quantidade não seja negativa
    IF v_novaQuantidade < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ajuste resultaria em quantidade negativa em estoque.';
    END IF;

    -- 3. Atualiza a quantidade em estoque
    UPDATE Estoque
    SET Quantidade = v_novaQuantidade, Data_Entrada = CURDATE() -- Atualiza a data de entrada para o ajuste
    WHERE idProduto = p_idProduto;

    -- 4. Registra uma mensagem de sucesso ou alerta.
    IF v_novaQuantidade < p_limiteAlerta THEN
        SELECT CONCAT('ALERTA: O produto ', (SELECT Nome_Produto FROM Produto WHERE idProduto = p_idProduto), ' está com estoque baixo: ', v_novaQuantidade, ' unidades.') AS Alerta_Estoque;
    ELSE
        SELECT 'Ajuste de estoque realizado com sucesso.' AS Mensagem;
    END IF;

    -- 5. Seleciona os dados atualizados do estoque para verificação
    SELECT p.Nome_Produto, e.Quantidade FROM Produto p JOIN Estoque e ON p.idProduto = e.idProduto WHERE p.idProduto = p_idProduto;

    -- Confirma a transação
    COMMIT;

END $$

DELIMITER ;

-- call procedure
-- 1. Teste da Procedure: RegistrarNovaVendaCompleta (Agora para UM produto por chamada)
-- Registra uma venda para o Cliente 1 (João Silva) e Funcionario 2 (Fernanda Lima)
-- com 2 unidades do Produto 1 (Camiseta Básica)
CALL RegistrarNovaVendaCompleta(1, 2, CURDATE(), 'Venda simplificada de uma camiseta.', 1, 2, 34.99);

-- Para verificar o resultado:
-- SELECT * FROM Venda ORDER BY idVenda DESC LIMIT 1;
-- SELECT * FROM Item_Venda ORDER BY idItem_Venda DESC LIMIT 1;
-- SELECT p.Nome_Produto, e.Quantidade FROM Estoque e JOIN Produto p ON e.idProduto = p.idProduto WHERE e.idProduto = 1;


-- 2. Teste da Procedure: GerenciarPromocaoProduto
-- 2.1 Adiciona o Produto 3 (Saia Midi Floral) à Promoção 1 (Liquidação Verão)
CALL GerenciarPromocaoProduto(3, 1, 'ADICIONAR', NULL);

-- 2.2 Atualiza o desconto da Promoção 2 (Semana da Moda) para 12%
CALL GerenciarPromocaoProduto(NULL, 2, 'ATUALIZAR', 0.12); -- NULL para idProduto é aceitável para ATUALIZAR a promoção em si.

-- 2.3 Remove o Produto 1 (Camiseta Básica) da Promoção 1 (Liquidação Verão)
CALL GerenciarPromocaoProduto(1, 1, 'REMOVER', NULL);

-- Para verificar o resultado:
-- SELECT * FROM Produto_Promocao WHERE idProduto = 3 AND idPromocao = 1;
-- SELECT * FROM Promocao WHERE idPromocao = 2;
-- SELECT * FROM Produto_Promocao WHERE idProduto = 1 AND idPromocao = 1;


-- 3. Teste da Procedure: AtualizarStatusProdutoFornecedor
-- Altera o status do Produto 5 (Colar Pedras) para 'Inativo'
CALL AtualizarStatusProdutoFornecedor(5, 'Inativo');

-- Altera o status do Produto 5 (Colar Pedras) de volta para 'Ativo'
CALL AtualizarStatusProdutoFornecedor(5, 'Ativo');

-- Para verificar o resultado:
-- SELECT idProduto, Nome_Produto, Status FROM Produto WHERE idProduto = 5;


-- 4. Teste da Procedure: GerarRelatorioVendasDetalhado
-- Gera um relatório de vendas detalhado para o mês atual, para todos os funcionários
CALL GerarRelatorioVendasDetalhado(CURDATE() - INTERVAL 30 DAY, CURDATE(), NULL);

-- Gera um relatório de vendas detalhado para o mês atual, apenas para o Funcionário 1 (Roberto Carlos)
CALL GerarRelatorioVendasDetalhado(CURDATE() - INTERVAL 30 DAY, CURDATE(), 1);


-- 5. Teste da Procedure: GerenciarCadastroCliente
-- 5.1 Adiciona um novo cliente
CALL GerenciarCadastroCliente(
    'ADICIONAR',
    NULL,
    'Cliente Simples Teste',
    '111.111.111-12',
    'simples.cliente@teste.com',
    '(99) 99999-0000',
    'Rua Simples, 1, Bairro Teste Simples'
);

-- 5.2 Atualiza o cliente recém-adicionado (será o último inserido, então ID 6 ou 7 dependendo dos seus testes anteriores)
-- ATENÇÃO: Verifique o ID do cliente inserido no passo anterior antes de executar.
-- Você pode usar SELECT idCliente FROM Cliente WHERE CPF = '111.111.111-12'; para pegar o ID.
CALL GerenciarCadastroCliente(
    'ATUALIZAR',
    (SELECT idCliente FROM Cliente WHERE CPF = '111.111.111-12'), -- Pega o ID dinamicamente
    'Cliente Simples Atualizado',
    '111.111.111-12',
    'simples.atualizado@teste.com',
    '(99) 88888-0000',
    'Av. Simples, 2, Nova Area Simples'
);

-- 5.3 Exclui o cliente (CUIDADO: Se este cliente tiver vendas associadas, a exclusão pode falhar devido à FK ON DELETE RESTRICT)
CALL GerenciarCadastroCliente('EXCLUIR', (SELECT idCliente FROM Cliente WHERE CPF = '111.111.111-12'), NULL, NULL, NULL, NULL, NULL);


-- 6. Teste da Procedure: AuditoriaEstoque
-- Adiciona 10 unidades ao Produto 1 (Camiseta Básica) e define o limite de alerta em 50
CALL AuditoriaEstoque(1, 10, 'Recebimento de nova mercadoria', 50);

-- Remove 70 unidades do Produto 2 (Calça Jeans Skinny) e define o limite de alerta em 100
CALL AuditoriaEstoque(2, -70, 'Venda em massa', 100);

-- Para verificar o resultado:
SELECT p.Nome_Produto, e.Quantidade FROM Estoque e JOIN Produto p ON e.idProduto = p.idProduto WHERE e.idProduto IN (1, 2);

-----------------------------------------
-- Create functions
-----------------------------------------

DELIMITER $$

-- 1. Função: CalcularValorTotalVendaPorId
-- Retorna o valor total de uma venda específica, somando o valor de todos os seus itens.
CREATE FUNCTION CalcularValorTotalVendaPorId(p_idVenda INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(10,2);
    SELECT SUM(Quantidade * Preco_Unitario)
    INTO v_total
    FROM Item_Venda
    WHERE idVenda = p_idVenda;

    -- Se a venda não tiver itens ou não existir, retorna 0
    IF v_total IS NULL THEN
        SET v_total = 0;
    END IF;

    RETURN v_total;
END $$

-- 2. Função: ObterQuantidadeProdutosPorCategoria
-- Retorna o número total de produtos em uma categoria específica.
CREATE FUNCTION ObterQuantidadeProdutosPorCategoria(p_idCategoria INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_quantidade INT;
    SELECT COUNT(idProduto)
    INTO v_quantidade
    FROM Produto
    WHERE idCategoria = p_idCategoria;

    RETURN v_quantidade;
END $$

-- 3. Função: VerificarEstoqueDisponivel
-- Retorna a quantidade disponível de um produto em estoque.
CREATE FUNCTION VerificarEstoqueDisponivel(p_idProduto INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_quantidade INT;
    SELECT Quantidade
    INTO v_quantidade
    FROM Estoque
    WHERE idProduto = p_idProduto;

    -- Se o produto não estiver no estoque, retorna 0
    IF v_quantidade IS NULL THEN
        SET v_quantidade = 0;
    END IF;

    RETURN v_quantidade;
END $$

-- 4. Função: ObterPrecoMedioCategoria
-- Retorna o preço médio dos produtos em uma categoria específica.
CREATE FUNCTION ObterPrecoMedioCategoria(p_idCategoria INT)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_precoMedio DECIMAL(10,2);
    SELECT AVG(Preco)
    INTO v_precoMedio
    FROM Produto
    WHERE idCategoria = p_idCategoria;

    IF v_precoMedio IS NULL THEN
        SET v_precoMedio = 0.00;
    END IF;

    RETURN v_precoMedio;
END $$

-- 5. Função: ObterNomeFuncionarioPorId
-- Retorna o nome completo de um funcionário dado o seu ID.
CREATE FUNCTION ObterNomeFuncionarioPorId(p_idFuncionario INT)
RETURNS VARCHAR(150)
READS SQL DATA
BEGIN
    DECLARE v_nomeFuncionario VARCHAR(150);
    SELECT Nome_Funcionario INTO v_nomeFuncionario
    FROM Funcionario
    WHERE idFuncionario = p_idFuncionario;

    IF v_nomeFuncionario IS NULL THEN
        RETURN 'Funcionário não encontrado';
    END IF;

    RETURN v_nomeFuncionario;
END $$

-- 6. Função: ContarItensVendidosPorProduto
-- Retorna o total de um produto específico vendido em todas as vendas.
CREATE FUNCTION ContarItensVendidosPorProduto(p_idProduto INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_totalVendido INT;
    SELECT SUM(Quantidade)
    INTO v_totalVendido
    FROM Item_Venda
    WHERE idProduto = p_idProduto;

    IF v_totalVendido IS NULL THEN
        SET v_totalVendido = 0;
    END IF;

    RETURN v_totalVendido;
END $$

DELIMITER ;

-- Teste functions
-- 1. Teste da Função: CalcularValorTotalVendaPorId
-- Substitua '1' por um ID de venda real existente no seu banco.
SELECT CalcularValorTotalVendaPorId(1) AS ValorTotalDaPrimeiraVenda;


-- 2. Teste da Função: ObterQuantidadeProdutosPorCategoria
-- Substitua '1' por um ID de categoria real existente (ex: Roupas Femininas).
SELECT ObterQuantidadeProdutosPorCategoria(1) AS QtdProdutosCategoria1;
-- Teste com uma categoria que pode não ter produtos (ou um ID inexistente)
SELECT ObterQuantidadeProdutosPorCategoria(999) AS QtdProdutosCategoriaInexistente;


-- 3. Teste da Função: VerificarEstoqueDisponivel
-- Verifica a quantidade disponível de produtos no estoque.
SELECT VerificarEstoqueDisponivel(1) AS EstoqueProduto1CamisetaBasica;    -- ID 1: Camiseta Básica
SELECT VerificarEstoqueDisponivel(2) AS EstoqueProduto2CalcaJeansSkinny; -- ID 2: Calça Jeans Skinny
SELECT VerificarEstoqueDisponivel(999) AS EstoqueProdutoInexistente;


-- 4. Teste da Função: ObterPrecoMedioCategoria
-- Retorna o preço médio dos produtos na Categoria 1 (substitua por um ID real se necessário).
SELECT ObterPrecoMedioCategoria(1) AS PrecoMedioCategoria1;
-- Teste com uma categoria sem produtos ou inexistente
SELECT ObterPrecoMedioCategoria(999) AS PrecoMedioCategoriaInexistente;


-- 5. Teste da Função: ObterNomeFuncionarioPorId
-- Retorna o nome de funcionários específicos.
SELECT ObterNomeFuncionarioPorId(1) AS NomeFuncionario1RobertoCarlos;
SELECT ObterNomeFuncionarioPorId(2) AS NomeFuncionario2FernandaLima;
SELECT ObterNomeFuncionarioPorId(999) AS NomeFuncionarioInexistente;


-- 6. Teste da Função: ContarItensVendidosPorProduto
-- Conta o total de um produto específico vendido (use um ID de produto que você sabe que foi vendido).
SELECT ContarItensVendidosPorProduto(1) AS TotalVendidoProduto1CamisetaBasica;
SELECT ContarItensVendidosPorProduto(5) AS TotalVendidoProduto5ColarPedras;
SELECT ContarItensVendidosPorProduto(999) AS TotalVendidoProdutoInexistente;

-- Creat Triggers

DELIMITER $$

-- 1. Trigger: `trg_AtualizarEstoqueAposVenda`
-- Garante que o estoque de um produto seja reduzido automaticamente após a inserção de um item de venda.
-- Evento: AFTER INSERT na tabela Item_Venda
CREATE TRIGGER trg_AtualizarEstoqueAposVenda
AFTER INSERT ON Item_Venda
FOR EACH ROW
BEGIN
    UPDATE Estoque
    SET Quantidade = Quantidade - NEW.Quantidade
    WHERE idProduto = NEW.idProduto;
END $$

-- 2. Trigger: `trg_PrevenirEstoqueNegativo`
-- Impede que a quantidade em estoque de um produto se torne negativa.
-- Evento: BEFORE UPDATE na tabela Estoque (quando a quantidade é alterada)
CREATE TRIGGER trg_PrevenirEstoqueNegativo
BEFORE UPDATE ON Estoque
FOR EACH ROW
BEGIN
    IF NEW.Quantidade < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: A quantidade em estoque não pode ser negativa.';
    END IF;
END $$

-- 3. Trigger: `trg_RegistrarAlteracaoPrecoProduto`
-- Registra um log quando o preço de um produto é alterado.
-- Para esta trigger, assumimos uma tabela de log simples:
-- CREATE TABLE Log_Preco_Produto (
--     idLog INT AUTO_INCREMENT PRIMARY KEY,
--     idProduto INT,
--     Preco_Antigo DECIMAL(10,2),
--     Preco_Novo DECIMAL(10,2),
--     Data_Alteracao DATETIME DEFAULT NOW(),
--     Usuario VARCHAR(100) DEFAULT USER()
-- );
-- Evento: AFTER UPDATE na tabela Produto (quando o preço muda)
CREATE TRIGGER trg_RegistrarAlteracaoPrecoProduto
AFTER UPDATE ON Produto
FOR EACH ROW
BEGIN
    IF OLD.Preco <> NEW.Preco THEN
        INSERT INTO Log_Preco_Produto (idProduto, Preco_Antigo, Preco_Novo, Data_Alteracao, Usuario)
        VALUES (NEW.idProduto, OLD.Preco, NEW.Preco, NOW(), USER());
    END IF;
END $$

-- 4. Trigger: `trg_AtualizarValorTotalVenda`
-- Atualiza o Valor_Total na tabela Venda sempre que um item_venda é alterado (atualizado ou deletado).
-- Esta é crucial para manter a integridade do Valor_Total da Venda.
-- Evento: AFTER UPDATE e AFTER DELETE na tabela Item_Venda
CREATE TRIGGER trg_AtualizarValorTotalVenda_AU
AFTER UPDATE ON Item_Venda
FOR EACH ROW
BEGIN
    -- Atualiza o valor total da venda para o ID da venda antiga e da nova, caso o idVenda tenha mudado (raro, mas possível)
    UPDATE Venda
    SET Valor_Total = (SELECT COALESCE(SUM(Quantidade * Preco_Unitario), 0) FROM Item_Venda WHERE idVenda = NEW.idVenda)
    WHERE idVenda = NEW.idVenda;

    IF OLD.idVenda <> NEW.idVenda THEN -- Se o item mudou de venda (caso improvável)
        UPDATE Venda
        SET Valor_Total = (SELECT COALESCE(SUM(Quantidade * Preco_Unitario), 0) FROM Item_Venda WHERE idVenda = OLD.idVenda)
        WHERE idVenda = OLD.idVenda;
    END IF;
END $$

CREATE TRIGGER trg_AtualizarValorTotalVenda_AD
AFTER DELETE ON Item_Venda
FOR EACH ROW
BEGIN
    -- Atualiza o valor total da venda para o ID da venda do item deletado
    UPDATE Venda
    SET Valor_Total = (SELECT COALESCE(SUM(Quantidade * Preco_Unitario), 0) FROM Item_Venda WHERE idVenda = OLD.idVenda)
    WHERE idVenda = OLD.idVenda;
END $$

-- 5. Trigger: `trg_DefinirDataCadastroCliente`
-- Define automaticamente a Data_Cadastro para a data atual no momento da inserção de um novo cliente, se não for fornecida.
-- Evento: BEFORE INSERT na tabela Cliente
CREATE TRIGGER trg_DefinirDataCadastroCliente
BEFORE INSERT ON Cliente
FOR EACH ROW
BEGIN
    IF NEW.Data_Cadastro IS NULL THEN
        SET NEW.Data_Cadastro = CURDATE();
    END IF;
END $$

-- 6. Trigger: `trg_ValidarDataPromocao`
-- Impede que uma promoção seja criada ou atualizada com Data_Fim anterior à Data_Inicio.
-- Evento: BEFORE INSERT e BEFORE UPDATE na tabela Promocao
CREATE TRIGGER trg_ValidarDataPromocao_BI
BEFORE INSERT ON Promocao
FOR EACH ROW
BEGIN
    IF NEW.Data_Fim < NEW.Data_Inicio THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: Data_Fim da promoção não pode ser anterior à Data_Inicio.';
    END IF;
END $$

CREATE TRIGGER trg_ValidarDataPromocao_BU
BEFORE UPDATE ON Promocao
FOR EACH ROW
BEGIN
    IF NEW.Data_Fim < NEW.Data_Inicio THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: Data_Fim da promoção não pode ser anterior à Data_Inicio.';
    END IF;
END $$

DELIMITER ;

-- teste triggers
--tabela necessaria para salvar os registros da trigger
CREATE TABLE Log_Preco_Produto (
    idLog INT AUTO_INCREMENT PRIMARY KEY,
    idProduto INT,
    Preco_Antigo DECIMAL(10,2),
    Preco_Novo DECIMAL(10,2),
    Data_Alteracao DATETIME DEFAULT NOW(),
    Usuario VARCHAR(100) DEFAULT USER()
);

USE mydb;

-- --- TESTES DOS TRIGGERS ---

-- Preparação: Verifica estado inicial
SELECT '--- Estado Inicial ---' AS 'Status';
SELECT idProduto, Quantidade FROM Estoque WHERE idProduto = 1; -- Camiseta Básica
SELECT idVenda, Valor_Total FROM Venda WHERE idVenda = 1; -- Venda existente (se tiver)
SELECT idProduto, Preco FROM Produto WHERE idProduto = 1; -- Preço do produto
SELECT COUNT(*) FROM Log_Preco_Produto;
SELECT idCliente, Nome_Cliente, Data_Cadastro FROM Cliente ORDER BY idCliente DESC LIMIT 1;
SELECT idPromocao, Nome_Promocao, Data_Inicio, Data_Fim FROM Promocao WHERE idPromocao = 6; -- Use um ID de promoção que possa ser modificado/inserido para teste


-- 1. Teste do Trigger: `trg_AtualizarEstoqueAposVenda`
-- Este trigger é ativado ao inserir um Item_Venda.
SELECT '--- Teste: trg_AtualizarEstoqueAposVenda ---' AS 'Status';
-- Adiciona um novo item à Venda 1 (se a Venda 1 existir, se não, use um idVenda válido ou crie uma venda antes)
-- Assume que Venda 1 e Produto 1 existem.
-- Estoque do produto 1 deve diminuir.
INSERT INTO Item_Venda (Quantidade, Preco_Unitario, idProduto, idVenda)
VALUES (3, 35.00, 1, 1); -- Adicionando 3 Camisetas Básicas à Venda 1

SELECT idProduto, Quantidade FROM Estoque WHERE idProduto = 1; -- Verifica o estoque


-- 2. Teste do Trigger: `trg_PrevenirEstoqueNegativo`
-- Este trigger impede que o estoque se torne negativo.
SELECT '--- Teste: trg_PrevenirEstoqueNegativo ---' AS 'Status';
-- Tentativa de atualizar o estoque do Produto 1 para um valor negativo.
-- Isso deve gerar um erro.
-- USE APENAS PARA TESTE, POIS IRÁ CAUSAR UM ERRO E PARAR A EXECUÇÃO SE O CLIENTE SQL FOR CONFIGURADO PARA ISSO.
-- Para ver o erro, execute esta linha separadamente.
-- UPDATE Estoque SET Quantidade = -5 WHERE idProduto = 1;

-- Atualização válida (não negativa)
UPDATE Estoque SET Quantidade = 50 WHERE idProduto = 1;
SELECT idProduto, Quantidade FROM Estoque WHERE idProduto = 1;


-- 3. Teste do Trigger: `trg_RegistrarAlteracaoPrecoProduto`
-- Este trigger registra alterações de preço de produto em Log_Preco_Produto.
SELECT '--- Teste: trg_RegistrarAlteracaoPrecoProduto ---' AS 'Status';
-- Altera o preço do Produto 1.
UPDATE Produto SET Preco = 36.50 WHERE idProduto = 1;
SELECT idProduto, Preco FROM Produto WHERE idProduto = 1;
SELECT * FROM Log_Preco_Produto ORDER BY Data_Alteracao DESC LIMIT 1; -- Verifica o log


-- 4. Teste dos Triggers: `trg_AtualizarValorTotalVenda_AU` e `trg_AtualizarValorTotalVenda_AD`
-- Estes triggers atualizam o Valor_Total da Venda.
SELECT '--- Teste: trg_AtualizarValorTotalVenda ---' AS 'Status';
SELECT idVenda, Valor_Total FROM Venda WHERE idVenda = 1; -- Valor antes

-- 4.1 Teste AU (Atualização de Item_Venda):
-- Altera a quantidade de um item na Venda 1 (o item que acabamos de inserir, ou um existente).
-- O Valor_Total da Venda 1 deve ser atualizado automaticamente.
UPDATE Item_Venda
SET Quantidade = 5, Preco_Unitario = 30.00 -- Altera a quantidade e o preço unitário do último item inserido na venda 1
WHERE idVenda = 1 AND idProduto = 1 ORDER BY idItem_Venda DESC LIMIT 1;

SELECT idVenda, Valor_Total FROM Venda WHERE idVenda = 1; -- Valor após atualização

-- 4.2 Teste AD (Deleção de Item_Venda):
-- Deleta um item da Venda 1.
-- O Valor_Total da Venda 1 deve ser atualizado automaticamente.
DELETE FROM Item_Venda WHERE idVenda = 1 AND idProduto = 1 AND Quantidade = 5; -- Deleta o item que acabamos de alterar

SELECT idVenda, Valor_Total FROM Venda WHERE idVenda = 1; -- Valor após deleção


-- 5. Teste do Trigger: `trg_DefinirDataCadastroCliente`
-- Este trigger define a Data_Cadastro para novos clientes.
SELECT '--- Teste: trg_DefinirDataCadastroCliente ---' AS 'Status';
-- Insere um novo cliente sem especificar Data_Cadastro.
INSERT INTO Cliente (Nome_Cliente, CPF, Email, Telefone, Endereco_Completo)
VALUES ('Novo Cliente Teste Trigger', '111.111.111-13', 'trigger@cliente.com', '(11) 99999-0000', 'Rua da Trigger, 10');

SELECT idCliente, Nome_Cliente, Data_Cadastro FROM Cliente ORDER BY idCliente DESC LIMIT 1; -- Verifica a data de cadastro


-- 6. Teste dos Triggers: `trg_ValidarDataPromocao_BI` e `trg_ValidarDataPromocao_BU`
-- Estes triggers validam as datas de início e fim da promoção.
SELECT '--- Teste: trg_ValidarDataPromocao ---' AS 'Status';

-- 6.1 Teste BI (INSERT inválido):
-- Tentativa de inserir uma promoção com Data_Fim antes de Data_Inicio.
-- Isso deve gerar um erro.
-- USE APENAS PARA TESTE, POIS IRÁ CAUSAR UM ERRO.
-- INSERT INTO Promocao (Nome_Promocao, Data_Inicio, Data_Fim, Desconto, Ativo)
-- VALUES ('Promo Invalida', '2025-07-01', '2025-06-01', 0.10, TRUE);

-- Inserção válida:
INSERT INTO Promocao (Nome_Promocao, Data_Inicio, Data_Fim, Desconto, Ativo)
VALUES ('Promo Valida Teste', '2025-07-01', '2025-07-31', 0.05, TRUE);
SELECT idPromocao, Nome_Promocao, Data_Inicio, Data_Fim FROM Promocao ORDER BY idPromocao DESC LIMIT 1;

-- 6.2 Teste BU (UPDATE inválido):
-- Tenta atualizar uma promoção existente para ter Data_Fim antes de Data_Inicio.
-- Isso deve gerar um erro.
-- USE APENAS PARA TESTE, POIS IRÁ CAUSAR UM ERRO.
-- UPDATE Promocao SET Data_Fim = '2025-01-01' WHERE idPromocao = (SELECT idPromocao FROM Promocao ORDER BY idPromocao DESC LIMIT 1);

-- Atualização válida:
UPDATE Promocao SET Desconto = 0.07 WHERE idPromocao = (SELECT idPromocao FROM Promocao ORDER BY idPromocao DESC LIMIT 1);
SELECT idPromocao, Nome_Promocao, Desconto FROM Promocao ORDER BY idPromocao DESC LIMIT 1;
