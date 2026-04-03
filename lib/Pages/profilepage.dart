import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopio/Pages/shipping_address_page.dart';
import 'package:shopio/Pages/uploadproductpage.dart';

import 'package:shopio/authentication/loginpage.dart';
import 'package:shopio/authentication/signup.dart';
import 'package:shopio/provider/profile_provider.dart';
import 'package:shopio/Pages/editprofilepage.dart';
import 'package:shopio/widget/buttoncolor.dart';
import 'package:shopio/widget/ownproduct.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() => context.read<ProfileProvider>().loadProfile());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: Color(0xFFF2F2F2),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),

            /// Profile Image
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: provider.imageUrl != null
                      ? NetworkImage(provider.imageUrl!)
                      : null,
                  child: provider.imageUrl == null
                      ? const Icon(Icons.person, size: 60, color: Colors.grey)
                      : null,
                ),

                GestureDetector(
                  onTap: provider.isLoading
                      ? null
                      : provider.pickAndUploadImage,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 0, 0, 0),
                      shape: BoxShape.circle,
                    ),
                    child: provider.isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            /// User Name
            Text(
              provider.userName ?? "No Name",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            /// Email
            Text(user?.email ?? "", style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 30),

            /// Menu Items
            buildMenuItem(Icons.person, "Edit Profile", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfilePage()),
              );
            }),
            buildMenuItem(Icons.shop, "view products", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OwnProductPage()),
              );
            }),

            buildMenuItem(Icons.notifications, "Notification", () {}),

            //shipping adrs page
            buildMenuItem(Icons.location_on, "Shipping Address", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ShippingAddressPage()),
              );
            }),

            const SizedBox(height: 20),

            /// Button for uploadinf products
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ButtonColor(
                text: "Add Product",
                isFullWidth: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UploadProductPage(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            /// Sign Out Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ButtonColor(
                text: "Sign Out",
                isFullWidth: true,
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false,
                  );
                },
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

/// Reusable Menu Item
Widget buildMenuItem(IconData icon, String title, VoidCallback onTap) {
  return ListTile(
    leading: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.lightBlueAccent.withOpacity(0.45),
            Colors.white.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: const Color.fromARGB(255, 16, 82, 187)),
    ),
    title: Text(title),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    onTap: onTap,
  );
}
