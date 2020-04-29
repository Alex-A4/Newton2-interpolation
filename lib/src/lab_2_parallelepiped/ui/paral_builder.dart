import 'package:flutter/material.dart';
import 'package:newton_2/src/lab_2_parallelepiped/ui/paral_graphic.dart';
import 'package:newton_2/src/lab_2_parallelepiped/ui/paral_input.dart';

class ParalBuilder extends StatelessWidget {
  ParalBuilder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key('ParalBuilderScaffold'),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: ParalInput(),
            ),
            VerticalDivider(thickness: 1, width: 2),
            Flexible(
              fit: FlexFit.tight,
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ParalGraphic(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
