class Technician {
  final String id;
  final String name;
  final String mail;
  final String phone;

  const Technician(this.id, this.name, this.mail, this.phone);

  static Technician fromJsonMap(String id, Map<String, dynamic> map) {
    return Technician(
      id,
      map["name"],
      map["mail"],
      map["phone"],
    );
  }

  Map<String, dynamic> toJsonMap() {
    return {
      "name": name,
      "mail": mail,
      "phone": phone
    };
  }
}
