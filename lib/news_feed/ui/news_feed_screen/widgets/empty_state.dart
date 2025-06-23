import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final RefreshCallback handleRefresh;
  const EmptyState({super.key, required this.handleRefresh});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: handleRefresh,
        child: const SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: 300,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.article_outlined, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("No Posts Yet",
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  SizedBox(height: 8),
                  Text("Pull down to refresh",
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
