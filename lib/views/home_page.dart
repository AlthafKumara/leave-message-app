import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:ngl_app/model/message_model.dart';
import 'package:ngl_app/services/message.dart';
import 'package:ngl_app/widgets/colors.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _authorcontroller = TextEditingController();
  final TextEditingController _messagecontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _submit() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      bool sukses = await MessageServices.postMessage(
          _authorcontroller.text, _messagecontroller.text);
      setState(() {
        _isLoading = false;
      });
      if (sukses) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Data Berhasil ditambahkan")));
        _authorcontroller.clear();
        _messagecontroller.clear();

        setState(() {
          futureMessages = MessageServices.getMessage();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Data tidak dapat ditambahkan")));
      }
    }
  }

  late Future<List<MessageModel>> futureMessages;

  @override
  void _showform() async {
    _authorcontroller.clear();
    _messagecontroller.clear();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colorss.Warna1,
            title: Text("Give me a new message",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 25),),
            content: SingleChildScrollView(
              child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _authorcontroller,
                        decoration: InputDecoration(labelText: "Author"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Masukkan Nama Authorr";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _messagecontroller,
                        decoration: InputDecoration(labelText: "Message"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Masukkan pesan";
                          }
                          return null;
                        },
                      )
                    ],
                  )),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.black),
                  )),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.black),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                  onPressed: () {
                    _submit();
                  },
                  child: Text("Submit"))
            ],
          );
        });
  }

  void dispose() {
    _authorcontroller.dispose();
    _messagecontroller.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    futureMessages = MessageServices.getMessage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorss.Warna3,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colorss.Warna2,
        title: Text(
          'Leave me a Message',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _showform();
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
          future: futureMessages,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error : ${snapshot.error}"),
              );
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              return Center(
                child: Text("No Messages Found"),
              );
            } else {
              final messages = snapshot.data!;
              return ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colorss.Warna1,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  message.author.toString(),
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(message.message.toString())
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            }
          }),
    );
  }
}
