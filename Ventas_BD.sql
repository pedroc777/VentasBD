-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Ventas2
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Ventas2
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS Ventas2 DEFAULT CHARACTER SET utf8 ;
-- -----------------------------------------------------
-- Schema ventas2
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema ventas2
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ventas2` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `Ventas2` ;

-- -----------------------------------------------------
-- Table Ventas2.Proveedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Ventas2.Proveedor (
  proveedorId INT NOT NULL AUTO_INCREMENT,
  proveedorNom VARCHAR(255) NULL,
  proveedorDir VARCHAR(255) NULL,
  proveedorRFC VARCHAR(255) NULL,
  PRIMARY KEY (proveedorId))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table Ventas2.sucursal
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Ventas2.sucursal (
  sucursalId INT NOT NULL AUTO_INCREMENT,
  sucursalNom VARCHAR(255) NULL,
  sucursalDir VARCHAR(255) NULL,
  PRIMARY KEY (`sucursalId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Ventas2`.`traspaso`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Ventas2.traspaso (
  traspasoId INT NOT NULL AUTO_INCREMENT,
  sucursalIdorin INT NOT NULL,
  sucursalIdIdDest INT NOT NULL,
  fecha DATE NULL,
  PRIMARY KEY (traspasoId),
  INDEX fk_traspaso_sucursal1_idx (sucursalIdorin ASC) VISIBLE,
  INDEX fk_traspaso_sucursal2_idx (sucursalIdIdDest ASC) VISIBLE,
  CONSTRAINT fk_traspaso_sucursal1
    FOREIGN KEY (sucursalIdorin)
    REFERENCES Ventas2.sucursal (sucursalId)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_traspaso_sucursal2
    FOREIGN KEY (sucursalIdIdDest)
    REFERENCES Ventas2.sucursal (sucursalId)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table Ventas2.cliente
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Ventas2.cliente (
  clienteId INT NOT NULL AUTO_INCREMENT,
  clienteNom VARCHAR(255) NULL,
  clienteDir VARCHAR(255) NULL,
  clienteTel VARCHAR(255) NULL,
  clienteRFC VARCHAR(255) NULL,
  PRIMARY KEY (clienteId))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table Ventas2.tipoProducto
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Ventas2.tipoProducto (
  tPid INT NOT NULL AUTO_INCREMENT,
  tPNombre VARCHAR(255) NULL,
  tPDesc VARCHAR(255) NULL,
  proveedorId INT NOT NULL,
  PRIMARY KEY (tPid),
  INDEX fk_tipoProducto_Proveedor_idx (proveedorId ASC) VISIBLE,
  CONSTRAINT fk_tipoProducto_Proveedor
    FOREIGN KEY (proveedorId)
    REFERENCES Ventas2.Proveedor (proveedorId)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table Ventas2.producto
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Ventas2.producto (
  productoId INT NOT NULL AUTO_INCREMENT,
  productoNombre VARCHAR(255) NULL,
  productoDesc VARCHAR(255) NULL,
  productoPrecio FLOAT NULL,
  tPid INT NOT NULL,
  tiendaId INT NOT NULL,
  PRIMARY KEY (productoId),
  INDEX fk_producto_sucursal1_idx (tiendaId ASC) VISIBLE,
  INDEX fk_producto_tipoProducto1_idx (tPid ASC) VISIBLE,
  CONSTRAINT fk_producto_sucursal1
    FOREIGN KEY (tiendaId)
    REFERENCES Ventas2.sucursal (sucursalId)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_producto_tipoProducto1
    FOREIGN KEY (tPid)
    REFERENCES Ventas2.tipoProducto (tPid)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table Ventas2.traspasoProducto
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Ventas2.traspasoProducto (
  trprId INT NOT NULL AUTO_INCREMENT,
  traspasoId INT NOT NULL,
  productoId INT NOT NULL,
  PRIMARY KEY (trprId),
  INDEX fk_traspasoProducto_traspaso1_idx (traspasoId ASC) VISIBLE,
  INDEX fk_traspasoProducto_producto1_idx (productoId ASC) VISIBLE,
  UNIQUE INDEX productoId_UNIQUE (productoId ASC) VISIBLE,
  UNIQUE INDEX traspasoId_UNIQUE (traspasoId ASC) VISIBLE,
  CONSTRAINT fk_traspasoProducto_traspaso1
    FOREIGN KEY (traspasoId)
    REFERENCES Ventas2.traspaso (traspasoId)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_traspasoProducto_producto1
    FOREIGN KEY (productoId)
    REFERENCES Ventas2.producto (productoId)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table Ventas2.venta
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Ventas2.venta (
  ventaId INT NOT NULL AUTO_INCREMENT,
  clienteId INT NOT NULL,
  totalVenta FLOAT NULL,
  fechaVenta DATE NULL,
  sucursalId INT NOT NULL,
  PRIMARY KEY (ventaId, sucursalId),
  INDEX fk_venta_cliente1_idx (clienteId ASC) VISIBLE,
  INDEX fk_venta_sucursal1_idx (sucursalId ASC) VISIBLE,
  CONSTRAINT fk_venta_cliente1
    FOREIGN KEY (clienteId)
    REFERENCES Ventas2.cliente (clienteId)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_venta_sucursal1
    FOREIGN KEY (sucursalId)
    REFERENCES Ventas2.sucursal (sucursalId)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table Ventas2.devolucion
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Ventas2.devolucion (
  devId INT NOT NULL AUTO_INCREMENT,
  ventaId INT NOT NULL,
  sucursalId INT NOT NULL,
  sucursalId2 INT NOT NULL,
  fechaDev VARCHAR(45) NULL,
  totalDev VARCHAR(45) NULL,
  PRIMARY KEY (devId),
  INDEX fk_devolucion_sucursal1_idx (sucursalId ASC) VISIBLE,
  INDEX fk_devolucion_venta1_idx (ventaId ASC, sucursalId2 ASC) VISIBLE,
  CONSTRAINT fk_devolucion_sucursal1
    FOREIGN KEY (sucursalId)
    REFERENCES Ventas2.sucursal (sucursalId)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_devolucion_venta1
    FOREIGN KEY (ventaId , sucursalId2)
    REFERENCES Ventas2.venta (ventaId , sucursalId)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Ventas2`.`productoVenta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Ventas2.productoVenta (
  pvId INT NOT NULL AUTO_INCREMENT,
  ventaId INT NOT NULL,
  sucursalId INT NOT NULL,
  sucursalId2 INT NOT NULL,
  productoId INT NOT NULL,
  PRIMARY KEY (pvId),
  INDEX fk_productoVenta_venta1_idx (ventaId ASC, sucursalId ASC) VISIBLE,
  INDEX fk_productoVenta_producto1_idx (productoId ASC) VISIBLE,
  UNIQUE INDEX productoId_UNIQUE (productoId ASC) VISIBLE,
  INDEX fk_productoVenta_sucursal1_idx (sucursalId2 ASC) VISIBLE,
  CONSTRAINT fk_productoVenta_venta1
    FOREIGN KEY (ventaId , sucursalId)
    REFERENCES Ventas2.venta (ventaId , sucursalId)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_productoVenta_producto1
    FOREIGN KEY (productoId)
    REFERENCES Ventas2.producto (productoId)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_productoVenta_sucursal1
    FOREIGN KEY (sucursalId2)
    REFERENCES Ventas2.sucursal (sucursalId)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table Ventas2.devProducto
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Ventas2.devProducto (
  dpId INT NOT NULL AUTO_INCREMENT,
  pvId INT NOT NULL,
  devId INT NOT NULL,
  PRIMARY KEY (dpId),
  INDEX fk_devProducto_productoVenta1_idx (pvId ASC) VISIBLE,
  INDEX fk_devProducto_devolucion1_idx (devId ASC) VISIBLE,
  UNIQUE INDEX pvId_UNIQUE (pvId ASC) VISIBLE,
  CONSTRAINT fk_devProducto_productoVenta1
    FOREIGN KEY (pvId)
    REFERENCES Ventas2.productoVenta (pvId)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT fk_devProducto_devolucion1
    FOREIGN KEY (devId)
    REFERENCES Ventas2.devolucion (devId)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE ventas2;

-- -----------------------------------------------------
-- Table ventas2.cliente
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ventas2.cliente (
  clienteId INT NOT NULL AUTO_INCREMENT,
  clienteNom VARCHAR(255) NULL DEFAULT NULL,
  clienteDir VARCHAR(255) NULL DEFAULT NULL,
  clienteTel VARCHAR(255) NULL DEFAULT NULL,
  clienteRFC VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (clienteId))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table ventas2.sucursal
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ventas2.sucursal (
  sucursalId INT NOT NULL AUTO_INCREMENT,
  sucursalNom VARCHAR(255) NULL DEFAULT NULL,
  sucursalDir VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (sucursalId))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table ventas2.venta
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ventas2.venta (
  ventaId INT NOT NULL AUTO_INCREMENT,
  clienteId INT NOT NULL,
  totalVenta FLOAT NULL DEFAULT NULL,
  fechaVenta DATE NULL DEFAULT NULL,
  sucursalId INT NOT NULL,
  PRIMARY KEY (ventaId, sucursalId),
  INDEX fk_venta_cliente1_idx (clienteId ASC) VISIBLE,
  INDEX fk_venta_sucursal1_idx (sucursalId ASC) VISIBLE,
  CONSTRAINT fk_venta_cliente1
    FOREIGN KEY (clienteId)
    REFERENCES ventas2.cliente (clienteId),
  CONSTRAINT fk_venta_sucursal1
    FOREIGN KEY (sucursalId)
    REFERENCES ventas2.sucursal (sucursalId))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table ventas2.devolucion
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ventas2.devolucion (
  devId INT NOT NULL AUTO_INCREMENT,
  ventaId INT NOT NULL,
  sucursalId INT NOT NULL,
  sucursalId2 INT NOT NULL,
  fechaDev VARCHAR(45) NULL DEFAULT NULL,
  totalDev VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (devId),
  INDEX fk_devolucion_sucursal1_idx (sucursalId ASC) VISIBLE,
  INDEX fk_devolucion_venta1_idx (ventaId ASC, sucursalId2 ASC) VISIBLE,
  CONSTRAINT fk_devolucion_sucursal1
    FOREIGN KEY (sucursalId)
    REFERENCES ventas2.sucursal (sucursalId),
  CONSTRAINT fk_devolucion_venta1
    FOREIGN KEY (ventaId , sucursalId2)
    REFERENCES ventas2.venta (ventaId , sucursalId))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table ventas2.proveedor
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ventas2.proveedor (
  proveedorId INT NOT NULL AUTO_INCREMENT,
  proveedorNom VARCHAR(255) NULL DEFAULT NULL,
  proveedorDir VARCHAR(255) NULL DEFAULT NULL,
  proveedorRFC VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (proveedorId))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table ventas2.tipoproducto
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ventas2.tipoproducto (
  tPid INT NOT NULL AUTO_INCREMENT,
  tPNombre VARCHAR(255) NULL DEFAULT NULL,
  tPDesc VARCHAR(255) NULL DEFAULT NULL,
  proveedorId INT NOT NULL,
  PRIMARY KEY (tPid),
  INDEX fk_tipoProducto_Proveedor_idx (proveedorId ASC) VISIBLE,
  CONSTRAINT fk_tipoProducto_Proveedor
    FOREIGN KEY (proveedorId)
    REFERENCES ventas2.proveedor (proveedorId))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table ventas2.producto
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ventas2.producto (
  productoId INT NOT NULL AUTO_INCREMENT,
  productoNombre VARCHAR(255) NULL DEFAULT NULL,
  productoDesc VARCHAR(255) NULL DEFAULT NULL,
  productoPrecio FLOAT NULL DEFAULT NULL,
  tPid INT NOT NULL,
  tiendaId INT NOT NULL,
  PRIMARY KEY (productoId),
  INDEX fk_producto_sucursal1_idx (tiendaId ASC) VISIBLE,
  INDEX fk_producto_tipoProducto1_idx (tPid ASC) VISIBLE,
  CONSTRAINT fk_producto_sucursal1
    FOREIGN KEY (tiendaId)
    REFERENCES ventas2.sucursal (sucursalId),
  CONSTRAINT fk_producto_tipoProducto1
    FOREIGN KEY (tPid)
    REFERENCES ventas2.tipoproducto (tPid))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table ventas2.productoventa
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ventas2.productoventa (
  pvId INT NOT NULL AUTO_INCREMENT,
  ventaId INT NOT NULL,
  sucursalId INT NOT NULL,
  sucursalId2 INT NOT NULL,
  productoId INT NOT NULL,
  PRIMARY KEY (pvId),
  UNIQUE INDEX productoId_UNIQUE (productoId ASC) VISIBLE,
  INDEX fk_productoVenta_venta1_idx (ventaId ASC, sucursalId ASC) VISIBLE,
  INDEX fk_productoVenta_producto1_idx (productoId ASC) VISIBLE,
  INDEX fk_productoVenta_sucursal1_idx (sucursalId2 ASC) VISIBLE,
  CONSTRAINT fk_productoVenta_producto1
    FOREIGN KEY (productoId)
    REFERENCES ventas2.producto (productoId),
  CONSTRAINT fk_productoVenta_sucursal1
    FOREIGN KEY (sucursalId2)
    REFERENCES ventas2.sucursal (sucursalId),
  CONSTRAINT fk_productoVenta_venta1
    FOREIGN KEY (ventaId , sucursalId)
    REFERENCES ventas2.venta (ventaId , sucursalId))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table ventas2.devproducto
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ventas2.devproducto (
  dpId INT NOT NULL AUTO_INCREMENT,
  pvId INT NOT NULL,
  devId INT NOT NULL,
  PRIMARY KEY (dpId),
  INDEX fk_devProducto_productoVenta1_idx (pvId ASC) VISIBLE,
  INDEX fk_devProducto_devolucion1_idx (devId ASC) VISIBLE,
  CONSTRAINT fk_devProducto_devolucion1
    FOREIGN KEY (devId)
    REFERENCES ventas2.devolucion (devId),
  CONSTRAINT fk_devProducto_productoVenta1
    FOREIGN KEY (pvId)
    REFERENCES ventas2.productoventa (pvId))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table ventas2.traspaso
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ventas2.traspaso (
  traspasoId INT NOT NULL AUTO_INCREMENT,
  sucursalIdorin INT NOT NULL,
  sucursalIdIdDest INT NOT NULL,
  fecha DATE NULL DEFAULT NULL,
  PRIMARY KEY (traspasoId),
  INDEX fk_traspaso_sucursal1_idx (sucursalIdorin ASC) VISIBLE,
  INDEX fk_traspaso_sucursal2_idx (sucursalIdIdDest ASC) VISIBLE,
  CONSTRAINT fk_traspaso_sucursal1
    FOREIGN KEY (sucursalIdorin)
    REFERENCES ventas2.sucursal (sucursalId),
  CONSTRAINT fk_traspaso_sucursal2
    FOREIGN KEY (sucursalIdIdDest)
    REFERENCES ventas2.sucursal (sucursalId))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `ventas2`.`traspasoproducto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS ventas2.traspasoproducto (
  trprId INT NOT NULL AUTO_INCREMENT,
  productoId INT NOT NULL,
  traspasoId INT NOT NULL,
  PRIMARY KEY (trprId),
  UNIQUE INDEX productoId_UNIQUE (productoId ASC) VISIBLE,
  INDEX fk_traspasoProducto_traspaso1_idx (traspasoId ASC) VISIBLE,
  INDEX fk_traspasoProducto_producto1_idx (productoId ASC) VISIBLE,
  CONSTRAINT fk_traspasoProducto_producto1
    FOREIGN KEY (proproductoventaductoId)
    REFERENCES ventas2.producto (productoId),
  CONSTRAINT fk_traspasoProducto_traspaso1
    FOREIGN KEY (traspasoId)
    REFERENCES ventas2.traspaso (traspasoId))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


/*------------------------------------------------------------------------------------------------------------*/
/*1. Llene las tablas Proveedor, tipoProducto, cliente, y sucursal con al menos 5 instancias.*/
/*proveedor*/
INSERT INTO proveedor (proveedorNom, proveedorDir, proveedorRFC)
values
	("Samsung", "Menlo Park, CA 94025", "COSS380301QU10"),
    ("Apple", "Silicon Valley, CA 54090", "JOAP890402RV43"),
    ("Xiaomi", "PekÃ­n, China", "XIPK100503GT54"),
    ("Huawei", "Shenzhen, China", "HUARZ870604MP76"),
    ("Motorola", " Monroe Street, IL 60661", "MOPG280705NH12");

/*cliente*/
INSERT INTO cliente (clienteNom, clienteDir, clienteTel, clienteRFC)
values
	("Pedro Cano", "692 Windham Road 6", "5289456734", "CAPP840617HMC"),
    ("Madison Square", "783 Birmingham St 7", "6389443786", "SQGM960918CMH"),
    ("Gonzalo Pérez", "540 Somex H6", "5236369534", "PEMG941123GMC"),
    ("Romualdo López", "562 Gral. Anaya 99", "7399876765", "LOMR740101RKO"),
    ("Cirilo Sanchez", "S/N Autopista a Cuernavaca", "8956775623", "SAPC950427CCA");

/*sucursal*/
INSERT INTO sucursal (sucursalNom, sucursalDir)
values
	("Smart X Vallejo", "Clz. Vía Vallejo N0. 1090 Col. Santa Cruz de las Salinas, Del. Azcapotzalco"),
    ("Teléfonos Linda Vista", "Av. Montevideo 363, Lindavista Sur, Gustavo A. Madero"),
    ("Park Phone", "Colector 13 280, Magdalena de las Salinas, Gustavo A. Madero"),
    ("Celulares Chayito", "Av. El Rosario No. 1025, Col. El Rosario, Azcapotzalco"),
    ("E-Phones", "Blvd. Manuel Ávila Camacho No. 1007, Col. Santa Monica, Tlalnepantla de Baz");

/*TipoProducto*/
INSERT INTO tipoproducto (tPNombre, tPDesc, proveedorId)
values
	("Smartphone", "Teléfono avanzado con sistema operativo y pantalla táctil.", 2),
    ("Clásico", "Teléfono para realizar llamadas y mensajes de texto.", 5),
    ("Low cost", "Teléfono con funciones básicas (whatsapp, llamadas, etc).", 3),
    ("Todoterreno", "Teléfono avanzado que resiste condiciones extremas.", 4),
    ("Octacore", "Teléfono avanzado con 8 núcleos en el procesador.", 1);
    
-- las descripciones las saquÃ© de aquÃ­: https://www.maxmovil.com/es/moviles-libres/tipos.html

/*2. Llene las tablas Producto, Venta y Traspaso con al menos 10 instancias*/
/*Producto*/
INSERT INTO producto (productoNombre, productoDesc, productoPrecio, tPid, tiendaId)
values
	("iPhone XL","iPhone de última generación",20000.00, 2, 1),
    ("MOTO G","Almacenamiento: 16 Gb, SO: Android",10000.00, 1, 2),
    ("RM","Teléfono pequeño y resitente",20000.00, 4, 3),
    ("ZTE","Almacenamiento: 4GB, SO: Android",6000.00, 3, 4),
    ("Nokia 5120","Teléfono austero",500.00, 2, 5),
    ("GALAXY Z Omega","Almacenamiento: 64 Gb, SO: Android",50000.00, 5, 5),
    ("iPhone 5","Almacenamiento: 60 gb, SO: iOS",6000.00, 1, 4),
    ("BlackBerry 7230","Almacenamiento: 4 Gb, SO: RM",1000.00, 2, 3),
    ("Xiaomi Redmi Note 8","Almacenamiento: 64 Gb, SO: Android 11 MIUI 12.5",30000.00, 5, 3),
    ("Huawei Nova 9","Almacenamiento: 64 Gb, SO: EMUI 12 ",12999.00, 3, 2),
    ("BlackBerry Z10","Almacenamiento: 32 Gb, SO: BlackBerry 10",15000.00, 4, 1);

/*venta; Fecha: 20180101 (año/mes/día)*/
INSERT INTO venta (clienteId, totalVenta, fechaVenta, sucursalId)
values
	(1, 30000.00, 20220130, 1),
    (2, 15000.00, 20220131, 5),
    (3, 20000.00, 20220131, 4),
    (4, 500.00, 20220201, 3),
    (5, 12999.00, 20220202, 2),
    (5, 10000.00, 20220204, 1),
    (4, 6000.00, 20220204, 2),
    (3, 15500.00, 20220204, 3),
    (2, 1000.00, 20220205, 4),
    (1, 20000.00, 20220206, 1),
    (5, 500.00, 20220130, 1);

/*traspaso; Fecha: 20180101 (año/mes/día)*/
INSERT INTO traspaso (sucursalIdorin, sucursalIdIdDest, fecha)
values
	(1, 2, 20211101),
    (2, 3, 20211102),
    (3, 4, 20211103),
    (4, 5, 20211122),
    (5, 1, 20211122),
    (5, 2, 20211122),
    (5, 3, 20211127),
    (4, 5, 20211212),
    (3, 5, 20211223),
    (2, 1, 20211230);
    
/*3. Llene las tablas Producto, Venta y Traspaso con al menos 10 instancias*/
/*Producto*/
INSERT INTO producto (productoNombre, productoDesc, productoPrecio, tPid, tiendaId)
values
	("iPhone 13 pro","Almacenamiento: 64Gb, SO: iOS",45000.00, 2, 1),
    ("Google Pixel 6 Pro","Almacenamiento: 8 Gb, SO: Android 16",18000.00, 1, 2),
    ("iPhone 13","Almacenamiento: 128Gb, SO: iOS",37000.00, 4, 3),
    ("Samsung Galaxy S21 Ultra","Almacenamiento: 32Gb, SO: Android 12",17000.00, 3, 4),
    ("Oppo Find X3 Pro","Almacenamiento: 64Gb, SO: Android 12",19000.00, 2, 5),
    ("Realme GT","Almacenamiento: 1 Tb, SO: Android 13",26000.00, 5, 5),
    ("Red Magic 6S Pro","Almacenamiento: 6Gb, SO: Android 10",60000.00, 1, 4),
    ("Samsung Galaxy Z Flip 3","Almacenamiento: 90Gb, SO: RMI",100000.00, 2, 3),
    ("Sony Xperia 1 III","Almacenamiento: 60 Gb, SO: Android 11 MIUI 12.5",14000.00, 5, 3),
    ("OnePlus Nord 2","Almacenamiento: 80 Gb, SO: EMUI 12 ",37000.00, 3, 2);
    
/*venta; Fecha: 20180101 (año/mes/día)*/
INSERT INTO venta (clienteId, totalVenta, fechaVenta, sucursalId)
values
	(2, 17000.00, 20220207, 2),
    (2, 16000.00, 20220208, 5),
    (5, 67000.00, 20220208, 5),
    (5, 80000.00, 20220208, 5),
    (4, 12500.00, 20220208, 3),
    (3, 66000.00, 20220209, 3),
    (5, 19343.99, 20220210, 3),
    (1, 14314.00, 20220210, 1),
    (3, 86787.00, 20220210, 1),
    (4, 96868.00, 20220211, 4),
    (5, 76868.00, 20220211, 4);

/*traspaso; Fecha: 20180101 (aÃ±o/mes/dÃ­a)*/
INSERT INTO traspaso (sucursalIdorin, sucursalIdIdDest, fecha)
values
	(5, 4, 20220211),
    (4, 3, 20220212),
    (3, 2, 20220213),
    (2, 1, 20220214),
    (2, 5, 20220215),
    (3, 1, 20220215),
    (4, 5, 20220215),
    (2, 4, 20220216),
    (3, 1, 20220217),
    (4, 5, 20220217);


/*4. Llene las tablas Producto/Venta y Traspaso/Producto con al menos 20 instancias.*/
/*Producto/Venta*/
INSERT INTO productoventa (ventaId, sucursalId, sucursalId2, productoId)
VALUES
	(2, 5, 5, 2),
    (3, 4, 4, 3),
    (4, 3, 3, 4),
    (5, 2, 2, 5),
    (6, 1, 1, 6),
    (7, 2, 2, 7),
    (8, 3, 3, 8),
    (9, 4, 4, 9),
    (10, 1, 1, 10),
    (11, 1, 1, 11),
    (12, 2, 2, 12),
    (13, 5, 5, 13),
    (14, 5, 5, 14),
    (15, 5, 5, 15),
    (16, 3, 3, 16),
    (17, 3, 3, 17),
    (18, 3, 3, 18),
    (19, 1, 1, 19),
    (20, 1, 1, 20);
    
/*Traspaso/Producto*/
INSERT INTO traspasoproducto (productoId, traspasoId)
VALUES
	(2,1),
    (3,2),
    (6,3),
    (7,4),
    (19,5),
    (21,6),
    (20,7),
    (1,8),
    (4,9),
    (5,10),
    (8,11),
    (9,12),
    (10,13),
    (11,14),
    (12,15),
    (13,16),
    (14,17),
    (15,18),
    (16,19);

/*5. Llene las tablas Devolución con 1 instancia y dev/Producto con al menos 1 instancia*/
/*devolucion*/
INSERT INTO devolucion (ventaId, sucursalId, sucursalId2, fechaDev, totalDev)
VALUES (1,1,1,20220207,70000.00),
       (2,5,5,20220208,80000.00),
       (3,4,4,20220209,500.00),
       (4,3,3,20220210,15000.00);

/*dev/Producto*/
INSERT INTO devproducto (pvId, devId)
VALUES (1,7),
	   (21,8),
       (22,9),
       (23,10);

/*6. Genere una vista de los productos más vendidos. Para ello considere mostrar productoId, productoNombre,
productoDescripcio, proveedorNombre y tPNombre*/

/*consulta*/
SELECT p.productoId, p.productoNombre, p.productoDesc, v.proveedorNom, t.tPNombre, COUNT(t.tPNombre) as "Numero de ventas"
FROM ((producto p INNER JOIN tipoproducto t ON p.tPid = t.tPid) INNER JOIN proveedor v
ON t.proveedorId = v.proveedorId) INNER JOIN productoventa n ON p.productoId = n.productoId GROUP BY t.tPNombre
ORDER BY COUNT(t.tPNombre) desc;

/*vista*/
CREATE VIEW productos_mas_vendidos AS
SELECT p.productoId, p.productoNombre, p.productoDesc, v.proveedorNom, t.tPNombre, COUNT(t.tPNombre) as "Numero de ventas"
FROM ((producto p INNER JOIN tipoproducto t ON p.tPid = t.tPid) INNER JOIN proveedor v
ON t.proveedorId = v.proveedorId) INNER JOIN productoventa n ON p.productoId = n.productoId GROUP BY t.tPNombre
ORDER BY COUNT(t.tPNombre) desc;

/*7. Genere una función que permita obtener el tPNombre del producto más vendido*/
/*Consulta*/
SELECT t.tPNombre
FROM (producto p INNER JOIN tipoproducto t ON t.tPid = p.tPid) INNER JOIN productoventa v
ON v.productoId = p.productoId group by t.tPid ORDER BY COUNT(t.tPid) desc limit 1;

/*función*/
DELIMITER //
CREATE FUNCTION NombreMasVendido () RETURNS VARCHAR (255)
deterministic
BEGIN
 DECLARE n VARCHAR(255);
 SELECT t.tPNombre INTO n FROM (producto p INNER JOIN tipoproducto t ON t.tPid = p.tPid) INNER JOIN productoventa v ON v.productoId = p.productoId group by t.tPid ORDER BY COUNT(t.tPid) desc limit 1;
 RETURN n;
END//
DELIMITER ;

select NombreMasVendido();

/*8. Genere un procedimiento que muestre todos los productos de un proveedor con base en el nombre del proveedor*/
/*consulta*/
SELECT p.*, v.proveedorNom, t.tPNombre FROM (producto p INNER JOIN tipoproducto t ON p.tPid = t.tPid)
INNER JOIN proveedor v ON v.proveedorId = p.tPid WHERE v.proveedorNom = "Samsung";

/*procedimiento*/
DELIMITER //
CREATE PROCEDURE BUSCA_PRODUCTO (_NombreProveedor VARCHAR(255))
BEGIN
	SELECT p.*, v.proveedorNom, t.tPNombre FROM (producto p INNER JOIN tipoproducto t ON p.tPid = t.tPid)
	INNER JOIN proveedor v ON v.proveedorId = p.tPid WHERE v.proveedorNom = _NombreProveedor;
END //
DELIMITER ;

CALL BUSCA_PRODUCTO("Motorola");

/*9. Genere una tabla llamada DevRespaldo con los campos: DervrespaldoID, DevID, VentaID, SucursalID,
 FechaDev, TotalDev, Sucursal, Usuario*/
CREATE TABLE IF NOT EXISTS DevRespaldo(
	DevrespaldoId INT AUTO_INCREMENT,
    DevID INT,
    VentaID INT,
    SucursalID INT,
    FechaDev DATE,
    TotalDev FLOAT,
    Sucursal INT,
    Usuario INT,
    
    PRIMARY KEY (DevrespaldoId)
);

ALTER TABLE devrespaldo MODIFY COLUMN Usuario VARCHAR(255);
ALTER TABLE devrespaldo MODIFY COLUMN Sucursal VARCHAR(255);

/*10. Genere un trigger en la tabla Devolución de modo que al eliminar un registro de esta,
dicho registro se guarde en la tala RespaldoDev y que al mismo tiempo elimine los registros
asociados en Dev/Producto*/

/*primero hice una función para obtener el nombre de la surcursal y poder insertarlo en devrespaldo*/
DROP FUNCTION IF EXISTS nombreS;

DELIMITER //
CREATE FUNCTION nombreS (sucursalId INT) RETURNS VARCHAR (255)
deterministic
BEGIN
	DECLARE z VARCHAR (255);
	SELECT s.sucursalNom INTO z FROM devolucion d INNER JOIN sucursal s ON d.sucursalId = s.sucursalId;
    RETURN z;
END//
DELIMITER ;

/*luego hice el trigger*/
DROP TRIGGER IF EXISTS ventas2.respaldoDev;
delimiter //
CREATE TRIGGER respaldoDev BEFORE DELETE ON devolucion
FOR EACH ROW
  BEGIN
    INSERT INTO DevRespaldo (DevID, VentaID, SucursalID, FechaDev, TotalDev, Sucursal, Usuario)
    VALUES (OLD.devId, OLD.ventaId,OLD.sucursalId,OLD.fechaDev,OLD.totalDev, nombreS(OLD.sucursalId), current_user());
  END;

//
delimiter ;

/*Esta primera versión sólo respalda los datos indicados. Hice otra que sí borra los datos de la tabla devproducto,
pero los borra todos. Lo dejé así porque no sé qué le pasó a mi servidor o a workbench, pero llega un momento en que
el trigger deja de funcionar. Quiero borrar un dato de devolucion y sólo me otorga el siguiente error:
22:26:23	DELETE FROM devolucion WHERE devId = 9	Error Code: 1172. Result consisted of more than one row	0.000 sec
 No me dio tiempo de probar con otras posibilidades que pongo abajo*/

delimiter //
CREATE TRIGGER respaldoDev BEFORE DELETE ON devolucion
FOR EACH ROW
  BEGIN
	DELETE FROM devproducto;
    INSERT INTO DevRespaldo (DevID, VentaID, SucursalID, FechaDev, TotalDev, Sucursal, Usuario)
    VALUES (OLD.devId, OLD.ventaId,OLD.sucursalId,OLD.fechaDev,OLD.totalDev, nombreS(OLD.sucursalId), current_user());
  END;

//
delimiter ;

/*----------------------------------OTRAS POSIBILIDADES---------------------------------------------*/

delimiter //
CREATE TRIGGER respaldoDev BEFORE DELETE ON devolucion
FOR EACH ROW
  BEGIN
	DELETE FROM devproducto WHERE devproducto.devId = devpId(OLD.devId);
    INSERT INTO DevRespaldo (DevID, VentaID, SucursalID, FechaDev, TotalDev, Sucursal, Usuario)
    VALUES (OLD.devId, OLD.ventaId,OLD.sucursalId,OLD.fechaDev,OLD.totalDev, nombreS(OLD.sucursalId), current_user());
  END;

//
delimiter ;

/*para esta hice otra función que devuelve el id de devolucion, pero me arrojaba los mismos errores*/
DROP FUNCTION IF EXISTS devpId;
DELIMITER //
CREATE FUNCTION devpId (devId INT) RETURNS INT
deterministic
BEGIN
	DECLARE i INT;
	SELECT d.devId INTO i FROM (devolucion d INNER JOIN devproducto t ON d.devId = t.devId) WHERE t.devId = devId limit 1;
    RETURN i;
END//
DELIMITER ;


/*---------------------------------INSTRUCCIONES DE LAS TABLAS CON TODAS LAS MODIFICACIONES------------------------------------------------*/
CREATE TABLE cliente (
  clienteId int NOT NULL AUTO_INCREMENT,
  clienteNom varchar(255) DEFAULT NULL,
  clienteDir varchar(255) DEFAULT NULL,
  clienteTel varchar(255) DEFAULT NULL,
  clienteRFC varchar(255) DEFAULT NULL,
  PRIMARY KEY (clienteId)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;

CREATE TABLE devolucion (
  devId int NOT NULL AUTO_INCREMENT,
  ventaId int NOT NULL,
  sucursalId int NOT NULL,
  sucursalId2 int NOT NULL,
  fechaDev varchar(45) DEFAULT NULL,
  totalDev varchar(45) DEFAULT NULL,
  PRIMARY KEY (`devId`),
  KEY fk_devolucion_sucursal1_idx (sucursalId),
  KEY fk_devolucion_venta1_idx (ventaId,sucursalId2),
  CONSTRAINT fk_devolucion_sucursal1 FOREIGN KEY (sucursalId) REFERENCES sucursal (sucursalId),
  CONSTRAINT fk_devolucion_venta1 FOREIGN KEY (ventaId, sucursalId2) REFERENCES venta (ventaId, sucursalId)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb3;

CREATE TABLE devproducto (
  dpId int NOT NULL AUTO_INCREMENT,
  pvId int NOT NULL,
  devId int NOT NULL,
  PRIMARY KEY (dpId),
  UNIQUE KEY pvId_UNIQUE (pvId),
  KEY fk_devProducto_productoVenta1_idx (pvId),
  KEY fk_devProducto_devolucion1_idx (devId),
  CONSTRAINT fk_devProducto_devolucion1 FOREIGN KEY (devId) REFERENCES devolucion (devId),
  CONSTRAINT fk_devProducto_productoVenta1 FOREIGN KEY (pvId) REFERENCES productoventa (pvId)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb3;

CREATE TABLE devrespaldo (
  DevrespaldoId int NOT NULL AUTO_INCREMENT,
  DevID int DEFAULT NULL,
  VentaID int DEFAULT NULL,
  SucursalID int DEFAULT NULL,
  FechaDev date DEFAULT NULL,
  TotalDev float DEFAULT NULL,
  Sucursal varchar(255) DEFAULT NULL,
  Usuario varchar(255) DEFAULT NULL,
  PRIMARY KEY (DevrespaldoId)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3;

CREATE TABLE producto (
  productoId int NOT NULL AUTO_INCREMENT,
  productoNombre varchar(255) DEFAULT NULL,
  productoDesc varchar(255) DEFAULT NULL,
  productoPrecio float DEFAULT NULL,
  tPid int NOT NULL,
  tiendaId int NOT NULL,
  PRIMARY KEY (productoId),
  KEY fk_producto_sucursal1_idx (tiendaId),
  KEY fk_producto_tipoProducto1_idx (tPid),
  CONSTRAINT fk_producto_sucursal1 FOREIGN KEY (tiendaId) REFERENCES sucursal (sucursalId),
  CONSTRAINT fk_producto_tipoProducto1 FOREIGN KEY (tPid) REFERENCES tipoproducto (tPid)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb3;

CREATE TABLE productoventa (
  pvId int NOT NULL AUTO_INCREMENT,
  ventaId int NOT NULL,
  sucursalId int NOT NULL,
  sucursalId2 int NOT NULL,
  productoId int NOT NULL,
  PRIMARY KEY (pvId),
  UNIQUE KEY productoId_UNIQUE (productoId),
  KEY fk_productoVenta_venta1_idx (ventaId,sucursalId),
  KEY fk_productoVenta_producto1_idx (productoId),
  KEY fk_productoVenta_sucursal1_idx (sucursalId2),
  CONSTRAINT fk_productoVenta_producto1 FOREIGN KEY (productoId) REFERENCES producto (productoId),
  CONSTRAINT fk_productoVenta_sucursal1 FOREIGN KEY (sucursalId2) REFERENCES sucursal (sucursalId),
  CONSTRAINT fk_productoVenta_venta1 FOREIGN KEY (ventaId, sucursalId) REFERENCES venta (ventaId, sucursalId)
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb3;

CREATE TABLE proveedor (
  proveedorId int NOT NULL AUTO_INCREMENT,
  proveedorNom varchar(255) DEFAULT NULL,
  proveedorDir varchar(255) DEFAULT NULL,
  proveedorRFC varchar(255) DEFAULT NULL,
  PRIMARY KEY (proveedorId)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;

CREATE TABLE sucursal (
  sucursalId int NOT NULL AUTO_INCREMENT,
  sucursalNom varchar(255) DEFAULT NULL,
  sucursalDir varchar(255) DEFAULT NULL,
  PRIMARY KEY (sucursalId)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;

CREATE TABLE tipoproducto (
  tPid int NOT NULL AUTO_INCREMENT,
  tPNombre varchar(255) DEFAULT NULL,
  tPDesc varchar(255) DEFAULT NULL,
  proveedorId int NOT NULL,
  PRIMARY KEY (tPid),
  KEY fk_tipoProducto_Proveedor_idx (proveedorId),
  CONSTRAINT fk_tipoProducto_Proveedor FOREIGN KEY (proveedorId) REFERENCES proveedor (proveedorId)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;

CREATE TABLE traspaso (
  traspasoId int NOT NULL AUTO_INCREMENT,
  sucursalIdorin int NOT NULL,
  sucursalIdIdDest int NOT NULL,
  fecha date DEFAULT NULL,
  PRIMARY KEY (traspasoId),
  KEY fk_traspaso_sucursal1_idx (sucursalIdorin),
  KEY fk_traspaso_sucursal2_idx (sucursalIdIdDest),
  CONSTRAINT fk_traspaso_sucursal1 FOREIGN KEY (sucursalIdorin) REFERENCES sucursal (sucursalId),
  CONSTRAINT fk_traspaso_sucursal2 FOREIGN KEY (sucursalIdIdDest) REFERENCES sucursal (sucursalId)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb3;

CREATE TABLE traspasoproducto (
  trprId int NOT NULL AUTO_INCREMENT,
  traspasoId int NOT NULL,
  productoId int NOT NULL,
  PRIMARY KEY (trprId),
  UNIQUE KEY productoId_UNIQUE (productoId),
  UNIQUE KEY traspasoId_UNIQUE (traspasoId),
  KEY fk_traspasoProducto_traspaso1_idx (traspasoId),
  KEY fk_traspasoProducto_producto1_idx (productoId),
  CONSTRAINT fk_traspasoProducto_producto1 FOREIGN KEY (productoId) REFERENCES producto (productoId),
  CONSTRAINT fk_traspasoProducto_traspaso1 FOREIGN KEY (traspasoId) REFERENCES traspaso (traspasoId)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb3;

CREATE TABLE venta (
  ventaId int NOT NULL AUTO_INCREMENT,
  clienteId int NOT NULL,
  totalVenta float DEFAULT NULL,
  fechaVenta date DEFAULT NULL,
  sucursalId int NOT NULL,
  PRIMARY KEY (ventaId,sucursalId),
  KEY fk_venta_cliente1_idx (clienteId),
  KEY fk_venta_sucursal1_idx (sucursalId),
  CONSTRAINT fk_venta_cliente1 FOREIGN KEY (clienteId) REFERENCES cliente (clienteId),
  CONSTRAINT fk_venta_sucursal1 FOREIGN KEY (sucursalId) REFERENCES sucursal (sucursalId)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb3;
