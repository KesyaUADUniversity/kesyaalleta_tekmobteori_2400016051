class Task {
  final String id;
  String title;
  String description;
  DateTime deadline;
  String priority;
  bool isCompleted;
  final bool isFormal;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.deadline,
    required this.priority,
    this.isCompleted = false,
    this.isFormal = true,
  });
}