import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../Controllers/grade_view_controller.dart';
import '../Models/grade.dart';

class SubmissionGradeView extends ConsumerStatefulWidget {
  final int submissionId;


  const SubmissionGradeView({Key? key, required this.submissionId}) : super(key: key);

  @override
  SubmissionGradeViewState createState() => SubmissionGradeViewState();
}

class SubmissionGradeViewState extends ConsumerState<SubmissionGradeView> {
  late AsyncValue<Grade> grade;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => ref
        .read(gradeViewControllerProvider.notifier)
        .fetchSubmissionGrade(widget.submissionId));
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
                  .fetchSubmissionGrade(widget.submissionId);
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
