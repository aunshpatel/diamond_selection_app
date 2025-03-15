import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String _selectedPriceOrder = "Default";
  String _selectedCaratOrder = "Default";
  Set<String> cartItems = {};

  @override
  void initState() {
    super.initState();
    _loadCartState();
  }

  void _loadCartState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      cartItems = prefs.getStringList('cartItems')?.toSet() ?? {};
    });
  }

  void _updateCartState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('cartItems', cartItems.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text('Diamond Results', style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0XFF3A4355)
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Final Price Filter:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    buildSortDropdown(_selectedPriceOrder, ["Default", "Low to High", "High to Low"],
                          (value) {
                        setState(() {
                          _selectedPriceOrder = value;
                        });

                        context.read<DiamondBloc>().add(
                          SortDiamonds(
                            sortBy: "price",
                            ascending: value == "Low to High" ? true : value == "High to Low" ? false : null,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Carat Weight Filter:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    buildSortDropdown(_selectedCaratOrder, ["Default", "Low to High", "High to Low"],
                          (value) {
                        setState(() {
                          _selectedCaratOrder = value;
                        });

                        context.read<DiamondBloc>().add(
                          SortDiamonds(
                            sortBy: "carat",
                            ascending: value == "Low to High" ? true : value == "High to Low" ? false : null,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<DiamondBloc, DiamondState>(
              builder: (context, state) {
                if (state is DiamondLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is DiamondLoaded) {
                  final List<Diamond> diamonds = state.diamonds;

                  if (diamonds.isEmpty) {
                    return Center(child: Text('No diamonds match the selected criteria.', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)));
                  }

                  return ListView.builder(
                    itemCount: diamonds.length,
                    itemBuilder: (context, index) {
                      final diamond = diamonds[index];
                      bool isInCart = cartItems.contains(diamond.lotID);

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
                                    child: Text(
                                      "${index + 1}) Lot ID: ${diamond.lotID}",
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Material(
                                      color: isInCart ? Color.fromARGB(128, 58, 67, 85) : Color(0XFF3A4355),
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: MaterialButton(
                                        onPressed: isInCart ? null : () {
                                          context.read<CartBloc>().add(AddToCart(diamond));
                                          setState(() {
                                            cartItems.add(diamond.lotID);
                                            _updateCartState();
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("${diamond.lotID} added to cart")),
                                          );
                                        },
                                        minWidth: 50.0,
                                        child: Text(
                                          isInCart ? 'Added to Cart' : 'Add to Cart',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
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
                              Text(
                                "Final Amount: \$${diamond.finalAmount.toStringAsFixed(2)}",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                              ),
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
                  return Center(child: Text('Unexpected state. Please try again.', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CartPage()),
          ).then((_) {
            setState(() {
              _loadCartState();
            });
          });
        },
        backgroundColor: Color(0XFF3A4355),
        child: const Icon(Icons.shopping_cart, color: Colors.white),
      ),
    );
  }

  Widget buildSortDropdown(String selectedValue, List<String> options, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: DropdownButton<String>(
        value: selectedValue,
        onChanged: (value) => onChanged(value!),
        items: options.map((label) {
          return DropdownMenuItem(
            value: label,
            child: Text(label),
          );
        }).toList(),
      ),
    );
  }
}
