class ResultRange {
  final int? id;
  final int categoryId;
  final String rangeText;
  final String type;
  final String description;

  ResultRange({
    this.id,
    required this.categoryId,
    required this.rangeText,
    required this.type,
    required this.description,
  });

  factory ResultRange.fromJson(Map<String, dynamic> json) {
    return ResultRange(
      id: json['id'],
      categoryId: json['category_id'],
      rangeText: json['range_text'],
      type: json['type'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category_id': categoryId,
      'range_text': rangeText,
      'type': type,
      'description': description,
    };
  }
}
