//
// {
// "left": ["Day","Weak","First"],
// "right": ["Last","Strong","Night"],
// "answers": {"Day":"Night","Weak":"Strong","First":"Last"},
// }
//
// {
// "left": ["Fast","Big","Heavy"],
// "right": ["Slow","Light","Small"],
// "answers": {"Fast":"Slow","Big":"Small","Heavy":"Light"},
// }
//
// {
// "left": ["Open","Rich","Full"],
// "right": ["Empty","Close","Poor"],
// "answers": {"Open":"Close","Rich":"Poor","Full":"Empty"},
// }
//

import 'package:flutter/material.dart';
import 'package:temple_adventures/d1.dart';

class W2 extends StatelessWidget {
  static const String id = "W2";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            W1(),
            W1(),
            W1(),
            W1(),
          ],
        ),
      ),
    );
  }
}
