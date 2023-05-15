import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StudentSubmissionInfoScaffold extends ConsumerStatefulWidget {
  final int submissionId;
  final Widget child;

  const StudentSubmissionInfoScaffold(
      {Key? key, required this.submissionId, required this.child})
      : super(key: key);

  @override
  StudentSubmissionInfoScaffoldState createState() =>
      StudentSubmissionInfoScaffoldState();
}

class StudentSubmissionInfoScaffoldState
    extends ConsumerState<StudentSubmissionInfoScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grader.IO",
            style: TextStyle(
                color: Colors.white,
                // fontWeight: FontWeight.bold,
                fontSize: 18)),
        backgroundColor: Colors.blueGrey,
        iconTheme: const IconThemeData(color: Colors.white),
        toolbarHeight: 80,
      ),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: GoRouter.of(context).location ==
                  "/submission_info/${widget.submissionId}"
              ? 0
              : 1,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.details), label: "Details"),
            BottomNavigationBarItem(
                icon: Icon(Icons.assignment_outlined), label: "Review"),
          ],
          onTap: (index) {
            if (index == 0) {
              GoRouter.of(context)
                  .pushReplacement('/submission_info/${widget.submissionId}');
            } else if (index == 1) {
              GoRouter.of(context).pushReplacement(
                  '/created_review/${widget.submissionId}');
            }
          }),
    );
  }
}
