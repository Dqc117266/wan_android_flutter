import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';

class MineScreen extends StatelessWidget {
  const MineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      body: ListView(
        children: [
          _buildHeadItem(context),

          _buildBodyItem(context, "设置", Icons.settings_outlined, BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))),
          _buildBodyItem(context, "aa", Icons.hourglass_empty, BorderRadius.zero),
          _buildBodyItem(context, "bvb", Icons.verified_user_outlined, BorderRadius.zero),
          _buildBodyItem(context, "bvb", Icons.done, BorderRadius.zero),
          _buildBodyItem(context, "cc", Icons.g_mobiledata_sharp, BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))),
        ],
      ),
    );
  }

  Widget _buildHeadItem(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),

      child: Material(
        child: InkWell(
          onTap: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 56.0,
                height: 56.0,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Icon(
                  Icons.account_circle_outlined,
                  size: 56,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("登陆/注册", style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 24,),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBodyItem(BuildContext context, String title, IconData iconData, BorderRadius borderRadius) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 8),
      // decoration: BoxDecoration(
      //     border: Border(
      //       bottom: BorderSide(
      //         color: Theme.of(context).hintColor.withOpacity(0.2),
      //         width: 0.5,
      //       ),
      //     )
      // ),
      child: Material(
        child: InkWell(
          onTap: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Icon(iconData),
              ),

              Expanded(child: Text(title)),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 24,),
              ),            ],
          ),
        ),
      ),
    );
  }

}
