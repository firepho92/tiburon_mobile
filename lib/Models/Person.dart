class Person {
  int personal_id;
  String personal_name;
  String alias;
  String password;
  int administrator;

  Person.empty();

  Person.persistent({
    this.personal_id,
    this.personal_name,
    this.alias
  });

  Person({
    this.personal_id,
    this.personal_name,
    this.alias,
    this.password,
    this.administrator
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      personal_id: json['personal_id'],
      personal_name: json['personal_name'],
      alias: json['alias'],
      password: json['password'],
      administrator: json['administrator'],
    );
  }
}