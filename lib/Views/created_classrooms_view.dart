import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grader_io/Controllers/joined_classrooms_view_controller.dart';
import '../Controllers/created_classrooms_view_controller.dart';
import '../Models/created_classrooms.dart';

class CreatedClassroomsView extends ConsumerStatefulWidget {
  const CreatedClassroomsView({Key? key}) : super(key: key);

  @override
  CreatedClassroomsViewState createState() => CreatedClassroomsViewState();
}

class CreatedClassroomsViewState extends ConsumerState<CreatedClassroomsView> {
  late AsyncValue<CreatedClassrooms> createdClassrooms;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => ref
        .read(createdClassroomsViewControllerProvider.notifier)
        .fetchCreatedClassrooms());
  }

  @override
  Widget build(BuildContext context) {
    createdClassrooms = ref.watch(createdClassroomsViewControllerProvider);

    return createdClassrooms.when(
      data: (createdClassrooms) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: RefreshIndicator(
          onRefresh: () async {
            ref
                .read(joinedClassroomsViewControllerProvider.notifier)
                .fetchJoinedClassrooms();
          },
          child: createdClassrooms.classrooms!.isEmpty
              ? const Center(child: Text('No Classrooms created'))
              : ListView.builder(
                  itemCount: createdClassrooms.classrooms!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Material(
                        elevation: 4.0,
                        shadowColor: Colors.blueGrey,
                        child: ListTile(
                          onTap: () => {
                            GoRouter.of(context).push('/summary_of_assignments',
                                extra: createdClassrooms.classrooms![index])
                          },
                          title:
                              Text(createdClassrooms.classrooms![index].name!),
                          subtitle: Text(createdClassrooms
                              .classrooms![index].description!),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
      error: (e, s) => Center(
        child: Text(e.toString()),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
