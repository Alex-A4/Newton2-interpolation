import 'dart:async';

import 'package:rxdart/rxdart.dart';

/// Хранилище для значения
class FieldStorage<T> {
  final String name;
  final Validator<T> validator;
  final Parser<T> parser;
  final BehaviorSubject<T> _subject;

  T get value => _subject.value;

  Stream<T> get valueStream {
    return _subject.stream
        .debounceTime(Duration(milliseconds: 300))
        .transform(StreamTransformer.fromHandlers(handleData: (T value, sink) {
      if (value != null && (validator == null || validator(value) != null))
        sink.add(value);
      else
        sink.addError('Неправильное значение');
    }));
  }

  FieldStorage(this.name, this.validator, this.parser, T initValue)
      : this._subject = BehaviorSubject.seeded(initValue);

  void changeValue(String value) => _subject.sink.add(parser(value));

  void dispose() {
    _subject.close();
  }
}

/// Функция для валидации поля типа T
typedef Validator<T> = bool Function(T value);

/// Функция для парсинга строки в тип T
typedef Parser<T> = T Function(String value);
