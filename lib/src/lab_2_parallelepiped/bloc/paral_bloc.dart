import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:newton_2/src/lab_2_parallelepiped/models/polynom.dart';
import 'package:newton_2/src/scripts/scripts.dart';
import 'package:newton_2/src/storage/field_storage.dart';
import 'package:rxdart/rxdart.dart';

import 'paral.dart';

class ParalBloc extends Bloc<ParalEvent, ParalState> {
  final _storageMap = <String, FieldStorage>{};

  FieldStorage getField(String name) => _storageMap[name];

  Stream<bool> get buildButton => CombineLatestStream(
      _getStreams(), (values) => true && state is! CalculatingState);

  Iterable<Stream<dynamic>> _getStreams() {
    final list = <Stream<dynamic>>[];
    _storageMap.forEach((_, s) => list.add(s.valueStream));
    return list;
  }

  Polynomial polynomial;

  @override
  ParalState get initialState => InitialState();

  @override
  Stream<ParalState> mapEventToState(ParalEvent event) async* {
    if (event is InitBlocEvent) {
      _initStorage();
      yield InitializedState();
    }

    if (event is BuildGraphicEvent) {
      bool hasError = false;
      if (_storageMap['A'].value >= _storageMap['B'].value) {
        _storageMap['A'].addError('Поле A не меньше B');
        hasError = true;
      }
      if (_storageMap['C'].value >= _storageMap['D'].value) {
        _storageMap['C'].addError('Поле C не меньше D');
        hasError = true;
      }
      if (_storageMap['a'].value >= _storageMap['b'].value) {
        _storageMap['a'].addError('Поле a не меньше b');
        hasError = true;
      }
      if (!hasError) {
        polynomial = Polynomial(
          _storageMap['A'].value,
          _storageMap['B'].value,
          _storageMap['C'].value,
          _storageMap['D'].value,
          _storageMap['alpha'].value,
          _storageMap['betta'].value,
          _storageMap['delta'].value,
          _storageMap['epsilon'].value,
          _storageMap['mu'].value,
          _storageMap['n'].value,
          _storageMap['a'].value,
          _storageMap['b'].value,
          _storageMap['dx'].value,
          _storageMap['builder'].value,
        );
        yield PreparingState();
      }
    }

    if (event is CalculatePointsEvent) {
      polynomial.width = event.width;
      yield CalculatingState();
      var points = await compute(calculateGraphic, polynomial);
      yield ShowState(points, polynomial);
    }
  }

  void _initStorage() {
    _storageMap['A'] =
        FieldStorage<double>('A', validate1000range, doubleParser, -10);
    _storageMap['B'] =
        FieldStorage<double>('B', validate1000range, doubleParser, 10);
    _storageMap['C'] =
        FieldStorage<double>('C', validate1000range, doubleParser, -10);
    _storageMap['D'] =
        FieldStorage<double>('D', validate1000range, doubleParser, 10);

    _storageMap['alpha'] =
        FieldStorage<double>('alpha', validate100range, doubleParser, 1);
    _storageMap['betta'] =
        FieldStorage<double>('betta', validate100range, doubleParser, 1);
    _storageMap['delta'] =
        FieldStorage<double>('delta', validate100range, doubleParser, 1);
    _storageMap['epsilon'] =
        FieldStorage<double>('epsilon', validate100range, doubleParser, 1);
    _storageMap['mu'] =
        FieldStorage<double>('mu', validate100range, doubleParser, 1);

    _storageMap['n'] = FieldStorage<int>('n', validate0to100, intParser, 10);
    _storageMap['a'] =
        FieldStorage<double>('a', validate100range, doubleParser, -1);
    _storageMap['b'] =
        FieldStorage<double>('b', validate100range, doubleParser, 1);
    _storageMap['dx'] = FieldStorage<double>('dx', null, doubleParser, 0.5);

    _storageMap['builder'] =
        FieldStorage<String>('builder', null, null, 'alpha');
  }

  void dispose() {
    _storageMap.forEach((key, value) => value.dispose());
    super.close();
  }
}

List<Point<double>> calculateGraphic(Polynomial pol) {
  List<Point<double>> pointsIntegral = [];
  double px;
  double x;
  int n1;
  double i1, i2;

  for (px = 0; px <= pol.width; px++) {
    x = pol.A + px * (pol.B - pol.A) / pol.width;
    n1 = pol.n;
    while (true) {
      if (n1 == pol.n) {
        i1 = calculateIntegral(pol, x, n1);
      }
      i2 = calculateIntegral(pol, x, 2 * n1);

      if ((1 / 3) * (i1 - i2).abs() < pol.dx) {
        break;
      }
      i1 = i2;
      n1 = 2 * n1;
    }

    if (pol.C <= i2 && i2 <= pol.D) {
      pointsIntegral.add(Point(px, i2));
    }
  }
  return pointsIntegral;
}

double calculateIntegral(Polynomial pol, double value, int n) {
  switch (pol.activeParam) {
    case 'alpha':
      return pol.integral(value, null, null, null, null, n);
    case 'betta':
      return pol.integral(null, value, null, null, null, n);
    case 'delta':
      return pol.integral(null, null, value, null, null, n);
    case 'epsilon':
      return pol.integral(null, null, null, value, null, n);
    case 'mu':
      return pol.integral(null, null, null, null, value, n);
    default:
      return 0;
  }
}
