import 'package:flutter/material.dart';
import 'package:notesapp/home_screen.dart';
import 'package:notesapp/note_service.dart';

class AddAndUpdateNotes extends StatefulWidget {
  final String? title;
  final String? description;
  final String? id;
  const AddAndUpdateNotes({super.key, this.title, this.description, this.id});

  @override
  State<AddAndUpdateNotes> createState() => _AddAndUpdateNotesState();
}

class _AddAndUpdateNotesState extends State<AddAndUpdateNotes> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final NotesService _notesService = NotesService();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.title ?? '';
    descriptionController.text = widget.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title != null ? 'Update Note' : 'Add Note',
          style: TextStyle(color: Colors.cyan),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.cyan),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hint: Text('Title'),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: descriptionController,
                maxLines: 12,
                decoration: InputDecoration(
                  hint: Text('Description'),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 50),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    widget.title != null
                        ? await _notesService.updateNote(
                            widget.id.toString(),
                            titleController.text,
                            descriptionController.text,
                          )
                        : await _notesService.createNote(
                            titleController.text,
                            descriptionController.text,
                          );
                    titleController.clear();
                    descriptionController.clear();

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  },
                  child: Text(
                    widget.title != null ? 'Update Note' : 'Add Note',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
