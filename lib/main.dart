import 'package:flutter/material.dart';
import 'package:newton_2/src/app.dart';
import 'package:newton_2/src/bloc/newton.dart';
import 'package:newton_2/src/bloc/newton_bloc.dart';

void main() => runApp(App(bloc: NewtonBloc()..add(InitBlocEvent())));
