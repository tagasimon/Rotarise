// import 'package:flutter/material.dart';
// import 'package:rotaract/extensions/extensions.dart';

// class ActionWidget extends StatelessWidget {
//   final IconData asset;
//   final String text;
//   final Function()? onTap;

//   const ActionWidget({
//     super.key,
//     required this.asset,
//     required this.text,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: ClipRRect(
//         child: GestureDetector(
//           onTap: onTap,
//           child: Card(
//             elevation: 5,
//             shadowColor: Colors.greenAccent,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
//                   child: Icon(asset, size: 40),
//                 ),
//                 const SizedBox(height: 10),
//                 Container(
//                   padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
//                   child: Text(
//                     text,
//                     textAlign: TextAlign.center,
//                     style: context.textTheme.titleMedium!.copyWith(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
