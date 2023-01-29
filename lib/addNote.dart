import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

//My own files
import './home.dart';
import './editNote.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage();

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {

  late SharedPreferences _prefs; //for accessing shared preferences

  late List<dynamic> notes; //to store the notes

  late List<String> bodys; //variable to store the body of the notes

  late List<String> titles; //variable to store the tilte of the notes

  late List<String> createdAtTimes; //list of the times the notes were created

  final _formKey = GlobalKey<FormState>(); //for editing forms

  String finalTitle = ""; //the final title to be saved/created

  String finalBody = ""; //the final body to be saved/created

  bool canSaveNote = false; //if the note can be saved

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getNotesList(); //get the notes value

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void saveNoteFunction() async {

    //ensure that the note being created is not empty
    if(finalTitle.isNotEmpty == true || finalBody.isNotEmpty == true) {

      titles.add(finalTitle); //add the new title to the list of titles

      bodys.add(finalBody); //add the new body to the list of bodies

      String currentDateTime = DateTime.now().toString();
      // example of the current value of currentDateTime is 2021-08-27 19:14:57.142575

      createdAtTimes.add(currentDateTime); //store the new createdAtTime to the list of created at times

      _prefs.setStringList("titles", titles); //save it to the titles shared preferences

      _prefs.setStringList("bodys", bodys); //save it to the titles shared preferences

      _prefs.setStringList("createdAtTimes", createdAtTimes); //save it to the titles shared preferences

      //go back to homepage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    }
  }

  //function to get the notes list
  _getNotesList() async {

    notes = []; //set the notes list to an empty one

    bodys = []; //set the bodies list to an empty one

    titles = []; //set the titles list to an empty one

    createdAtTimes = [];

    _prefs = await SharedPreferences.getInstance(); //get the shared preferences instance
    if (_prefs.getStringList("bodys") != null) {
      bodys = _prefs.getStringList("bodys")!.toList();
      setState(() {});
    }

    if (_prefs.getStringList("titles") != null) {

      titles = _prefs.getStringList("titles")!.toList();
      setState(() {});
    }

    if (_prefs.getStringList("createdAtTimes") != null) {
      createdAtTimes = _prefs.getStringList("createdAtTimes")!.toList();
      setState(() {});
    }

    //ensure the newly entered note is not empty
    if(bodys.isNotEmpty == true || titles.isNotEmpty == true || createdAtTimes.isNotEmpty == true) {

      List<dynamic> testNotes = [];
      for(int i = 0; i < bodys.length; i++) {
        var n = {
          "title": titles[i],
          "body": bodys[i],
          "createdAtTime": createdAtTimes[i]
        };

        testNotes.add(n);
        
      }

      setState(() {

        for (var value in testNotes.reversed) {

          notes.add(value);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the AddNotePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("LimNotes"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              child: const Icon(Icons.check),
              onTap: saveNoteFunction,
            ),
          )
        ],
      ),
      body: Form(  
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[  
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Input title',
              ),
              onChanged: (String titleInput) {
                //
                finalTitle = titleInput;

                //if the title is empty, disable the save function from working
                if(titleInput == "" || titleInput.isEmpty == true || finalTitle == "" || finalTitle.isEmpty == true) {
                  setState(() {
                    canSaveNote = false;
                  });
                } else {
                  setState(() {
                    canSaveNote = true;
                  });
                }
              },
            ),
            TextFormField(
              keyboardType: TextInputType.multiline,
              minLines: 8,
              maxLines: null, // <-- SEE HERE
              onChanged: (String bodyInput) {
                
                finalBody = bodyInput;

                //if the body is empty, disable the save function from working
                if(bodyInput == "" || bodyInput.isEmpty == true || finalBody == "" || finalBody.isEmpty == true) {
                  setState(() {
                    canSaveNote = false;
                  });
                } else {
                  setState(() {
                    canSaveNote = true;
                  });
                }
              },
            ),
          ],  
        ),  
      )
    );
  }
}