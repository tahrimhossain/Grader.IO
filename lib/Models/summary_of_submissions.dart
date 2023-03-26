import 'package:grader_io/Models/submission_summary.dart';

class SummaryOfSubmissions {
  List<SubmissionSummary>? submissions;

  SummaryOfSubmissions({this.submissions});

  SummaryOfSubmissions.fromJson(Map<String, dynamic> json) {
    if (json['submissions'] != null) {
      submissions = <SubmissionSummary>[];
      json['submissions'].forEach((v) {
        submissions!.add(SubmissionSummary.fromJson(v));
      });
    }
  }

}