import 'package:flutter/material.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';
import 'course_type_selection_screen.dart';
import 'register_screen.dart'; // we'll create next


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
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

                // Logo / Header
                Center(
                  child: Column(
                    children: [
                      // Replace with your actual logo asset later
                      const Icon(Icons.school, size: 80, color: Color(0xFF003087)),
                      const SizedBox(height: 16),
                      const Text(
                        "Bandari Student Portal",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003087),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Sign in to continue",
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60),

                // Fields
                CustomTextField(
                  label: "Email or Phone",
                  hint: "student@bandari.ac.tz",
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Please enter your email/phone";
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
                    if (value == null || value.isEmpty) return "Please enter your password";
                    if (value.length < 6) return "Password must be at least 6 characters";
                    return null;
                  },
                ),

                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Forgot password screen
                    },
                    child: const Text("Forgot Password?"),
                  ),
                ),

                const SizedBox(height: 32),

                PrimaryButton(
                  label: "Sign In",
                  isLoading: _isLoading,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() => _isLoading = true);
                      // TODO: Call your login API here
                      Future.delayed(const Duration(seconds: 2), () {
                        setState(() => _isLoading = false);
                        // Navigate to home on success
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
                    const Text("Don't have an account? "),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RegisterScreen()),
                        );
                      },
                      child: const Text("Register"),
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}