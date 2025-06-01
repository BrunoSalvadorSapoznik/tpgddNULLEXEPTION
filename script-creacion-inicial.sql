/* creacion migracion */
USE [GD1C2025]
GO

PRINT 'comenzar migracion'
GO

--DROPS
--drop de FKs
DECLARE @DropConstraints NVARCHAR(MAX) = N''

SELECT @DropConstraints += 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.' 
                         + QUOTENAME(OBJECT_NAME(parent_object_id)) + ' ' + 'DROP CONSTRAINT ' + QUOTENAME(name) + ';' + CHAR(13) 
FROM sys.foreign_keys


IF @DropConstraints <> N''
    EXECUTE sp_executesql @DropConstraints; 

PRINT '**** dropeo de constraints hecho con exito ****';
GO

--drop de tablas
DECLARE @DropTables NVARCHAR(MAX) = N''

SELECT @DropTables += 'DROP TABLE ' + QUOTENAME(TABLE_SCHEMA) + '.' + QUOTENAME(TABLE_NAME) + ';' + CHAR(13) 
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'NULL_EXEPTION' and TABLE_TYPE = 'BASE TABLE'


IF @DropTables <> N''
    EXECUTE sp_executesql @DropTables

PRINT '**** dropeo de tablas hecho con exito ****'
GO

IF EXISTS (SELECT * FROM sys.procedures WHERE object_id = OBJECT_ID('[NULL_EXEPTION].Migrar_Provincia'))
    DROP PROCEDURE [NULL_EXEPTION].Migrar_Provincia;

IF EXISTS (SELECT * FROM sys.procedures WHERE object_id = OBJECT_ID('[NULL_EXEPTION].Migrar_Localidad'))
    DROP PROCEDURE [NULL_EXEPTION].Migrar_Localidad;

IF EXISTS (SELECT * FROM sys.procedures WHERE object_id = OBJECT_ID('[NULL_EXEPTION].Migrar_Sucursal'))
    DROP PROCEDURE [NULL_EXEPTION].Migrar_Sucursal;

IF EXISTS (SELECT * FROM sys.procedures WHERE object_id = OBJECT_ID('[NULL_EXEPTION].Migrar_Cliente'))
    DROP PROCEDURE [NULL_EXEPTION].Migrar_Cliente;

IF EXISTS (SELECT * FROM sys.procedures WHERE object_id = OBJECT_ID('[NULL_EXEPTION].Migrar_Modelo'))
    DROP PROCEDURE [NULL_EXEPTION].Migrar_Modelo;

IF EXISTS (SELECT * FROM sys.procedures WHERE object_id = OBJECT_ID('[NULL_EXEPTION].Migrar_Medida'))
    DROP PROCEDURE [NULL_EXEPTION].Migrar_Medida;

IF EXISTS (SELECT * FROM sys.procedures WHERE object_id = OBJECT_ID('[NULL_EXEPTION].Migrar_Sillon'))
    DROP PROCEDURE [NULL_EXEPTION].Migrar_Sillon;

IF EXISTS (SELECT * FROM sys.procedures WHERE object_id = OBJECT_ID('[NULL_EXEPTION].Migrar_Pedido'))
    DROP PROCEDURE [NULL_EXEPTION].Migrar_Pedido;

IF EXISTS (SELECT * FROM sys.procedures WHERE object_id = OBJECT_ID('[NULL_EXEPTION].Migrar_DetallePedido'))
    DROP PROCEDURE [NULL_EXEPTION].Migrar_DetallePedido;

IF EXISTS (SELECT * FROM sys.procedures WHERE object_id = OBJECT_ID('[NULL_EXEPTION].Migrar_Estado'))
    DROP PROCEDURE [NULL_EXEPTION].Migrar_Estado;

IF EXISTS (SELECT * FROM sys.procedures WHERE object_id = OBJECT_ID('[NULL_EXEPTION].Migrar_Estado_X_Pedido'))
    DROP PROCEDURE [NULL_EXEPTION].Migrar_Estado_X_Pedido;

IF EXISTS (SELECT * FROM sys.procedures WHERE object_id = OBJECT_ID('[NULL_EXEPTION].Migrar_Factura'))
    DROP PROCEDURE [NULL_EXEPTION].Migrar_Factura;

IF EXISTS (SELECT * FROM sys.procedures WHERE object_id = OBJECT_ID('[NULL_EXEPTION].Migrar_DetalleFactura'))
    DROP PROCEDURE [NULL_EXEPTION].Migrar_DetalleFactura;

IF EXISTS (SELECT * FROM sys.procedures WHERE object_id = OBJECT_ID('[NULL_EXEPTION].Migrar_Envio'))
    DROP PROCEDURE [NULL_EXEPTION].Migrar_Envio;

IF EXISTS (SELECT * FROM sys.procedures WHERE object_id = OBJECT_ID('[NULL_EXEPTION].Migrar_Color'))
    DROP PROCEDURE [NULL_EXEPTION].Migrar_Color;

IF EXISTS (SELECT * FROM sys.procedures WHERE object_id = OBJECT_ID('[NULL_EXEPTION].Migrar_Textura'))
    DROP PROCEDURE [NULL_EXEPTION].Migrar_Textura;

IF EXISTS (SELECT * FROM sys.procedures WHERE object_id = OBJECT_ID('[NULL_EXEPTION].Migrar_Dureza'))
    DROP PROCEDURE [NULL_EXEPTION].Migrar_Dureza;

IF EXISTS (SELECT * FROM sys.procedures WHERE object_id = OBJECT_ID('[NULL_EXEPTION].Migrar_Densidad'))
    DROP PROCEDURE [NULL_EXEPTION].Migrar_Densidad;

IF EXISTS (SELECT * FROM sys.procedures WHERE object_id = OBJECT_ID('[NULL_EXEPTION].Migrar_Tela'))
    DROP PROCEDURE [NULL_EXEPTION].Migrar_Tela;

IF EXISTS (SELECT * FROM sys.procedures WHERE object_id = OBJECT_ID('[NULL_EXEPTION].Migrar_Madera'))
    DROP PROCEDURE [NULL_EXEPTION].Migrar_Madera;

IF EXISTS (SELECT * FROM sys.procedures WHERE object_id = OBJECT_ID('[NULL_EXEPTION].Migrar_Relleno'))
    DROP PROCEDURE [NULL_EXEPTION].Migrar_Relleno;

IF EXISTS (SELECT * FROM sys.procedures WHERE object_id = OBJECT_ID('[NULL_EXEPTION].Migrar_Material'))
    DROP PROCEDURE [NULL_EXEPTION].Migrar_Material;

IF EXISTS (SELECT * FROM sys.procedures WHERE object_id = OBJECT_ID('[NULL_EXEPTION].Migrar_Proveedor'))
    DROP PROCEDURE [NULL_EXEPTION].Migrar_Proveedor;

IF EXISTS (SELECT * FROM sys.procedures WHERE object_id = OBJECT_ID('[NULL_EXEPTION].Migrar_Compra'))
    DROP PROCEDURE [NULL_EXEPTION].Migrar_Compra;

IF EXISTS (SELECT * FROM sys.procedures WHERE object_id = OBJECT_ID('[NULL_EXEPTION].Migrar_DetalleCompra'))
    DROP PROCEDURE [NULL_EXEPTION].Migrar_DetalleCompra;

IF EXISTS (SELECT * FROM sys.procedures WHERE object_id = OBJECT_ID('[NULL_EXEPTION].Migrar_Sillon_X_Material'))
    DROP PROCEDURE [NULL_EXEPTION].Migrar_Sillon_X_Material;

IF EXISTS(SELECT name FROM sys.schemas WHERE name = 'NULL_EXEPTION')
BEGIN
    DROP SCHEMA NULL_EXEPTION
    PRINT '**** SCHEMA NULL_EXEPTION eliminado ****';
END
GO

--CREACIoN DE SCHEMA--------------------------------
CREATE SCHEMA NULL_EXEPTION;
GO

PRINT '**** SCHEMA NULL_EXEPTION creado correctamente ****';
GO

--CREACIoN DE TABLAS--------------------------------

/* PROVINCA */
CREATE TABLE [NULL_EXEPTION].[Provincia]
(
    [id] BIGINT NOT NULL IDENTITY,
    [nombre] NVARCHAR(255) NOT NULL
);

/* LOCALIDAD */
CREATE TABLE [NULL_EXEPTION].[Localidad]
(
    [id] BIGINT NOT NULL IDENTITY,
    [nombre] NVARCHAR(255) NOT NULL,
    [provincia_id] BIGINT
);

/* SUCURSAL */
CREATE TABLE [NULL_EXEPTION].[Sucursal]
(
    [id] BIGINT NOT NULL IDENTITY,
    [nombre] NVARCHAR(255) NOT NULL,
    [localidad_id] BIGINT,
    [direccion] NVARCHAR(255),
    [telefono] NVARCHAR(50),
    [mail] NVARCHAR(255)
);

/* CLIENTE */
CREATE TABLE [NULL_EXEPTION].[Cliente]
(
    [id] BIGINT NOT NULL IDENTITY,
    [nombre] NVARCHAR(255) NOT NULL,
    [apellido] NVARCHAR(255) NOT NULL,
    [email] NVARCHAR(255),
    [telefono] NVARCHAR(50),
    [localidad_id] BIGINT,
    [dni] NVARCHAR(50),
    [fecha_nacimiento] DATE
);

/* PEDIDO */
CREATE TABLE [NULL_EXEPTION].[Pedido]
(
    [id] BIGINT NOT NULL, 
    [sucursal_id] BIGINT,
    [cliente_id] BIGINT,
    [fecha_hora] DATETIME,
    [precio_total] DECIMAL(18,2) 
);

/* MEDIDA */
CREATE TABLE [NULL_EXEPTION].[Medida]
(
    [id] BIGINT NOT NULL IDENTITY,
    [largo] DECIMAL(18,2),
    [profundidad] DECIMAL(18,2),
    [alto] DECIMAL(18,2),
    [precio] DECIMAL(18,2)
);

/* MODELO */
CREATE TABLE [NULL_EXEPTION].[Modelo]
(
    [id] BIGINT NOT NULL IDENTITY,
    [nombre] NVARCHAR(255) NOT NULL,
    [precio_base] DECIMAL(18,2),
    [descripcion] NVARCHAR(MAX) 
);

/* SILLON */
CREATE TABLE [NULL_EXEPTION].[Sillon]
(
    [id] BIGINT NOT NULL IDENTITY,
    [nombre] NVARCHAR(255) NOT NULL,
    [modelo_id] BIGINT,
    [medida_id] BIGINT
);

/* DETALLE_PEDIDO */
CREATE TABLE [NULL_EXEPTION].[DetallePedido]
(
    [id] BIGINT NOT NULL IDENTITY,
    [pedido_id] BIGINT,
    [sillon_id] BIGINT,
    [cantidad] BIGINT,
    [precio_unitario] DECIMAL(18,2),
    [subtotal] DECIMAL(18,2)
);

/* DETALLE_FACTURA */
CREATE TABLE [NULL_EXEPTION].[DetalleFactura]
(
    [id] BIGINT NOT NULL IDENTITY,
    [detalle_ped_id] BIGINT,
    [factura_id] BIGINT,
    [cantidad] BIGINT,
    [precio_unitario] DECIMAL(18,2),
    [subtotal] DECIMAL(18,2)
);

/* FACTURA */
CREATE TABLE [NULL_EXEPTION].[Factura]
(
    [id] BIGINT NOT NULL, 
    [sucursal_id] BIGINT,
    [cliente_id] BIGINT,
    [fecha_hora] DATETIME,
    [precio_total] DECIMAL(18,2),
    [pedido_id] BIGINT
);

/* ENVIO */
CREATE TABLE [NULL_EXEPTION].[Envio]
(
    [id] BIGINT NOT NULL, 
    [factura_id] BIGINT,
    [fecha_programada] DATETIME,
    [fecha_entrega] DATETIME,
    [importe_traslado] DECIMAL(18,2),
    [importe_subida] DECIMAL(18,2),
    [total] DECIMAL(18,2)
);

/* ESTADO */
CREATE TABLE [NULL_EXEPTION].[Estado]
(
    [id] BIGINT NOT NULL IDENTITY,
    [nombre] NVARCHAR(255) NOT NULL
);

/* ESTADO_X_PEDIDO */
CREATE TABLE [NULL_EXEPTION].[Estado_X_Pedido]
(
    [estado_id] BIGINT NOT NULL,
    [pedido_id] BIGINT NOT NULL,
    [fecha_hora] DATETIME NOT NULL,
    [motivo] NVARCHAR(MAX) 
);

/* TEXTURA */
CREATE TABLE [NULL_EXEPTION].[Textura]
(
    [id] BIGINT NOT NULL IDENTITY,
    [nombre] NVARCHAR(255) NOT NULL
);

/* COLOR */
CREATE TABLE [NULL_EXEPTION].[Color]
(
    [id] BIGINT NOT NULL IDENTITY,
    [nombre] NVARCHAR(255) NOT NULL
);

/* DUREZA */
CREATE TABLE [NULL_EXEPTION].[Dureza]
(
    [id] BIGINT NOT NULL IDENTITY,
    [nombre] NVARCHAR(255) NOT NULL
);

/* DENSIDAD */
CREATE TABLE [NULL_EXEPTION].[Densidad]
(
    [id] BIGINT NOT NULL IDENTITY,
    [nombre] NVARCHAR(255) NOT NULL
);

/* MATERIAL */
CREATE TABLE [NULL_EXEPTION].[Material]
(
    [id] BIGINT NOT NULL IDENTITY,
    [nombre] NVARCHAR(255) NOT NULL,
    [precio_base] DECIMAL(18,2),
    [tela_id] BIGINT,
    [madera_id] BIGINT,
    [relleno_id] BIGINT,
    [descripcion] NVARCHAR(MAX)
);

/* TELA */
CREATE TABLE [NULL_EXEPTION].[Tela]
(
    [id] BIGINT NOT NULL IDENTITY,
    [nombre] NVARCHAR(255) NOT NULL,
    [color_id] BIGINT,
    [textura_id] BIGINT,
    [disponible] BIT 
);

/* MADERA */
CREATE TABLE [NULL_EXEPTION].[Madera]
(
    [id] BIGINT NOT NULL IDENTITY,
    [nombre] NVARCHAR(255) NOT NULL,
    [color_id] BIGINT,
    [dureza_id] BIGINT,
    [disponible] BIT
);

/* RELLENO */
CREATE TABLE [NULL_EXEPTION].[Relleno]
(
    [id] BIGINT NOT NULL IDENTITY,
    [nombre] NVARCHAR(255) NOT NULL,
    [densidad_id] BIGINT,
    [disponible] BIT
);

/* PROVEEDOR */
CREATE TABLE [NULL_EXEPTION].[Proveedor]
(
    [id] BIGINT NOT NULL IDENTITY,
    [localidad_id] BIGINT,
    [razon_social_id] NVARCHAR(255), 
    [cuit] NVARCHAR(50),
    [direccion] NVARCHAR(255),
    [telefono] NVARCHAR(50),
    [mail] NVARCHAR(255)
);

/* COMPRA */
CREATE TABLE [NULL_EXEPTION].[Compra]
(
    [id] BIGINT NOT NULL, 
    [sucursal_id] BIGINT,
    [proveedor_id] BIGINT,
    [fecha] DATETIME,
    [total] DECIMAL(18,2)
);

/* DETALLE_COMPRA */
CREATE TABLE [NULL_EXEPTION].[DetalleCompra]
(
    [id] BIGINT NOT NULL IDENTITY,
    [compra_id] BIGINT,
    [material_id] BIGINT,
    [precio_unitario] DECIMAL(18,2),
    [cantidad] DECIMAL(18,3), 
    [subtotal] DECIMAL(18,2)
);

/* SILLON_X_MATERIAL */
CREATE TABLE [NULL_EXEPTION].[Sillon_X_Material]
(
    [id] BIGINT NOT NULL IDENTITY,
    [sillon_id] BIGINT,
    [material_id] BIGINT
);


/* CONSTRAINT GENERATION - PRIMARY KEYS */

ALTER TABLE [NULL_EXEPTION].[Provincia]
    ADD CONSTRAINT [PK_Provincia] PRIMARY KEY CLUSTERED ([id] ASC);

ALTER TABLE [NULL_EXEPTION].[Localidad]
    ADD CONSTRAINT [PK_Localidad] PRIMARY KEY CLUSTERED ([id] ASC);

ALTER TABLE [NULL_EXEPTION].[Sucursal]
    ADD CONSTRAINT [PK_Sucursal] PRIMARY KEY CLUSTERED ([id] ASC);

ALTER TABLE [NULL_EXEPTION].[Cliente]
    ADD CONSTRAINT [PK_Cliente] PRIMARY KEY CLUSTERED ([id] ASC);

ALTER TABLE [NULL_EXEPTION].[Pedido]
    ADD CONSTRAINT [PK_Pedido] PRIMARY KEY CLUSTERED ([id] ASC);

ALTER TABLE [NULL_EXEPTION].[Medida]
    ADD CONSTRAINT [PK_Medida] PRIMARY KEY CLUSTERED ([id] ASC);

ALTER TABLE [NULL_EXEPTION].[Modelo]
    ADD CONSTRAINT [PK_Modelo] PRIMARY KEY CLUSTERED ([id] ASC);

ALTER TABLE [NULL_EXEPTION].[Sillon]
    ADD CONSTRAINT [PK_Sillon] PRIMARY KEY CLUSTERED ([id] ASC);

ALTER TABLE [NULL_EXEPTION].[DetallePedido]
    ADD CONSTRAINT [PK_DetallePedido] PRIMARY KEY CLUSTERED ([id] ASC);

ALTER TABLE [NULL_EXEPTION].[DetalleFactura]
    ADD CONSTRAINT [PK_DetalleFactura] PRIMARY KEY CLUSTERED ([id] ASC);

ALTER TABLE [NULL_EXEPTION].[Factura]
    ADD CONSTRAINT [PK_Factura] PRIMARY KEY CLUSTERED ([id] ASC);

ALTER TABLE [NULL_EXEPTION].[Envio]
    ADD CONSTRAINT [PK_Envio] PRIMARY KEY CLUSTERED ([id] ASC);

ALTER TABLE [NULL_EXEPTION].[Estado]
    ADD CONSTRAINT [PK_Estado] PRIMARY KEY CLUSTERED ([id] ASC);

ALTER TABLE [NULL_EXEPTION].[Estado_X_Pedido]
ADD CONSTRAINT [PK_Estado_X_Pedido] PRIMARY KEY CLUSTERED ([estado_id], [pedido_id]);

ALTER TABLE [NULL_EXEPTION].[Textura]
    ADD CONSTRAINT [PK_Textura] PRIMARY KEY CLUSTERED ([id] ASC);

ALTER TABLE [NULL_EXEPTION].[Color]
    ADD CONSTRAINT [PK_Color] PRIMARY KEY CLUSTERED ([id] ASC);

ALTER TABLE [NULL_EXEPTION].[Dureza]
    ADD CONSTRAINT [PK_Dureza] PRIMARY KEY CLUSTERED ([id] ASC);

ALTER TABLE [NULL_EXEPTION].[Densidad]
    ADD CONSTRAINT [PK_Densidad] PRIMARY KEY CLUSTERED ([id] ASC);

ALTER TABLE [NULL_EXEPTION].[Material]
    ADD CONSTRAINT [PK_Material] PRIMARY KEY CLUSTERED ([id] ASC);

ALTER TABLE [NULL_EXEPTION].[Tela]
    ADD CONSTRAINT [PK_Tela] PRIMARY KEY CLUSTERED ([id] ASC);

ALTER TABLE [NULL_EXEPTION].[Madera]
    ADD CONSTRAINT [PK_Madera] PRIMARY KEY CLUSTERED ([id] ASC);

ALTER TABLE [NULL_EXEPTION].[Relleno]
    ADD CONSTRAINT [PK_Relleno] PRIMARY KEY CLUSTERED ([id] ASC);

ALTER TABLE [NULL_EXEPTION].[Proveedor]
    ADD CONSTRAINT [PK_Proveedor] PRIMARY KEY CLUSTERED ([id] ASC);

ALTER TABLE [NULL_EXEPTION].[Compra]
    ADD CONSTRAINT [PK_Compra] PRIMARY KEY CLUSTERED ([id] ASC);

ALTER TABLE [NULL_EXEPTION].[DetalleCompra]
    ADD CONSTRAINT [PK_DetalleCompra] PRIMARY KEY CLUSTERED ([id] ASC);

ALTER TABLE [NULL_EXEPTION].[Sillon_X_Material]
    ADD CONSTRAINT [PK_Sillon_X_Material] PRIMARY KEY CLUSTERED ([id] ASC);


/* CONSTRAINT GENERATION - FOREIGN KEYS */

ALTER TABLE [NULL_EXEPTION].[Localidad]
    ADD CONSTRAINT [FK_Localidad_provincia] FOREIGN KEY ([provincia_id])
    REFERENCES [NULL_EXEPTION].[Provincia]([id]);

ALTER TABLE [NULL_EXEPTION].[Sucursal]
    ADD CONSTRAINT [FK_Sucursal_localidad] FOREIGN KEY ([localidad_id])
    REFERENCES [NULL_EXEPTION].[Localidad]([id]);

ALTER TABLE [NULL_EXEPTION].[Cliente]
    ADD CONSTRAINT [FK_Cliente_localidad] FOREIGN KEY ([localidad_id])
    REFERENCES [NULL_EXEPTION].[Localidad]([id]);

ALTER TABLE [NULL_EXEPTION].[Pedido]
    ADD CONSTRAINT [FK_Pedido_sucursal] FOREIGN KEY ([sucursal_id])
    REFERENCES [NULL_EXEPTION].[Sucursal]([id]);

ALTER TABLE [NULL_EXEPTION].[Pedido]
    ADD CONSTRAINT [FK_Pedido_cliente] FOREIGN KEY ([cliente_id])
    REFERENCES [NULL_EXEPTION].[Cliente]([id]);

ALTER TABLE [NULL_EXEPTION].[Sillon]
    ADD CONSTRAINT [FK_Sillon_modelo] FOREIGN KEY ([modelo_id])
    REFERENCES [NULL_EXEPTION].[Modelo]([id]);

ALTER TABLE [NULL_EXEPTION].[Sillon]
    ADD CONSTRAINT [FK_Sillon_medida] FOREIGN KEY ([medida_id])
    REFERENCES [NULL_EXEPTION].[Medida]([id]);

ALTER TABLE [NULL_EXEPTION].[DetallePedido]
    ADD CONSTRAINT [FK_DetallePedido_pedido] FOREIGN KEY ([pedido_id])
    REFERENCES [NULL_EXEPTION].[Pedido]([id]);

ALTER TABLE [NULL_EXEPTION].[DetallePedido]
    ADD CONSTRAINT [FK_DetallePedido_sillon] FOREIGN KEY ([sillon_id])
    REFERENCES [NULL_EXEPTION].[Sillon]([id]);

ALTER TABLE [NULL_EXEPTION].[DetalleFactura]
    ADD CONSTRAINT [FK_DetalleFactura_detalle_pedido] FOREIGN KEY ([detalle_ped_id])
    REFERENCES [NULL_EXEPTION].[DetallePedido]([id]);

ALTER TABLE [NULL_EXEPTION].[DetalleFactura]
    ADD CONSTRAINT [FK_DetalleFactura_factura] FOREIGN KEY ([factura_id])
    REFERENCES [NULL_EXEPTION].[Factura]([id]);

ALTER TABLE [NULL_EXEPTION].[Factura]
    ADD CONSTRAINT [FK_Factura_sucursal] FOREIGN KEY ([sucursal_id])
    REFERENCES [NULL_EXEPTION].[Sucursal]([id]);

ALTER TABLE [NULL_EXEPTION].[Factura]
    ADD CONSTRAINT [FK_Factura_cliente] FOREIGN KEY ([cliente_id])
    REFERENCES [NULL_EXEPTION].[Cliente]([id]);

ALTER TABLE [NULL_EXEPTION].[Factura]
    ADD CONSTRAINT [FK_Factura_pedido] FOREIGN KEY ([pedido_id])
    REFERENCES [NULL_EXEPTION].[Pedido]([id]);

ALTER TABLE [NULL_EXEPTION].[Envio]
    ADD CONSTRAINT [FK_Envio_factura] FOREIGN KEY ([factura_id])
    REFERENCES [NULL_EXEPTION].[Factura]([id]);

ALTER TABLE [NULL_EXEPTION].[Estado_X_Pedido]
    ADD CONSTRAINT [FK_Estado_X_Pedido_estado] FOREIGN KEY ([estado_id])
    REFERENCES [NULL_EXEPTION].[Estado]([id]);

ALTER TABLE [NULL_EXEPTION].[Estado_X_Pedido]
    ADD CONSTRAINT [FK_Estado_X_Pedido_pedido] FOREIGN KEY ([pedido_id])
    REFERENCES [NULL_EXEPTION].[Pedido]([id]);

ALTER TABLE [NULL_EXEPTION].[Material]
    ADD CONSTRAINT [FK_Material_Tela] FOREIGN KEY ([tela_id])
    REFERENCES [NULL_EXEPTION].[Tela]([id]);

ALTER TABLE [NULL_EXEPTION].[Material]
    ADD CONSTRAINT [FK_Material_Madera] FOREIGN KEY ([madera_id])
    REFERENCES [NULL_EXEPTION].[Madera]([id]);

ALTER TABLE [NULL_EXEPTION].[Material]
    ADD CONSTRAINT [FK_Material_Relleno] FOREIGN KEY ([relleno_id])
    REFERENCES [NULL_EXEPTION].[Relleno]([id]);

ALTER TABLE [NULL_EXEPTION].[Tela]
    ADD CONSTRAINT [FK_Tela_color] FOREIGN KEY ([color_id])
    REFERENCES [NULL_EXEPTION].[Color]([id]);

ALTER TABLE [NULL_EXEPTION].[Tela]
    ADD CONSTRAINT [FK_Tela_textura] FOREIGN KEY ([textura_id])
    REFERENCES [NULL_EXEPTION].[Textura]([id]);

ALTER TABLE [NULL_EXEPTION].[Madera]
    ADD CONSTRAINT [FK_Madera_color] FOREIGN KEY ([color_id])
    REFERENCES [NULL_EXEPTION].[Color]([id]);

ALTER TABLE [NULL_EXEPTION].[Madera]
    ADD CONSTRAINT [FK_Madera_dureza] FOREIGN KEY ([dureza_id])
    REFERENCES [NULL_EXEPTION].[Dureza]([id]);

ALTER TABLE [NULL_EXEPTION].[Relleno]
    ADD CONSTRAINT [FK_Relleno_densidad] FOREIGN KEY ([densidad_id])
    REFERENCES [NULL_EXEPTION].[Densidad]([id]);

ALTER TABLE [NULL_EXEPTION].[Proveedor]
    ADD CONSTRAINT [FK_Proveedor_localidad] FOREIGN KEY ([localidad_id])
    REFERENCES [NULL_EXEPTION].[Localidad]([id]);

ALTER TABLE [NULL_EXEPTION].[Compra]
    ADD CONSTRAINT [FK_Compra_sucursal] FOREIGN KEY ([sucursal_id])
    REFERENCES [NULL_EXEPTION].[Sucursal]([id]);

ALTER TABLE [NULL_EXEPTION].[Compra]
    ADD CONSTRAINT [FK_Compra_proveedor] FOREIGN KEY ([proveedor_id])
    REFERENCES [NULL_EXEPTION].[Proveedor]([id]);

ALTER TABLE [NULL_EXEPTION].[DetalleCompra]
    ADD CONSTRAINT [FK_DetalleCompra_compra] FOREIGN KEY ([compra_id])
    REFERENCES [NULL_EXEPTION].[Compra]([id]);

ALTER TABLE [NULL_EXEPTION].[DetalleCompra]
    ADD CONSTRAINT [FK_DetalleCompra_material] FOREIGN KEY ([material_id])
    REFERENCES [NULL_EXEPTION].[Material]([id]);

ALTER TABLE [NULL_EXEPTION].[Sillon_X_Material]
    ADD CONSTRAINT [FK_Sillon_X_Material_sillon] FOREIGN KEY ([sillon_id])
    REFERENCES [NULL_EXEPTION].[Sillon]([id]);

ALTER TABLE [NULL_EXEPTION].[Sillon_X_Material]
    ADD CONSTRAINT [FK_Sillon_X_Material_material] FOREIGN KEY ([material_id])
    REFERENCES [NULL_EXEPTION].[Material]([id]);

PRINT '**** Tablas y Constraints creadas correctamente ****';
GO

/* --- MIGRACION DE DATOS ---*/

/* PROVINCIA */

CREATE PROCEDURE [NULL_EXEPTION].Migrar_Provincia
AS
BEGIN
    INSERT INTO [NULL_EXEPTION].[Provincia] (nombre)
    SELECT DISTINCT Sucursal_Provincia as nombre
    FROM gd_esquema.Maestra
    WHERE Sucursal_Provincia IS NOT NULL AND Sucursal_Provincia <> ''
      AND Sucursal_Provincia NOT IN (SELECT nombre FROM [NULL_EXEPTION].[Provincia]);

    INSERT INTO [NULL_EXEPTION].[Provincia] (nombre)
    SELECT DISTINCT Cliente_Provincia as nombre
    FROM gd_esquema.Maestra
    WHERE Cliente_Provincia IS NOT NULL AND Cliente_Provincia <> ''
      AND Cliente_Provincia NOT IN (SELECT nombre FROM [NULL_EXEPTION].[Provincia]);

    INSERT INTO [NULL_EXEPTION].[Provincia] (nombre)
    SELECT DISTINCT Proveedor_Provincia as nombre
    FROM gd_esquema.Maestra
    WHERE Proveedor_Provincia IS NOT NULL AND Proveedor_Provincia <> ''
      AND Proveedor_Provincia NOT IN (SELECT nombre FROM [NULL_EXEPTION].[Provincia]);
END
GO

/* LOCALIDAD */
CREATE PROCEDURE [NULL_EXEPTION].Migrar_Localidad
AS
BEGIN
    -- Localidades de sucursales
    INSERT INTO [NULL_EXEPTION].[Localidad] (nombre, provincia_id)
    SELECT DISTINCT m.Sucursal_Localidad, p.id
    FROM gd_esquema.Maestra m
    JOIN [NULL_EXEPTION].[Provincia] p ON p.nombre = m.Sucursal_Provincia
    WHERE m.Sucursal_Localidad IS NOT NULL AND m.Sucursal_Localidad <> ''
      AND NOT EXISTS (
        SELECT 1 FROM [NULL_EXEPTION].[Localidad] l
        WHERE l.nombre = m.Sucursal_Localidad AND l.provincia_id = p.id
    );

    -- Localidades de clientes
    INSERT INTO [NULL_EXEPTION].[Localidad] (nombre, provincia_id)
    SELECT DISTINCT m.Cliente_Localidad, p.id
    FROM gd_esquema.Maestra m
    JOIN [NULL_EXEPTION].[Provincia] p ON p.nombre = m.Cliente_Provincia
    WHERE m.Cliente_Localidad IS NOT NULL AND m.Cliente_Localidad <> ''
      AND NOT EXISTS (
        SELECT 1 FROM [NULL_EXEPTION].[Localidad] l
        WHERE l.nombre = m.Cliente_Localidad AND l.provincia_id = p.id
    );

    -- Localidades de proveedores
    INSERT INTO [NULL_EXEPTION].[Localidad] (nombre, provincia_id)
    SELECT DISTINCT m.Proveedor_Localidad, p.id
    FROM gd_esquema.Maestra m
    JOIN [NULL_EXEPTION].[Provincia] p ON p.nombre = m.Proveedor_Provincia
    WHERE m.Proveedor_Localidad IS NOT NULL AND m.Proveedor_Localidad <> ''
      AND NOT EXISTS (
        SELECT 1 FROM [NULL_EXEPTION].[Localidad] l
        WHERE l.nombre = m.Proveedor_Localidad AND l.provincia_id = p.id
    );
END
GO

CREATE PROCEDURE [NULL_EXEPTION].Migrar_Sucursal
AS
BEGIN
    INSERT INTO [NULL_EXEPTION].[Sucursal] (nombre, localidad_id, direccion, telefono, mail)
    SELECT DISTINCT
        CAST(m.Sucursal_NroSucursal AS NVARCHAR(255)), 
        l.id,
        m.Sucursal_Direccion,
        m.Sucursal_Telefono,
        m.Sucursal_Mail
    FROM gd_esquema.Maestra m
    JOIN [NULL_EXEPTION].[Provincia] p ON p.nombre = m.Sucursal_Provincia
    JOIN [NULL_EXEPTION].[Localidad] l ON l.nombre = m.Sucursal_Localidad AND l.provincia_id = p.id
    WHERE m.Sucursal_NroSucursal IS NOT NULL
      AND NOT EXISTS (
        SELECT 1 FROM [NULL_EXEPTION].[Sucursal] s
        WHERE s.nombre = CAST(m.Sucursal_NroSucursal AS NVARCHAR(255))
    );
END
GO

CREATE PROCEDURE [NULL_EXEPTION].Migrar_Cliente
AS
BEGIN
    INSERT INTO [NULL_EXEPTION].[Cliente] (nombre, apellido, email, telefono, localidad_id, dni, fecha_nacimiento)
    SELECT DISTINCT
        m.Cliente_Nombre,
        m.Cliente_Apellido,
        m.Cliente_Mail,
        m.Cliente_Telefono,
        l.id,
        m.Cliente_Dni,
        TRY_CAST(m.Cliente_FechaNacimiento AS DATE)
    FROM gd_esquema.Maestra m
    JOIN [NULL_EXEPTION].[Provincia] p ON p.nombre = m.Cliente_Provincia
    JOIN [NULL_EXEPTION].[Localidad] l ON l.nombre = m.Cliente_Localidad AND l.provincia_id = p.id
    WHERE m.Cliente_Dni IS NOT NULL 
      AND NOT EXISTS (
        SELECT 1 FROM [NULL_EXEPTION].[Cliente] c WHERE c.dni = m.Cliente_Dni
    );
END
GO

CREATE PROCEDURE [NULL_EXEPTION].Migrar_Modelo
AS
BEGIN
    INSERT INTO [NULL_EXEPTION].[Modelo] (nombre, descripcion, precio_base)
    SELECT DISTINCT
        m.Sillon_Modelo_Codigo,
        m.Sillon_Modelo_Descripcion,
        TRY_CAST(m.Sillon_Modelo_Precio AS DECIMAL(18,2))
    FROM gd_esquema.Maestra m
    WHERE m.Sillon_Modelo_Codigo IS NOT NULL AND m.Sillon_Modelo_Codigo <> ''
      AND NOT EXISTS (
        SELECT 1 FROM [NULL_EXEPTION].[Modelo] mod
        WHERE mod.nombre = m.Sillon_Modelo_Codigo
    );
END
GO

CREATE PROCEDURE [NULL_EXEPTION].Migrar_Medida
AS
BEGIN
    INSERT INTO [NULL_EXEPTION].[Medida] (alto, largo, profundidad, precio)
    SELECT DISTINCT
        TRY_CAST(m.Sillon_Medida_Alto AS DECIMAL(18,2)),
        TRY_CAST(m.Sillon_Medida_Ancho AS DECIMAL(18,2)), 
        TRY_CAST(m.Sillon_Medida_Profundidad AS DECIMAL(18,2)),
        TRY_CAST(m.Sillon_Medida_Precio AS DECIMAL(18,2))
    FROM gd_esquema.Maestra m
    WHERE TRY_CAST(m.Sillon_Medida_Alto AS DECIMAL(18,2)) IS NOT NULL 
      AND NOT EXISTS (
        SELECT 1 FROM [NULL_EXEPTION].[Medida] me
        WHERE
            me.alto = TRY_CAST(m.Sillon_Medida_Alto AS DECIMAL(18,2)) AND
            me.largo = TRY_CAST(m.Sillon_Medida_Ancho AS DECIMAL(18,2)) AND
            me.profundidad = TRY_CAST(m.Sillon_Medida_Profundidad AS DECIMAL(18,2))
          
    );
END
GO

CREATE PROCEDURE [NULL_EXEPTION].Migrar_Sillon
AS
BEGIN
    INSERT INTO [NULL_EXEPTION].[Sillon] (nombre, modelo_id, medida_id)
    SELECT DISTINCT
        m.Sillon_Codigo,
        mod.id,
        me.id
    FROM gd_esquema.Maestra m
    JOIN [NULL_EXEPTION].[Modelo] mod
        ON mod.nombre = m.Sillon_Modelo_Codigo
    JOIN [NULL_EXEPTION].[Medida] me
        ON me.alto = TRY_CAST(m.Sillon_Medida_Alto AS DECIMAL(18,2))
        AND me.largo = TRY_CAST(m.Sillon_Medida_Ancho AS DECIMAL(18,2))
        AND me.profundidad = TRY_CAST(m.Sillon_Medida_Profundidad AS DECIMAL(18,2))
    WHERE m.Sillon_Codigo IS NOT NULL AND m.Sillon_Codigo <> ''
      AND NOT EXISTS (
        SELECT 1 FROM [NULL_EXEPTION].[Sillon] s
        WHERE s.nombre = m.Sillon_Codigo
    );
END
GO

CREATE PROCEDURE [NULL_EXEPTION].Migrar_Pedido
AS
BEGIN
    INSERT INTO [NULL_EXEPTION].[Pedido] (id, sucursal_id, cliente_id, fecha_hora, precio_total)
    SELECT DISTINCT
        TRY_CAST(m.Pedido_Numero AS BIGINT),
        s.id,
        c.id,
        TRY_CAST(m.Pedido_Fecha AS DATETIME),
        TRY_CAST(m.Pedido_Total AS DECIMAL(18,2))
    FROM gd_esquema.Maestra m
    JOIN [NULL_EXEPTION].[Sucursal] s
        ON s.nombre = CAST(m.Sucursal_NroSucursal AS NVARCHAR(255))
    JOIN [NULL_EXEPTION].[Cliente] c
        ON c.dni = m.Cliente_Dni
    WHERE m.Pedido_Numero IS NOT NULL
      AND NOT EXISTS (
        SELECT 1 FROM [NULL_EXEPTION].[Pedido] p
        WHERE p.id = TRY_CAST(m.Pedido_Numero AS BIGINT)
    );
END
GO

CREATE PROCEDURE [NULL_EXEPTION].Migrar_DetallePedido
AS
BEGIN
    INSERT INTO [NULL_EXEPTION].[DetallePedido] (pedido_id, sillon_id, cantidad, precio_unitario, subtotal)
    SELECT DISTINCT 
        TRY_CAST(m.Pedido_Numero AS BIGINT),
        s.id,
        TRY_CAST(m.Detalle_Pedido_Cantidad AS BIGINT),
        TRY_CAST(m.Detalle_Pedido_Precio AS DECIMAL(18,2)),
        TRY_CAST(m.Detalle_Pedido_SubTotal AS DECIMAL(18,2))
    FROM [GD1C2025].[gd_esquema].[Maestra] m
    JOIN [NULL_EXEPTION].[Sillon] s
        ON s.nombre = m.Sillon_Codigo
    WHERE Sillon_Codigo IS NOT NULL;
END
GO

CREATE PROCEDURE [NULL_EXEPTION].Migrar_Estado
AS
BEGIN
    INSERT INTO [NULL_EXEPTION].[Estado] (nombre)
    SELECT DISTINCT m.Pedido_Estado
    FROM gd_esquema.Maestra m
    WHERE m.Pedido_Estado IS NOT NULL AND m.Pedido_Estado <> ''
      AND NOT EXISTS (
        SELECT 1 FROM [NULL_EXEPTION].[Estado] e
        WHERE e.nombre = m.Pedido_Estado
    );
END
GO

CREATE PROCEDURE [NULL_EXEPTION].Migrar_Estado_X_Pedido
AS
BEGIN
    WITH Datos AS (
        SELECT DISTINCT
            e.id AS estado_id,
            TRY_CAST(m.Pedido_Numero AS BIGINT) AS pedido_id,
            TRY_CAST(
                CASE 
                    WHEN m.Pedido_Estado = 'CANCELADO' THEN m.Pedido_Cancelacion_Fecha
                    ELSE m.Pedido_Fecha
                END AS DATETIME
            ) AS fecha_hora,
            m.Pedido_Cancelacion_Motivo AS motivo
        FROM gd_esquema.Maestra m
        JOIN [NULL_EXEPTION].[Estado] e ON e.nombre = m.Pedido_Estado
        JOIN [NULL_EXEPTION].[Pedido] ped ON ped.id = TRY_CAST(m.Pedido_Numero AS BIGINT)
        WHERE m.Pedido_Numero IS NOT NULL AND m.Pedido_Estado IS NOT NULL
    )
    INSERT INTO [NULL_EXEPTION].[Estado_X_Pedido] (estado_id, pedido_id, fecha_hora, motivo)
    SELECT estado_id, pedido_id, fecha_hora, motivo
    FROM Datos
    WHERE fecha_hora IS NOT NULL
      AND NOT EXISTS (
        SELECT 1 FROM [NULL_EXEPTION].[Estado_X_Pedido] ex
        WHERE ex.estado_id = Datos.estado_id AND ex.pedido_id = Datos.pedido_id
      );
END
GO


CREATE PROCEDURE [NULL_EXEPTION].Migrar_Factura
AS
BEGIN
    INSERT INTO [NULL_EXEPTION].[Factura] (id, sucursal_id, cliente_id, fecha_hora, precio_total, pedido_id)
    SELECT DISTINCT
        TRY_CAST(m.Factura_Numero AS BIGINT),
        s.id,
        c.id,
        TRY_CAST(m.Factura_Fecha AS DATETIME),
        TRY_CAST(m.Factura_Total AS DECIMAL(18,2)),
        TRY_CAST(m.Pedido_Numero AS BIGINT)
    FROM gd_esquema.Maestra m
    JOIN [NULL_EXEPTION].[Sucursal] s ON s.nombre = CAST(m.Sucursal_NroSucursal AS NVARCHAR(255))
    JOIN [NULL_EXEPTION].[Cliente] c ON c.dni = m.Cliente_Dni
    JOIN [NULL_EXEPTION].[Pedido] p ON p.id = TRY_CAST(m.Pedido_Numero AS BIGINT)
    WHERE m.Factura_Numero IS NOT NULL
      AND NOT EXISTS (
        SELECT 1 FROM [NULL_EXEPTION].[Factura] f
        WHERE f.id = TRY_CAST(m.Factura_Numero AS BIGINT)
    );
END
GO

CREATE PROCEDURE [NULL_EXEPTION].Migrar_DetalleFactura
AS
BEGIN
    INSERT INTO [NULL_EXEPTION].[DetalleFactura] (detalle_ped_id, factura_id, cantidad, precio_unitario, subtotal)
    SELECT 
        dp.id as detalle_ped_id,
        fac.id as factura_id,
        TRY_CAST(m.Detalle_Factura_Cantidad AS BIGINT) as cantidad,
        TRY_CAST(m.Detalle_Factura_Precio AS DECIMAL(18,2)) as precio_unitario,
        TRY_CAST(m.Detalle_Factura_SubTotal AS DECIMAL(18,2)) as subtotal
    FROM gd_esquema.Maestra m
    JOIN [NULL_EXEPTION].[Factura] fac ON fac.id = TRY_CAST(m.Factura_Numero AS BIGINT) 
    JOIN [NULL_EXEPTION].[DetallePedido] dp ON dp.pedido_id = fac.pedido_id 
        AND dp.cantidad = TRY_CAST(m.Detalle_Pedido_Cantidad AS BIGINT)
        AND dp.precio_unitario = TRY_CAST(m.Detalle_Pedido_Precio AS DECIMAL(18,2))
        AND dp.subtotal = TRY_CAST(m.Detalle_Pedido_SubTotal AS DECIMAL(18,2))
    WHERE m.Factura_Numero IS NOT NULL 
      AND NOT EXISTS (
        SELECT 1 FROM [NULL_EXEPTION].[DetalleFactura] df
        WHERE df.detalle_ped_id = dp.id
    );
END
GO

CREATE PROCEDURE [NULL_EXEPTION].Migrar_Envio
AS
BEGIN
    INSERT INTO [NULL_EXEPTION].[Envio] (id, factura_id, fecha_programada, fecha_entrega, importe_traslado, importe_subida, total)
    SELECT DISTINCT
        TRY_CAST(m.Envio_Numero AS BIGINT),
        TRY_CAST(m.Factura_Numero AS BIGINT),
        TRY_CAST(m.Envio_Fecha_Programada AS DATETIME),
        TRY_CAST(m.Envio_Fecha AS DATETIME),
        TRY_CAST(m.Envio_ImporteTraslado AS DECIMAL(18,2)),
        TRY_CAST(m.Envio_ImporteSubida AS DECIMAL(18,2)),
        TRY_CAST(m.Envio_Total AS DECIMAL(18,2))
    FROM gd_esquema.Maestra m
    JOIN [NULL_EXEPTION].[Factura] f ON f.id = TRY_CAST(m.Factura_Numero AS BIGINT) 
    WHERE m.Envio_Numero IS NOT NULL
      AND NOT EXISTS (
        SELECT 1 FROM [NULL_EXEPTION].[Envio] e
        WHERE e.id = TRY_CAST(m.Envio_Numero AS BIGINT)
    );
END
GO

CREATE PROCEDURE [NULL_EXEPTION].Migrar_Color
AS
BEGIN
    INSERT INTO [NULL_EXEPTION].[Color] (nombre)
    SELECT DISTINCT m.Tela_Color
    FROM gd_esquema.Maestra m
    WHERE m.Tela_Color IS NOT NULL AND m.Tela_Color <> ''
    AND NOT EXISTS (
        SELECT 1 FROM [NULL_EXEPTION].[Color] c WHERE c.nombre = m.Tela_Color
    );

    INSERT INTO [NULL_EXEPTION].[Color] (nombre)
    SELECT DISTINCT m.Madera_Color
    FROM gd_esquema.Maestra m
    WHERE m.Madera_Color IS NOT NULL AND m.Madera_Color <> ''
    AND NOT EXISTS (
        SELECT 1 FROM [NULL_EXEPTION].[Color] c WHERE c.nombre = m.Madera_Color
    );
END
GO

CREATE PROCEDURE [NULL_EXEPTION].Migrar_Textura
AS
BEGIN
    INSERT INTO [NULL_EXEPTION].[Textura] (nombre)
    SELECT DISTINCT m.Tela_Textura
    FROM gd_esquema.Maestra m
    WHERE m.Tela_Textura IS NOT NULL AND m.Tela_Textura <> ''
    AND NOT EXISTS (
        SELECT 1 FROM [NULL_EXEPTION].[Textura] t WHERE t.nombre = m.Tela_Textura
    );
END
GO

CREATE PROCEDURE [NULL_EXEPTION].Migrar_Dureza
AS
BEGIN
    INSERT INTO [NULL_EXEPTION].[Dureza] (nombre)
    SELECT DISTINCT m.Madera_Dureza
    FROM gd_esquema.Maestra m
    WHERE m.Madera_Dureza IS NOT NULL AND m.Madera_Dureza <> ''
    AND NOT EXISTS (
        SELECT 1 FROM [NULL_EXEPTION].[Dureza] d WHERE d.nombre = m.Madera_Dureza
    );
END
GO

CREATE PROCEDURE [NULL_EXEPTION].Migrar_Densidad
AS
BEGIN
    INSERT INTO [NULL_EXEPTION].[Densidad] (nombre)
    SELECT DISTINCT CAST(m.Relleno_Densidad AS NVARCHAR(255))
    FROM gd_esquema.Maestra m
    WHERE m.Relleno_Densidad IS NOT NULL
      AND NOT EXISTS (
          SELECT 1 FROM [NULL_EXEPTION].[Densidad] d
          WHERE d.nombre = CAST(m.Relleno_Densidad AS NVARCHAR(255))
      );
END
GO

CREATE PROCEDURE [NULL_EXEPTION].Migrar_Tela
AS
BEGIN
    INSERT INTO [NULL_EXEPTION].[Tela] (nombre, color_id, textura_id, disponible)
    SELECT DISTINCT
        m.Material_Nombre,
        c.id,
        t.id,
        1 
    FROM gd_esquema.Maestra m
    JOIN [NULL_EXEPTION].[Color] c ON c.nombre = m.Tela_Color
    JOIN [NULL_EXEPTION].[Textura] t ON t.nombre = m.Tela_Textura
    WHERE m.Material_Tipo = 'Tela' AND m.Material_Nombre IS NOT NULL AND m.Material_Nombre <> ''
      AND m.Tela_Color IS NOT NULL AND m.Tela_Textura IS NOT NULL 
      AND NOT EXISTS (
          SELECT 1 FROM [NULL_EXEPTION].[Tela] te WHERE te.nombre = m.Material_Nombre
      );
END
GO

CREATE PROCEDURE [NULL_EXEPTION].Migrar_Madera
AS
BEGIN
    INSERT INTO [NULL_EXEPTION].[Madera] (nombre, color_id, dureza_id, disponible)
    SELECT DISTINCT
        m.Material_Nombre,
        c.id,
        d.id,
        1
    FROM gd_esquema.Maestra m
    JOIN [NULL_EXEPTION].[Color] c ON c.nombre = m.Madera_Color
    JOIN [NULL_EXEPTION].[Dureza] d ON d.nombre = m.Madera_Dureza
    WHERE m.Material_Tipo = 'Madera' AND m.Material_Nombre IS NOT NULL AND m.Material_Nombre <> ''
      AND m.Madera_Color IS NOT NULL AND m.Madera_Dureza IS NOT NULL
      AND NOT EXISTS (
          SELECT 1 FROM [NULL_EXEPTION].[Madera] ma WHERE ma.nombre = m.Material_Nombre
      );
END
GO

CREATE PROCEDURE [NULL_EXEPTION].Migrar_Relleno
AS
BEGIN
    INSERT INTO [NULL_EXEPTION].[Relleno] (nombre, densidad_id, disponible)
    SELECT DISTINCT
        m.Material_Nombre,
        d.id,
        1
    FROM gd_esquema.Maestra m
    JOIN [NULL_EXEPTION].[Densidad] d ON d.nombre = m.Relleno_Densidad
    WHERE m.Material_Tipo = 'Relleno' AND m.Material_Nombre IS NOT NULL AND m.Material_Nombre <> ''
      AND m.Relleno_Densidad IS NOT NULL
      AND NOT EXISTS (
          SELECT 1 FROM [NULL_EXEPTION].[Relleno] r WHERE r.nombre = m.Material_Nombre
      );
END
GO

CREATE PROCEDURE [NULL_EXEPTION].Migrar_Material
AS
BEGIN
    -- TELA
    INSERT INTO [NULL_EXEPTION].[Material] (nombre, precio_base, tela_id, madera_id, relleno_id, descripcion)
    SELECT DISTINCT
        m.Material_Nombre,
        TRY_CAST(m.Material_Precio AS DECIMAL(18,2)),
        t.id, 
        NULL,
        NULL,
        m.Material_Descripcion
    FROM gd_esquema.Maestra m
    JOIN [NULL_EXEPTION].[Tela] t ON t.nombre = m.Material_Nombre 
    WHERE m.Material_Tipo = 'Tela' AND m.Material_Nombre IS NOT NULL
      AND NOT EXISTS (
        SELECT 1 FROM [NULL_EXEPTION].[Material] mat WHERE mat.nombre = m.Material_Nombre AND mat.tela_id = t.id -- Mas especifico
    );

    -- MADERA
    INSERT INTO [NULL_EXEPTION].[Material] (nombre, precio_base, tela_id, madera_id, relleno_id, descripcion)
    SELECT DISTINCT
        m.Material_Nombre,
        TRY_CAST(m.Material_Precio AS DECIMAL(18,2)),
        NULL,
        ma.id, 
        NULL,
        m.Material_Descripcion
    FROM gd_esquema.Maestra m
    JOIN [NULL_EXEPTION].[Madera] ma ON ma.nombre = m.Material_Nombre
    WHERE m.Material_Tipo = 'Madera' AND m.Material_Nombre IS NOT NULL
      AND NOT EXISTS (
        SELECT 1 FROM [NULL_EXEPTION].[Material] mat WHERE mat.nombre = m.Material_Nombre AND mat.madera_id = ma.id
    );

    -- RELLENO
    INSERT INTO [NULL_EXEPTION].[Material] (nombre, precio_base, tela_id, madera_id, relleno_id, descripcion)
    SELECT DISTINCT
        m.Material_Nombre,
        TRY_CAST(m.Material_Precio AS DECIMAL(18,2)),
        NULL,
        NULL,
        r.id, 
        m.Material_Descripcion
    FROM gd_esquema.Maestra m
    JOIN [NULL_EXEPTION].[Relleno] r ON r.nombre = m.Material_Nombre
    WHERE m.Material_Tipo = 'Relleno' AND m.Material_Nombre IS NOT NULL
      AND NOT EXISTS (
        SELECT 1 FROM [NULL_EXEPTION].[Material] mat WHERE mat.nombre = m.Material_Nombre AND mat.relleno_id = r.id
    );
END
GO

CREATE PROCEDURE [NULL_EXEPTION].Migrar_Sillon_X_Material
AS
BEGIN
    -- TELA
    INSERT INTO [NULL_EXEPTION].[Sillon_X_Material] (sillon_id, material_id)
    SELECT DISTINCT
        s.id,
        mat.id
    FROM gd_esquema.Maestra m
    JOIN [NULL_EXEPTION].[Sillon] s ON s.nombre = m.Sillon_Codigo
    JOIN [NULL_EXEPTION].[Tela] te ON te.nombre = m.Material_Nombre
        AND te.color_id = (SELECT id FROM [NULL_EXEPTION].[Color] WHERE nombre = m.Tela_Color)
        AND te.textura_id = (SELECT id FROM [NULL_EXEPTION].[Textura] WHERE nombre = m.Tela_Textura)
    JOIN [NULL_EXEPTION].[Material] mat ON mat.tela_id = te.id AND mat.nombre = m.Material_Nombre
    WHERE m.Material_Tipo = 'Tela'
      AND m.Sillon_Codigo IS NOT NULL AND m.Sillon_Codigo <> ''
      AND NOT EXISTS (
        SELECT 1 FROM [NULL_EXEPTION].[Sillon_X_Material] sxm
        WHERE sxm.sillon_id = s.id AND sxm.material_id = mat.id
    );

    -- MADERA
    INSERT INTO [NULL_EXEPTION].[Sillon_X_Material] (sillon_id, material_id)
    SELECT DISTINCT
        s.id,
        mat.id
    FROM gd_esquema.Maestra m
    JOIN [NULL_EXEPTION].[Sillon] s ON s.nombre = m.Sillon_Codigo
    JOIN [NULL_EXEPTION].[Madera] ma ON ma.nombre = m.Material_Nombre
        AND ma.color_id = (SELECT id FROM [NULL_EXEPTION].[Color] WHERE nombre = m.Madera_Color)
        AND ma.dureza_id = (SELECT id FROM [NULL_EXEPTION].[Dureza] WHERE nombre = m.Madera_Dureza)
    JOIN [NULL_EXEPTION].[Material] mat ON mat.madera_id = ma.id AND mat.nombre = m.Material_Nombre
    WHERE m.Material_Tipo = 'Madera'
      AND m.Sillon_Codigo IS NOT NULL AND m.Sillon_Codigo <> ''
      AND NOT EXISTS (
        SELECT 1 FROM [NULL_EXEPTION].[Sillon_X_Material] sxm
        WHERE sxm.sillon_id = s.id AND sxm.material_id = mat.id
    );

    -- RELLENO
    INSERT INTO [NULL_EXEPTION].[Sillon_X_Material] (sillon_id, material_id)
    SELECT DISTINCT
        s.id,
        mat.id
    FROM gd_esquema.Maestra m
    JOIN [NULL_EXEPTION].[Sillon] s ON s.nombre = m.Sillon_Codigo
    JOIN [NULL_EXEPTION].[Relleno] r ON r.nombre = m.Material_Nombre
        AND r.densidad_id = (SELECT id FROM [NULL_EXEPTION].[Densidad] WHERE nombre = m.Relleno_Densidad)
    JOIN [NULL_EXEPTION].[Material] mat ON mat.relleno_id = r.id AND mat.nombre = m.Material_Nombre
    WHERE m.Material_Tipo = 'Relleno'
      AND m.Sillon_Codigo IS NOT NULL AND m.Sillon_Codigo <> ''
      AND NOT EXISTS (
        SELECT 1 FROM [NULL_EXEPTION].[Sillon_X_Material] sxm
        WHERE sxm.sillon_id = s.id AND sxm.material_id = mat.id
    );
END
GO

CREATE PROCEDURE [NULL_EXEPTION].Migrar_Proveedor
AS
BEGIN
    INSERT INTO [NULL_EXEPTION].[Proveedor] (localidad_id, razon_social_id, cuit, direccion, telefono, mail)
    SELECT DISTINCT
        l.id,
        m.Proveedor_RazonSocial, 
        m.Proveedor_Cuit,
        m.Proveedor_Direccion,
        m.Proveedor_Telefono,
        m.Proveedor_Mail
    FROM gd_esquema.Maestra m
    JOIN [NULL_EXEPTION].[Provincia] p ON p.nombre = m.Proveedor_Provincia
    JOIN [NULL_EXEPTION].[Localidad] l ON l.nombre = m.Proveedor_Localidad AND l.provincia_id = p.id
    WHERE m.Proveedor_Cuit IS NOT NULL AND m.Proveedor_Cuit <> ''
      AND NOT EXISTS (
        SELECT 1 FROM [NULL_EXEPTION].[Proveedor] pr
        WHERE pr.cuit = m.Proveedor_Cuit
    );
END
GO

CREATE PROCEDURE [NULL_EXEPTION].Migrar_Compra
AS
BEGIN
    INSERT INTO [NULL_EXEPTION].[Compra] (id, sucursal_id, proveedor_id, fecha, total)
    SELECT DISTINCT
        TRY_CAST(m.Compra_Numero AS BIGINT),
        s.id,
        p.id,
        TRY_CAST(m.Compra_Fecha AS DATETIME),
        TRY_CAST(m.Compra_Total AS DECIMAL(18,2))
    FROM gd_esquema.Maestra m
    JOIN [NULL_EXEPTION].[Sucursal] s ON s.nombre = CAST(m.Sucursal_NroSucursal AS NVARCHAR(255))
    JOIN [NULL_EXEPTION].[Proveedor] p ON p.cuit = m.Proveedor_Cuit
    WHERE m.Compra_Numero IS NOT NULL
      AND NOT EXISTS (
        SELECT 1 FROM [NULL_EXEPTION].[Compra] c
        WHERE c.id = TRY_CAST(m.Compra_Numero AS BIGINT)
    );
END
GO

CREATE PROCEDURE [NULL_EXEPTION].Migrar_DetalleCompra
AS
BEGIN
    INSERT INTO [NULL_EXEPTION].[DetalleCompra] (compra_id, material_id, precio_unitario, cantidad, subtotal)
    SELECT DISTINCT
        TRY_CAST(m.Compra_Numero AS BIGINT),
        mat.id,
        TRY_CAST(m.Detalle_Compra_Precio AS DECIMAL(18,2)),
        TRY_CAST(m.Detalle_Compra_Cantidad AS DECIMAL(18,3)),
        TRY_CAST(m.Detalle_Compra_SubTotal AS DECIMAL(18,2))
    FROM gd_esquema.Maestra m
    JOIN [NULL_EXEPTION].[Compra] com ON com.id = TRY_CAST(m.Compra_Numero AS BIGINT) 
    JOIN [NULL_EXEPTION].[Material] mat ON mat.nombre = m.Material_Nombre 
    WHERE m.Compra_Numero IS NOT NULL AND m.Material_Nombre IS NOT NULL
      AND NOT EXISTS (
        SELECT 1 FROM [NULL_EXEPTION].[DetalleCompra] dc
        WHERE dc.compra_id = TRY_CAST(m.Compra_Numero AS BIGINT)
          AND dc.material_id = mat.id
          AND dc.cantidad = TRY_CAST(m.Detalle_Compra_Cantidad AS DECIMAL(18,3))
          AND dc.precio_unitario = TRY_CAST(m.Detalle_Compra_Precio AS DECIMAL(18,2))
    );
END
GO

PRINT '**** Procedimientos de Migracion Creados Correctamente ****';
GO

print'-- PROVINCIAS --';
EXEC [NULL_EXEPTION].Migrar_Provincia;
print'-- LOCALIDADES --';
EXEC [NULL_EXEPTION].Migrar_Localidad;
print'-- SUCURSALES --';
EXEC [NULL_EXEPTION].Migrar_Sucursal;
print'-- CLIENTES --';
EXEC [NULL_EXEPTION].Migrar_Cliente;
print'-- MODELOS --';
EXEC [NULL_EXEPTION].Migrar_Modelo;
print'-- MEDIDAS --';
EXEC [NULL_EXEPTION].Migrar_Medida;
print'-- SILLONES --';
EXEC [NULL_EXEPTION].Migrar_Sillon;
print'-- PEDIDOS --';
EXEC [NULL_EXEPTION].Migrar_Pedido;
print'-- DETALLESPEDIDOS --';
EXEC [NULL_EXEPTION].Migrar_DetallePedido;
print'-- ESTADOS --';
EXEC [NULL_EXEPTION].Migrar_Estado;
print'-- ESTADOSXPEDIDOS --';
EXEC [NULL_EXEPTION].Migrar_Estado_X_Pedido;
print'-- FACTURAS --';
EXEC [NULL_EXEPTION].Migrar_Factura;
print'-- DETALLEFACTURAS --';
EXEC [NULL_EXEPTION].Migrar_DetalleFactura;
print'-- ENVIOS --';
EXEC [NULL_EXEPTION].Migrar_Envio;
print'-- COLORES --';
EXEC [NULL_EXEPTION].Migrar_Color;
print'-- TEXTURAS --';
EXEC [NULL_EXEPTION].Migrar_Textura;
print'-- DUREZAS --';
EXEC [NULL_EXEPTION].Migrar_Dureza;
print'-- DENSIDADES --';
EXEC [NULL_EXEPTION].Migrar_Densidad;
print'-- TELAS --';
EXEC [NULL_EXEPTION].Migrar_Tela;
print'-- MADERAS --';
EXEC [NULL_EXEPTION].Migrar_Madera;
print'-- RELLENOS --';
EXEC [NULL_EXEPTION].Migrar_Relleno;
print'-- MATERIALES --';
EXEC [NULL_EXEPTION].Migrar_Material; 
print'-- SILLON_X_MATERIAL --';
EXEC [NULL_EXEPTION].Migrar_Sillon_X_Material; 
print'-- PROVEEDORES --';
EXEC [NULL_EXEPTION].Migrar_Proveedor;
print'-- COMPRAS --';
EXEC [NULL_EXEPTION].Migrar_Compra;
print'-- DETALLESCOMPRAS --';
EXEC [NULL_EXEPTION].Migrar_DetalleCompra;
