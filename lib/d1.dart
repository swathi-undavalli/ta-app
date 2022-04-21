// // https://zuzubusylabs.s3.ap-south-1.amazonaws.com/pictures/vocabulary/activities/dolch-sight/activityTile/this-one.svg
// //
// //
// //     {
// // "left": ["soft","happy","hot"],
// // "right": ["cold","hard","sad"],
// // "answers": {"soft":"hard","hot":"cold","happy":"sad"},
// // }
// //
// // {
// // "left": ["young","tall","dirty"],
// // "right": ["clean","old","short"],
// // "answers": {"young":"old","dirty":"clean","tall":"short"},
// // }
// //
// // {
// // "left": ["Day","Weak","First"],
// // "right": ["Last","Strong","Night"],
// // "answers": {"Day":"Night","Weak":"Strong","First":"Last"},
// // }
// //
// // {
// // "left": ["Fast","Big","Heavy"],
// // "right": ["Slow","Light","Small"],
// // "answers": {"Fast":"Slow","Big":"Small","Heavy":"Light"},
// // }
// //
// // {
// // "left": ["Open","Rich","Full"],
// // "right": ["Empty","Close","Poor"],
// // "answers": {"Open":"Close","Rich":"Poor","Full":"Empty"},
// // }
//
// //
//
// // void main() {
// //   var arr = [1, 2, 3, 4, 3, 2];
// //   var res = 0;
// //   for (int i = 0; i < arr.length; i++) {
// //     res = res + arr[i];
// //   }
// //
// //   print(res);
// // }
//
// // void main() {
// //   var n = 5025;
// //   var value = convertFive(n);
// //   print(value);
// // }
// //
// // int convertFive(int n) {
// //   var newNum = 0;
// //   var result = 0;
// //   while (n != 0) {
// //     var r = n % 10;
// //     if (r == 0) {
// //       r = 5;
// //       newNum = newNum * 10 + r;
// //     } else {
// //       newNum = newNum * 10 + r;
// //     }
// //     n = (n / 10).floor();
// //   }
// //   while (newNum != 0) {
// //     result = result * 10 + (newNum % 10);
// //     newNum = (newNum / 10).floor();
// //   }
// //   return result;
// // }
//
// //
//
// // class Solution {
// //
// //   String hii;
// //
// //   printHelloWorld() {
// //     print("Hello World");
// //   }
// // }
// //
// // void main() {
// //   Solution solution = Solution();
// //   solution.printHelloWorld();
// //   solution.hii = "Sahitha";
// //   print(solution.hii);
// // }
//
// // void main() {
// //   var arr = [1, 2, 4, 11, 8, 10];
// //
// //   int x = 9;
// //
// //   var count = countOfElements(arr, x);
// //
// //   print(count);
// // }
// //
// // int countOfElements(List<int> arr, int x) {
// //   var newArr = [];
// //
// //   for (int i = 0; i < arr.length; i++) {
// //     if (arr[i] < x) {
// //       newArr.add(arr[i]);
// //     }
// //   }
// //
// //   return newArr.length;
// // }
// //
//
// // void main(){
// //
// //   int n = 3;
// //
// //   var sum = seriesNum(n);
// //
// //   print(sum);
// //
// // }
// //
// // int seriesNum(int n) {
// //
// //   var sum = 0;
// //
// //   for(int i = 1 ; i <= n ; i++){
// //
// //     sum = sum + i;
// //
// //   }
// //
// //   return sum;
// // }
//
// // import 'dart:io';
// //
// // void main() {
// //   var arr = [1, 2, 3, 4, 5];
// //
// //   for (int i = 0; i < arr.length; i++) {
// //     stdout.write("${arr[i]} ");
// //   }
// // }
//
// // void main(){
// //
// //   var names = ["Geek", "Geeks", "Geeksfor",
// //     "GeeksforGeeksfor", "GeeksforGeekforGeek"];
// //
// //       var big = names[0];
// //
// //       for(int i = 0 ; i < names.length ; i++){
// //
// //         if(big.length <= names[i].length){
// //
// //           big = names[i];
// //
// //         }
// //     }
// //
// //       print(big);
// //
// // }
//
// // void main(){
// //
// //   var str = "ABCddE";
// //
// //   print(str.toLowerCase());
// //
// // }
//
// // void main() {
// //   int a = 3;
// //   int b = 3;
// //
// //   var product = multiplication(a, b);
// //
// //   print(product);
// // }
// //
// // int multiplication(int a, int b) {
// //   int c = a * b;
// //
// //   return c;
// // }
//
// // void main() {
// //   var arr = [5, 3, 6, 1, 2];
// //   var k = 2;
// //
// //   var start = arr[k - 1];
// //
// //   var end = arr.last - (k - 1);
// //
// //   print(start);
// //   print(end);
// // }
//
// // void main() {
// //   var n = 153;
// //
// //   var res = armstrongNumber(n);
// //
// //   print(res);
// // }
// //
// // String armstrongNumber(int n) {
// //   var sum = 0;
// //   var temp = n;
// //   while (n != 0) {
// //     var r = n % 10;
// //
// //     sum = sum + (r * r * r);
// //
// //     n = (n / 10).floor();
// //   }
// //   if (sum == temp) {
// //     return "true";
// //   } else
// //     return "false";
// // }
//
// // void main() {
// //   var l1 = [
// //     [1, 2, 3],
// //     [4, 5, 6]
// //   ];
// //   var l2 = [
// //     [7, 8],
// //     [9, 10],
// //     [11, 12]
// //   ];
// //
// //   var r = [[0,0,0],[0,0,0]];
// //
// //   for(int i = 0 ; i < l1.length ; i++){
// //
// //     for(int j = 0 ; j < l2[0].length ; j++){
// //
// //       for(int k = 0 ; k < l2.length ; k++){
// //
// //           r[i][j] += l1[i][k] * l2[k][j];
// //
// //       }
// //       print(r);
// //
// //     }
// //   }
// //
// // }
//
// // import 'dart:io';
// //
// // void main() {
// //   var s = "sahithaKamesh";
// //
// //   for(int i = s.length - 1 ; i >= 0 ; i--){
// //
// //     stdout.write(s[i]);
// //
// //   }
// //
// // }
// // void main(){
// //
// //   var n = 6;
// //
// //
// //
// // }
//
// import 'package:flutter/material.dart';
//
// class W1 extends StatefulWidget {
//   // static const String id = "W1";
//   @override
//   _W1State createState() => _W1State();
// }
//
// class _W1State extends State<W1> {
//   bool d = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           d = !d;
//         });
//       },
//       child: Padding(
//         padding: const EdgeInsets.only(bottom: 20.0),
//         child: Container(
//           height: 100,
//           width: 100,
//           color: d ? Colors.red : Colors.green,
//         ),
//       ),
//     );
//   }
// }
