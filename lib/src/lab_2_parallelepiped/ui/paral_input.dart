import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newton_2/src/lab_2_parallelepiped/bloc/paral.dart';
import 'package:newton_2/src/storage/field_storage.dart';

/// Виджет для ввода значений полинома по их названиям.
///
/// Каждый [FieldBuilder] позволяет вводить нужное значение, а [FieldPopUp]
/// позволяет выбрать из списка одно значение.
/// В ситуации, когда все поля заполнены и нет ошибок, кнопка [BuildButton]
/// становится разблокированной и позволяет построить график
class ParalInput extends StatelessWidget {
  ParalInput({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final bloc = BlocProvider.of<ParalBloc>(context);

    return StreamBuilder<ParalState>(
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  getRowOfFields('A', 'B', bloc),
                  getRowOfFields('C', 'D', bloc),
                  getRowOfFields('alpha', 'betta', bloc),
                  getRowOfFields('delta', 'epsilon', bloc),
                  getRowOfFields('mu', 'n', bloc),
                  getRowOfFields('a', 'b', bloc),
                  FieldPopUp(storage: bloc.getField('dx')),
                  RadioField(storage: bloc.getField('builder')),
                  SizedBox(height: 15),
                  BuildButton(bloc: bloc),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget getRowOfFields(String left, String right, ParalBloc bloc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: SizedBox(
        height: 40,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(child: FieldBuilder(storage: bloc.getField(left))),
            SizedBox(width: 20),
            Expanded(child: FieldBuilder(storage: bloc.getField(right))),
          ],
        ),
      ),
    );
  }
}

class RadioField extends StatelessWidget {
  final FieldStorage<String> storage;

  RadioField({Key key, @required this.storage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      initialData: storage.initValue,
      stream: storage.valueStream,
      builder: (_, snap) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            getRadio('alpha', snap.data),
            getRadio('betta', snap.data),
            getRadio('delta', snap.data),
            getRadio('epsilon', snap.data),
            getRadio('mu', snap.data),
          ],
        );
      },
    );
  }

  Widget getRadio(String value, String current) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio(
          value: value,
          groupValue: current,
          onChanged: storage.changeValue,
        ),
        Text(value),
      ],
    );
  }
}

class BuildButton extends StatelessWidget {
  final ParalBloc bloc;

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
                : () => BlocProvider.of<ParalBloc>(context)
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
      initialData: storage.initValue,
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
                    'dx : ${snap.data}',
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
          'Лаба №2\n'
          'α * sin(β * x) + δ * cos(ε / (x - μ)^2)\n'
          '®Адрианов Алексей ИТ-31, 2020',
          style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}
