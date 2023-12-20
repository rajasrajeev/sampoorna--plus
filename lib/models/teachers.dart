class Teachers {
  Token? token;
  List<PermittedBatches>? permittedBatches;
  String? userId;
  String? userType;
  int? iat;
  int? exp;

  Teachers(
      {this.token,
      this.permittedBatches,
      this.userId,
      this.userType,
      this.iat,
      this.exp});

  Teachers.fromJson(Map<String, dynamic> json) {
    token = json['token'] != null ? new Token.fromJson(json['token']) : null;
    if (json['permittedBatches'] != null) {
      permittedBatches = <PermittedBatches>[];
      json['permittedBatches'].forEach((v) {
        permittedBatches!.add(new PermittedBatches.fromJson(v));
      });
    }
    userId = json['user_id'];
    userType = json['user_type'];
    iat = json['iat'];
    exp = json['exp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.token != null) {
      data['token'] = this.token!.toJson();
    }
    if (this.permittedBatches != null) {
      data['permittedBatches'] =
          this.permittedBatches!.map((v) => v.toJson()).toList();
    }
    data['user_id'] = this.userId;
    data['user_type'] = this.userType;
    data['iat'] = this.iat;
    data['exp'] = this.exp;
    return data;
  }
}

class Token {
  String? schoolId;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  String? stateAdmin;
  String? revenueDistrictAdmin;
  String? eduDistrictAdmin;
  String? subDistrictAdmin;
  String? student;
  String? employee;
  String? admin;
  String? classteacher;
  String? userType;
  Null? revenueDistrictId;
  Null? eduDistrictId;
  Null? subDistrictId;
  String? userId;

  Token(
      {this.schoolId,
      this.username,
      this.firstName,
      this.lastName,
      this.email,
      this.stateAdmin,
      this.revenueDistrictAdmin,
      this.eduDistrictAdmin,
      this.subDistrictAdmin,
      this.student,
      this.employee,
      this.admin,
      this.classteacher,
      this.userType,
      this.revenueDistrictId,
      this.eduDistrictId,
      this.subDistrictId,
      this.userId});

  Token.fromJson(Map<String, dynamic> json) {
    schoolId = json['school_id'];
    username = json['username'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    stateAdmin = json['state_admin'];
    revenueDistrictAdmin = json['revenue_district_admin'];
    eduDistrictAdmin = json['edu_district_admin'];
    subDistrictAdmin = json['sub_district_admin'];
    student = json['student'];
    employee = json['employee'];
    admin = json['admin'];
    classteacher = json['classteacher'];
    userType = json['user_type'];
    revenueDistrictId = json['revenue_district_id'];
    eduDistrictId = json['edu_district_id'];
    subDistrictId = json['sub_district_id'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['school_id'] = this.schoolId;
    data['username'] = this.username;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['state_admin'] = this.stateAdmin;
    data['revenue_district_admin'] = this.revenueDistrictAdmin;
    data['edu_district_admin'] = this.eduDistrictAdmin;
    data['sub_district_admin'] = this.subDistrictAdmin;
    data['student'] = this.student;
    data['employee'] = this.employee;
    data['admin'] = this.admin;
    data['classteacher'] = this.classteacher;
    data['user_type'] = this.userType;
    data['revenue_district_id'] = this.revenueDistrictId;
    data['edu_district_id'] = this.eduDistrictId;
    data['sub_district_id'] = this.subDistrictId;
    data['user_id'] = this.userId;
    return data;
  }
}

class PermittedBatches {
  String? batchId;
  String? name;
  String? grade;

  PermittedBatches({this.batchId, this.name, this.grade});

  PermittedBatches.fromJson(Map<String, dynamic> json) {
    batchId = json['batch_id'];
    name = json['name'];
    grade = json['class'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['batch_id'] = this.batchId;
    data['name'] = this.name;
    data['class'] = this.grade;
    return data;
  }
}
