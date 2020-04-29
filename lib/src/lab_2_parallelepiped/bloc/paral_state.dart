import 'package:newton_2/src/lab_2_parallelepiped/models/polynom.dart';

abstract class ParalState {}

class InitialState extends ParalState {}

class InitializedState extends ParalState {}

class CalculatingState extends ParalState {}

class BuildState extends ParalState {
  final Polynomial polynomial;

  BuildState(this.polynomial);
}
