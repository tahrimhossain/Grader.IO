import 'package:grader_io/Models/submission_detail.dart';

class CreatedSubmissionDetail {
  String? currentStateOfAssignment;
  SubmissionDetail? submissionDetail;

  CreatedSubmissionDetail({this.currentStateOfAssignment, this.submissionDetail});

  CreatedSubmissionDetail.fromJson(Map<String, dynamic> json) {
    currentStateOfAssignment = json['current_state_of_assignment'];
    submissionDetail =
    json['detail'] != null ? SubmissionDetail.fromJson(json['detail']) : null;
  }

}