import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newton_2/src/lab_1_newton2/bloc/newton.dart';
import 'package:newton_2/src/storage/field_storage.dart';

/// Виджет для ввода значений полинома по их названиям.
///
/// Каждый [FieldBuilder] позволяет вводить нужное значение, а [FieldPopUp]
/// позволяет выбрать из списка одно значение.
/// В ситуации, когда все поля заполнены и нет ошибок, кнопка [BuildButton]
/// становится разблокированной и позволяет построить график
class NewtonInput extends StatelessWidget {
  NewtonInput({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<NewtonBloc>(context);
    return StreamBuilder<NewtonState>(
      stream: bloc.where((s) => s is InitialState || s is InitializedState),
      builder: (_, snap) {
        if (!snap.hasData) {
          return Container();
        }
        if (snap.data is InitialState) {
          return Container();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InfoField(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  getRowOfFields('A', 'B', bloc),
                  getRowOfFields('C', 'D', bloc),
                  getRowOfFields('alpha', 'betta', bloc),
                  getRowOfFields('delta', 'epsilon', bloc),
                  getRowOfFields('mu', 'n', bloc),
                  FieldPopUp(storage: bloc.getField('h')),
                  SizedBox(height: 30),
                  BuildButton(bloc: bloc),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget getRowOfFields(String left, String right, NewtonBloc bloc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(child: FieldBuilder(storage: bloc.getField(left))),
          SizedBox(width: 20),
          Expanded(child: FieldBuilder(storage: bloc.getField(right))),
        ],
      ),
    );
  }
}

class BuildButton extends StatelessWidget {
  final NewtonBloc bloc;

  BuildButton({Key key, @required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: bloc.buildButton,
        builder: (_, snap) {
          return FlatButton(
            color: Colors.blue,
            textColor: Colors.white,
            child: Text(
              'Построить',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            onPressed: !snap.hasData
                ? null
                : () => BlocProvider.of<NewtonBloc>(context)
                    .add(BuildGraphicEvent()),
          );
        });
  }
}

/// Виджет подписывается на необходимый ему стрим из [storage] и при вводе
/// значений отдаёт их.
class FieldBuilder<T> extends StatelessWidget {
  final FieldStorage<T> storage;
  final TextEditingController controller;

  FieldBuilder({
    Key key,
    @required this.storage,
  })  : this.controller = TextEditingController(text: '${storage.initValue}'),
        super(key: key ?? Key('FieldBuilder-${storage.name}'));

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      key: Key('FieldStorageStream-${storage.name}'),
      stream: storage.valueStream,
      builder: (_, snap) {
        return TextField(
          key: Key('FieldStorageText-${storage.name}'),
          controller: controller,
          textAlign: TextAlign.center,
          maxLines: 1,
          autocorrect: false,
          style: TextStyle(fontSize: 18, color: Colors.black),
          onChanged: storage.changeValue,
          decoration: InputDecoration(
            labelText: storage.name,
            labelStyle: TextStyle(fontSize: 20, color: Colors.grey),
            border: OutlineInputBorder(
              gapPadding: 5,
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(width: 1, color: Colors.grey),
            ),
            errorText: snap.error,
          ),
        );
      },
    );
  }
}

class FieldPopUp extends StatelessWidget {
  final FieldStorage storage;

  FieldPopUp({Key key, @required this.storage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      initialData: storage.value,
      stream: storage.valueStream,
      builder: (_, snap) {
        var value = snap.data;
        return PopupMenuButton<double>(
          initialValue: value,
          itemBuilder: (_) => [
            PopupMenuItem(child: Text('0.0001'), value: 0.0001),
            PopupMenuItem(child: Text('0.001'), value: 0.001),
            PopupMenuItem(child: Text('0.01'), value: 0.01),
            PopupMenuItem(child: Text('0.1'), value: 0.1),
            PopupMenuItem(child: Text('1'), value: 1),
          ],
          child: Card(
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'h : ${snap.data}',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.white),
                ],
              ),
            ),
          ),
          onSelected: (v) => storage.changeValue(v.toString()),
        );
      },
    );
  }
}

class InfoField extends StatelessWidget {
  InfoField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[350],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          'Лаба №1\n'
          'α * sin(β * x) + δ * cos(ε / (x - μ)^2)\n'
          '®Адрианов Алексей ИТ-31, 2020',
          style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}
