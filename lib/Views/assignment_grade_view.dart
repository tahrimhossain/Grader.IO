import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Controllers/grade_view_controller.dart';
import '../Models/grade.dart';

class AssignmentGradeView extends ConsumerStatefulWidget {
  final int assignmentId;


  const AssignmentGradeView({Key? key, required this.assignmentId}) : super(key: key);

  @override
  AssignmentGradeViewState createState() => AssignmentGradeViewState();
}

class AssignmentGradeViewState extends ConsumerState<AssignmentGradeView> {
  late AsyncValue<Grade> grade;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => ref
        .read(gradeViewControllerProvider.notifier)
        .fetchAssignmentGrade(widget.assignmentId));
  }

  @override
  Widget build(BuildContext context) {
    grade = ref.watch(gradeViewControllerProvider);

    return grade.when(
      data: (grade) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: RefreshIndicator(
            onRefresh: () async {
              ref
                  .read(gradeViewControllerProvider.notifier)
                  .fetchAssignmentGrade(widget.assignmentId);
            },
            child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Max Score:${grade.maxScore!}"),
                    Text("Evaluation Score:${grade.evaluationScore!}"),
                    Text("Review Score:${grade.reviewScore!}"),
                    Text("Predicted Score:${grade.predictedScore!}"),
                    Text("Final Score:${grade.finalScore!}"),
                  ],
                ))),
      ),
      error: (e, s) => Center(
        child: Text(e.toString()),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}