import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rotaract/_core/extensions/color_extension.dart';
import 'package:rotaract/admin_tools/models/project_model.dart';
import 'package:rotaract/admin_tools/ui/club_projects/widgets/project_app_bar.dart';
import 'package:rotaract/admin_tools/ui/club_projects/widgets/stat_card.dart';
import 'package:rotaract/admin_tools/ui/club_projects/widgets/tab_section.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final ProjectModel project;
  const ProjectDetailsScreen({super.key, required this.project});

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const projectColor = Colors.pink;

    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            ProjectAppBar(
              project: widget.project,
            ), // AppBar with project details
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildHeroSection(projectColor),
                  TabSection(
                    project: widget.project,
                    projectColor: projectColor,
                    tabController: _tabController,
                  ),
                ],
              ),
            ), // This was the missing closing parenthesis and brace
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(Color projectColor) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  projectColor.lighter,
                  Colors.white,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: projectColor.light),
              boxShadow: [
                BoxShadow(
                  color: projectColor.lighter,
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StatCard('Raised', "10", projectColor),
                    StatCard('Target', "100", Colors.grey.shade700),
                    const StatCard('Donors', '127', Colors.orange),
                  ],
                ),
                const SizedBox(height: 24),
                _buildProgressBar(projectColor),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Quick actions
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showDonateModal(context, projectColor),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: projectColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite, size: 20),
                      SizedBox(width: 8),
                      Text('Donate Now',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: projectColor.light),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconButton(
                  onPressed: () => _shareProject(),
                  icon: Icon(Icons.share, color: projectColor),
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(Color projectColor) {
    const progress = 0.5;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}% Complete',
              style: TextStyle(
                color: projectColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 12,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(projectColor),
          ),
        ),
      ],
    );
  }

  void _showDonateModal(BuildContext context, Color projectColor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Icon(Icons.favorite, color: projectColor, size: 24),
                  const SizedBox(width: 12),
                  const Text(
                    'Make a Donation',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Quick donation amounts
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                    ['10,000', '50,000', '100,000', '500,000'].map((amount) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _processDonation(amount);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: projectColor.withAlphaa(0.1),
                      foregroundColor: projectColor,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text('UGX $amount'),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showCustomAmountDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: projectColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Custom Amount',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  void _showCustomAmountDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Enter Amount'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Amount (UGX)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processDonation(controller.text);
            },
            child: const Text('Donate'),
          ),
        ],
      ),
    );
  }

  void _processDonation(String amount) {
    Fluttertoast.showToast(
        msg: 'Donation of UGX $amount processed successfully!',
        toastLength: Toast.LENGTH_SHORT);
  }

  void _shareProject() {
    Fluttertoast.showToast(
        msg: 'Sharing project details...', toastLength: Toast.LENGTH_SHORT);
  }
}
