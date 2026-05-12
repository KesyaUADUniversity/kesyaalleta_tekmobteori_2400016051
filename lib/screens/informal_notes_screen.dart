import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class InformalNotesScreen extends StatefulWidget {
  const InformalNotesScreen({Key? key}) : super(key: key);

  @override
  State<InformalNotesScreen> createState() => _InformalNotesScreenState();
}

class _InformalNotesScreenState extends State<InformalNotesScreen> {
  final _noteController = TextEditingController();

  void _addNote() {
    if (_noteController.text.isNotEmpty) {
      Provider.of<TaskProvider>(context, listen: false)
          .addInformalNote(_noteController.text, false);
      _noteController.clear();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    final isDark = provider.isDarkMode;
    final notes = provider.informalNotes;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A2E) : const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF16213E) : const Color(0xFF4A90E2),
        elevation: 0,
        // Tombol Back Otomatis Ada di Sini
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('To-Do List', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            SizedBox(width: 8),
            Text('🌈', style: TextStyle(fontSize: 24)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            onPressed: () => _showAddNoteDialog(context),
          ),
        ],
      ),
      body: notes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.note_outlined,
                    size: 100,
                    color: isDark ? Colors.white24 : Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada catatan informal',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white70 : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + untuk menambahkan',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white54 : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return _buildNoteCard(note, isDark, provider);
              },
            ),
    );
  }

  Widget _buildNoteCard(Map<String, dynamic> note, bool isDark, dynamic provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: isDark ? const Color(0xFF16213E) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Checkbox(
          value: note['completed'],
          onChanged: (_) => provider.toggleNoteStatus(note['id']),
          activeColor: Colors.green,
        ),
        title: Text(
          note['note'],
          style: TextStyle(
            fontSize: 16,
            color: isDark ? Colors.white : Colors.grey[800],
            decoration: note['completed'] ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          onPressed: () => provider.deleteNote(note['id']),
        ),
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Provider.of<TaskProvider>(context, listen: false).isDarkMode 
            ? const Color(0xFF16213E) 
            : Colors.white,
        title: const Text('Tambah Catatan'),
        content: TextField(
          controller: _noteController,
          style: TextStyle(
            color: Provider.of<TaskProvider>(context, listen: false).isDarkMode 
                ? Colors.white 
                : Colors.black,
          ),
          decoration: InputDecoration(
            hintText: 'Masukkan catatan...',
            hintStyle: TextStyle(
              color: Provider.of<TaskProvider>(context, listen: false).isDarkMode 
                  ? Colors.white54 
                  : Colors.grey,
            ),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(
                color: Provider.of<TaskProvider>(context, listen: false).isDarkMode 
                    ? Colors.white70 
                    : Colors.grey[700],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _addNote,
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}