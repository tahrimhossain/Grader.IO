import 'assignment.dart';

class SummaryOfAssignments {
  List<Assignment>? assignments;

  SummaryOfAssignments({this.assignments});

  SummaryOfAssignments.fromJson(Map<String, dynamic> json) {
    if (json['assignments'] != null) {
      assignments = <Assignment>[];
      json['assignments'].forEach((v) {
        assignments!.add(Assignment.fromJson(v));
      });
    }
  }

}
