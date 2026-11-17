import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:handtext_ai/services/uncertain_ranges.dart';

void main() {
  const first = TextRange(start: 0, end: 4);
  const second = TextRange(start: 5, end: 10);
  test('convierte puntos Unicode a UTF-16 sin alterar el texto', () {
    const text = '🙂 duda';
    final ranges = rangesFromApi(text, [
      {'start': 2, 'end': 6},
    ]);
    expect(ranges, [const TextRange(start: 3, end: 7)]);
    expect(ranges.single.textInside(text), 'duda');
    expect(rangesFromApi(text, null), isEmpty);
  });
  test(
    'descarta vacíos, negativos, fuera del texto, solapados y desordenados',
    () {
      expect(
        rangesFromApi('hola mundo', [
          null,
          {'start': -1, 'end': 2},
          {'start': 0, 'end': 0},
          {'start': 0, 'end': 4},
          {'start': 2, 'end': 6},
          {'start': 5, 'end': 99},
          {'start': 5, 'end': 10},
          {'start': 0, 'end': 2},
        ]),
        [first, second],
      );
      expect(
        validRanges('hola mundo', [
          const TextRange(start: -1, end: 2),
          first,
          const TextRange(start: 2, end: 5),
          second,
          const TextRange(start: 9, end: 11),
        ]),
        [first, second],
      );
    },
  );
  test('editar una palabra elimina su marca y conserva las siguientes', () {
    expect(adjustRanges('hola mundo', 'hoLA mundo', [first, second]), [second]);
    expect(adjustRanges('hola mundo', ' mundo', [first, second]), [
      const TextRange(start: 1, end: 6),
    ]);
    expect(adjustRanges('hola mundo', 'hola nueva mundo', [first, second]), [
      first,
      const TextRange(start: 11, end: 16),
    ]);
  });
  test(
    'pegar letras al principio o final modifica la palabra; puntuación no',
    () {
      expect(adjustRanges('hola', 'xhola', [first]), isEmpty);
      expect(adjustRanges('hola', 'holax', [first]), isEmpty);
      expect(adjustRanges('hola', 'hola!', [first]), [first]);
      expect(adjustRanges('hola', '!hola', [first]), [
        const TextRange(start: 1, end: 5),
      ]);
      expect(adjustRanges('hola', 'hola', [first]), [first]);
    },
  );
}
