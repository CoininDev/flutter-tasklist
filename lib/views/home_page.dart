import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testeflutter/controllers/task.dart';
import 'package:testeflutter/views/widgets/task.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<TasksController>();
    final tasks = ctrl.searchTasks();
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            searchBox(context, ctrl),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Text('Todas as tarefas:', style: TextStyle(fontSize: 20)),
            ),
            Expanded(
              child:
                  tasks.keys.isEmpty
                      ? ctrl.query.isEmpty
                          ? Text("Me faz um carinho....")
                          : Text("Nenhum resultado da busca encontrado :!")
                      : ListView.builder(
                        itemCount: tasks.keys.length,
                        itemBuilder: (context, index) {
                          final taskKeys = tasks.keys.toList();
                          final taskVals = tasks.values.toList();
                          return TaskUI(
                            id: taskKeys[index],
                            item: taskVals[index],
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => showDialog(
              context: context,
              builder: (context) => _NewTaskPopup(),
            ),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget searchBox(BuildContext ctx, TasksController ctrl) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Theme.of(ctx).primaryColorDark,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(7),
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(ctx).highlightColor,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 20, minHeight: 25),
          border: InputBorder.none,
          hintText: 'Pesquisar...',
        ),
        onChanged: (value) => ctrl.updateQuery(value),
      ),
    );
  }
}

class _NewTaskPopup extends StatelessWidget {
  void _confirm(BuildContext context, TextEditingController textCtrl) {
    final title = textCtrl.text.trim();
    if (title.isNotEmpty) {
      final tasksCtrl = context.read<TasksController>();
      tasksCtrl.addTask(title);
    }
    Navigator.of(context).pop();
  }

  void _cancel(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController textCtrl = TextEditingController();

    return AlertDialog(
      title: Text("Nova Tarefa:"),
      content: TextField(
        controller: textCtrl,
        autofocus: true,
        onSubmitted: (value) => _confirm(context, textCtrl),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(7),
          border: InputBorder.none,
          hintText: 'Ex. checar e-mails.',
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
      actions: [
        TextButton(onPressed: () => _cancel(context), child: Text('Cancelar')),
        ElevatedButton(
          onPressed: () => _confirm(context, textCtrl),
          child: Text('Salvar'),
        ),
      ],
    );
  }
}
