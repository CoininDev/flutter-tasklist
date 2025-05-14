import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testeflutter/controllers/task.dart';
import 'package:testeflutter/models/task.dart';

class TaskUI extends StatelessWidget {
  final TaskModel item;
  final int id;

  const TaskUI({super.key, required this.id, required this.item});

  @override
  Widget build(BuildContext ctx) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(ctx).primaryColorDark,
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: Checkbox(
          value: item.done,
          onChanged: (_) => ctx.read<TasksController>().toggleTask(id),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SelectableText(
              item.name,
              style: TextStyle(
                decoration:
                    item.done
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                color:
                    item.done
                        ? Theme.of(ctx).disabledColor
                        : Theme.of(ctx).indicatorColor,
              ),
            ),
            IconButton(
              onPressed: () => ctx.read<TasksController>().delTask(id),
              icon: Icon(Icons.remove),
              hoverColor: Colors.redAccent,
            ),
          ],
        ),
        onTap: () => ctx.read<TasksController>().toggleTask(id),
      ),
    );
  }
}
