import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grader_io/Exceptions/token_expired.dart';
import 'package:grader_io/Exceptions/token_not_found.dart';
import 'package:grader_io/Models/assignment_detail.dart';
import 'package:grader_io/Models/created_classrooms.dart';
import 'package:grader_io/Models/submission_detail.dart';
import 'package:grader_io/Models/summary_of_assigned_submissions_for_review.dart';
import 'package:grader_io/Models/summary_of_assignments.dart';
import 'package:grader_io/Models/summary_of_submission_reviews.dart';
import 'package:grader_io/Models/summary_of_submissions.dart';
import 'package:grader_io/Models/user_info.dart';
import 'package:grader_io/Services/secure_storage_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Models/grade.dart';
import '../Models/joined_classrooms.dart';
import '../Models/review_detail.dart';

final apiProvider = Provider((ref) {
  return Api(ref: ref);
});

class Api{

  Ref ref;

  //String baseUrl = 'http://127.0.0.1:5000';
  String baseUrl = 'https://grader-io.onrender.com';

  Api({required this.ref});

  Future<String> register(String email, String name, String password) async {
    http.Response response = await http.post(Uri.parse('$baseUrl/register'),headers: {"Access-Control-Allow-Origin": "*","Content-type": "application/json","Accept": "application/json"},body: jsonEncode({"email":email,"name":name,"password":password})).timeout(const Duration(seconds: 20));
    Map<String,dynamic> jsonData = json.decode(response.body);
    if(response.statusCode == 200){
      return jsonData["access_token"];
    }else{
      throw Exception(jsonData["message"]);
    }
  }

  Future<String> logIn(String email, String password) async {
    http.Response response = await http.post(Uri.parse('$baseUrl/login'),headers: {"Content-type": "application/json","Accept": "application/json"},body: jsonEncode({"email":email,"password":password})).timeout(const Duration(seconds: 20));
    Map<String,dynamic> jsonData = json.decode(response.body);
    if(response.statusCode == 200){
      return jsonData["access_token"];
    }else{
      throw Exception(jsonData["message"]);
    }
  }

  Future<UserInfo> getUserInfo()async{
    String accessToken = await ref.read(secureStorageServiceProvider).getAccessToken();
    http.Response response = await http.get(Uri.parse('$baseUrl/userinfo'),headers: {"Content-type": "application/json","Accept": "application/json","Authorization":accessToken}).timeout(const Duration(seconds: 20));
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
    http.Response response = await http.get(Uri.parse('$baseUrl/createdclassrooms'),headers: {"Content-type": "application/json","Accept": "application/json","Authorization":accessToken}).timeout(const Duration(seconds: 20));
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
    http.Response response = await http.get(Uri.parse('$baseUrl/joinedclassrooms'),headers: {"Content-type": "application/json","Accept": "application/json","Authorization":accessToken}).timeout(const Duration(seconds: 20));
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

  Future<void> createClassroom(String name, String description) async {
    String accessToken = await ref.read(secureStorageServiceProvider).getAccessToken();
    http.Response response = await http.post(Uri.parse('$baseUrl/createclassroom'),headers: {"Content-type": "application/json","Accept": "application/json","Authorization":accessToken},body: jsonEncode({"name":name,"description":description})).timeout(const Duration(seconds: 20));
    Map<String,dynamic> jsonData = json.decode(response.body);
    if(response.statusCode == 200){
      return;
    }else{
      throw Exception(jsonData["message"]);
    }
  }

  Future<SummaryOfAssignments> getSummaryOfAssignments(String classroomCode)async{
    String accessToken = await ref.read(secureStorageServiceProvider).getAccessToken();
    http.Response response = await http.get(Uri.parse('$baseUrl/summaryofassignments/$classroomCode'),headers: {"Content-type": "application/json","Accept": "application/json","Authorization":accessToken}).timeout(const Duration(seconds: 20));
    Map<String,dynamic> jsonData = json.decode(response.body);
    if(response.statusCode == 200){
      return SummaryOfAssignments.fromJson(jsonData);
    }else if(response.statusCode == 401){
      if(jsonData["message"] == "Token expired"){
        throw TokenExpiredException(message: "session expired");
      }else if(jsonData["message"] == "Unauthorized action"){
        throw Exception(jsonData["message"]);
      }else{
        throw TokenNotFoundException(message: "token not found");
      }
    }else{
      throw Exception(jsonData["message"]);
    }
  }

  Future<void> createAssignment(String code, String title,String description, String instructions, int maxScore, int numberOfReviewersPerSubmission, String submissionDeadline, String reviewDeadline) async {
    String accessToken = await ref.read(secureStorageServiceProvider).getAccessToken();
    http.Response response = await http.post(Uri.parse('$baseUrl/createassignment'),headers: {"Content-type": "application/json","Accept": "application/json","Authorization":accessToken},body: jsonEncode({"code":code,"title":title,"description":description,"instructions":instructions,"max_score":maxScore,"number_of_reviewers_per_submission":numberOfReviewersPerSubmission,"submission_deadline":submissionDeadline,"review_deadline":reviewDeadline})).timeout(const Duration(seconds: 20));
    Map<String,dynamic> jsonData = json.decode(response.body);
    if(response.statusCode == 200){
      return;
    }else{
      throw Exception(jsonData["message"]);
    }
  }

  Future<SummaryOfSubmissions> getSummaryOfSubmissions(int assignmentId) async{
    String accessToken = await ref.read(secureStorageServiceProvider).getAccessToken();
    http.Response response = await http.get(Uri.parse('$baseUrl/summaryofsubmissions/$assignmentId'),headers: {"Content-type": "application/json","Accept": "application/json","Authorization":accessToken}).timeout(const Duration(seconds: 20));
    Map<String,dynamic> jsonData = json.decode(response.body);
    if(response.statusCode == 200){
      return SummaryOfSubmissions.fromJson(jsonData);
    }else if(response.statusCode == 401){
      if(jsonData["message"] == "Token expired"){
        throw TokenExpiredException(message: "session expired");
      }else if(jsonData["message"] == "Unauthorized action"){
        throw Exception(jsonData["message"]);
      }else{
        throw TokenNotFoundException(message: "token not found");
      }
    }else{
      throw Exception(jsonData["message"]);
    }
  }

  Future<void> publishScore(int assignmentId)async{
    String accessToken = await ref.read(secureStorageServiceProvider).getAccessToken();
    http.Response response = await http.post(Uri.parse('$baseUrl/publishscore'),headers: {"Content-type": "application/json","Accept": "application/json","Authorization":accessToken},body: jsonEncode({"assignment_id":assignmentId})).timeout(const Duration(seconds: 20));
    Map<String,dynamic> jsonData = json.decode(response.body);
    if(response.statusCode == 200){
      return;
    }else{
      throw Exception(jsonData["message"]);
    }
  }

  Future<void> updateFinalScore(int submissionId, int finalScore)async{
    String accessToken = await ref.read(secureStorageServiceProvider).getAccessToken();
    http.Response response = await http.post(Uri.parse('$baseUrl/updatefinalscore'),headers: {"Content-type": "application/json","Accept": "application/json","Authorization":accessToken},body: jsonEncode({"submission_id":submissionId,"final_score":finalScore})).timeout(const Duration(seconds: 20));
    Map<String,dynamic> jsonData = json.decode(response.body);
    if(response.statusCode == 200){
      return;
    }else{
      throw Exception(jsonData["message"]);
    }
  }

  Future<AssignmentDetail> getAssignmentDetail(int assignmentId)async{

    String accessToken = await ref.read(secureStorageServiceProvider).getAccessToken();
    http.Response response = await http.get(Uri.parse('$baseUrl/assignmentdetail/$assignmentId'),headers: {"Content-type": "application/json","Accept": "application/json","Authorization":accessToken}).timeout(const Duration(seconds: 20));
    Map<String,dynamic> jsonData = json.decode(response.body);
    if(response.statusCode == 200){
      return AssignmentDetail.fromJson(jsonData);
    }else if(response.statusCode == 401){
      if(jsonData["message"] == "Token expired"){
        throw TokenExpiredException(message: "session expired");
      }else if(jsonData["message"] == "Unauthorized action"){
        throw Exception(jsonData["message"]);
      }else{
        throw TokenNotFoundException(message: "token not found");
      }
    }else{
      throw Exception(jsonData["message"]);
    }
  }


  Future<SubmissionDetail> getSubmissionDetail(int submissionId)async{

    String accessToken = await ref.read(secureStorageServiceProvider).getAccessToken();
    http.Response response = await http.get(Uri.parse('$baseUrl/submissiondetail/$submissionId'),headers: {"Content-type": "application/json","Accept": "application/json","Authorization":accessToken}).timeout(const Duration(seconds: 20));
    Map<String,dynamic> jsonData = json.decode(response.body);
    if(response.statusCode == 200){
      return SubmissionDetail.fromJson(jsonData);
    }else if(response.statusCode == 401){
      if(jsonData["message"] == "Token expired"){
        throw TokenExpiredException(message: "session expired");
      }else if(jsonData["message"] == "Unauthorized action"){
        throw Exception(jsonData["message"]);
      }else{
        throw TokenNotFoundException(message: "token not found");
      }
    }else{
      throw Exception(jsonData["message"]);
    }
  }


  Future<SummaryOfSubmissionReviews> getSummaryOfSubmissionReviews(int submissionId)async{

    String accessToken = await ref.read(secureStorageServiceProvider).getAccessToken();
    http.Response response = await http.get(Uri.parse('$baseUrl/summaryofsubmissionreviews/$submissionId'),headers: {"Content-type": "application/json","Accept": "application/json","Authorization":accessToken}).timeout(const Duration(seconds: 20));
    Map<String,dynamic> jsonData = json.decode(response.body);
    if(response.statusCode == 200){
      return SummaryOfSubmissionReviews.fromJson(jsonData);
    }else if(response.statusCode == 401){
      if(jsonData["message"] == "Token expired"){
        throw TokenExpiredException(message: "session expired");
      }else if(jsonData["message"] == "Unauthorized action"){
        throw Exception(jsonData["message"]);
      }else{
        throw TokenNotFoundException(message: "token not found");
      }
    }else{
      throw Exception(jsonData["message"]);
    }
  }


  Future<ReviewDetail> getReviewDetail(int reviewId)async{

    String accessToken = await ref.read(secureStorageServiceProvider).getAccessToken();
    http.Response response = await http.get(Uri.parse('$baseUrl/reviewdetail/$reviewId'),headers: {"Content-type": "application/json","Accept": "application/json","Authorization":accessToken}).timeout(const Duration(seconds: 20));
    Map<String,dynamic> jsonData = json.decode(response.body);
    if(response.statusCode == 200){
      return ReviewDetail.fromJson(jsonData);
    }else if(response.statusCode == 401){
      if(jsonData["message"] == "Token expired"){
        throw TokenExpiredException(message: "session expired");
      }else if(jsonData["message"] == "Unauthorized action"){
        throw Exception(jsonData["message"]);
      }else{
        throw TokenNotFoundException(message: "token not found");
      }
    }else{
      throw Exception(jsonData["message"]);
    }
  }


  Future<Grade> getGrade(int submissionId)async{

    String accessToken = await ref.read(secureStorageServiceProvider).getAccessToken();
    http.Response response = await http.get(Uri.parse('$baseUrl/submissiongrade/$submissionId'),headers: {"Content-type": "application/json","Accept": "application/json","Authorization":accessToken}).timeout(const Duration(seconds: 20));
    Map<String,dynamic> jsonData = json.decode(response.body);
    if(response.statusCode == 200){
      return Grade.fromJson(jsonData);
    }else if(response.statusCode == 401){
      if(jsonData["message"] == "Token expired"){
        throw TokenExpiredException(message: "session expired");
      }else if(jsonData["message"] == "Unauthorized action"){
        throw Exception(jsonData["message"]);
      }else{
        throw TokenNotFoundException(message: "token not found");
      }
    }else{
      throw Exception(jsonData["message"]);
    }
  }


  Future<SummaryOfAssignedSubmissionsForReview> getSummaryOfAssignedSubmissionsForReview(int assignmentId)async{
    String accessToken = await ref.read(secureStorageServiceProvider).getAccessToken();
    http.Response response = await http.get(Uri.parse('$baseUrl/summaryofassignedsubmissionsforreview/$assignmentId'),headers: {"Content-type": "application/json","Accept": "application/json","Authorization":accessToken}).timeout(const Duration(seconds: 20));
    Map<String,dynamic> jsonData = json.decode(response.body);
    if(response.statusCode == 200){
      return SummaryOfAssignedSubmissionsForReview.fromJson(jsonData);
    }else if(response.statusCode == 401){
      if(jsonData["message"] == "Token expired"){
        throw TokenExpiredException(message: "session expired");
      }else if(jsonData["message"] == "Unauthorized action"){
        throw Exception(jsonData["message"]);
      }else{
        throw TokenNotFoundException(message: "token not found");
      }
    }else{
      throw Exception(jsonData["message"]);
    }
  }

  Future<SummaryOfSubmissionReviews> getSummaryOfReviewsGottenForCreatedSubmission(int assignmentId)async{
    String accessToken = await ref.read(secureStorageServiceProvider).getAccessToken();
    http.Response response = await http.get(Uri.parse('$baseUrl/summaryofreviewsgottenforcreatedsubmission/$assignmentId'),headers: {"Content-type": "application/json","Accept": "application/json","Authorization":accessToken}).timeout(const Duration(seconds: 20));
    Map<String,dynamic> jsonData = json.decode(response.body);
    if(response.statusCode == 200){
      return SummaryOfSubmissionReviews.fromJson(jsonData);
    }else if(response.statusCode == 401){
      if(jsonData["message"] == "Token expired"){
        throw TokenExpiredException(message: "session expired");
      }else if(jsonData["message"] == "Unauthorized action"){
        throw Exception(jsonData["message"]);
      }else{
        throw TokenNotFoundException(message: "token not found");
      }
    }else{
      throw Exception(jsonData["message"]);
    }
  }

  Future<Grade> getAssignmentGrade(int assignmentId) async{
    String accessToken = await ref.read(secureStorageServiceProvider).getAccessToken();
    http.Response response = await http.get(Uri.parse('$baseUrl/assignmentgrade/$assignmentId'),headers: {"Content-type": "application/json","Accept": "application/json","Authorization":accessToken}).timeout(const Duration(seconds: 20));
    Map<String,dynamic> jsonData = json.decode(response.body);
    if(response.statusCode == 200){
      return Grade.fromJson(jsonData);
    }else if(response.statusCode == 401){
      if(jsonData["message"] == "Token expired"){
        throw TokenExpiredException(message: "session expired");
      }else if(jsonData["message"] == "Unauthorized action"){
        throw Exception(jsonData["message"]);
      }else{
        throw TokenNotFoundException(message: "token not found");
      }
    }else{
      throw Exception(jsonData["message"]);
    }
  }

}