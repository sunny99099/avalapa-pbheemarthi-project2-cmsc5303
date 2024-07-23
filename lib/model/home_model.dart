import 'package:firebase_auth/firebase_auth.dart';
import 'package:lesson6/model/item_model.dart';

class HomeModel {
  User user;
  HomeModel(this.user);
   List<Item> ItemList = [];

  String? validatety(String? value) {
    if (value == null || value.isEmpty) {
      return 'No password provided';
    } else if (value.length < 2) {
      return 'Min char is 2';
    } else {
      return null;
    }
  }
}

class ItemModel {
  final String name;
  int quantity;

  ItemModel({
    required this.name,
    this.quantity = 0, 
  });

  
  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      name: map['name'] ?? '',
      quantity: map['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> itemMap() {
    return {
      'name': name,
      'quantity': quantity,
    };
  }
}

