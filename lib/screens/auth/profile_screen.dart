import 'package:flutter/material.dart';

import '../../screens/auth/profile_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/articles/my_articles_screen.dart';
import '../../controllers/artikel_controller.dart';
import '../../widgets/grid_artikel_populer.dart';
import '../../controllers/auth_controller.dart';
import '../../screens/auth/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                  color: Color(0XFFD1A824),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: const AssetImage(
                        'assets/images/kucing.png',
                      ),
                    ),
                    SizedBox(height: 5),
                    FutureBuilder(
                      future: AuthController
                          .getLocalProfile(), // ← PERBAIKAN TERPENTING
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final user = snapshot.data!;
                          return Column(
                            children: [
                              Text(
                                user.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                user.username,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),

                    SizedBox(height: 20),
                    // End Profile

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Button edit profile
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditProfileScreen(),
                              ),
                            ).then((_) {
                              setState(() {});
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0XFFD1A824),
                            minimumSize: Size(115, 60),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.edit, color: Colors.white, size: 20),
                              Text(
                                "Edit Profile",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // End button edit profile

                        SizedBox(width: 10),
                        // Button logout
                        ElevatedButton(
                          onPressed: () async {
                            final message = await AuthController.logout(
                              context,
                            );

                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(message)));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0XFFD1A824),
                            minimumSize: Size(115, 60),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.logout, color: Colors.white, size: 20),
                              Text(
                                "Logout",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // End Button Logout
                      ],
                    ),
                  ],
                ),
              ),

              // List Artikel Saya
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Postingan Terbaru',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    FutureBuilder(
                        future: ArtikelController.getMyArtikel(1, 4),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error : ${snapshot.error}');
                          } else {
                            final artikelList = snapshot.data ?? [];

                            return GridArtikelPopuler(artikelList: artikelList);
                          }
                        }),
                  ],
                ),
              ),
              // End List Artikel saya
            ],
          ),
        ),
      ),
    );
  }
}
