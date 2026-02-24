import 'package:flutter/material.dart';
import 'package:shopio/widget/support_widget.dart';

class Productdetails extends StatefulWidget {
  const Productdetails({super.key});

  @override
  State<Productdetails> createState() => _ProductdetailsState();
}

class _ProductdetailsState extends State<Productdetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F2F2),
        title: Text("Product Details", style: Appwidget.boldTextFieldStyle()),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                width: double.infinity,
                child: Image.asset(
                  "images/headphone2.png",
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 16),

              // PRODUCT NAME , PRICE
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("HeadPhone", style: Appwidget.productnametext()),
                  Text("\$400", style: Appwidget.productamounttext()),
                ],
              ),

              const SizedBox(height: 16),

              // DESCRIPTION TITLE
              Text("Description", style: Appwidget.semiBoldTextStyle()),

              const SizedBox(height: 8),

              // DESCRIPTION TEXT
              Text(
                "Enjoy clear sound and deep bass with these comfortable headphones. Perfect for music, calls, and videos. Great choice for everyday use.",
                style: Appwidget.lightTextFieldStyle(),
              ),

              const SizedBox(height: 16),
              //buy now button
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color.fromARGB(
                              255,
                              1,
                              160,
                              234,
                            ).withOpacity(0.45),
                            const Color.fromARGB(
                              255,
                              170,
                              232,
                              252,
                            ).withOpacity(0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(
                              255,
                              20,
                              120,
                              201,
                            ).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Buy Now",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 0, 123, 195),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color.fromARGB(
                              255,
                              1,
                              160,
                              234,
                            ).withOpacity(0.45),
                            const Color.fromARGB(
                              255,
                              170,
                              232,
                              252,
                            ).withOpacity(0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(
                              255,
                              20,
                              120,
                              201,
                            ).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Add to Cart",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 0, 123, 195),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
