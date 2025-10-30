class Categories {
  final int id;
  final String name;

  Categories({required this.id, required this.name});

  factory Categories.fromMap(Map<String, dynamic> map) {
    return Categories(
      id: map['id'],
      name: map['name'],
    );
  }

}
