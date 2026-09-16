import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gestionale_edile/widgets/responsive_card_grid.dart';

Widget _riquadro(String testo, double altezza) {
  return Card(
    key: ValueKey(testo),
    child: SizedBox(height: altezza, child: Text(testo)),
  );
}

void main() {
  testWidgets('altezzaUniforme porta tutte le card all\'altezza della più alta',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 1000,
            child: ListView(
              children: [
                ColumnsCardGrid(
                  maxColumns: 2,
                  minWidth: 300,
                  altezzaUniforme: true,
                  children: [
                    _riquadro('a', 50),
                    _riquadro('b', 200),
                    _riquadro('c', 80),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final altezze = [
      for (final t in ['a', 'b', 'c'])
        tester.getSize(find.byKey(ValueKey(t))).height,
    ];
    expect(altezze[0], altezze[1]);
    expect(altezze[1], altezze[2]);
    expect(altezze[0], greaterThanOrEqualTo(200));

    // Due colonne affiancate, terza card sulla riga sotto.
    final a = tester.getTopLeft(find.byKey(const ValueKey('a')));
    final b = tester.getTopLeft(find.byKey(const ValueKey('b')));
    final c = tester.getTopLeft(find.byKey(const ValueKey('c')));
    expect(a.dy, b.dy);
    expect(b.dx, greaterThan(a.dx));
    expect(c.dy, greaterThan(a.dy));
    expect(c.dx, a.dx);
  });

  testWidgets('senza altezzaUniforme le card mantengono la propria altezza',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 1000,
            child: ListView(
              children: [
                ColumnsCardGrid(
                  maxColumns: 2,
                  minWidth: 300,
                  children: [_riquadro('a', 50), _riquadro('b', 200)],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(
      tester.getSize(find.byKey(const ValueKey('a'))).height,
      lessThan(tester.getSize(find.byKey(const ValueKey('b'))).height),
    );
  });

  testWidgets(
    'altezzaUniforme: espandendo una card la griglia si ri-dimensiona',
    (tester) async {
      var espansa = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 1000,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return ListView(
                    children: [
                      ColumnsCardGrid(
                        maxColumns: 2,
                        minWidth: 300,
                        altezzaUniforme: true,
                        children: [
                          Card(
                            key: const ValueKey('a'),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 50),
                                IconButton(
                                  key: const ValueKey('toggle'),
                                  icon: const Icon(Icons.expand_more),
                                  onPressed: () =>
                                      setState(() => espansa = !espansa),
                                ),
                                AnimatedSize(
                                  duration: const Duration(milliseconds: 400),
                                  child: espansa
                                      ? const SizedBox(
                                          height: 300,
                                          width: double.infinity,
                                        )
                                      : const SizedBox(width: double.infinity),
                                ),
                              ],
                            ),
                          ),
                          _riquadro('b', 80),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      final altezzaChiusa = tester.getSize(find.byKey(const ValueKey('a'))).height;

      await tester.tap(find.byKey(const ValueKey('toggle')));
      await tester.pumpAndSettle();

      final altezzaAperta = tester.getSize(find.byKey(const ValueKey('a'))).height;
      expect(
        altezzaAperta,
        greaterThan(altezzaChiusa),
        reason: 'la card espansa deve crescere invece di sovrapporsi',
      );
      // E le card restano tutte alte uguale.
      expect(
        tester.getSize(find.byKey(const ValueKey('b'))).height,
        altezzaAperta,
      );
    },
  );
}
