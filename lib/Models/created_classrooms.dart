import 'classroom.dart';

class CreatedClassrooms {
  List<Classroom>? classrooms;

  CreatedClassrooms({this.classrooms});

  CreatedClassrooms.fromJson(Map<String, dynamic> json) {
    if (json['classrooms'] != null) {
      classrooms = <Classroom>[];
      json['classrooms'].forEach((v) {
        classrooms!.add(Classroom.fromJson(v));
      });
    }
  }

}