import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../blocs/cart_bloc.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(LoadCart());
  }

  Future<void> _updateCartState(String lotID, bool isAdded) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartItems = prefs.getStringList('cartItems') ?? [];

    if (isAdded) {
      if (!cartItems.contains(lotID)) {
        cartItems.add(lotID);
      }
    } else {
      cartItems.remove(lotID);
    }

    await prefs.setStringList('cartItems', cartItems);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.cartDiamonds.isEmpty) {
            return const Center(child: Text("Your cart is empty.", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),);
          }

          double totalCarat = state.cartDiamonds.fold(0, (sum, d) => sum + d.carat);
          double totalPrice = state.cartDiamonds.fold(0, (sum, d) => sum + d.finalAmount);
          double avgPrice = totalPrice / (state.cartDiamonds.isEmpty ? 1 : state.cartDiamonds.length);
          double avgDiscount = state.cartDiamonds.fold(0.0, (sum, d) => sum + d.discount) / (state.cartDiamonds.isEmpty ? 1 : state.cartDiamonds.length);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: state.cartDiamonds.length,
                  itemBuilder: (context, index) {
                    final diamond = state.cartDiamonds[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                                  child: Text("${index + 1}) Lot ID: ${diamond.lotID}",
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    context.read<CartBloc>().add(RemoveFromCart(diamond));
                                    await _updateCartState(diamond.lotID, false);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("${diamond.lotID} removed from cart")),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const Divider(),
                            Text("Carat: ${diamond.carat} ct", style: const TextStyle(fontSize: 16)),
                            Text("Size: ${diamond.size}", style: const TextStyle(fontSize: 16)),
                            Text("Shape: ${diamond.shape}", style: const TextStyle(fontSize: 16)),
                            Text("Lab: ${diamond.lab}", style: const TextStyle(fontSize: 16)),
                            Text("Color: ${diamond.color}", style: const TextStyle(fontSize: 16)),
                            Text("Clarity: ${diamond.clarity}", style: const TextStyle(fontSize: 16)),
                            Text("Cut: ${diamond.cut}", style: const TextStyle(fontSize: 16)),
                            Text("Polish: ${diamond.polish}", style: const TextStyle(fontSize: 16)),
                            Text("Symmetry: ${diamond.symmetry}", style: const TextStyle(fontSize: 16)),
                            Text("Fluorescence: ${diamond.fluorescence}", style: const TextStyle(fontSize: 16)),
                            Text("Discount: ${diamond.discount}%", style: const TextStyle(fontSize: 16, color: Colors.red)),
                            Text("Per Carat Rate: \$${diamond.perCaratRate.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16)),
                            Text("Final Amount: \$${diamond.finalAmount.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                            const SizedBox(height: 5),
                            Text("Key To Symbol: ${diamond.keyToSymbol}", style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
                            Text("Lab Comment: ${diamond.labComment}", style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("Total Carat: $totalCarat"),
                    Text("Total Price: \$${totalPrice.toStringAsFixed(2)}"),
                    Text("Average Price: \$${avgPrice.toStringAsFixed(2)}"),
                    Text("Average Discount: ${avgDiscount.toStringAsFixed(2)}%"),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
