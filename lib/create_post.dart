import 'package:flutter/material.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  String topic = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: TextButton(
            child: Text(
              '취소',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('새 글 작성'),
          actions: [
            TextButton(
              child: Text(
                '작성',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: PopupMenuButton<String>(
                    child: Text(topic.isEmpty ? '말머리를 선택하세요' : topic),
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
                ),
                Divider(),
                TextField(
                  decoration: InputDecoration(
                      labelText: '제목을 입력해주세요', border: InputBorder.none),
                ),
                Divider(),
                TextField(
                  decoration: InputDecoration(
                      labelText: '제목을 입력해주세요', border: InputBorder.none),
                  scrollPadding: EdgeInsets.all(8),
                  minLines: 1,
                  maxLines: null,
                )
                // TextField(
                //   minLines: 1,
                //   maxLines: null,
                // )
                // SingleChildScrollView(
                //   child: TextField(
                //     decoration: InputDecoration(
                //         labelText: '내용을 입력해주세요', border: InputBorder.none),
                //     maxLines: null,
                //   ),
                // ),
                // Divider(),
              ],
            ),
          ),
        ));
  }
}
