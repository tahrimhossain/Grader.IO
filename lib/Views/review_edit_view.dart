// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ReviewEdit extends StatefulWidget {
  const ReviewEdit({super.key});

  @override
  State<ReviewEdit> createState() => _ReviewEditState();
}

class _ReviewEditState extends State<ReviewEdit> {
  String _markdownTextDescription = '';
  String submissionContents = "abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc \\ "
                              "abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc \\ "
                              "abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc \\ "
                              "abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc abc \\ ";
  
  final _descController = TextEditingController();
  
  final _scrollController = ScrollController();

  final _formKey = GlobalKey<FormState>();

  int maxScore = 100;
  int assignedScore = 50;

  bool submittedAnything = false;
  bool showEditor = false;

  bool timeExpired = false;
  
  
  void wrapWith({required String leftSide, required String rightSide, required TextEditingController controller}) {
    final text = controller.value.text;
    final selection = controller.selection;
    final middle = selection.textInside(text);
    final newText = '${selection.textBefore(text)}$leftSide$middle$rightSide${selection.textAfter(text)}';
    controller.value = controller.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(
        offset: selection.baseOffset + leftSide.length + middle.length,
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery. of(context). size. width;
    double height = MediaQuery. of(context). size. height;
    double editorHeight = 350;

    return Scaffold(
      body: SingleChildScrollView(
        child: (!submittedAnything) ?
        Container(
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
                  timeExpired ? 
                  SizedBox() 
                  :
                  Container(
                    height: 50,
                    width: 140,
                    child: SizedBox(
                      width: 140,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 224, 224, 224),
                        ),
                        
                        child: Text(
                          "Review",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 22, 22, 22),
                            ),
                        ),
                        
                        onPressed: () {
                          setState(() {
                            submittedAnything ^= true;
                            showEditor ^= true;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ) 
        :
        Column(
        children: [
          SizedBox(width: width, height: 100,),
          Container(
            width: width, 
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(15),
            child: Text(
              "Description :",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(15.0),
            padding: EdgeInsets.all(5),
            width: (width) - 30,
            constraints: BoxConstraints(minHeight: 50),
            color: Color.fromARGB(255, 228, 228, 228),
            child:  MarkdownBody(
              selectable: true,
              data: submissionContents,
            )
          ),
          showEditor ? 
          Container(
            width: width,
            height: 80,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Text(
                  "Score : ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 50),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueGrey),
                        ),
                        
                      ),
                      validator: (value) {
                        assignedScore = int.parse(value!);
                        return null;
                      }
                    ),
                  ),
                ),
                SizedBox(height: 50, width: 10,),
                Text("/$maxScore"),
              ],
            ),
          ) 
          :
          Container(
            width: width, 
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(15),
            child: Text(
              "Score : $assignedScore/$maxScore",
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
          showEditor ? 
          Row(
            children: [
              
              Container(
                margin: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                child: Row(
                  children: [
                    SizedBox(width: 20, height: editorHeight,),
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
                            child: markdownEdititems(_descController),
                          ),
                          Container(
                            width: (width) / 2 - 30,
                            height: editorHeight - 40,
                            padding: EdgeInsets.all(20),
                            child: TextField(
                              controller: _descController,
                              keyboardType: TextInputType.multiline,
                              maxLines: 15,
                              decoration: InputDecoration(border: InputBorder.none),
                              onChanged: (text) {
                                setState(() {
                                  _markdownTextDescription = text;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(color: Colors.black, width: 5, height: editorHeight,),
                    Container(
                      width: (width) / 2 - 30,
                      height: editorHeight,
                      child: SingleChildScrollView(
                        child: Container(
                          height: editorHeight,
                          width: (width) / 2 - 30,
                          padding: EdgeInsets.all(20),
                          child: Markdown(data: _markdownTextDescription),
                        ),
                      ),
                    ),
                  ],
                ),
                ),
              ],
            )
            :
            Row(
            children: [
              
              Container(
                margin: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                child: Row(
                  children: [
                    SizedBox(width: 20, height: editorHeight,),
                    
                    Container(
                      width: (width) - 60,
                      height: editorHeight,
                      child: SingleChildScrollView(
                        child: Container(
                          height: editorHeight,
                          width: (width) - 60,
                          padding: EdgeInsets.all(20),
                          child: Markdown(
                            data: _markdownTextDescription
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ),
              ],
            ),
            showEditor ? 
            Container(
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
                          backgroundColor: Color.fromARGB(255, 224, 224, 224),
                        ),
                        
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 22, 22, 22),
                            ),
                        ),
                        
                        onPressed: () {
                          setState(() {
                            showEditor = false;
                            submittedAnything ^= true;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 20,),
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
                          if (_formKey.currentState!.validate() && assignedScore <= maxScore) {
                            setState(() {
                              showEditor = false;  
                            });
                          } else {
                            var snackBar = SnackBar(content: Text('Score should be less than or equal to max score.'));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ) 
            :
            Container(
              
            ),
          ],
        ),
      ), 
    );
  }

  
  ListView markdownEdititems(TextEditingController controller) => ListView(
        shrinkWrap: true,
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        children: [
          ElevatedButton(
            
            child: Icon(Icons.format_size_rounded),
            onPressed: () => wrapWith(leftSide: '# ', rightSide: '', controller: controller),
          ),
          SizedBox(width: 20),
          ElevatedButton(
            
            child: Icon(Icons.format_bold),
            onPressed: () => wrapWith(
              leftSide: '**',
              rightSide: '**',
              controller: controller
            ),
          ),
          SizedBox(width: 20),
          ElevatedButton(
            
            child: Icon(Icons.list),
            onPressed: () => wrapWith(
              leftSide: '- ',
              rightSide: '',
              controller: controller
            ),
          ),
          SizedBox(width: 20),
          ElevatedButton(
            
            child: Icon(Icons.format_italic),
            onPressed: () => wrapWith(
              leftSide: '*',
              rightSide: '*', 
              controller: controller
            ),
          ),
          SizedBox(width: 20),
          ElevatedButton(
          
            child: Icon(Icons.code),
            onPressed: () => wrapWith(
              leftSide: '```',
              rightSide: '```', 
              controller: controller
            ),
          ),
          
        ],
      );
}
