import 'package:flutter/material.dart';
import '../models/artikel_model.dart';
import '../screens/articles/detail.screen.dart';

class GridArtikelAll  extends StatelessWidget {
  final List<Artikel> artikelList;
  const GridArtikelAll ({super.key, required this.artikelList});

  @override 
  Widget build (BuildContext context) {
    const baseUrl = 'https://api-pariwisata.rakryan.id';
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1,
      ),

      itemCount: artikelList.length,
      itemBuilder: (context, index) {
        final artikel = artikelList[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => DetailScreen(detailArtikel: artikel),
              ),
            );
          },
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar Artikel
              Expanded(
                child: Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage('$baseUrl/${artikel.image}'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              // End Gambar Artikel

              SizedBox(height: 5),

              // Judul Artikel
              Text(
                artikel.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // End Judul Artikel

              // Deskripsi Artikel
              Text(
                artikel.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis, 
                style: TextStyle(fontSize: 12),
              ),
              // End Deskripsi Artikel

            ],
          ),
        );
      },
    );
  }
}