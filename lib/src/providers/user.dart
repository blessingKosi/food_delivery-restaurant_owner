import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_restaurant/src/helpers/order.dart';
import 'package:food_delivery_restaurant/src/helpers/product.dart';
import 'package:food_delivery_restaurant/src/helpers/restaurant.dart';
import 'package:food_delivery_restaurant/src/helpers/user.dart';
import 'package:food_delivery_restaurant/src/models/cart_item.dart';
import 'package:food_delivery_restaurant/src/models/order.dart';
import 'package:food_delivery_restaurant/src/models/product.dart';

import 'package:food_delivery_restaurant/src/models/restaurant.dart';
import 'package:image_picker/image_picker.dart';

enum Status { Uninitialized, Unauthenticated, Authenticating, Authenticated }

class UserProvider with ChangeNotifier {
  FirebaseAuth _auth;
  User _user;
  Status _status = Status.Uninitialized;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  UserServices _userServices = UserServices();
  OrderServices _orderServices = OrderServices();
  RestaurantServices _restaurantServices = RestaurantServices();
  ProductServices _productServices = ProductServices();
  RestaurantModel _restaurant;
  List<ProductModel> products = <ProductModel>[];
  List<CartItemModel> cartItems = [];
  double _totalSales = 0;
  double _avgPrice = 0;
  double _restaurantRating = 0;

  //  getters
  Status get status => _status;
  User get user => _user;
  RestaurantModel get restaurant => _restaurant;
  double get totalSales => _totalSales;
  double get avgPrice => _avgPrice;
  double get restaurantRating => _restaurantRating;

  // public variables
  List<OrderModel> orders = [];

  final formKey = GlobalKey<FormState>();

  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();

  File restaurantImage;
  String restaurantImageFileName;
  final picker = ImagePicker();

  UserProvider.initialize() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onStateChanged);
  }

  Future<bool> signIn() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(
        email: email.text.trim(),
        password: password.text.trim(),
      );
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future<bool> signUp() async {
    try{
_status = Status.Authenticating;
      notifyListeners();
      await _auth
          .createUserWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((result) async {
            String imageUrl =
          await _uploadImageFile(imageFile: restaurantImage, imageFileName: restaurantImageFileName);
        _firestore.collection('restaurants').doc(result.user.uid).set({
          'name': name.text,
          'email': email.text,
          'id': result.user.uid,
          'avgPrice': 0.0,
          'image': imageUrl,
          'popular': false,
          'rates': 0,
          'rating': 0.0,
          // 'likedFood': [],
          // 'likedRestaurants': [],
        });
      });
      return true;
    } catch(e) {
_status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  // Future<bool> signUp() async {
  //   try {
  //     String imageUrl =
  //         await _uploadImageFile(imageFile: restaurantImage, imageFileName: restaurantImageFileName);
  //     _status = Status.Authenticating;
  //     notifyListeners();
  //     await _auth
  //         .createUserWithEmailAndPassword(
  //             email: email.text.trim(), password: password.text.trim())
  //         .then((result) {
  //       _firestore.collection('restaurants').doc(result.user.uid).set({
  //         'name': name.text,
  //         'email': email.text,
  //         'id': result.user.uid,
  //         'avgPrice': 0.0,
  //         'image': imageUrl,
  //         'popular': false,
  //         'rates': 0,
  //         'rating': 0.0,
  //         // 'likedFood': [],
  //         // 'likedRestaurants': [],
  //       });
  //     });
  //     return true;
  //   } catch (e) {
  //     _status = Status.Unauthenticated;
  //     notifyListeners();
  //     print(e.toString());
  //     return false;
  //   }
  // }

  Future signOut() {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  void clearController() {
    email.text = '';
    password.text = '';
    name.text = '';
  }

  Future<void> reload() async {
    _restaurant = await _restaurantServices.getRestaurantById(id: user.uid);
    await loadProductsByRestaurant(restaurantId: user.uid);
    await getOrders();
    await getTotalSales();
    await getAvgPrice();
    notifyListeners();
  }

  Future<void> _onStateChanged(User user) async {
    if (user == null) {
      _status = Status.Uninitialized;
    } else {
      _user = user;
      _status = Status.Authenticated;
      await loadProductsByRestaurant(restaurantId: user.uid);
      await getOrders();
      await getTotalSales();
      await getAvgPrice();
      _restaurant = await _restaurantServices.getRestaurantById(id: user.uid);
    }
    notifyListeners();
  }


// method to load image file
  getImageFile({ImageSource source}) async {
    final pickedFile =
        await picker.getImage(source: source, maxWidth: 640, maxHeight: 400);
    restaurantImage = File(pickedFile.path);

    restaurantImageFileName =
        restaurantImage.path.substring(restaurantImage.path.indexOf('/') + 1);
    print('THIS IS:$restaurantImageFileName');
    print('THIS IS:$restaurantImageFileName');
    print('THIS IS:$restaurantImageFileName');
    print('THIS IS:$restaurantImageFileName');
    notifyListeners();
  }

  // method to upload the file to firebase
  Future _uploadImageFile({File imageFile, String imageFileName}) async {
    Reference reference = FirebaseStorage.instance.ref().child(imageFileName);
    UploadTask uploadTask = reference.putFile(imageFile);
    String imageUrl;

    await uploadTask.whenComplete(() async {
      imageUrl = await uploadTask.snapshot.ref.getDownloadURL();
    });
    return imageUrl;
  }


  getOrders() async {
    orders = await _orderServices.restaurantOrders(restaurantId: _user.uid);
    notifyListeners();
  }

  getTotalSales() async {
    for (OrderModel order in orders) {
      for (CartItemModel item in order.cart) {
        if (item.restaurantId == user.uid) {
          _totalSales = _totalSales + item.totalRestaurantSales;
          cartItems.add(item);
        }
      }
    }
    _totalSales = _totalSales * 1;
    notifyListeners();
  }

  getAvgPrice() {
    if (products.length != 0) {
      int amountSum = 0;
      for (ProductModel product in products) {
        amountSum = product.price.floor();
      }
      _avgPrice = amountSum / products.length;
    }
    notifyListeners();
  }

  getRating() {
    if (_restaurant.rates != 0) {
      _restaurantRating = restaurantRating / restaurant.rates;
    }
  }

  Future<bool> removeFromCart({Map cartItem}) async {
    print('THE PRODUCT IS: ${cartItem.toString()}');

    try {
      _userServices.removeFromCart(userId: _user.uid, cartItem: cartItem);
      return true;
    } catch (e) {
      print('THE ERROR ${e.toString()}');
      return false;
    }
  }

  Future loadProductsByRestaurant({String restaurantId}) async {
    products = await _productServices.getProductsByRestaurant(id: restaurantId);
    notifyListeners();
  }
}
