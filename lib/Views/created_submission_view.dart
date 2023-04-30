// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Controllers/created_submission_view_controller.dart';
import '../Models/created_submission_detail.dart';

class CreatedSubmissionView extends ConsumerStatefulWidget {
  final int assignmentId;

  const CreatedSubmissionView({Key? key, required this.assignmentId})
      : super(key: key);

  @override
  CreatedSubmissionViewState createState() => CreatedSubmissionViewState();
}

class CreatedSubmissionViewState extends ConsumerState<CreatedSubmissionView> {



  late AsyncValue<CreatedSubmissionDetail> submissionDetail;
  String _markdownTextDescription = '';

  final _descController = TextEditingController();

  final _scrollController = ScrollController();

  bool submittedAnything = false;
  bool showEditor = false;

  void wrapWith(
      {required String leftSide,
      required String rightSide,
      required TextEditingController controller}) {
    final text = controller.value.text;
    final selection = controller.selection;
    final middle = selection.textInside(text);
    final newText =
        '${selection.textBefore(text)}$leftSide$middle$rightSide${selection.textAfter(text)}';
    controller.value = controller.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(
        offset: selection.baseOffset + leftSide.length + middle.length,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => ref
        .read(createdSubmissionViewControllerProvider.notifier)
        .fetchCreatedSubmission(widget.assignmentId));
  }

  @override
  Widget build(BuildContext context) {
    submissionDetail = ref.watch(createdSubmissionViewControllerProvider);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double editorHeight = 550;

    return submissionDetail.when(
      data: (submissionDetail) {
        if (submissionDetail.submissionDetail == null) {
          submittedAnything = false;
          if(showEditor == false){
            _descController.value = TextEditingValue(text: '');
            _markdownTextDescription = '';
          }
        } else {
          submittedAnything = true;
          if(showEditor == false){
            _markdownTextDescription =
            submissionDetail.submissionDetail!.content!;
          }
        }
        return SingleChildScrollView(
          child: (!submittedAnything && showEditor == false)
              ? Container(
                  width: width,
                  height: height,
                  padding: EdgeInsets.all(15),
                  child: Center(
                    child: SizedBox(
                      height: 200,
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            child: Text(
                              "You have not submitted anything",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          submissionDetail.currentStateOfAssignment ==
                                  'accepting_submissions'
                              ? Container(
                                  height: 50,
                                  width: 140,
                                  child: SizedBox(
                                    width: 140,
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 224, 224, 224),
                                      ),
                                      child: Text(
                                        "Edit",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 22, 22, 22),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          showEditor = true;
                                        });
                                      },
                                    ),
                                  ),
                                )
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ),
                )
              : Column(
                  children: [
                    Container(
                      width: width,
                      height: 100,
                    ),
                    submittedAnything ?
                    Container(
                      width: width,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "State :",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ) 
                    :
                    Container(),
                    submittedAnything ?
                    Container(
                      width: width,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                      child: Text(
                        submissionDetail.submissionDetail!.submissionState!.toString().toUpperCase(),
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ) 
                    :
                    Container(),
                    Container(
                      width: width,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "Contents :",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    showEditor
                        ? Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: editorHeight,
                                    ),
                                    SizedBox(
                                      width: (width) / 2 - 30,
                                      height: editorHeight,
                                      child: Column(
                                        children: [
                                          Container(
                                            width: (width) / 2 - 30,
                                            height: 40,
                                            padding: EdgeInsets.all(3),
                                            // color: Colors.blue,
                                            child: markdownEdititems(
                                                _descController),
                                          ),
                                          Container(
                                            width: (width) / 2 - 30,
                                            height: editorHeight - 40,
                                            padding: EdgeInsets.all(20),
                                            child: TextField(
                                              controller: _descController,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              maxLines: 25,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none),
                                              onChanged: (text) {
                                                setState(() {

                                                  _markdownTextDescription =
                                                      text;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      color: Colors.black,
                                      width: 5,
                                      height: editorHeight,
                                    ),
                                    Container(
                                      width: (width) / 2 - 30,
                                      height: editorHeight,
                                      child: SingleChildScrollView(
                                        child: Container(
                                          height: editorHeight,
                                          width: (width) / 2 - 30,
                                          padding: EdgeInsets.all(20),
                                          child: Markdown(
                                              data: _markdownTextDescription),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: editorHeight,
                                    ),
                                    Container(
                                      width: (width) - 60,
                                      height: editorHeight,
                                      child: SingleChildScrollView(
                                        child: Container(
                                          height: editorHeight,
                                          width: (width) - 60,
                                          padding: EdgeInsets.all(20),
                                          child: Markdown(
                                              data: _markdownTextDescription),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                    showEditor
                        ? Container(
                            width: width,
                            height: 60,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.all(15),
                            child: Container(
                              width: 300,
                              height: 60,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 140,
                                    height: 60,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            Color.fromARGB(255, 224, 224, 224),
                                      ),
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 22, 22, 22),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          showEditor = false;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  SizedBox(
                                    width: 140,
                                    height: 60,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueGrey,
                                      ),
                                      child: Text(
                                        "Save",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        showEditor = false;
                                        ref.read(createdSubmissionViewControllerProvider.notifier).saveSubmission(widget.assignmentId, _markdownTextDescription);
                                        
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : submissionDetail.currentStateOfAssignment ==
                                'accepting_submissions'
                            ? Container(
                                width: width,
                                height: 60,
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.all(15),
                                child: Container(
                                  width: 300,
                                  height: 60,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 140,
                                        height: 60,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color.fromARGB(
                                                255, 224, 224, 224),
                                          ),
                                          child: Text(
                                            "Edit",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 22, 22, 22),
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              showEditor = true;
                                              _descController.value =
                                                  TextEditingValue(
                                                      text: submissionDetail
                                                          .submissionDetail!
                                                          .content!);
                                              _markdownTextDescription = submissionDetail.submissionDetail!.content!;
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      SizedBox(
                                        width: 140,
                                        height: 60,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blueGrey,
                                          ),
                                          child: Text(
                                            "Submit",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onPressed: () {
                                            showEditor = false;
                                            ref.read(createdSubmissionViewControllerProvider.notifier).submitSubmission(widget.assignmentId, submissionDetail.submissionDetail!.content!);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox(),
                  ],
                ),
        );
      },
      error: (e, s) => Center(
        child: Text(e.toString()),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  ListView markdownEdititems(TextEditingController controller) => ListView(
        shrinkWrap: true,
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        children: [
          ElevatedButton(
            child: Icon(Icons.format_size_rounded),
            onPressed: () =>
                wrapWith(leftSide: '# ', rightSide: '', controller: controller),
          ),
          SizedBox(width: 20),
          ElevatedButton(
            child: Icon(Icons.format_bold),
            onPressed: () => wrapWith(
                leftSide: '**', rightSide: '**', controller: controller),
          ),
          SizedBox(width: 20),
          ElevatedButton(
            child: Icon(Icons.list),
            onPressed: () =>
                wrapWith(leftSide: '- ', rightSide: '', controller: controller),
          ),
          SizedBox(width: 20),
          ElevatedButton(
            child: Icon(Icons.format_italic),
            onPressed: () =>
                wrapWith(leftSide: '*', rightSide: '*', controller: controller),
          ),
          SizedBox(width: 20),
          ElevatedButton(
            child: Icon(Icons.code),
            onPressed: () => wrapWith(
                leftSide: '```', rightSide: '```', controller: controller),
          ),
        ],
      );
}
