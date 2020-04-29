import 'package:flutter/material.dart';
import 'package:newton_2/src/lab_1_newton2/app.dart';
import 'package:newton_2/src/lab_2_parallelepiped/app.dart';
import 'package:newton_2/src/lab_2_parallelepiped/bloc/paral.dart' as p;

import 'src/lab_1_newton2/bloc/newton.dart';

void main() => runApp(LabSelector());

class LabSelector extends StatelessWidget {
  LabSelector({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (_) => HomePage(),
        '/lab1': (_) => AppNewton2(bloc: NewtonBloc()..add(InitBlocEvent())),
        '/lab2': (_) =>
            AppParallelepiped(bloc: p.ParalBloc()..add(p.InitBlocEvent())),
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
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Выберите номер лабы'),
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
