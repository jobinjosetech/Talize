import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:talize/dashboard/categories_all.dart';
import 'package:talize/dashboard/widgets/card_category.dart';

class Categories extends StatefulWidget {
  final String email;
  const Categories(this.email, {Key? key}) : super(key: key);
  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              TextButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoriesAll(
                        email: widget.email,
                      ),
                    ),
                  ),
                },
                child: Text(
                  "See All",
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
          height: 180.0,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(widget.email.toString())
                .collection('categories')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: Color(0XFF346751)),
                );
              }
              return ListView(
                scrollDirection: Axis.horizontal,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
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
    );
  }
}
