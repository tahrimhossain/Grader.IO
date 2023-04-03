import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grader_io/Models/summary_of_submission_reviews.dart';

import '../Controllers/summary_of_submission_reviews_view_controller.dart';

class SummaryOfSubmissionReviewsView extends ConsumerStatefulWidget {
  final int submissionId;

  const SummaryOfSubmissionReviewsView({Key? key, required this.submissionId})
      : super(key: key);

  @override
  SummaryOfSubmissionReviewsViewState createState() =>
      SummaryOfSubmissionReviewsViewState();
}

class SummaryOfSubmissionReviewsViewState
    extends ConsumerState<SummaryOfSubmissionReviewsView> {
  late AsyncValue<SummaryOfSubmissionReviews> summaryOfSubmissionReviews;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => ref
        .read(summaryOfSubmissionReviewsViewControllerProvider.notifier)
        .fetchSummaryOfSubmissionReviews(widget.submissionId));
  }

  @override
  Widget build(BuildContext context) {
    summaryOfSubmissionReviews =
        ref.watch(summaryOfSubmissionReviewsViewControllerProvider);

    return summaryOfSubmissionReviews.when(
      data: (summaryOfSubmissionReviews) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: RefreshIndicator(
          onRefresh: () async {
            ref
                .read(summaryOfSubmissionReviewsViewControllerProvider.notifier)
                .fetchSummaryOfSubmissionReviews(widget.submissionId);
          },
          child: summaryOfSubmissionReviews.reviews!.isEmpty
              ? const Center(child: Text('No Reviews'))
              : ListView.builder(
            itemCount: summaryOfSubmissionReviews.reviews!.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Material(
                  elevation: 4.0,
                  shadowColor: Colors.blueGrey,
                  child: ListTile(
                    onTap: () {},
                    title: Text(
                        summaryOfSubmissionReviews.reviews![index].name!),
                  ),
                ),
              );
            },
          ),
        ),
      ),

      error: (e, s) =>Center(
        child: Text(e.toString()),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),

    );
  }
}
