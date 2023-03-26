import 'classroom.dart';

class JoinedClassrooms {
  List<Classroom>? classrooms;

  JoinedClassrooms({this.classrooms});

  JoinedClassrooms.fromJson(Map<String, dynamic> json) {
    if (json['classrooms'] != null) {
      classrooms = <Classroom>[];
      json['classrooms'].forEach((v) {
        classrooms!.add(Classroom.fromJson(v));
      });
    }
  }

}