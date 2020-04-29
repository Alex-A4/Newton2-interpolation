import 'package:flutter/material.dart';
import 'package:newton_2/src/lab_1_newton2/app.dart';
import 'package:newton_2/src/lab_2_parallelepiped/app.dart';
import 'package:newton_2/src/lab_2_parallelepiped/bloc/paral.dart' as p;

import 'src/lab_1_newton2/bloc/newton.dart';

void main() {
  // ignore: close_sinks
  final newtonBloc = NewtonBloc()..add(InitBlocEvent());
  // ignore: close_sinks
  final paralBloc = p.ParalBloc()..add(p.InitBlocEvent());
  runApp(LabSelector(newtonBloc: newtonBloc, paralBloc: paralBloc));
}

class LabSelector extends StatelessWidget {
  final NewtonBloc newtonBloc;
  final p.ParalBloc paralBloc;

  LabSelector({Key key, @required this.newtonBloc, @required this.paralBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (_) => HomePage(),
        '/lab1': (_) => AppNewton2(bloc: newtonBloc),
        '/lab2': (_) => AppParallelepiped(bloc: paralBloc),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Проект разработал Адрианов Алексей ИТ-31, 2020'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Выберите номер лабы',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text('Лаба №1'),
                  onPressed: () => Navigator.of(context).pushNamed('/lab1'),
                ),
                SizedBox(width: 30),
                FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text('Лаба №2'),
                  onPressed: () => Navigator.of(context).pushNamed('/lab2'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
