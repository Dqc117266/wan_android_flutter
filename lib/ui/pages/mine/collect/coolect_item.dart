import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:wan_android_flutter/core/utils/http_utils.dart';

import '../../../../core/model/collects_model.dart';

class CollectItem extends StatefulWidget {
  final Datas data;
  final BorderRadius borderRadius;
  final bool isBottomLine;
  final void Function(Datas data)? onFavoriteClicked; // 修改为接受 Datas 参数的回调函数
  final void Function(Datas data)? onItemClicked; // 修改为接受 Datas 参数的回调函数

  const CollectItem(
      {super.key,
      required this.data,
      required this.borderRadius,
      required this.isBottomLine,
      this.onFavoriteClicked,
      this.onItemClicked});

  @override
  State<CollectItem> createState() => _CollectItemState();
}

class _CollectItemState extends State<CollectItem> {
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
            if (widget.onItemClicked != null) {
              widget.onItemClicked!(widget.data);
            }
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 16, 10, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAuthorDateRow(
                    context, widget.data.author!, widget.data.niceDate!),
                SizedBox(height: 8),
                HtmlWidget(
                  widget.data.title!,
                  textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                ),
                SizedBox(height: 8),
                _buildChapterAndFavoriteRow(context, widget.data.chapterName!),
              ],
            ),
          ),
        ),
      ),
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
            borderRadius: BorderRadius.circular(16),
            onTap: () async {
              final result = await HttpUtils.unMyCollectChapter(
                  context, widget.data.id!, widget.data.originId!);
              if (result != null && result.errorCode == 0) {
                widget.onFavoriteClicked!(widget.data);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Icon(Icons.favorite,
                  color: Theme.of(context).colorScheme.primary),
            ))
      ],
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
}
