import 'dart:math';

import 'package:newton_2/src/lab_2_parallelepiped/models/polynom.dart';

abstract class ParalState {}

class InitialState extends ParalState {}

class InitializedState extends ParalState {}

class CalculatingState extends ParalState {}

class PreparingState extends ParalState {}

class ShowState extends ParalState {
  final Polynomial pol;
  final List<Point<double>> points;

  ShowState(this.points, this.pol);
}
