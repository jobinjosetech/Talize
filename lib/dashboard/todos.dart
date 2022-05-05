import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talize/dashboard/dashboard.dart';
import 'package:talize/dashboard/widgets/card_category.dart';
import 'package:talize/dashboard/widgets/card_todos.dart';

class Todos extends StatefulWidget {
  final String email;
  final String docId;
  final String title;
  const Todos(this.email, this.docId, this.title, {Key? key}) : super(key: key);

  @override
  State<Todos> createState() => _TodosState();
}

class _TodosState extends State<Todos> {
  TextEditingController todos_title = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF171717),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => DashBoard()),
                          (route) => false);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    widget.title,
                    textScaleFactor: 1.4,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color.fromARGB(255, 224, 224, 224),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(widget.email.toString())
                      .collection('categories')
                      .doc(widget.docId)
                      .collection('todos')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child:
                            CircularProgressIndicator(color: Color(0XFF346751)),
                      );
                    }
                    return ListView(
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        String docId = document.id;
                        return TodoCard(
                            data, docId, widget.docId, widget.email);
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            builder: (BuildContext context) {
              return Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.5,
                padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
                child: Column(
                  children: [
                    TextField(
                      cursorColor: Color(0XFF346751),
                      autofocus: true,
                      textAlign: TextAlign.center,
                      controller: todos_title,
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: Color(0XFF346751)),
                      decoration: InputDecoration(
                        hintText: 'Hint Text',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0XFF346751),
                          ),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        filled: true,
                        contentPadding: EdgeInsets.all(16),
                        fillColor: Colors.transparent,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0XFF346751),
                          ),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0XFF346751),
                          ),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0XFF346751),
                          ),
                          borderRadius: BorderRadius.circular(25.7),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.email)
                            .collection('categories')
                            .doc(widget.docId)
                            .collection('todos')
                            .add({
                          'title': todos_title.text,
                          'isDone': false,
                          'timestamp': DateTime.now().millisecondsSinceEpoch,
                        });
                        todos_title.clear();
                        Navigator.pop(context);
                      },
                      child: Text('Add Todos'),
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0XFF346751),
                        primary: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        label: Text('Add Todos'),
        icon: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0XFF346751),
      ),
    );
  }
}

class Dashboard {}
