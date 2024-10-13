--Usar DB_Banco
USE DB_Banco;
GO


--Ejercicio Fondos Totales
--Declarar variables
DECLARE @IDCliente INT, @SaldoTotal DECIMAL(20, 2), @InteresPrestamo DECIMAL(20, 2),
@MontoPrestamo DECIMAL(20, 2), @InteresPlazoFijo DECIMAL(20, 2), @FondosTotales DECIMAL(20, 2);

--Establecer el ID del cliente
SET @IDCliente = (SELECT IDCLiente FROM TB_Clientes WHERE IDCliente = 3);

--Obtener el saldo total de las cuentas del cliente (solo Plazo Fijo)
SELECT @SaldoTotal = SUM(SaldoDeposito) 
FROM TB_Cuentas 
WHERE IDCliente = @IDCliente AND IDCuenta IN (SELECT IDCuenta FROM TB_PlazoFijo);

--Obtener el interés generado en la cuenta a Plazo Fijo con interés simple
--Interés Simple = MontoInicial * TasaInteres * CantidadPlazos
SELECT @InteresPlazoFijo = SUM(SaldoDeposito * InteresRetorno / 100 * PlazoRetiro)
FROM TB_Cuentas c
JOIN TB_PlazoFijo p ON c.IDCuenta = p.IDCuenta
WHERE c.IDCliente = @IDCliente;

--Obtener el monto total de los préstamos del cliente
SELECT @MontoPrestamo = SUM(MontoInicial) 
FROM TB_Prestamos
WHERE IDCliente = @IDCliente;

DECLARE @Dias INT;
--Obtener el total de los préstamos pendientes con interés compuesto
--Interés Compuesto = MontoInicial * (((TasaInteres + 1) ^ CantidadPlazos) - 1)
SELECT @InteresPrestamo = SUM(MontoInicial * (POWER(((TasaInteres / 100) + 1), DATEDIFF(DAY, FechaInicio, GETDATE()))) - 1),
@Dias = MAX(DATEDIFF(DAY, FechaInicio, GETDATE()))
FROM TB_Prestamos 
WHERE IDCliente = @IDCliente AND EstadoPrestamo = 'Activo'
GROUP BY IDCliente, FechaInicio;

--Calcular los fondos totales del cliente (Ingresos - Deudas)
SET @FondosTotales = @SaldoTotal + @InteresPlazoFijo - @MontoPrestamo - @InteresPrestamo;

--Mostrar los fondos totales
SELECT @SaldoTotal AS SaldoTotal, @InteresPlazoFijo AS InteresPlazoFijo,
@MontoPrestamo AS MontoPrestamo, @Dias AS DiasAcumulados,
@InteresPrestamo AS InteresPrestamo, @FondosTotales AS FondosTotales;
GO


--Ejercicio enviar a la Lista Negra
SELECT * FROM TB_ListaNegra
UPDATE TB_Prestamos
SET TasaInteres = 4.5 --4.6
WHERE IDPrestamo = 2
SELECT * FROM TB_ListaNegra
GO