class Part {
  final String id;
  final String name;
  final String description;

  const Part(this.id, this.name, this.description);

  static Part fromJsonMap(String id, Map<String, dynamic> map) {
    return Part(
        id,
        map["name"],
        map["description"]
    );
  }

  Map<String, dynamic> toJsonMap() {
    return {
      "name": name,
      "description": description
    };
  }
}
