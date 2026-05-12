import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback? onCheckboxChanged;

  const TaskCard({
    Key? key,
    required this.task,
    required this.isDark,
    required this.onTap,
    this.onCheckboxChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color priorityColor;
    switch (task.priority.toLowerCase()) {
      case 'tinggi':
        priorityColor = Colors.red;
        break;
      case 'sedang':
        priorityColor = Colors.orange;
        break;
      default:
        priorityColor = Colors.green;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: isDark ? const Color(0xFF16213E) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 4,
          height: 50,
          decoration: BoxDecoration(
            color: priorityColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.grey[800],
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${task.deadline.day} ${_getMonthName(task.deadline.month)} ${task.deadline.year}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onCheckboxChanged != null)
              Checkbox(
                value: task.isCompleted,
                onChanged: (_) => onCheckboxChanged!(),
                activeColor: const Color(0xFF4A90E2),
              ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    // Cegah error jika bulan di luar range 1-12
    if (month < 1 || month > 12) return '';
    return months[month - 1];
  }
}