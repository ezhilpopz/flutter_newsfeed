import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class NewsFeed extends StatefulWidget {
  const NewsFeed({
    super.key,
  });

  @override
  State<NewsFeed> createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  @override
  void initState() {
    super.initState();
  }

  final CollectionReference fetchData =
      FirebaseFirestore.instance.collection("newsbox");

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
    String currenttime = dateFormat.format(DateTime.now());
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.orangeAccent,
          title: const Text("News"),
        ),
        body: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: fetchData.snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  if (streamSnapshot.hasData) {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: streamSnapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final DocumentSnapshot documentSnapshot =
                                streamSnapshot.data!.docs[index];
                            return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Material(
                                  borderRadius: BorderRadius.circular(20),
                                  color:
                                      const Color.fromARGB(255, 227, 219, 219),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text(
                                          documentSnapshot['title'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                      ListTile(
                                          title: Text(
                                              documentSnapshot['description'])),
                                      ListTile(
                                        title: Text(
                                          "Published in $currenttime",
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      )
                                    ],
                                  ),
                                ));
                          }),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                })
          ],
        ));
  }
}
