import 'package:grader_io/Models/submission_summary.dart';

class SummaryOfAssignedSubmissionsForReview {

  List<SubmissionSummary>? submissions;

  SummaryOfAssignedSubmissionsForReview({this.submissions});

  SummaryOfAssignedSubmissionsForReview.fromJson(Map<String, dynamic> json) {

    if (json['submissions'] != null) {
      submissions = <SubmissionSummary>[];
      json['submissions'].forEach((v) {
        submissions!.add(SubmissionSummary.fromJson(v));
      });
    }
  }

}