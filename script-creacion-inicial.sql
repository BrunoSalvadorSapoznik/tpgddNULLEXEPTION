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

SELECT @DropTables += 'DROP TABLE [NULL_EXEPTION]. ' + QUOTENAME(TABLE_NAME)

FROM INFORMATION_SCHEMA.TABLES

WHERE TABLE_SCHEMA = 'NULL_EXEPTION' and TABLE_TYPE = 'BASE TABLE'

EXECUTE sp_executesql @DropTables

PRINT '**** dropeo de tablas hecho con exito ****'

GO

IF EXISTS(SELECT name FROM sys.schemas WHERE name = 'NULL_EXEPTION')
DROP SCHEMA NULL_EXEPTION
GO

--CREACIÓN DE SCHEMA--------------------------------
CREATE SCHEMA NULL_EXEPTION;
GO

print '**** SCHEMA creado correctamente ****';

GO

--CREACIÓN DE TABLAS--------------------------------

CREATE TABLE [NULL_EXEPTION].[Provincia] 
(
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);


CREATE TABLE [NULL_EXEPTION].[Localidad] 
(
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    provincia_id BIGINT,
    FOREIGN KEY (provincia_id) REFERENCES [NULL_EXEPTION].Provincia(id)
);


CREATE TABLE [NULL_EXEPTION].[Sucursal] 
(
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    localidad_id BIGINT,
    dirección VARCHAR(255),
    teléfono VARCHAR(50),
    mail VARCHAR(255),
    FOREIGN KEY (localidad_id) REFERENCES [NULL_EXEPTION].Localidad(id)
);


CREATE TABLE [NULL_EXEPTION].[Cliente] 
(
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    apellido VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    teléfono VARCHAR(50),
    localidad_id BIGINT,
    dni VARCHAR(50),
    fecha_nacimiento DATE,
    FOREIGN KEY (localidad_id) REFERENCES [NULL_EXEPTION].Localidad(id)
);


CREATE TABLE [NULL_EXEPTION].[Pedido] 
(
    id BIGINT PRIMARY KEY,
    sucursal_id BIGINT,
    cliente_id BIGINT,
    fecha_hora DATETIME,
    precio_total DECIMAL,
    FOREIGN KEY (sucursal_id) REFERENCES [NULL_EXEPTION].Sucursal(id),
    FOREIGN KEY (cliente_id) REFERENCES [NULL_EXEPTION].Cliente(id)
);


CREATE TABLE [NULL_EXEPTION].[Medida] 
(
    id BIGINT PRIMARY KEY,
    lar DECIMAL,
    profundidad DECIMAL,
    alto DECIMAL,
    precio DECIMAL
);


CREATE TABLE [NULL_EXEPTION].[Modelo] 
(
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    precio_base DECIMAL,
    descripción TEXT
);


CREATE TABLE [NULL_EXEPTION].[Sillon] 
(
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    modelo_id BIGINT,
    medida_id BIGINT,
    FOREIGN KEY (modelo_id) REFERENCES [NULL_EXEPTION].Modelo(id),
    FOREIGN KEY (medida_id) REFERENCES [NULL_EXEPTION].Medida(id)
);


CREATE TABLE [NULL_EXEPTION].[DetallePedido] 
(
    id BIGINT PRIMARY KEY,
    pedido_id BIGINT,
    sillon_id BIGINT,
    cantidad BIGINT,
    precio_unitario DECIMAL,
    sub_total DECIMAL,
    FOREIGN KEY (pedido_id) REFERENCES [NULL_EXEPTION].Pedido(id),
    FOREIGN KEY (sillon_id) REFERENCES [NULL_EXEPTION].Sillon(id)
);


CREATE TABLE [NULL_EXEPTION].[DetalleFactura] 
(
    id BIGINT PRIMARY KEY,
    detalle_ped_id BIGINT,
    sucursal_id BIGINT,
    cliente_id BIGINT,
    cantidad BIGINT,
    precio_unitario DECIMAL,
    subtotal DECIMAL,
    FOREIGN KEY (detalle_ped_id) REFERENCES [NULL_EXEPTION].DetallePedido(id),
    FOREIGN KEY (sucursal_id) REFERENCES [NULL_EXEPTION].Sucursal(id),
    FOREIGN KEY (cliente_id) REFERENCES [NULL_EXEPTION].Cliente(id)
);


CREATE TABLE [NULL_EXEPTION].[Factura] 
(
    nroFactura BIGINT PRIMARY KEY,
    sucursal_id BIGINT,
    cliente_id BIGINT,
    fecha_hora DATETIME,
    precio_total DECIMAL,
    pedido_id BIGINT,
    FOREIGN KEY (sucursal_id) REFERENCES [NULL_EXEPTION].Sucursal(id),
    FOREIGN KEY (cliente_id) REFERENCES [NULL_EXEPTION].Cliente(id),
    FOREIGN KEY (pedido_id) REFERENCES [NULL_EXEPTION].Pedido(id)
);


CREATE TABLE [NULL_EXEPTION].[Envio] 
(
    id BIGINT PRIMARY KEY,
    factura_id BIGINT,
    fecha_programada DATETIME,
    fecha_entrega DATETIME,
    importe_traslado DECIMAL,
    importe_subida DECIMAL,
    total DECIMAL,
    FOREIGN KEY (factura_id) REFERENCES [NULL_EXEPTION].Factura(nroFactura)
);


CREATE TABLE [NULL_EXEPTION].[Estado] 
(
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);


CREATE TABLE [NULL_EXEPTION].[Estado_X_Pedido] 
(
    id_estado BIGINT PRIMARY KEY,
    id_pedido BIGINT PRIMARY KEY,
    fecha_hora DATETIME,
    motivo TEXT,
    FOREIGN KEY (id_estado) REFERENCES [NULL_EXEPTION].Estado(id),
    FOREIGN KEY (id_pedido) REFERENCES [NULL_EXEPTION].Pedido(id)
);


CREATE TABLE [NULL_EXEPTION].[Textura] 
(
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);


CREATE TABLE [NULL_EXEPTION].[Color] 
(
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);


CREATE TABLE [NULL_EXEPTION].[Dureza] 
(
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);


CREATE TABLE [NULL_EXEPTION].[Densidad] 
(
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);


CREATE TABLE [NULL_EXEPTION].[Material] 
(
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    precio_base DECIMAL,
    tipo_id BIGINT,
    descripción TEXT,
);


CREATE TABLE [NULL_EXEPTION].[Tela] 
(
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    color_id BIGINT,
    textura_id BIGINT,
    disponible BOOLEAN,
    FOREIGN KEY (color_id) REFERENCES [NULL_EXEPTION].Color(id),
    FOREIGN KEY (textura_id) REFERENCES [NULL_EXEPTION].Textura(id)
);


CREATE TABLE [NULL_EXEPTION].[Madera] 
(
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    color_id BIGINT,
    dureza_id BIGINT,
    disponible BOOLEAN,
    FOREIGN KEY (color_id) REFERENCES [NULL_EXEPTION].Color(id),
    FOREIGN KEY (dureza_id) REFERENCES [NULL_EXEPTION].Dureza(id)
);


CREATE TABLE [NULL_EXEPTION].[Relleno] 
(
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    densidad_id BIGINT,
    disponible BOOLEAN,
    FOREIGN KEY (densidad_id) REFERENCES [NULL_EXEPTION].Densidad(id)
);

CREATE TABLE [NULL_EXEPTION].[RazonSocial] 
(
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);

CREATE TABLE [NULL_EXEPTION].[Proveedor] 
(
    id BIGINT PRIMARY KEY,
    localidad_id BIGINT,
    razon_social_id BIGINT,
    cuit VARCHAR(50),
    dirección VARCHAR(255),
    teléfono VARCHAR(50),
    mail VARCHAR(255),
    FOREIGN KEY (localidad_id) REFERENCES [NULL_EXEPTION].Localidad(id),
    FOREIGN KEY (razon_social_id) REFERENCES [NULL_EXEPTION].RazonSocial(id)
);


CREATE TABLE [NULL_EXEPTION].[Compra] 
(
    id BIGINT PRIMARY KEY,
    id_sucursal BIGINT,
    id_proveedor BIGINT,
    fecha DATETIME,
    total DECIMAL,
    FOREIGN KEY (id_sucursal) REFERENCES [NULL_EXEPTION].Sucursal(id),
    FOREIGN KEY (id_proveedor) REFERENCES [NULL_EXEPTION].Proveedor(id)
);


CREATE TABLE [NULL_EXEPTION].[DetalleCompra] 
(
    id BIGINT PRIMARY KEY,
    id_compra BIGINT,
    id_material BIGINT,
    precio_unitario DECIMAL,
    cantidad DECIMAL,
    subtotal DECIMAL,
    FOREIGN KEY (id_compra) REFERENCES [NULL_EXEPTION].Compra(id),
    FOREIGN KEY (id_material) REFERENCES [NULL_EXEPTION].Material(id)
);


print '**** Tablas creadas correctamente ****';

GO





