import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

//My own files
import './home.dart';

class EditNotePage extends StatefulWidget {

  late List<dynamic> notes; //the notes variable

  var noteToEdit; //the note to edit passed from the homepage

  EditNotePage(this.noteToEdit);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {

  late SharedPreferences _prefs; //an instance of shared preferences

  late List<dynamic> notes; // the notes variable

  late List<String> bodys; //the body of the notes variable

  late List<String> titles; //the title of the ntoes variable

  late List<String> createdAtTimes; //the createdAtTimes of the notes variable

  //late int noOfNotificationsCreated;

  final _formKey = GlobalKey<FormState>(); //for reading input from the form

  String finalTitle = ""; //the final title before been saved

  String finalBody = ""; //the final title before been saved

  late String createdAt; //the date and time the note was created

  bool canSaveNote = false; //determine if the note can be saved

  bool canEdit = false; //determine if the note can be edited

  String formattedDate = ""; //the formatted date to display

  int noteIndex = 0; //the inital index of the note to be edited in the list of all the notes

  var noteToEdit; //the note to edit

  //TextEditingController titleTextFormFieldController = TextEditingController();

  //TextEditingController bodyTextFormFieldController = TextEditingController();

  //function to save the note
  void saveNoteFunction() async {

    //print("saveNotFunction noteIndex: " + noteIndex.toString());
    //ensure the note is not empty before saving it
    if(finalTitle.isNotEmpty == true || finalBody.isNotEmpty == true) {

      titles[noteIndex] = finalTitle; //set the new title of the note to the new one

      bodys[noteIndex] = finalBody; //set the new body of the note to the new one

      String currentDateTime = DateTime.now().toString();
      // example of the current value of currentDateTime is 2021-08-27 19:14:57.142575

      createdAtTimes[noteIndex] = currentDateTime; //set the new createdAtTime of the note to the new one

      _prefs.setStringList("titles", titles); //save the new title

      _prefs.setStringList("bodys", bodys); //save the new body

      _prefs.setStringList("createdAtTimes", createdAtTimes); //save the new createdAtTime

      //go back to the homepage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );

    } else {
      //print("one or more fields are empty");
      //print("There must be text in at least 1 field");
    }
  }

  void deleteNoteFunction() async {

    titles.removeAt(noteIndex); //delete the note's title from the list of titles

    bodys.removeAt(noteIndex); //delete the note's body from the list of bodies

    createdAtTimes.removeAt(noteIndex); //delete the note's createdAtTime from the list of createdAtTimes

    _prefs.setStringList("titles", titles); //save the new list of titles to shared preferences

    _prefs.setStringList("bodys", bodys); //save the new list of bodies to shared preferences

    _prefs.setStringList("createdAtTimes", createdAtTimes); //save the new list of createdAtTimes to shared preferences

    //go back to the homepage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage()),
    );

  }

  //function to get the notes
  _getNoteList() async {

    //print("getNoteList just ran");

    bodys = []; //set the bodies list to an empty one initially

    titles = []; //set the titles list to an empty one initially

    createdAtTimes = []; //set the createdAtTimes list to an empty one initially
    
    notes = []; //set the notes list to an empty one initially

    noteToEdit = widget.noteToEdit; //from the widget passed from the homepage as a parameter

    _prefs = await SharedPreferences.getInstance(); //get the shared preferences
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

    //if notes actually exists, store it in the notes variable
    if(bodys.isNotEmpty == true || titles.isNotEmpty == true || createdAtTimes.isNotEmpty == true) {

      List<dynamic> testNotes = [];
      for(int i = 0; i < bodys.length; i++) {
        var n = {
          "title": titles[i],
          "body": bodys[i],
          "createdAtTime": createdAtTimes[i]
        };

        notes.add(n);
      }

      //get index of noteToEdit in notes
      setState(() {
        noteIndex = notes.indexWhere((element) => element["title"] == noteToEdit["title"] 
          && element["body"] == noteToEdit["body"]
          && element["createdAtTime"] == noteToEdit["createdAtTimes"]
        );
      });

      print("\n notes:");
      print(notes);
      print("\n noteToEdit:");
      print(noteToEdit);
      print("\n noteIndex:");
      print(noteIndex);

      //noteIndex = 0;

      print("The noteIndex: " + noteIndex.toString());

      setState(() {

        finalTitle = notes[noteIndex]["title"];

        finalBody = notes[noteIndex]["body"];
      });

      createdAt = notes[noteIndex]["createdAtTime"].toString(); //the datetime the note was created

      DateTime dt = DateTime.parse(createdAt);

      formattedDate = DateFormat('MMMM d h:mma EE').format(dt); //October 2 7:09PM Sun
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getNoteList(); //get the note value
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
        // Here we take the value from the EditNotePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("LimNotes"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: GestureDetector(
              child: const Icon(Icons.delete),
              onTap: () {
                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Delete Note?'),
                    content: const Text('Are you sure you want to delete this note?\n(You can\'t undo this action)'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: deleteNoteFunction,
                        child: const Text('Proceed'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Visibility(
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: GestureDetector(
                child: const Icon(Icons.check),
                onTap: saveNoteFunction,
              ),
            ),
            visible: canEdit
          )
        ],
      ),
      body: Form(  
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              child: TextFormField(
                enabled: canEdit,
                decoration: const InputDecoration( 
                  hintText: 'Input title',
                ),
                initialValue: noteToEdit["title"],
                onChanged: (String titleInput) {
                  
                  setState(() {
                    finalTitle = titleInput;
                  });
                },
              ),
              onTap: () {
                if(canEdit == false) {
                  setState(() {
                    canEdit = true;
                  });
                }
              }
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 2, left: 1),
              child: Text(
                formattedDate,
                style: const TextStyle(
                  fontSize: 12
                )
              ),
            ),
            GestureDetector(
              child: TextFormField(
                enabled: canEdit,
                keyboardType: TextInputType.multiline,
                minLines: 8,
                maxLines: null, // <-- SEE HERE
                initialValue: noteToEdit["body"],
                onChanged: (String bodyInput) {
                  
                  setState(() {
                    finalBody = bodyInput;
                  });
                },
              ),
              onTap: () {
                if(canEdit == false) {
                  setState(() {
                    canEdit = true;
                  });
                }
              },
            ),
          ],  
        ),  
      ),
    );
  }
}