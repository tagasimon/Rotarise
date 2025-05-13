import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/repos/nutritionist_repo.dart';
import 'package:rotaract/ui/nutritionists_screen/nutritionist_item_widget.dart';

class NutritionistsScreen extends ConsumerWidget {
  const NutritionistsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nutritionistsListProv = ref.watch(nutritionistsListProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'CLUB OFFICERS',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: nutritionistsListProv.when(
        data: (data) {
          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color:
                    const Color(0xFFFFAA00), // Orange color matching app theme
                child: const Column(
                  children: [
                    Text(
                      'Meet Our Expert Team',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'The team behind Operations',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: nutritionists.length,
                  itemBuilder: (context, index) {
                    return NutritionistItemWidget(
                      nutritionist: nutritionists[index],
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => const Center(
          child: Text(
            'Error loading nutritionists',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
