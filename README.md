# ProjetoEmTrioBDD

> Projeto acadêmico desenvolvido em trio para a disciplina de Banco de Dados no curso de Análise e Desenvolvimento de Sistemas (ADS) – SENAC.

## 👥 Integrantes do Projeto

- Maíra Lourenço (GitHub: [@MairaLourencoDEV](https://github.com/MairaLourencoDEV))
- Manoel Olímpio (GitHub: [@Molimpion](https://github.com/Molimpion))
- Victoria Zambom (GitHub: [@VicZambom](https://github.com/VicZambom))

## 📚 Descrição

Este projeto tem como objetivo a criação do esquema de um banco de dados relacional utilizando MySQL. A proposta envolve modelar tabelas com chaves primárias, estrangeiras, constraints e relacionamentos coerentes para representar um sistema comercial com funcionalidades de vendas, promoções, produtos e usuários.

## 🗃️ Estrutura do Banco de Dados

O banco de dados contém as seguintes tabelas principais:

- `Cliente`  
- `Funcionario`  
- `Venda`  
- `Item_Venda`  
- `Produto`  
- `Promocao`  
- `Produto_Promocao`

Cada tabela foi criada com o uso de `FOREIGN KEY`, `PRIMARY KEY`, `AUTO_INCREMENT` e integridade referencial via `ON DELETE` e `ON UPDATE`.

## 🛠️ Tecnologias Utilizadas

- MySQL 8.x
- Workbench
- Git & GitHub

## 📄 Scripts SQL

Os scripts de criação das tabelas estão disponíveis na pasta principal deste repositório. Para executá-los:

1. Crie o banco de dados:
   ```sql
   CREATE DATABASE IF NOT EXISTS mydb;
   USE mydb;
