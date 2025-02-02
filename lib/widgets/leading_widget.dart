import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../core/extensions/context_ext.dart';
import '../core/services/assets.dart';

class LeadingWidget extends StatelessWidget {
  const LeadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 26.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(Assets.kIcDoneBox),
          Text(
            'Taski',
            style: context.textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}
