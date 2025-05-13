// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:rotaract/constants/constants.dart';
// import 'package:rotaract/widgets/circle_image_widget.dart';

// class HomeAppBarWidget extends ConsumerWidget {
//   final String title;
//   const HomeAppBarWidget({super.key, required this.title});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // date format showing only month and date
//     // final cUser = ref.read(filterNotifierProvider).cUser;
//     return SliverAppBar(
//       title: GestureDetector(
//         onTap: () {
//           // context.push(const CustomProfileScreen())
//         },
//         child: Row(
//           children: [
//             CircleImageWidget(
//               color: Theme.of(context).primaryColorDark,
//               // imageUrl: cUser?.profileUrl ?? Constants.kDefaultImageLink,
//               imageUrl: Constants.kDefaultImageLink,
//               radius: 20,
//             ),
//             const SizedBox(width: 5),
//             Text(title),
//           ],
//         ),
//       ),
//       floating: true,
//       actions: [
//         IconButton(
//           onPressed: () {
//             // final cUserId = ref.watch(filterNotifierProvider).cUser!.id;
//             // ref
//             //     .read(filterNotifierProvider.notifier)
//             //     .updateFilter(selectedTipsterId: cUserId);
//             // context.push(const UserProfileStats());
//           },
//           icon: const Icon(Icons.bar_chart, color: Colors.black),
//         ),
//         IconButton(
//           onPressed: () {},
//           icon: const Icon(Icons.notifications),
//         )
//       ],
//     );
//   }
// }
