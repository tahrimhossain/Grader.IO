// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    double width = MediaQuery. of(context). size. width;
    double height = MediaQuery. of(context). size. height;

    return joinedClassrooms.when(
      data: (joinedClassrooms) => joinedClassrooms.classrooms!.isEmpty?Center(child: Text('No classroom created'),):SingleChildScrollView(
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
                for (var item in joinedClassrooms.classrooms!) 
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
                              )
                            ),
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
                                
                              )
                            ),
                            Expanded(
                              flex: 2, 
                              child: Container(
                                color: Colors.white,
                                child: Row(
                                  children: [
                                    Expanded(child: SizedBox(),),
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: Tooltip(
                                        message: "Copy classroom code",
                                        child: IconButton(
                                          icon: Icon(Icons.content_copy),
                                          onPressed:() {
                                            Clipboard.setData(ClipboardData(text: item.code!));
                                          },
                                        ),
                                      ),
                                    ),
                                  ]
                                ),
                              )
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      GoRouter.of(context).push('/summary_of_assignments_in_joined_classroom/${item.name!}/${item.code!}');
                    },
                  )
              ],
            )
          ),
        ),
      error: (e, s) =>  Center(child: Text(e.toString()),),
      loading: () => const Center(child: CircularProgressIndicator()),);
  }
}