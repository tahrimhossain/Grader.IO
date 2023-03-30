class ReviewSummary {
  int? reviewId;
  int? score;
  int? maxScore;
  int? reviewerId;
  String? email;
  String? name;
  int? submissionId;

  ReviewSummary(
      {this.reviewId,
        this.score,
        this.maxScore,
        this.reviewerId,
        this.email,
        this.name,
        this.submissionId});

  ReviewSummary.fromJson(Map<String, dynamic> json) {
    reviewId = json['review_id'];
    score = json['score'];
    maxScore = json['max_score'];
    reviewerId = json['reviewer_id'];
    email = json['email'];
    name = json['name'];
    submissionId = json['submission_id'];
  }

}