import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grader_io/Controllers/summary_of_submissions_view_controller.dart';

import '../Models/summary_of_submissions.dart';

class SummaryOfSubmissionsView extends ConsumerStatefulWidget {
  final int assignmentId;

  const SummaryOfSubmissionsView({Key? key, required this.assignmentId})
      : super(key: key);

  @override
  SummaryOfSubmissionsViewState createState() =>
      SummaryOfSubmissionsViewState();
}

class SummaryOfSubmissionsViewState
    extends ConsumerState<SummaryOfSubmissionsView> {
  late AsyncValue<SummaryOfSubmissions> summaryOfSubmissions;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => ref
        .read(summaryOfSubmissionsViewControllerProvider.notifier)
        .fetchSummaryOfSubmissions(widget.assignmentId));
  }

  @override
  Widget build(BuildContext context) {
    summaryOfSubmissions =
        ref.watch(summaryOfSubmissionsViewControllerProvider);

    return summaryOfSubmissions.when(
      data: (summaryOfSubmissions) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: RefreshIndicator(
            onRefresh: () async {
              ref
                  .read(summaryOfSubmissionsViewControllerProvider.notifier)
                  .fetchSummaryOfSubmissions(widget.assignmentId);
            },
            child: summaryOfSubmissions.submissions!.isEmpty
                ? const Center(child: Text('No Submissions'))
                : ListView.builder(
                    itemCount: summaryOfSubmissions.submissions!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Material(
                          elevation: 4.0,
                          shadowColor: Colors.blueGrey,
                          child: ListTile(
                            onTap: () {},
                            title: Text(
                                summaryOfSubmissions.submissions![index].name!),
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
