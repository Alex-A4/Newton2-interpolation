import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:charts_flutter/flutter.dart' as chart;
import 'package:newton_2/src/lab_2_parallelepiped/bloc/paral.dart';

/// Виджет для построения графика.
/// Подписывается на поток состояний блока и рисует два графика Pn(x) и f(x)
class ParalGraphic extends StatelessWidget {
  ParalGraphic({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      key: Key('ParalGraphicLayout'),
      builder: (_, constraints) {
        return BlocBuilder<ParalBloc, ParalState>(
          key: Key('ParalGraphicBlocBuilder'),
          builder: (_, state) {
            if (state is CalculatingState)
              return Center(child: CircularProgressIndicator());
            if (state is BuildState) {
              final pol = state.polynomial;
              double step = (pol.B - pol.A) / constraints.maxWidth;
              double px;
              int n1;
              double i1, i2;

              List<Point<double>> pointsIntegral = [];
              List<Point<double>> corners = [
                Point(pol.A, pol.D),
                Point(pol.B, pol.C),
              ];

              for (px = pol.A; px <= pol.B; px += step) {
                n1 = pol.n;
                while (true) {
                  if (n1 == pol.n) {
                    i1 = pol.integral(px, null, null, null, null, n1);
                  }
                  i2 = pol.integral(px, null, null, null, null, 2 * n1);

                  if ((i1 - i2).abs() < pol.dx) {
                    break;
                  }
                  i1 = i2;
                  n1 = 2 * n1;
                }

                if (pol.C <= i2 && i2 <= pol.D)
                  pointsIntegral.add(Point(px, i2));
              }

              return chart.LineChart(
                <chart.Series<Point<double>, double>>[
                  new chart.Series(
                    data: pointsIntegral,
                    id: 'Integral',
                    domainFn: (p, _) => p.x,
                    measureFn: (p, _) => p.y,
                    displayName: 'Integral',
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
