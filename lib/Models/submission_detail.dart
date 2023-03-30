class SubmissionDetail {
  int? submissionId;
  DateTime? submissionTime;
  String? content;
  String? submissionState;
  String? email;
  String? name;
  int? userId;
  int? assignmentId;

  SubmissionDetail(
      {this.submissionId,
        this.submissionTime,
        this.content,
        this.submissionState,
        this.email,
        this.name,
        this.userId,
        this.assignmentId});

  SubmissionDetail.fromJson(Map<String, dynamic> json) {
    submissionId = json['submission_id'];
    submissionTime = DateTime.parse(json['submission_time']);
    content = json['content'];
    submissionState = json['submission_state'];
    email = json['email'];
    name = json['name'];
    userId = json['user_id'];
    assignmentId = json['assignment_id'];
  }
  
}