# 🍦 Plan de Implementación: Aplicación "Heladería" (Flutter + Firebase)

> 📌 **Nota preliminar**: Este documento es un plan estratégico y procedimental. No incluye fragmentos de código. Cuando lo requieras, podremos avanzar fase por fase con la implementación técnica detallada.

---

## 🛠️ 1. Herramientas y Entorno de Desarrollo
| Categoría | Herramienta / Recurso | Propósito |
|-----------|----------------------|-----------|
| **IDE** | VS Code | Editor principal (ligero, extensible) |
| **Extensiones VS Code** | `Flutter`, `Dart`, `Flutter Intl`, `Error Lens`, `Pubspec Assist` | Soporte de lenguaje, formateo, gestión de paquetes |
| **SDK** | Flutter SDK (última versión estable) + Dart SDK | Motor multiplataforma |
| **CLI** | `flutter`, `dart`, `firebase`, `flutterfire` | Creación, empaquetado y conexión con Firebase |
| **Emulación/Dispositivos** | Android Studio (AVD), iOS Simulator (macOS), o dispositivos físicos reales | Pruebas nativas |
| **Control de versiones** | Git + GitHub/GitLab | Historial, colaboración, CI/CD futuro |
| **Diseño** | Figma / Penpot | Wireframes, prototipos interactivos, handoff a dev |

> 💡 *Nota*: Si por "Antigravity" te referías a otro IDE, VS Code es la opción recomendada por su integración nativa con FlutterFire y menor consumo de recursos. Android Studio solo sería necesario si requieres emuladores avanzados o profiling profundo.

---

## 🎨 2. Diseño UI/UX (Flujo y Componentes)
### 2.1. Mapa de Navegación
```
Splash → Login / Registro → Home (Catálogo de helados) 
       → Detalle de Producto → Carrito / Checkout → Historial de Pedidos
       → Perfil / Configuración
```

### 2.2. Pantallas Clave y Objetivos UX
| Pantalla | Objetivo UX | Elementos Críticos |
|----------|-------------|-------------------|
| **Login/Registro** | Acceso seguro y rápido | Formularios validados, toggle eye para contraseña, enlaces de recuperación, indicadores de carga |
| **Home (Catálogo)** | Exploración visual y filtrado | Grid responsive, categorías por sabor/tipo, buscador, badge de favoritos |
| **Detalle** | Conversión a compra | Galería, descripción, selector de tamaño/toppings, precio dinámico, botón CTA principal |
| **Carrito/Pedidos** | Claridad en resumen y estado | Lista editable, totales calculados, estados (pendiente/preparando/entregado), historial |
| **Perfil** | Gestión de cuenta y preferencias | Datos de usuario, cierre de sesión, historial, notificaciones (futuro) |

### 2.3. Sistema de Diseño
- **Paleta**: Tonos pastel (menta, vainilla, fresa) + acentos oscuros para contraste
- **Tipografía**: Sans-serif legible (ej. `Inter` o `Poppins`), jerarquía clara (H1-H4, Body, Caption)
- **Componentes reutilizables**: Cards, botones primarios/secundarios, inputs, chips de filtro, skeletons de carga, snackbars de feedback
- **Accesibilidad**: Contraste mínimo 4.5:1, tamaños de fuente escalables, navegación por teclado/lector de pantalla

---

## 🏗️ 3. Arquitectura y Dependencias (`pubspec.yaml`)
### 3.1. Estructura de Carpetas (Feature-First + Provider)
```
lib/
├── main.dart
├── core/
│   ├── constants/
│   ├── utils/
│   └── theme/
├── data/
│   ├── models/
│   └── services/
├── providers/
├── screens/
└── widgets/
```

### 3.2. Dependencias Conceptuales para `pubspec.yaml`
*(Solo listado de propósito, sin bloque de código)*
- **Firebase**: `firebase_core`, `firebase_auth`, `cloud_firestore`, `flutterfire_cli`
- **Estado**: `provider` (gestión global y local)
- **Navegación**: `go_router` (declarativa, segura, con guards de auth)
- **UI/UX**: `google_fonts`, `flutter_svg`, `cached_network_image`, `intl` (formato moneda/fechas), `skeletonizer` (loaders)
- **Validación/Forms**: `formz` o `flutter_form_builder` (opcional)
- **Utilidades**: `uuid` (IDs locales), `shared_preferences` (settings offline), `flutter_secure_storage` (tokens si se escalan)

> ✅ Se mantendrá la arquitectura limpia separando `models`, `services`, `providers`, `screens` y `widgets`.

---

## 🔥 4. Configuración de Firebase
1. **Crear proyecto** en Firebase Console
2. **Habilitar Authentication**: Método `Correo electrónico / Contraseña`
3. **Crear Firestore Database**: Modo producción, región cercana a usuarios objetivo
4. **Definir Colecciones**:
   - `users`: perfil, roles, preferencias
   - `products`: nombre, categoría, descripción, precio, imagen, stock/disponibilidad
   - `orders`: userId, items, total, estado, timestamps
   - `categories` (opcional): para filtrado dinámico
5. **Reglas de Seguridad**:
   - Auth: solo usuarios autenticados leen/escriben sus propios datos
   - Firestore: reglas restrictivas por colección, validación de campos básicos
6. **Vincular Flutter**: Usar `flutterfire configure` para generar `firebase_options.dart` automáticamente

---

## 🛠️ 5. Procedimiento de Desarrollo (Paso a Paso)
### 🔹 Etapa 1: Inicialización y Estructura
1. Crear proyecto Flutter con `flutter create heladeria_app`
2. Configurar `pubspec.yaml` con dependencias listadas
3. Ejecutar `flutter pub get` y verificar sin errores
4. Crear estructura de carpetas según sección 3.1
5. Configurar tema global (`ThemeData`), constantes y tipografías

### 🔹 Etapa 2: Conexión Firebase
6. Instalar FlutterFire CLI y autenticar con cuenta de Google
7. Ejecutar `flutterfire configure` y seleccionar proyecto + apps (Android/iOS/Web)
8. Inicializar Firebase en `main.dart` con `Firebase.initializeApp()`
9. Verificar conexión con logs o pantalla de diagnóstico temporal

### 🔹 Etapa 3: Modelos y Servicios
10. Definir clases modelo (`User`, `Product`, `Order`) con métodos `fromJson`/`toJson`
11. Crear servicios: `AuthService` (login, register, signOut, stream de usuario) y `FirestoreService` (CRUD de productos/órdenes)
12. Implementar manejo de errores global (FirebaseExceptions, timeouts, validaciones)

### 🔹 Etapa 4: Estado con Provider
13. Crear `AuthProvider`: expone `currentUser`, `isLoading`, `errorMessage`
14. Crear `ProductProvider`: carga catálogo, filtros, favoritos
15. Crear `CartProvider`: añadir/eliminar items, calcular totales, persistencia local
16. Envolver `MaterialApp` con `MultiProvider` y registrar los providers

### 🔹 Etapa 5: Pantallas y Navegación
17. Implementar `go_router` con rutas protegidas (redirect si no hay sesión)
18. Desarrollar `LoginScreen` y `RegisterScreen` con validación básica y feedback visual
19. Construir `HomeScreen` con grid de productos, búsqueda y filtros
20. Desarrollar `ProductDetailScreen` con selectors dinámicos
21. Implementar `CartScreen` y `OrderHistoryScreen`
22. Añadir `ProfileScreen` con opciones de cuenta y cierre de sesión

### 🔹 Etapa 6: UX Avanzada y Optimización
23. Añadir estados de carga (`CircularProgressIndicator` o skeletons)
24. Implementar pull-to-refresh y paginación en listas largas
25. Manejar estados offline/error con snackbars y botones de reintento
26. Optimizar imágenes (caché, compresión, lazy loading)
27. Añadir animaciones sutiles (transiciones, hover effects, microinteracciones)

---

## ✅ 6. Pruebas, Seguridad y Despliegue
| Actividad | Descripción |
|-----------|-------------|
| **Pruebas Unitarias** | Modelos, servicios, lógica de providers |
| **Pruebas de Widget** | Interacción con botones, validación de formularios, navegación |
| **Pruebas de Integración** | Flujo completo: login → catálogo → carrito → pedido |
| **Auditoría Firebase** | Verificar reglas de seguridad, límites de cuotas, índices compuestos |
| **Performance** | Usar `flutter devtools` para analizar frames, memoria, red |
| **Build Release** | Configurar signing (Android), versionado, iconos, splash |
| **Distribución** | Internal testing (Play Console / TestFlight), luego producción |

---

## 📌 Buenas Prácticas y Notas Clave
- 🔒 **Seguridad**: Nunca expongas claves de API en código. Usa `flutterfire` para config segura.
- 🔄 **Estado**: Mantén los providers enfocados. Evita god-objects. Usa `context.read` vs `context.watch` correctamente.
- 📱 **Multiplataforma**: Prueba en iOS y Android desde el día 1. Usa `Platform.isIOS/Android` solo cuando sea estrictamente necesario.
- 📦 **Dependencias**: Fija versiones compatibles. Actualiza con `flutter pub outdated` periódicamente.
- 🧪 **Testing**: Escribe pruebas antes de refactorizar. Usa mocks para servicios Firebase en desarrollo.
- 🌍 **Localización**: Prepara estructura `l10n` desde el inicio si planeas múltiples idiomas.

---

## 🚀 Siguientes Pasos
1. Valida este plan y ajusta alcance/prioridades según tu visión.
2. Define los campos exactos de cada modelo (productos, usuarios, pedidos).
3. Confirma si deseas continuar con la **Fase 1 de implementación técnica** (configuración de proyecto, estructura, `pubspec.yaml` y Firebase inicial) con código guiado paso a paso.

¿Deseas ajustar algún flujo, añadir funcionalidades (ej. pagos, notificaciones push, panel admin) o avanzamos directamente a la primera etapa de código?
