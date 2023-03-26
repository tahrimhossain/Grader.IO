class Classroom {
  int? classroomId;
  String? name;
  String? description;
  String? code;
  int? createdBy;

  Classroom(
      {this.classroomId,
        this.name,
        this.description,
        this.code,
        this.createdBy});

  Classroom.fromJson(Map<String, dynamic> json) {
    classroomId = json['classroom_id'];
    name = json['name'];
    description = json['description'];
    code = json['code'];
    createdBy = json['created_by'];
  }
}
