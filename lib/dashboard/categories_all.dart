import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talize/dashboard/dashboard.dart';
import 'package:talize/dashboard/widgets/card_category.dart';

class CategoriesAll extends StatefulWidget {
  final String email;
  const CategoriesAll({Key? key, required this.email}) : super(key: key);

  @override
  State<CategoriesAll> createState() => _CategoriesAllState();
}

class _CategoriesAllState extends State<CategoriesAll> {
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
                    "Category",
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
                    return GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.2,
                        mainAxisSpacing: 15,
                      ),
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(top: 20, right: 10),
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        String docId = document.id;
                        return CategoryCard(data, docId, widget.email);
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
