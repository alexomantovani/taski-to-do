import 'package:flutter/material.dart';

import '../core/extensions/context_ext.dart';
import '../core/services/assets.dart';
import '../core/services/styles.dart';

class ActionsWidget extends StatelessWidget {
  const ActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'John',
          style: context.textTheme.titleMedium!.copyWith(
            color: Styles.kPrimaryBlue,
          ),
        ),
        const SizedBox(width: 14.0),
        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(Assets.kJohnImage),
              fit: BoxFit.fill,
            ),
          ),
        ),
        const SizedBox(width: 26.0),
      ],
    );
  }
}
