import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

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
    // notes = [];
    // for (int i = 0; i < _myNotes.length; i++) {
    //   notes.add(_myNotes.getAt(i));
    // }
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
    // setState(() {
    //   titleController.text = newNote['title'];
    //   contentController.text = newNote['content'];
    // });
    await _myNotes.put(key, newNote);
    getNotes();
    titleController.clear();
    contentController.clear();
  }

  void _showForm (BuildContext context, int? key) async {
    if(key != null){

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
            bottom: MediaQuery.of(context).viewInsets.bottom + 20
            ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15)
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: const Offset(0, 3)
              )
            ],
          ),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(
                  top: 20,
                  bottom: 10
                  ),
                child: Center(
                  child: Text(
                    'Add a note',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                
                ),
              ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: 'Enter your note title'
                ),
              ),
              const SizedBox(height: 20,),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  hintText: 'Enter your note content'
                ),
              ),
              const SizedBox(height: 20,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
                onPressed: (){
                  String title = titleController.text;
                  String content = contentController.text;

                  if(!(title.isEmpty || content.isEmpty)) {
                    if(key == null){
                      storeData(
                        {
                          'title': title.toString(),
                          'content': content.toString()
                        }
                      );
                      titleController.clear();
                      contentController.clear();
                    }else{
                      updateData(
                        key, 
                        {
                          'title': title.toString(),
                          'content': content.toString()
                        });
                    }
                    getNotes();
                    Navigator.pop(context);
                  }

                }, 
                child: Text(key == null ? 'Edit Notes' : 'Add Note')
              ),
            ],
          
          ),
        );
      }
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      getNotes();
      print(_myNotes.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      data: IconThemeData(
                        color: Colors.red
                      ), 
                      child: Icon(Icons.delete),
                    ),
                    onPressed: () {
                      deleteData(index);
                    },
                  ),
                  IconButton(
                    icon: const IconTheme(
                      data: IconThemeData(
                        color: Colors.blue
                      ), 
                      child: Icon(Icons.mode_edit),
                    ),
                    onPressed: () {
                      _showForm(context, notes[index]['key']);
                      setState(() {
                        titleController.text = notes[index]['title'];
                        contentController.text = notes[index]['content'];
                      });
                      // updateData(
                      //   notes[index]['key'], 
                      //   {
                      //     'title' : notes[index]['title'],
                      //     'content' : notes[index]['content'],
                      //   }
                      //   );
                    },
                  ),
                ],
              )
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showForm(context, null);
        },
        backgroundColor: Colors.blue,
          child: const IconTheme(
            data: IconThemeData(
              color: Colors.white
            ), 
            child: Icon(Icons.add),
          ),
      ),
    );
  }
}