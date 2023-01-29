import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

//My own files
import './home.dart';
import './editNote.dart';
import './services/local_notification_service.dart';

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
  //final SharedPreferences _prefs = SharedPreferences.getInstance();
  late SharedPreferences _prefs;

  late List<dynamic> notes;

  late List<String> bodys;

  late List<String> titles;

  late List<String> createdAtTimes;

  late List<String> reminders;

  final _formKey = GlobalKey<FormState>();

  String finalTitle = "";

  String finalBody = "";

  String finalReminder = "";

  bool canSaveNote = false;

  int _counter = 0;

  late final LocalNotificationService service;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getNotesList(); //get the notes value

    service = LocalNotificationService();
    service.initialize(); //initialize the service
    listenTiNotification();
  }

  void saveNoteFunction() async {
    //if((finalTitle != "" || finalTitle.isEmpty == false) || (finalBody != "" || finalBody.isEmpty == false)) {
    if(finalTitle.isNotEmpty == true || finalBody.isNotEmpty == true) {
      //return null;

      titles.add(finalTitle);

      bodys.add(finalBody);

      String currentDateTime = DateTime.now().toString();
      // example of the current value of currentDateTime is 2021-08-27 19:14:57.142575

      finalReminder = dateTime.toString();

      createdAtTimes.add(currentDateTime);

      reminders.add(finalReminder);

      //if(finalReminder != null && finalReminder != "" && finalReminder.isNotEmpty) {
      if(finalReminder != "" && finalReminder.isNotEmpty) {
        /*await service.showNotification(
          id: (notes.length + 1),
          title: finalTitle,
          body: finalBody
        );*/

        String payloadToPass = (titles.length - 1).toString();

        await service.showScheduledWithPayloadNotification(
          //id: (notes.length + 1),
          id: finalTitle.length,
          title: finalTitle,
          body: finalBody,
          payload: payloadToPass,
          seconds: 5
        );
      }

      _prefs.setStringList("titles", titles);

      _prefs.setStringList("bodys", bodys);

      _prefs.setStringList("createdAtTimes", createdAtTimes);

      _prefs.setStringList("reminders", reminders);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );

    }
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

  _getNotesList() async {

    notes = [];

    bodys = [];

    titles = [];

    createdAtTimes = [];

    reminders = [];

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

    if (_prefs.getStringList("reminders") != null) {
      //todoList = prefs.getStringList("key");
      reminders = _prefs.getStringList("reminders")!.toList();
      setState(() {});
    }

    if(bodys.isNotEmpty == true || titles.isNotEmpty == true || createdAtTimes.isNotEmpty == true) {

      List<dynamic> testNotes = [];
      for(int i = 0; i < bodys.length; i++) {
        var n = {
          "title": titles[i],
          "body": bodys[i],
          "createdAtTime": createdAtTimes[i],
          "reminder": reminders
        };

        testNotes.add(n);
        
      }

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

          notes.add(value);
        }
      });
    }
  }

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime dateTime = DateTime.now();
  bool showDate = false;
  bool showTime = false;
  bool showDateTime = false;

   // Select for Date
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
      return DateFormat('yyyy-MM-dd HH: ss a').format(dateTime);
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
          GestureDetector(
            child: const Icon(Icons.check),
            onTap: canSaveNote ? saveNoteFunction : null/*() {
              if((finalTitle != "" || finalTitle.isEmpty == false) || (finalTitle != "" || finalTitle.isEmpty == false)) {
                return null;
              }
            }*/,
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
                //icon: const Icon(Icons.person),  
                hintText: 'Input title',  
                //labelText: 'Name',  
              ),
              onChanged: (String titleInput) {
                //
                finalTitle = titleInput;

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
            Visibility(
              child: Row(
                children: [
                  const Icon(
                    Icons.alarm,
                    size: 8,
                  ),
                  Text(
                    getDateTime(),
                    style: const TextStyle(
                      fontSize: 8
                    ),
                  ),
                ]
              ),
              visible: showDateTime
            ),
            TextFormField(
              keyboardType: TextInputType.multiline,
              minLines: 8,
              maxLines: null, // <-- SEE HERE
              decoration: const InputDecoration(
                //icon: const Icon(Icons.phone),  
                //hintText: 'Enter a phone number',  
                //labelText: 'Phone',  
              ),
              onChanged: (String bodyInput) {
                //
                //finalBody = finalBody;
                finalBody = bodyInput;

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
              /*validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },*/
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          _selectDateTime(context);
          showDateTime = true;
        },
        child: const Icon(Icons.alarm),
        //backgroundColor: Colors.green,
      ),
    );
  }

  void listenTiNotification() {
    service.onNotificationClick.stream.listen(onNotificationListener);
  }

  void onNotificationListener(String? payload) {
    if(payload != null && payload.isNotEmpty) {
      print("payload $payload");

      int noteIndex = int.parse(payload);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditNotePage(noteIndex)),
      );
    }
  }
}