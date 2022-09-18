import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbms_connect/editEvent.dart';
import 'package:flutter/material.dart';

class EventLis extends StatelessWidget {
  const EventLis({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
        stream: FirebaseFirestore.instance.collection("events").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          } else if (!snapshot.hasData) {
            return Container(
              height: 100,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data.docs.length == 0) {
              return const Text("No data found");
            }
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        dense: true,
                        leading: Text(
                          (index + 1).toString(),
                        ),
                        title: Text(
                          snapshot.data.docs[index]["name"] ?? "",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data.docs[index]["date"] ?? "",
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              snapshot.data.docs[index]["type"] ?? "",
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        trailing: CircleAvatar(
                          child: Text(snapshot.data.docs[index]["name"]
                              .toString()
                              .substring(0, 1)),
                        ),
                        onTap: () {
                          print(
                            "new Id+${snapshot.data.docs[index].id}",
                          );
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditEvent(
                                        eId: snapshot.data.docs[index].id,
                                      )));
                        },
                      ),
                    ),
                  );
                });
          } else {
            return const Text("Something went wrong");
          }
        });
  }
}
