class Grade {
  int? evaluationScore;
  int? reviewScore;
  int? predictedScore;
  int? finalScore;
  int? maxScore;

  Grade(
      {this.evaluationScore,
        this.reviewScore,
        this.predictedScore,
        this.finalScore,
        this.maxScore});

  Grade.fromJson(Map<String, dynamic> json) {
    evaluationScore = json['evaluation_score'];
    reviewScore = json['review_score'];
    predictedScore = json['predicted_score'];
    finalScore = json['final_score'];
    maxScore = json['max_score'];
  }

}
