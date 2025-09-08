import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class ShimmerWidget {
  static Widget shimmerWidget({
    required double width,
    required double height,
    bool isRounded = false,
    double borderRadius = 0.0,
    bool useScreenFraction = false,
    ShapeBorder? customShape,
  }) {
    return Builder(
      builder: (context) {
        final screenSize = MediaQuery.of(context).size;
        final effectiveWidth = useScreenFraction ? screenSize.width * width : width;
        final effectiveHeight = useScreenFraction ? screenSize.height * height : height;

        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: effectiveWidth,
            height: effectiveHeight,
            decoration: isRounded
                ? BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    color: Colors.grey[300],
                  )
                : BoxDecoration(
                    shape: customShape != null ? BoxShape.rectangle : BoxShape.rectangle,
                    color: Colors.grey[300],
                  ),
            child: customShape != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(borderRadius),
                    child: Container(color: Colors.grey[300]),
                  )
                : null,
          ),
        );
      },
    );
  }

  static List<Widget> buildShimmerList({
    required int itemCount,
    required double width,
    required double height,
    required bool isRounded,
    double borderRadius = 12.0,
    bool useScreenFraction = true,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 4.0),
    List<dynamic>? data,
  }) {
    final effectiveCount = data?.length ?? itemCount;
    return List.generate(
      effectiveCount,
      (index) => Padding(
        padding: padding,
        child: shimmerWidget(
          width: width,
          height: height,
          isRounded: isRounded,
          borderRadius: borderRadius,
          useScreenFraction: useScreenFraction,
        ),
      ),
    );
  }

  static Widget buildShimmerGrid({
    required int itemCount,
    required double childAspectRatio,
    required int crossAxisCount,
    required double crossAxisSpacing,
    required double mainAxisSpacing,
    double borderRadius = 10.0,
    EdgeInsets padding = const EdgeInsets.all(8.0),
    List<dynamic>? data,
  }) {
    final effectiveCount = data?.length ?? itemCount;
    return GridView.builder(
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
      ),
      itemCount: effectiveCount,
      itemBuilder: (context, index) => ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: shimmerWidget(
          width: 1.0,
          height: 1.0,
          isRounded: true,
          borderRadius: borderRadius,
          useScreenFraction: false,
        ),
      ),
    );
  }

  static Widget buildTrendingTabShimmer({
    required double carouselHeight,
    required double movieListHeight,
    required double movieItemWidthFraction,
    required double titleWidthFraction,
    required Size screenSize,
    int carouselItemCount = 3,
    int listItemCount = 5,
  }) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: carouselHeight,
              autoPlay: false,
              enlargeCenterPage: true,
              viewportFraction: 0.7,
            ),
            items: buildShimmerList(
              itemCount: carouselItemCount,
              width: 0.7,
              height: 1.0,
              isRounded: true,
              borderRadius: 18,
              useScreenFraction: true,
            ).map((shimmer) {
              return Stack(
                children: [
                  shimmer,
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: shimmerWidget(
                        width: 0.3,
                        height: 0.03,
                        isRounded: true,
                        borderRadius: 6,
                        useScreenFraction: true,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                shimmerWidget(
                  width: titleWidthFraction,
                  height: 0.03,
                  isRounded: false,
                  useScreenFraction: true,
                ),
                shimmerWidget(
                  width: 0.15,
                  height: 0.03,
                  isRounded: false,
                  useScreenFraction: true,
                ),
              ],
            ),
          ),
          SizedBox(
            height: movieListHeight,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: buildShimmerList(
                itemCount: listItemCount,
                width: movieItemWidthFraction,
                height: 1.0,
                isRounded: true,
                borderRadius: 12,
                useScreenFraction: true,
              ),
            ),
          ),
          SizedBox(height: screenSize.height * 0.02),
          // Shimmer for Now Playing Section Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                shimmerWidget(
                  width: titleWidthFraction,
                  height: 0.03,
                  isRounded: false,
                  useScreenFraction: true,
                ),
                shimmerWidget(
                  width: 0.15,
                  height: 0.03,
                  isRounded: false,
                  useScreenFraction: true,
                ),
              ],
            ),
          ),
          SizedBox(
            height: movieListHeight,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: buildShimmerList(
                itemCount: listItemCount,
                width: movieItemWidthFraction,
                height: 1.0,
                isRounded: true,
                borderRadius: 12,
                useScreenFraction: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}