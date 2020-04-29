import 'dart:math';

import 'package:flutter/foundation.dart';
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
    // ignore: close_sinks
    final bloc = BlocProvider.of<ParalBloc>(context);

    return LayoutBuilder(
      key: Key('ParalGraphicLayout'),
      builder: (_, constraints) {
        return BlocBuilder<ParalBloc, ParalState>(
          key: Key('ParalGraphicBlocBuilder'),
          builder: (_, state) {
            if (state is CalculatingState) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is PreparingState) {
              WidgetsBinding.instance.addPostFrameCallback(
                  (_) => bloc.add(CalculatePointsEvent(constraints.maxWidth)));
              return Center(child: CircularProgressIndicator());
            }

            if (state is ShowState) {
              List<Point<double>> corners = [
                Point(state.pol.A, state.pol.D),
                Point(state.pol.B, state.pol.C),
              ];

              return chart.LineChart(
                <chart.Series<Point<double>, double>>[
                  new chart.Series(
                    data: state.points,
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
