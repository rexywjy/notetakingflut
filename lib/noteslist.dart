import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'passcode.dart'; // Import your PinCodeWidget page here
import 'package:intl/intl.dart';

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
        'content': note['content'],
        'createdDate': note['createdDate'] ?? '',
        'lastUpdated': note['lastUpdated'] ?? '',
      };
    }).toList();
    setState(() {
      notes = data;
    });
  }

  Future<dynamic> storeData(Map<String, dynamic> newNote) async {
    await _myNotes.add(newNote);
    print(_myNotes.length);
    titleController.clear();
    contentController.clear();
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

  void _showForm(BuildContext context, int? key, int index) async {
    var createdDate;
    var lastUpdated;
    if (key != null) {
      final note = notes.firstWhere((note) => note['key'] == key);
      titleController.text = note['title'];
      contentController.text = note['content'];
      createdDate = note['createdDate'] == '' ? '-' : note['createdDate'];
      lastUpdated = note['lastUpdated'] == '' ? '-' : note['lastUpdated'];
    }

    if (index >= 0) {
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                TextField(
                  controller: titleController,
                  decoration:
                      const InputDecoration(hintText: 'Enter your note title'),
                ),
                const SizedBox(
                  height: 20,
                ),
                // TextField(
                //   maxLines: 8, //or null
                //   decoration: InputDecoration.collapsed(hintText: "Enter your text here"),
                // ),
                TextField(
                  controller: contentController,
                  maxLines: 8, //o
                  decoration: const InputDecoration(
                      hintText: 'Enter your note content'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Created Date : ' + createdDate,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Last Update : ' + lastUpdated,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(10))
                  ),
                  onPressed: () {
                    String title = titleController.text;
                    String content = contentController.text;

                    if (!(title.isEmpty || content.isEmpty)) {
                      if (key == null) {
                        storeData({
                          'title': title,
                          'content': content,
                          'createdDate': DateFormat.yMd()
                              .add_jm()
                              .format(DateTime.now())
                              .toString(),
                          'lastUpdated': DateFormat.yMd()
                              .add_jm()
                              .format(DateTime.now())
                              .toString(),
                        });
                      } else {
                        updateData(key, {
                          'title': title,
                          'content': content,
                          'lastUpdated': DateFormat.yMd()
                              .add_jm()
                              .format(DateTime.now())
                              .toString(),
                        });
                      }
                      getNotes();
                      Navigator.pop(context);
                    }
                  },
                  child: Text(key == null ? 'Add Note' : 'Edit Note'),
                ),
                const SizedBox(
                  height: 2,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (index >= 0) {
                      deleteData(index);
                    }
                    Navigator.pop(context);
                    titleController.clear();
                    contentController.clear();
                  },
                  child: Text('Delete Note'),
                  style: const ButtonStyle(
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                    backgroundColor: WidgetStatePropertyAll(Colors.red),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                TextField(
                  controller: titleController,
                  decoration:
                      const InputDecoration(hintText: 'Enter your note title'),
                ),
                const SizedBox(
                  height: 20,
                ),
                // TextField(
                //   maxLines: 8, //or null
                //   decoration: InputDecoration.collapsed(hintText: "Enter your text here"),
                // ),
                TextField(
                  controller: contentController,
                  maxLines: 8, //o
                  decoration: const InputDecoration(
                      hintText: 'Enter your note content'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(10))
                  ),
                  onPressed: () {
                    String title = titleController.text;
                    String content = contentController.text;

                    if (!(title.isEmpty || content.isEmpty)) {
                      if (key == null) {
                        storeData({
                          'title': title,
                          'content': content,
                          'createdDate': DateFormat.yMd()
                              .add_jm()
                              .format(DateTime.now())
                              .toString(),
                          'lastUpdated': DateFormat.yMd()
                              .add_jm()
                              .format(DateTime.now())
                              .toString(),
                        });
                      } else {
                        updateData(key, {
                          'title': title,
                          'content': content,
                          'lastUpdated': DateFormat.yMd()
                              .add_jm()
                              .format(DateTime.now())
                              .toString(),
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
        flexibleSpace: const Center(
          child: Padding(
            padding:
                EdgeInsets.only(top: 0.0), // Adjust bottom padding as needed
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
        automaticallyImplyLeading:
            true, // This should be true to show the back button
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: GridView.builder(
          // ListView.builder(
          // ListView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            // crossAxisCount: 2,
            // crossAxisSpacing: 10,
            // mainAxisSpacing: 10,
            crossAxisCount: 2,
            childAspectRatio: 1.0,
            crossAxisSpacing: 0.0,
            mainAxisSpacing: 5,
            mainAxisExtent: 200,
          ),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          itemCount: notes.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                _showForm(context, notes[index]['key'], index);
              },
              child: Card(
                elevation: 5,
                // margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(
                    notes[index]['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notes[index]['content'],
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Updated: ${notes[index]['lastUpdated']}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  // trailing: Row(
                  //   mainAxisSize: MainAxisSize.min,
                  //   children: [
                  //     IconButton(
                  //       icon: const IconTheme(
                  //         data: IconThemeData(color: Colors.red),
                  //         child: Icon(Icons.delete),
                  //       ),
                  //       onPressed: () {
                  //         deleteData(index);
                  //       },
                  //     ),
                  //     IconButton(
                  //       icon: const IconTheme(
                  //         data: IconThemeData(color: Colors.blue),
                  //         child: Icon(Icons.mode_edit),
                  //       ),
                  //       onPressed: () {
                  //         _showForm(context, notes[index]['key']);
                  //       },
                  //     ),
                  //   ],
                  // ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showForm(context, null, -1);
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
