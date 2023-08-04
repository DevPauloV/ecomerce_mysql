-- MySQL dump 10.13  Distrib 8.0.29, for Win64 (x86_64)
--
-- Host: localhost    Database: e_commerce
-- ------------------------------------------------------
-- Server version	8.0.29

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `categorias`
--

DROP TABLE IF EXISTS `categorias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categorias` (
  `idCategoria` int NOT NULL AUTO_INCREMENT,
  `CategoriaNome` varchar(45) CHARACTER SET utf8mb3 COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`idCategoria`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb3 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categorias`
--

LOCK TABLES `categorias` WRITE;
/*!40000 ALTER TABLE `categorias` DISABLE KEYS */;
INSERT INTO `categorias` VALUES (1,'Eletronicos'),(2,'Perfumes'),(3,'Telefonia'),(4,'Roupas'),(5,'Calçados Masculinos'),(6,'Calçados Femininos');
/*!40000 ALTER TABLE `categorias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `idCliente` int NOT NULL AUTO_INCREMENT,
  `NomeCliente` varchar(40) COLLATE utf8_bin DEFAULT NULL,
  `FoneCliente` varchar(15) COLLATE utf8_bin DEFAULT NULL,
  `EmailCliente` varchar(40) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`idCliente`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,'Cliente A',NULL,NULL),(2,'Cliente B',NULL,NULL);
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `compras`
--

DROP TABLE IF EXISTS `compras`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `compras` (
  `idCompras` int NOT NULL AUTO_INCREMENT,
  `DataCompra` date DEFAULT NULL,
  `HoraCOmpra` time DEFAULT NULL,
  `idProduto` int NOT NULL,
  `QuantidadeCompra` int NOT NULL,
  `precoCompra` decimal(12,2) NOT NULL DEFAULT '0.00',
  `parcelasCompra` int DEFAULT '1',
  PRIMARY KEY (`idCompras`),
  KEY `FK2_idx` (`idProduto`),
  CONSTRAINT `FK2` FOREIGN KEY (`idProduto`) REFERENCES `produtos` (`idProdutos`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `compras`
--

LOCK TABLES `compras` WRITE;
/*!40000 ALTER TABLE `compras` DISABLE KEYS */;
INSERT INTO `compras` VALUES (6,'2022-10-11','20:35:00',1,10,700.00,10),(7,'2022-10-18','19:21:00',1,20,700.00,5),(9,'2022-10-18','20:45:00',2,10,280.00,3);
/*!40000 ALTER TABLE `compras` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tgr_compras_bi` BEFORE INSERT ON `compras` FOR EACH ROW BEGIN
   SET new.precocompra = (select produtos.precocustoproduto
              from produtos where produtos.idprodutos = new.idproduto);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tgr_compras_ai` AFTER INSERT ON `compras` FOR EACH ROW BEGIN
    declare v_msg  varchar(100);
    declare v_erro char(03);
    
    -- Atualizar o Saldo em Estoque
    call sp_atualizaestoque (new.idproduto, new.quantidadecompra, 'E', v_msg, v_msgII, v_erro);
    IF (v_erro <> 'Sim') THEN
			  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro na atualização do Estoque'; 
 	END IF;
    
    -- Chamar Procedure para gerar os Boletos
    IF (v_erro = 'Não') THEN
		call sp_geraboleto2( new.idcompras      -- idtransacao
						   ,'P'    -- tipo de financeiro (Pagar/Receber)
						   , v_msg); -- Mensagem de retorno
		IF (v_msg <> 'Boletos gerados com sucesso!!') THEN
				  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro na Geração dos Boletos'; 
		END IF;
    END IF;   
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tgr_compras_bu` BEFORE UPDATE ON `compras` FOR EACH ROW BEGIN
   SET new.precocompra = (select produtos.precocustoproduto
              from produtos where produtos.idprodutos = new.idproduto);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tgr_compras_ad` AFTER UPDATE ON `compras` FOR EACH ROW BEGIN
    declare v_erro char(03);
    
    -- Atualizar o Saldo em Estoque
    -- OLD
    call sp_atualizaestoque (old.idproduto, old.quantidadecompra, 'S', v_msg, v_msgII, v_erro);
    IF (v_erro = 'Sim') THEN
			  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro na atualizacao do Estoque'; 
 	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tgr_compras_au` AFTER UPDATE ON `compras` FOR EACH ROW BEGIN
    declare v_erro char(03);
    
    -- Atualizar o Saldo em Estoque
    -- NEW
    call sp_atualizaestoque (new.idproduto, new.quantidadecompra, 'E', v_msg, v_msgII, v_erro);
    IF (v_erro = 'Sim') THEN
			  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro na atualização do Estoque - NEW'; 
 	END IF;
    
    -- OLD
    call sp_atualizaestoque (old.idproduto, old.quantidadecompra, 'S', v_msg, v_msgII, v_erro);
    IF (v_erro = 'Sim') THEN
			  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro na atualização do Estoque - OLD'; 
 	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `devedores`
--

DROP TABLE IF EXISTS `devedores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `devedores` (
  `idCliente` int NOT NULL,
  `NomeCliente` varchar(40) COLLATE utf8_bin DEFAULT NULL,
  `ValorDivida` decimal(12,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `devedores`
--

LOCK TABLES `devedores` WRITE;
/*!40000 ALTER TABLE `devedores` DISABLE KEYS */;
INSERT INTO `devedores` VALUES (1,'Cliente A',950.00);
/*!40000 ALTER TABLE `devedores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `etapas`
--

DROP TABLE IF EXISTS `etapas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `etapas` (
  `idetapas` int NOT NULL,
  `etapanome` varchar(45) COLLATE utf8_bin DEFAULT NULL,
  `etapascol` varchar(45) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`idetapas`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `etapas`
--

LOCK TABLES `etapas` WRITE;
/*!40000 ALTER TABLE `etapas` DISABLE KEYS */;
INSERT INTO `etapas` VALUES (1,'Carrinho',NULL),(2,'Aguardando Pagamento',NULL),(3,'Pago',NULL),(4,'Em Separacao',NULL),(5,'Separado',NULL),(6,'Faturado',NULL),(7,'Aguardando Coleta',NULL),(8,'Em Transporte',NULL),(9,'Entregue',NULL),(99,'Cancelado',NULL);
/*!40000 ALTER TABLE `etapas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `financeiro`
--

DROP TABLE IF EXISTS `financeiro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `financeiro` (
  `idfinanceiro` int NOT NULL AUTO_INCREMENT,
  `dataemissao` date NOT NULL,
  `datavencimento` date DEFAULT NULL,
  `datapagamento` date DEFAULT NULL,
  `valordevido` decimal(15,5) DEFAULT NULL,
  `valorpago` decimal(15,5) DEFAULT NULL,
  `valorjuros` decimal(15,5) DEFAULT NULL,
  `valordesconto` decimal(15,5) DEFAULT NULL,
  `idtransacao` int DEFAULT NULL,
  `numeroparcela` int DEFAULT NULL,
  `tipo_financeiro` char(1) CHARACTER SET utf8mb3 COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`idfinanceiro`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb3 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `financeiro`
--

LOCK TABLES `financeiro` WRITE;
/*!40000 ALTER TABLE `financeiro` DISABLE KEYS */;
INSERT INTO `financeiro` VALUES (41,'2022-10-18','2022-10-17',NULL,3500.00000,NULL,NULL,NULL,7,1,'P'),(42,'2022-10-18','2022-12-17',NULL,2800.00000,NULL,NULL,NULL,7,2,'P'),(43,'2022-10-18','2023-01-16',NULL,2800.00000,NULL,NULL,NULL,7,3,'P'),(44,'2022-10-18','2023-02-15',NULL,2800.00000,NULL,NULL,NULL,7,4,'P'),(45,'2022-10-18','2023-03-17',NULL,2800.00000,NULL,NULL,NULL,7,5,'P'),(49,'2022-10-18','2022-11-17',NULL,933.33000,NULL,NULL,NULL,9,1,'P'),(50,'2022-10-18','2022-12-17',NULL,933.33000,NULL,NULL,NULL,9,2,'P'),(51,'2022-10-18','2023-01-16',NULL,933.33000,NULL,NULL,NULL,9,3,'P'),(52,'2022-11-08','2022-12-08',NULL,950.00000,NULL,NULL,NULL,10,1,'R'),(53,'2022-11-08','2022-01-07',NULL,950.00000,NULL,NULL,NULL,10,2,'R'),(54,'2022-11-08','2022-12-08',NULL,326.67000,NULL,NULL,NULL,12,1,'R'),(55,'2022-11-08','2023-01-07',NULL,326.67000,NULL,NULL,NULL,12,2,'R'),(56,'2022-11-08','2023-02-06',NULL,326.67000,NULL,NULL,NULL,12,3,'R'),(57,'2022-11-08','2022-12-15',NULL,950.00000,NULL,NULL,NULL,13,1,'R');
/*!40000 ALTER TABLE `financeiro` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produtos`
--

DROP TABLE IF EXISTS `produtos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produtos` (
  `idProdutos` int NOT NULL AUTO_INCREMENT,
  `NomeProduto` varchar(45) CHARACTER SET utf8mb3 COLLATE utf8_bin NOT NULL,
  `SaldoProduto` int DEFAULT '0',
  `Idcategoria` int NOT NULL,
  `precocustoproduto` decimal(12,2) NOT NULL DEFAULT '0.00',
  `precovendaproduto` decimal(12,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`idProdutos`),
  KEY `fk1_idx` (`Idcategoria`),
  CONSTRAINT `fk1` FOREIGN KEY (`Idcategoria`) REFERENCES `categorias` (`idCategoria`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produtos`
--

LOCK TABLES `produtos` WRITE;
/*!40000 ALTER TABLE `produtos` DISABLE KEYS */;
INSERT INTO `produtos` VALUES (1,'TV LG 70\"',22,1,700.00,950.00),(2,'Monitor 29\" LG',2,1,280.00,490.00),(3,'Tenis Ardidas Max',3,5,650.00,930.00),(4,'Medidor de Pressão',2,1,15.00,54.00),(5,'Bicicleta Ergometrica',1,1,630.00,1280.00);
/*!40000 ALTER TABLE `produtos` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tgr_produtos_bu` BEFORE UPDATE ON `produtos` FOR EACH ROW BEGIN
   /* Entradas */
   IF (NEW.SaldoProduto < 0 ) THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O Saldo do Produto nao pode ficar negatico'; 
   END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `rastreio`
--

DROP TABLE IF EXISTS `rastreio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rastreio` (
  `idrastreio` int NOT NULL AUTO_INCREMENT,
  `idvenda` int NOT NULL,
  `idetapa` int NOT NULL,
  `dataregistro` date DEFAULT NULL,
  `horaregistro` time DEFAULT NULL,
  `obsregistro` varchar(45) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`idrastreio`),
  KEY `fk_etapa_idx` (`idetapa`),
  KEY `fk_vendaid_idx` (`idvenda`),
  CONSTRAINT `fk_etapa` FOREIGN KEY (`idetapa`) REFERENCES `etapas` (`idetapas`),
  CONSTRAINT `fk_vendaid` FOREIGN KEY (`idvenda`) REFERENCES `vendas` (`idvendas`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rastreio`
--

LOCK TABLES `rastreio` WRITE;
/*!40000 ALTER TABLE `rastreio` DISABLE KEYS */;
INSERT INTO `rastreio` VALUES (1,10,2,'2022-11-22','20:27:00','Aguardando Pagto Cartao'),(2,10,3,'2022-11-22','20:29:00','Pagto Autorizado');
/*!40000 ALTER TABLE `rastreio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transportadores`
--

DROP TABLE IF EXISTS `transportadores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transportadores` (
  `idtransportadores` int NOT NULL AUTO_INCREMENT,
  `trans_nome` varchar(45) COLLATE utf8_bin DEFAULT NULL,
  `trans_fone` varchar(15) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`idtransportadores`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transportadores`
--

LOCK TABLES `transportadores` WRITE;
/*!40000 ALTER TABLE `transportadores` DISABLE KEYS */;
INSERT INTO `transportadores` VALUES (1,'Correios',NULL),(2,'FEDEX',NULL),(3,'Total Transportes',NULL),(4,'X Logistics',NULL);
/*!40000 ALTER TABLE `transportadores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_avencer`
--

DROP TABLE IF EXISTS `v_avencer`;
/*!50001 DROP VIEW IF EXISTS `v_avencer`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_avencer` AS SELECT 
 1 AS `datavencimento`,
 1 AS `datahoje`,
 1 AS `datavencimentoOriginal`,
 1 AS `datahojeoriginal`,
 1 AS `dataemissaobanco`,
 1 AS `datavencimentobanco`,
 1 AS `valordevidobanco`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_clientes`
--

DROP TABLE IF EXISTS `v_clientes`;
/*!50001 DROP VIEW IF EXISTS `v_clientes`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_clientes` AS SELECT 
 1 AS `idCLiente`,
 1 AS `NomeCliente`,
 1 AS `Total_Compras`,
 1 AS `Duplicatas_Vencida`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_titulos`
--

DROP TABLE IF EXISTS `v_titulos`;
/*!50001 DROP VIEW IF EXISTS `v_titulos`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_titulos` AS SELECT 
 1 AS `Vencimento`,
 1 AS `DataAtual`,
 1 AS `Valor`,
 1 AS `Situacao`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `vendas`
--

DROP TABLE IF EXISTS `vendas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vendas` (
  `idvendas` int NOT NULL AUTO_INCREMENT,
  `datavenda` date DEFAULT NULL,
  `horavenda` time DEFAULT NULL,
  `idproduto` int NOT NULL,
  `quantidadevenda` int NOT NULL,
  `valorvenda` decimal(12,2) NOT NULL,
  `parcelasVenda` int DEFAULT '1',
  `idCliente` int DEFAULT NULL,
  PRIMARY KEY (`idvendas`),
  KEY `fk3_idx` (`idproduto`),
  KEY `idCliente` (`idCliente`),
  CONSTRAINT `fk3` FOREIGN KEY (`idproduto`) REFERENCES `produtos` (`idProdutos`),
  CONSTRAINT `vendas_ibfk_1` FOREIGN KEY (`idCliente`) REFERENCES `clientes` (`idCliente`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb3 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vendas`
--

LOCK TABLES `vendas` WRITE;
/*!40000 ALTER TABLE `vendas` DISABLE KEYS */;
INSERT INTO `vendas` VALUES (10,'2022-11-08','19:46:00',1,2,950.00,2,1),(12,'2022-11-08','19:57:00',2,2,490.00,3,2),(13,'2022-11-15','13:25:00',1,1,950.00,1,1);
/*!40000 ALTER TABLE `vendas` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tgr_vendas_bi` BEFORE INSERT ON `vendas` FOR EACH ROW BEGIN
   SET new.valorvenda = (select produtos.precovendaproduto
              from produtos where produtos.idprodutos = new.idproduto);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tgr_vendas_ai` AFTER INSERT ON `vendas` FOR EACH ROW BEGIN
    DECLARE v_msg varchar(30);
    
    UPDATE produtos 
        SET produtos.saldoproduto = produtos.saldoproduto 
                                  - new.quantidadevenda
        WHERE produtos.idprodutos = new.idproduto; 
   
   CALL sp_geraboleto2(new.idvendas, 'R',v_msg);
    IF v_msg <> 'Boletos gerados com sucesso!!' THEN
       SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro na geração da Duplicata'; 
    END IF;
   
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tgr_vendas_bu` BEFORE UPDATE ON `vendas` FOR EACH ROW BEGIN
   SET new.valorvenda = (select produtos.precovendaproduto
              from produtos where produtos.idprodutos = new.idproduto);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tgr_vendas_au` AFTER UPDATE ON `vendas` FOR EACH ROW BEGIN
    UPDATE produtos 
        SET produtos.saldoproduto = produtos.saldoproduto 
                                  - new.quantidadevenda
                                  + old.quantidadevenda
        WHERE produtos.idprodutos = new.idproduto; 
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `tgr_vendas_ad` AFTER DELETE ON `vendas` FOR EACH ROW BEGIN
    UPDATE produtos 
        SET produtos.saldoproduto = produtos.saldoproduto 
                                  + old.quantidadevenda
        WHERE produtos.idprodutos = old.idproduto; 
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping events for database 'e_commerce'
--

--
-- Dumping routines for database 'e_commerce'
--
/*!50003 DROP PROCEDURE IF EXISTS `sp_atualizaestoque` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_atualizaestoque`(IN p_idproduto INT, 
                                     IN p_quantidade INT,
                                     IN p_operacao char(01),
                                     OUT p_status varchar(30),
                                     OUT p_statusII varchar(255),
                                     OUT p_erro char(03))
BEGIN
   SET p_erro = 'Não';
   -- Verificar se o tipo de operacao é valido
   IF (upper(p_operacao) NOT IN ('E','S','+','-')) THEN
      SET p_status   = 'Operacao Invalida',
          p_statusII = 'Operacao Invalida',
          p_erro     = 'Sim';
   END IF;
   
   -- Verificar se a quantidade nao é negativa
   IF (p_quantidade < 0) THEN
      SET p_status   = 'Quantidade Negativa (Invalida)',
          p_statusII = concat(p_statusII, '/','Quantidade Negativa (Invalida)'),
          p_erro     = 'Sim';
   END IF;
   

   IF p_erro = 'Não' THEN
      IF (upper(p_operacao) IN ('E','+')) THEN
         UPDATE produtos SET produtos.SaldoProduto = 
                             produtos.SaldoProduto +
                             p_quantidade
                WHERE produtos.idProdutos = p_idproduto; 
         SET p_status = 'Sucesso - Entrada',
             p_statusII = 'Sucesso - Entrada';       
      ELSE
         UPDATE produtos SET produtos.SaldoProduto = 
                             produtos.SaldoProduto -
                             p_quantidade
                WHERE produtos.idProdutos = p_idproduto;             
         SET p_status = 'Sucesso - Saida',       
             p_statusII = 'Sucesso - Entrada';       
      END IF;
   END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_devedores` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_devedores`()
BEGIN
     DELETE FROM devedores;
     INSERT INTO DEVEDORES  (SELECT v_clientes.idCliente
                                  , v_clientes.NomeCliente
                                  , v_clientes.Duplicatas_Vencida 
                              FROM v_clientes WHERE v_clientes.Duplicatas_Vencida > 0);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_geraboleto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_geraboleto`(IN p_idtransacao INT, IN p_valortotal decimal(15,2), IN p_parcelas INT, IN p_tipocobranca CHAR(01), OUT p_msg VARCHAR(100))
BEGIN
	   DECLARE v_contador INT;
	   DECLARE v_vencimento DATE;
       DECLARE v_valorparcela DECIMAL(15,2);
	   -- Calcular o Valor da Parcela
	   SET v_valorparcela  = (p_valortotal / p_parcelas);
	   
	   -- Looping para criar os registros na tabela financeiro
	   SET v_contador = 1;
	   SET v_vencimento = current_date();
	   WHILE (v_contador <= p_parcelas) DO
		 -- incluir dados na tabela financeiro
		 SET v_vencimento = adddate(v_vencimento,30);
		 INSERT INTO financeiro (dataemissao
								,datavencimento
								,valordevido
								,idtransacao
								,numeroparcela
								,tipo_financeiro)
			 VALUES (current_date(),
					 v_vencimento,
					 v_valorparcela,
					 p_idtransacao,
					 v_contador,
					 p_tipocobranca
					 );      
		 SET v_contador = v_contador + 1;
	   END WHILE;
       SET p_msg = 'Boletos gerados com sucesso!!';
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_geraboleto2` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_geraboleto2`(IN p_idtransacao INT, 
                                IN p_tipocobranca CHAR(01), 
								OUT p_msg VARCHAR(100))
BEGIN
	   DECLARE v_contador INT;
       DECLARE v_dataemissao DATE;
	   DECLARE v_vencimento DATE;
       DECLARE v_valorparcela DECIMAL(15,2);
	   DECLARE v_quantidadeparcelas INT;
       DECLARE v_erro CHAR(01);
	   
       SET v_erro = 'N';
	   -- Validar se o tipo de cobrança é valido
	   IF (UPPER(p_tipocobranca) NOT IN ('P','R')) THEN
	      SET p_msg = 'Tipo de Parcela Invalido';
		  SET v_erro = 'S';
	   END IF;
	   
       IF v_erro <> 'S' THEN
		   -- Buscar os dados da compra para tipo 'P'
		   -- Calcular o Valor da Parcela de Compras
		   IF (p_tipocobranca = 'P') THEN
			   SELECT ((compras.precocompra * 
						compras.quantidadecompra) / compras.parcelascompra)
					 , compras.parcelascompra	
					 , compras.datacompra
					INTO v_valorparcela
					   , v_quantidadeparcelas
					   , v_dataemissao
				   FROM compras 
				   WHERE compras.idcompras = p_idtransacao;
		   END IF;
		   -- Calcular o Valor da Parcela de Vendas
		   IF (p_tipocobranca = 'R') THEN
			   SELECT ((vendas.valorvenda * 
						vendas.quantidadevenda) / vendas.parcelasVenda)
					 , vendas.parcelasVenda	
					 , vendas.datavenda
					INTO v_valorparcela
					   , v_quantidadeparcelas
					   , v_dataemissao
				   FROM vendas 
				   WHERE vendas.idvendas = p_idtransacao;
		   END IF;
		   -- Validar se o Valor da Parcela é Valido
		   IF (v_valorparcela = 0 OR v_valorparcela IS NULL) THEN
			  SET p_msg = 'Dados da Compra Invalidos';
			  SET v_erro = 'S';
		   END IF;
        END IF; 

	   
	   IF v_erro <> 'S' THEN
		   -- Looping para criar os registros na tabela financeiro
		   SET v_contador = 1;
		   SET v_vencimento = v_dataemissao;
		   WHILE (v_contador <= v_quantidadeparcelas) DO
			 -- incluir dados na tabela financeiro
			 SET v_vencimento = adddate(v_vencimento,30);
			 INSERT INTO financeiro (dataemissao
									,datavencimento
									,valordevido
									,idtransacao
									,numeroparcela
									,tipo_financeiro)
				 VALUES (current_date(),
						 v_vencimento,
						 v_valorparcela,
						 p_idtransacao,
						 v_contador,
						 p_tipocobranca
						 );      
			 SET v_contador = v_contador + 1;
		   END WHILE;
		   SET p_msg = 'Boletos gerados com sucesso!!';
	   END IF;
	END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `v_avencer`
--

/*!50001 DROP VIEW IF EXISTS `v_avencer`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_avencer` (`datavencimento`,`datahoje`,`datavencimentoOriginal`,`datahojeoriginal`,`dataemissaobanco`,`datavencimentobanco`,`valordevidobanco`) AS select date_format(`financeiro`.`datavencimento`,'%d/%m/%Y') AS `date_format(datavencimento, '%d/%m/%Y')`,date_format(curdate(),'%d/%m/%Y') AS `date_format(current_date(), '%d/%m/%Y')`,`financeiro`.`datavencimento` AS `datavencimento`,curdate() AS `current_date()`,`financeiro`.`dataemissao` AS `dataemissao`,`financeiro`.`datavencimento` AS `datavencimento`,`financeiro`.`valordevido` AS `valordevido` from `financeiro` where (`financeiro`.`datavencimento` > curdate()) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_clientes`
--

/*!50001 DROP VIEW IF EXISTS `v_clientes`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_clientes` (`idCLiente`,`NomeCliente`,`Total_Compras`,`Duplicatas_Vencida`) AS select `clientes`.`idCliente` AS `idCliente`,`clientes`.`NomeCliente` AS `NomeCliente`,coalesce((select sum(`vendas`.`valorvenda`) from `vendas` where (`vendas`.`idCliente` = `clientes`.`idCliente`)),0) AS `Total_Compras`,coalesce((select sum(`financeiro`.`valordevido`) from (`financeiro` join `vendas` on(((`vendas`.`idvendas` = `financeiro`.`idtransacao`) and (`vendas`.`idCliente` = `clientes`.`idCliente`)))) where ((`financeiro`.`tipo_financeiro` = 'R') and (`financeiro`.`datapagamento` is null) and (`financeiro`.`datavencimento` < curdate()))),0) AS `Duplicatas_Vencida` from `clientes` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_titulos`
--

/*!50001 DROP VIEW IF EXISTS `v_titulos`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_titulos` (`Vencimento`,`DataAtual`,`Valor`,`Situacao`) AS select date_format(`financeiro`.`datavencimento`,'%d/%m/%Y') AS `Vencimento`,date_format(curdate(),'%d/%m/%Y') AS `Hoje`,`financeiro`.`valordevido` AS `ValorDevido`,(case when (`financeiro`.`datavencimento` < curdate()) then 'Vencido' else 'A Vencer' end) AS `Situacao` from `financeiro` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-11-22 20:34:21
