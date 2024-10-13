--Usar DB_Banco
USE DB_Banco;
GO

--Trigger para validar EstadoPrestamo en TB_Prestamos
CREATE TRIGGER TR_ValidarEstadoPrestamo
ON TB_Prestamos
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM inserted
        WHERE EstadoPrestamo NOT IN ('Activo', 'Pagado')
    )
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR('El estado del préstamo solo puede ser ''Activo'' o ''Pagado''.', 16, 1);
    END
END;
GO

--Trigger para validar EstadoPrestamo en TB_Prestamos
CREATE TRIGGER TR_ValidarPeriodoPrestamo
ON TB_Prestamos
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM inserted
        WHERE PeriodoPrestamo NOT IN ('Diario', 'Semanal', 'Mensual', 'Anual')
    )
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR('El periodo del préstamo solo puede ser ''Diario'', ''Semanal'', ''Mensual'' o ''Anual''.', 16, 1);
    END
END;
GO

--Trigger para validar TipoTransaccion en TB_Transacciones
CREATE TRIGGER TR_ValidarTipoTransaccion
ON TB_Transacciones
AFTER INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM inserted
        WHERE TipoTransaccion NOT IN ('Deposito', 'Retiro')
    )
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR('El tipo de transacción solo puede ser ''Deposito'' o ''Retiro''.', 16, 1);
    END
END;
GO

--Trigger para validar el tipo de Cuenta en TB_Transacciones
CREATE TRIGGER TR_ValidarTipoCuenta
ON TB_Transacciones
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM TB_PlazoFijo PF
        JOIN inserted I ON PF.IDCuenta = I.IDCuenta
    )
    BEGIN
        ROLLBACK TRANSACTION;
        RAISERROR('No se pueden realizar transacciones en cuentas de Plazo Fijo.', 16, 1);
    END
END;
GO

--Trigger para validar el Retiro en TB_Transacciones
CREATE TRIGGER TR_ValidarTransaccionRetiro
ON TB_Transacciones
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE TipoTransaccion = 'Retiro'
    )
    BEGIN
        DECLARE @IDCuenta INT, @MontoRetiro DECIMAL(10, 2), @SaldoDeposito DECIMAL(10, 2), @LimiteRetiro DECIMAL(10, 2);
		--Seleccionar IDCuenta y MontoTransaccion (Retiro)
        SELECT @IDCuenta = IDCuenta, @MontoRetiro = MontoTransaccion
        FROM inserted;
		--Seleccionar SaldoDeposito
        SELECT @SaldoDeposito = SaldoDeposito
        FROM TB_Cuentas
        WHERE IDCuenta = @IDCuenta;
		--Condicion MontoRetiro mayor a SaldoDeposito
        IF @MontoRetiro > @SaldoDeposito
        BEGIN
            ROLLBACK TRANSACTION;
            RAISERROR('El monto de retiro no puede ser mayor al saldo en depósito.', 16, 1);
        END
		ELSE
		BEGIN
			--Seleccionar LimiteRetiro
			SELECT @LimiteRetiro = LimiteRetiro
			FROM TB_Ahorro
			WHERE IDCuenta = @IDCuenta;
			--Condicion MontoRetiro mayor a LimiteRetiro
			IF @MontoRetiro > @LimiteRetiro
			BEGIN
				ROLLBACK TRANSACTION;
				RAISERROR('El monto de retiro excede el límite de retiro permitido para esta cuenta.', 16, 1);
			END
			ELSE
			BEGIN
				--Disminuir SaldoDeposito
				UPDATE TB_Cuentas
				SET SaldoDeposito = SaldoDeposito - @MontoRetiro
				WHERE IDCuenta = @IDCuenta;
			END
		END
    END
END;
GO

--Trigger para validar el Deposito en TB_Transacciones
CREATE TRIGGER TR_ValidarTransaccionDeposito
ON TB_Transacciones
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE TipoTransaccion = 'Deposito'
    )
    BEGIN
        DECLARE @IDCuenta INT, @MontoDeposito DECIMAL(10, 2);
		--Seleccionar IDCuenta y MontoTransaccion (Deposito)
        SELECT @IDCuenta = IDCuenta, @MontoDeposito = MontoTransaccion
        FROM inserted;
		--Aumentar SaldoCuenta
        UPDATE TB_Cuentas
        SET SaldoDeposito = SaldoDeposito + @MontoDeposito
        WHERE IDCuenta = @IDCuenta;
    END
END;
GO

--Trigger para enviar a ListaNegra
CREATE TRIGGER TR_MoverAListaNegra
ON TB_Prestamos
AFTER UPDATE
AS
BEGIN
    DECLARE @IDCliente INT, @IDPrestamo INT, @FechaInicio DATE, @PeriodoPrestamo VARCHAR(7);
    -- Seleccionar datos del prestamo
    SELECT @IDCliente = i.IDCliente, @IDPrestamo = i.IDPrestamo, @FechaInicio = i.FechaInicio, @PeriodoPrestamo = i.PeriodoPrestamo
    FROM inserted i
    WHERE i.EstadoPrestamo = 'Activo';
    -- Validar si el préstamo es diario y han pasado más de 120 dias
    IF @PeriodoPrestamo = 'Diario' AND DATEDIFF(DAY, @FechaInicio, GETDATE()) > 120
    BEGIN
		GOTO EnviarListaNegra;
    END;

	EnviarListaNegra:
			INSERT INTO TB_ListaNegra (IDCliente)
			VALUES (@IDCliente);
END;
GO
