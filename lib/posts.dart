import 'package:flutter/material.dart';
import 'model/post.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'postDetail.dart';
import 'create_post.dart';

class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  late Future<List<Post>> posts;
  @override
  void initState() {
    super.initState();
    posts = fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: FutureBuilder<List<Post>>(
        future: posts,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
                child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      Post? post = snapshot.data?[index];
                      return SizedBox(
                          child: Column(
                        children: [
                          ListTile(
                            contentPadding:
                                EdgeInsets.only(left: 0.0, right: 0.0),
                            title: Text(snapshot.data?[index].title ?? ''),
                            subtitle: Text(
                                snapshot.data?[index].userId.toString() ?? ''),
                            trailing: const Icon(
                              Icons.post_add,
                              size: 60,
                            ),
                            style: ListTileStyle.list,
                            onTap: () {
                              if (post?.id != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PostDetail(
                                              postId: post!.id,
                                            )));
                              }
                            },
                          ),
                          Divider(),
                          Row(
                            children: [
                              const Icon(Icons.remove_red_eye),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                child: Text('123'),
                              ),
                              const Icon(Icons.comment),
                              const Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                child: Text('4'),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.arrow_upward)),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                                child: Text('345'),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.arrow_downward)),
                              const Spacer(),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.bookmark)),
                            ],
                          ),
                          const Divider(
                            thickness: 8,
                          )
                        ],
                      ));
                    }),
                onRefresh: () async {
                  setState(() {
                    posts = fetchPosts();
                  });
                });
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // 기본적으로 로딩 Spinner를 보여줍니다.
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CreatePost()));
        },
        child: const Icon(Icons.add),
      ),
    ));
  }
}

Future<List<Post>> fetchPosts() async {
  const url = 'https://jsonplaceholder.typicode.com/posts/';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    List<Post> posts = jsonDecode(response.body)
        .map<Post>((item) => Post.fromJson(item))
        .toList();
    return posts;
  } else {
    throw Exception('Failed to load post');
  }
}
