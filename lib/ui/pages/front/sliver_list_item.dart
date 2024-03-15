import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:wan_android_flutter/core/model/front_articles_model.dart';
import 'package:wan_android_flutter/ui/pages/web/web_page.dart';

class SliverListItem extends StatelessWidget {
  final Datas datas;

  SliverListItem({super.key, required this.datas});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(WebPageScreen.routeName, arguments: {
            "title": datas.title,
            "url": datas.link,
          });
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, 12, 8, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    datas.chapterName!,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Text(
                    datas.niceDate!,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                datas.title!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    datas.superChapterName!,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Icon(Icons.favorite_border, color: Theme.of(context).primaryColor,),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
