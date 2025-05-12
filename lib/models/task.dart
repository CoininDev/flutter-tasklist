class TaskModel {
  String name;
  bool done;

  TaskModel({required this.name, required this.done});

  Map<String, dynamic> toJson() => {'name': name, 'done': done};

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      TaskModel(name: json['name'], done: json['done']);
}
