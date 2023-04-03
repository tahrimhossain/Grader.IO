import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Controllers/submission_detail_view_controller.dart';
import '../Models/submission_detail.dart';

class SubmissionDetailView extends ConsumerStatefulWidget {
  final int submissionId;

  const SubmissionDetailView({Key? key, required this.submissionId})
      : super(key: key);

  @override
  SubmissionDetailViewState createState() =>
      SubmissionDetailViewState();
}

class SubmissionDetailViewState
    extends ConsumerState<SubmissionDetailView> {

  late AsyncValue<SubmissionDetail> submissionDetail;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => ref
        .read(submissionDetailViewControllerProvider.notifier)
        .fetchSubmissionDetail(widget.submissionId));
  }

  @override
  Widget build(BuildContext context) {
    submissionDetail =
        ref.watch(submissionDetailViewControllerProvider);

    return submissionDetail.when(
      data: (submissionDetail) =>Padding(
        padding: const EdgeInsets.all(8.0),
        child: RefreshIndicator(
            onRefresh: () async {
              ref
                  .read(submissionDetailViewControllerProvider.notifier)
                  .fetchSubmissionDetail(widget.submissionId);
            },
            child: Center(
              child: Markdown(data:submissionDetail.content!,selectable: true,),
            )
        ),
      ),
      error: (e, s) => Center(
        child: Text(e.toString()),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),

    );

  }
}