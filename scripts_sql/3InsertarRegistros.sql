--Usar DB_Banco
USE DB_Banco;
GO

--Regsitros Cliente
DECLARE @NombreCliente VARCHAR(30), @ApellidoCliente VARCHAR(30), @CorreoElectronico VARCHAR(60)
SET @NombreCliente = 'Gendor';
SET @ApellidoCliente = 'Skraivok';
SET @CorreoElectronico = 'painted.count@nostramo.com';

INSERT INTO TB_Clientes
(NombreCliente, ApellidoCliente, CorreoElectronico)
VALUES
(@NombreCliente, @ApellidoCliente, @CorreoElectronico),
('Zahariel', 'El Zurias', 'caliban.order@lion.com'),
('Arabella', 'Stern', 'sororita.canoness@ministorum.com')
GO

--Regsitros Prestamo
INSERT INTO TB_Prestamos
(IDCliente, MontoInicial, FechaInicio, PeriodoPrestamo)
VALUES
(1, 800, '2024-10-10', 'Mensual'),
(3, 1500, '2023-05-23', 'Diario')
GO

--Registros Cuenta
INSERT INTO TB_Cuentas
(IDCliente, SaldoDeposito, InteresRetorno, FechaApertura)
VALUES
(2, 30000, 1.1, '2021-02-20'),
(3, 46000, 4.6, '2019-06-17')
GO

--Regristros Cuenta Ahorro
INSERT INTO TB_Ahorro
(IDCuenta)
VALUES
(1)
GO

--Regristros Cuenta PlazoFijo
INSERT INTO TB_PlazoFijo
(IDCuenta)
VALUES
(2)
GO