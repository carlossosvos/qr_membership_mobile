import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../../../core/widgets/atoms/app_button.dart';
import '../../../core/widgets/atoms/app_title.dart';
import '../../../core/widgets/atoms/app_icon.dart';
import '../../../core/widgets/atoms/app_text.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  Timer? _verificationTimer;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _startVerificationCheck();
  }

  @override
  void dispose() {
    _verificationTimer?.cancel();
    super.dispose();
  }

  void _startVerificationCheck() {
    // Check every 3 seconds for verification
    _verificationTimer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) => _checkVerificationStatus(),
    );
  }

  void _checkVerificationStatus() {
    context.read<AuthCubit>().reloadUser();
  }

  Future<void> _resendVerificationEmail() async {
    setState(() => _isResending = true);

    try {
      await context.read<AuthCubit>().sendEmailVerification();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification email sent!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending email: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Email was verified! Timer will be disposed automatically
            _verificationTimer?.cancel();
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          String userEmail = '';
          if (state is AuthEmailNotVerified) {
            userEmail = state.user.email ?? '';
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon
                  const AppIcon(icon: Icons.mark_email_unread_outlined),

                  const SizedBox(height: 32),

                  // Title
                  AppTitle(
                    title: 'Verify Your Email',
                    subtitle: 'We sent a verification email to: $userEmail',
                  ),

                  const SizedBox(height: 24),

                  // Instructions
                  const AppText.body(
                    text:
                        'Please check your email and click the verification link. This page will automatically update once verified.',
                  ),

                  const SizedBox(height: 32),

                  // Resend button
                  AppButton(
                    text: 'Resend Email',
                    onPressed: _resendVerificationEmail,
                    isLoading: _isResending,
                  ),

                  const SizedBox(height: 16),

                  // Sign out option
                  TextButton(
                    onPressed: () => context.read<AuthCubit>().signOut(),
                    child: Text(
                      'Sign out',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
