import 'package:newton_2/src/models/polynom.dart';

abstract class NewtonState {}

class InitialState extends NewtonState {}

class CalculatingState extends NewtonState {}

class BuildState extends NewtonState {
  final Polynomial polynomial;

  BuildState(this.polynomial);
}
