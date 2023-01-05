class UserModel {
  UserModel({
     this.name,
     this.age,
     this.email,
     this.createdDate,
     this.lastSignedInDate
  });

  UserModel.fromJson(Map<String, Object?> json)
      : this(
          name: json['name'] as String,
          age: json['age']! as int,
          email: json['email']! as String,
          createdDate: json['created_date']! as String,
          lastSignedInDate: json['signed_in_date']! as String,
          
        );

  final String? name;
  final int? age;
  final String? email;
  final String? createdDate;
  final String? lastSignedInDate;

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'age': age,
      'email': email,
      'created_date': createdDate,
      'signed_in_date': lastSignedInDate,
    };
  }
}