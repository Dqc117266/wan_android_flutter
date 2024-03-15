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
              _buildAuthorDateRow(
                context,
                datas.author! != "" ? datas.author! : datas.shareUser!,
                datas.niceDate!,
              ),

              SizedBox(
                height: 8,
              ),

              Text(
                datas.title!,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(
                height: 8,
              ),

              _buildChapterAndFavoriteRow(context, datas.superChapterName!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthorDateRow(BuildContext context, String author, String date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          author.isNotEmpty ? author : 'Unknown',
          style: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .color!
                  .withOpacity(0.6)),
        ),
        Text(
          date,
          style: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .color!
                  .withOpacity(0.6)),
        ),
      ],
    );
  }

  Widget _buildChapterAndFavoriteRow(BuildContext context, String chapterName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          chapterName,
          style: TextStyle(
              color: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .color!
                  .withOpacity(0.6)),
        ),
        InkWell(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          onTap: () {
            // Your favorite onTap logic
          },
          child: Icon(Icons.favorite_border,
              color: Theme.of(context).colorScheme.primary),
        ),
      ],
    );
  }
}
