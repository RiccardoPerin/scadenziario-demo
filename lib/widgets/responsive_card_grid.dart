import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Griglia di card a colonne di uguale larghezza, responsive: il numero di
/// colonne si adatta allo spazio disponibile (la larghezza dello schermo) in
/// modo che ogni card resti larga almeno [minWidth] (restando leggibile),
/// senza mai superare [maxColumns]. A parità di numero di colonne le card si
/// allargano per riempire tutto lo spazio disponibile, invece di lasciare
/// spazio vuoto sugli schermi più larghi. Sotto [minWidth] per una sola
/// colonna le card vengono impilate a piena larghezza (comportamento mobile).
///
/// Con [altezzaUniforme] a `true` tutte le card vengono portate all'altezza
/// della più alta, così che i riquadri risultino tutti uguali; su una sola
/// colonna (mobile) resta l'impilamento normale, dove uniformare l'altezza
/// aggiungerebbe solo spazio vuoto.
class ColumnsCardGrid extends StatelessWidget {
  const ColumnsCardGrid({
    super.key,
    required this.children,
    this.maxColumns = 4,
    this.minWidth = 320,
    this.spacing = 16,
    this.altezzaUniforme = false,
  });

  final List<Widget> children;
  final int maxColumns;
  final double minWidth;
  final double spacing;
  final bool altezzaUniforme;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final larghezzaDisponibile = constraints.maxWidth;
        final colonneCheCiStanno =
            ((larghezzaDisponibile + spacing) / (minWidth + spacing)).floor();
        final colonne = colonneCheCiStanno.clamp(1, maxColumns);

        if (colonne <= 1) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final child in children) ...[
                child,
                if (child != children.last) SizedBox(height: spacing),
              ],
            ],
          );
        }

        if (altezzaUniforme) {
          return _GrigliaAltezzaUniforme(
            colonne: colonne,
            spacing: spacing,
            children: children,
          );
        }

        // Ogni colonna è una Column indipendente (non un Wrap "piatto"): così,
        // quando una card cambia altezza (es. espansione), si spostano solo
        // le card sottostanti nella stessa colonna e non quelle delle altre
        // colonne. La distribuzione round-robin (i % colonne) mantiene lo
        // stesso ordine di lettura per righe che si otterrebbe con un Wrap.
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var col = 0; col < colonne; col++) ...[
              if (col > 0) SizedBox(width: spacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = col; i < children.length; i += colonne) ...[
                      children[i],
                      if (i + colonne < children.length) SizedBox(height: spacing),
                    ],
                  ],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _CellaParentData extends ContainerBoxParentData<RenderBox> {}

/// Dispone i figli in una griglia a [colonne] colonne di uguale larghezza,
/// dando a tutti la stessa altezza: quella del figlio più alto.
class _GrigliaAltezzaUniforme extends MultiChildRenderObjectWidget {
  const _GrigliaAltezzaUniforme({
    required this.colonne,
    required this.spacing,
    required super.children,
  });

  final int colonne;
  final double spacing;

  @override
  _RenderGrigliaAltezzaUniforme createRenderObject(BuildContext context) {
    return _RenderGrigliaAltezzaUniforme(colonne: colonne, spacing: spacing);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderGrigliaAltezzaUniforme renderObject,
  ) {
    renderObject
      ..colonne = colonne
      ..spacing = spacing;
  }
}

class _RenderGrigliaAltezzaUniforme extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _CellaParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _CellaParentData> {
  _RenderGrigliaAltezzaUniforme({
    required int colonne,
    required double spacing,
  }) : _colonne = colonne,
       _spacing = spacing;

  int _colonne;
  int get colonne => _colonne;
  set colonne(int value) {
    if (_colonne == value) return;
    _colonne = value;
    markNeedsLayout();
  }

  double _spacing;
  double get spacing => _spacing;
  set spacing(double value) {
    if (_spacing == value) return;
    _spacing = value;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _CellaParentData) {
      child.parentData = _CellaParentData();
    }
  }

  double _larghezzaCella(double larghezzaDisponibile) {
    final larghezza =
        (larghezzaDisponibile - _spacing * (_colonne - 1)) / _colonne;
    return larghezza < 0 ? 0 : larghezza;
  }

  int get _righe => (childCount / _colonne).ceil();

  @override
  void performLayout() {
    final larghezza = constraints.maxWidth;
    if (childCount == 0) {
      size = constraints.constrain(Size(larghezza, 0));
      return;
    }
    final larghezzaCella = _larghezzaCella(larghezza);

    // Prima passata: misura l'altezza naturale di ogni riquadro alla
    // larghezza della colonna.
    var altezzaMassima = 0.0;
    final vincoliMisura = BoxConstraints.tightFor(width: larghezzaCella);
    var child = firstChild;
    while (child != null) {
      child.layout(vincoliMisura, parentUsesSize: true);
      if (child.size.height > altezzaMassima) {
        altezzaMassima = child.size.height;
      }
      child = (child.parentData! as _CellaParentData).nextSibling;
    }

    // Seconda passata: tutti i riquadri alti quanto il più alto. L'altezza va
    // imposta come minimo e non come vincolo "tight": con vincoli tight ogni
    // riquadro diventerebbe un relayout boundary, quindi quando il suo
    // contenuto cambia altezza (es. una card che si espande) la richiesta di
    // layout non risalirebbe fino a questa griglia, che continuerebbe a
    // imporre la vecchia altezza lasciando il contenuto fuori dalla card.
    // Il risultato è identico, perché nessun riquadro può superare l'altezza
    // massima misurata nella prima passata alla stessa larghezza.
    final vincoliCella = BoxConstraints(
      minWidth: larghezzaCella,
      maxWidth: larghezzaCella,
      minHeight: altezzaMassima,
    );
    var i = 0;
    child = firstChild;
    while (child != null) {
      final parentData = child.parentData! as _CellaParentData;
      child.layout(vincoliCella, parentUsesSize: true);
      parentData.offset = Offset(
        (i % _colonne) * (larghezzaCella + _spacing),
        (i ~/ _colonne) * (altezzaMassima + _spacing),
      );
      child = parentData.nextSibling;
      i++;
    }

    size = constraints.constrain(
      Size(larghezza, _righe * altezzaMassima + (_righe - 1) * _spacing),
    );
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    if (childCount == 0) {
      return constraints.constrain(Size(constraints.maxWidth, 0));
    }
    final vincoliMisura = BoxConstraints.tightFor(
      width: _larghezzaCella(constraints.maxWidth),
    );
    var altezzaMassima = 0.0;
    var child = firstChild;
    while (child != null) {
      final altezza = child.getDryLayout(vincoliMisura).height;
      if (altezza > altezzaMassima) altezzaMassima = altezza;
      child = (child.parentData! as _CellaParentData).nextSibling;
    }
    return constraints.constrain(
      Size(
        constraints.maxWidth,
        _righe * altezzaMassima + (_righe - 1) * _spacing,
      ),
    );
  }

  double _larghezzaIntrinseca(double Function(RenderBox child) larghezzaCella) {
    var larghezzaMassimaCella = 0.0;
    var child = firstChild;
    while (child != null) {
      final larghezza = larghezzaCella(child);
      if (larghezza > larghezzaMassimaCella) larghezzaMassimaCella = larghezza;
      child = (child.parentData! as _CellaParentData).nextSibling;
    }
    return larghezzaMassimaCella * _colonne + _spacing * (_colonne - 1);
  }

  @override
  double computeMinIntrinsicWidth(double height) =>
      _larghezzaIntrinseca((child) => child.getMinIntrinsicWidth(height));

  @override
  double computeMaxIntrinsicWidth(double height) =>
      _larghezzaIntrinseca((child) => child.getMaxIntrinsicWidth(height));

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}

/// Griglia di card responsive: su schermi larghi dispone le card in un
/// [Wrap] a larghezza intrinseca (comportamento "a griglia"), su schermi
/// stretti (mobile) le impila a piena larghezza in un'unica colonna, così
/// da restare leggibili invece di essere centrate e ritagliate.
class ResponsiveCardGrid extends StatelessWidget {
  const ResponsiveCardGrid({
    super.key,
    required this.children,
    this.minWidth = 240,
    this.maxWidth = 460,
    this.spacing = 16,
  });

  final List<Widget> children;
  final double minWidth;
  final double maxWidth;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < minWidth * 2 + spacing) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final child in children) ...[
                child,
                if (child != children.last) SizedBox(height: spacing),
              ],
            ],
          );
        }
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: children
              .map(
                (child) => ConstrainedBox(
                  constraints: BoxConstraints(minWidth: minWidth, maxWidth: maxWidth),
                  child: IntrinsicWidth(child: child),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

/// Layout a due colonne (es. "elenco principale" + "pannello laterale") che
/// su schermi larghi affianca [left] e [right] separandoli con un bordo
/// verticale, mentre su mobile li impila in colonna per evitare che le due
/// colonne diventino troppo strette per essere leggibili.
class ResponsiveSplit extends StatelessWidget {
  const ResponsiveSplit({
    super.key,
    required this.left,
    required this.right,
    this.leftFlex = 1,
    this.rightFlex = 1,
    this.breakpoint = 700,
  });

  final Widget left;
  final Widget right;
  final int leftFlex;
  final int rightFlex;
  final double breakpoint;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < breakpoint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [left, const SizedBox(height: 24), right],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: leftFlex, child: left),
            const SizedBox(width: 20),
            Expanded(
              flex: rightFlex,
              child: Container(
                padding: const EdgeInsets.only(left: 20),
                decoration: const BoxDecoration(
                  border: Border(left: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
                ),
                child: right,
              ),
            ),
          ],
        );
      },
    );
  }
}
