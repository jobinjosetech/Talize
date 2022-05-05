import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talize/dashboard/todos.dart';

class TodoCard extends StatefulWidget {
  final String email;
  final String docId;
  final String todoId;
  final Map<String, dynamic> data;
  TodoCard(this.data, this.todoId, this.docId, this.email);

  @override
  State<TodoCard> createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(70, 47, 47, 47),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 15,
          ),
          InkWell(
            onTap: () {
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.email)
                  .collection('categories')
                  .doc(widget.docId)
                  .collection('todos')
                  .doc(widget.todoId)
                  .update({'isDone': !widget.data['isDone']});
            },
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Color(0XFF346751),
                borderRadius: BorderRadius.circular(20),
              ),
              child: widget.data['isDone']
                  ? Icon(
                      Icons.done_rounded,
                      color: Colors.white,
                      size: 20,
                    )
                  : null,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            widget.data['title'],
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: widget.data['isDone'] ? Colors.grey : Colors.white,
              decoration: widget.data['isDone']
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}
