import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newton_2/src/bloc/newton.dart';

import 'package:charts_flutter/flutter.dart' as chart;

/// Виджет для построения графика.
/// Подписывается на поток состояний блока и рисует два графика Pn(x) и f(x)
class NewtonGraphic extends StatelessWidget {
  NewtonGraphic({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      key: Key('NewtonGraphicLayout'),
      builder: (_, constraints) {
        return BlocBuilder<NewtonBloc, NewtonState>(
          key: Key('NewtonGraphicBlocBuilder'),
          builder: (_, state) {
            if (state is CalculatingState)
              return Center(child: CircularProgressIndicator());
            if (state is BuildState) {
              final pol = state.polynomial;
              double x;
              int px;

              List<Point<double>> pointsFx = [];
              List<Point<double>> pointsPn = [];
              List<Point<double>> corners = [
                Point(pol.A, pol.D),
                Point(pol.B, pol.C),
              ];

              for (px = 0; px <= constraints.maxWidth; px++) {
                x = pol.A + px * (pol.B - pol.A) / constraints.maxWidth;
                final fx = pol.fx(x);
                final pn = pol.pn(x);
                if (pol.C <= fx && fx <= pol.D) pointsFx.add(Point(x, fx));
                if (pol.C < pn && pn <= pol.D) pointsPn.add(Point(x, pn));
              }

              return chart.LineChart(
                <chart.Series<Point<double>, double>>[
                  new chart.Series(
                    data: pointsFx,
                    id: 'f(x)',
                    domainFn: (p, _) => p.x,
                    measureFn: (p, _) => p.y,
                    displayName: 'f(x)',
                    seriesColor: chart.Color.fromHex(code: '#66BB6A'),
                  ),
                  new chart.Series(
                    data: pointsPn,
                    id: 'Pn(x)',
                    domainFn: (p, _) => p.x,
                    measureFn: (p, _) => p.y,
                    displayName: 'Pn(x)',
                    seriesColor: chart.Color.fromHex(code: '#42A5F5'),
                  ),
                  new chart.Series(
                    data: corners,
                    id: '',
                    domainFn: (p, _) => p.x,
                    measureFn: (p, _) => p.y,
                    seriesColor: chart.Color.transparent,
                  ),
                ],
                animate: false,
                behaviors: [
                  chart.SeriesLegend(position: chart.BehaviorPosition.bottom),
                ],
              );
            }

            return Center(
              child: Text(
                'Нажмите "Построить" для отображения графика',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            );
          },
        );
      },
    );
  }
}
