
class Category {
  int id;
  String categoryName;

  Category(this.id, this.categoryName);

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
  }
}