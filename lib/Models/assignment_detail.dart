class AssignmentDetail {
  int? assignmentId;
  String? title;
  String? description;
  String? instructions;
  int? maxScore;
  int? numberOfReviewersPerSubmission;
  String? currentState;
  DateTime? submissionDeadline;
  DateTime? reviewDeadline;

  AssignmentDetail(
      {this.assignmentId,
        this.title,
        this.description,
        this.instructions,
        this.maxScore,
        this.numberOfReviewersPerSubmission,
        this.currentState,
        this.submissionDeadline,
        this.reviewDeadline});

  AssignmentDetail.fromJson(Map<String, dynamic> json) {
    assignmentId = json['assignment_id'];
    title = json['title'];
    description = json['description'];
    instructions = json['instructions'];
    maxScore = json['max_score'];
    numberOfReviewersPerSubmission = json['number_of_reviewers_per_submission'];
    currentState = json['current_state'];
    submissionDeadline = DateTime.parse(json['submission_deadline']);
    reviewDeadline = DateTime.parse(json['review_deadline']);
  }

  
}
