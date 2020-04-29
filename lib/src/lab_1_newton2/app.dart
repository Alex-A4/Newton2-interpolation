import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newton_2/src/lab_1_newton2/bloc/newton.dart';
import 'package:newton_2/src/lab_1_newton2/ui/newton_builder.dart';

class AppNewton2 extends StatelessWidget {
  final NewtonBloc bloc;

  AppNewton2({Key key = const Key('AppKey'), @required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NewtonBloc>(
      key: Key('AppBlocProvider'),
      create: (_) => bloc,
      child: NewtonBuilder(),
    );
  }
}
