import 'package:grader_io/Models/submission_summary.dart';

class SummaryOfAssignedSubmissionsForReview {
  String? currentState;
  List<SubmissionSummary>? submissions;

  SummaryOfAssignedSubmissionsForReview({this.currentState,this.submissions});

  SummaryOfAssignedSubmissionsForReview.fromJson(Map<String, dynamic> json) {

    if (json['submissions'] != null) {
      submissions = <SubmissionSummary>[];
      json['submissions'].forEach((v) {
        submissions!.add(SubmissionSummary.fromJson(v));
      });
    }
  }

}