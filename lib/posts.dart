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

class _PostsState extends State<Posts>
    with SingleTickerProviderStateMixin, RestorationMixin {
  late Future<List<Post>> posts;
  String topic = '';
  String order = '';
  final RestorableInt tabIndex = RestorableInt(0);

  @override
  String get restorationId => 'tab_scrollable_demo';

  TabController? _tabController;
  @override
  void initState() {
    super.initState();
    posts = fetchPosts();
    _tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    _tabController!.addListener(() {
      // When the tab controller's value is updated, make sure to update the
      // tab index value, which is state restorable.
      setState(() {
        tabIndex.value = _tabController!.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController!.dispose();
    tabIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: ToggleButtons(renderBorder: false, children: [
          TextButton(
              onPressed: () {},
              child: Text(
                '게시판',
                style: TextStyle(fontSize: 20),
              )),
          TextButton(
              onPressed: () {},
              child: Text(
                '채팅',
                style: TextStyle(fontSize: 20),
              )),
        ], isSelected: [
          true,
          false
        ]),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Colors.blue,
              )),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications,
                color: Colors.blue,
              ))
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    PopupMenuButton<String>(
                      child: Row(
                        children: [
                          Text('구미동', style: TextStyle(color: Colors.black)),
                          Icon(
                            Icons.arrow_drop_down,
                            color: Colors.blue,
                          )
                        ],
                      ),
                      onSelected: (value) {
                        setState(() {
                          // topic = value;
                        });
                      },
                      itemBuilder: (context) => <PopupMenuItem<String>>[
                        PopupMenuItem<String>(
                          value: '서초동',
                          child: Text(
                            '서초동',
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: '다른 동네 찾아보기',
                          child: Text(
                            '다른 동네 찾아보기',
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    PopupMenuButton<String>(
                      child: Row(
                        children: [
                          Text(order.isEmpty ? '최신순' : order),
                          Icon(Icons.arrow_drop_down)
                        ],
                      ),
                      padding: EdgeInsets.zero,
                      onSelected: (value) {
                        setState(() {
                          topic = value;
                        });
                      },
                      itemBuilder: (context) => <PopupMenuItem<String>>[
                        PopupMenuItem<String>(
                          value: '인기순',
                          child: Text(
                            '인기순',
                          ),
                        ),
                      ],
                    ),
                    VerticalDivider(),
                    PopupMenuButton<String>(
                      child: Row(
                        children: [
                          Text(topic.isEmpty ? '전체 토픽' : topic),
                          Icon(Icons.arrow_drop_down)
                        ],
                      ),
                      padding: EdgeInsets.zero,
                      onSelected: (value) {
                        setState(() {
                          topic = value;
                        });
                      },
                      itemBuilder: (context) => <PopupMenuItem<String>>[
                        PopupMenuItem<String>(
                          value: '일상',
                          child: Text(
                            '일상',
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: '중고거래',
                          child: Text(
                            '중고거래',
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: '제보',
                          child: Text(
                            '제보',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: FutureBuilder<List<Post>>(
                future: posts,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return RefreshIndicator(
                        child: ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (BuildContext context, int index) {
                              Post? post = snapshot.data?[index];
                              if (post != null) {}
                              if (index == 0) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                      child: Placeholder(
                                        fallbackHeight: 100,
                                      ),
                                    ),
                                    PostCell(post: post)
                                  ],
                                );
                              }

                              return PostCell(post: post);
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
              )),
            ],
          ),
          Placeholder()
        ],
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

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    // TODO: implement restoreState
    registerForRestoration(tabIndex, 'tab_index');
  }
}

class PostCell extends StatefulWidget {
  const PostCell({
    super.key,
    required this.post,
  });

  final Post? post;

  @override
  State<PostCell> createState() => _PostCellState();
}

class _PostCellState extends State<PostCell> {
  @override
  Widget build(BuildContext context) {
    var replies = (widget.post?.replies ?? 0);
    var views = (widget.post?.views ?? 0);
    var likes = (widget.post?.likes ?? 0);
    var isBookmark = widget.post?.isBookmark ?? false;
    var likeType = widget.post?.likeType ?? LikeType.none;

    return SizedBox(
        child: Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
          title: Text(widget.post?.title ?? ''),
          subtitle: Row(
            children: [Text('길동')],
          ),
          style: ListTileStyle.list,
          onTap: () {
            if (widget.post?.id != null) {
              setState(() {
                widget.post?.views = (widget.post?.views ?? 0) + 1;
              });

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PostDetail(
                            postId: widget.post!.id,
                          )));
            }
          },
        ),
        Divider(),
        Row(
          children: [
            const Icon(Icons.remove_red_eye),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Text('$views'),
            ),
            const Icon(Icons.comment),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Text('$replies'),
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    switch (widget.post!.likeType) {
                      case LikeType.like:
                        widget.post?.likes = (widget.post?.likes ?? 0) - 1;
                        widget.post?.likeType = LikeType.none;
                        break;
                      case LikeType.unlike:
                        widget.post?.likes = (widget.post?.likes ?? 0) + 2;
                        widget.post?.likeType = LikeType.like;
                        break;
                      case LikeType.none:
                        widget.post?.likes = (widget.post?.likes ?? 0) + 1;
                        widget.post?.likeType = LikeType.like;
                        break;
                    }
                  });
                },
                icon: Icon(
                  Icons.arrow_upward,
                  color: likeType == LikeType.like
                      ? Colors.redAccent
                      : Colors.black38,
                )),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Text('$likes'),
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    switch (widget.post!.likeType) {
                      case LikeType.unlike:
                        widget.post?.likes = (widget.post?.likes ?? 0) + 1;
                        widget.post?.likeType = LikeType.none;
                        break;
                      case LikeType.like:
                        widget.post?.likes = (widget.post?.likes ?? 0) - 2;
                        widget.post?.likeType = LikeType.unlike;
                        break;
                      case LikeType.none:
                        widget.post?.likes = (widget.post?.likes ?? 0) - 1;
                        widget.post?.likeType = LikeType.unlike;
                        break;
                    }
                  });
                },
                icon: Icon(
                  Icons.arrow_downward,
                  color: likeType == LikeType.unlike
                      ? Colors.blueAccent
                      : Colors.black38,
                )),
            const Spacer(),
            IconButton(
                onPressed: () {
                  setState(() {
                    widget.post?.isBookmark =
                        !(widget.post?.isBookmark ?? false);
                  });
                },
                icon: Icon(Icons.bookmark,
                    color: isBookmark ? Colors.blueAccent : Colors.black38)),
          ],
        ),
        const Divider(
          thickness: 8,
        )
      ],
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
