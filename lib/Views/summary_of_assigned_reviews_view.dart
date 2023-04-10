import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grader_io/Models/summary_of_assigned_submissions_for_review.dart';

import '../Controllers/summary_of_assigned_reviews_view_controller.dart';

class SummaryOfAssignedReviewsView extends ConsumerStatefulWidget {
  final int assignmentId;

  const SummaryOfAssignedReviewsView({Key? key, required this.assignmentId})
      : super(key: key);

  @override
  SummaryOfAssignedReviewsViewState createState() =>
      SummaryOfAssignedReviewsViewState();
}

class SummaryOfAssignedReviewsViewState
    extends ConsumerState<SummaryOfAssignedReviewsView> {
  late AsyncValue<SummaryOfAssignedSubmissionsForReview> summaryOfAssignedSubmissionsForReview;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => ref
        .read(summaryOfAssignedReviewsViewControllerProvider.notifier)
        .fetchAssignedReviews(widget.assignmentId));
  }

  @override
  Widget build(BuildContext context) {
    summaryOfAssignedSubmissionsForReview =
        ref.watch(summaryOfAssignedReviewsViewControllerProvider);

    return summaryOfAssignedSubmissionsForReview.when(
      data: (summaryOfAssignedSubmissionsForReview) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: RefreshIndicator(
          onRefresh: () async {
            ref
                .read(summaryOfAssignedReviewsViewControllerProvider.notifier)
                .fetchAssignedReviews(widget.assignmentId);
          },
          child: summaryOfAssignedSubmissionsForReview.submissions!.isEmpty
              ? const Center(child: Text('No Reviews Assigned'))
              : ListView.builder(
            itemCount: summaryOfAssignedSubmissionsForReview.submissions!.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Material(
                  elevation: 4.0,
                  shadowColor: Colors.blueGrey,
                  child: ListTile(
                    onTap: () {
                      GoRouter.of(context).push('/submission_info/${summaryOfAssignedSubmissionsForReview.submissions![index].submissionId}');
                    },
                    title: Text("Submission ${index+1}"),
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