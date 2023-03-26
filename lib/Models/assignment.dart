class Assignment {
  int? assignmentId;
  String? title;
  String? currentState;
  DateTime? submissionDeadline;
  DateTime? reviewDeadline;


  Assignment(
      {this.assignmentId,
        this.title,
        this.currentState,
        this.submissionDeadline,
        this.reviewDeadline});

  Assignment.fromJson(Map<String, dynamic> json) {
    assignmentId = json['assignment_id'];
    title = json['title'];
    currentState = json['current_state'];
    submissionDeadline = DateTime.parse(json['submission_deadline']);
    reviewDeadline = DateTime.parse(json['review_deadline']);

  }


}
