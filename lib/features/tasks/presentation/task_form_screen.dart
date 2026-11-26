import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TaskDraft {
  const TaskDraft(this.title, this.description, this.priority, {this.dueDate});

  final String title;
  final String description;
  final String priority;
  final DateTime? dueDate;
}

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _description = TextEditingController();

  String _priority = 'Media';
  DateTime? _dueDate;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? today,
      firstDate: today,
      lastDate: DateTime(now.year + 5),
    );

    if (!mounted || selectedDate == null) return;

    setState(() {
      _dueDate = selectedDate;
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final draft = TaskDraft(
      _title.text.trim(),
      _description.text.trim(),
      _priority,
      dueDate: _dueDate,
    );

    context.pop(draft);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva tarea')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Completa los datos de tu nueva tarea.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            TextFormField(
              controller: _title,
              decoration: const InputDecoration(
                labelText: 'Título de la tarea',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                final title = value?.trim() ?? '';

                if (title.isEmpty) {
                  return 'El título de la tarea es obligatorio.';
                }

                if (title.length < 3) {
                  return 'Ingresa al menos 3 caracteres.';
                }

                return null;
              },
            ),

            const SizedBox(height: 16),

            TextFormField(
              controller: _description,
              decoration: const InputDecoration(
                labelText: 'Descripción (opcional)',
                prefixIcon: Icon(Icons.description_outlined),
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              initialValue: _priority,
              decoration: const InputDecoration(
                labelText: 'Nivel de prioridad',
                prefixIcon: Icon(Icons.flag_outlined),
                border: OutlineInputBorder(),
              ),
              items: ['Alta', 'Media', 'Baja']
                  .map(
                    (value) =>
                        DropdownMenuItem(value: value, child: Text(value)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _priority = value ?? 'Media';
                });
              },
            ),

            const SizedBox(height: 16),

            OutlinedButton.icon(
              onPressed: _selectDate,
              icon: const Icon(Icons.calendar_today),
              label: Text(
                _dueDate == null
                    ? 'Seleccionar fecha (opcional)'
                    : 'Fecha: ${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
              ),
            ),

            if (_dueDate != null)
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _dueDate = null;
                  });
                },
                icon: const Icon(Icons.close),
                label: const Text('Quitar fecha'),
              ),

            const SizedBox(height: 24),

            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.check),
              label: const Text('Guardar tarea'),
            ),

            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancelar'),
            ),
          ],
        ),
      ),
    );
  }
}
