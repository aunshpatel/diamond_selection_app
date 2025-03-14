import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/diamond_bloc.dart';
import '../models/diamondModel.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Diamond Results')),
      body: BlocBuilder<DiamondBloc, DiamondState>(
        builder: (context, state) {
          if (state is DiamondLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is DiamondLoaded) {
            final List<Diamond> diamonds = state.diamonds;

            if (diamonds.isEmpty) {
              return Center(child: Text('No diamonds match the selected criteria.'));
            }

            return ListView.builder(
              itemCount: diamonds.length,
              itemBuilder: (context, index) {
                final diamond = diamonds[index];
                return ListTile(
                  leading: Text("${index+1}) ", style: TextStyle(fontSize: 18)),
                  title: Text("Lot ID: ${diamond.lotID}", style: TextStyle(fontSize: 16)),
                  subtitle: Text(
                      "Carat: ${diamond.carat}, Shape: ${diamond.shape}, Color: ${diamond.color}, Clarity: ${diamond.clarity}",
                      style: TextStyle(fontSize: 14)
                  ),
                  trailing: Text("\$${diamond.finalAmount}", style: TextStyle(fontSize: 16)),
                );
              },
            );
          } else {
            return Center(child: Text('Unexpected state. Please try again.'));
          }
        },
      ),
    );
  }
}
