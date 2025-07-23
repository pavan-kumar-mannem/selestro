/// A simple model class for search items
class SearchItem {
  const SearchItem({
    required this.id,
    required this.name,
    this.description,
  });
  final String id;
  final String name;
  final String? description;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'SearchItem(id: $id, name: $name)';
}
