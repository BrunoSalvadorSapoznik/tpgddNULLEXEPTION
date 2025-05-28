/* creacion migracion */
 USE [GD1C2025]
GO

PRINT ' comenzar migracion'

GO

--DROPS
--drop de FKs
DECLARE @DropConstraints NVARCHAR(MAX) = ''

SELECT @DropConstraints += 'ALTER TABLE' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + ''
                        + QUOTENAME(OBJECT_NAME(parent_object_id)) + ' ' + 'DROP CONSTRAINT' + QUOTENAME(name)

FROM sys.foreign_keys
/*
-name: nombre de la FK
-parent_object_id: ID del objeto (tabla) que tiene la FK

ALTER TABLE [NO_SE_BAJA_NADIE].[Ventas] DROP CONSTRAINT [FK_Ventas_Clientes];
*/
EXECUTE sp_executesql @DroptConstraints;

PRINT '**** dropeo de constraints hecho con exito ****';

GO

--drop de tablas
DECLARE @DropTables NVARCHAR(MAX) = ''

SELECT @DropTables += 'DROP TABLE NULL_EXEPTION. ' + QUOTENAME(TABLE_NAME)

FROM INFORMATION_SCHEMA.TABLES

WHERE TABLE_SCHEMA = 'NULL_EXEPTION' and TABLE_TYPE = 'BASE TABLE'

EXECUTE sp_executesql @DropTables

PRINT '**** dropeo de tablas hecho con exito ****'

GO

IF EXISTS(SELECT name FROM sys.schemas WHERE name = 'NULL_EXEPTION')
DROP SCHEMA NULL_EXEPTION
GO

--Creacion de esquema---------------
CREATE SCHEMA NULL_EXEPTION;
GO

CREATE TABLE NULL_EXEPTION.Pedido (
    id BIGINT PRIMARY KEY,
    sucursal_id BIGINT FOREIGN KEY REFERENCES NULL_EXEPTION.Sucursal(id),
    cliente_id BIGINT FOREIGN KEY REFERENCES NULL_EXEPTION.Cliente(id),
    fecha_hora DATETIME,
    precio_total FLOAT
);
GO

CREATE TABLE NULL_EXEPTION.DetallePedido (
    id BIGINT PRIMARY KEY,
    pedido_id BIGINT FOREIGN KEY REFERENCES NULL_EXEPTION.Pedido(id),
    sillon_id BIGINT FOREIGN KEY REFERENCES NULL_EXEPTION.Sillon(id),
    cantidad BIGINT,
    precio_unitario FLOAT,
    sub_total FLOAT
);
GO

CREATE TABLE NULL_EXEPTION.Sucursal (
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(255),
    localidad_id BIGINT FOREIGN KEY REFERENCES NULL_EXEPTION.Localidad(id),
    direccion VARCHAR(255),
    telefono VARCHAR(50),
    mail VARCHAR(255)
);
GO

CREATE TABLE NULL_EXEPTION.Localidad (
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(255),
    provincia_id BIGINT FOREIGN KEY REFERENCES NULL_EXEPTION.Provincia(id)
);
GO

CREATE TABLE NULL_EXEPTION.Provincia (
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(255)
);
GO

CREATE TABLE NULL_EXEPTION.Cliente (
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(255),
    apellido VARCHAR(255),
    email VARCHAR(255),
    telefono VARCHAR(50),
    localidad_id BIGINT FOREIGN KEY REFERENCES NULL_EXEPTION.Localidad(id),
    dni VARCHAR(50),
    fecha_nacimiento DATE
);
GO

CREATE TABLE NULL_EXEPTION.DetalleFactura (
    id BIGINT PRIMARY KEY,
    detalle_ped_id BIGINT FOREIGN KEY REFERENCES NULL_EXEPTION.DetallePedido(id),
    sucursal_id BIGINT FOREIGN KEY REFERENCES NULL_EXEPTION.Sucursal(id),
    cliente_id BIGINT FOREIGN KEY REFERENCES NULL_EXEPTION.Cliente(id),
    cantidad BIGINT,
    precio_unitario FLOAT,
    subtotal FLOAT
);
GO

CREATE TABLE NULL_EXEPTION.Envio (
    id BIGINT PRIMARY KEY,
    factura_id BIGINT FOREIGN KEY REFERENCES NULL_EXEPTION.Factura(nroFactura),
    fecha_programada DATETIME,
    fecha_entrega DATETIME,
    importe_traslado FLOAT,
    importe_subida FLOAT,
    total FLOAT
);
GO

CREATE TABLE NULL_EXEPTION.Factura (
    nroFactura BIGINT PRIMARY KEY,
    sucursal_id BIGINT FOREIGN KEY REFERENCES NULL_EXEPTION.Sucursal(id),
    cliente_id BIGINT FOREIGN KEY REFERENCES NULL_EXEPTION.Cliente(id),
    fecha_hora DATETIME,
    precio_total FLOAT,
    pedido_id BIGINT FOREIGN KEY REFERENCES NULL_EXEPTION.Pedido(id)
);
GO

CREATE TABLE NULL_EXEPTION.Estado (
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(255)
);
GO

CREATE TABLE NULL_EXEPTION.Estado_X_Pedido (
    id_estado BIGINT FOREIGN KEY REFERENCES NULL_EXEPTION.Estado(id),
    id_pedido BIGINT FOREIGN KEY REFERENCES NULL_EXEPTION.Pedido(id),
    fecha_hora DATETIME,
    motivo TEXT
);
GO

CREATE TABLE NULL_EXEPTION.Medida (
    id BIGINT PRIMARY KEY,
    largo FLOAT,
    profundidad FLOAT,
    alto FLOAT,
    precio FLOAT
);
GO

CREATE TABLE NULL_EXEPTION.Sillon (
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(255),
    modelo_id BIGINT FOREIGN KEY REFERENCES NULL_EXEPTION.Modelo(id),
    medida_id BIGINT FOREIGN KEY REFERENCES NULL_EXEPTION.Medida(id)
);
GO

CREATE TABLE NULL_EXEPTION.Modelo (
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(255),
    precio_base FLOAT,
    descripcion TEXT
);
GO

CREATE TABLE NULL_EXEPTION.Material (
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(255),
    precio_base FLOAT,
    tipo_id BIGINT FOREIGN KEY REFERENCES NULL_EXEPTION.Tipo(id),
    descripcion TEXT
);
GO

CREATE TABLE NULL_EXEPTION.Tela (
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(255),
    color_id BIGINT FOREIGN KEY REFERENCES NULL_EXEPTION.Color(id),
    textura_id BIGINT FOREIGN KEY REFERENCES NULL_EXEPTION.Textura(id),
    disponible BOOLEAN
);
GO

CREATE TABLE NULL_EXEPTION.Madera (
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(255),
    color_id BIGINT FOREIGN KEY REFERENCES NULL_EXEPTION.Color(id),
    dureza_id BIGINT FOREIGN KEY REFERENCES NULL_EXEPTION.Dureza(id),
    disponible BOOLEAN
);
GO

CREATE TABLE NULL_EXEPTION.Relleno (
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(255),
    densidad_id BIGINT FOREIGN KEY REFERENCES NULL_EXEPTION.Densidad(id),
    disponible BOOLEAN
);
GO

CREATE TABLE NULL_EXEPTION.Textura (
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(255)
);
GO

CREATE TABLE NULL_EXEPTION.Color (
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(255)
);
GO

CREATE TABLE NULL_EXEPTION.Dureza (
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(255)
);
GO

CREATE TABLE NULL_EXEPTION.Densidad (
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(255)
);
GO

CREATE TABLE NULL_EXEPTION.DetalleCompra (
    id BIGINT PRIMARY KEY,
    id_compra BIGINT FOREIGN KEY REFERENCES NULL_EXEPTION.Compra(id),
    id_material BIGINT FOREIGN KEY REFERENCES NULL_EXEPTION.Material(id),
    precio_unitario FLOAT,
    cantidad FLOAT,
    subtotal FLOAT
);
GO

CREATE TABLE NULL_EXEPTION.Compra (
    id BIGINT PRIMARY KEY,
    id_sucursal BIGINT FOREIGN KEY REFERENCES NULL_EXEPTION.Sucursal(id),
    id_proveedor BIGINT FOREIGN KEY REFERENCES NULL_EXEPTION.Proveedor(id),
    fecha DATETIME,
    total FLOAT
);
GO

CREATE TABLE NULL_EXEPTION.Proveedor (
    id BIGINT PRIMARY KEY,
    localidad_id BIGINT FOREIGN KEY REFERENCES NULL_EXEPTION.Localidad(id),
    razon_social_id BIGINT FOREIGN KEY REFERENCES NULL_EXEPTION.RazonSocial(id),
    cuit VARCHAR(50),
    direccion VARCHAR(255),
    telefono VARCHAR(50),
    mail VARCHAR(255)
);
GO







