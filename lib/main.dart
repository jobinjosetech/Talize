import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talize/auth/auth.dart';
import 'package:talize/dashboard/dashboard.dart';
import 'package:talize/welcome.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;
  User? _user = null;
  bool _isSignedIn = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    checkAuth();
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

  void checkAuth() async {
    _user = await _auth.currentUser;
    if (_user != null) {
      setState(() {
        _isSignedIn = true;
      });
    } else {
      setState(() {
        _isSignedIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: _isLoading
            ? Welcome()
            : _isSignedIn
                ? DashBoard()
                : Auth());
  }
}
