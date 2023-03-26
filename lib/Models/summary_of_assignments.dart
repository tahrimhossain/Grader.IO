import 'assignment_summary.dart';

class SummaryOfAssignments {
  List<AssignmentSummary>? assignments;

  SummaryOfAssignments({this.assignments});

  SummaryOfAssignments.fromJson(Map<String, dynamic> json) {
    if (json['assignments'] != null) {
      assignments = <AssignmentSummary>[];
      json['assignments'].forEach((v) {
        assignments!.add(AssignmentSummary.fromJson(v));
      });
    }
  }

}
