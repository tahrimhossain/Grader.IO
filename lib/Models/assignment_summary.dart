class AssignmentSummary {
  int? assignmentId;
  String? title;
  String? currentState;
  DateTime? submissionDeadline;
  DateTime? reviewDeadline;


  AssignmentSummary(
      {this.assignmentId,
        this.title,
        this.currentState,
        this.submissionDeadline,
        this.reviewDeadline});

  AssignmentSummary.fromJson(Map<String, dynamic> json) {
    assignmentId = json['assignment_id'];
    title = json['title'];
    currentState = json['current_state'];
    submissionDeadline = DateTime.parse(json['submission_deadline']).toLocal();
    reviewDeadline = DateTime.parse(json['review_deadline']).toLocal();

  }


}
