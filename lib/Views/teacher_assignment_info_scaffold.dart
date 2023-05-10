import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grader_io/Controllers/summary_of_assignments_view_controller.dart';
import '../Controllers/summary_of_submissions_view_controller.dart';
import '../Models/summary_of_submissions.dart';

class TeacherAssignmentInfoScaffold extends ConsumerStatefulWidget {
  final String classroomCode;
  final int assignmentId;
  final Widget child;

  const TeacherAssignmentInfoScaffold(
      {Key? key, required this.assignmentId, required this.child,required this.classroomCode})
      : super(key: key);

  @override
  TeacherAssignmentInfoScaffoldState createState() =>
      TeacherAssignmentInfoScaffoldState();
}

class TeacherAssignmentInfoScaffoldState
    extends ConsumerState<TeacherAssignmentInfoScaffold> {
  late AsyncValue<SummaryOfSubmissions> summaryOfSubmissions;

  @override
  Widget build(BuildContext context) {
    summaryOfSubmissions =
        ref.watch(summaryOfSubmissionsViewControllerProvider);
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
        leading: GoRouter.of(context).canPop()?IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ref.read(summaryOfAssignmentsViewControllerProvider.notifier).fetchAssignments(widget.classroomCode);
            GoRouter.of(context).pop();
          },
        ):null,
      ),
      floatingActionButton: GoRouter.of(context).location ==
              "/summary_of_submissions/${widget.classroomCode}/${widget.assignmentId}"
          ? summaryOfSubmissions.when(
              data: (summaryOfSubmissions) =>
                  summaryOfSubmissions.currentState == 'grades_assigned'
                      ? FloatingActionButton(
                          onPressed: () {
                            ref
                                .read(summaryOfSubmissionsViewControllerProvider
                                    .notifier)
                                .publishScore(widget.assignmentId);
                          },
                          tooltip: "Publish Score",
                          child: const Icon(Icons.publish),
                        )
                      : null,
              error: (e, s) => null,
              loading: () => null)
          : null,
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: GoRouter.of(context).location ==
                  "/assignment_detail/${widget.assignmentId}"
              ? 0
              : 1,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.details), label: "Details"),
            BottomNavigationBarItem(
                icon: Icon(Icons.assignment_outlined), label: "Submissions"),
          ],
          onTap: (index) {
            if (index == 0) {
              ref
                  .read(summaryOfSubmissionsViewControllerProvider.notifier)
                  .setStateToLoading();
              GoRouter.of(context)
                  .pushReplacement('/assignment_detail/${widget.classroomCode}/${widget.assignmentId}');
            } else if (index == 1) {
              GoRouter.of(context).pushReplacement(
                  '/summary_of_submissions/${widget.classroomCode}/${widget.assignmentId}');
            }
          }),
    );
  }
}
