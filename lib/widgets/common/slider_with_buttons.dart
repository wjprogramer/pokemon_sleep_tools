// import 'package:flutter/material.dart';
//
// class SliderWithButtons extends StatefulWidget {
//   const SliderWithButtons({super.key});
//
//   @override
//   State<SliderWithButtons> createState() => _SliderWithButtonsState();
// }
//
// class _SliderWithButtonsState extends State<SliderWithButtons> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Slider(
//           value: _currLevel.toDouble(),
//           onChanged: (v) {
//             _changeLevel(v.toInt());
//           },
//           divisions: 99,
//           min: 1,
//           max: 100,
//         ),
//         Row(
//           children: [
//             Expanded(child: _buildLevelButton(value: -10)),
//             Expanded(child: _buildLevelButton(value: -1)),
//             Stack(
//               children: [
//                 const Opacity(
//                   opacity: 0,
//                   child: Padding(
//                     padding: EdgeInsets.all(4.0),
//                     child: Text('100'),
//                   ),
//                 ),
//                 Positioned.fill(
//                   child: Center(
//                     child: Text(
//                       _currLevel.toString(),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Expanded(child: _buildLevelButton(value: 1)),
//             Expanded(child: _buildLevelButton(value: 10)),
//           ].xMapIndexed((index, e, list) => <Widget>[
//             e,
//             if (list.length - 1 != index)
//               Gap.sm,
//           ]).expand((e) => e).toList(),
//         ),
//       ],
//     );
//   }
// }
