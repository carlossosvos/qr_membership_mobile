import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/organisms/auth_form_switcher.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoginMode = true;

  void _handleLogin(String email, String password) {
    context.read<AuthCubit>().signIn(email: email, password: password);
  }

  void _handleRegister(String name, String email, String password) {
    context.read<AuthCubit>().signUp(
      email: email,
      password: password,
      displayName: name,
    );
  }

  void _handleForgotPassword() {
    // TODO: Implement forgot password logic
    // You could show a dialog or navigate to a forgot password screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Forgot password functionality coming soon!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
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
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: AuthFormSwitcher(
              onLogin: _handleLogin,
              onRegister: _handleRegister,
              onForgotPassword: _handleForgotPassword,
              isLoading: isLoading,
            ),
          );
        },
      ),
    );
  }
}
