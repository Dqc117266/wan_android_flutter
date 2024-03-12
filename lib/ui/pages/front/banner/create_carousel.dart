import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/model/front_banner_model.dart';

import 'dot_indicator.dart';

class CreateCarousel extends StatefulWidget {
  final FrontBannerModel frontBannerModel;

  CreateCarousel({Key? key, required this.frontBannerModel}) : super(key: key);

  @override
  State<CreateCarousel> createState() => _CreateCarouselState();
}

class _CreateCarouselState extends State<CreateCarousel> {
  GlobalKey<DotIndicatorRowState> dotIndicatorRowKey =
      GlobalKey<DotIndicatorRowState>();
  late List<Widget> _imageWidgets;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _imageWidgets = widget.frontBannerModel.data!
        .map((item) => CachedNetworkImage(imageUrl: item!.imagePath!))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: CarouselSlider(
            items: _imageWidgets,
            options: CarouselOptions(
              height: 200.0,
              enableInfiniteScroll: true,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              enlargeCenterPage: true,
              enlargeFactor: 0.3,
              onPageChanged: (index, reason) {
                dotIndicatorRowKey.currentState?.setCurrent(index);
              },
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: DotIndicatorRow(
            key: dotIndicatorRowKey,
            length: _imageWidgets.length,
          ),
        ),
      ],
    );
  }
}