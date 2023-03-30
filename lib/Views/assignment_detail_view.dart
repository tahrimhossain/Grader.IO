import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grader_io/Controllers/assignment_detail_view_controller.dart';
import 'package:grader_io/Models/assignment_detail.dart';


class AssignmentDetailView extends ConsumerStatefulWidget {
  final int assignmentId;

  const AssignmentDetailView({Key? key, required this.assignmentId})
      : super(key: key);

  @override
  AssignmentDetailViewState createState() =>
      AssignmentDetailViewState();
}

class AssignmentDetailViewState
    extends ConsumerState<AssignmentDetailView> {

  late AsyncValue<AssignmentDetail> assignmentDetail;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => ref
        .read(assignmentDetailViewControllerProvider.notifier)
        .fetchAssignmentDetail(widget.assignmentId));
  }

  @override
  Widget build(BuildContext context) {
    assignmentDetail =
        ref.watch(assignmentDetailViewControllerProvider);

    return assignmentDetail.when(
      data: (assignmentDetail) =>Padding(
          padding: const EdgeInsets.all(8.0),
          child: RefreshIndicator(
            onRefresh: () async {
              ref
                  .read(assignmentDetailViewControllerProvider.notifier)
                  .fetchAssignmentDetail(widget.assignmentId);
            },
            child: Center(
              child: Text(assignmentDetail.title!),
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