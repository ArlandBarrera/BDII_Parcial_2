--Creacion Base de Datos DB_Banco
CREATE DATABASE DB_Banco
GO

--Usar DB_Banco
USE DB_Banco;
GO

--Crear Tabla Clientes
CREATE TABLE TB_Clientes(
	IDCliente INT NOT NULL IDENTITY(1,1),
	NombreCliente VARCHAR(30) NOT NULL,
	ApellidoCliente VARCHAR(30) NOT NULL,
	CorreoElectronico VARCHAR(60) NOT NULL,
	CONSTRAINT PK_TB_Clientes_IDCliente PRIMARY KEY (IDCliente),
);
GO

--Crear Tabla Prestamos
CREATE TABLE TB_Prestamos(
	IDPrestamo INT NOT NULL IDENTITY(1,1),
	IDCliente INT NOT NULL,
	MontoInicial DECIMAL(10, 2) NOT NULL,
	TasaInteres DECIMAL(10, 2) NOT NULL DEFAULT 5,
	FechaInicio DATE NOT NULL,
	PeriodoPrestamo VARCHAR(7) NOT NULL, --Diario, Semanal, Mensual, Anual
	EstadoPrestamo VARCHAR(6) NOT NULL DEFAULT 'Activo', --Activo, Pagado
	CONSTRAINT PK_TB_Prestamos_IDPrestamo PRIMARY KEY (IDPrestamo),
	CONSTRAINT FK_TB_Prestamos_TB_Clientes_IDCliente
	FOREIGN KEY (IDCliente) REFERENCES TB_Clientes(IDCliente),
);
GO

--Crear Tabla Cuentas
CREATE TABLE TB_Cuentas(
	IDCuenta INT NOT NULL IDENTITY(1,1),
	IDCliente INT NOT NULL,
	SaldoDeposito DECIMAL(10, 2) NOT NULL,
	InteresRetorno DECIMAL(10, 2) NOT NULL DEFAULT 2.5,
	FechaApertura DATE NOT NULL,
	CONSTRAINT PK_TB_Cuentas_IDCuenta PRIMARY KEY (IDCuenta),
	CONSTRAINT FK_TB_Cuentas_TB_Clientes_IDCliente
	FOREIGN KEY (IDCliente) REFERENCES TB_Clientes(IDCliente),
);
GO

--Crear Tabla Transacciones
CREATE TABLE TB_Transacciones(
	IDTransaccion INT NOT NULL IDENTITY(1,1),
	IDCuenta INT NOT NULL,
	MontoTransaccion DECIMAL(10, 2) NOT NULL,
	TipoTransaccion VARCHAR(8) NOT NULL, --Retiro, Deposito
	FechaTransaccion DATE NOT NULL,
	CONSTRAINT PK_TB_Transacciones_IDTransaccion PRIMARY KEY (IDTransaccion),
	CONSTRAINT FK_TB_Transacciones_TB_Cuentas_IDCuenta
	FOREIGN KEY (IDCuenta) REFERENCES TB_Cuentas(IDCuenta),
);
GO

--Crear Tabla Ahorro
CREATE TABLE TB_Ahorro(
	IDCuenta INT NOT NULL,
	IDAhorro INT NOT NULL IDENTITY(1,1),
	LimiteRetiro DECIMAL(10, 2) NOT NULL DEFAULT 5000,
	CONSTRAINT FK_TB_Ahorro_TB_Cuentas_IDCuenta
	FOREIGN KEY (IDCuenta) REFERENCES TB_Cuentas(IDCuenta),
);
GO

--Crear Tabla PlazoFijo
CREATE TABLE TB_PlazoFijo(
	IDCuenta INT NOT NULL,
	IDPlazoFijo INT NOT NULL IDENTITY(1,1),
	PlazoRetiro INT NOT NULL DEFAULT 3, --Anual
	CONSTRAINT FK_TB_PlazoFijo_TB_Cuentas_IDCuenta
	FOREIGN KEY (IDCuenta) REFERENCES TB_Cuentas(IDCuenta),
);
GO

--Crear Tabla ListaNegra
CREATE TABLE TB_ListaNegra(
	IDCliente INT NOT NULL,
	Castigo VARCHAR(50) NOT NULL DEFAULT 'Expropiacion de Vivienda',
	CONSTRAINT FK_TB_ListaNegra_TB_Clientes_IDCliente
	FOREIGN KEY (IDCliente) REFERENCES TB_Clientes(IDCliente),
);
GO
