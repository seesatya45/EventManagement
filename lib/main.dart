import 'package:dbms_connect/add_event.dart';
import 'package:dbms_connect/event_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Event Management',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(title: 'Event Management')
        //  FutureBuilder(
        //   future: Hive.openBox<dynamic>('myBox'),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.done) {
        //       if (snapshot.error != null) {
        //         return const Scaffold(
        //           body: Center(
        //             child: Text('Something went wrong :/'),
        //           ),
        //         );
        //       } else {
        //         return const MyHomePage(title: 'Event Management Team');
        //       }
        //     } else {
        //       return Scaffold(
        //         body: Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: const <Widget>[
        //             Text('Loading...'),
        //             CircularProgressIndicator(),
        //           ],
        //         ),
        //       );
        //     }
        //   },
        // ),
        );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? name;
  String? date;
  String? event1;

  @override
  Widget build(BuildContext context) {
    return
        // HomeScreen();
        Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut().then((value) {
                  // print(value.user!.uid);
                  Fluttertoast.showToast(msg: "Sign Out Successfully");
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => HomeScreen(title: widget.title),
                  ));
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => HomeScreen(title: widget.title),
                  //   ),
                  // );
                }).catchError((e) {
                  Fluttertoast.showToast(msg: "Something went wrong $e");
                });
              },
              icon: Icon(Icons.logout))
        ],
        title: Text(
          widget.title,
          style: (TextStyle(fontSize: 16)),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const <Widget>[EventLis()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventMY(),
            ),
          );
        },
        tooltip: 'Add Event',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController emailId = TextEditingController();
  TextEditingController passWord = TextEditingController();
  String? myEmail;
  String? myPass;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Login"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: emailId,
                      decoration: const InputDecoration(
                          label: Text("Email"), border: InputBorder.none),
                      onChanged: (val) {
                        myEmail = val;
                      },
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      obscureText: true,
                      controller: passWord,
                      decoration: const InputDecoration(
                          label: Text("Password"), border: InputBorder.none),
                      onChanged: (val) {
                        myPass = val;
                      },
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  if (emailId.text.isNotEmpty && passWord.text.isNotEmpty) {
                    await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: "event@gmail.com", password: "123456")
                        .then((value) {
                      emailId.clear();
                      passWord.clear();
                      print(value.user!.uid);
                      Fluttertoast.showToast(msg: "Success");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyHomePage(
                            title: widget.title,
                          ),
                        ),
                      );
                    }).catchError((e) {
                      Fluttertoast.showToast(msg: "Something went wrong $e");
                    });
                  } else {
                    Fluttertoast.showToast(msg: "Please fill all fields");
                  }
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) =>
                  //             MyHomePage(title: widget.title)));
                },
                child: const Text("Login"))
          ],
        ));
  }
}
