class Category {
  final int id;
  final String name;
  final String? parent;

  Category({
    required this.id,
    required this.name,
    this.parent,
  });
}