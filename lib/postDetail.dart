import 'package:flutter/material.dart';
import 'model/post.dart';
import 'model/comment.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PostDetail extends StatefulWidget {
  // const PostDetaiil({super.key});
  final int postId;
  const PostDetail({Key? key, required this.postId}) : super(key: key);

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  late Future<Post> post;
  late Future<List<Comment>> comments;

  @override
  void initState() {
    super.initState();

    post = fetchPost();
    comments = fetchComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('동네 게시판'),
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.menu))],
        ),
        body: FutureBuilder<Post>(
            future: post,
            builder: (context, snapShot) {
              Post? post = snapShot.data;
              var postView = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        '말머리',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.blueAccent),
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.bookmark,
                            color: Colors.blue,
                          )),
                    ],
                  ),
                  Text(
                    '${post?.title}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                    // textAlign: TextAlign.left,
                  ),
                  Row(
                    children: [
                      Text('${post?.userId.toString()}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      const Text(' 2023. 1. 12'),
                      const Spacer(),
                      const Icon(Icons.remove_red_eye),
                      const Text('123')
                    ],
                  ),
                  const Divider(),
                  Text('${post?.body}'),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: [
                      FloatingActionButton.extended(
                          icon: const Icon(Icons.comment),
                          onPressed: () {},
                          label: const Text('123')),
                      const Spacer(),
                      FloatingActionButton.extended(
                          icon: const Icon(Icons.arrow_upward),
                          onPressed: () {},
                          label: const Text('100')),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: FloatingActionButton.extended(
                            icon: const Icon(Icons.arrow_downward),
                            onPressed: () {},
                            label: const Text('1')),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                    child: Placeholder(
                      fallbackHeight: 100,
                    ),
                  )
                ],
              );
              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder<List<Comment>>(
                    future: comments,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            Expanded(
                                child: ListView.builder(
                                    padding: const EdgeInsets.all(8),
                                    itemCount: (snapshot.data?.length ?? 0),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      Comment? comment = snapshot.data?[index];
                                      if (comment != null) {}
                                      if (index == 0) {
                                        return Column(
                                          children: [
                                            postView,
                                            _commentCell(comment, context)
                                          ],
                                        );
                                      }

                                      return _commentCell(comment, context);
                                    })),
                            const TextField(
                              decoration:
                                  InputDecoration(label: Text('댓글을 입력해주세요')),
                              minLines: 1,
                              maxLines: 4,
                            ),
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.photo)),
                                const Spacer(),
                                OutlinedButton(
                                    onPressed: () {}, child: const Text('남기기'))
                              ],
                            )
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }

                      // 기본적으로 로딩 Spinner를 보여줍니다.
                      return const Center(child: CircularProgressIndicator());
                    },
                  ));
            }));
  }

  SizedBox _commentCell(Comment? post, BuildContext context) {
    if (post == null) {
      return const SizedBox(
        height: 0,
      );
    }
    return SizedBox(
        child: Column(
      children: [
        ListTile(
          title: Text(post.name),
          subtitle: Text(post.body),
          trailing: const Icon(Icons.post_add),
          style: ListTileStyle.list,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PostDetail(
                          postId: post.id,
                        )));
          },
        ),
        const Divider(),
        Row(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_upward)),
            const Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Text('345'),
            ),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.arrow_downward)),
          ],
        ),
        const Divider(
          thickness: 10,
        )
      ],
    ));
  }

  Future<Post> fetchPost() async {
    var url = 'https://jsonplaceholder.typicode.com/posts/${widget.postId}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      return Post.fromJson(jsonBody);
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<List<Comment>> fetchComments() async {
    var url =
        'https://jsonplaceholder.typicode.com/comments?postId=${widget.postId}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<Comment> comments = jsonDecode(response.body)
          .map<Comment>((item) => Comment.fromJson(item))
          .toList();
      return comments;
    } else {
      throw Exception('Failed to load post');
    }
  }
}
