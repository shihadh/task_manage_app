import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/text_const.dart';
import '../../../core/theme/color_const.dart';
import '../controller/auth_controller.dart';
import '../../tasks/view/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authController = context.read<AuthController>();
      final success = await authController.login(
        _usernameController.text,
        _passwordController.text,
      );

      if (success && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              authController.errorMessage ?? TextConst.auth['loginFailed']!,
            ),
            backgroundColor: ColorConst.red,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient and Shapes
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0F0C29),
                  Color(0xFF302B63),
                  Color(0xFF24243E),
                ],
              ),
            ),
          ),
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6A11CB).withOpacity(0.2),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF2575FC).withOpacity(0.2),
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Premium Logo Section
                    TweenAnimationBuilder<double>(
                      duration: const Duration(seconds: 1),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: ColorConst.white.withOpacity(0.1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: ColorConst.white.withOpacity(0.2),
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.auto_graph_rounded,
                              size: 72,
                              color: ColorConst.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            TextConst.auth['appName']!,
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              color: ColorConst.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                          Text(
                            TextConst.auth['appSlogan']!,
                            style: TextStyle(
                              fontSize: 16,
                              color: ColorConst.white.withOpacity(0.6),
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),

                    // Glassmorphism Card
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                          child: Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: ColorConst.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                color: ColorConst.white.withOpacity(0.2),
                                width: 1.5,
                              ),
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    TextConst.auth['loginTitle']!,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: ColorConst.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    TextConst.auth['loginSubtitle']!,
                                    style: TextStyle(
                                      color: ColorConst.white.withOpacity(0.5),
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  _buildTextField(
                                    controller: _usernameController,
                                    label: TextConst.auth['usernameLabel']!,
                                    icon: Icons.alternate_email_rounded,
                                    validator: (v) => v!.isEmpty
                                        ? TextConst.auth['usernameRequired']
                                        : null,
                                  ),
                                  const SizedBox(height: 20),
                                  _buildTextField(
                                    controller: _passwordController,
                                    label: TextConst.auth['passwordLabel']!,
                                    icon: Icons.lock_outline_rounded,
                                    isPassword: true,
                                    validator: (v) => v!.isEmpty
                                        ? TextConst.auth['passwordRequired']
                                        : null,
                                  ),
                                  const SizedBox(height: 40),
                                  Consumer<AuthController>(
                                    builder: (context, auth, _) {
                                      return _buildPremiumButton(
                                        onPressed: auth.isLoading
                                            ? null
                                            : _handleLogin,
                                        isLoading: auth.isLoading,
                                        text: TextConst.auth['loginButton']!,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      style: const TextStyle(color: ColorConst.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: ColorConst.white.withOpacity(0.5)),
        prefixIcon: Icon(icon, color: ColorConst.white.withOpacity(0.7)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: ColorConst.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: ColorConst.white),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        filled: true,
        fillColor: ColorConst.white.withOpacity(0.05),
      ),
    );
  }

  Widget _buildPremiumButton({
    required VoidCallback? onPressed,
    required bool isLoading,
    required String text,
  }) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: onPressed == null
              ? [Colors.grey.shade800, Colors.grey.shade900]
              : [const Color(0xFF6A11CB), const Color(0xFF2575FC)],
        ),
        boxShadow: onPressed == null
            ? []
            : [
                BoxShadow(
                  color: const Color(0xFF6A11CB).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: ColorConst.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
