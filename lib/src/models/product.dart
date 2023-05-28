import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  static const ID = 'id';
  static const NAME = 'name';
  static const IMAGE = 'image';
  static const RATING = 'rating';
  static const PRICE = 'price';
  static const RESTAURANT_ID = 'restaurantId';
  static const RESTAURANT = 'restaurant';
  static const DESCRIPTION = "description";
  static const CATEGORY = 'category';
  static const FEATURED = 'featured';
  static const RATES = "rates";

  String _id;
  String _name;
  String _image;
  double _rating;
  double _price;
  String _restaurantId;
  String _restaurant;
  String _description;
  String _category;
  bool _featured;
  int _rates;

  // getters

  String get id => _id;
  String get name => _name;
  String get image => _image;
  double get rating => _rating;
  double get price => _price;
  String get restaurantId => _restaurantId;
  String get restaurant => _restaurant;
  String get description => _description;
  String get category => _category;
  bool get featured => _featured;
  int get rates => _rates;

  ProductModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.data()[ID];
    _name = snapshot.data()[NAME];
    _image = snapshot.data()[IMAGE];
    _rating = snapshot.data()[RATING];
    _price = snapshot.data()[PRICE].floorToDouble();
    _restaurantId = snapshot.data()[RESTAURANT_ID];
    _restaurant = snapshot.data()[RESTAURANT];
    _description = snapshot.data()[DESCRIPTION];
    _category = snapshot.data()[CATEGORY];
    _featured = snapshot.data()[FEATURED];
    _rates = snapshot.data()[RATES];
  }
}
