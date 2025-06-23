import 'package:flutter/material.dart';

class ErrorState extends StatelessWidget {
  final RefreshCallback handleRefresh;
  const ErrorState({super.key, required this.handleRefresh});

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
                  Icon(Icons.error_outline, size: 48, color: Colors.red),
                  SizedBox(height: 16),
                  Text("Something went wrong",
                      style: TextStyle(fontSize: 16, color: Colors.red)),
                  SizedBox(height: 8),
                  Text("Pull down to try again",
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
