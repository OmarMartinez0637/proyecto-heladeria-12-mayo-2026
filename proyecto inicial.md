actúa como un administrador de base de datos: proyecto heladeria dairy queen, que entidades se necesitan para su gestión

Como administrador de base de datos, aquí están las entidades clave para gestionar una heladería Dairy Queen, organizadas por dominio funcional:El modelo contempla **13 entidades** organizadas en 5 dominios:

<img width="932" height="517" alt="image" src="https://github.com/user-attachments/assets/492b520b-d7a1-4103-9788-8691726d8257" />

**Operaciones centrales**
- `PEDIDO` y `DETALLE_PEDIDO` — corazón del sistema, registra cada venta con sus productos, tipo (mostrador, drive-thru, delivery), estado y total.
- `PRODUCTO` — catálogo con precio, categoría (Blizzard, Dilly Bar, combo, etc.) y disponibilidad.

**Recursos humanos**
- `EMPLEADO` y `TURNO` — gestión de personal por sucursal, con control de horarios y asignación de atención a pedidos.

**Inventario y recetas**
- `INGREDIENTE` y `INGREDIENTE_PRODUCTO` — tabla puente que define la receta de cada producto, permitiendo calcular costos y controlar consumo automáticamente.
- `INVENTARIO` — stock por sucursal con alertas de cantidad mínima.

**Cadena de suministro**
- `PROVEEDOR`, `COMPRA` y `DETALLE_COMPRA` — trazabilidad de cada compra de insumos y su costo.

**Clientes y sucursales**
- `CLIENTE` — base para programa de lealtad y análisis de comportamiento.
- `SUCURSAL` — entidad raíz que agrupa empleados, pedidos e inventario.

¿Quieres que profundice en algún dominio específico, defina las restricciones e índices, o genere el DDL en SQL?

# Tablas
<img width="1145" height="509" alt="image" src="https://github.com/user-attachments/assets/8e4f9057-7677-4460-865a-c5b4739503e1" />
<img width="1100" height="411" alt="image" src="https://github.com/user-attachments/assets/5b27b70b-39d7-4672-b1f6-b3935f59e974" />
<img width="1103" height="390" alt="image" src="https://github.com/user-attachments/assets/e49f1c2e-8c75-448a-8899-17040c2ce311" />
<img width="1102" height="431" alt="image" src="https://github.com/user-attachments/assets/401bb570-9aa1-43bc-a540-0d008122a58f" />
<img width="1104" height="383" alt="image" src="https://github.com/user-attachments/assets/fd0c104f-1f4e-4d0a-96ba-43d7cc72cb75" />
<img width="1279" height="396" alt="image" src="https://github.com/user-attachments/assets/fab9fc77-0a47-4382-9eab-3d1ac87a2fec" />
<img width="1285" height="371" alt="image" src="https://github.com/user-attachments/assets/51dd5a66-7f91-4b36-bd07-e56adca69fe8" />
<img width="1105" height="452" alt="image" src="https://github.com/user-attachments/assets/72acf191-e43a-4881-a747-36e6ac10d47c" />
<img width="1102" height="379" alt="image" src="https://github.com/user-attachments/assets/06343c89-b3ca-4514-8091-3a7cf5e13a8e" />
<img width="1096" height="358" alt="image" src="https://github.com/user-attachments/assets/5261db5b-d43d-442b-b6f6-e0ffdd9215bb" />
<img width="1094" height="401" alt="image" src="https://github.com/user-attachments/assets/307bad06-d176-43f0-be32-7ecdd7a4a0de" />
<img width="1100" height="385" alt="image" src="https://github.com/user-attachments/assets/06800458-769b-4e61-9eef-c17ea73c2537" />
<img width="1103" height="375" alt="image" src="https://github.com/user-attachments/assets/666faf3a-5e3d-44c6-affd-f171feab42c9" />

Ahí están las 13 entidades con todos sus atributos, tipos de dato y clasificación de claves. Algunas notas de diseño relevantes:

Los tipos `DECIMAL(10,2)` se usan para dinero (precio, total, salario) y `DECIMAL(10,3)` para cantidades de ingredientes donde se necesita mayor precisión (gramos, litros fraccionados).

`INGREDIENTE_PRODUCTO` no tiene `PK` propia porque usa la combinación `(id_producto, id_ingrediente)` como llave compuesta — es una tabla puente pura.

El campo `precio_unitario` en `DETALLE_PEDIDO` guarda el precio *al momento de la venta*, no referencia al catálogo, lo que protege el historial ante cambios futuros de precios.

¿Quieres que genere el DDL en SQL, las restricciones `UNIQUE`/`NOT NULL`, o los índices recomendados para consultas frecuentes?
