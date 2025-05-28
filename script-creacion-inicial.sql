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
CREATE SCHEMA NULL_EXEPTION
GO






