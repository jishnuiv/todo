class  Model {
  Model({
    this.id,

    this.Tododata,
    });

  Model.fromJson(dynamic json) {
    id = json['ID'];

    Tododata = json['tododata'];

  }
  String? id;

  String? Tododata;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ID'] = id;

    map['tododata'] = Tododata;

    return map;
  }

}