class PermittedBatches {
  List<PermittedBatch>? permittedBatches;

  PermittedBatches({this.permittedBatches});

  PermittedBatches.fromJson(Map<String, dynamic> json) {
    if (json['permittedBatches'] != null) {
      permittedBatches = <PermittedBatch>[];
      json['permittedBatches'].forEach((v) {
        permittedBatches!.add(PermittedBatch.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (permittedBatches != null) {
      data['permittedBatches'] =
          permittedBatches!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PermittedBatch {
  String? batchId;
  String? name;
  String? grade;

  PermittedBatch({this.batchId, this.name, this.grade});

  PermittedBatch.fromJson(Map<String, dynamic> json) {
    batchId = json['batch_id'];
    name = json['name'];
    grade = json['class'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['batch_id'] = batchId;
    data['name'] = name;
    data['class'] = grade;
    return data;
  }
}
