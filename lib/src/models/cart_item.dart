class CartItemModel {
  static const ID = "id";
  static const NAME = "name";
  static const IMAGE = "image";
  static const PRODUCT_ID = "productId";
  static const QUANTITY = "quantity";
  static const PRICE = "price";
  static const RESTAURANT_ID = "restaurantId";
  static const TOTAL_RESTAURANT_SALES = "totalRestaurantSales";

  String _id;
  String _name;
  String _image;
  String _productId;
  int _quantity;
  int _price;
  String _restaurantId;
  int _totalRestaurantSales;
  int _date;

  //  getters
  String get id => _id;

  String get name => _name;

  String get image => _image;

  String get productId => _productId;

  int get price => _price;

  int get quantity => _quantity;

  String get restaurantId => _restaurantId;

  int get totalRestaurantSales => _totalRestaurantSales;

  int get date => _date;

  CartItemModel.fromMap(Map data, int createdAt) {
    _id = data[ID];
    _name = data[NAME];
    _image = data[IMAGE];
    _productId = data[PRODUCT_ID];
    _price = data[PRICE].floor();
    _quantity = data[QUANTITY];
    _restaurantId = data[RESTAURANT_ID];
    _totalRestaurantSales = data[TOTAL_RESTAURANT_SALES].floor();
    _date = createdAt;
  }

  Map toMap() => {
        ID: _id,
        IMAGE: _image,
        NAME: _name,
        PRODUCT_ID: _productId,
        QUANTITY: _quantity,
        PRICE: _price,
        RESTAURANT_ID: _restaurantId,
        TOTAL_RESTAURANT_SALES: _totalRestaurantSales,
      };
}
