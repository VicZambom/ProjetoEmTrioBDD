
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
