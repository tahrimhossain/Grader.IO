import 'package:grader_io/Models/review_detail.dart';

class CreatedReviewDetail {
  String? currentStateOfAssignment;
  int? maxScore;
  ReviewDetail? reviewDetail;

  CreatedReviewDetail(
      {this.currentStateOfAssignment, this.maxScore, this.reviewDetail});

  CreatedReviewDetail.fromJson(Map<String, dynamic> json) {
    currentStateOfAssignment = json['current_state_of_assignment'];
    maxScore = json['max_score'];
    reviewDetail =
    json['detail'] != null ? ReviewDetail.fromJson(json['detail']) : null;
  }

}