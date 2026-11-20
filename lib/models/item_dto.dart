/// Modelo DTO de elemento acoplado a JSON y SQLite.
class ItemDto {
  final String id;
  final String title;
  final String description;
  final String category;

  const ItemDto({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
  });

  factory ItemDto.fromMap(Map<String, dynamic> map) {
    return ItemDto(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
    };
  }
}
