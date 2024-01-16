class UserModel {
  UserModel(this.data);

  String data;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
    };
  }
}
