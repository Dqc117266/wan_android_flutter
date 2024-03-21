import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/model/front_banner_model.dart';
import 'package:wan_android_flutter/ui/pages/web/web_page.dart';

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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16))
      ),
      child: Stack(
        children: [
          CarouselSlider(
            items: _imageWidgets.map((widget) {
              return GestureDetector(
                onTap: () {
                  // Handle tap event here
                  int index = _imageWidgets.indexOf(widget);
                  // final url = widget.frontBannerModel.data![index].url;
                  // _launchURL(url!);
                  final title = this.widget.frontBannerModel.data![index].title;
                  final url = this.widget.frontBannerModel.data![index].url;
                  final id = this.widget.frontBannerModel.data![index].id;

                  Navigator.of(context).pushNamed(
                    WebPageScreen.routeName,
                    arguments: {"title": title, "url": url, "id" : id},
                  );

                  print('Item tapped at index $index');
                },
                child: widget,
              );
            }).toList(),
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

          Positioned(
            bottom: -4,
            right: 0,
            left: 0,
            child: DotIndicatorRow(
              key: dotIndicatorRowKey,
              length: _imageWidgets.length,
            ),
          ),
        ],
      ),
    );
  }
}
