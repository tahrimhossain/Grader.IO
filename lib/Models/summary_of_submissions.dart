import 'package:grader_io/Models/submission_summary.dart';

class SummaryOfSubmissions {
  String? currentState;
  List<SubmissionSummary>? submissions;

  SummaryOfSubmissions({this.currentState,this.submissions});

  SummaryOfSubmissions.fromJson(Map<String, dynamic> json) {
    currentState = json['current_state'];
    if (json['submissions'] != null) {
      submissions = <SubmissionSummary>[];
      json['submissions'].forEach((v) {
        submissions!.add(SubmissionSummary.fromJson(v));
      });
    }
  }

}