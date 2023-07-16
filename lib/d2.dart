import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class D2 extends StatefulWidget {
  static const String id = "D2";
  @override
  _D2State createState() => _D2State();
}

class _D2State extends State<D2> {
  final storyController = StoryController();

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoryView(
        storyItems: [
          StoryItem.text(
              title: "WOW !!! i built my first status story",
              textStyle: TextStyle(fontSize: 25),
              backgroundColor: Colors.green),
          StoryItem.pageImage(
            caption: "Simply beautiful😘😘😘",
            controller: storyController,
            url:
                "https://i.pinimg.com/originals/f6/eb/53/f6eb535411056b553dfdec1665387c0c.jpg",
          ),
          StoryItem.pageImage(
            caption: "Simply beautiful😘😘😘",
            controller: storyController,
            url:
                "https://i.pinimg.com/originals/f6/eb/53/f6eb535411056b553dfdec1665387c0c.jpg",
          ),
          StoryItem.pageImage(
            caption: "Simply beautiful😘😘😘",
            controller: storyController,
            url:
                "https://i.pinimg.com/originals/f6/eb/53/f6eb535411056b553dfdec1665387c0c.jpg",
          ),
          StoryItem.pageImage(
            caption: "Simply beautiful😘😘😘",
            controller: storyController,
            url:
                "https://i.pinimg.com/originals/f6/eb/53/f6eb535411056b553dfdec1665387c0c.jpg",
          ),
        ],
        onStoryShow: (s) {
          //print("Showing a story");
        },
        onComplete: () {
          //print("Completed a cycle");
        },
        progressPosition: ProgressPosition.top,
        repeat: true,
        controller: storyController,
      ),
    );
  }
}
