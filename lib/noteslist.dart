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
  
  Future<dynamic> storeData(Map<String, dynamic> newNote) async {
    await _myNotes.add(newNote);
    print(_myNotes.length);
    
  }

  void _showForm (BuildContext context) async {
    showModalBottomSheet(
      elevation: 10,
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
              Padding(
                padding: const EdgeInsets.only(
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
                    storeData(
                      {
                        'title': title.toString(),
                        'content': content.toString()
                      }
                    );
                    titleController.clear();
                    contentController.clear();
                    Navigator.pop(context);
                  }

                }, 
                child: const Text('Add note')
              ),
              // ElevatedButton(
              //   onPressed: () {
              //     _myNotes.add({
              //       'title': titleController.text,
              //       'content': contentController.text
              //     });
              //     Navigator.pop(context);
              //   },
              //   child: const Text('Add note'),
              // )
            ],
          
          ),
        );
        // AlertDialog(
        //   title: const Text('Add a note'),
        //   content: TextField(
        //     decoration: const InputDecoration(
        //       hintText: 'Enter your note'
        //     ),
        //     onSubmitted: (String value) {
        //       _myNotes.add(value);
        //       Navigator.pop(context);
        //     },
        //   ),
        // );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showForm(context);
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