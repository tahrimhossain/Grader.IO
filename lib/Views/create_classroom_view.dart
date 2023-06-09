// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:grader_io/Controllers/create_classroom_view_controller.dart';
import 'package:grader_io/Models/classroom.dart';

class CreateClassroomView extends ConsumerStatefulWidget {
  const CreateClassroomView({Key? key}) : super(key: key);

  @override
  CreateClassroomViewState createState() => CreateClassroomViewState();
}

class CreateClassroomViewState extends ConsumerState<CreateClassroomView> {
  late AsyncValue<CreateClassroomState> createClassroomState;
  final _formKey = GlobalKey<FormState>();
  String? _classroomName = "";
  String? _classroomDescription = "";

  @override
  Widget build(BuildContext context) {
    createClassroomState = ref.watch(createClassroomViewControllerProvider);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    ref.listen(createClassroomViewControllerProvider, (prev, next) {
      if (next is AsyncData &&
          next.asData!.value is FailedToCreateClassroomState) {
        Exception error =
            (next.asData!.value as FailedToCreateClassroomState).error;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error:$error'),
          backgroundColor: Colors.red.shade300,
          duration: const Duration(seconds: 2),
        ));
      } else if (next is AsyncData &&
          next.asData!.value is SuccessfullyCreatedClassroomState) {
        Classroom createdClassroom =
            (next.asData!.value as SuccessfullyCreatedClassroomState).classroom;
        GoRouter.of(context).pushReplacement(
          '/summary_of_assignments_in_created_classroom/${createdClassroom.name!}/${createdClassroom.code!}',
        );
      }
    });

    return createClassroomState.when(
      data: (createClassroomState) => Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: width,
                height: height * .2,
              ),
              Center(
                child: Card(
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 400,
                          width: min(500, width),
                          child: LayoutBuilder(builder: (context, constraints) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                ),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: constraints.maxWidth * 0.3,
                                            child: Text("Classroom name : "),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          SizedBox(
                                            width: constraints.maxWidth * 0.6,
                                            child: TextFormField(
                                              minLines: 1,
                                              maxLines: 3,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide:
                                                      BorderSide(width: 50),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.blueGrey),
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Classroom name can\'t be empty';
                                                }
                                                if (value.toString().length >
                                                    100) {
                                                  return 'Name can\'t be more than 100 characters.';
                                                }
                                                return null;
                                              },
                                              onSaved: (value) {
                                                _classroomName = value;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                              width: constraints.maxWidth * 0.3,
                                              child: Text("Description : ")),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          SizedBox(
                                            width: constraints.maxWidth * 0.6,
                                            child: TextFormField(
                                              minLines: 1,
                                              maxLines: 3,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.blueGrey),
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value!.toString().length >
                                                    200) {
                                                  return 'Description can\'t be more than 200 characters.';
                                                }
                                                return null;
                                              },
                                              onSaved: (value) {
                                                _classroomDescription = value;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 25.0),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                        SizedBox(
                          width: 200,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                ref
                                    .read(createClassroomViewControllerProvider
                                        .notifier)
                                    .createClassroom(_classroomName!,
                                        _classroomDescription!);
                              }
                            },
                            child: Text(
                              'Create Classroom.',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      error: (e, s) => Scaffold(
          body: Center(
        child: Text("Error"),
      )),
      loading: () => Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
