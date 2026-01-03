import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../models/auth_models.dart';
import '../../../../core/constants/app_constants.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _ageController = TextEditingController();
  final _specializationController = TextEditingController();

  UserRole _selectedRole = UserRole.user;
  Gender _selectedGender = Gender.male;
  Block _selectedBlock = Block.vikasnagar;
  bool _obscurePassword = true;

  // Light blue color for selected role
  static const Color _selectedRoleColor = Color(0xFFADD8E6);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _ageController.dispose();
    _specializationController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final request = RegisterRequest(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      role: _selectedRole.name.toUpperCase(),
      fullName: _fullNameController.text.trim(),
      gender: _selectedGender.name.toUpperCase(),
      phoneNumber: _phoneController.text.isNotEmpty ? _phoneController.text.trim() : null,
      block: _selectedRole == UserRole.user ? _selectedBlock.name.toUpperCase() : null,
      address: _addressController.text.isNotEmpty ? _addressController.text.trim() : null,
      age: _ageController.text.isNotEmpty ? int.tryParse(_ageController.text) : null,
      specialization: _selectedRole == UserRole.doctor ? _specializationController.text.trim() : null,
    );

    final success = await ref.read(authProvider.notifier).register(request);

    if (!mounted) return;

    if (success) {
      context.go('/home');
    } else {
      final error = ref.read(authProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'Registration failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getRoleDisplayName(UserRole role) {
    switch (role) {
      case UserRole.user:
        return 'User';
      case UserRole.admin:
        return 'Admin';
      case UserRole.doctor:
        return 'Doctor';
      case UserRole.trainer:
        return 'Trainer';
      case UserRole.teacher:
        return 'Teacher';
    }
  }

  String _getGenderDisplayName(Gender gender) {
    switch (gender) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.other:
        return 'Other';
    }
  }

  String _getBlockDisplayName(Block block) {
    switch (block) {
      case Block.vikasnagar:
        return 'Vikasnagar';
      case Block.doiwala:
        return 'Doiwala';
      case Block.sahaspur:
        return 'Sahaspur';
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),

                  // ========== HEADER SECTION ==========
                  // Top Logos Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // UPES Logo (Left)
                      _buildLogoPlaceholder(
                        assetName: 'assets/images/image.png',
                        fallbackText: 'image.png',
                        width: 80,
                        height: 50,
                      ),
                      // Government Logo (Right)
                      _buildLogoPlaceholder(
                        assetName: 'assets/images/dst.png',
                        fallbackText: 'dst.png',
                        width: 80,
                        height: 50,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Page Title
                  Text(
                    'Community Covid Resilience\nResource Center',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // ========== BRANDING SECTION ==========
                  // Main App Logo (Center) - Smaller for register screen
                  Container(
                    width: screenWidth * 0.3,
                    height: screenWidth * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/sua.jpeg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.health_and_safety,
                                  size: 64,
                                  color: Colors.green[700],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'sua.jpeg',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          );
                        },

                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    'Swastha Aur Abhimaan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // ========== REGISTER FORM ==========
                  // Register Heading
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Role Selection Label
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Select your role',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Role Selection Pills
                  _buildRoleSelector(),
                  const SizedBox(height: 24),

                  // Full Name Field
                  _buildUnderlineTextField(
                    controller: _fullNameController,
                    label: 'Full Name',
                    validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),

                  // Email Field
                  _buildUnderlineTextField(
                    controller: _emailController,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Required';
                      if (!value.contains('@')) return 'Invalid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.grey[600]),
                      border: const UnderlineInputBorder(),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey[600],
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Required';
                      if (value.length < 6) return 'Min 6 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Gender Selection Pills
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Gender',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildGenderSelector(),
                  const SizedBox(height: 16),

                  // Phone Number
                  _buildUnderlineTextField(
                    controller: _phoneController,
                    label: 'Phone Number (Optional)',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),

                  // Block Selection (for USER role)
                  if (_selectedRole == UserRole.user) ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Select your block',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildBlockSelector(),
                    const SizedBox(height: 16),

                    _buildUnderlineTextField(
                      controller: _addressController,
                      label: 'Address (Optional)',
                    ),
                    const SizedBox(height: 16),

                    _buildUnderlineTextField(
                      controller: _ageController,
                      label: 'Age (Optional)',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Specialization (for DOCTOR role)
                  if (_selectedRole == UserRole.doctor) ...[
                    _buildUnderlineTextField(
                      controller: _specializationController,
                      label: 'Specialization',
                      validator: (value) => value?.isEmpty ?? true ? 'Required for doctors' : null,
                    ),
                    const SizedBox(height: 16),
                  ],

                  const SizedBox(height: 24),

                  // Register Button (Pill shape, black background)
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: authState.isLoading ? null : _handleRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: authState.isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Register',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: const Text(
                          'Login Here',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoPlaceholder({
    required String assetName,
    required String fallbackText,
    required double width,
    required double height,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: Image.asset(
        assetName,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                fallbackText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUnderlineTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        border: const UnderlineInputBorder(),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
      validator: validator,
    );
  }

  Widget _buildRoleSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: UserRole.values.map((role) {
          final isSelected = _selectedRole == role;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedRole = role);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? _selectedRoleColor : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected ? _selectedRoleColor : Colors.grey[400]!,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  _getRoleDisplayName(role),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Row(
      children: Gender.values.map((gender) {
        final isSelected = _selectedGender == gender;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () {
              setState(() => _selectedGender = gender);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? _selectedRoleColor : Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? _selectedRoleColor : Colors.grey[400]!,
                  width: 1.5,
                ),
              ),
              child: Text(
                _getGenderDisplayName(gender),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBlockSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: Block.values.map((block) {
          final isSelected = _selectedBlock == block;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedBlock = block);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? _selectedRoleColor : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected ? _selectedRoleColor : Colors.grey[400]!,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  _getBlockDisplayName(block),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
