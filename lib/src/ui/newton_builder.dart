import 'package:flutter/material.dart';
import 'package:newton_2/src/ui/newton_graphic.dart';

import 'package:newton_2/src/ui/newton_input.dart';

class NewtonBuilder extends StatelessWidget {
  NewtonBuilder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('NewtonBuilderScaffold'),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: NewtonInput(),
            ),
            VerticalDivider(thickness: 1, width: 2),
            Flexible(
              fit: FlexFit.tight,
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: NewtonGraphic(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
