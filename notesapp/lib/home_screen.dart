import 'package:flutter/material.dart';
import 'package:notesapp/add_and_update_notes.dart';
import 'package:notesapp/note_service.dart'; // Add this

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotesService _notesService = NotesService();
  @override
  void initState() {
    super.initState();
    _notesService.getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes App', style: TextStyle(color: Colors.cyan)),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.cyan),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder(
        future: _notesService.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No notes found'));
          }

          List notesList = snapshot.data!;

          return ListView.builder(
            itemCount: notesList.length,
            itemBuilder: (context, index) {
              final note = notesList[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Card(
                  child: ListTile(
                    onTap: () {},
                    leading: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddAndUpdateNotes(
                              title: note['title'],
                              description: note['description'],
                              id: note['_id'],
                            ),
                          ),
                        );

                        setState(() {});
                      },
                      icon: Icon(Icons.edit, color: Colors.blue),
                    ),
                    title: Text(note['title']),
                    subtitle: Text(note['description']),
                    trailing: IconButton(
                      onPressed: () async {
                        await _notesService.deleteNote(note['_id']);
                        setState(() {});
                      },
                      icon: Icon(Icons.delete, color: Colors.red),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddAndUpdateNotes()),
          );
          setState(() {});
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
