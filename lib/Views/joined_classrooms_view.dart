import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grader_io/Controllers/joined_classrooms_view_controller.dart';
import 'package:grader_io/Models/joined_classrooms.dart';

class JoinedClassroomsView extends ConsumerStatefulWidget {

  const JoinedClassroomsView({Key? key})
      : super(key: key);

  @override
  JoinedClassroomsViewState createState() =>
      JoinedClassroomsViewState();
}

class JoinedClassroomsViewState extends ConsumerState<JoinedClassroomsView> {

  late AsyncValue<JoinedClassrooms> joinedClassrooms;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => ref
        .read(joinedClassroomsViewControllerProvider.notifier)
        .fetchJoinedClassrooms());
  }

  @override
  Widget build(BuildContext context) {

    joinedClassrooms = ref.watch(joinedClassroomsViewControllerProvider);

    return joinedClassrooms.when(
      data: (joinedClassrooms) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: RefreshIndicator(
          onRefresh: ()async{
            ref.read(joinedClassroomsViewControllerProvider.notifier).fetchJoinedClassrooms();
          },
          child: joinedClassrooms.classrooms!.isEmpty?
          const Center(child: Text('No Classrooms joined')):
          ListView.builder(
            itemCount: joinedClassrooms.classrooms!.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Material(
                  elevation: 4.0,
                  shadowColor: Colors.blueGrey,
                  child: ListTile(
                    onTap: () => {
                      GoRouter.of(context).push('/summary_of_assignments_in_joined_classroom/${joinedClassrooms.classrooms![index].name!}/${joinedClassrooms.classrooms![index].code!}',)
                    },
                    title: Text( joinedClassrooms.classrooms![index].name!),
                    subtitle: Text(joinedClassrooms.classrooms![index].description!),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      error: (e, s) =>  Center(child: Text(e.toString()),),
      loading: () => const Center(child: CircularProgressIndicator()),);
  }
}