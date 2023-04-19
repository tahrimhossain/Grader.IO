// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:flutter/material.dart';

class JoinClassroom extends StatefulWidget {
  const JoinClassroom({super.key});

  @override
  State<JoinClassroom> createState() => _JoinClassroomState();
}


class _JoinClassroomState extends State<JoinClassroom> {

  final _formKey = GlobalKey<FormState>();
  String? _classroomCode = "";
  

  @override
  Widget build(BuildContext context) {
    
    double width = MediaQuery. of(context). size. width;
    double height = MediaQuery. of(context). size. height;

    return Scaffold (
      body: SingleChildScrollView(
        child: Column (
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
                        height: 300, 
                        width: min(500, width), 
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Column(
                              children: [
                                SizedBox(height: 50,),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          SizedBox(width: constraints.maxWidth * 0.3, child: Text("Classroom code : "),),                              
                                          SizedBox(width: 15,),
                                          SizedBox(
                                            width: constraints.maxWidth * 0.6,
                                            child: TextFormField(
                                              minLines: 1,
                                              maxLines: 3,
                                            
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(width: 50),
                                                ),
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: Colors.blueGrey),
                                                ),
                                                
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Enter a valid code';
                                                }
                                                return null;
                                              },
                                              onSaved: (value) {
                                                _classroomCode = value;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 20,),
                                      
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        height: 40,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                            ),
                            onPressed: () { if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                              }},
                            
                            child: Text(
                              'Join',
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
    );

    
  }

}
