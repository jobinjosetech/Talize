import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:talize/dashboard/categories.dart';
import './component/date_widget_timeline.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  DateTime _selectedValue = DateTime.now();
  String stringdate = DateTime.now().toString().split(' ')[0];
  bool _isLoading = true;
  User? _user = null;
  bool _isSignedIn = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController category_title = TextEditingController();
  @override
  void initState() {
    super.initState();
    getUser();
    Future.delayed(
      const Duration(milliseconds: 500),
      () => {
        setState(
          () {
            _isLoading = false;
          },
        ),
      },
    );
  }

  void getUser() async {
    User? user = await _auth.currentUser;
    setState(() {
      _user = user;
    });
    print(_user!.displayName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF171717),
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40.0,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Hello, " +
                                    _user!.displayName
                                        .toString()
                                        .split(' ')[0] +
                                    " 🖐",
                                textScaleFactor: 1.6,
                                style: TextStyle(
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.w700,
                                  color: Color.fromARGB(255, 224, 224, 224),
                                ),
                              ),
                              CircleAvatar(
                                radius: 25.0,
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: _user!.photoURL.toString(),
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(
                                      color: Color(0XFF346751),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 60.0,
                        ),
                        Column(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Activities",
                                    textScaleFactor: 1.4,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Color.fromARGB(255, 224, 224, 224),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => {},
                                    child: Text(
                                      "Add Activity",
                                      textScaleFactor: 1.1,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Color(0XFF346751),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: double.infinity,
                              child: DatePickerTimeline(_selectedValue,
                                  onDateChange: (date) {
                                setState(() {
                                  _selectedValue = date;
                                  stringdate = date.toString().split(' ')[0];
                                });
                              }),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Categories(_user!.email.toString()),
                      ],
                    ),
                  ),
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
                      controller: category_title,
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
                            .doc(_user!.email.toString())
                            .collection('categories')
                            .add({
                          'title': category_title.text,
                          'timestamp': DateTime.now().millisecondsSinceEpoch,
                        });
                        category_title.clear();
                        Navigator.pop(context);
                      },
                      child: Text('Add Category'),
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
        label: Text('Add Category'),
        icon: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0XFF346751),
      ),
    );
  }
}
