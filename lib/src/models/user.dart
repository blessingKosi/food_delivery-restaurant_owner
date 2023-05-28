import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  static const NAME = 'name';
  static const EMAIL = 'email';
  static const ID = 'id';
  //static const LIKED_FOOD = 'likedFood';
  //static const Liked_Restaurants = 'likedRestaurants';
  static const STRIPE_ID = "stripeId";
  static const CART = 'cart';

  String _name;
  String _email;
  String _id;
  //List _likedFood;
  //List _likedRestaurants;
  String _stripeId;
  int _priceSum = 0;
  //int _quantitySum = 0;

  //getters

  String get name => _name;
  String get email => _email;
  String get id => _id;
  //List get likedFood => _likedFood;
  //List get likedRestaurants => _likedRestaurants;
  String get stripeId => _stripeId;

  //public variable
  List cart;
  int totalCartPrice;

  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    _name = snapshot.data()[NAME];
    _email = snapshot.data()[EMAIL];
    _id = snapshot.data()[ID];
    //_likedFood = snapshot.data()[LIKED_FOOD] ?? [];
    //_likedRestaurants = snapshot.data()[Liked_Restaurants] ?? [];
    _stripeId = snapshot.data()[STRIPE_ID];
    cart = snapshot.data()[CART] ?? [];
    totalCartPrice = getTotalPrice(cart: snapshot.data()[CART]);
  }

  int getTotalPrice({List cart}) {
    for (Map cartItem in cart) {
      _priceSum += cartItem['price'] * cartItem['quantity'];
    }
    int total = _priceSum;

    print('THE TOTAL IS: $total');
    print('THE TOTAL IS: $total');
    print('THE TOTAL IS: $total');

    return total;
  }

  // List<CartItemModel> _convertcartItems(List<Map> cart) {
  //   List<CartItemModel> convertedCart = [];
  //   for (Map cartItem in cart) {
  //     convertedCart.add(CartItemModel.fromMap(cartItem));
  //   }
  //   return convertedCart;
  // }
}
