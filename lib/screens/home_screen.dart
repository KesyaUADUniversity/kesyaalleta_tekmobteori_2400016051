import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import 'add_task_screen.dart';
import 'detail_task_screen.dart';
import 'informal_notes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    final isDark = provider.isDarkMode;
    
    List<Task> filteredTasks = provider.formalTasks;
    if (_filter == 'completed') {
      filteredTasks = filteredTasks.where((t) => t.isCompleted).toList();
    } else if (_filter == 'pending') {
      filteredTasks = filteredTasks.where((t) => !t.isCompleted).toList();
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A2E) : const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF16213E) : const Color(0xFF4A90E2),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo, Mahasiswa! 👋',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
            const Text(
              'Reminder Tugas',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              provider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: () => provider.toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.note_outlined, color: Colors.white),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const InformalNotesScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildFilterChip('Semua', 'all', isDark),
                const SizedBox(width: 8),
                _buildFilterChip('Belum Selesai', 'pending', isDark),
                const SizedBox(width: 8),
                _buildFilterChip('Selesai', 'completed', isDark),
              ],
            ),
          ),
          Expanded(
            child: filteredTasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 80,
                          color: isDark ? Colors.white24 : Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada tugas',
                          style: TextStyle(
                            fontSize: 18,
                            color: isDark ? Colors.white70 : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      return _buildTaskCard(task, isDark);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: isDark ? const Color(0xFFE94560) : const Color(0xFF4A90E2),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddTaskScreen()),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, bool isDark) {
    final isSelected = _filter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      backgroundColor: isDark ? const Color(0xFF16213E) : Colors.white,
      selectedColor: isDark ? const Color(0xFF0F3460) : const Color(0xFF4A90E2),
      labelStyle: TextStyle(
        color: isSelected 
            ? Colors.white 
            : (isDark ? Colors.white70 : Colors.grey[700]),
      ),
      onSelected: (selected) {
        setState(() => _filter = value);
      },
    );
  }

  Widget _buildTaskCard(Task task, bool isDark) {
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
            Checkbox(
              value: task.isCompleted,
              onChanged: (_) {
                Provider.of<TaskProvider>(context, listen: false)
                    .toggleTaskStatus(task.id);
              },
              activeColor: const Color(0xFF4A90E2),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailTaskScreen(taskId: task.id),
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return months[month - 1];
  }
}