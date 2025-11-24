import 'package:flutter/material.dart';
import '../../widgets/grid_my_artikel.dart';
import '../../controllers/artikel_controller.dart';
import '../../models/artikel_model.dart';
import './form_screen.dart';
import 'dart:convert';
import '../../services/artikel_service.dart';

class MyArticlesScreen extends StatefulWidget {
  const MyArticlesScreen({super.key});

  @override
  State<MyArticlesScreen> createState() => _MyArticlesScreenState();
}

class _MyArticlesScreenState extends State<MyArticlesScreen> {
  List<Artikel> artikelAll = [];
  int page = 1;
  final int limit = 3;
  bool isLoading = false;
  bool hasMore = true;

  Future<void> loadArtikel() async {
    if (isLoading || !hasMore) return;

    setState(() => isLoading = true);

    try {
      final getArtikel = await ArtikelService.getMyArtikel(page, limit);
      final totalData = jsonDecode(getArtikel.body)["totalData"];

      final data = await ArtikelController.getMyArtikel(page, limit);

      setState(() {
        artikelAll.addAll(data);
        if (artikelAll.length >= totalData) {
          hasMore = false;
        } else {
          page++;
        }
      });
    } catch (e) {
      debugPrint("Gagal memuat artikel $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    loadArtikel();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: const AssetImage(
                        'assets/images/profile.png',
                      ),
                      radius: 25,
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("Username", style: TextStyle(fontSize: 15)),
                      ],
                    ),
                    Spacer(),
                    Icon(
                      Icons.notifications,
                      color: Color(0XFFD1A824),
                      size: 30,
                    ),
                  ],
                ),
                // End Header

                // Search bar
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari Tempat Wisata',
                    hintStyle: TextStyle(fontSize: 14),
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Color(0XFFD1A824).withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                // End Search Bar

                // Header list artikel saya
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'List Artikel Kamu',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ArticleFromScreen(isEdit: false),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: Color(0XFFD1A824),
                        size: 20,
                      ),
                      label: Text(
                        'Buat Artikel Saya',
                        style: TextStyle(
                          color: Color(0XFFD1A824),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                // End header list artikel saya

                // Gridview
                const SizedBox(height: 10),
                GridMyArtikel(artikelList: artikelAll),
                // End Gridview

                // Tombol Load More
                const SizedBox(height: 10),
                if (hasMore)
                  Center(
                    child: ElevatedButton(
                      onPressed: isLoading ? null : loadArtikel,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0XFFD1A824),
                      ),
                      child: isLoading
                          ? const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Text("Load More"),
                    ),
                  )
                else
                  Center(child: const Text("Semua artikel sudah dimuat")),
                // End Tombol Load More
              ],
            ),
          ),
        ),
      ),
    );
  }
}
