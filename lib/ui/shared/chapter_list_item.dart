import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'package:wan_android_flutter/core/model/front_articles_model.dart';
import 'package:wan_android_flutter/core/utils/http_utils.dart';
import 'package:wan_android_flutter/ui/pages/web/web_page.dart';

class ChapterListItem extends StatefulWidget {
  final Datas datas;
  final BorderRadius borderRadius;
  final bool isBottomLine;

  ChapterListItem(
      {super.key,
      required this.datas,
      required this.borderRadius,
      required this.isBottomLine});

  @override
  State<ChapterListItem> createState() => _SliverListItemState();
}

class _SliverListItemState extends State<ChapterListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      decoration: widget.isBottomLine
          ? BoxDecoration(
              border: Border(
              bottom: BorderSide(
                color: Theme.of(context).hintColor.withOpacity(0.2),
                width: 0.5,
              ),
            ))
          : null,
      child: Material(
        borderRadius: widget.borderRadius,
        child: InkWell(
          borderRadius: widget.borderRadius,
          onTap: () {
            Navigator.of(context).pushNamed(WebPageScreen.routeName,
                arguments: widget.datas);
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 16, 10, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAuthorDateRow(
                  context,
                  widget.datas.author! != "" ? widget.datas.author! : widget.datas.shareUser!,
                  widget.datas.niceDate!,
                ),
                SizedBox(height: 8),
                HtmlWidget(
                  widget.datas.title!,
                  textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                ),
                SizedBox(height: 8),
                _buildChapterAndFavoriteRow(context, widget.datas.superChapterName!),
              ],
            ),
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
            _collecAndUnCollec();
          },
          child: widget.datas.collect! ? Icon(Icons.favorite,
              color: Theme.of(context).colorScheme.primary) : Icon(Icons.favorite_border,
              color: Theme.of(context).colorScheme.primary),
        ),
      ],
    );
  }

  void _collecAndUnCollec() {
    if (!widget.datas.collect!) {
      HttpUtils.collectChapter(context, widget.datas.id!).then((value) {
        if (value != null && value!.errorCode == 0) {
          setState(() {
            widget.datas.collect = !widget.datas.collect!;
          });
        }
      });
    } else {
      HttpUtils.unCollectChapter(context, widget.datas.id!).then((value) {
        setState(() {
          if (value != null && value!.errorCode == 0) {
            widget.datas.collect = !widget.datas.collect!;
          }
        });
      });
    }
  }

}
