import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'task.dart';

void main() {
  runApp(const TaskFlowApp());
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}

// Tareas de ejemplo del proyecto ForáneoGo.
const demoTasks = [
  Task(
    id: 1,
    title: 'Revisar requisitos de la Etapa 3',
    description: 'Analizar las nuevas indicaciones del proyecto ForáneoGo',
    priority: 'Alta',
    isCompleted: true,
    userId: 1,
  ),
  Task(
    id: 2,
    title: 'Analizar la nueva fuente de verdad',
    description: 'Definir cómo se administrarán los datos del sistema',
    priority: 'Alta',
    isCompleted: true,
    userId: 1,
  ),
  Task(
    id: 3,
    title: 'Adaptar los repositorios de datos',
    description: 'Actualizar el acceso a los datos de la aplicación',
    priority: 'Alta',
    isCompleted: false,
    userId: 1,
  ),
  Task(
    id: 4,
    title: 'Integrar la aplicación con el servidor',
    description: 'Conectar ForáneoGo con los servicios remotos',
    priority: 'Alta',
    isCompleted: false,
    userId: 1,
  ),
  Task(
    id: 5,
    title: 'Realizar pruebas de integración',
    description: 'Verificar la comunicación y el funcionamiento',
    priority: 'Media',
    isCompleted: false,
    userId: 1,
  ),
];

// Busca una tarea por su identificador.
Task? findTask(int? id) {
  for (final task in demoTasks) {
    if (task.id == id) {
      return task;
    }
  }
  return null;
}

// Configuración de navegación.
final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const TaskListScreen()),
    GoRoute(
      path: '/task/:id',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '');
        return TaskDetailScreen(task: findTask(id));
      },
    ),
  ],
);

// Tarjeta de cada tarea.
class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, this.onTap});

  final Task task;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: task.isCompleted ? Colors.green : null,
        ),
        title: Text(task.title),
        subtitle: Text('${task.priority} · ${task.description}'),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

// Pantalla de bienvenida de las sesiones anteriores.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final String studentName = 'Yuleisi Moreira';

  static const dailyGoal = 5;

  int pendingTasks = 3;
  int completedTasks = 0;

  void _completeTask() {
    if (pendingTasks == 0) {
      return;
    }

    setState(() {
      pendingTasks--;

      if (completedTasks < dailyGoal) {
        completedTasks++;
      }
    });
  }

  void _addTask() {
    setState(() {
      pendingTasks++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final statusMessage = pendingTasks == 0
        ? '¡Excelente! No tienes tareas pendientes.'
        : 'Aún tienes tareas por organizar.';

    return Scaffold(
      appBar: AppBar(title: const Text('TaskFlow'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¡Hola, $studentName!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(statusMessage),
            Text('Completadas hoy: $completedTasks de $dailyGoal'),
            const SizedBox(height: 28),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(Icons.pending_actions),
                    const SizedBox(width: 12),
                    Text('Tareas pendientes: $pendingTasks'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Objetivo diario: $completedTasks de 5 tareas completadas',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (completedTasks >= dailyGoal)
              const Text(
                '¡Felicitaciones! Alcanzaste tu objetivo diario.',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              children: [
                ElevatedButton.icon(
                  onPressed: _addTask,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar tarea'),
                ),
                OutlinedButton.icon(
                  onPressed: pendingTasks == 0 ? null : _completeTask,
                  icon: const Icon(Icons.done),
                  label: const Text('Completar una tarea'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Pantalla principal: listado de tareas.
class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis tareas')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: demoTasks.length,
        itemBuilder: (context, index) {
          final task = demoTasks[index];

          return TaskCard(
            task: task,
            onTap: () => context.push('/task/${task.id}'),
          );
        },
      ),
    );
  }
}

// Pantalla de detalle de una tarea.
class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.task});

  final Task? task;

  @override
  Widget build(BuildContext context) {
    final selected = task;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de tarea')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: selected == null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('No se encontró esta tarea.'),
                  const SizedBox(height: 20),
                  FilledButton.tonalIcon(
                    onPressed: () =>
                        context.canPop() ? context.pop() : context.go('/'),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Volver al listado'),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selected.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Text(selected.description),
                  const SizedBox(height: 16),
                  Chip(label: Text('Prioridad: ${selected.priority}')),
                  const SizedBox(height: 12),
                  Text(
                    selected.isCompleted
                        ? 'Estado: completada'
                        : 'Estado: pendiente',
                  ),
                  const SizedBox(height: 12),
                  Text('Usuario: ${selected.userId}'),
                  const SizedBox(height: 20),
                  Card(
                    child: ListTile(
                      leading: Icon(
                        selected.isCompleted
                            ? Icons.check_circle
                            : Icons.pending_actions,
                        color: selected.isCompleted
                            ? Colors.green
                            : Colors.orange,
                      ),
                      title: Text(
                        selected.isCompleted
                            ? 'Tarea finalizada'
                            : 'Tarea por realizar',
                      ),
                      subtitle: Text(
                        selected.isCompleted
                            ? 'Esta actividad ya fue completada.'
                            : 'Esta actividad todavía está pendiente.',
                      ),
                    ),
                  ),
                  const Spacer(),
                  FilledButton.tonalIcon(
                    onPressed: () =>
                        context.canPop() ? context.pop() : context.go('/'),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Volver al listado'),
                  ),
                ],
              ),
      ),
    );
  }
}
