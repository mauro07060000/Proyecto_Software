-- Creación de la base de datos
CREATE DATABASE adventureWorksDW;
USE adventureWorksDW;

-- Dimensión Producto
CREATE TABLE Dim_Product (
  Product_key INT PRIMARY KEY AUTO_INCREMENT,
  Product_id INT(11) NOT NULL COMMENT 'Primary key for Product records.',
  Product_Name VARCHAR(100) CHARACTER SET utf8mb4 NOT NULL COMMENT 'Name of the product.',
  ProductCategory_Name VARCHAR(100) CHARACTER SET utf8mb4 NOT NULL COMMENT 'Category description.',
  ProductSubcategory_Name VARCHAR(100) CHARACTER SET utf8mb4 NOT NULL COMMENT 'Subcategory description.'
);

-- Dimensión Tiempo
CREATE TABLE Dim_Tiempo (
  Tiempo_key INT PRIMARY KEY AUTO_INCREMENT,
  OrderDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Dates the sales order was created.',
  Dia INT,
  Mes INT,
  Ano INT
);

-- Dimensión Cliente
CREATE TABLE Dim_Cliente (
  Cliente_key INT PRIMARY KEY AUTO_INCREMENT,
  Customer_ID INT(11) NOT NULL COMMENT 'Primary key.',
  City VARCHAR(30) CHARACTER SET utf8mb4 NOT NULL COMMENT 'Name of the city.',
  Store_name VARCHAR(100) CHARACTER SET utf8mb4 NOT NULL COMMENT 'Name of the store.'
);

-- Dimensión Territory
CREATE TABLE Dim_Territory (
  Territory_key INT PRIMARY KEY AUTO_INCREMENT,
  Territory_ID INT(11) NOT NULL COMMENT 'Primary key for SalesTerritory records.',
  CountryRegionName VARCHAR(100) CHARACTER SET utf8mb4 NOT NULL COMMENT 'Country or region name.',
  StateProvinceName VARCHAR(100) CHARACTER SET utf8mb4 NOT NULL COMMENT 'State or province description.'
);

-- Tabla de Hechos Fact_Ventas
CREATE TABLE Fact_Ventas (
  Ventas_key INT PRIMARY KEY AUTO_INCREMENT,
  Cliente_key INT,
  Producto_key INT,
  Tiempo_key INT,
  Territory_key INT,
  Valor DECIMAL(10,2),
  Costo DECIMAL(10,2),
  Ganancia DECIMAL(10,2),
  Descuentos DECIMAL(10,2),
  Cantidad INT,

  FOREIGN KEY (Cliente_key) REFERENCES Dim_Cliente(Cliente_key),
  FOREIGN KEY (Producto_key) REFERENCES Dim_Product(Product_key),
  FOREIGN KEY (Tiempo_key) REFERENCES Dim_Tiempo(Tiempo_key),
  FOREIGN KEY (Territory_key) REFERENCES Dim_Territory(Territory_key)
);
