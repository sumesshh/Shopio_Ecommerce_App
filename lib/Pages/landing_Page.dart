import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopio/Pages/bottomnavigationbar.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background Image (Bottom Layer)
          Image.asset("images/langing page image.png", fit: BoxFit.cover),

          // 2. Dark overlay (Middle Layer) - Wrapped in IgnorePointer or positioned correctly
          IgnorePointer(
            // This ensures touches pass through the overlay to the button
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),

          // 3. Centered Text
          Center(
            child: Text(
              "Shop Smarter\nWith Shopio",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: const Color.fromARGB(255, 230, 241, 249),
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // 4. Bottom Button (Top Layer)
          Positioned(
            bottom: 40,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                print("Button clicked!"); // Watch your console for this!
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Bottomnavigationbar(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white, // Sets text/icon color easily
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Get Started"),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
