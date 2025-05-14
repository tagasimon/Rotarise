import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/constants/constants.dart';
import 'package:rotaract/extensions/extensions.dart';
import 'package:rotaract/ui/club_main_screen/widgets/club_about_widget.dart';
import 'package:rotaract/providers/club_repo_providers.dart';
import 'package:share_plus/share_plus.dart';

class ClubMainScreen extends ConsumerStatefulWidget {
  final String id;
  const ClubMainScreen({super.key, required this.id});

  @override
  ConsumerState<ClubMainScreen> createState() => _ClubMainScreenState();
}

class _ClubMainScreenState extends ConsumerState<ClubMainScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCont;
  @override
  void initState() {
    _tabCont = TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final clubByIdProv = ref.watch(getClubByIdProvider(widget.id));
    return clubByIdProv.when(
      data: (data) {
        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (_, __) {
              return [
                SliverAppBar(
                  expandedHeight: 300,
                  centerTitle: true,
                  pinned: true,
                  leading: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      onPressed: () => context.pop(false),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  title: Text(
                    data?.name ?? "",
                    style: const TextStyle(
                      letterSpacing: 0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  actions: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: IconButton(
                        onPressed: () async {
                          Share.share(
                              'Check Out this Rotaract Club: ${data!.name}',
                              subject: 'Download Rotact ${Constants.kAppLink}');
                        },
                        icon: const Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: false,
                    background: CachedNetworkImage(
                      imageUrl: data?.imageUrl ?? Constants.kDefaultImageLink,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => CachedNetworkImage(
                          imageUrl: Constants.kDefaultImageLink,
                          fit: BoxFit.cover),
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(50),
                    child: Container(
                      width: double.infinity,
                      color: Theme.of(context).primaryColorLight,
                      alignment: Alignment.center,
                      child: TabBar(
                        controller: _tabCont,
                        tabs: const [
                          Tab(
                            child: Row(
                              children: [
                                // Icon(Icons.whatshot_sharp, color: Colors.red),
                                SizedBox(width: 2),
                                Text("POSTS"),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              children: [
                                // Icon(Icons.whatshot_sharp, color: Colors.black),
                                SizedBox(width: 2),
                                Text("EVENTS"),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              children: [
                                // Icon(Icons.insights),
                                SizedBox(width: 2),
                                Text("MEMBERS"),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              children: [
                                // Icon(Icons.insights),
                                SizedBox(width: 2),
                                Text("ABOUT"),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabCont,
              children: [
                const SizedBox(child: Text("POSTS")),
                const SizedBox(child: Text("EVENTS")),
                const SizedBox(child: Text("MEMBERS")),
                ClubAboutWidget(id: widget.id),
              ],
            ),
          ),
        );
      },
      error: (error, stack) {
        log("Error: $error, StackTrace: $stack");
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Errorr!!",
              style: TextStyle(
                letterSpacing: 0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
          ),
          body: const Center(child: Text("Error")),
        );
      },
      loading: () {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
