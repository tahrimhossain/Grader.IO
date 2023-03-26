class SubmissionSummary {
  int? submissionId;
  DateTime? submissionTime;
  String? email;
  String? name;
  int? evaluationScore;
  int? reviewScore;
  int? predictedScore;
  int? finalScore;
  int? maxScore;

  SubmissionSummary(
      {this.submissionId,
        this.submissionTime,
        this.email,
        this.name,
        this.evaluationScore,
        this.reviewScore,
        this.predictedScore,
        this.finalScore,
        this.maxScore});

  SubmissionSummary.fromJson(Map<String, dynamic> json) {
    submissionId = json['submission_id'];
    submissionTime = DateTime.parse(json['submission_time']);
    email = json['email'];
    name = json['name'];
    evaluationScore = json['evaluation_score'];
    reviewScore = json['review_score'];
    predictedScore = json['predicted_score'];
    finalScore = json['final_score'];
    maxScore = json['max_score'];
  }

}