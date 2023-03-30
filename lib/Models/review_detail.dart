class ReviewDetail {
  int? reviewId;
  int? score;
  int? maxScore;
  String? content;
  int? reviewerId;
  String? email;
  String? name;
  int? submissionId;

  ReviewDetail(
      {this.reviewId,
        this.score,
        this.maxScore,
        this.content,
        this.reviewerId,
        this.email,
        this.name,
        this.submissionId});

  ReviewDetail.fromJson(Map<String, dynamic> json) {
    reviewId = json['review_id'];
    score = json['score'];
    maxScore = json['max_score'];
    content = json['content'];
    reviewerId = json['reviewer_id'];
    email = json['email'];
    name = json['name'];
    submissionId = json['submission_id'];
  }

}
