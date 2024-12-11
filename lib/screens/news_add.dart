import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

final _formkey = GlobalKey<FormState>();

class NewsAdd extends StatefulWidget {
  const NewsAdd({super.key});

  @override
  State<NewsAdd> createState() => _NewsAddState();
}

class _NewsAddState extends State<NewsAdd> {
  final TextEditingController _newstitle = TextEditingController();
  final TextEditingController _newspara = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 50,
          right: 20,
          left: 20,
        ),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              SizedBox(
                child: TextFormField(
                  validator: (title) => title!.length < 10
                      ? 'Title Should be at least 10 character'
                      : null,
                  controller: _newstitle,
                  decoration: InputDecoration(
                      hintText: "Enter The News Title",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                child: TextFormField(
                  validator: (description) => description!.isEmpty
                      ? 'Enter The News Description'
                      : null,
                  controller: _newspara,
                  textAlignVertical: TextAlignVertical.top,
                  textAlign: TextAlign.left,
                  maxLines: 5,
                  decoration: InputDecoration(
                      hintText: "Write News Briefly",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              OutlinedButton(
                  onPressed: () {
                    // ignore: unnecessary_null_comparison
                    // if (newspara.text != null && newstitle.text != null) {
                    //   Navigator.pushNamed(context, '/newsfeed', arguments: {
                    //     "newspara": newspara.text,
                    //     "newstitle": newstitle.text
                    //   });
                    // } else {
                    //   print("invalid Input");
                    // }

                    if (_formkey.currentState!.validate()) {
                      CollectionReference collRef =
                          FirebaseFirestore.instance.collection('newsbox');
                      collRef.add({
                        "title": _newstitle.text,
                        "description": _newspara.text
                      });

                      _newstitle.clear();
                      _newspara.clear();
                      sucesstoast().show(context);
                    } else {
                      errortoast().show(context);
                    }
                  },
                  style: const ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(Colors.orangeAccent),
                  ),
                  child: const Text(
                    "Publish",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  )),
            ],
          ),
        ),
      ),
    ));
  }

  DelightToastBar sucesstoast() {
    return DelightToastBar(
      builder: (context) {
        return const ToastCard(
            leading: Icon(Icons.check_circle_outline),
            color: Colors.greenAccent,
            title: Text("News Published"));
      },
      autoDismiss: true,
      snackbarDuration: Durations.extralong4,
      position: DelightSnackbarPosition.bottom,
    );
  }

  DelightToastBar errortoast() {
    return DelightToastBar(
      builder: (context) {
        return const ToastCard(
            leading: Icon(Icons.clear_outlined),
            color: Colors.red,
            title: Text("Check the fields"));
      },
      autoDismiss: true,
      snackbarDuration: Durations.extralong4,
      position: DelightSnackbarPosition.bottom,
    );
  }
}
