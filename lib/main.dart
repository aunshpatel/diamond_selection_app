import 'package:diamond_selection_app/screens/filter_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/diamond_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DiamondBloc(),
      child: MaterialApp(
        title: 'Diamond App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FilterPage(),
      ),
    );
  }
}