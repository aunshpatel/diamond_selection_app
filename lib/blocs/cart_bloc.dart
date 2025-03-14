import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/diamondModel.dart';

abstract class CartEvent {}

class AddToCart extends CartEvent {
  final Diamond diamond;
  AddToCart(this.diamond);
}

class RemoveFromCart extends CartEvent {
  final Diamond diamond;
  RemoveFromCart(this.diamond);
}

class LoadCart extends CartEvent {}

class CartState {
  final List<Diamond> cartDiamonds;
  CartState(this.cartDiamonds);
}

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState([])) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<LoadCart>(_onLoadCart);
  }

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    final updatedCart = List<Diamond>.from(state.cartDiamonds)..add(event.diamond);
    emit(CartState(updatedCart));
    await _saveCart(updatedCart);
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) async {
    final updatedCart = List<Diamond>.from(state.cartDiamonds)
      ..removeWhere((d) => d.lotID == event.diamond.lotID);
    emit(CartState(updatedCart));
    await _saveCart(updatedCart);
  }

  void _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    final savedCart = await _loadCart();
    emit(CartState(savedCart));
  }

  Future<void> _saveCart(List<Diamond> cart) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedData = jsonEncode(cart.map((d) => d.toJson()).toList());
    await prefs.setString('cart', encodedData);
  }

  Future<List<Diamond>> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cartData = prefs.getString('cart');
    if (cartData == null) return [];
    final List<dynamic> decodedData = jsonDecode(cartData);
    return decodedData.map((item) => Diamond.fromJson(item)).toList();
  }
}