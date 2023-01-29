import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

//My own files
import './home.dart';
import './services/local_notification_service.dart';

class EditNotePage extends StatefulWidget {

  late List<dynamic> notes;
  
  //late int noteIndex;

  //late int noteIndex;
  var noteToEdit;

  //EditNotePage(this.noteIndex);
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
  //final SharedPreferences _prefs = SharedPreferences.getInstance();
  late SharedPreferences _prefs;

  late List<dynamic> notes;

  late List<String> bodys;

  late List<String> titles;

  late List<String> createdAtTimes;

  late int noOfNotificationsCreated;

  final _formKey = GlobalKey<FormState>();

  String finalTitle = "";

  String finalBody = "";

  late String createdAt;

  bool canSaveNote = false;

  bool canEdit = false;
  //bool canEdit = true;

  String formattedDate = "";

  //late int noteIndex;
  int noteIndex = 0;
  //int? noteIndex;
  var noteToEdit;

  int _counter = 0;

  late final LocalNotificationService service;

  TextEditingController titleTextFormFieldController = TextEditingController();

  TextEditingController bodyTextFormFieldController = TextEditingController();

  void saveNoteFunction() async {
    //if((finalTitle != "" || finalTitle.isEmpty == false) || (finalBody != "" || finalBody.isEmpty == false)) {
    //if(!(finalTitle == "" || finalTitle.isEmpty == true) && (finalBody == "" || finalBody.isEmpty == true)) {
    //if(finalTitle.isEmpty != false || finalBody.isEmpty != false || (finalTitle.isEmpty != false && finalBody.isEmpty != false)) {

    print("saveNotFunction noteIndex: " + noteIndex.toString());
    if(finalTitle.isNotEmpty == true || finalBody.isNotEmpty == true) {
      //return null;

      List<String> reversedTitles = [];
      List<String> reversedBodys = [];
      List<String> reversedCreatedAtTimes = [];

      for (var value in titles.reversed) {
        //stdout.write(" $value ");

        reversedTitles.add(value);
      }

      for (var value in bodys.reversed) {
        //stdout.write(" $value ");

        reversedBodys.add(value);
      }

      for (var value in createdAtTimes.reversed) {
        //stdout.write(" $value ");

        reversedCreatedAtTimes.add(value);
      }

      titles[noteIndex] = finalTitle;
      //reversedTitles[noteIndex] = finalTitle;
      //Remove item by specifying the position of the item in the list
      //reversedTitles.removeAt(noteIndex);
      //titles.removeAt(noteIndex);
      //titles[noteIndex] = titleTextFormFieldController.text;

      bodys[noteIndex] = finalBody;
      //reversedBodys[noteIndex] = finalBody;
      //reversedBodys.removeAt(noteIndex);
      //bodys.removeAt(noteIndex);
      //bodys[noteIndex] = bodyTextFormFieldController.text;

      List<String> newTitles = [];
      List<String> newBodys = [];
      List<String> newCreatedAtTimes = [];

      String currentDateTime = DateTime.now().toString();
      // example of the current value of currentDateTime is 2021-08-27 19:14:57.142575

      createdAtTimes[noteIndex] = currentDateTime;
      //reversedCreatedAtTimes[noteIndex] = currentDateTime;
      //reversedCreatedAtTimes.removeAt(noteIndex);
      //createdAtTimes.removeAt(noteIndex);

      for (var value in reversedTitles.reversed) {
        //stdout.write(" $value ");

        newTitles.add(value);
      }

      for (var value in reversedBodys.reversed) {
        //stdout.write(" $value ");

        newBodys.add(value);
      }

      for (var value in reversedCreatedAtTimes.reversed) {
        //stdout.write(" $value ");

        newCreatedAtTimes.add(value);
      }

      /*newTitles.add(finalTitle);
      newBodys.add(finalBody);
      newCreatedAtTimes.add(currentDateTime);*/

      _prefs.setStringList("titles", titles);
      //_prefs.setStringList("titles", newTitles);

      _prefs.setStringList("bodys", bodys);
      //_prefs.setStringList("bodys", newBodys);

      _prefs.setStringList("createdAtTimes", createdAtTimes);
      //_prefs.setStringList("createdAtTimes", newCreatedAtTimes);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );

    } else {
      //print("one or more fields are empty");
      print("There must be text in at least 1 field");
    }
  }

  void deleteNoteFunction() async {

    List<String> reversedTitles = [];
    List<String> reversedBodys = [];
    List<String> reversedCreatedAtTimes = [];

    for (var value in titles.reversed) {
      //stdout.write(" $value ");

      reversedTitles.add(value);
    }

    for (var value in bodys.reversed) {
      //stdout.write(" $value ");

      reversedBodys.add(value);
    }

    for (var value in createdAtTimes.reversed) {
      //stdout.write(" $value ");

      reversedCreatedAtTimes.add(value);
    }

    //reversedTitles.removeAt(noteIndex);
    titles.removeAt(noteIndex);

    //reversedBodys.removeAt(noteIndex);
    bodys.removeAt(noteIndex);

    //reversedCreatedAtTimes.removeAt(noteIndex);
    createdAtTimes.removeAt(noteIndex);

    List<String> newTitles = [];
    List<String> newBodys = [];
    List<String> newCreatedAtTimes = [];

    for (var value in reversedTitles.reversed) {
      //stdout.write(" $value ");

      newTitles.add(value);
    }

    for (var value in reversedBodys.reversed) {
      //stdout.write(" $value ");

      newBodys.add(value);
    }

    for (var value in reversedCreatedAtTimes.reversed) {
      //stdout.write(" $value ");

      newCreatedAtTimes.add(value);
    }

    _prefs.setStringList("titles", titles);
    //_prefs.setStringList("titles", newTitles);

    _prefs.setStringList("bodys", bodys);
    //_prefs.setStringList("bodys", newBodys);

    _prefs.setStringList("createdAtTimes", createdAtTimes);
    //_prefs.setStringList("createdAtTimes", newCreatedAtTimes);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage()),
    );

  }
  
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  //late int noteIndex;

  _getNoteList() async {

    print("getNoteList just ran");

    bodys = [];

    titles = [];

    createdAtTimes = [];
    
    notes = [];

    //noteIndex = widget.noteIndex;
    noteToEdit = widget.noteToEdit;

    /*print("The noteToEdit: \n");
    print(noteToEdit);
    print("\n");

    print("The noteIndex: " + noteIndex.toString());*/

    _prefs = await SharedPreferences.getInstance();
    if (_prefs.getStringList("bodys") != null) {
      //todoList = prefs.getStringList("key");
      bodys = _prefs.getStringList("bodys")!.toList();
      setState(() {});
    }

    if (_prefs.getStringList("titles") != null) {
      //todoList = prefs.getStringList("key");
      titles = _prefs.getStringList("titles")!.toList();
      setState(() {});
    }

    if (_prefs.getStringList("createdAtTimes") != null) {
      //todoList = prefs.getStringList("key");
      createdAtTimes = _prefs.getStringList("createdAtTimes")!.toList();
      setState(() {});
    }

    if(bodys.isNotEmpty == true || titles.isNotEmpty == true || createdAtTimes.isNotEmpty == true) {

      List<dynamic> testNotes = [];
      for(int i = 0; i < bodys.length; i++) {
        var n = {
          "title": titles[i],
          "body": bodys[i],
          "createdAtTime": createdAtTimes[i]
        };

        //testNotes.add(n);
        notes.add(n);
      }

      /*print("\n notes:");
      print(notes);
      print("\n noteToEdit:");
      print(noteToEdit);
      print("\n noteIndex:");
      print(noteIndex);*/

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
        //notes = testNotes;

        //sort the notes from most recent to first (last to first)
        //and store it in the notes variable
        /*List<dynamic> reorderedTestNotes = [];

        for(int i = 0; i < testNotes.length; i++) {
          reorderedTestNotes[i]
        }*/

        for (var value in testNotes.reversed) {
          //stdout.write(" $value ");

          //notes.add(value);-
        }

        titleTextFormFieldController.text = notes[noteIndex]["title"];
        //titleTextFormFieldController.text = noteToEdit["title"];

        bodyTextFormFieldController.text = notes[noteIndex]["body"];
        //bodyTextFormFieldController.text = noteToEdit["body"];

        finalTitle = notes[noteIndex]["title"];
        //finalTitle = noteToEdit["title"];

        finalBody = notes[noteIndex]["body"];
        //finalBody = noteToEdit["body"];

        //finalCreatedAtTime = notes[noteIndex]["createdAtTime"];
      });

      print(notes);

      createdAt = notes[noteIndex]["createdAtTime"].toString();
      //createdAt = noteToEdit["createdAtTimes"].toString();

      print(createdAt);

      DateTime dt = DateTime.parse(createdAt);
      
      //formattedDate = DateFormat('MMMM dd jm MMMd').format(dt);

      //formattedDate = DateFormat('MMMM dd jm MMMd').format(dt); //October 02 j9 Oct2

      formattedDate = DateFormat('MMMM d h:mma EE').format(dt); //October 2 7:09PM Sun

      //formattedDate = DateFormat('MM dd').format(dt);

      //formattedDate = "Test Date";

      selectedTime = TimeOfDay.fromDateTime(selectedDate);
    }
  }

  //DateTime selectedDate = DateTime.now();
  //TimeOfDay selectedTime = TimeOfDay.now();
  late DateTime selectedDate;
  late TimeOfDay selectedTime;
  DateTime dateTime = DateTime.now();
  bool showDate = false;
  bool showTime = false;
  bool showDateTime = false;

  //Select for Date
  Future<DateTime> _selectDate(BuildContext context) async {
    var currentDate = DateTime.now();

    final selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      //firstDate: DateTime(2000),
      //firstDate: DateTime.now(),
      firstDate: currentDate,
      lastDate: DateTime(currentDate.year + 20)
    );

    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
    return selectedDate;
  }

  //Select for Time
  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (selected != null && selected != selectedTime) {
      setState(() {
        selectedTime = selected;
      });
    }
    return selectedTime;
  }
  
  //select date time picker
  Future _selectDateTime(BuildContext context) async {
    final date = await _selectDate(context);
      if (date == null) return;

    final time = await _selectTime(context);

      if (time == null) return;
    setState(() {
      dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  String getDateTime() {
    // ignore: unnecessary_null_comparison
    if (dateTime == null) {
      return 'select date timer';
    } else {

      //return DateFormat('yyyy-MM-dd HH: ss a').format(dateTime);
      
      //return DateFormat('yyyy-MM-dd HH: mm a').format(dateTime);

      /*DateTime dt1 = DateTime.parse("2021-12-23 11:47:00");
      DateTime dt2 = DateTime.parse("2018-02-27 10:09:00");

      if(dt1.isBefore(dt2)){
        print("DT1 is before DT2");
      }*/
      
      DateTime todaysDate = DateTime.now();
      DateTime dateToCheck = dateTime;

      if(dateToCheck.isBefore(todaysDate)){
        print("DT1 is before DT2");

        return DateFormat('yyyy-MM-dd HH: mm a').format(dateTime) + " Expired";

        //return "Expired!";
      } else {
        return DateFormat('yyyy-MM-dd HH: mm a').format(dateTime);

        //return "still on point";
      }
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
              //child: Icon(Icons.delete_outline),
              child: const Icon(Icons.delete),
              //onTap: canSaveNote ? saveNoteFunction : null/*() {
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
                        //onPressed: () => Navigator.pop(context, 'Proceed'),
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
                //onTap: canSaveNote ? saveNoteFunction : null/*() {
                onTap: saveNoteFunction/*() {
                  if((finalTitle != "" || finalTitle.isEmpty == false) || (finalTitle != "" || finalTitle.isEmpty == false)) {
                    return null;
                  }
                }*/,
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
                  //icon: const Icon(Icons.person),  
                  hintText: 'Input title',  
                  //labelText: 'Name',  
                ),
                //controller: titleTextFormFieldController,
                //initialValue: notes[noteIndex]["title"],
                initialValue: noteToEdit["title"],
                onChanged: (String titleInput) {
                  //
                  //finalTitle = titleInput;

                  setState(() {
                    finalTitle = titleInput;
                  });

                  /*if(titleInput == "" || titleInput.isEmpty == true || finalTitle == "" || finalTitle.isEmpty == true) {
                    setState(() {
                      canSaveNote = false;
                    });
                  } else {
                    setState(() {
                      canSaveNote = true;
                    });
                  }*/
                }/*,
                onTap: () {
                  if(canEdit == false) {
                    setState(() {
                      canEdit = true;
                    });
                  }
                }*/,
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
                //"Test New",
                style: const TextStyle(
                  fontSize: 12
                  //fontSize: 20
                )
              ),
            ),
            GestureDetector(
              child: TextFormField(
                enabled: canEdit,
                keyboardType: TextInputType.multiline,
                minLines: 8,
                maxLines: null, // <-- SEE HERE
                decoration: const InputDecoration(
                  //icon: const Icon(Icons.phone),  
                  //hintText: 'Enter a phone number',  
                  //labelText: 'Phone',  
                ),
                //controller: bodyTextFormFieldController,
                //initialValue: notes[noteIndex]["body"],
                initialValue: noteToEdit["body"],
                onChanged: (String bodyInput) {
                  //
                  //finalBody = finalBody;
                  //finalBody = bodyInput;

                  setState(() {
                    finalBody = bodyInput;
                  });

                  /*if(bodyInput == "" || bodyInput.isEmpty == true || finalBody == "" || finalBody.isEmpty == true) {
                    setState(() {
                      canSaveNote = false;
                    });
                  } else {
                    setState(() {
                      canSaveNote = true;
                    });
                  }*/
                },
                /*onTap: () {
                  if(canEdit == false) {
                    setState(() {
                      canEdit = true;
                    });
                  }
                },*/
                /*validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },*/
              ),
              onTap: () {
                if(canEdit == false) {
                  setState(() {
                    canEdit = true;
                  });
                }
              },
            ),
            /*TextFormField(  
              decoration: const InputDecoration(  
              icon: const Icon(Icons.calendar_today),  
              hintText: 'Enter your date of birth',  
              labelText: 'Dob',  
              ),  
            ),  
            new Container(  
              padding: const EdgeInsets.only(left: 150.0, top: 40.0),  
              child: new ElevatedButton(  
                child: const Text('Submit'),  
                  onPressed: null,  
              )
            ),*/
          ],  
        ),  
      ),
    );
  }
}