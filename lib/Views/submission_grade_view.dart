import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Controllers/submission_grade_view_controller.dart';
import '../Models/submission_grade.dart';

class SubmissionGradeView extends ConsumerStatefulWidget {
  final int submissionId;

  const SubmissionGradeView({Key? key, required this.submissionId})
      : super(key: key);

  @override
  SubmissionGradeViewState createState() => SubmissionGradeViewState();
}

class SubmissionGradeViewState extends ConsumerState<SubmissionGradeView> {
  late AsyncValue<SubmissionGrade> submissionGrade;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => ref
        .read(submissionGradeViewControllerProvider.notifier)
        .fetchSubmissionGrade(widget.submissionId));
  }

  @override
  Widget build(BuildContext context) {
    submissionGrade = ref.watch(submissionGradeViewControllerProvider);

    return submissionGrade.when(
      data: (submissionGrade) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: RefreshIndicator(
            onRefresh: () async {
              ref
                  .read(submissionGradeViewControllerProvider.notifier)
                  .fetchSubmissionGrade(widget.submissionId);
            },
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Max Score:${submissionGrade.grade!.maxScore!}"),
                Text(
                    "Evaluation Score:${submissionGrade.grade!.evaluationScore!}"),
                Text("Review Score:${submissionGrade.grade!.reviewScore!}"),
                Text(
                    "Predicted Score:${submissionGrade.grade!.predictedScore!}"),
                Text("Final Score:${submissionGrade.grade!.finalScore!}"),
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
