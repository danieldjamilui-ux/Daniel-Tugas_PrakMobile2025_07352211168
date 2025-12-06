class Book {
  final int id;
  final String title;
  final String author;
  final String description;
  final String? image;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    this.image,
  });

factory Book.fromJson(Map<String, dynamic> json) {
  String? img = json['image'];
  if (img != null && !img.startsWith('http')) {
    img = 'https://hmti-news.hppms-sabala.my.id/public_storage/$img';
  }

  return Book(
    id: json['id'],
    title: json['title'],
    author: json['author'],
    description: json['content'],
    image: img,
  );
}
}
