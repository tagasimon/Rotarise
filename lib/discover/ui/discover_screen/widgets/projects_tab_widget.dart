import 'package:flutter/material.dart';

class ProjectsTabWidget extends StatelessWidget {
  const ProjectsTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 2, // Mock data
        itemBuilder: (context, index) => _buildProjectCard(context, index),
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, int index) {
    final mockProjects = [
      {
        'title': 'Kakindu Project',
        'description': 'Building a school in Kakindu',
        'progress': 0.5,
        'raised': 'UGX100,000,000',
        'target': 'UGX200,000,000',
        'club': 'Rotaract Club of Kampala North',
        'category': 'Education',
        'color': Colors.blue,
        'icon': Icons.school,
      },
      {
        'title': 'Water Project',
        'description': 'Providing clean water to rural communities',
        'progress': 0.3,
        'raised': 'UGX 20,000,000',
        'target': 'UGX 500,000,000',
        'club': 'Rotaract Club of Gayaza',
        'category': 'Water & Sanitation',
        'color': Colors.cyan,
        'icon': Icons.water_drop,
      },
    ];

    final project = mockProjects[index % mockProjects.length];
    final projectColor = project['color'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            projectColor.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: projectColor.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: projectColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Subtle pattern overlay
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: projectColor.withOpacity(0.03),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with icon and category
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: projectColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          project['icon'] as IconData,
                          color: projectColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${project['title']}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: projectColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "${project['category']}",
                                style: TextStyle(
                                  color: projectColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Description
                  Text(
                    "${project['description']}",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                      height: 1.6,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Progress section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: projectColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: projectColor.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Raised",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${project['raised']}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: projectColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Target",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${project['target']}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Modern progress bar
                        Stack(
                          children: [
                            Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            Container(
                              height: 8,
                              width: MediaQuery.of(context).size.width *
                                  0.7 *
                                  (project['progress'] as double),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    projectColor.withOpacity(0.8),
                                    projectColor,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color: projectColor.withOpacity(0.3),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Progress percentage
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "${((project['progress'] as double) * 100).toInt()}% funded",
                            style: TextStyle(
                              color: projectColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Club info and donate button
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Organized by",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${project['club']}",
                              style: TextStyle(
                                color: Colors.purple.shade600,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Modern donate button
                      ElevatedButton(
                        onPressed: () {
                          _showDonateDialog(context, project);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: projectColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          shadowColor: projectColor.withOpacity(0.3),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.favorite, size: 18),
                            SizedBox(width: 8),
                            Text(
                              "Donate",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDonateDialog(BuildContext context, Map<String, dynamic> project) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.favorite,
                color: project['color'] as Color,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Support ${project['title']}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your donation will help us reach our goal of ${project['target']} for this amazing project.",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Choose donation amount:",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children:
                    ['10,000', '50,000', '100,000', '500,000'].map((amount) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _processDonation(context, amount, project);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          (project['color'] as Color).withOpacity(0.1),
                      foregroundColor: project['color'] as Color,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text("UGX $amount"),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showCustomAmountDialog(context, project);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: project['color'] as Color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Custom Amount"),
            ),
          ],
        );
      },
    );
  }

  void _showCustomAmountDialog(
      BuildContext context, Map<String, dynamic> project) {
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text("Enter Custom Amount"),
          content: TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Amount (UGX)",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixText: "UGX ",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _processDonation(context, amountController.text, project);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: project['color'] as Color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Donate"),
            ),
          ],
        );
      },
    );
  }

  void _processDonation(
      BuildContext context, String amount, Map<String, dynamic> project) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text("Thank you for donating UGX $amount to ${project['title']}!"),
        backgroundColor: project['color'] as Color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
