--Usar DB_Banco
USE DB_Banco;
GO

--Trigger tipo de cuenta Plazo Fijo
INSERT INTO TB_Transacciones
(IDCuenta, MontoTransaccion, TipoTransaccion, FechaTransaccion)
VALUES
(2, 150, 'Retiro', GETDATE())
GO

--Trigger limitar retiro Cuenta Ahorro
INSERT INTO TB_Transacciones
(IDCuenta, MontoTransaccion, TipoTransaccion, FechaTransaccion)
VALUES
(1, 5001, 'Retiro', GETDATE())
GO

--Insertar Transaccion Deposito
SELECT * FROM TB_Cuentas
INSERT INTO TB_Transacciones
(IDCuenta, MontoTransaccion, TipoTransaccion, FechaTransaccion)
VALUES
(1, 12000, 'Deposito', GETDATE())
SELECT * FROM TB_Transacciones
SELECT * FROM TB_Cuentas
GO