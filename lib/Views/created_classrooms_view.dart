// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return createdClassrooms.when(
      data: (createdClassrooms) => createdClassrooms.classrooms!.isEmpty
          ? Center(
              child: Text('No classroom created'),
            )
          : SingleChildScrollView(
              child: Container(
                  height: height,
                  width: width,
                  child: GridView.count(
                    primary: false,
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: width ~/ 350,
                    childAspectRatio: 1.2,
                    children: <Widget>[
                      for (var item in createdClassrooms.classrooms!)
                        InkWell(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Card(
                              color: Colors.blueGrey,
                              elevation: 10.0,
                              shadowColor: Colors.black,
                              child: Column(
                                mainAxisSize: MainAxisSize.min, // add this
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      flex: 3,
                                      child: Container(
                                        padding: EdgeInsets.all(15),
                                        child: Text(
                                          item.name!,
                                          maxLines: 2,
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                      )),
                                  Expanded(
                                      flex: 4,
                                      child: Container(
                                        padding: EdgeInsets.all(15),
                                        width: double.infinity,
                                        color: Colors.white,
                                        child: Text(
                                          item.description!,
                                          maxLines: 4,
                                          style: TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            color: Colors.black,
                                            fontSize: 12,
                                          ),
                                        ),
                                      )),
                                  Expanded(
                                      flex: 2,
                                      child: Container(
                                        color: Colors.white,
                                        child: Row(children: [
                                          Expanded(
                                            child: SizedBox(),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            child: Tooltip(
                                              message: "Copy classroom code",
                                              child: IconButton(
                                                icon: Icon(Icons.content_copy),
                                                onPressed: () {
                                                  Clipboard.setData(
                                                      ClipboardData(
                                                          text: item.code!));
                                                },
                                              ),
                                            ),
                                          ),
                                        ]),
                                      )),
                                ],
                              ),
                            ),
                          ),
                          onTap: () => {
                            GoRouter.of(context).push(
                              '/summary_of_assignments_in_created_classroom/${item.name!}/${item.code!}',
                            )
                          },
                        )
                    ],
                  )),
            ),
      error: (e, s) => Center(
        child: Text(e.toString()),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
