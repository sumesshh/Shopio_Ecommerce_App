import 'package:flutter/material.dart';
import 'package:shopio/Pages/home_page.dart';
import 'package:shopio/Pages/orderpage.dart';
import 'package:shopio/Pages/profilepage.dart';
import 'package:shopio/widget/glossy_nav_button.dart';

class Bottomnavigationbar extends StatefulWidget {
  const Bottomnavigationbar({super.key});

  @override
  State<Bottomnavigationbar> createState() => _BottomnavigationbarState();
}

class _BottomnavigationbarState extends State<Bottomnavigationbar> {
  int currentIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = const [HomePage(), Orderpage(), ProfilePage()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      body: pages[currentIndex],
      resizeToAvoidBottomInset: false,

      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20),
          ],
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GlossyNavButton(
              icon: Icons.home_outlined,
              isActive: currentIndex == 0,
              onTap: () {
                setState(() {
                  currentIndex = 0;
                });
              },
            ),
            GlossyNavButton(
              icon: Icons.shopping_bag_outlined,
              isActive: currentIndex == 1,
              onTap: () {
                setState(() {
                  currentIndex = 1;
                });
              },
            ),
            GlossyNavButton(
              icon: Icons.person_outline,
              isActive: currentIndex == 2,
              onTap: () {
                setState(() {
                  currentIndex = 2;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
