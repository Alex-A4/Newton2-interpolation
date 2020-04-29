import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:charts_flutter/flutter.dart' as chart;
import 'package:newton_2/src/lab_1_newton2/bloc/newton.dart';

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
              List<Point<double>> pointsFh = [];
              List<Point<double>> pointsPh = [];
              List<Point<double>> pointsFP = [];
              List<Point<double>> corners = [
                Point(pol.A, pol.D),
                Point(pol.B, pol.C),
              ];

              for (px = 0; px <= constraints.maxWidth; px++) {
                x = pol.A + px * (pol.B - pol.A) / constraints.maxWidth;
                final fx = pol.fx(x);
                final pn = pol.pn(x);
                final pf = fx - pn;
                final fh = (pol.fx(x + pol.h) - fx) / pol.h;
                final ph = (pol.pn(x + pol.h) - pn) / pol.h;

                if (pol.C <= fx && fx <= pol.D) pointsFx.add(Point(x, fx));
                if (pol.C <= pn && pn <= pol.D) pointsPn.add(Point(x, pn));
                if (pol.C <= pf && pf <= pol.D) pointsFP.add(Point(x, pf));
                if (pol.C <= fh && fh <= pol.D) pointsFh.add(Point(x, fh));
                if (pol.C <= ph && ph <= pol.D) pointsPh.add(Point(x, ph));
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
                  new chart.Series(
                    data: pointsFP,
                    id: 'f(x)-Pn(x)',
                    displayName: 'f(x)-Pn()',
                    domainFn: (p, _) => p.x,
                    measureFn: (p, _) => p.y,
                    seriesColor: chart.Color.fromHex(code: '#DC143C'),
                  ),
                  new chart.Series(
                    data: pointsFh,
                    id: '(f(x+h)-f(x))/h',
                    displayName: '(f(x+h)-f(x))/h',
                    domainFn: (p, _) => p.x,
                    measureFn: (p, _) => p.y,
                    seriesColor: chart.Color.fromHex(code: '#FF8C00'),
                  ),
                  new chart.Series(
                    data: pointsPh,
                    id: '(Pn(x+h)-Pn(x))/h',
                    displayName: '(Pn(x+h)-Pn(x))/h',
                    domainFn: (p, _) => p.x,
                    measureFn: (p, _) => p.y,
                    seriesColor: chart.Color.fromHex(code: '#8A2BE2'),
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
