import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grader_io/Controllers/summary_of_assignments_view_controller.dart';
import 'package:grader_io/Models/summary_of_assignments.dart';

import '../Models/classroom.dart';

class SummaryOfAssignmentsView extends ConsumerStatefulWidget {
  final Classroom classroom;

  const SummaryOfAssignmentsView({Key? key, required this.classroom})
      : super(key: key);

  @override
  SummaryOfAssignmentsViewState createState() =>
      SummaryOfAssignmentsViewState();
}

class SummaryOfAssignmentsViewState
    extends ConsumerState<SummaryOfAssignmentsView> {
  late AsyncValue<SummaryOfAssignments> summaryOfAssignments;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => ref
        .read(summaryOfAssignmentsViewControllerProvider.notifier)
        .fetchAssignments(widget.classroom.code!));
  }

  @override
  Widget build(BuildContext context) {
    summaryOfAssignments =
        ref.watch(summaryOfAssignmentsViewControllerProvider);

    return summaryOfAssignments.when(
      data: (summaryOfAssignments) => Scaffold(
        appBar: AppBar(
          title: Text(widget.classroom.name!,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RefreshIndicator(
            onRefresh: () async {
              ref
                  .read(summaryOfAssignmentsViewControllerProvider.notifier)
                  .fetchAssignments(widget.classroom.code!);
            },
            child: summaryOfAssignments.assignments!.isEmpty
                ? const Center(child: Text('No Assignments created'))
                : ListView.builder(
                    itemCount: summaryOfAssignments.assignments!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Material(
                          elevation: 4.0,
                          shadowColor: Colors.blueGrey,
                          child: ListTile(
                            onTap: () => {},
                            title: Text(summaryOfAssignments
                                .assignments![index].title!),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
      error: (e, s) => Scaffold(
        appBar: AppBar(
          title: Text(widget.classroom.name!,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Center(
          child: Text(e.toString()),
        ),
      ),
      loading: () => Scaffold(
        appBar: AppBar(
          title: Text(widget.classroom.name!,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
