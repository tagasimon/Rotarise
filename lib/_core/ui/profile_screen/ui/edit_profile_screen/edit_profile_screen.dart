import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rotaract/_core/extensions/color_extension.dart';
import 'package:rotaract/_core/notifiers/tab_index_notifier.dart';
import 'package:rotaract/_core/ui/profile_screen/controllers/club_member_controllers.dart';
import 'package:rotaract/_core/ui/profile_screen/models/club_member_model.dart';
import 'package:intl/intl.dart';

class EditProfileEditPage extends ConsumerStatefulWidget {
  final ClubMemberModel member;
  const EditProfileEditPage({super.key, required this.member});

  @override
  ConsumerState<EditProfileEditPage> createState() =>
      _EditProfileEditPageState();
}

class _EditProfileEditPageState extends ConsumerState<EditProfileEditPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late ScrollController _scrollController;

  // Form key and controllers
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _professionController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _companyController;
  late TextEditingController _jobTitleController;
  late TextEditingController _expertiseController;
  late TextEditingController _educationController;

  // Form state
  String? _selectedGender;
  DateTime? _selectedDateOfBirth;
  List<String> _expertiseList = [];
  List<String> _educationList = [];
  bool _isLoading = false;

  final List<String> _genderOptions = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say'
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeControllers();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _scrollController = ScrollController();
    _animationController.forward();
  }

  void _initializeControllers() {
    _firstNameController = TextEditingController(text: widget.member.firstName);
    _lastNameController = TextEditingController(text: widget.member.lastName);
    _professionController =
        TextEditingController(text: widget.member.profession ?? '');
    _phoneController =
        TextEditingController(text: widget.member.phoneNumber ?? '');
    _addressController =
        TextEditingController(text: widget.member.address ?? '');
    _companyController =
        TextEditingController(text: widget.member.company ?? '');
    _jobTitleController =
        TextEditingController(text: widget.member.jobTitle ?? '');
    _expertiseController = TextEditingController();
    _educationController = TextEditingController();

    _selectedGender = widget.member.gender;
    _selectedDateOfBirth = widget.member.dateOfBirth;
    _expertiseList = List<String>.from(widget.member.expertise ?? []);
    _educationList = List<String>.from(widget.member.education ?? []);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _professionController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _companyController.dispose();
    _jobTitleController.dispose();
    _expertiseController.dispose();
    _educationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    // final state = ref.watch(clubMemberControllersProvider);
    ref.listen(clubMemberControllersProvider, (previous, next) {
      if (next.hasError) {
        Fluttertoast.showToast(
          msg: "Error: ${next.error}",
        );
      } else if (next.hasValue && next.value != null) {
        Fluttertoast.showToast(
          msg: "Profile updated successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.of(context).pop(next.value);
      }
    });
    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
      appBar: _buildAppBar(isDark),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(
                    'Personal Information', Icons.person_outline, Colors.blue),
                const SizedBox(height: 16),
                _buildPersonalInfoSection(isDark),
                const SizedBox(height: 32),
                _buildSectionTitle('Contact Information',
                    Icons.contact_phone_outlined, Colors.green),
                const SizedBox(height: 16),
                _buildContactInfoSection(isDark),
                const SizedBox(height: 32),
                _buildSectionTitle('Professional Information',
                    Icons.work_outline, Colors.orange),
                const SizedBox(height: 16),
                _buildProfessionalInfoSection(isDark),
                const SizedBox(height: 32),
                _buildSectionTitle(
                    'Skills & Education', Icons.school_outlined, Colors.purple),
                const SizedBox(height: 16),
                _buildSkillsEducationSection(isDark),
                const SizedBox(height: 40),
                _buildActionButtons(isDark),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isDark) {
    return AppBar(
      elevation: 0,
      backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          color: isDark ? Colors.white : Colors.grey[800],
        ),
        style: IconButton.styleFrom(
          backgroundColor: isDark ? Colors.grey[800] : Colors.white,
          shape: const CircleBorder(),
        ),
      ),
      title: Text(
        'Edit Profile',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: isDark ? Colors.white : Colors.grey[800],
        ),
      ),
      actions: [
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withAlphaa(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoSection(bool isDark) {
    return _buildCard(
      isDark,
      Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _firstNameController,
                  label: 'First Name',
                  icon: Icons.person_outline,
                  validator: (value) =>
                      value?.isEmpty == true ? 'First name is required' : null,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildTextField(
                  controller: _lastNameController,
                  label: 'Last Name',
                  icon: Icons.person_outline,
                  validator: (value) =>
                      value?.isEmpty == true ? 'Last name is required' : null,
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildGenderDropdown(isDark),
          const SizedBox(height: 20),
          _buildDatePicker(isDark),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _professionController,
            label: 'Profession',
            icon: Icons.work_outline,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoSection(bool isDark) {
    return _buildCard(
      isDark,
      Column(
        children: [
          _buildTextField(
            controller: _phoneController,
            label: 'Phone Number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            isDark: isDark,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _addressController,
            label: 'Address',
            icon: Icons.location_on_outlined,
            maxLines: 3,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalInfoSection(bool isDark) {
    return _buildCard(
      isDark,
      Column(
        children: [
          _buildTextField(
            controller: _companyController,
            label: 'Company',
            icon: Icons.business_outlined,
            isDark: isDark,
          ),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _jobTitleController,
            label: 'Job Title',
            icon: Icons.badge_outlined,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsEducationSection(bool isDark) {
    return _buildCard(
      isDark,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildChipSection(
            'Areas of Expertise',
            _expertiseList,
            _expertiseController,
            Colors.purple,
            isDark,
            () => _addToList(_expertiseController, _expertiseList),
          ),
          const SizedBox(height: 24),
          _buildChipSection(
            'Education',
            _educationList,
            _educationController,
            Colors.teal,
            isDark,
            () => _addToList(_educationController, _educationList),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(bool isDark, Widget child) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withAlphaa(0.3)
                : Colors.grey.withAlphaa(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: child,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    required bool isDark,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.grey[800],
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
        labelStyle: TextStyle(
          color: isDark ? Colors.grey[400] : Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: isDark ? Colors.grey[800] : Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.blue.shade400,
            width: 2,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildGenderDropdown(bool isDark) {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      onChanged: (value) => setState(() => _selectedGender = value),
      decoration: InputDecoration(
        labelText: 'Gender',
        prefixIcon: Icon(
          Icons.wc_outlined,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
        labelStyle: TextStyle(
          color: isDark ? Colors.grey[400] : Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
        filled: true,
        fillColor: isDark ? Colors.grey[800] : Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.blue.shade400,
            width: 2,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      items: _genderOptions.map((gender) {
        return DropdownMenuItem(
          value: gender,
          child: Text(
            gender,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
      dropdownColor: isDark ? Colors.grey[800] : Colors.white,
    );
  }

  Widget _buildDatePicker(bool isDark) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                _selectedDateOfBirth != null
                    ? DateFormat('MMMM dd, yyyy').format(_selectedDateOfBirth!)
                    : 'Date of Birth',
                style: TextStyle(
                  color: _selectedDateOfBirth != null
                      ? (isDark ? Colors.white : Colors.grey[800])
                      : (isDark ? Colors.grey[400] : Colors.grey[600]),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChipSection(
    String title,
    List<String> items,
    TextEditingController controller,
    Color color,
    bool isDark,
    VoidCallback onAdd,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.grey[800],
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Add ${title.toLowerCase()}...',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  filled: true,
                  fillColor: isDark ? Colors.grey[800] : Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
                onSubmitted: (_) => onAdd(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: onAdd,
              icon: Icon(Icons.add, color: color),
              style: IconButton.styleFrom(
                backgroundColor: color.withAlphaa(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (items.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items
                .map((item) => _buildEditableChip(item, color, items))
                .toList(),
          ),
      ],
    );
  }

  Widget _buildEditableChip(String label, Color color, List<String> list) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlphaa(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlphaa(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => setState(() => list.remove(label)),
            child: Icon(
              Icons.close,
              size: 16,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isDark) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: _isLoading ? null : _saveProfile,
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade600,
                    Colors.indigo.shade700,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withAlphaa(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Container(
                alignment: Alignment.center,
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.save_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'SAVE CHANGES',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _addToList(TextEditingController controller, List<String> list) {
    final text = controller.text.trim();
    if (text.isNotEmpty && !list.contains(text)) {
      setState(() {
        list.add(text);
        controller.clear();
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateOfBirth ??
          DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Colors.blue,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedDateOfBirth = picked);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Create updated member object
      final updatedMember = widget.member.copyWith(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        gender: _selectedGender,
        profession: _professionController.text.trim().isEmpty
            ? null
            : _professionController.text.trim(),
        dateOfBirth: _selectedDateOfBirth,
        phoneNumber: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        address: _addressController.text.trim().isEmpty
            ? null
            : _addressController.text.trim(),
        company: _companyController.text.trim().isEmpty
            ? null
            : _companyController.text.trim(),
        jobTitle: _jobTitleController.text.trim().isEmpty
            ? null
            : _jobTitleController.text.trim(),
        expertise: _expertiseList.isEmpty ? null : _expertiseList,
        education: _educationList.isEmpty ? null : _educationList,
      );

      // TODO: Implement actual save functionality
      final res = await ref
          .read(clubMemberControllersProvider.notifier)
          .updateMember(updatedMember);

      if (res) {
        Fluttertoast.showToast(
          msg: "Profile updated successfully!",
        );
      }

      if (mounted) {
        Navigator.of(context).pop(updatedMember);
        ref.read(tabIndexProvider.notifier).setTabIndex(0);
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to update profile. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
