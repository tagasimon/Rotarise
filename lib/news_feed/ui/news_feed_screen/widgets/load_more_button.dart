import 'package:flutter/material.dart';

class LoadMoreButton extends StatelessWidget {
  final bool isLoadingMore;
  final VoidCallback loadMore;
  const LoadMoreButton(
      {super.key, required this.isLoadingMore, required this.loadMore});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: isLoadingMore
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            )
          : Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 100),
                child: ElevatedButton.icon(
                  onPressed: loadMore,
                  icon: const Icon(Icons.expand_more),
                  label: const Text('Load More Posts'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
