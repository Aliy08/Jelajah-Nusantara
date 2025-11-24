import 'package:flutter/material.dart';
import '../models/artikel_model.dart';
import '../screens/articles/detail.screen.dart';

class GridArtikelPopuler extends StatelessWidget {
  final List<Artikel> artikelList;
  const GridArtikelPopuler({super.key, required this.artikelList});

  @override
  Widget build(BuildContext context) {
    const baseUrl = 'https://api-pariwisata.rakryan.id';
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 0.8,
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                // Foto bg wisata
                Image.network('$baseUrl/${artikel.image}',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                  print(error);
                  return Center(
                    child: Icon(Icons.broken_image, color: Colors.red),
                  );
                }),
                // End foto bg wisata
          
                // Nama tempat Wisata
                Positioned(
                  left: 10,
                  bottom: 40,
                  child: Container(
                    height: 20,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      artikel.title,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
                // End Nama tempat Wisata
          
                // Icon Rating
                Positioned(
                  left: 10,
                  bottom: 10,
                  child: Container(
                    height: 20,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: Colors.yellow, size: 15),
                        SizedBox(width: 4),
                        Text(
                          '4.1',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                // End Icon Rating
              ],
            ),
          ),
        );
      },
    );
  }
}
