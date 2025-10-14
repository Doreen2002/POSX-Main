import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:flutter/services.dart';
import 'package:offline_pos/controllers/item_screen_controller.dart';

class CalculatorWidget extends StatefulWidget {
  @override
  _CalculatorWidgetState createState() => _CalculatorWidgetState();
}

class _CalculatorWidgetState extends State<CalculatorWidget> {
  String _expression = '';
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto focus when widget is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _onPressed(String text) {
    setState(() {
      if (text == 'C') {
        _expression = '';
      } else if (text == '⌫') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (text == '=') {
        try {
          String finalExpression = _expression
              .replaceAll('×', '*')
              .replaceAll('÷', '/')
              .replaceAll('%', '/100');

          Parser p = Parser();
          Expression exp = p.parse(finalExpression);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);

          if (eval == eval.toInt()) {
            _expression = eval.toInt().toString();
          } else {
            _expression = eval.toString();
          }
        } catch (e) {
          _expression = 'Error';
        }
      } else {
        _expression += text;
      }
    });
  }

  void _handleKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final key = event.logicalKey;
      if (key == LogicalKeyboardKey.enter) {
        _onPressed('=');
      } else if (key == LogicalKeyboardKey.backspace) {
        _onPressed('⌫');
      } else if (key == LogicalKeyboardKey.delete) {
        _onPressed('C');
      } else if (key.keyLabel.isNotEmpty) {
        String label = key.keyLabel;
        if (RegExp(r'^[0-9]$').hasMatch(label)) {
          _onPressed(label);
        } else if (label == '+') {
          _onPressed('+');
        } else if (label == '-') {
          _onPressed('-');
        } else if (label == '*') {
          _onPressed('×');
        } else if (label == '/') {
          _onPressed('÷');
        } else if (label == '%') {
          _onPressed('%');
        } else if (label == '.') {
          _onPressed('.');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttons = [
      'C',
      '⌫',
      '%',
      '+',
      '7',
      '8',
      '9',
      '÷',
      '4',
      '5',
      '6',
      '×',
      '1',
      '2',
      '3',
      '-',
      '0',
      '.',
      '=',
    ];

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF2B3691),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(vertical: 18),
    );

    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _handleKey,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF018644), Color(0xFF033D20)],
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40),
                  const Text(
                    'Calculator',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => {Navigator.pop(context), },
                    
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(12),
              alignment: Alignment.centerRight,
              child: Text(
                _expression,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(height: 1),

            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: buttons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    style: buttonStyle,
                    onPressed: () => _onPressed(buttons[index]),
                    child: Text(
                      buttons[index],
                      style: const TextStyle(fontSize: 20),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
