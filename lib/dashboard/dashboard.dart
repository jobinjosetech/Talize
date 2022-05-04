import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:horizontal_center_date_picker/datepicker_controller.dart';
import 'package:horizontal_center_date_picker/horizontal_date_picker.dart';
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
  @override
  void initState() {
    super.initState();
    getUser();
    Future.delayed(
      const Duration(milliseconds: 2000),
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
                                        CircularProgressIndicator(),
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
                                  Text(
                                    "Add Activity",
                                    textScaleFactor: 1.1,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0XFF346751),
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                    "Category",
                                    textScaleFactor: 1.4,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Color.fromARGB(255, 224, 224, 224),
                                    ),
                                  ),
                                  Text(
                                    "See all",
                                    textScaleFactor: 1.1,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0XFF346751),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
