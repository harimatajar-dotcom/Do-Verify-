/// Category enum representing template categories
enum Category {
  all('all', 'All', 'All Templates'),
  work('work', 'Work', 'Work Templates'),
  personal('personal', 'Personal', 'Personal Templates'),
  dev('dev', 'Dev', 'Development Templates'),
  health('health', 'Health', 'Health & Wellness');

  final String id;
  final String name;
  final String fullName;

  const Category(this.id, this.name, this.fullName);

  /// Get category from string id
  static Category fromId(String id) {
    return Category.values.firstWhere(
      (category) => category.id == id,
      orElse: () => Category.all,
    );
  }

  /// Get all categories except 'all'
  static List<Category> get filterCategories =>
      Category.values.where((c) => c != Category.all).toList();
}
