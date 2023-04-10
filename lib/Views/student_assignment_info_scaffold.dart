import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StudentAssignmentInfoScaffold extends ConsumerStatefulWidget {
  final int assignmentId;
  final Widget child;

  const StudentAssignmentInfoScaffold(
      {Key? key, required this.assignmentId, required this.child})
      : super(key: key);

  @override
  StudentAssignmentInfoScaffoldState createState() =>
      StudentAssignmentInfoScaffoldState();
}

class StudentAssignmentInfoScaffoldState
    extends ConsumerState<StudentAssignmentInfoScaffold> {
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
          type: BottomNavigationBarType.fixed,
          currentIndex: GoRouter.of(context).location ==
                  "/assignment_info/${widget.assignmentId}"
              ? 0
              : GoRouter.of(context).location ==
                      "/created_submission/${widget.assignmentId}"
                  ? 1
                  : GoRouter.of(context).location ==
                          "/summary_of_assigned_reviews/${widget.assignmentId}"
                      ? 2
                      : GoRouter.of(context).location ==
                              "/summary_of_received_reviews/${widget.assignmentId}"
                          ? 3
                          : 4,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.details), label: "Details"),
            BottomNavigationBarItem(
                icon: Icon(Icons.assignment), label: "Submission"),
            BottomNavigationBarItem(
                icon: Icon(Icons.reviews_sharp), label: "Assigned Reviews"),
            BottomNavigationBarItem(
                icon: Icon(Icons.reviews_sharp), label: "Received Reviews"),
            BottomNavigationBarItem(icon: Icon(Icons.grade), label: "Grade"),
          ],
          onTap: (index) {
            if (index == 0) {
              GoRouter.of(context)
                  .pushReplacement('/assignment_info/${widget.assignmentId}');
            } else if (index == 1) {
            } else if (index == 2) {
              GoRouter.of(context)
                  .pushReplacement('/summary_of_assigned_reviews/${widget.assignmentId}');
            } else if (index == 3) {
              GoRouter.of(context)
                  .pushReplacement('/summary_of_received_reviews/${widget.assignmentId}');
            }else if(index == 4){
              GoRouter.of(context)
                  .pushReplacement('/assignment_grade/${widget.assignmentId}');
            }
          }),
    );
  }
}
