import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CommonCarousel<T> extends StatelessWidget {
  final List<T> items;
  final double height;
  final String Function(T) imageUrl;
  final String Function(T) title;
  final void Function(T) onTap;

  const CommonCarousel({
    super.key,
    required this.items,
    required this.height,
    required this.imageUrl,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: height,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.9,
      ),
      items: items.map((item) {
        return GestureDetector(
          onTap: () => onTap(item), 
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(imageUrl(item)),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  title(item),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
