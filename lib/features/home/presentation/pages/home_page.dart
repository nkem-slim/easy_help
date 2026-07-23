import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy Help'),
        actions: [],
        automaticallyImplyLeading: false, // this removes the back button
      ),
      body: const Center(child: Text('Home dashboard — TODO')),
    );
  }
}
