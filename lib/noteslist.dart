import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'passcode.dart'; // Import your PinCodeWidget page here

class NoteList extends StatefulWidget {
  const NoteList({super.key});

  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  final _myNotes = Hive.box('notes');
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  List<Map<String, dynamic>> notes = [];

  Future<void> getNotes() async {
    final data = _myNotes.keys.map((key) {
      final note = _myNotes.get(key);
      return {
        'key': key,
        'title': note['title'],
        'content': note['content']
      };
    }).toList();
    setState(() {
      notes = data;
    });
  }

  Future<dynamic> storeData(Map<String, dynamic> newNote) async {
    await _myNotes.add(newNote);
    print(_myNotes.length);
  }

  Future<dynamic> deleteData(int index) async {
    await _myNotes.deleteAt(index);
    print(_myNotes.length);
    getNotes();
  }

  Future<dynamic> updateData(int key, Map<String, dynamic> newNote) async {
    await _myNotes.put(key, newNote);
    getNotes();
    titleController.clear();
    contentController.clear();
  }

  void _showForm(BuildContext context, int? key) async {
    if (key != null) {
      final note = notes.firstWhere((note) => note['key'] == key);
      titleController.text = note['title'];
      contentController.text = note['content'];
    }

    showModalBottomSheet(
      elevation: 10,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 3))
            ],
          ),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: Center(
                  child: Text(
                    'Add a note',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                    hintText: 'Enter your note title'),
              ),
              const SizedBox(height: 20,),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                    hintText: 'Enter your note content'),
              ),
              const SizedBox(height: 20,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () {
                  String title = titleController.text;
                  String content = contentController.text;

                  if (!(title.isEmpty || content.isEmpty)) {
                    if (key == null) {
                      storeData({
                        'title': title,
                        'content': content
                      });
                    } else {
                      updateData(key, {
                        'title': title,
                        'content': content
                      });
                    }
                    getNotes();
                    Navigator.pop(context);
                  }
                },
                child: Text(key == null ? 'Add Note' : 'Edit Note'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 40.0), // Adjust bottom padding as needed
            child: Text(
              'Notes',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
        ),
        automaticallyImplyLeading: true, // This should be true to show the back button
        leading: IconButton(
          icon: Icon(Icons.logout), // Change this to your logout icon
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PinCodeWidget()),
            );
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 5,
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(notes[index]['title']),
              subtitle: Text(notes[index]['content']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const IconTheme(
                      data: IconThemeData(color: Colors.red),
                      child: Icon(Icons.delete),
                    ),
                    onPressed: () {
                      deleteData(index);
                    },
                  ),
                  IconButton(
                    icon: const IconTheme(
                      data: IconThemeData(color: Colors.blue),
                      child: Icon(Icons.mode_edit),
                    ),
                    onPressed: () {
                      _showForm(context, notes[index]['key']);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showForm(context, null);
        },
        backgroundColor: Colors.blue,
        child: const IconTheme(
          data: IconThemeData(color: Colors.white),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
