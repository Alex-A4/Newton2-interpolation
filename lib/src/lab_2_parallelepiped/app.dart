import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newton_2/src/lab_2_parallelepiped/bloc/paral.dart';
import 'package:newton_2/src/lab_2_parallelepiped/ui/paral_builder.dart';

class AppParallelepiped extends StatelessWidget {
  final ParalBloc bloc;

  AppParallelepiped({Key key = const Key('AppParalKey'), @required this.bloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ParalBloc>(
      key: Key('AppBlocProvider'),
      create: (_) => bloc,
      child: ParalBuilder(),
    );
  }
}
