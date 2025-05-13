import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rotaract/models/nutritionist.dart';

final nutritionistRepoProvider = Provider<NutritionistRepo>((ref) {
  return NutritionistRepo();
});

// nutritionists list provider
final nutritionistsListProvider = FutureProvider<List<Nutritionist>>((
  ref,
) async {
  final nutritionistRepo = ref.watch(nutritionistRepoProvider);
  return nutritionistRepo.fetchNutritionists();
});

class NutritionistRepo {
  // This class is responsible for managing the nutritionist data.
  // It can include methods to fetch, add, update, or delete nutritionist information.

  // Example method to fetch nutritionist data
  Future<List<Nutritionist>> fetchNutritionists() async {
    await Future.delayed(const Duration(seconds: 1));
    return nutritionists;
  }
}

final List<Nutritionist> nutritionists = [
  Nutritionist(
    name: 'Dr. Sarah Namirembe',
    title: 'Lead Nutritionist',
    specialization: 'Infant & Maternal Nutrition',
    education: 'PhD, Nutrition Science, Makerere University',
    imageUrl: 'assets/images/nutritionist1.jpg',
    description:
        'Specializes in developing nutritious formulas for infants and nursing mothers with over 15 years of experience.',
  ),
  Nutritionist(
    name: 'James Okello',
    title: 'Senior Nutritionist',
    specialization: 'Pediatric Nutrition',
    education: 'MSc, Food Science, Makerere University',
    imageUrl: 'assets/images/nutritionist2.jpg',
    description:
        'Expert in formulating age-appropriate nutrition solutions for children from 6 months to 5 years.',
  ),
  Nutritionist(
    name: 'Grace Akello',
    title: 'Clinical Nutritionist',
    specialization: 'Therapeutic Nutrition',
    education: 'BSc, Nutrition & Dietetics, Kyambogo University',
    imageUrl: 'assets/images/nutritionist3.jpg',
    description:
        'Focuses on nutritional interventions for children with special dietary needs and health conditions.',
  ),
  Nutritionist(
    name: 'Dr. Robert Musoke',
    title: 'Research Nutritionist',
    specialization: 'Food Safety & Quality',
    education: 'PhD, Food Technology, Makerere University',
    imageUrl: 'assets/images/nutritionist4.jpg',
    description:
        'Leads research on sustainable, locally-sourced ingredients for optimal nutritional profiles.',
  ),
  Nutritionist(
    name: 'Patricia Namuwenge',
    title: 'Community Nutrition Educator',
    specialization: 'Public Health Nutrition',
    education: 'MPH, Makerere University School of Public Health',
    imageUrl: 'assets/images/nutritionist5.jpg',
    description:
        'Works with communities to promote proper nutrition practices and education for families.',
  ),
];
