USE [GD1C2025]
GO

PRINT '**** Iniciando creación del modelo de BI ****'
GO

-- Verificar y eliminar tablas BI existentes
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'BI_Fact_Ventas' AND schema_id = SCHEMA_ID('NULL_EXEPTION'))
    DROP TABLE [NULL_EXEPTION].[BI_Fact_Ventas];

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'BI_Dim_Tiempo' AND schema_id = SCHEMA_ID('NULL_EXEPTION'))
    DROP TABLE [NULL_EXEPTION].[BI_Dim_Tiempo];

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'BI_Dim_Ubicacion' AND schema_id = SCHEMA_ID('NULL_EXEPTION'))
    DROP TABLE [NULL_EXEPTION].[BI_Dim_Ubicacion];

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'BI_Dim_Cliente' AND schema_id = SCHEMA_ID('NULL_EXEPTION'))
    DROP TABLE [NULL_EXEPTION].[BI_Dim_Cliente];

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'BI_Dim_Turno' AND schema_id = SCHEMA_ID('NULL_EXEPTION'))
    DROP TABLE [NULL_EXEPTION].[BI_Dim_Turno];

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'BI_Dim_Modelo' AND schema_id = SCHEMA_ID('NULL_EXEPTION'))
    DROP TABLE [NULL_EXEPTION].[BI_Dim_Modelo];

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'BI_Dim_Estado_Pedido' AND schema_id = SCHEMA_ID('NULL_EXEPTION'))
    DROP TABLE [NULL_EXEPTION].[BI_Dim_Estado_Pedido];

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'BI_Dim_Tipo_Material' AND schema_id = SCHEMA_ID('NULL_EXEPTION'))
    DROP TABLE [NULL_EXEPTION].[BI_Dim_Tipo_Material];

PRINT '**** Tablas BI existentes eliminadas (si existían) ****'
GO

-- Creación de tablas dimensionales


-- VER QUE COSAS SON REALMENTE NOT NULL Y QUE COSAS SON NULL

CREATE TABLE [NULL_EXEPTION].[BI_Dim_Tiempo] (
    [id] BIGINT NOT NULL IDENTITY,
    [anio] YEAR NOT NULL,
    [cuatrimestre] INT NOT NULL,
    [mes] INT NOT NULL,
    [fecha] DATE NOT NULL
);

CREATE TABLE [NULL_EXEPTION].[BI_Dim_Ubicacion] (
    [id] BIGINT NOT NULL IDENTITY,
    [provincia] NVARCHAR(255) NOT NULL,
    [localidad] NVARCHAR(255) NOT NULL
);

CREATE TABLE [NULL_EXEPTION].[BI_Dim_Cliente] (
    [id] BIGINT NOT NULL IDENTITY,
    [rango_etario] NVARCHAR(50) NOT NULL -- REVISAR COMO SE PUEDE HACER PARA QUE SEA UN RANGO
);

CREATE TABLE [NULL_EXEPTION].[BI_Dim_Turno] (
    [id] BIGINT NOT NULL IDENTITY,
    [turno] NVARCHAR(50) NOT NULL,
    [hora_inicio] TIME NOT NULL,
    [hora_fin] TIME NOT NULL
);

CREATE TABLE [NULL_EXEPTION].[BI_Dim_Modelo] (
    [id] BIGINT NOT NULL IDENTITY,
    [modelo_nombre] NVARCHAR(255) NOT NULL,
    [modelo_codigo] NVARCHAR(255) NOT NULL
);

CREATE TABLE [NULL_EXEPTION].[BI_Dim_Estado_Pedido] (
    [id] BIGINT NOT NULL IDENTITY,
    [estado_nombre] NVARCHAR(255) NOT NULL
);

CREATE TABLE [NULL_EXEPTION].[BI_Dim_Tipo_Material] (
    [id] BIGINT NOT NULL IDENTITY,
    [tipo_material] NVARCHAR(50) NOT NULL
);


------------------HASTA ACA SCRIPT ANTERIOR REVISAR

-- Creación de tabla de hechos
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
);

PRINT '**** Tablas del modelo BI creadas correctamente ****'
GO

-- Poblar tablas dimensionales
PRINT '**** Poblando tablas dimensionales ****'
GO

-- Dimensión Tiempo
INSERT INTO [NULL_EXEPTION].[BI_Dim_Tiempo] (anio, cuatrimestre, mes, fecha)
SELECT DISTINCT
    YEAR(p.fecha_hora) as anio,
    CASE 
        WHEN MONTH(p.fecha_hora) BETWEEN 1 AND 4 THEN 1
        WHEN MONTH(p.fecha_hora) BETWEEN 5 AND 8 THEN 2
        ELSE 3
    END as cuatrimestre,
    MONTH(p.fecha_hora) as mes,
    CAST(p.fecha_hora AS DATE) as fecha
FROM [NULL_EXEPTION].[Pedido] p
UNION
SELECT DISTINCT
    YEAR(c.fecha) as anio,
    CASE 
        WHEN MONTH(c.fecha) BETWEEN 1 AND 4 THEN 1
        WHEN MONTH(c.fecha) BETWEEN 5 AND 8 THEN 2
        ELSE 3
    END as cuatrimestre,
    MONTH(c.fecha) as mes,
    CAST(c.fecha AS DATE) as fecha
FROM [NULL_EXEPTION].[Compra] c;

-- Dimensión Ubicación
INSERT INTO [NULL_EXEPTION].[BI_Dim_Ubicacion] (provincia, localidad, sucursal_id, sucursal_nombre)
SELECT 
    p.nombre as provincia,
    l.nombre as localidad,
    s.id as sucursal_id,
    s.nombre as sucursal_nombre
FROM [NULL_EXEPTION].[Sucursal] s
JOIN [NULL_EXEPTION].[Localidad] l ON s.localidad_id = l.id
JOIN [NULL_EXEPTION].[Provincia] p ON l.provincia_id = p.id;

-- Dimensión Cliente (Rango Etario)
INSERT INTO [NULL_EXEPTION].[BI_Dim_Cliente] (rango_etario)
VALUES 
    ('<25'),
    ('25-35'),
    ('35-50'),
    ('>50');

-- Dimensión Turno
INSERT INTO [NULL_EXEPTION].[BI_Dim_Turno] (turno, hora_inicio, hora_fin)
VALUES 
    ('08:00 - 14:00', '08:00:00', '14:00:00'),
    ('14:00 - 20:00', '14:00:00', '20:00:00');

-- Dimensión Modelo
INSERT INTO [NULL_EXEPTION].[BI_Dim_Modelo] (modelo_nombre, modelo_codigo)
SELECT nombre, nombre FROM [NULL_EXEPTION].[Modelo];

-- Dimensión Estado Pedido
INSERT INTO [NULL_EXEPTION].[BI_Dim_Estado_Pedido] (estado_nombre)
SELECT nombre FROM [NULL_EXEPTION].[Estado];

-- Dimensión Tipo Material
INSERT INTO [NULL_EXEPTION].[BI_Dim_Tipo_Material] (tipo_material)
VALUES 
    ('Tela'),
    ('Madera'),
    ('Relleno');

PRINT '**** Tablas dimensionales pobladas correctamente ****'
GO

-- Poblar tabla de hechos
PRINT '**** Poblando tabla de hechos ****'
GO

INSERT INTO [NULL_EXEPTION].[BI_Fact_Ventas] (
    tiempo_id, ubicacion_id, cliente_id, turno_id, modelo_id, estado_id, tipo_material_id,
    cantidad_pedidos, cantidad_facturas, total_ingresos, total_egresos, ganancias,
    factura_promedio, tiempo_fabricacion_promedio, porcentaje_conversion,
    porcentaje_envios_cumplidos, costo_envio_promedio
)
-- Consulta compleja que agrupa y calcula todos los indicadores necesarios
-- Aquí se muestra un esquema básico, la implementación completa requeriría
-- varias subconsultas y joins para calcular cada métrica
SELECT 
    t.tiempo_id,
    u.ubicacion_id,
    c.cliente_id,
    tu.turno_id,
    m.modelo_id,
    e.estado_id,
    tm.tipo_material_id,
    -- Métricas calculadas
    COUNT(DISTINCT p.id) as cantidad_pedidos,
    COUNT(DISTINCT f.id) as cantidad_facturas,
    SUM(f.precio_total) as total_ingresos,
    SUM(co.total) as total_egresos,
    SUM(f.precio_total) - SUM(ISNULL(co.total, 0)) as ganancias,
    AVG(f.precio_total) as factura_promedio,
    -- Otras métricas
    NULL as tiempo_fabricacion_promedio,
    NULL as porcentaje_conversion,
    NULL as porcentaje_envios_cumplidos,
    NULL as costo_envio_promedio
FROM 
    [NULL_EXEPTION].[Pedido] p
JOIN [NULL_EXEPTION].[BI_Dim_Tiempo] t ON 
    YEAR(p.fecha_hora) = t.anio AND 
    MONTH(p.fecha_hora) = t.mes
JOIN [NULL_EXEPTION].[Sucursal] s ON p.sucursal_id = s.id
JOIN [NULL_EXEPTION].[BI_Dim_Ubicacion] u ON 
    s.id = u.sucursal_id
JOIN [NULL_EXEPTION].[Cliente] cl ON p.cliente_id = cl.id
JOIN [NULL_EXEPTION].[BI_Dim_Cliente] c ON 
    CASE 
        WHEN DATEDIFF(YEAR, cl.fecha_nacimiento, GETDATE()) < 25 THEN '<25'
        WHEN DATEDIFF(YEAR, cl.fecha_nacimiento, GETDATE()) BETWEEN 25 AND 35 THEN '25-35'
        WHEN DATEDIFF(YEAR, cl.fecha_nacimiento, GETDATE()) BETWEEN 36 AND 50 THEN '35-50'
        ELSE '>50'
    END = c.rango_etario
JOIN [NULL_EXEPTION].[BI_Dim_Turno] tu ON 
    CASE 
        WHEN DATEPART(HOUR, p.fecha_hora) BETWEEN 8 AND 13 THEN '08:00 - 14:00'
        ELSE '14:00 - 20:00'
    END = tu.turno
LEFT JOIN [NULL_EXEPTION].[Factura] f ON p.id = f.pedido_id
LEFT JOIN [NULL_EXEPTION].[Compra] co ON 
    s.id = co.sucursal_id AND
    YEAR(co.fecha) = t.anio AND 
    MONTH(co.fecha) = t.mes
JOIN [NULL_EXEPTION].[DetallePedido] dp ON p.id = dp.pedido_id
JOIN [NULL_EXEPTION].[Sillon] si ON dp.sillon_id = si.id
JOIN [NULL_EXEPTION].[BI_Dim_Modelo] m ON si.modelo_id = m.modelo_id
JOIN [NULL_EXEPTION].[Estado_X_Pedido] ep ON p.id = ep.pedido_id
JOIN [NULL_EXEPTION].[BI_Dim_Estado_Pedido] e ON ep.estado_id = e.estado_id
LEFT JOIN [NULL_EXEPTION].[Sillon_X_Material] sxm ON si.id = sxm.sillon_id
LEFT JOIN [NULL_EXEPTION].[Material] ma ON sxm.material_id = ma.id
LEFT JOIN [NULL_EXEPTION].[BI_Dim_Tipo_Material] tm ON 
    CASE 
        WHEN ma.tela_id IS NOT NULL THEN 'Tela'
        WHEN ma.madera_id IS NOT NULL THEN 'Madera'
        WHEN ma.relleno_id IS NOT NULL THEN 'Relleno'
    END = tm.tipo_material
GROUP BY 
    t.tiempo_id, u.ubicacion_id, c.cliente_id, tu.turno_id, 
    m.modelo_id, e.estado_id, tm.tipo_material_id;

PRINT '**** Tabla de hechos poblada correctamente ****'
GO

-- Creación de vistas para los indicadores requeridos
PRINT '**** Creando vistas para indicadores ****'
GO

-- 1. Ganancias por mes y sucursal
CREATE VIEW [NULL_EXEPTION].[BI_Ganancias_Mensuales_Sucursal] AS
SELECT 
    t.anio,
    t.mes,
    u.sucursal_nombre,
    SUM(fv.ganancias) as ganancias
FROM 
    [NULL_EXEPTION].[BI_Fact_Ventas] fv
JOIN [NULL_EXEPTION].[BI_Dim_Tiempo] t ON fv.tiempo_id = t.tiempo_id
JOIN [NULL_EXEPTION].[BI_Dim_Ubicacion] u ON fv.ubicacion_id = u.ubicacion_id
GROUP BY 
    t.anio, t.mes, u.sucursal_nombre;
GO 
-- 2. Factura promedio mensual por provincia y cuatrimestre
CREATE VIEW [NULL_EXEPTION].[BI_Factura_Promedio_Provincia_Cuatrimestre] AS
SELECT 
    t.anio,
    t.cuatrimestre,
    u.provincia,
    AVG(fv.factura_promedio) as factura_promedio
FROM 
    [NULL_EXEPTION].[BI_Fact_Ventas] fv
JOIN [NULL_EXEPTION].[BI_Dim_Tiempo] t ON fv.tiempo_id = t.tiempo_id
JOIN [NULL_EXEPTION].[BI_Dim_Ubicacion] u ON fv.ubicacion_id = u.ubicacion_id
GROUP BY 
    t.anio, t.cuatrimestre, u.provincia;
GO
-- 3. Top 3 modelos por ventas por cuatrimestre, localidad y rango etario
CREATE VIEW [NULL_EXEPTION].[BI_Top3_Modelos_Ventas] AS
WITH RankedModels AS (
    SELECT 
        t.anio,
        t.cuatrimestre,
        u.localidad,
        c.rango_etario,
        m.modelo_nombre,
        SUM(fv.cantidad_facturas) as cantidad_ventas,
        ROW_NUMBER() OVER (PARTITION BY t.anio, t.cuatrimestre, u.localidad, c.rango_etario ORDER BY SUM(fv.cantidad_facturas) DESC) as rank
    FROM 
        [NULL_EXEPTION].[BI_Fact_Ventas] fv
    JOIN [NULL_EXEPTION].[BI_Dim_Tiempo] t ON fv.tiempo_id = t.tiempo_id
    JOIN [NULL_EXEPTION].[BI_Dim_Ubicacion] u ON fv.ubicacion_id = u.ubicacion_id
    JOIN [NULL_EXEPTION].[BI_Dim_Cliente] c ON fv.cliente_id = c.cliente_id
    JOIN [NULL_EXEPTION].[BI_Dim_Modelo] m ON fv.modelo_id = m.modelo_id
    GROUP BY 
        t.anio, t.cuatrimestre, u.localidad, c.rango_etario, m.modelo_nombre
)
SELECT 
    anio,
    cuatrimestre,
    localidad,
    rango_etario,
    modelo_nombre,
    cantidad_ventas
FROM 
    RankedModels
WHERE 
    rank <= 3;
GO 
-- 4. Volumen de pedidos por turno, sucursal y mes
CREATE VIEW [NULL_EXEPTION].[BI_Volumen_Pedidos_Turno_Sucursal] AS
SELECT 
    t.anio,
    t.mes,
    u.sucursal_nombre,
    tu.turno,
    SUM(fv.cantidad_pedidos) as cantidad_pedidos
FROM 
    [NULL_EXEPTION].[BI_Fact_Ventas] fv
JOIN [NULL_EXEPTION].[BI_Dim_Tiempo] t ON fv.tiempo_id = t.tiempo_id
JOIN [NULL_EXEPTION].[BI_Dim_Ubicacion] u ON fv.ubicacion_id = u.ubicacion_id
JOIN [NULL_EXEPTION].[BI_Dim_Turno] tu ON fv.turno_id = tu.turno_id
GROUP BY 
    t.anio, t.mes, u.sucursal_nombre, tu.turno;
GO 
-- 5. Conversión de pedidos por estado, cuatrimestre y sucursal
CREATE VIEW [NULL_EXEPTION].[BI_Conversion_Pedidos_Estado] AS
SELECT 
    t.anio,
    t.cuatrimestre,
    u.sucursal_nombre,
    e.estado_nombre,
    SUM(fv.cantidad_pedidos) as cantidad_pedidos,
    (SUM(fv.cantidad_pedidos) * 100.0 / SUM(SUM(fv.cantidad_pedidos)) OVER (PARTITION BY t.anio, t.cuatrimestre, u.sucursal_nombre)) as porcentaje
FROM 
    [NULL_EXEPTION].[BI_Fact_Ventas] fv
JOIN [NULL_EXEPTION].[BI_Dim_Tiempo] t ON fv.tiempo_id = t.tiempo_id
JOIN [NULL_EXEPTION].[BI_Dim_Ubicacion] u ON fv.ubicacion_id = u.ubicacion_id
JOIN [NULL_EXEPTION].[BI_Dim_Estado_Pedido] e ON fv.estado_id = e.estado_id
GROUP BY 
    t.anio, t.cuatrimestre, u.sucursal_nombre, e.estado_nombre;
GO
-- 6. Tiempo promedio de fabricación por sucursal y cuatrimestre
CREATE VIEW [NULL_EXEPTION].[BI_Tiempo_Fabricacion_Promedio] AS
SELECT 
    t.anio,
    t.cuatrimestre,
    u.sucursal_nombre,
    AVG(fv.tiempo_fabricacion_promedio) as tiempo_promedio_dias
FROM 
    [NULL_EXEPTION].[BI_Fact_Ventas] fv
JOIN [NULL_EXEPTION].[BI_Dim_Tiempo] t ON fv.tiempo_id = t.tiempo_id
JOIN [NULL_EXEPTION].[BI_Dim_Ubicacion] u ON fv.ubicacion_id = u.ubicacion_id
GROUP BY 
    t.anio, t.cuatrimestre, u.sucursal_nombre;
GO
-- 7. Promedio de compras por mes
CREATE VIEW [NULL_EXEPTION].[BI_Promedio_Compras_Mensual] AS
SELECT 
    t.anio,
    t.mes,
    AVG(fv.total_egresos) as promedio_compras
FROM 
    [NULL_EXEPTION].[BI_Fact_Ventas] fv
JOIN [NULL_EXEPTION].[BI_Dim_Tiempo] t ON fv.tiempo_id = t.tiempo_id
GROUP BY 
    t.anio, t.mes;
GO
-- 8. Compras por tipo de material, sucursal y cuatrimestre
CREATE VIEW [NULL_EXEPTION].[BI_Compras_Tipo_Material] AS
SELECT 
    t.anio,
    t.cuatrimestre,
    u.sucursal_nombre,
    tm.tipo_material,
    SUM(fv.total_egresos) as total_compras
FROM 
    [NULL_EXEPTION].[BI_Fact_Ventas] fv
JOIN [NULL_EXEPTION].[BI_Dim_Tiempo] t ON fv.tiempo_id = t.tiempo_id
JOIN [NULL_EXEPTION].[BI_Dim_Ubicacion] u ON fv.ubicacion_id = u.ubicacion_id
JOIN [NULL_EXEPTION].[BI_Dim_Tipo_Material] tm ON fv.tipo_material_id = tm.tipo_material_id
GROUP BY 
    t.anio, t.cuatrimestre, u.sucursal_nombre, tm.tipo_material;
GO
-- 9. Porcentaje de cumplimiento de envíos por mes
CREATE VIEW [NULL_EXEPTION].[BI_Cumplimiento_Envios] AS
SELECT 
    t.anio,
    t.mes,
    AVG(fv.porcentaje_envios_cumplidos) as porcentaje_cumplimiento
FROM 
    [NULL_EXEPTION].[BI_Fact_Ventas] fv
JOIN [NULL_EXEPTION].[BI_Dim_Tiempo] t ON fv.tiempo_id = t.tiempo_id
GROUP BY 
    t.anio, t.mes;
Go
-- 10. Top 3 localidades con mayor costo de envío promedio
CREATE VIEW [NULL_EXEPTION].[BI_Top3_Localidades_Costo_Envio] AS
WITH LocalidadCostos AS (
    SELECT 
        u.localidad,
        AVG(fv.costo_envio_promedio) as costo_promedio,
        ROW_NUMBER() OVER (ORDER BY AVG(fv.costo_envio_promedio) DESC) as rank
    FROM 
        [NULL_EXEPTION].[BI_Fact_Ventas] fv
    JOIN [NULL_EXEPTION].[BI_Dim_Ubicacion] u ON fv.ubicacion_id = u.ubicacion_id
    GROUP BY 
        u.localidad
)
SELECT 
    localidad,
    costo_promedio
FROM 
    LocalidadCostos
WHERE 
    rank <= 3;
GO
PRINT '**** Vistas creadas correctamente ****'
GO

PRINT '**** Modelo de BI creado y poblado exitosamente ****'
GO
