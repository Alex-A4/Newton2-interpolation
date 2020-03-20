import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newton_2/src/bloc/newton.dart';
import 'package:newton_2/src/ui/newton_builder.dart';

class App extends StatelessWidget {
  final NewtonBloc bloc;

  App({Key key = const Key('AppKey'), @required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NewtonBloc>(
      key: Key('AppBlocProvider'),
      create: (_) => bloc,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Newton2',
        home: NewtonBuilder(),
      ),
    );
  }
}
