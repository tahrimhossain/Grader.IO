import 'package:grader_io/Models/review_summary.dart';

class SummaryOfSubmissionReviews {
  List<ReviewSummary>? reviews;

  SummaryOfSubmissionReviews({this.reviews});

  SummaryOfSubmissionReviews.fromJson(Map<String, dynamic> json) {
    if (json['reviews'] != null) {
      reviews = <ReviewSummary>[];
      json['reviews'].forEach((v) {
        reviews!.add(ReviewSummary.fromJson(v));
      });
    }
  }

}