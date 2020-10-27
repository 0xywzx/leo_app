class Article {
  int id;
  String title;
  String articleUrl;
  String ogImageUrl;
  String articleNote;
  bool isRead;
  int categoryId;
  String createdAt;

  Article(this.id, this.title, this.articleUrl, this.ogImageUrl, this.articleNote, this.isRead, this.categoryId, this.createdAt);

  Article.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    articleUrl = json['article_url'];
    ogImageUrl = json['og_image_url'];
    articleNote = json['article_note'];
    isRead = json['is_read'];
    categoryId = json['category_id'];
    createdAt = json['created_at'];
  }
}