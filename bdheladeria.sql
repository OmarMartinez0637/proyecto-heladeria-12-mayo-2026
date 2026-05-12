-- Script de creación de base de datos para Heladería
-- Generado automáticamente

CREATE DATABASE IF NOT EXISTS bdheladeria;
USE bdheladeria;

-- 1. SUCURSAL
CREATE TABLE SUCURSAL (
    id_sucursal INT NOT NULL,
    nombre VARCHAR(100),
    direccion VARCHAR(200),
    ciudad VARCHAR(80),
    telefono VARCHAR(20),
    PRIMARY KEY (id_sucursal)
);

-- 2. CLIENTE
CREATE TABLE CLIENTE (
    id_cliente INT NOT NULL,
    nombre VARCHAR(100),
    correo VARCHAR(100),
    telefono VARCHAR(20),
    fecha_registro DATE,
    PRIMARY KEY (id_cliente)
);

-- 3. PRODUCTO
CREATE TABLE PRODUCTO (
    id_producto INT NOT NULL,
    nombre VARCHAR(100),
    categoria VARCHAR(50),
    precio DECIMAL(10,2),
    disponible BOOLEAN,
    PRIMARY KEY (id_producto)
);

-- 4. INGREDIENTE
CREATE TABLE INGREDIENTE (
    id_ingredient INT NOT NULL,
    nombre VARCHAR(100),
    unidad_medida VARCHAR(20),
    costo_unitario DECIMAL(10,2),
    PRIMARY KEY (id_ingredient)
);

-- 5. PROVEEDOR
CREATE TABLE PROVEEDOR (
    id_proveedor INT NOT NULL,
    nombre VARCHAR(100),
    contacto VARCHAR(100),
    telefono VARCHAR(20),
    correo VARCHAR(100),
    PRIMARY KEY (id_proveedor)
);

-- 6. EMPLEADO
CREATE TABLE EMPLEADO (
    id_empleado INT NOT NULL,
    id_sucursal INT,
    nombre VARCHAR(100),
    puesto VARCHAR(50),
    salario DECIMAL(10,2),
    fecha_contrato DATE,
    PRIMARY KEY (id_empleado),
    FOREIGN KEY (id_sucursal) REFERENCES SUCURSAL(id_sucursal)
);

-- 7. TURNO
CREATE TABLE TURNO (
    id_turno INT NOT NULL,
    id_empleado INT,
    hora_inicio DATETIME,
    hora_fin DATETIME,
    dia_semana VARCHAR(15),
    PRIMARY KEY (id_turno),
    FOREIGN KEY (id_empleado) REFERENCES EMPLEADO(id_empleado)
);

-- 8. PEDIDO
CREATE TABLE PEDIDO (
    id_pedido INT NOT NULL,
    id_cliente INT,
    id_sucursal INT,
    id_empleado INT,
    fecha_hora DATETIME,
    tipo VARCHAR(20),
    total DECIMAL(10,2),
    estado VARCHAR(20),
    PRIMARY KEY (id_pedido),
    FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente),
    FOREIGN KEY (id_sucursal) REFERENCES SUCURSAL(id_sucursal),
    FOREIGN KEY (id_empleado) REFERENCES EMPLEADO(id_empleado)
);

-- 9. DETALLE_PEDIDO
CREATE TABLE DETALLE_PEDIDO (
    id_detalle INT NOT NULL,
    id_pedido INT,
    id_producto INT,
    cantidad INT,
    precio_unitario DECIMAL(10,2),
    PRIMARY KEY (id_detalle),
    FOREIGN KEY (id_pedido) REFERENCES PEDIDO(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES PRODUCTO(id_producto)
);

-- 10. INGREDIENTE_PRODUCTO (Receta)
CREATE TABLE INGREDIENTE_PRODUCTO (
    id_producto INT NOT NULL,
    id_ingrediente INT NOT NULL,
    cantidad DECIMAL(10,3),
    PRIMARY KEY (id_producto, id_ingrediente),
    FOREIGN KEY (id_producto) REFERENCES PRODUCTO(id_producto),
    FOREIGN KEY (id_ingrediente) REFERENCES INGREDIENTE(id_ingredient)
);

-- 11. INVENTARIO
CREATE TABLE INVENTARIO (
    id_inventario INT NOT NULL,
    id_sucursal INT,
    id_ingrediente INT,
    cantidad_actual DECIMAL(10,3),
    cantidad_minima DECIMAL(10,3),
    fecha_actualizacion DATE,
    PRIMARY KEY (id_inventario),
    FOREIGN KEY (id_sucursal) REFERENCES SUCURSAL(id_sucursal),
    FOREIGN KEY (id_ingrediente) REFERENCES INGREDIENTE(id_ingredient)
);

-- 12. COMPRA
CREATE TABLE COMPRA (
    id_compra INT NOT NULL,
    id_proveedor INT,
    id_sucursal INT,
    fecha DATE,
    total DECIMAL(10,2),
    PRIMARY KEY (id_compra),
    FOREIGN KEY (id_proveedor) REFERENCES PROVEEDOR(id_proveedor),
    FOREIGN KEY (id_sucursal) REFERENCES SUCURSAL(id_sucursal)
);

-- 13. DETALLE_COMPRA
CREATE TABLE DETALLE_COMPRA (
    id_detalle INT NOT NULL,
    id_compra INT,
    id_ingrediente INT,
    cantidad DECIMAL(10,3),
    precio_unitario DECIMAL(10,2),
    PRIMARY KEY (id_detalle),
    FOREIGN KEY (id_compra) REFERENCES COMPRA(id_compra),
    FOREIGN KEY (id_ingrediente) REFERENCES INGREDIENTE(id_ingredient)
);
