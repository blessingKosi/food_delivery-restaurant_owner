import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/restaurant.dart';

class RestaurantServices {
  String collection = 'restaurants';
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<RestaurantModel>> getRestaurants() async =>
      _firestore.collection(collection).get().then((result) {
        List<RestaurantModel> restaurants = [];
        for (DocumentSnapshot restaurant in result.docs) {
          restaurants.add(RestaurantModel.fromSnapsot(restaurant));
        }

        return restaurants;
      });

  Future<RestaurantModel> getRestaurantById({String id}) => _firestore
          .collection(collection)
          .doc(id.toString())
          .get()
          .then((document) {
        return RestaurantModel.fromSnapsot(document);
      });

  Future<List<RestaurantModel>> searchRestaurant({String restaurantName}) {
    String searchKey = restaurantName[0].toUpperCase() +
        restaurantName.substring(1); // converting first character to uppercase
    return _firestore
        .collection(collection)
        .orderBy('name')
        .startAt([searchKey])
        .endAt([searchKey + '\uf8ff'])
        .get()
        .then(
          (result) {
            List<RestaurantModel> restaurants = [];
            for (DocumentSnapshot restaurant in result.docs) {
              restaurants.add(RestaurantModel.fromSnapsot(restaurant));
            }
            return restaurants;
          },
        );
  }
}
