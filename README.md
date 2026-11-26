# taskflow

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Alcance de TaskFlow

Problema: necesito organizar actividades académicas y saber cuáles faltan.
Usuario objetivo: estudiante que planifica entregas semanales.

### Historias de usuario y criterios de aceptación
1. Como estudiante, quiero listar mis tareas para ver qué debo hacer.
   Criterio: la lista muestra título, prioridad y estado de cada tarea.
2. Como estudiante, quiero abrir una tarea para leer su descripción.
   Criterio: al tocar una tarjeta aparece el detalle de la tarea elegida.
3. Como estudiante, quiero crear una tarea para registrar un pendiente.
   Criterio: el formulario guarda una tarea válida y la lista la muestra.
4. Como estudiante, quiero editar una tarea para corregir sus datos.
   Criterio: los cambios guardados aparecen en lista y detalle.
5. Como estudiante, quiero eliminar una tarea terminada para limpiar la lista.
   Criterio: después de confirmar, la tarea desaparece de la lista.

### Modelo de datos
Task: id (entero único), title (texto), description (texto),
priority (Alta, Media o Baja), isCompleted (verdadero/falso),
userId (entero que identifica al usuario de prueba).

### Pantallas previstas
Lista: tarjetas de tareas y acción para crear.
Detalle: información completa y futuras acciones de editar o eliminar.
Formulario: campos de título, descripción y prioridad.

### Requisitos no funcionales
La navegación debe tener textos comprensibles.
Un id inexistente debe mostrar un mensaje en vez de cerrar la app.

### Contrato de API que necesitaremos
GET /tasks        listar tareas
GET /tasks/:id    consultar detalle
POST /tasks       crear tarea
PATCH /tasks/:id  actualizar tarea
DELETE /tasks/:id eliminar tarea

La API concreta se elegirá después. Estas rutas son requisitos, no
direcciones de un servidor ya conectado.


### Contrato JSON de Task

La aplicación utilizará una estructura JSON para representar
la información de cada tarea.

Ejemplo de una tarea:

```json
{
  "id": 1,
  "title": "Revisar requisitos de la Etapa 3",
  "description": "Analizar las nuevas indicaciones del proyecto ForáneoGo",
  "priority": "Alta",
  "isCompleted": true,
  "userId": 1
}
```

El contrato establece los campos y tipos de datos que
debe contener una tarea:

- id: número entero que identifica la tarea.
- title: cadena de texto con el título.
- description: cadena de texto con la descripción.
- priority: cadena de texto con la prioridad.
- isCompleted: valor booleano que indica su estado.
- userId: número entero que identifica al usuario.

El método Task.fromJson permite convertir esta estructura
JSON en un objeto Task de Dart.

Actualmente se utilizan datos locales de ejemplo.
La conexión con una API queda prevista para futuras sesiones.


## API de tareas

En la Sesión 07 se integró una API REST en TaskFlow utilizando Dio, con el objetivo de obtener tareas desde un servidor y mostrarlas en la aplicación mediante la arquitectura MVVM.

### Endpoint utilizado

- **API:** JSONPlaceholder
- **URL base:** https://jsonplaceholder.typicode.com
- **Endpoint:** `/todos`
- **Método HTTP:** GET
- **Parámetro:** `userId=2`
- **URL completa:** https://jsonplaceholder.typicode.com/todos?userId=2

Se seleccionó el usuario 2 para comprobar que TaskFlow puede consultar tareas de diferentes usuarios.

### Campos recibidos

La API proporciona cuatro campos:

- `userId`: identificador del usuario.
- `id`: identificador de la tarea.
- `title`: título de la tarea.
- `completed`: estado de finalización.

### Adaptación al modelo Task

El modelo de TaskFlow conserva seis campos. Como la API no proporciona descripción ni prioridad, se utilizan los siguientes valores predeterminados:

- `description`: Sin descripción (API).
- `priority`: Sin prioridad (API).

Además, el campo `completed` se convierte en `isCompleted` mediante `Task.fromJson()`.

### Arquitectura utilizada

La aplicación mantiene la arquitectura MVVM y utiliza la siguiente secuencia:

Service → Repository → ViewModel → Interfaz.

`TaskApiService` realiza la solicitud HTTP mediante Dio. `RemoteTaskRepository` obtiene y conserva temporalmente los datos. `TasksViewModel` administra las tareas y notifica a la interfaz mediante Provider.

### Actualización del estado

Cuando se marca una tarea como completada, el cambio se realiza únicamente en memoria. Todavía no se envía una actualización al servidor, por lo que al reiniciar la aplicación se recupera el estado original de la API.

## Sesión 08 — Estados de carga, éxito, vacío y error

En esta sesión se implementó el manejo de los estados de la consulta remota de tareas mediante ChangeNotifier, Provider, context.watch y context.read.

### Estados de la aplicación

| Estado | Comportamiento | Prueba realizada |
|---|---|---|
| Carga | Indicador circular y mensaje «Cargando tus tareas...». | Se presionó el icono de actualización. |
| Éxito | Listado remoto con la cantidad de tareas disponibles. | Se consultó la API con el parámetro userId = 2 y conexión a internet. |
| Vacío | Icono, mensaje informativo y botón Actualizar. | Se cambió temporalmente el parámetro userId a 9999. |
| Error | Icono, mensaje de error y botón Reintentar. | Se desactivó la conexión a internet y se actualizó el listado. |

### Trabajo autónomo incremental

Se personalizaron los mensajes, iconos y botones de los diferentes estados de TaskFlow. También se incorporó un contador de tareas en la barra superior.

Se comprobó que el botón Reintentar permite recuperar el listado remoto después de restablecer la conexión a internet, sin necesidad de reiniciar la aplicación.

Se conservó la navegación al detalle, la actualización mediante el gesto de deslizar hacia abajo y la opción de marcar tareas como completadas de manera local.

Finalmente, se restauró el parámetro userId = 2 para mantener la consulta remota de tareas.
