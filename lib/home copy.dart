import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

//My own files
import './addNote.dart';
import './editNote.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage();

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SharedPreferences _prefs; //for accessing shared preferences

  late List<dynamic> notes; //to store the notes

  late List<String> notesCreatedAtTimes; //list of the times the notes were created

  late List<String> bodys; //variable to store the body of the notes

  late List<String> titles; //variable to store the tilte of the notes

  late List<String> createdAtTimes; //

  bool notesDoneLoading = false;

  int _counter = 0;

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

  //Future<String> _getNotesList() async {
  _getNotesList() async {
    bodys = [];

    titles = [];

    createdAtTimes = [];
    
    notes = [];

    notesCreatedAtTimes = [];

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
          "createdAtTimes": createdAtTimes[i]
        };

        testNotes.add(n);
        
      }

      for(int k = 0; k < testNotes.length; k++) {

        notesCreatedAtTimes.add(testNotes[k]["createdAtTimes"]);
        
      }

      //sort the createdAtTimes strings in descending order
      notesCreatedAtTimes.sort((a,b) {
        return b.compareTo(a); //swap a for b and vise versa to make it to be in ascending order
      });

      print("notesCreatedAtTimes: ");

      print(notesCreatedAtTimes);
      setState(() {
        for(int m = 0; m < notesCreatedAtTimes.length; m++) {

          for(int l = 0; l < testNotes.length; l++) {
            if(notesCreatedAtTimes[m] == testNotes[l]["createdAtTimes"]) {
              notes.add(testNotes[l]);
            }
          }
        }
      });

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

          //notes.add(value);
        }
      });

      setState(() {
        notesDoneLoading = true;
      });

    } else {

      bodys = [];

      titles = [];

      createdAtTimes = [];

      notes = [];

      setState(() {
        notesDoneLoading = true;
      });
      
    }

    /*if(notes.length > 0) {
      return "not_null";
    } else {
      return "null";
    }*/
  }

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
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("LimNotes"),
        actions: [
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.info_outline,
                size: 30.0,
              ),
            ),
            onTap: () {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text(
                    'Info',
                    textAlign: TextAlign.center,
                  ),
                  content: Container(
                    height: 50.0,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Developed by Colin Uchem ",
                                style: TextStyle(
                                  color: Colors.black
                                )
                              ),
                              TextSpan(
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline
                                ),
                                text: "(www.uchemcolin.xyz)",
                                  recognizer: TapGestureRecognizer()..onTap =  () async{
                                    var url = Uri.parse("http://www.uchemcolin.xyz");
                                    //var url = Uri.parse("https://www.google.com");
                                    
                                    if (await canLaunchUrl(url)) {
                                    //try {
                                      await launchUrl(url);
                                    } else {
                                    //} catch(e) {
                                      //throw 'Could not launch $url';

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          /*action: SnackBarAction(
                                            label: 'Action',
                                            onPressed: () {
                                              // Code to execute.
                                            },
                                          ),*/
                                          content: Text(
                                            "Could not open the website",
                                            style: TextStyle(
                                              fontSize: 18
                                            ),
                                            textAlign: TextAlign.center
                                          ),
                                          duration: const Duration(milliseconds: 1500),
                                          width: 200.0, // Width of the SnackBar.
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, // Inner padding for SnackBar content.
                                            vertical: 10.0
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                              ),
                            ]
                        )),
                        Divider(
                          color: Colors.black,
                        ),
                        Container(
                          width: double.infinity,
                          child: const Text(
                            'Limsaver version: 1.0.0',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13
                            ),
                          ),
                        ),
                      ]
                    )
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                )
              );
            },
          )
        ],
      ),
      body: FutureBuilder(
        //future: _fetchNetworkCall, // async work
        //future: _getNotesList(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

          //if(snapshot.hasData == true && snapshot.data != "null") {
          //if(snapshot.data != "null") {
          if(notesDoneLoading == true) {

            if(notes.isNotEmpty == true) {
              //
              return ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, i) {

                  int noteIndex = i;

                  String listBuilderTitle = notes[i]["title"].toString();
                  String listBuilderBody = notes[i]["body"].toString();
                  String listBuilderCreatedAt = notes[i]["createdAtTimes"].toString();

                  //DateTime dt = DateTime.parse('2020-01-02 03:04:05');
                  DateTime dt = DateTime.parse(listBuilderCreatedAt);

                  String dtDay = DateFormat('dd').format(dt);

                  String dtYear = DateFormat('yyyy').format(dt);

                  DateTime now = DateTime.now();

                  String nowDay = DateFormat('dd').format(now);

                  String nowYear = DateFormat('yyyy').format(now);

                  String formattedDate = "";

                  //if(dt)
                  if(dtDay == nowDay) {
                    formattedDate = DateFormat.jm().format(dt); //5:08 PM
                  } else {
                    if(dtYear == nowYear) {
                      formattedDate = DateFormat('MMMM d').format(dt); //October 2
                      
                    } else {
                      formattedDate = DateFormat('MMMM d, yyyy').format(dt); //October 2, 2022
                    }
                  }

                  //String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(dt);
                  //String formattedDate = DateFormat('MM dd').format(dt);

                  if(listBuilderTitle == "" || listBuilderTitle.isEmpty) {
                    
                    return GestureDetector(
                      child: ListTile(
                        //title: Text(notes[i]["body"].toString()),
                        title: Text(
                          listBuilderBody,
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          formattedDate
                        ),
                      ),
                      onTap: () {
                        //print(notes[noteIndex]);

                        Navigator.push(
                          context,

                          MaterialPageRoute(builder: (context) => EditNotePage(notes[noteIndex]))
                        );
                      },
                    );
                  
                  } else {

                    //return Container();

                    return GestureDetector(
                      child: ListTile(
                        //tileColor: Colors.grey[300],
                        //title: Text(notes[i]["body"].toString()),
                        title: Text(
                          listBuilderTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              formattedDate
                            ),
                          ]
                        )
                      ),
                      onTap: () {

                        //print(notes[noteIndex]);

                        Navigator.push(
                          context,
                          //MaterialPageRoute(builder: (context) => EditNotePage(noteIndex)),

                          MaterialPageRoute(builder: (context) => EditNotePage(notes[noteIndex])),
                        );
                      }
                    );

                  }
                },
              );

            }/* else if(notes.length == 0) {
              
              return Center(
                child: Text(
                  "There are currently no notes.",
                  style: TextStyle(
                    fontSize: 17
                  ),
                ),
              );
            }*/ else {
              //return const CircularProgressIndicator();

              return Center(
                child: Text(
                  "There are currently no notes.",
                  style: TextStyle(
                    fontSize: 17
                  ),
                ),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator()
            );
          }
          /*switch (snapshot.connectionState) {
            case ConnectionState.waiting: return Text('Loading....');
            default:
              if (snapshot.hasError)
                return Text('Error: ${snapshot.error}');
              else
            return Text('Result: ${snapshot.data}');
          }*/
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNotePage()),
          );
        },
        child: const Icon(Icons.add),
        //backgroundColor: Colors.green,
      ),
    );
  }
}