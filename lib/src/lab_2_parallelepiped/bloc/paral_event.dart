abstract class ParalEvent {}

class InitBlocEvent extends ParalEvent {}

class BuildGraphicEvent extends ParalEvent {}

class CalculatePointsEvent extends ParalEvent {
  final double width;

  CalculatePointsEvent(this.width);
}
