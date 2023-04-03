

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Controllers/grade_view_controller.dart';
import '../Models/grade.dart';

class GradeView extends ConsumerStatefulWidget {
  final int submissionId;

  const GradeView({Key? key, required this.submissionId})
      : super(key: key);

  @override
  GradeViewState createState() =>
      GradeViewState();
}

class GradeViewState
    extends ConsumerState<GradeView> {

  late AsyncValue<Grade> grade;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => ref
        .read(gradeViewControllerProvider.notifier)
        .fetchGrade(widget.submissionId));
  }

  @override
  Widget build(BuildContext context) {
    grade =
        ref.watch(gradeViewControllerProvider);

    return grade.when(
      data: (grade) =>Padding(
        padding: const EdgeInsets.all(8.0),
        child: RefreshIndicator(
            onRefresh: () async {
              ref
                  .read(gradeViewControllerProvider.notifier)
                  .fetchGrade(widget.submissionId);
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
              )
            )
        ),
      ),
      error: (e, s) => Center(
        child: Text(e.toString()),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),

    );

  }
}