/* creacion migracion */
 USE [GD1C2025]
GO

PRINT ' comenzar migracion'

GO

--DROPS
--drop de FKs
DECLARE @DropConstraints NNVARCHAR(MAX) = ''

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
DECLARE @DropTables NNVARCHAR(MAX) = ''

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
    [provincia_id] BIGINT,
    FOREIGN KEY (provincia_id) REFERENCES [NULL_EXEPTION].Provincia(id)
);

/* SUCURSAL */
CREATE TABLE [NULL_EXEPTION].[Sucursal] 
(
    [id] BIGINT NOT NULL IDENTITY,
    [nombre] NVARCHAR(255) NOT NULL,
    [localidad_id] BIGINT,
    [dirección] NVARCHAR(255),
    [teléfono] NVARCHAR(50),
    [mail] NVARCHAR(255),
    FOREIGN KEY (localidad_id) REFERENCES [NULL_EXEPTION].Localidad(id)
);

/* CLIENTE */
CREATE TABLE [NULL_EXEPTION].[Cliente] 
(
    [id] BIGINT NOT NULL IDENTITY,
    [nombre] NVARCHAR(255) NOT NULL,
    [apellido] NVARCHAR(255) NOT NULL,
    [email] NVARCHAR(255),
    [teléfono] NVARCHAR(50),
    [localidad_id] BIGINT,
    [dni] NVARCHAR(50),
    [fecha_nacimiento] DATE,
    FOREIGN KEY (localidad_id) REFERENCES [NULL_EXEPTION].Localidad(id)
);

/* PEDIDO */
CREATE TABLE [NULL_EXEPTION].[Pedido] 
(
    [id] BIGINT NOT NULL IDENTITY,
    [sucursal_id] BIGINT,
    [cliente_id] BIGINT,
    [fecha_hora] DATETIME,
    [precio_total] DECIMAL,
    FOREIGN KEY (sucursal_id) REFERENCES [NULL_EXEPTION].Sucursal(id),
    FOREIGN KEY (cliente_id) REFERENCES [NULL_EXEPTION].Cliente(id)
);

/* MEDIDA */
CREATE TABLE [NULL_EXEPTION].[Medida] 
(
    [id] BIGINT NOT NULL IDENTITY,
    [largo] DECIMAL,
    [profundidad] DECIMAL,
    [alto] DECIMAL,
    [precio] DECIMAL
);

/* MODELO */
CREATE TABLE [NULL_EXEPTION].[Modelo] 
(
    [id] BIGINT NOT NULL IDENTITY,
    [nombre] NVARCHAR(255) NOT NULL,
    [precio_base] DECIMAL,
    [descripción] NVARCHAR
);

/* SILLON */
CREATE TABLE [NULL_EXEPTION].[Sillon] 
(
    [id] BIGINT NOT NULL IDENTITY,
    [nombre] NVARCHAR(255) NOT NULL,
    [modelo_id] BIGINT,
    [medida_id] BIGINT,
    FOREIGN KEY (modelo_id) REFERENCES [NULL_EXEPTION].Modelo(id),
    FOREIGN KEY (medida_id) REFERENCES [NULL_EXEPTION].Medida(id)
);

/* DETALLE_PEDIDO */
CREATE TABLE [NULL_EXEPTION].[DetallePedido] 
(
    [id] BIGINT NOT NULL IDENTITY,
    [pedido_id] BIGINT,
    [sillon_id] BIGINT,
    [cantidad] BIGINT,
    [precio_unitario] DECIMAL,
    [sub_total] DECIMAL
);

/* DETALLE_FACTURA */
CREATE TABLE [NULL_EXEPTION].[DetalleFactura] 
(
    [id] BIGINT NOT NULL IDENTITY,
    [detalle_ped_id] BIGINT,
    [sucursal_id] BIGINT,
    [cliente_id] BIGINT,
    [cantidad] BIGINT,
    [precio_unitario] DECIMAL,
    [subtotal] DECIMAL
);

/* FACTURA */
CREATE TABLE [NULL_EXEPTION].[Factura] 
(
    [nroFactura] BIGINT NOT NULL IDENTITY,
    [sucursal_id] BIGINT,
    [cliente_id] BIGINT,
    [fecha_hora] DATETIME,
    [precio_total] DECIMAL,
    [pedido_id] BIGINT
);

/* ENVIO */
CREATE TABLE [NULL_EXEPTION].[Envio] 
(
    [id] BIGINT NOT NULL IDENTITY,
    [factura_id] BIGINT,
    [fecha_programada] DATETIME,
    [fecha_entrega] DATETIME,
    [importe_traslado] DECIMAL,
    [importe_subida] DECIMAL,
    [total] DECIMAL
);

/* ESTADO */
CREATE TABLE [NULL_EXEPTION].[Estado] 
(
    [id] BIGINT NOT NULL IDENTITY,
    [nombre] NVARCHAR(255) NOT NULL
);

/* ESTADO_X_PEDIIDO */
CREATE TABLE [NULL_EXEPTION].[Estado_X_Pedido] 
(
    [id_estado] BIGINT NOT NULL,
    [id_pedido] BIGINT NOT NULL,
    [fecha_hora] DATETIME,
    [motivo] NVARCHAR
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
    [precio_base] DECIMAL,
    [tipo_id] BIGINT,
    [descripción] NVARCHAR
);

/* TELA */
CREATE TABLE [NULL_EXEPTION].[Tela] 
(
    [id] BIGINT NOT NULL IDENTITY,
    [nombre] NVARCHAR(255) NOT NULL,
    [color_id] BIGINT,
    [textura_id] BIGINT,
    [disponible] BOOLEAN
);

/* MADERA */
CREATE TABLE [NULL_EXEPTION].[Madera] 
(
    [id] BIGINT NOT NULL IDENTITY,
    [nombre] NVARCHAR(255) NOT NULL,
    [color_id] BIGINT,
    [dureza_id] BIGINT,
    [disponible] BOOLEAN
);

/* RELLENO */
CREATE TABLE [NULL_EXEPTION].[Relleno] 
(
    [id] BIGINT NOT NULL IDENTITY,
    [nombre] NVARCHAR(255) NOT NULL,
    [densidad_id] BIGINT,
    [disponible] BOOLEAN
);

/* RAZON_SOCIAL */
CREATE TABLE [NULL_EXEPTION].[RazonSocial] 
(
    [id] BIGINT NOT NULL IDENTITY,
    [nombre] NVARCHAR(255) NOT NULL
);

/* PROVEEDOR */
CREATE TABLE [NULL_EXEPTION].[Proveedor] 
(
    [id] BIGINT NOT NULL IDENTITY,
    [localidad_id] BIGINT,
    [razon_social_id] BIGINT,
    [cuit] NVARCHAR(50),
    [dirección] NVARCHAR(255),
    [teléfono] NVARCHAR(50),
    [mail] NVARCHAR(255),
);

/* COMPRA */
CREATE TABLE [NULL_EXEPTION].[Compra] 
(
    [id] BIGINT NOT NULL IDENTITY,
    [id_sucursal] BIGINT,
    [id_proveedor] BIGINT,
    [fecha] DATETIME,
    [total] DECIMAL
);

/* DETALLE_COMPRA */
CREATE TABLE [NULL_EXEPTION].[DetalleCompra] 
(
    [id] BIGINT NOT NULL IDENTITY,
    [id_compra] BIGINT,
    [id_material] BIGINT,
    [precio_unitario] DECIMAL,
    [cantidad] DECIMAL,
    [subtotal] DECIMAL
);


/* CONSTRAINT GENERATION - PRIMARY KEYS */

/* EJEMPLO DE PK */
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
    ADD CONSTRAINT [PK_Factura] PRIMARY KEY CLUSTERED ([nroFactura] ASC);

ALTER TABLE [NULL_EXEPTION].[Envio]
    ADD CONSTRAINT [PK_Envio] PRIMARY KEY CLUSTERED ([id] ASC);

ALTER TABLE [NULL_EXEPTION].[Estado]
    ADD CONSTRAINT [PK_Estado] PRIMARY KEY CLUSTERED ([id] ASC);

ALTER TABLE [NULL_EXEPTION].[Estado_X_Pedido]
    ADD CONSTRAINT [PK_Estado_X_Pedido] PRIMARY KEY CLUSTERED ([id_estado] ASC, [id_pedido] ASC);

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

ALTER TABLE [NULL_EXEPTION].[RazonSocial]
    ADD CONSTRAINT [PK_RazonSocial] PRIMARY KEY CLUSTERED ([id] ASC);

ALTER TABLE [NULL_EXEPTION].[Proveedor]
    ADD CONSTRAINT [PK_Proveedor] PRIMARY KEY CLUSTERED ([id] ASC);

ALTER TABLE [NULL_EXEPTION].[Compra]
    ADD CONSTRAINT [PK_Compra] PRIMARY KEY CLUSTERED ([id] ASC);

ALTER TABLE [NULL_EXEPTION].[DetalleCompra]
    ADD CONSTRAINT [PK_DetalleCompra] PRIMARY KEY CLUSTERED ([id] ASC);


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
    ADD CONSTRAINT [FK_DetalleFactura_sucursal] FOREIGN KEY ([sucursal_id])
    REFERENCES [NULL_EXEPTION].[Sucursal]([id]);

ALTER TABLE [NULL_EXEPTION].[DetalleFactura]
    ADD CONSTRAINT [FK_DetalleFactura_cliente] FOREIGN KEY ([cliente_id])
    REFERENCES [NULL_EXEPTION].[Cliente]([id]);

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
    REFERENCES [NULL_EXEPTION].[Factura]([nroFactura]);

ALTER TABLE [NULL_EXEPTION].[Estado_X_Pedido]
    ADD CONSTRAINT [FK_Estado_X_Pedido_estado] FOREIGN KEY ([id_estado])
    REFERENCES [NULL_EXEPTION].[Estado]([id]);

ALTER TABLE [NULL_EXEPTION].[Estado_X_Pedido]
    ADD CONSTRAINT [FK_Estado_X_Pedido_pedido] FOREIGN KEY ([id_pedido])
    REFERENCES [NULL_EXEPTION].[Pedido]([id]);

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

ALTER TABLE [NULL_EXEPTION].[Proveedor]
    ADD CONSTRAINT [FK_Proveedor_razon_social] FOREIGN KEY ([razon_social_id])
    REFERENCES [NULL_EXEPTION].[RazonSocial]([id]);

ALTER TABLE [NULL_EXEPTION].[Compra]
    ADD CONSTRAINT [FK_Compra_sucursal] FOREIGN KEY ([id_sucursal])
    REFERENCES [NULL_EXEPTION].[Sucursal]([id]);

ALTER TABLE [NULL_EXEPTION].[Compra]
    ADD CONSTRAINT [FK_Compra_proveedor] FOREIGN KEY ([id_proveedor])
    REFERENCES [NULL_EXEPTION].[Proveedor]([id]);

ALTER TABLE [NULL_EXEPTION].[DetalleCompra] 
    ADD CONSTRAINT [FK_DetalleCompra_compra] FOREIGN KEY ([id_compra])
    REFERENCES [NULL_EXEPTION].[Compra]([id]);  

ALTER TABLE [NULL_EXEPTION].[DetalleCompra] 
    ADD CONSTRAINT [FK_DetalleCompra_material] FOREIGN KEY ([id_material])
    REFERENCES [NULL_EXEPTION].[Material]([id]);

print '**** Tablas creadas correctamente ****';

GO

/* --- MIGRACION DE DATOS ---*/

