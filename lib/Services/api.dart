import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grader_io/Exceptions/token_expired.dart';
import 'package:grader_io/Exceptions/token_not_found.dart';
import 'package:grader_io/Models/assignment_detail.dart';
import 'package:grader_io/Models/created_classrooms.dart';
import 'package:grader_io/Models/summary_of_assignments.dart';
import 'package:grader_io/Models/summary_of_submissions.dart';
import 'package:grader_io/Models/user_info.dart';
import 'package:grader_io/Services/secure_storage_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Models/joined_classrooms.dart';

final apiProvider = Provider((ref) {
  return Api(ref: ref);
});

class Api{

  Ref ref;
  String baseUrl = 'http://127.0.0.1:5000';

  Api({required this.ref});

  Future<String> register(String email, String name, String password) async {
    http.Response response = await http.post(Uri.parse('$baseUrl/register'),headers: {"Access-Control-Allow-Origin": "*","Content-type": "application/json","Accept": "application/json"},body: jsonEncode({"email":email,"name":name,"password":password})).timeout(const Duration(seconds: 7));
    Map<String,dynamic> jsonData = json.decode(response.body);
    if(response.statusCode == 200){
      return jsonData["access_token"];
    }else{
      throw Exception(jsonData["message"]);
    }
  }

  Future<String> logIn(String email, String password) async {
    http.Response response = await http.post(Uri.parse('$baseUrl/login'),headers: {"Content-type": "application/json","Accept": "application/json"},body: jsonEncode({"email":email,"password":password})).timeout(const Duration(seconds: 7));
    Map<String,dynamic> jsonData = json.decode(response.body);
    if(response.statusCode == 200){
      return jsonData["access_token"];
    }else{
      throw Exception(jsonData["message"]);
    }
  }

  Future<UserInfo> getUserInfo()async{
    String accessToken = await ref.read(secureStorageServiceProvider).getAccessToken();
    http.Response response = await http.get(Uri.parse('$baseUrl/userinfo'),headers: {"Content-type": "application/json","Accept": "application/json","Authorization":accessToken}).timeout(const Duration(seconds: 7));
    Map<String,dynamic> jsonData = json.decode(response.body);
    if(response.statusCode == 200){
      return UserInfo.fromJson(jsonData);
    }else if(response.statusCode == 401){
      if(jsonData["message"] == "Token expired"){
        throw TokenExpiredException(message: "session expired");
      }else{
        throw TokenNotFoundException(message: "token not found");
      }
    }else{
      throw Exception(jsonData["message"]);
    }

  }

  Future<CreatedClassrooms> getCreatedClassrooms()async{
    String accessToken = await ref.read(secureStorageServiceProvider).getAccessToken();
    http.Response response = await http.get(Uri.parse('$baseUrl/createdclassrooms'),headers: {"Content-type": "application/json","Accept": "application/json","Authorization":accessToken}).timeout(const Duration(seconds: 7));
    Map<String,dynamic> jsonData = json.decode(response.body);
    if(response.statusCode == 200){
      return CreatedClassrooms.fromJson(jsonData);
    }else if(response.statusCode == 401){
      if(jsonData["message"] == "Token expired"){
        throw TokenExpiredException(message: "session expired");
      }else{
        throw TokenNotFoundException(message: "token not found");
      }
    }
    else{
      throw Exception(jsonData["message"]);
    }

  }

  Future<JoinedClassrooms> getJoinedClassrooms()async{
    String accessToken = await ref.read(secureStorageServiceProvider).getAccessToken();
    http.Response response = await http.get(Uri.parse('$baseUrl/joinedclassrooms'),headers: {"Content-type": "application/json","Accept": "application/json","Authorization":accessToken}).timeout(const Duration(seconds: 7));
    Map<String,dynamic> jsonData = json.decode(response.body);
    if(response.statusCode == 200){
      return JoinedClassrooms.fromJson(jsonData);
    }else if(response.statusCode == 401){
      if(jsonData["message"] == "Token expired"){
        throw TokenExpiredException(message: "session expired");
      }else{
        throw TokenNotFoundException(message: "token not found");
      }
    }else{
      throw Exception(jsonData["message"]);
    }
  }

  Future<SummaryOfAssignments> getSummaryOfAssignments(String classroomCode)async{
    String accessToken = await ref.read(secureStorageServiceProvider).getAccessToken();
    http.Response response = await http.get(Uri.parse('$baseUrl/summaryofassignments/$classroomCode'),headers: {"Content-type": "application/json","Accept": "application/json","Authorization":accessToken}).timeout(const Duration(seconds: 7));
    Map<String,dynamic> jsonData = json.decode(response.body);
    if(response.statusCode == 200){
      return SummaryOfAssignments.fromJson(jsonData);
    }else if(response.statusCode == 401){
      if(jsonData["message"] == "Token expired"){
        throw TokenExpiredException(message: "session expired");
      }else{
        throw TokenNotFoundException(message: "token not found");
      }
    }else{
      throw Exception(jsonData["message"]);
    }
  }

  Future<SummaryOfSubmissions> getSummaryOfSubmissions(int assignmentId) async{
    String accessToken = await ref.read(secureStorageServiceProvider).getAccessToken();
    http.Response response = await http.get(Uri.parse('$baseUrl/summaryofsubmissions/$assignmentId'),headers: {"Content-type": "application/json","Accept": "application/json","Authorization":accessToken}).timeout(const Duration(seconds: 7));
    Map<String,dynamic> jsonData = json.decode(response.body);
    if(response.statusCode == 200){
      return SummaryOfSubmissions.fromJson(jsonData);
    }else if(response.statusCode == 401){
      if(jsonData["message"] == "Token expired"){
        throw TokenExpiredException(message: "session expired");
      }else{
        throw TokenNotFoundException(message: "token not found");
      }
    }else{
      throw Exception(jsonData["message"]);
    }
  }

  Future<AssignmentDetail> getAssignmentDetail(int assignmentId)async{

    String accessToken = await ref.read(secureStorageServiceProvider).getAccessToken();
    http.Response response = await http.get(Uri.parse('$baseUrl/assignmentdetail/$assignmentId'),headers: {"Content-type": "application/json","Accept": "application/json","Authorization":accessToken}).timeout(const Duration(seconds: 7));
    Map<String,dynamic> jsonData = json.decode(response.body);
    if(response.statusCode == 200){
      return AssignmentDetail.fromJson(jsonData);
    }else if(response.statusCode == 401){
      if(jsonData["message"] == "Token expired"){
        throw TokenExpiredException(message: "session expired");
      }else{
        throw TokenNotFoundException(message: "token not found");
      }
    }else{
      throw Exception(jsonData["message"]);
    }
  }



}