import 'package:flutter/material.dart';

void main() {
  runApp(const TaskFlowApp());
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Variables de la pantalla de bienvenida
    const studentName = 'Yuleis Mariley';
    const motivationalMessage =
        '¡Cada tarea completada te acerca a tu meta!';
    const pendingTasks = 3;
    const courseName = 'Desarrollo de aplicaciones móviles';

    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskFlow'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // Icono representativo de TaskFlow
            const Icon(
              Icons.task_alt,
              size: 64,
              color: Colors.indigo,
            ),

            const SizedBox(height: 24),

            // Saludo personalizado
            Text(
              '¡Hola, $studentName!',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 12),

            // Mensaje motivacional
            Text(
              motivationalMessage,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.indigo,
                    fontWeight: FontWeight.w500,
                  ),
            ),

            const SizedBox(height: 16),

            // Nombre de la asignatura
            Text(
              'Bienvenido/a a $courseName.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 32),

            // Tarjeta de tareas pendientes
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Row(
                  children: [
                    const Icon(
                      Icons.pending_actions,
                      color: Colors.indigo,
                    ),

                    const SizedBox(width: 12),

                    Text(
                      'Tareas pendientes: $pendingTasks',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}