import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import 'course_type_selection_screen.dart';
import 'login_sceen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _emailOrPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),

                // Header / Logo area
                Center(
                  child: Column(
                    children: [
                      const Icon(Icons.school, size: 80, color: Color(0xFF003087)),
                      const SizedBox(height: 16),
                      const Text(
                        "Create Your Account",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003087),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Join the Bandari Student Portal",
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // Form Fields
                CustomTextField(
                  label: "Full Name",
                  hint: "e.g. John Mwangi",
                  controller: _fullNameController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your full name";
                    }
                    if (value.trim().split(' ').length < 2) {
                      return "Please enter both first and last name";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                CustomTextField(
                  label: "Student ID / Registration Number",
                  hint: "e.g. BC/2024/001 or your index number",
                  controller: _studentIdController,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your student ID";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                CustomTextField(
                  label: "Email or Phone",
                  hint: "student@bandari.ac.tz or +255...",
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailOrPhoneController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter email or phone number";
                    }
                    // Basic format check (can be improved later)
                    if (!value.contains('@') && !value.startsWith('+') && !value.startsWith('0')) {
                      return "Enter a valid email or phone number";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                CustomTextField(
                  label: "Password",
                  obscureText: _obscurePassword,
                  controller: _passwordController,
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a password";
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                CustomTextField(
                  label: "Confirm Password",
                  obscureText: _obscureConfirmPassword,
                  controller: _confirmPasswordController,
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please confirm your password";
                    }
                    if (value != _passwordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 40),

                PrimaryButton(
                  label: "Create Account",
                  isLoading: _isLoading,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() => _isLoading = true);

                      // Simulate API call delay (replace with real registration logic later)
                      Future.delayed(const Duration(seconds: 2), () {
                        setState(() => _isLoading = false);

                        // TODO: Call your Laravel API here to register the user
                        // Example:
                        // registerUser(
                        //   fullName: _fullNameController.text.trim(),
                        //   studentId: _studentIdController.text.trim(),
                        //   emailOrPhone: _emailOrPhoneController.text.trim(),
                        //   password: _passwordController.text,
                        // );

                        // On success → navigate to login or home
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Account created successfully! Please sign in.")),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const CourseTypeSelectionScreen()),
                        );
                      });
                    }
                  },
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Sign In"),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _studentIdController.dispose();
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}