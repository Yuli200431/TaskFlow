import '../domain/task.dart';
import 'task_repository.dart';

class LocalTaskRepository implements TaskRepository {
  final List<Task> _tasks = [
    const Task(
      id: 1,
      title: 'Revisar requisitos de la Etapa 3',
      description: 'Analizar las nuevas indicaciones del proyecto ForáneoGo',
      priority: 'Alta',
      isCompleted: true,
      userId: 1,
    ),
    const Task(
      id: 2,
      title: 'Analizar la nueva fuente de verdad',
      description: 'Definir cómo se administrarán los datos del sistema',
      priority: 'Alta',
      isCompleted: true,
      userId: 1,
    ),
    const Task(
      id: 3,
      title: 'Adaptar los repositorios de datos',
      description: 'Actualizar el acceso a los datos de la aplicación',
      priority: 'Alta',
      isCompleted: false,
      userId: 1,
    ),
    const Task(
      id: 4,
      title: 'Integrar la aplicación con el servidor',
      description: 'Conectar ForáneoGo con los servicios remotos',
      priority: 'Alta',
      isCompleted: false,
      userId: 1,
    ),
    const Task(
      id: 5,
      title: 'Realizar pruebas de integración',
      description: 'Verificar la comunicación y el funcionamiento',
      priority: 'Media',
      isCompleted: false,
      userId: 1,
    ),
  ];

  @override
  Future<List<Task>> getTasks() async => List.unmodifiable(_tasks);

  @override
  void save(Task task) {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index == -1) return;
    _tasks[index] = task;
  }
}
