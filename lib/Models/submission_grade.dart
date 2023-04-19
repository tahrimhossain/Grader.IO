import 'package:grader_io/Models/grade.dart';

class SubmissionGrade {
  String? assignmentState;
  Grade? grade;

  SubmissionGrade({this.assignmentState, this.grade});

  SubmissionGrade.fromJson(Map<String, dynamic> json) {
    assignmentState = json['assignment_state'];
    grade = json['grade'] != null ? Grade.fromJson(json['grade']) : null;
  }

}
