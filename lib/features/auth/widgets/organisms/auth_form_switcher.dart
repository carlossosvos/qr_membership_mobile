import 'package:flutter/material.dart';
import '../../../../core/widgets/atoms/app_title.dart';
import '../../../../core/widgets/atoms/app_toggle_text.dart';
import '../molecules/login_form.dart';
import '../molecules/register_form.dart';

// Organism - Complete auth switching widget
class AuthFormSwitcher extends StatefulWidget {
  final Function(String email, String password) onLogin;
  final Function(String name, String email, String password) onRegister;
  final VoidCallback onForgotPassword;
  final bool isLoading;

  const AuthFormSwitcher({
    super.key,
    required this.onLogin,
    required this.onRegister,
    required this.onForgotPassword,
    this.isLoading = false,
  });

  @override
  State<AuthFormSwitcher> createState() => _AuthFormSwitcherState();
}

class _AuthFormSwitcherState extends State<AuthFormSwitcher>
    with SingleTickerProviderStateMixin {
  bool isLoginMode = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Controllers for login
  final TextEditingController _loginEmailController = TextEditingController();
  final TextEditingController _loginPasswordController =
      TextEditingController();

  // Controllers for register
  final TextEditingController _registerNameController = TextEditingController();
  final TextEditingController _registerEmailController =
      TextEditingController();
  final TextEditingController _registerPasswordController =
      TextEditingController();
  final TextEditingController _registerConfirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _registerNameController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _registerConfirmPasswordController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      isLoginMode = !isLoginMode;
      _animationController.reset();
      _animationController.forward();
    });
  }

  void _handleLogin() {
    widget.onLogin(
      _loginEmailController.text.trim(),
      _loginPasswordController.text,
    );
  }

  void _handleRegister() {
    widget.onRegister(
      _registerNameController.text.trim(),
      _registerEmailController.text.trim(),
      _registerPasswordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 60),

          // Title section
          AppTitle(
            title: isLoginMode ? 'Welcome Back' : 'Create Account',
            subtitle: isLoginMode
                ? 'Sign in to access your QR membership'
                : 'Join us to get your QR membership',
          ),

          const SizedBox(height: 48),

          // Form section with animation
          FadeTransition(
            opacity: _fadeAnimation,
            child: isLoginMode
                ? LoginForm(
                    emailController: _loginEmailController,
                    passwordController: _loginPasswordController,
                    onSubmit: _handleLogin,
                    onForgotPassword: widget.onForgotPassword,
                    isLoading: widget.isLoading,
                  )
                : RegisterForm(
                    nameController: _registerNameController,
                    emailController: _registerEmailController,
                    passwordController: _registerPasswordController,
                    confirmPasswordController:
                        _registerConfirmPasswordController,
                    onSubmit: _handleRegister,
                    isLoading: widget.isLoading,
                  ),
          ),

          const SizedBox(height: 32),

          // Toggle section
          AppToggleText(
            question: isLoginMode
                ? "Don't have an account?"
                : "Already have an account?",
            actionText: isLoginMode ? 'Sign Up' : 'Sign In',
            onPressed: _toggleMode,
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
