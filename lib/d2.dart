// // //
// // // {
// // // "left": ["Day","Weak","First"],
// // // "right": ["Last","Strong","Night"],
// // // "answers": {"Day":"Night","Weak":"Strong","First":"Last"},
// // // }
// // //
// // // {
// // // "left": ["Fast","Big","Heavy"],
// // // "right": ["Slow","Light","Small"],
// // // "answers": {"Fast":"Slow","Big":"Small","Heavy":"Light"},
// // // }
// // //
// // // {
// // // "left": ["Open","Rich","Full"],
// // // "right": ["Empty","Close","Poor"],
// // // "answers": {"Open":"Close","Rich":"Poor","Full":"Empty"},
// // // }
// // //
// //
// // import 'package:flutter/material.dart';
// // import 'package:temple_adventures/d1.dart';
// //
// // class W2 extends StatelessWidget {
// //   static const String id = "W2";
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: SafeArea(
// //         child: Column(
// //           children: [
// //             W1(),
// //             W1(),
// //             W1(),
// //             W1(),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// // import 'dart:io';
// //
// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// //
// // class W2 extends StatefulWidget {
// //   static const String id = "W2";
// //
// //   @override
// //   State<W2> createState() => _W2State();
// // }
// //
// // class _W2State extends State<W2> {
// //   final ImagePicker imgpicker = ImagePicker();
// //   List<XFile> imagefiles;
// //
// //   openImages() async {
// //     try {
// //       var pickedfiles = await imgpicker.pickMultiImage();
// //       if (pickedfiles != null) {
// //         imagefiles = pickedfiles;
// //         setState(() {});
// //       } else {
// //         //print("No image is selected.");
// //       }
// //     } catch (e) {
// //       //print("error while picking file.");
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //         resizeToAvoidBottomInset: false,
// //         appBar: AppBar(
// //           title: Text("Multiple Image Picker Flutter"),
// //           backgroundColor: Colors.deepPurpleAccent,
// //         ),
// //         body: Container(
// //           alignment: Alignment.center,
// //           padding: EdgeInsets.all(20),
// //           child: Column(
// //             children: [
// //               //open button ----------------
// //               ElevatedButton(
// //                   onPressed: () {
// //                     openImages();
// //                   },
// //                   child: Text("Open Images")),
// //
// //               Divider(),
// //               Text("Picked Files:"),
// //               Divider(),
// //
// //               imagefiles != null
// //                   ? Wrap(
// //                       children: imagefiles.map((imageone) {
// //                         return Container(
// //                             child: Card(
// //                           child: Container(
// //                             height: 100,
// //                             width: 100,
// //                             child: Image.file(File(imageone.path)),
// //                           ),
// //                         ));
// //                       }).toList(),
// //                     )
// //                   : Container()
// //             ],
// //           ),
// //         ));
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:temple_adventures/d.dart';
//
// class D2 extends StatelessWidget {
//   static const String id = "D2";
//
//   List<Map<String, dynamic>> storyItems = [
//     {
//       "id": "iiiii",
//       "createdAt": "2 min Ago",
//       "img":
//           "http://www.teluguclix.com/image/chinmayi-sripada/thumbs/thumbs_singer-chinmayi-HD-images-8.jpg",
//       "description": "hello",
//     },
//     {
//       "id": "iiiii",
//       "createdAt": "2 min Ago",
//       "img":
//           "https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/Chinmayi_Sripada.JPG/220px-Chinmayi_Sripada.JPG",
//       "description": "hello",
//     },
//     {
//       "id": "iiiii",
//       "createdAt": "2 min Ago",
//       "img":
//           "https://akm-img-a-in.tosshub.com/indiatoday/images/story/201812/Chinmaya.jpeg?AIJrvPVxJOa3.mFBRvk8ZjhkVbITEF.O&size=770:433",
//       "description": "hello",
//     },
//     {
//       "id": "iiiii",
//       "createdAt": "2 min Ago",
//       "img":
//           "http://www.teluguclix.com/image/chinmayi-sripada/thumbs/thumbs_singer-chinmayi-HD-images-8.jpg",
//       "description": "hello",
//     },
//     {
//       "id": "iiiii",
//       "createdAt": "2 min Ago",
//       "img":
//           "http://www.teluguclix.com/image/chinmayi-sripada/thumbs/thumbs_singer-chinmayi-3-1.jpg",
//       "description": "hello",
//     },
//     {
//       "id": "iiiii",
//       "createdAt": "2 min Ago",
//       "img":
//           "http://www.teluguclix.com/image/chinmayi-sripada/thumbs/thumbs_singer-chinmayi-HD-images-2.jpg",
//       "description": "hello",
//     },
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               ...List.generate(storyItems.length, (index) {
//                 return D(storyItems[index]["img"]);
//               })
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
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
