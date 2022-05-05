import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talize/dashboard/todos.dart';

class CategoryCard extends StatefulWidget {
  final String email;
  final String docId;
  final Map<String, dynamic> data;
  CategoryCard(this.data, this.docId, this.email);

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  String remaining_tasks = '0';
  TextEditingController category_title = TextEditingController();
  @override
  void initState() {
    category_title.text = widget.data['title'];
    super.initState();
  }

  void _showPopupMenu(Offset globalPosition) async {
    final screenSize = MediaQuery.of(context).size;
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        globalPosition.dx,
        globalPosition.dy,
        screenSize.width - globalPosition.dx,
        screenSize.height - globalPosition.dy,
      ),
      color: Color(0XFF346751),
      items: [
        PopupMenuItem(
          value: 1,
          child: TextButton(
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
                                .doc(widget.email)
                                .collection('categories')
                                .doc(widget.docId)
                                .update(
                              {
                                'title': category_title.text,
                              },
                            );
                            category_title.clear();
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text('update'),
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
            child: Text(
              "Edit",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: TextButton(
            onPressed: () {
              showModalBottomSheet(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.8,
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
                        Text(
                          'Are you sure you want to delete this category?',
                          style: TextStyle(color: Color(0XFF346751)),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
                              style: TextButton.styleFrom(
                                backgroundColor: Color(0XFF346751),
                                primary: Colors.white,
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
                                    .delete();
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: Text('Ok'),
                              style: TextButton.styleFrom(
                                backgroundColor: Color(0XFF346751),
                                primary: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Text(
              "Delete",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
      elevation: 8.0,
    ).then(
      (value) {
        if (value != null) print(value);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.email.toString())
        .collection('categories')
        .doc(widget.docId)
        .collection('todos')
        .where('isDone', isEqualTo: false)
        .get()
        .then(
      (value) {
        setState(() {
          remaining_tasks = value.docs.length.toString();
        });
      },
    );
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Todos(widget.email, widget.docId, widget.data['title']),
          ),
        );
      },
      onLongPressEnd: (LongPressEndDetails details) {
        _showPopupMenu(details.globalPosition);
      },
      child: Container(
        width: 200,
        height: 180.0,
        margin: EdgeInsets.only(left: 10),
        padding: EdgeInsets.fromLTRB(15, 25, 15, 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(70, 47, 47, 47),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              widget.data['title'],
              textScaleFactor: 1.1,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontFamily: 'poppins',
              ),
            ),
            Text(
              remaining_tasks + " Tasks remaining",
              style: TextStyle(
                color: Color.fromARGB(255, 152, 152, 152),
                fontWeight: FontWeight.w400,
                fontFamily: 'poppins',
              ),
            ),
            SizedBox(
              height: 18,
            ),
            TextButton(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Todos(widget.email, widget.docId, widget.data['title']),
                  ),
                ),
              },
              child: Text(
                'Go to Todos ->',
                style: TextStyle(
                  color: Color(0XFF346751),
                  fontWeight: FontWeight.w800,
                  fontFamily: 'poppins',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
