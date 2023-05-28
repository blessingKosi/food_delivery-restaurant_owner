import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_delivery_restaurant/src/models/cart_item.dart';

class OrderModel {
  static const ID = 'id';
  static const DESCRIPTION = 'description';
  static const CART = 'cart';
  static const USER_ID = 'userId';
  static const TOTAL = 'total';
  static const STATUS = 'status';
  static const CREATED_AT = 'createdAt';
  static const RESTAURANT_ID = 'restaurantId';

  String _id;
  String _description;
  String _userId;
  String _status;
  int _total;
  int _createdAt;
  String _restaurantId;

  // getters

  String get id => _id;
  String get description => _description;

  String get userId => _userId;
  String get status => _status;
  int get total => _total;
  int get createdAt => _createdAt;
  String get restaurantId => _restaurantId;

  // public variable
  List<CartItemModel> cart;

  OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.data()[ID];
    _description = snapshot.data()[DESCRIPTION];
    _total = snapshot.data()[TOTAL];
    _status = snapshot.data()[STATUS];
    _createdAt = snapshot.data()[CREATED_AT];
    _userId = snapshot.data()[USER_ID];
    cart = _convertcartItems(snapshot.data()[CART], _createdAt);
  }

  List<CartItemModel> _convertcartItems(List cart, int _createdAt) {
    List<CartItemModel> convertedCart = [];
    for (Map cartItem in cart) {
      convertedCart.add(CartItemModel.fromMap(cartItem, createdAt));
    }
    return convertedCart;
  }
}
