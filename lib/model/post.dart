enum LikeType { like, unlike, none }

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;
  int likes = 0;
  int views = 0;
  int replies = 10;
  bool isBookmark = false;
  LikeType likeType = LikeType.none;

  Post(
      {required this.userId,
      required this.id,
      required this.title,
      required this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}
