import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grader_io/Models/assignment_summary.dart';

class TeacherAssignmentInfoScaffold extends ConsumerStatefulWidget {
  final int assignmentId;
  final Widget child;


  const TeacherAssignmentInfoScaffold({Key? key, required this.assignmentId,required this.child})
      : super(key: key);

  @override
  TeacherAssignmentInfoScaffoldState createState() =>
      TeacherAssignmentInfoScaffoldState();
}

class TeacherAssignmentInfoScaffoldState
    extends ConsumerState<TeacherAssignmentInfoScaffold> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Grader.IO",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
          currentIndex:
          GoRouter.of(context).location == "/assignment_detail/${widget.assignmentId}" ? 0 : 1,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.details), label: "Details"),
            BottomNavigationBarItem(
                icon: Icon(Icons.assignment_outlined), label: "Submissions"),
          ],
          onTap: (index) {
            if (index == 0) {
              GoRouter.of(context).pushReplacement('/assignment_detail/${widget.assignmentId}');
            } else if (index == 1) {
              GoRouter.of(context).pushReplacement('/summary_of_submissions/${widget.assignmentId}');
            }
          }),
    );
  }
}
