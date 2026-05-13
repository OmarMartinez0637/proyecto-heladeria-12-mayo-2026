# PLAN DE IMPLEMENTACIÓN COMPLETO: HELADERÍA OMAR (FLUTTER/DART MULTIPLATAFORMA)

A continuación se presenta un documento técnico-arquitectónico exhaustivo, diseñado para guiar el desarrollo de la aplicación desde cero hasta su despliegue, cumpliendo estrictamente con la especificación de no incluir código fuente, pero detallando cada capa, decisión de diseño, estructura de datos, flujo de usuario y buenas prácticas de ingeniería de software.

---

## 1. SISTEMA DE DISEÑO UI/UX Y PALETA DE COLORES

La identidad visual debe transmitir frescura, confianza y apetito visual, alineada con el sector de heladerías premium. Se utiliza un sistema de diseño basado en una cuadrícula de 8 puntos, tipografía escalable y componentes reutilizables. La paleta está optimizada para cumplir con ratios de contraste WCAG AA, garantizando legibilidad y accesibilidad en todos los dispositivos.

| Elemento de Interfaz | Color Hex | Propósito y Uso | Notas de Implementación |
|----------------------|-----------|-----------------|--------------------------|
| Azul Primario | `#004B91` | Barra de aplicación (AppBar), encabezados de sección, iconos de navegación, elementos de marca | Transmite confianza y profesionalismo. Usar en fondos de navegación superior e inferior. |
| Rojo Primario | `#E21836` | Botones de acción principal (CTA), badges de ofertas, alertas importantes, iconos de carrito | Genera urgencia visual y destaca acciones de compra. Aplicar con bordes redondeados para suavizar impacto. |
| Fondo Principal | `#F8F9FA` | Pantallas de catálogo, perfil, historial de pedidos | Fondo neutro que evita fatiga visual y permite que los productos resalten. |
| Superficie/Cartas | `#FFFFFF` | Contenedores de productos, formularios, modales, tarjetas de resumen | Sombra sutil de 4px de desenfoque para jerarquía visual sin competir con colores primarios. |
| Texto Primario | `#1A1A1A` | Títulos, nombres de productos, precios, encabezados de tabla | Alto contraste sobre fondos claros. Peso tipográfico semibold o bold. |
| Texto Secundario | `#5A5A5A` | Descripciones, etiquetas, metadatos, placeholders | Mejora legibilidad sin saturar la interfaz. Usar en textos auxiliares. |
| Acento Vainilla/Crema | `#FFD166` | Fondos de secciones destacadas, íconos decorativos, divisores temáticos | Evoca sabores clásicos. Usar con moderación para calidez visual. |
| Acento Menta/Refresco | `#A8E6CF` | Indicadores de disponibilidad, estados de preparación, etiquetas frescura | Refuerza la sensación de frío y frescura inherente al producto. |
| Acento Fresa/Dulce | `#FF8B99` | Badges de nuevos productos, decoraciones de temporada, elementos promocionales | Complementa la paleta sin competir con el rojo primario. |
| Error/Validación | `#E74C3C` | Mensajes de error, campos inválidos, alertas de stock bajo | Feedback inmediato y claro. Acompañar con íconos descriptivos. |
| Advertencia | `#F39C12` | Notificaciones de reabastecimiento, tiempos de espera, cambios de estado | Precaución sin alarmismo. Usar en banners informativos. |
| Éxito/Confirmación | `#27AE60` | Estados de pedido entregado, pago confirmado, registro exitoso | Refuerzo positivo en flujos de conversión. |

**Directrices UX/UI Clave:**
- **Microinteracciones:** Animaciones suaves al añadir al carrito, transiciones de página con desvanecimiento, efectos de pulso en botones de compra.
- **Espaciado:** Sistema de 8pt para márgenes, padding y separación entre elementos.
- **Tipografía:** Escala fluida (12, 14, 16, 20, 24, 32, 40). Fuente sans-serif moderna y redondeada para transmitir cercanía.
- **Accesibilidad:** Soporte para modo oscuro con inversión inteligente de paleta, tamaño de fuente ajustable, etiquetas para lectores de pantalla, navegación por teclado en web.
- **Jerarquía Visual:** El color rojo solo se usa para acciones que generan conversión o requieren atención inmediata. El azul domina la navegación y estructura. Los acentos se reservan para decoración y estados.

---

## 2. ENTIDADES DE BASE DE DATOS (NUMERADAS 1-13)

Las siguientes entidades representan la estructura relacional original. Dado que Firebase Firestore es una base de datos NoSQL orientada a documentos, cada tabla se modelará como una colección con documentos que contienen campos tipados, referencias cruzadas mediante identificadores únicos, y subcolecciones donde sea necesario para optimizar lecturas y mantener la consistencia transaccional.

1. **SUCURSAL**
   - Campos: id_sucursal, nombre, direccion, ciudad, telefono
   - Adaptación Firestore: Colección principal. Documenta horarios de atención, coordenadas geográficas para mapas, y estado operativo (abierto/cerrado/mantenimiento).

2. **CLIENTE**
   - Campos: id_cliente, nombre, correo, telefono, fecha_registro
   - Adaptación Firestore: Vinculado a Firebase Authentication mediante UID. Campos adicionales: direcciones guardadas, preferencias de sabor, historial de fidelización, rol (cliente/admin).

3. **PRODUCTO**
   - Campos: id_producto, nombre, categoria, precio, disponible
   - Adaptación Firestore: Colección con subcolecciones para variantes (tamaño, toppings), imágenes optimizadas, alergenos, y estado de stock por sucursal. Indexación por categoría y disponibilidad para consultas rápidas.

4. **INGREDIENTE**
   - Campos: id_ingrediente, nombre, unidad_medida, costo_unitario
   - Adaptación Firestore: Colección de insumos crudos. Vinculada a inventario y recetas. Campos de trazabilidad: lote, fecha de vencimiento, proveedor asociado.

5. **PROVEEDOR**
   - Campos: id_proveedor, nombre, contacto, telefono, correo
   - Adaptación Firestore: Colección con documentos de evaluación de desempeño, términos de pago, contratos digitales, y historial de entregas.

6. **EMPLEADO**
   - Campos: id_empleado, id_sucursal, nombre, puesto, salario, fecha_contrato
   - Adaptación Firestore: Colección con credenciales de acceso diferenciadas. Campos de permisos, turno asignado, métricas de productividad, y estado (activo/vacaciones/baja).

7. **TURNO**
   - Campos: id_turno, id_empleado, hora_inicio, hora_fin, dia_semana
   - Adaptación Firestore: Subcolección o colección independiente con referencias cruzadas. Útil para programación, asistencia y cálculo de nómina. Campos de asistencia real vs planificada.

8. **PEDIDO**
   - Campos: id_pedido, id_cliente, id_sucursal, id_empleado, fecha_hora, tipo, total, estado
   - Adaptación Firestore: Colección central. Subcolección DETALLE_PEDIDO embebida o referenciada. Campos de rastreo: método de pago, instrucciones especiales, geolocalización de entrega, estimación de tiempo.

9. **DETALLE_PEDIDO**
   - Campos: id_detalle, id_pedido, id_producto, cantidad, precio_unitario
   - Adaptación Firestore: Documentos hijos bajo cada pedido. Campos de personalización (sin azúcar, extra topping), estado de preparación por ítem, impuestos aplicados.

10. **INGREDIENTE_PRODUCTO**
    - Campos: id_producto, id_ingrediente, cantidad
    - Adaptación Firestore: Documentos de mapeo receta-producto. Campos de proporción, tolerancia de variación, y versión de receta (para trazabilidad de cambios).

11. **INVENTARIO**
    - Campos: id_inventario, id_sucursal, id_ingrediente, cantidad_actual, cantidad_minima, fecha_actualizacion
    - Adaptación Firestore: Colección por sucursal. Campos de alertas automáticas, historial de movimientos, ajustes por merma, y umbral de reorden dinámico.

12. **COMPRA**
    - Campos: id_compra, id_proveedor, id_sucursal, fecha, total
    - Adaptación Firestore: Colección de órdenes de compra. Subcolección DETALLE_COMPRA. Campos de estado (cotizada/aprobada/recibida/facturada), comprobante digital, y seguimiento logístico.

13. **DETALLE_COMPRA**
    - Campos: id_detalle, id_compra, id_ingrediente, cantidad, precio_unitario
    - Adaptación Firestore: Documentos hijos de compra. Campos de recepción parcial, control de calidad, lote recibido, y discrepancias vs pedido original.

---

## 3. MODELOS DE DATOS (MODELS) A UTILIZAR

Cada modelo en Dart representará una entidad o un objeto de dominio. Deben incluir validación estricta, serialización/deserialización JSON, manejo de estados opcionales, y mapeo explícito a documentos Firestore. Se recomienda utilizar generadores de código para evitar boilerplate, manteniendo la arquitectura limpia.

1. **Modelo Sucursal**: Identificador, nombre oficial, dirección completa, ciudad, teléfono, coordenadas GPS, horario operativo, estado de operación, imagen de fachada.
2. **Modelo Cliente**: Identificador, UID de autenticación, nombre completo, correo verificado, teléfono validado, fecha de registro, lista de direcciones guardadas, preferencias de contacto, historial de puntos/fidelización, rol de acceso.
3. **Modelo Producto**: Identificador, nombre comercial, categoría enum (blizzard, cono, paleta, combo, bebida, postre), precio base, precio promocional, estado de disponibilidad, lista de variantes, imágenes en CDN, descripción nutricional, alergenos, tiempo estimado de preparación.
4. **Modelo Ingrediente**: Identificador, nombre común, unidad de medida enum, costo unitario actual, proveedor preferido, fecha de último abastecimiento, estado de calidad, código de lote interno.
5. **Modelo Proveedor**: Identificador, razón social, nombre de contacto, teléfono comercial, correo corporativo, dirección fiscal, evaluación promedio, días de entrega estándar, condiciones de pago, documentos legales.
6. **Modelo Empleado**: Identificador, referencia a sucursal, nombre completo, puesto enum, salario base, fecha de contratación, UID de acceso, nivel de permisos, turno asignado, métricas de desempeño, estado laboral.
7. **Modelo Turno**: Identificador, referencia a empleado, horario de inicio, horario de fin, día de la semana enum, asistencia marcada, observaciones de supervisor, horas extras registradas.
8. **Modelo Pedido**: Identificador, referencia a cliente, referencia a sucursal, referencia a empleado asignado, marca de tiempo completa, tipo de servicio enum, monto total, estado enum, método de pago, instrucciones de entrega, geolocalización, seguimiento en tiempo real.
9. **Modelo DetallePedido**: Identificador, referencia a pedido, referencia a producto, cantidad solicitada, precio unitario congelado al momento de la compra, personalizaciones aplicadas, impuestos desglosados, estado de preparación individual.
10. **Modelo IngredienteProducto**: Referencia a producto, referencia a ingrediente, cantidad por receta, tolerancia de variación, versión de fórmula, fecha de última revisión, responsable de validación.
11. **Modelo Inventario**: Identificador, referencia a sucursal, referencia a ingrediente, stock actual, umbral mínimo, fecha de última actualización, historial de movimientos enum (entrada/salida/ajuste), responsable del conteo.
12. **Modelo Compra**: Identificador, referencia a proveedor, referencia a sucursal, fecha de emisión, costo total, estado de orden, número de factura, comprobante almacenado, fecha estimada de llegada.
13. **Modelo DetalleCompra**: Identificador, referencia a compra, referencia a ingrediente, cantidad recibida, precio unitario pactado, lote recibido, estado de control de calidad, discrepancias reportadas.

**Modelos Adicionales de Estado y UI:**
- Estado de Autenticación (cargando, autenticado, no autenticado, error)
- Estado del Carrito (ítems, total calculado, cupones aplicados, validación de stock)
- Estado de Pedido (timeline de preparación, notificaciones push, historial filtrado)
- Modelo de Ruta de Navegación (definición de pantallas, parámetros, profundidades)
- Modelo de Configuración de Tema (modo claro/oscuro, preferencia de usuario, escala tipográfica)
- Modelo de Notificación (tipo, timestamp, leída/no leída, acción asociada)

---

**Dependencias para `pubspec.yaml`:**

1. firebase_core: Inicialización y configuración base requerida para conectar y habilitar todos los servicios de Firebase en la aplicación multiplataforma.
2. firebase_auth: Gestión completa de autenticación por correo electrónico y contraseña, verificación de identidad, recuperación de cuenta y manejo seguro de sesiones.
3. cloud_firestore: Cliente de base de datos NoSQL para almacenamiento estructurado, consultas filtradas, sincronización en tiempo real y gestión de transacciones para productos, pedidos e inventario.
4. firebase_storage: Almacenamiento en la nube para imágenes de productos, fotos de sucursales, comprobantes de compra y documentos administrativos de la heladería.
5. firebase_messaging: Sistema de notificaciones push para alertar a clientes sobre el estado de sus pedidos y a empleados sobre nuevas órdenes o alertas de stock bajo.
6. flutter_riverpod: Gestión de estado reactivo, escalable y testable que separa la lógica de negocio de la capa visual, ideal para manejar carrito, autenticación y flujos de pedido.
7. go_router: Enrutamiento declarativo con protección de rutas por rol/autenticación, navegación anidada, manejo de errores y soporte para deep linking y web.
8. freezed: Generador de clases inmutables y tipos union para modelos de datos seguros, eliminando errores de mutación accidental y facilitando la copia y comparación de objetos.
9. json_serializable: Automatización de la serialización y deserialización entre documentos JSON de Firestore y objetos Dart tipados, reduciendo código boilerplate y manteniendo integridad de datos.
10. build_runner: Ejecutor de código requerido para generar automáticamente los archivos de mapeo de freezed y json_serializable durante las fases de desarrollo y compilación.
11. cached_network_image: Carga asíncrona y caché local inteligente de imágenes de productos y promociones, optimizando memoria, reduciendo latencia y mejorando la experiencia offline.
12. intl: Formateo profesional y localizado de fechas, monedas, números y horarios, esencial para precios dinámicos, historial de pedidos y reportes de ventas.
13. flutter_secure_storage: Almacenamiento cifrado a nivel de sistema operativo (Keychain/Keystore) para tokens de sesión, credenciales de acceso y preferencias sensibles del usuario.

---

## 5. ESTRUCTURA COMPLETA DEL PROYECTO (ÁRBOL DE CARPETAS)

La arquitectura sigue un enfoque por características (feature-first) combinado con capas limpias (clean architecture) para mantener escalabilidad, testabilidad y separación de responsabilidades.

```
heladeria_omar_app/
├── assets/
│   ├── fonts/
│   ├── icons/
│   ├── images/
│   └── templates/
│       ├── auth_templates/
│       ├── product_templates/
│       └── receipt_templates/
├── lib/
│   ├── main.dart
│   ├── app/
│   │   ├── router/
│   │   ├── theme/
│   │   └── config/
│   ├── core/
│   │   ├── constants/
│   │   ├── errors/
│   │   ├── utils/
│   │   └── widgets/
│   ├── data/
│   │   ├── models/
│   │   ├── repositories/
│   │   ├── datasources/
│   │   └── services/
│   ├── domain/
│   │   ├── entities/
│   │   ├── repositories/
│   │   └── usecases/
│   └── features/
│       ├── auth/
│       │   ├── presentation/
│       │   └── state/
│       ├── catalog/
│       │   ├── presentation/
│       │   └── state/
│       ├── cart/
│       │   ├── presentation/
│       │   └── state/
│       ├── orders/
│       │   ├── presentation/
│       │   └── state/
│       ├── profile/
│       │   ├── presentation/
│       │   └── state/
│       └── admin/
│           ├── inventory/
│           ├── suppliers/
│           └── staff/
├── test/
│   ├── unit/
│   ├── widget/
│   └── integration/
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

**Explicación de Carpetas Clave:**
- **assets/templates**: Plantillas reutilizables para recibos digitales, correos de confirmación, y pantallas de bienvenida. Almacena recursos estáticos no compilados.
- **data/models**: Clases que representan la estructura de datos crudos desde Firebase o APIs externas. Manejan serialización, validación y mapeo a entidades de dominio.
- **data/repositories**: Implementaciones concretas de acceso a datos. Coordinan fuentes locales/remote, caché, y transforman modelos a entidades.
- **domain/entities**: Objetos puros de negocio, sin dependencias de UI o infraestructura. Representan reglas y contratos del dominio.
- **domain/usecases**: Casos de uso interactivos que encapsulan lógica de negocio. Reciben entradas, ejecutan reglas y devuelven resultados.
- **features/**: Organización vertical por funcionalidad. Cada feature contiene su propia capa de presentación (pantallas, widgets) y estado (controladores, providers).
- **core/utils**: Herramientas transversales: formateadores, validadores, extensiones de tipos, constantes globales, helpers de fecha y moneda.
- **test/**: Pruebas unitarias para lógica de negocio, pruebas de widget para componentes visuales, pruebas de integración para flujos completos.

---

## 6. PROCEDIMIENTO PASO A PASO PARA CREAR EL PROYECTO

**Fase 1: Configuración del Entorno y Firebase**
1. Verificar que Flutter SDK esté instalado en versión estable actualizada. Configurar el entorno Antigravity con soporte para desarrollo multiplataforma y depuración en tiempo real.
2. Crear un nuevo proyecto en Firebase Console con nombre oficial de la heladería. Habilitar Authentication con método correo/contraseña, Firestore Database en modo de prueba inicial, Storage, Analytics y Crashlytics.
3. Registrar las aplicaciones Android, iOS y Web en Firebase Console. Descargar los archivos de configuración respectivos y ubicarlos en las rutas estándar de Flutter.
4. Activar índices compuestos en Firestore para las consultas más frecuentes: productos por categoría y disponibilidad, pedidos por estado y cliente, inventario por sucursal y umbral.
5. Configurar reglas de seguridad base: lectura pública para catálogo, escritura restringida a usuarios autenticados, acceso a pedidos solo al propietario o empleados con rol específico.

**Fase 2: Inicialización del Proyecto Flutter**
6. Generar la estructura base del proyecto desde Antigravity o terminal. Establecer nombre, paquete, organización y descripción oficial.
7. Editar el archivo de configuración de dependencias e incluir la lista numerada previamente proporcionada. Ejecutar sincronización y verificación de compatibilidad.
8. Configurar opciones de análisis estático para forzar tipado fuerte, evitar valores nulos implícitos, y aplicar convenciones de linteo estrictas.
9. Inicializar el sistema de rutas declarativas. Definir las rutas principales, rutas protegidas por autenticación, y parámetros esperados en navegación.

**Fase 3: Arquitectura y Capas de Datos**
10. Crear las carpetas de dominio, datos y características siguiendo el árbol estructurado. Establecer interfaces de repositorio en dominio e implementaciones en datos.
11. Desarrollar los modelos de datos según las 13 entidades numeradas. Implementar serialización, validación de campos obligatorios, manejo de enums y fechas.
12. Configurar el cliente de Firestore con inicialización segura, manejo de errores de red, y reintentos exponenciales. Implementar caché offline para catálogo y perfil.
13. Diseñar los casos de uso principales: registro, inicio de sesión, carga de productos, adición al carrito, creación de pedido, consulta de historial, actualización de inventario.

**Fase 4: Diseño UI/UX y Componentes**
14. Implementar el tema visual global aplicando la paleta de colores, tipografía, espaciado y sombras definidas. Configurar modo claro/oscuro y preferencias de usuario.
15. Construir la biblioteca de componentes base: botones primarios/secundarios, campos de texto con validación, tarjetas de producto, barras de progreso, diálogos de confirmación.
16. Desarrollar pantallas de onboarding y autenticación con flujos de recuperación de contraseña, verificación de correo y manejo de errores visuales.
17. Crear el catálogo de productos con filtros por categoría, búsqueda por nombre, estados de disponibilidad, y vista de detalle con variantes y alergenos.
18. Implementar el flujo de carrito con cálculo dinámico, cupones, selección de sucursal, tipo de servicio, y resumen antes de confirmar.

**Fase 5: Integración con Firebase y Estado**
19. Conectar la capa de presentación con los proveedores de estado. Manejar estados de carga, éxito y error en todas las operaciones asíncronas.
20. Implementar autenticación persistente, almacenamiento seguro de sesión, cierre seguro, y refresh de token si se utiliza autenticación avanzada.
21. Configurar escuchas en tiempo real para pedidos activos, cambios de estado, y notificaciones de preparación. Mostrar indicadores visuales de actividad.
22. Integrar Firestore Storage para carga de imágenes de productos, con compresión previa, progreso de subida, y fallback visual en caso de error.

**Fase 6: Funcionalidades Administrativas y Negocio**
23. Desarrollar vistas de gestión de inventario con alertas de stock bajo, registro de entradas/salidas, y ajustes de conteo.
24. Implementar módulo de proveedores y compras con registro de órdenes, seguimiento de entregas, y validación de lotes recibidos.
25. Crear panel de empleados con asignación de turnos, control de asistencia, y métricas de rendimiento por sucursal.
26. Configurar roles y permisos mediante claims de autenticación. Restringir acceso a módulos administrativos según nivel de autorización.

**Fase 7: Pruebas, Optimización y Despliegue**
27. Ejecutar pruebas unitarias para casos de uso, validación de modelos, y cálculos de precios/carrito. Verificar cobertura mínima del 80 por ciento.
28. Realizar pruebas de widget para componentes críticos: formularios, tarjetas, diálogos, y estados de carga. Validar accesibilidad y contraste.
29. Ejecutar pruebas de integración para flujos completos: registro, navegación al catálogo, adición al carrito, checkout, y confirmación de pedido.
30. Optimizar rendimiento: reducir reconstrucciones innecesarias, implementar paginación para catálogos grandes, comprimir assets, y habilitar tree-shaking.
31. Preparar metadatos para tiendas: iconos, capturas de pantalla, descripciones, políticas de privacidad, términos de servicio, y clasificación por edad.
32. Configurar pipeline de CI/CD para generación automática de builds, ejecución de pruebas estáticas, y despliegue a entornos de staging y producción.
33. Monitorear post-lanzamiento con Analytics, Crashlytics y feedback directo. Iterar mejoras basadas en datos reales de uso y comportamiento de conversión.

---

## 7. DIRECTRIZES CRÍTICAS DE ARQUITECTURA, UX Y MULTIPLATAFORMA

**Adaptación Relacional a NoSQL:**
Firestore no soporta joins nativos. Las relaciones se resuelven mediante documentos embebidos para datos frecuentes (detalle_pedido dentro de pedido), o referencias por ID para datos independientes que se actualizan a distinta frecuencia (cliente, sucursal). Las consultas complejas se precalculan en el backend o se manejan con subcolecciones indexadas.

**Gestión de Estado:**
Se recomienda un enfoque reactivo unificado. Los estados de UI deben derivar de flujos de datos inmutables. Evitar mutaciones directas. Centralizar la lógica de negocio en casos de uso, nunca en la capa de presentación. Usar providers con ámbito específico por feature para evitar reconstrucciones globales.

**Flujos de Usuario (UX):**
- **Onboarding:** Pantalla de bienvenida con ilustraciones temáticas, acceso rápido a catálogo sin registro obligatorio, solicitud de datos solo al checkout o guardado de favoritos.
- **Navegación:** Barra inferior con 4 íconos principales: Inicio, Buscar, Carrito, Perfil. Accesibilidad por gestos y botones de hardware en Android/iOS.
- **Checkout:** Proceso en 3 pasos máximo: Selección de servicio, Revisión de carrito y Dirección, Pago y Confirmación. Progreso visual claro en cada etapa.
- **Tracking:** Timeline horizontal con estados: Recibido, Preparando, Empacado, En camino, Entregado. Notificación push en cada transición.

**Seguridad y Privacidad:**
- Validación en cliente y servidor de todos los campos de entrada.
- Encriptación de datos sensibles en almacenamiento local.
- Políticas de retención de datos según regulaciones locales.
- Logs anonimizados en producción.
- Prevención de ataques de fuerza bruta con límites de intentos y verificación de correo.

**Optimización Multiplataforma:**
- Web: Compilación con tree-shaking agresivo, lazy loading de módulos, soporte para PWA con caché de catálogo offline.
- Móvil: Compilación nativa, manejo de permisos granular, adaptación a notch y barras de navegación dinámicas.
- Escritorio (opcional): Soporte para ventanas redimensionables, atajos de teclado, y menú contextual.
- Consistencia visual garantizada mediante tokens de diseño y componentes abstractos que se adaptan al sistema operativo subyacente sin duplicar lógica.

---

Este documento constituye la base técnica, visual y arquitectónica para desarrollar la aplicación de Heladería Omar con estándares profesionales, escalabilidad garantizada, y experiencia de usuario centrada en la conversión y fidelización. Cada sección puede expandirse en especificaciones técnicas detalladas por equipo de desarrollo, pero esta guía asegura coherencia, calidad y cumplimiento de los requisitos planteados sin necesidad de código explícito en esta etapa de planificación.
