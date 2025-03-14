import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/cart_bloc.dart';
import '../blocs/diamond_bloc.dart';
import '../models/diamondModel.dart';
import 'cart_page.dart';

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
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text("${index + 1}) Lot ID: ${diamond.lotID}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                context.read<CartBloc>().add(AddToCart(diamond));
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("${diamond.lotID} added to cart"))
                                );
                              },
                              child: const Text("Add to Cart"),
                            ),
                          ],
                        ),
                        Divider(),
                        Text("Carat: ${diamond.carat} ct", style: TextStyle(fontSize: 16)),
                        Text("Size: ${diamond.size}", style: TextStyle(fontSize: 16)),
                        Text("Shape: ${diamond.shape}", style: TextStyle(fontSize: 16)),
                        Text("Lab: ${diamond.lab}", style: TextStyle(fontSize: 16)),
                        Text("Color: ${diamond.color}", style: TextStyle(fontSize: 16)),
                        Text("Clarity: ${diamond.clarity}", style: TextStyle(fontSize: 16)),
                        Text("Cut: ${diamond.cut}", style: TextStyle(fontSize: 16)),
                        Text("Polish: ${diamond.polish}", style: TextStyle(fontSize: 16)),
                        Text("Symmetry: ${diamond.symmetry}", style: TextStyle(fontSize: 16)),
                        Text("Fluorescence: ${diamond.fluorescence}", style: TextStyle(fontSize: 16)),
                        Text("Discount: ${diamond.discount}%", style: TextStyle(fontSize: 16, color: Colors.red)),
                        Text("Per Carat Rate: \$${diamond.perCaratRate.toStringAsFixed(2)}", style: TextStyle(fontSize: 16)),
                        Text("Final Amount: \$${diamond.finalAmount.toStringAsFixed(2)}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                        SizedBox(height: 5),
                        Text("Key To Symbol: ${diamond.keyToSymbol}", style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
                        Text("Lab Comment: ${diamond.labComment}", style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('Unexpected state. Please try again.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartPage()),
          );
        },
        backgroundColor: Color(0XFF3A4355),
        child: const Icon(Icons.shopping_cart, color: Colors.white,),
      ),
    );
  }
}
