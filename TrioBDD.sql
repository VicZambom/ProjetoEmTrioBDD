
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