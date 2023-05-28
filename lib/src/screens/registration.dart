import 'package:flutter/material.dart';
import 'package:food_delivery_restaurant/src/helpers/screen_navigation.dart';
import 'package:food_delivery_restaurant/src/helpers/style.dart';
import 'package:food_delivery_restaurant/src/providers/user.dart';
import 'package:food_delivery_restaurant/src/screens/dashboard.dart';
import 'package:food_delivery_restaurant/src/widgets/custom_file_button.dart';
import 'package:food_delivery_restaurant/src/widgets/custom_text.dart';
import 'package:food_delivery_restaurant/src/widgets/loading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'login.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<UserProvider>(context);
//    final categoryProvider = Provider.of<CategoryProvider>(context);
//    final restaurantProvider = Provider.of<RestaurantProvider>(context);
    // final productProvider = Provider.of<ProductProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      key: _key,
      backgroundColor: white,
      body: authProvider.status == Status.Authenticating
          ? Center(child: Loading())
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 100,
                  ),
                  Container(
                    height: 130,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: userProvider?.restaurantImage == null
                              ? CustomFileUploadButton(
                                  icon: Icons.image,
                                  text: "Add image",
                                  onTap: () async {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext bc) {
                                        return Container(
                                          child: new Wrap(
                                            children: <Widget>[
                                              new ListTile(
                                                leading: new Icon(Icons.image),
                                                title: new Text('From gallery'),
                                                onTap: () async {
                                                  userProvider.getImageFile(
                                                      source:
                                                          ImageSource.gallery);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              new ListTile(
                                                leading:
                                                    new Icon(Icons.camera_alt),
                                                title:
                                                    new Text('Take a picture'),
                                                onTap: () async {
                                                  userProvider.getImageFile(
                                                      source:
                                                          ImageSource.camera);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child:
                                      Image.file(userProvider.restaurantImage),
                                ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: userProvider.restaurantImage != null,
                    child: TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext bc) {
                            return Container(
                              child: new Wrap(
                                children: <Widget>[
                                  new ListTile(
                                    leading: new Icon(Icons.image),
                                    title: new Text('From gallery'),
                                    onTap: () async {
                                      userProvider.getImageFile(
                                          source: ImageSource.gallery);
                                      Navigator.pop(context);
                                    },
                                  ),
                                  new ListTile(
                                    leading: new Icon(Icons.camera_alt),
                                    title: new Text('Take a picture'),
                                    onTap: () async {
                                      userProvider.getImageFile(
                                          source: ImageSource.camera);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: CustomText(text: 'Change Image', color: primary),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: grey),
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: TextFormField(
                            controller: authProvider.name,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Restaurant name",
                                icon: Icon(Icons.restaurant)),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a restaurant name';
                              }
                              return null;
                            }),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: grey),
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: TextFormField(
                            controller: authProvider.email,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email",
                                icon: Icon(Icons.email)),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter an email';
                              }
                              return null;
                            }),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: grey),
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: TextFormField(
                            controller: authProvider.password,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                icon: Icon(Icons.lock)),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            }),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () async {
                        print("BTN CLICKED!!!!");
                        print("BTN CLICKED!!!!");
                        print("BTN CLICKED!!!!");
                        print("BTN CLICKED!!!!");
                        print("BTN CLICKED!!!!");
                        print("BTN CLICKED!!!!");

                        if (!await authProvider.signUp()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Registration failed!")));
                          return;
                        } else if (userProvider.restaurantImage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please add an image')));
                        }
//                  categoryProvider.loadCategories();
//                  restaurantProvider.loadSingleRestaurant();
//                  productProvider.loadProducts();
                        authProvider.clearController();
                        changeScreenReplacement(context, DashboardScreen());
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: red,
                            border: Border.all(color: grey),
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CustomText(
                                text: "Resgister",
                                color: white,
                                size: 22,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      changeScreen(context, LoginScreen());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CustomText(
                          text: "login here here",
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
