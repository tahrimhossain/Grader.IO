// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Controllers/created_review_view_controller.dart';
import '../Models/created_review_detail.dart';

class CreatedReviewView extends ConsumerStatefulWidget {
  final int submissionId;

  const CreatedReviewView({Key? key, required this.submissionId})
      : super(key: key);

  @override
  CreatedReviewViewState createState() => CreatedReviewViewState();
}

class CreatedReviewViewState extends ConsumerState<CreatedReviewView> {
  late AsyncValue<CreatedReviewDetail> reviewDetail;

  String _markdownTextDescription = '';

  final _descController = TextEditingController();
  final _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();

  int assignedScore = 0;

  bool submittedAnything = false;
  bool showEditor = false;

  bool timeExpired = false;

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
        .read(createdReviewViewControllerProvider.notifier)
        .fetchCreatedReview(widget.submissionId));
  }

  @override
  Widget build(BuildContext context) {
    reviewDetail = ref.watch(createdReviewViewControllerProvider);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double editorHeight = 350;

    return reviewDetail.when(
      data: (reviewDetail) {
        if (reviewDetail.reviewDetail == null) {
          submittedAnything = false;
          assignedScore = 0;
          if (showEditor == false) {
            _descController.value = TextEditingValue(text: '');
            _markdownTextDescription = '';
          }
        } else {
          submittedAnything = true;
          assignedScore = reviewDetail.reviewDetail!.score!;
          if (showEditor == false) {
            _markdownTextDescription = reviewDetail.reviewDetail!.content!;
          }
        }
        return SingleChildScrollView(
          child: (!submittedAnything) && showEditor == false
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
                              "You have not reviewd the submission.",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          reviewDetail.currentStateOfAssignment ==
                                  'accepting_reviews'
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
                                        "Review",
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
                    SizedBox(width: width, height: 50,),
                    showEditor
                        ? Container(
                            width: width,
                            height: 80,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(15),
                            child: Row(
                              children: [
                                Text(
                                  "Score : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Container(
                                  height: 50,
                                  width: 70,
                                  alignment: Alignment.centerRight,
                                  child: Form(
                                    key: _formKey,
                                    child: TextFormField(
                                        minLines: 1,
                                        maxLines: 1,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(width: 50),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blueGrey),
                                          ),
                                        ),
                                        validator: (value) {
                                          assignedScore = int.parse(value!);
                                          return null;
                                        }),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                  width: 10,
                                ),
                                Text("/${reviewDetail.maxScore}"),
                              ],
                            ),
                          )
                        : Container(
                            width: width,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(15),
                            child: Text(
                              "Score : $assignedScore/${reviewDetail.maxScore}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                    Container(
                      width: width,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.all(15),
                      child: Text(
                        "Comment :",
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
                                              maxLines: 15,
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
                                        "Submit",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate() &&
                                            assignedScore <=
                                                reviewDetail.maxScore!) {
                                          showEditor = false;
                                          ref
                                              .read(
                                                  createdReviewViewControllerProvider
                                                      .notifier)
                                              .submitReview(
                                                  widget.submissionId,
                                                  assignedScore,
                                                  _markdownTextDescription);
                                        } else {
                                          var snackBar = SnackBar(
                                              content: Text(
                                                  'Score should be less than or equal to max score.'));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : reviewDetail.currentStateOfAssignment ==
                                'accepting_reviews' ? Container(
                                padding: EdgeInsets.only(right: 20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
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
                                            color:
                                                Color.fromARGB(255, 22, 22, 22),
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            showEditor = true;
                                            _descController.value =
                                                TextEditingValue(
                                                    text: reviewDetail
                                                        .reviewDetail!
                                                        .content!);
                                            _markdownTextDescription =
                                                reviewDetail
                                                    .reviewDetail!.content!;
                                          });
                                        },
                                      ),
                                    )
                                  ],
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
