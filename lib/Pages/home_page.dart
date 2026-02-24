import 'package:flutter/material.dart';
import 'package:shopio/models/product_models.dart';
import 'package:shopio/widget/All_products.dart';
import 'package:shopio/widget/Categories.dart';
import 'package:shopio/widget/support_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List categories = [
    "images/headphone_icon.png",
    "images/headphone2.png",
    "images/homepage_profile.png",
    "images/laptop.png",
    "images/laptop2.png",
    "images/TV.png",
    "images/watch.png",
    "images/watch2.png",
  ];

  List<Productmodels> products = [
    Productmodels(
      image: 'images/headphone_icon.png',
      name: 'headphone',
      price: '₹1999',
    ),

    Productmodels(
      image: 'images/headphone_icon.png',
      name: 'headphone',
      price: '₹1999',
    ),
    Productmodels(
      image: 'images/headphone_icon.png',
      name: 'headphone',
      price: '₹1999',
    ),
    Productmodels(
      image: 'images/headphone_icon.png',
      name: 'headphone',
      price: '₹1999',
    ),
    Productmodels(
      image: 'images/headphone_icon.png',
      name: 'headphone',
      price: '₹1999',
    ),
    Productmodels(
      image: 'images/headphone_icon.png',
      name: 'headphone',
      price: '₹1999',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(top: 10.0, left: 20.0, right: 20),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,

          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,

                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hey, Aleena ", style: Appwidget.boldTextFieldStyle()),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      "images/homepage_profile.png",
                      height: 70,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Container(
                padding: EdgeInsets.only(left: 10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search Products",
                    hintStyle: Appwidget.lightTextFieldStyle(),
                    prefixIcon: Icon(Icons.search, color: Colors.black),
                    prefixIconConstraints: BoxConstraints(minWidth: 10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              //categories
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Categories", style: Appwidget.semiBoldTextStyle()),
                  Text(
                    "see all",
                    style: TextStyle(
                      color: Colors.lightBlueAccent.withAlpha(180),
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 140,
                child: Container(
                  margin: EdgeInsets.only(left: 8),
                  child: ListView.builder(
                    itemCount: categories.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Category_Tile(images: categories[index]),
                      );
                    },
                  ),
                ),
              ),

              // all products
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("All Products", style: Appwidget.semiBoldTextStyle()),
                  Text(
                    "see all",
                    style: TextStyle(
                      color: Colors.lightBlueAccent.withAlpha(180),
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 180,
                child: Container(
                  margin: EdgeInsets.only(left: 8),
                  child: ListView.builder(
                    itemCount: products.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return ProductCards(product: products[index]);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
