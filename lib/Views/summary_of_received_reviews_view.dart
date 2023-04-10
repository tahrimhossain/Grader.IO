import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../Controllers/summary_of_received_reviews_view_controller.dart';
import '../Models/summary_of_submission_reviews.dart';

class SummaryOfReceivedReviewsView extends ConsumerStatefulWidget {
  final int assignmentId;

  const SummaryOfReceivedReviewsView({Key? key, required this.assignmentId})
      : super(key: key);

  @override
  SummaryOfReceivedReviewsViewState createState() =>
      SummaryOfReceivedReviewsViewState();
}

class SummaryOfReceivedReviewsViewState
    extends ConsumerState<SummaryOfReceivedReviewsView> {
  late AsyncValue<SummaryOfSubmissionReviews> summaryOfReceivedReviews;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => ref
        .read(summaryOfReceivedReviewsViewControllerProvider.notifier)
        .fetchReceivedReviews(widget.assignmentId));
  }

  @override
  Widget build(BuildContext context) {
    summaryOfReceivedReviews =
        ref.watch(summaryOfReceivedReviewsViewControllerProvider);

    return summaryOfReceivedReviews.when(
      data: (summaryOfReceivedReviews) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: RefreshIndicator(
          onRefresh: () async {
            ref
                .read(summaryOfReceivedReviewsViewControllerProvider.notifier)
                .fetchReceivedReviews(widget.assignmentId);
          },
          child: summaryOfReceivedReviews.reviews!.isEmpty
              ? const Center(child: Text('No Reviews Received'))
              : ListView.builder(
            itemCount: summaryOfReceivedReviews.reviews!.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Material(
                  elevation: 4.0,
                  shadowColor: Colors.blueGrey,
                  child: ListTile(
                    onTap: () {
                      GoRouter.of(context).push('/review_detail/${summaryOfReceivedReviews.reviews![index].reviewId}');
                    },
                    title: Text("Review ${index+1}"),
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