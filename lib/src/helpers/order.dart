import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:food_delivery_restaurant/src/models/order.dart';

class OrderServices {
  String collection = 'orders';
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void createOrder(
      {String userId,
      String id,
      String description,
      String status,
      List cart,
      int totalPrice}) {
    _firestore.collection(collection).doc(id).set({
      'userId': userId,
      'id': id,
      'cart': cart,
      'total': totalPrice,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'description': description,
      'status': status
    });
  }

  Future<List<OrderModel>> restaurantOrders({String restaurantId}) async => _firestore
          .collection(collection)
          .where('restaurantIds', arrayContains: restaurantId)
          .get()
          .then(
        (result) {
          List<OrderModel> orders = [];
          for (DocumentSnapshot order in result.docs) {
            orders.add(OrderModel.fromSnapshot(order));
          }
          print('NUMBER OF ORDERS: ${orders.length.toString()}');
          print('NUMBER OF ORDERS: ${orders.length.toString()}');
          print('NUMBER OF ORDERS: ${orders.length.toString()}');
          print('NUMBER OF ORDERS: ${orders.length.toString()}');
          print('NUMBER OF ORDERS: ${orders.length.toString()}');
          return orders;
        },
      );
}
