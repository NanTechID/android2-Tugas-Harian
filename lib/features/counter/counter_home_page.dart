import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'counter_bloc.dart';
import 'counter_bloc_page.dart';
import 'counter_riverpod_page.dart';

class CounterHomePage extends StatelessWidget {
  const CounterHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter Praktikum')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const CounterRiverpodPage(),
                  ),
                );
              },
              child: const Text('Riverpod Counter'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider<CounterBloc>(
                      create: (_) => CounterBloc(),
                      child: const CounterBlocPage(),
                    ),
                  ),
                );
              },
              child: const Text('BLoC Counter'),
            ),
          ],
        ),
      ),
    );
  }
}
