USE [GD1C2025]
GO

PRINT '**** Iniciando creación del modelo de BI ****'
GO

DECLARE @DropConstraints nvarchar(max) = ''

SELECT @DropConstraints += 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id)) + '.'
    + QUOTENAME(OBJECT_NAME(parent_object_id)) + ' ' + 'DROP CONSTRAINT' + QUOTENAME(name)

FROM sys.foreign_keys

EXECUTE sp_executesql @DropConstraints;

PRINT '**** CONSTRAINTs BI dropeadas correctamente ****';

GO

-- Verificar y eliminar tablas BI existentes
IF EXISTS (SELECT *
           FROM sys.tables
           WHERE name = 'BI_Fact_Ventas'
             AND schema_id = SCHEMA_ID('NULL_EXEPTION'))
    DROP TABLE [NULL_EXEPTION].[BI_Fact_Ventas];

IF EXISTS (SELECT *
           FROM sys.tables
           WHERE name = 'BI_Fact_Compras'
             AND schema_id = SCHEMA_ID('NULL_EXEPTION'))
    DROP TABLE [NULL_EXEPTION].[BI_Fact_Compras];

IF EXISTS (SELECT *
           FROM sys.tables
           WHERE name = 'BI_Fact_Envios'
             AND schema_id = SCHEMA_ID('NULL_EXEPTION'))
    DROP TABLE [NULL_EXEPTION].[BI_Fact_Envios];

IF EXISTS (SELECT *
           FROM sys.tables
           WHERE name = 'BI_Dim_Tiempo'
             AND schema_id = SCHEMA_ID('NULL_EXEPTION'))
    DROP TABLE [NULL_EXEPTION].[BI_Dim_Tiempo];

IF EXISTS (SELECT *
           FROM sys.tables
           WHERE name = 'BI_Dim_Ubicacion'
             AND schema_id = SCHEMA_ID('NULL_EXEPTION'))
    DROP TABLE [NULL_EXEPTION].[BI_Dim_Ubicacion];

IF EXISTS (SELECT *
           FROM sys.tables
           WHERE name = 'BI_Dim_Cliente'
             AND schema_id = SCHEMA_ID('NULL_EXEPTION'))
    DROP TABLE [NULL_EXEPTION].[BI_Dim_Cliente];

IF EXISTS (SELECT *
           FROM sys.tables
           WHERE name = 'BI_Dim_Turno'
             AND schema_id = SCHEMA_ID('NULL_EXEPTION'))
    DROP TABLE [NULL_EXEPTION].[BI_Dim_Turno];

IF EXISTS (SELECT *
           FROM sys.tables
           WHERE name = 'BI_Dim_Modelo'
             AND schema_id = SCHEMA_ID('NULL_EXEPTION'))
    DROP TABLE [NULL_EXEPTION].[BI_Dim_Modelo];

IF EXISTS (SELECT *
           FROM sys.tables
           WHERE name = 'BI_Dim_Estado_Pedido'
             AND schema_id = SCHEMA_ID('NULL_EXEPTION'))
    DROP TABLE [NULL_EXEPTION].[BI_Dim_Estado_Pedido];

IF EXISTS (SELECT *
           FROM sys.tables
           WHERE name = 'BI_Dim_Tipo_Material'
             AND schema_id = SCHEMA_ID('NULL_EXEPTION'))
    DROP TABLE [NULL_EXEPTION].[BI_Dim_Tipo_Material];

PRINT '**** Tablas BI existentes eliminadas (si existían) ****'
GO

-- Eliminar vistas

IF OBJECT_ID('[NULL_EXEPTION].[BI_Ganancias_Mensuales_Sucursal]', 'V') IS NOT NULL
    DROP VIEW [NULL_EXEPTION].[BI_Ganancias_Mensuales_Sucursal];
IF OBJECT_ID('[NULL_EXEPTION].[BI_Factura_Promedio_Provincia_Cuatrimestre]', 'V') IS NOT NULL
    DROP VIEW [NULL_EXEPTION].[BI_Factura_Promedio_Provincia_Cuatrimestre];
IF OBJECT_ID('[NULL_EXEPTION].[BI_Top3_Modelos_Ventas]', 'V') IS NOT NULL
    DROP VIEW [NULL_EXEPTION].[BI_Top3_Modelos_Ventas];
IF OBJECT_ID('[NULL_EXEPTION].[BI_Volumen_Pedidos_Turno_Sucursal]', 'V') IS NOT NULL
    DROP VIEW [NULL_EXEPTION].[BI_Volumen_Pedidos_Turno_Sucursal];
IF OBJECT_ID('[NULL_EXEPTION].[BI_Conversion_Pedidos_Estado]', 'V') IS NOT NULL
    DROP VIEW [NULL_EXEPTION].[BI_Conversion_Pedidos_Estado];
IF OBJECT_ID('[NULL_EXEPTION].[BI_Tiempo_Fabricacion_Promedio]', 'V') IS NOT NULL
    DROP VIEW [NULL_EXEPTION].[BI_Tiempo_Fabricacion_Promedio];
IF OBJECT_ID('[NULL_EXEPTION].[BI_Promedio_Compras_Mensual]', 'V') IS NOT NULL
    DROP VIEW [NULL_EXEPTION].[BI_Promedio_Compras_Mensual];
IF OBJECT_ID('[NULL_EXEPTION].[BI_Compras_Tipo_Material]', 'V') IS NOT NULL
    DROP VIEW [NULL_EXEPTION].[BI_Compras_Tipo_Material];
IF OBJECT_ID('[NULL_EXEPTION].[BI_Cumplimiento_Envios]', 'V') IS NOT NULL
    DROP VIEW [NULL_EXEPTION].[BI_Cumplimiento_Envios];
IF OBJECT_ID('[NULL_EXEPTION].[BI_Top3_Localidades_Costo_Envio]', 'V') IS NOT NULL
    DROP VIEW [NULL_EXEPTION].[BI_Top3_Localidades_Costo_Envio];

PRINT '**** Vistas BI existentes eliminadas (si existían) ****'
GO

-- Creación de tablas dimensionales


-- VER QUE COSAS SON REALMENTE NOT NULL Y QUE COSAS SON NULL

CREATE TABLE [NULL_EXEPTION].[BI_Dim_Tiempo]
(
    [id]           BIGINT NOT NULL IDENTITY,
    [anio]         INT    NOT NULL,
    [cuatrimestre] INT    NOT NULL,
    [mes]          INT    NOT NULL
);

CREATE TABLE [NULL_EXEPTION].[BI_Dim_Ubicacion]
(
    [id]        BIGINT        NOT NULL IDENTITY,
    [provincia] NVARCHAR(255) NOT NULL,
    [localidad] NVARCHAR(255) NOT NULL,
    [direccion] NVARCHAR(255) NOT NULL
);

CREATE TABLE [NULL_EXEPTION].[BI_Dim_Cliente]
(
    [id]           BIGINT       NOT NULL IDENTITY,
    [rango_etario] NVARCHAR(50) NOT NULL -- REVISAR COMO SE PUEDE HACER PARA QUE SEA UN RANGO
);

CREATE TABLE [NULL_EXEPTION].[BI_Dim_Turno]
(
    [id]          BIGINT       NOT NULL IDENTITY,
    [turno]       NVARCHAR(50) NOT NULL,
    [hora_inicio] TIME         NOT NULL,
    [hora_fin]    TIME         NOT NULL
);

CREATE TABLE [NULL_EXEPTION].[BI_Dim_Modelo]
(
    [id]            BIGINT        NOT NULL IDENTITY,
    [modelo_nombre] NVARCHAR(255) NOT NULL,
    [modelo_codigo] NVARCHAR(255) NOT NULL
);

CREATE TABLE [NULL_EXEPTION].[BI_Dim_Estado_Pedido]
(
    [id]            BIGINT        NOT NULL IDENTITY,
    [estado_nombre] NVARCHAR(255) NOT NULL
);

CREATE TABLE [NULL_EXEPTION].[BI_Dim_Tipo_Material]
(
    [id]            BIGINT       NOT NULL IDENTITY,
    [tipo_material] NVARCHAR(50) NOT NULL
);


------------------HASTA ACA SCRIPT ANTERIOR REVISAR

-- Creación de tabla de hechos
/*
CREATE TABLE [NULL_EXEPTION].[BI_Fact_Ventas] (
    [id] BIGINT NOT NULL IDENTITY,
    [tiempo_id] BIGINT NOT NULL,
    [ubicacion_id] BIGINT NOT NULL,
    [cliente_id] BIGINT NOT NULL,
    [turno_id] BIGINT NOT NULL,
    [modelo_id] BIGINT NOT NULL,
    [estado_id] BIGINT NOT NULL,
    [tipo_material_id] BIGINT,
    [cantidad_pedidos] BIGINT,
    [cantidad_facturas] BIGINT,
    [total_ingresos] DECIMAL(18,2),
    [total_egresos] DECIMAL(18,2),
    [ganancias] DECIMAL(18,2),
    [factura_promedio] DECIMAL(18,2),
    [tiempo_fabricacion_promedio] DECIMAL(18,2),
    [porcentaje_conversion] DECIMAL(5,2),
    [porcentaje_envios_cumplidos] DECIMAL(5,2),
    [costo_envio_promedio] DECIMAL(18,2),
);*/

CREATE TABLE [NULL_EXEPTION].[BI_Fact_Ventas]
(
    [id]                          BIGINT IDENTITY,
    [tiempo_id]                   BIGINT NOT NULL,
    [ubicacion_id]                BIGINT NOT NULL,
    [cliente_id]                  BIGINT NOT NULL,
    [turno_id]                    BIGINT NOT NULL,
    [modelo_id]                   BIGINT NOT NULL,
    [estado_id]                   BIGINT NOT NULL,
    [cantidad_facturas]           BIGINT,
    [total_ingresos]              DECIMAL(18, 2),
    [tiempo_fabricacion_promedio] DECIMAL(18, 2)
);

CREATE TABLE [NULL_EXEPTION].[BI_Fact_Compras]
(
    [id]               BIGINT IDENTITY,
    [tiempo_id]        BIGINT NOT NULL,
    [ubicacion_id]     BIGINT NOT NULL,
    [tipo_material_id] BIGINT NOT NULL,
    [total_egresos]    DECIMAL(18, 2),
    [promedio_compras] DECIMAL(18, 2)
);

CREATE TABLE [NULL_EXEPTION].[BI_Fact_Envios]
(
    [id]                          BIGINT IDENTITY,
    [tiempo_id]                   BIGINT NOT NULL,
    [ubicacion_id]                BIGINT NOT NULL,
    [porcentaje_envios_cumplidos] DECIMAL(5, 2),
    [costo_envio_promedio]        DECIMAL(18, 2)
);

-- Creacion de claves primarias

-- tablas dimensionales
ALTER TABLE [NULL_EXEPTION].[BI_Dim_Tiempo]
    ADD CONSTRAINT PK_BI_Dim_Tiempo PRIMARY KEY CLUSTERED (id);
ALTER TABLE [NULL_EXEPTION].[BI_Dim_Ubicacion]
    ADD CONSTRAINT PK_BI_Dim_Ubicacion PRIMARY KEY CLUSTERED (id);
ALTER TABLE [NULL_EXEPTION].[BI_Dim_Cliente]
    ADD CONSTRAINT PK_BI_Dim_Cliente PRIMARY KEY CLUSTERED (id);
ALTER TABLE [NULL_EXEPTION].[BI_Dim_Turno]
    ADD CONSTRAINT PK_BI_Dim_Turno PRIMARY KEY CLUSTERED (id);
ALTER TABLE [NULL_EXEPTION].[BI_Dim_Modelo]
    ADD CONSTRAINT PK_BI_Dim_Modelo PRIMARY KEY CLUSTERED (id);
ALTER TABLE [NULL_EXEPTION].[BI_Dim_Estado_Pedido]
    ADD CONSTRAINT PK_BI_Dim_Estado_Pedido PRIMARY KEY CLUSTERED (id);
ALTER TABLE [NULL_EXEPTION].[BI_Dim_Tipo_Material]
    ADD CONSTRAINT PK_BI_Dim_Tipo_Material PRIMARY KEY CLUSTERED (id);

-- tablas de hechos
ALTER TABLE [NULL_EXEPTION].[BI_Fact_Ventas]
    ADD CONSTRAINT PK_BI_Fact_Ventas PRIMARY KEY CLUSTERED (id);
ALTER TABLE [NULL_EXEPTION].[BI_Fact_Compras]
    ADD CONSTRAINT PK_BI_Fact_Compras PRIMARY KEY CLUSTERED (id);
ALTER TABLE [NULL_EXEPTION].[BI_Fact_Envios]
    ADD CONSTRAINT PK_BI_Fact_Envios PRIMARY KEY CLUSTERED (id);



-- Creación de claves foráneas

-- Ventas

ALTER TABLE [NULL_EXEPTION].[BI_Fact_Ventas]
    ADD CONSTRAINT FK_BI_Fact_Ventas_Tiempo
        FOREIGN KEY (tiempo_id) REFERENCES [NULL_EXEPTION].[BI_Dim_Tiempo] (id);

ALTER TABLE [NULL_EXEPTION].[BI_Fact_Ventas]
    ADD CONSTRAINT FK_BI_Fact_Ventas_Ubicacion
        FOREIGN KEY (ubicacion_id) REFERENCES [NULL_EXEPTION].[BI_Dim_Ubicacion] (id);

ALTER TABLE [NULL_EXEPTION].[BI_Fact_Ventas]
    ADD CONSTRAINT FK_BI_Fact_Ventas_Cliente
        FOREIGN KEY (cliente_id) REFERENCES [NULL_EXEPTION].[BI_Dim_Cliente] (id);

ALTER TABLE [NULL_EXEPTION].[BI_Fact_Ventas]
    ADD CONSTRAINT FK_BI_Fact_Ventas_Turno
        FOREIGN KEY (turno_id) REFERENCES [NULL_EXEPTION].[BI_Dim_Turno] (id);

ALTER TABLE [NULL_EXEPTION].[BI_Fact_Ventas]
    ADD CONSTRAINT FK_BI_Fact_Ventas_Modelo
        FOREIGN KEY (modelo_id) REFERENCES [NULL_EXEPTION].[BI_Dim_Modelo] (id);

ALTER TABLE [NULL_EXEPTION].[BI_Fact_Ventas]
    ADD CONSTRAINT FK_BI_Fact_Ventas_Estado
        FOREIGN KEY (estado_id) REFERENCES [NULL_EXEPTION].[BI_Dim_Estado_Pedido] (id);

-- Compras

ALTER TABLE [NULL_EXEPTION].[BI_Fact_Compras]
    ADD CONSTRAINT FK_BI_Fact_Compras_Tiempo
        FOREIGN KEY (tiempo_id) REFERENCES [NULL_EXEPTION].[BI_Dim_Tiempo] (id);

ALTER TABLE [NULL_EXEPTION].[BI_Fact_Compras]
    ADD CONSTRAINT FK_BI_Fact_Compras_Ubicacion
        FOREIGN KEY (ubicacion_id) REFERENCES [NULL_EXEPTION].[BI_Dim_Ubicacion] (id);

ALTER TABLE [NULL_EXEPTION].[BI_Fact_Compras]
    ADD CONSTRAINT FK_BI_Fact_Compras_TipoMaterial
        FOREIGN KEY (tipo_material_id) REFERENCES [NULL_EXEPTION].[BI_Dim_Tipo_Material] (id);

-- Envíos

ALTER TABLE [NULL_EXEPTION].[BI_Fact_Envios]
    ADD CONSTRAINT FK_BI_Fact_Envios_Tiempo
        FOREIGN KEY (tiempo_id) REFERENCES [NULL_EXEPTION].[BI_Dim_Tiempo] (id);

ALTER TABLE [NULL_EXEPTION].[BI_Fact_Envios]
    ADD CONSTRAINT FK_BI_Fact_Envios_Ubicacion
        FOREIGN KEY (ubicacion_id) REFERENCES [NULL_EXEPTION].[BI_Dim_Ubicacion] (id);



PRINT '**** Tablas del modelo BI creadas correctamente ****'
GO

-- Poblar tablas dimensionales
PRINT '**** Poblando tablas dimensionales ****'
GO

-- Dimensión Tiempo
INSERT INTO [NULL_EXEPTION].[BI_Dim_Tiempo] (anio, cuatrimestre, mes)
SELECT DISTINCT YEAR(p.fecha_hora)  as anio,
                CASE
                    WHEN MONTH(p.fecha_hora) BETWEEN 1 AND 4 THEN 1
                    WHEN MONTH(p.fecha_hora) BETWEEN 5 AND 8 THEN 2
                    ELSE 3
                    END             as cuatrimestre,
                MONTH(p.fecha_hora) as mes
FROM [NULL_EXEPTION].[Pedido] p
UNION
SELECT DISTINCT YEAR(c.fecha)  as anio,
                CASE
                    WHEN MONTH(c.fecha) BETWEEN 1 AND 4 THEN 1
                    WHEN MONTH(c.fecha) BETWEEN 5 AND 8 THEN 2
                    ELSE 3
                    END        as cuatrimestre,
                MONTH(c.fecha) as mes
FROM [NULL_EXEPTION].[Compra] c;

-- Dimensión Ubicación
INSERT INTO [NULL_EXEPTION].[BI_Dim_Ubicacion] (provincia, localidad, direccion)
SELECT p.nombre    as provincia,
       l.nombre    as localidad,
       s.direccion as direccion
FROM [NULL_EXEPTION].[Sucursal] s
         JOIN [NULL_EXEPTION].[Localidad] l ON s.localidad_id = l.id
         JOIN [NULL_EXEPTION].[Provincia] p ON l.provincia_id = p.id;

-- Dimensión Cliente (Rango Etario)
INSERT INTO [NULL_EXEPTION].[BI_Dim_Cliente] (rango_etario)
VALUES ('<25'),
       ('25-35'),
       ('35-50'),
       ('>50');

-- Dimensión Turno
INSERT INTO [NULL_EXEPTION].[BI_Dim_Turno] (turno, hora_inicio, hora_fin)
VALUES ('08:00 - 14:00', '08:00:00', '14:00:00'),
       ('14:00 - 20:00', '14:00:00', '20:00:00');

-- Dimensión Modelo
INSERT INTO [NULL_EXEPTION].[BI_Dim_Modelo] (modelo_nombre, modelo_codigo)
SELECT nombre, id
FROM [NULL_EXEPTION].[Modelo];

-- Dimensión Estado Pedido
INSERT INTO [NULL_EXEPTION].[BI_Dim_Estado_Pedido] (estado_nombre)
SELECT nombre
FROM [NULL_EXEPTION].[Estado];

-- Dimensión Tipo Material
INSERT INTO [NULL_EXEPTION].[BI_Dim_Tipo_Material] (tipo_material)
VALUES ('Tela'),
       ('Madera'),
       ('Relleno');

PRINT '**** Tablas dimensionales pobladas correctamente ****'
GO

-- Poblar tablas de hechos
PRINT '**** Poblando tablas de hechos ****'
GO

-- Poblar tabla de Ventas
PRINT '**** Tabla Fact_Ventas ****'
GO

INSERT INTO [NULL_EXEPTION].[BI_Fact_Ventas] (tiempo_id,
                                              ubicacion_id,
                                              cliente_id,
                                              turno_id,
                                              modelo_id,
                                              estado_id,
                                              cantidad_facturas,
                                              total_ingresos,
                                              tiempo_fabricacion_promedio)
SELECT t.id                                           AS tiempo_id,
       u.id                                           AS ubicacion_id,
       cr.id                                          AS cliente_rango_id,
       tu.id                                          AS turno_id,
       mo.id                                          AS modelo_id,
       ep_dim.id                                      AS estado_id,
       COUNT(f.id)                                    AS cantidad_facturas,
       SUM(isnull(f.precio_total, 0))                 AS total_ingresos,
       AVG(DATEDIFF(DAY, p.fecha_hora, ISNULL(f.fecha_hora, p.fecha_hora))) AS tiempo_fabricacion_promedio
FROM [NULL_EXEPTION].[Pedido] p
         LEFT JOIN [NULL_EXEPTION].[Factura] f ON f.pedido_id = p.id
         JOIN [NULL_EXEPTION].[Estado_X_Pedido] ep ON p.id = ep.pedido_id
         JOIN [NULL_EXEPTION].[Estado] e ON ep.estado_id = e.id
         JOIN [NULL_EXEPTION].[Cliente] c ON p.cliente_id = c.id
         JOIN [NULL_EXEPTION].[Sucursal] s ON p.sucursal_id = s.id
         JOIN [NULL_EXEPTION].[Localidad] l ON s.localidad_id = l.id
         JOIN [NULL_EXEPTION].[Provincia] pr ON l.provincia_id = pr.id

-- JOIN directo a DetallePedido y Sillon
         JOIN [NULL_EXEPTION].[DetallePedido] dp ON dp.pedido_id = p.id
         JOIN [NULL_EXEPTION].[Sillon] si ON dp.sillon_id = si.id
         JOIN [NULL_EXEPTION].[Modelo] m ON si.modelo_id = m.id

-- Dimensiones
         LEFT JOIN [NULL_EXEPTION].[BI_Dim_Tiempo] t
              ON t.anio = YEAR(p.fecha_hora) AND t.mes = MONTH(p.fecha_hora)

         JOIN [NULL_EXEPTION].[BI_Dim_Ubicacion] u
              ON u.direccion = s.direccion AND u.localidad = l.nombre AND u.provincia = pr.nombre

         JOIN [NULL_EXEPTION].[BI_Dim_Cliente] cr
              ON cr.rango_etario = CASE
                                       WHEN DATEDIFF(YEAR, c.fecha_nacimiento, GETDATE()) < 25 THEN '<25'
                                       WHEN DATEDIFF(YEAR, c.fecha_nacimiento, GETDATE()) BETWEEN 25 AND 35 THEN '25-35'
                                       WHEN DATEDIFF(YEAR, c.fecha_nacimiento, GETDATE()) BETWEEN 36 AND 50 THEN '35-50'
                                       ELSE '>50'
                  END

         JOIN [NULL_EXEPTION].[BI_Dim_Turno] tu
              ON CAST(p.fecha_hora AS TIME) BETWEEN tu.hora_inicio AND tu.hora_fin

         JOIN [NULL_EXEPTION].[BI_Dim_Modelo] mo
              ON mo.modelo_nombre = m.nombre

         JOIN [NULL_EXEPTION].[BI_Dim_Estado_Pedido] ep_dim ON ep_dim.estado_nombre = e.nombre

GROUP BY t.id, u.id, cr.id, tu.id, mo.id, ep_dim.id;


-- Poblar tabla de Compras
PRINT '**** Poblando BI_Fact_Compras ****'
GO

INSERT INTO [NULL_EXEPTION].[BI_Fact_Compras] (tiempo_id,
                                               ubicacion_id,
                                               tipo_material_id,
                                               total_egresos,
                                               promedio_compras)
SELECT t.id                        AS tiempo_id,
       u.id                        AS ubicacion_id,
       tm.id                       AS tipo_material_id,
       SUM(ISNULL(dc.subtotal, 0)) AS total_egresos,
       AVG(ISNULL(dc.subtotal, 0)) AS promedio_compras
FROM [NULL_EXEPTION].[Compra] c
         JOIN [NULL_EXEPTION].[DetalleCompra] dc ON c.id = dc.compra_id
         JOIN [NULL_EXEPTION].[Material] m ON dc.material_id = m.id

-- JOIN con tipo de material correspondiente
         LEFT JOIN [NULL_EXEPTION].[Tela] te ON m.tela_id = te.id
         LEFT JOIN [NULL_EXEPTION].[Madera] ma ON m.madera_id = ma.id
         LEFT JOIN [NULL_EXEPTION].[Relleno] re ON m.relleno_id = re.id

-- JOIN ubicación
         JOIN [NULL_EXEPTION].[Sucursal] s ON c.sucursal_id = s.id
         JOIN [NULL_EXEPTION].[Localidad] l ON s.localidad_id = l.id
         JOIN [NULL_EXEPTION].[Provincia] p ON l.provincia_id = p.id
         JOIN [NULL_EXEPTION].[BI_Dim_Ubicacion] u
              ON u.direccion = s.direccion AND u.localidad = l.nombre AND u.provincia = p.nombre

-- JOIN tiempo
         JOIN [NULL_EXEPTION].[BI_Dim_Tiempo] t
              ON t.anio = YEAR(c.fecha) AND t.mes = MONTH(c.fecha)

-- JOIN tipo de material (lógico)
         JOIN [NULL_EXEPTION].[BI_Dim_Tipo_Material] tm ON tm.tipo_material =
                                                           CASE
                                                               WHEN m.tela_id IS NOT NULL THEN 'Tela'
                                                               WHEN m.madera_id IS NOT NULL THEN 'Madera'
                                                               WHEN m.relleno_id IS NOT NULL THEN 'Relleno'
                                                               END

GROUP BY t.id, u.id, tm.id;

-- Poblar tabla de Envios
PRINT '**** Tabla Fact_Envios ****'
GO

INSERT INTO [NULL_EXEPTION].[BI_Fact_Envios] (
    tiempo_id,
    ubicacion_id,
    porcentaje_envios_cumplidos,
    costo_envio_promedio
)
SELECT
    t.id AS tiempo_id,
    u.id AS ubicacion_id,

    -- Porcentaje de envíos cumplidos en tiempo (fecha_entrega <= fecha_programada)
    CAST(SUM(CASE
                 WHEN e.fecha_entrega IS NOT NULL AND e.fecha_entrega <= e.fecha_programada THEN 1
                 ELSE 0
        END) * 100.0 AS FLOAT) / NULLIF(COUNT(e.id), 0) AS porcentaje_envios_cumplidos,

    -- Promedio del costo de envío
    AVG(ISNULL(e.total, 0)) AS costo_envio_promedio

FROM [NULL_EXEPTION].[Envio] e
         JOIN [NULL_EXEPTION].[Factura] f ON e.factura_id = f.id
         JOIN [NULL_EXEPTION].[Sucursal] s ON f.sucursal_id = s.id
         JOIN [NULL_EXEPTION].[Localidad] l ON s.localidad_id = l.id
         JOIN [NULL_EXEPTION].[Provincia] p ON l.provincia_id = p.id

         JOIN [NULL_EXEPTION].[BI_Dim_Ubicacion] u
              ON u.direccion = s.direccion AND u.localidad = l.nombre AND u.provincia = p.nombre

         JOIN [NULL_EXEPTION].[BI_Dim_Tiempo] t
              ON t.anio = YEAR(e.fecha_programada) AND t.mes = MONTH(e.fecha_programada)

GROUP BY t.id, u.id;


PRINT '**** Tablas de hechos poblada correctamente ****'
GO

-- Creación de vistas para los indicadores requeridos
PRINT '**** Creando vistas para indicadores ****'
GO

-- 1. Ganancias por mes y sucursal
CREATE VIEW [NULL_EXEPTION].[BI_Ganancias_Mensuales_Sucursal] AS
SELECT u.direccion,
       t.anio,
       t.mes,
       SUM(ISNULL(fv.total_ingresos, 0) - ISNULL(fc.total_egresos, 0)) AS ganancias
FROM [NULL_EXEPTION].[BI_Dim_Tiempo] t
         JOIN [NULL_EXEPTiON].[BI_Dim_Ubicacion] u ON 1 = 1
         LEFT JOIN [NULL_EXEPTiON].[BI_Fact_Ventas] fv
                   ON fv.tiempo_id = t.id AND fv.ubicacion_id = u.id
         LEFT JOIN [NULL_EXEPTiON].[BI_Fact_Compras] fc
                   ON fc.tiempo_id = t.id AND fc.ubicacion_id = u.id
GROUP BY t.anio, t.mes, u.direccion;
GO

-- 2. Factura promedio mensual por provincia y cuatrimestre
CREATE VIEW [NULL_EXEPTION].[BI_Factura_Promedio_Provincia_Cuatrimestre] AS
SELECT t.anio,
       t.cuatrimestre,
       u.provincia,
       AVG(fv.total_ingresos) AS factura_promedio
FROM [NULL_EXEPTION].[BI_Fact_Ventas] fv
         JOIN [NULL_EXEPTION].[BI_Dim_Tiempo] t ON fv.tiempo_id = t.id
         JOIN [NULL_EXEPTION].[BI_Dim_Ubicacion] u ON fv.ubicacion_id = u.id
GROUP BY t.anio, t.cuatrimestre, u.provincia;
GO
-- 3. Top 3 modelos por ventas por cuatrimestre, localidad y rango etario
CREATE VIEW [NULL_EXEPTION].[BI_Top3_Modelos_Ventas] AS
WITH RankedModels AS (SELECT t.anio,
                             t.cuatrimestre,
                             u.localidad,
                             c.rango_etario,
                             m.modelo_nombre,
                             SUM(fv.cantidad_facturas) AS cantidad_ventas,
                             ROW_NUMBER() OVER (
                                 PARTITION BY t.anio, t.cuatrimestre, u.localidad, c.rango_etario
                                 ORDER BY SUM(fv.cantidad_facturas) DESC
                                 )                     AS rank
                      FROM [NULL_EXEPTION].[BI_Fact_Ventas] fv
                               JOIN [NULL_EXEPTION].[BI_Dim_Tiempo] t ON fv.tiempo_id = t.id
                               JOIN [NULL_EXEPTION].[BI_Dim_Ubicacion] u ON fv.ubicacion_id = u.id
                               JOIN [NULL_EXEPTION].[BI_Dim_Cliente] c ON fv.cliente_id = c.id
                               JOIN [NULL_EXEPTION].[BI_Dim_Modelo] m ON fv.modelo_id = m.id
                      GROUP BY t.anio, t.cuatrimestre, u.localidad, c.rango_etario, m.modelo_nombre)
SELECT anio,
       cuatrimestre,
       localidad,
       rango_etario,
       modelo_nombre,
       cantidad_ventas
FROM RankedModels
WHERE rank <= 3;
GO

-- 4. Volumen de pedidos por turno, sucursal y mes
CREATE VIEW [NULL_EXEPTION].[BI_Volumen_Pedidos_Turno_Sucursal] AS
SELECT t.anio,
       t.mes,
       u.direccion,
       tu.turno,
       COUNT(*) AS cantidad_pedidos
FROM [NULL_EXEPTION].[BI_Fact_Ventas] fv
         JOIN [NULL_EXEPTION].[BI_Dim_Tiempo] t ON fv.tiempo_id = t.id
         JOIN [NULL_EXEPTION].[BI_Dim_Ubicacion] u ON fv.ubicacion_id = u.id
         JOIN [NULL_EXEPTION].[BI_Dim_Turno] tu ON fv.turno_id = tu.id
GROUP BY t.anio, t.mes, u.direccion, tu.turno;
GO

-- 5. Conversión de pedidos por estado, cuatrimestre y sucursal
CREATE VIEW [NULL_EXEPTION].[BI_Conversion_Pedidos_Estado] AS
SELECT t.anio,
       t.cuatrimestre,
       u.direccion,
       e.estado_nombre,
       COUNT(*)                                                              AS cantidad_pedidos,
       COUNT(*) * 100.0 /
       SUM(COUNT(*)) OVER (PARTITION BY t.anio, t.cuatrimestre, u.direccion) AS porcentaje
FROM [NULL_EXEPTION].[BI_Fact_Ventas] fv
         JOIN [NULL_EXEPTION].[BI_Dim_Tiempo] t ON fv.tiempo_id = t.id
         JOIN [NULL_EXEPTION].[BI_Dim_Ubicacion] u ON fv.ubicacion_id = u.id
         JOIN [NULL_EXEPTION].[BI_Dim_Estado_Pedido] e ON fv.estado_id = e.id
GROUP BY t.anio, t.cuatrimestre, u.direccion, e.estado_nombre;
GO

-- 6. Tiempo promedio de fabricación por sucursal y cuatrimestre
CREATE VIEW [NULL_EXEPTION].[BI_Tiempo_Fabricacion_Promedio] AS
SELECT t.anio,
       t.cuatrimestre,
       u.direccion,
       AVG(fv.tiempo_fabricacion_promedio) AS tiempo_promedio_dias
FROM [NULL_EXEPTION].[BI_Fact_Ventas] fv
         JOIN [NULL_EXEPTION].[BI_Dim_Tiempo] t ON fv.tiempo_id = t.id
         JOIN [NULL_EXEPTION].[BI_Dim_Ubicacion] u ON fv.ubicacion_id = u.id
GROUP BY t.anio, t.cuatrimestre, u.direccion;
GO

-- 7. Promedio de compras por mes
CREATE VIEW [NULL_EXEPTION].[BI_Promedio_Compras_Mensual] AS
SELECT t.anio,
       t.mes,
       AVG(fc.total_egresos) AS promedio_compras
FROM [NULL_EXEPTION].[BI_Fact_Compras] fc
         JOIN [NULL_EXEPTION].[BI_Dim_Tiempo] t ON fc.tiempo_id = t.id
GROUP BY t.anio, t.mes;
GO

-- 8. Compras por tipo de material, sucursal y cuatrimestre
CREATE VIEW [NULL_EXEPTION].[BI_Compras_Tipo_Material] AS
SELECT t.anio,
       t.cuatrimestre,
       u.direccion,
       tm.tipo_material,
       SUM(fc.total_egresos) AS total_compras
FROM [NULL_EXEPTION].[BI_Fact_Compras] fc
         JOIN [NULL_EXEPTION].[BI_Dim_Tiempo] t ON fc.tiempo_id = t.id
         JOIN [NULL_EXEPTION].[BI_Dim_Ubicacion] u ON fc.ubicacion_id = u.id
         JOIN [NULL_EXEPTION].[BI_Dim_Tipo_Material] tm ON fc.tipo_material_id = tm.id
GROUP BY t.anio, t.cuatrimestre, u.direccion, tm.tipo_material;
GO

-- 9. Porcentaje de cumplimiento de envíos por mes
CREATE VIEW [NULL_EXEPTION].[BI_Cumplimiento_Envios] AS
SELECT t.anio,
       t.mes,
       AVG(fe.porcentaje_envios_cumplidos) AS porcentaje_cumplimiento
FROM [NULL_EXEPTION].[BI_Fact_Envios] fe
         JOIN [NULL_EXEPTION].[BI_Dim_Tiempo] t ON fe.tiempo_id = t.id
GROUP BY t.anio, t.mes;
GO

-- 10. Top 3 localidades con mayor costo de envío promedio
CREATE VIEW [NULL_EXEPTION].[BI_Top3_Localidades_Costo_Envio] AS
WITH LocalidadCostos AS (SELECT u.localidad,
                                AVG(fe.costo_envio_promedio)                                   AS costo_promedio,
                                ROW_NUMBER() OVER (ORDER BY AVG(fe.costo_envio_promedio) DESC) AS rank
                         FROM [NULL_EXEPTION].[BI_Fact_Envios] fe
                                  JOIN [NULL_EXEPTION].[BI_Dim_Ubicacion] u ON fe.ubicacion_id = u.id
                         GROUP BY u.localidad)
SELECT localidad,
       costo_promedio
FROM LocalidadCostos
WHERE rank <= 3;
GO


PRINT '**** Vistas creadas correctamente ****'
GO

PRINT '**** Modelo de BI creado y poblado exitosamente ****'
GO
