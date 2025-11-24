import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_membership_poc/setup.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'features/auth/data/auth_service.dart';
import 'routes/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(AuthService()),
      child: Builder(
        builder: (context) {
          final authCubit = context.read<AuthCubit>();

          return MaterialApp.router(
            title: 'QR Membership POC',
            theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
            routerConfig: AppRouter.router(authCubit),
          );
        },
      ),
    );
  }
}
