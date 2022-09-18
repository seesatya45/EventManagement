import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EventMY extends StatefulWidget {
  EventMY({super.key});

  @override
  State<EventMY> createState() => _EventMYState();
}

class _EventMYState extends State<EventMY> {
  String dropdownvalue = 'Select Event';

  var items = ["Select Event", "Birthday", "Anniversary"];

  TextEditingController myController0 = TextEditingController();

  TextEditingController myController1 = TextEditingController();

  String? eName;

  String? date;

  String? type;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Event"),
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: myController0,
                    decoration: const InputDecoration(label: Text("Name")),
                    onChanged: (val) {
                      eName = val;
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: const InputDecoration(label: Text("Date")),
                    controller: myController1,
                    onChanged: (val) {
                      date = val;
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DropdownButton(
                      value: dropdownvalue,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue!;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  if (dropdownvalue != "Select Event" &&
                      myController0.text.isNotEmpty &&
                      myController1.text.isNotEmpty) {
                    Map<String, dynamic> data = {
                      "name": myController0.text,
                      "date": myController1.text,
                      "type": dropdownvalue,
                      "createAt": FieldValue.serverTimestamp()
                    };
                    var connectivityResult =
                        await Connectivity().checkConnectivity();
                    if (connectivityResult == ConnectivityResult.mobile ||
                        connectivityResult == ConnectivityResult.wifi) {
                      await FirebaseFirestore.instance
                          .collection("events")
                          .add(data)
                          .then((value) {
                        Fluttertoast.showToast(msg: "Submitted");
                      }).catchError((e) {
                        Fluttertoast.showToast(msg: "Something went wrong $e");
                      });
                    } else if (connectivityResult == ConnectivityResult.none) {
                      // var docId =
                      //     DateTime.now().microsecondsSinceEpoch.toString();
                      // _box!.put(docId, _box!.put(docId, data)).then((value) {
                      //   Fluttertoast.showToast(msg: "Local submitted");
                      // }).catchError((e) {
                      //   Fluttertoast.showToast(msg: "Please try again!");
                      // });
                    } else {
                      Fluttertoast.showToast(msg: "Please try again!");
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Please choose value");
                  }
                },
                child: const Text("Submit"))
          ],
        ),
      ),
    );
  }
}
