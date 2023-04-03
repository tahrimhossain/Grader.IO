import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TeacherSubmissionInfoScaffold extends ConsumerStatefulWidget {
  final int submissionId;
  final Widget child;

  const TeacherSubmissionInfoScaffold(
      {Key? key, required this.submissionId, required this.child})
      : super(key: key);

  @override
  TeacherSubmissionInfoScaffoldState createState() =>
      TeacherSubmissionInfoScaffoldState();
}

class TeacherSubmissionInfoScaffoldState
    extends ConsumerState<TeacherSubmissionInfoScaffold> {
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
          currentIndex: GoRouter.of(context).location ==
                  "/submission_detail/${widget.submissionId}"
              ? 0
              : GoRouter.of(context).location ==
                      "/submission_grade/${widget.submissionId}"
                  ? 2
                  : 1,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.details), label: "Details"),
            BottomNavigationBarItem(
                icon: Icon(Icons.assignment_outlined), label: "Reviews"),
            BottomNavigationBarItem(
                icon: Icon(Icons.grade_sharp), label: "Grades"),
          ],
          onTap: (index) {
            if (index == 0) {
              GoRouter.of(context)
                  .pushReplacement('/submission_detail/${widget.submissionId}');
            } else if (index == 1) {
              GoRouter.of(context).pushReplacement(
                  '/summary_of_submission_reviews/${widget.submissionId}');
            } else if (index == 2) {
              GoRouter.of(context)
                  .pushReplacement('/submission_grade/${widget.submissionId}');
            }
          }),
    );
  }
}
