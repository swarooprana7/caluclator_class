import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  late CalculatorLogic _calculatorLogic;

  @override
  void initState() {
    super.initState();
    _calculatorLogic = CalculatorLogic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calculator',
          style: TextStyle(fontFamily: 'OpenSans'),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: CalculatorDisplay(expression: _calculatorLogic.expression),
          ),
          Expanded(
            flex: 2,
            child: CalculatorButtons(
              buttons: _calculatorLogic.buttons,
              onButtonPressed: (buttonText) {
                setState(() {
                  _calculatorLogic.onButtonPressed(buttonText);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CalculatorDisplay extends StatelessWidget {
  final String expression;

  const CalculatorDisplay({super.key, required this.expression});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.grey[300],
      child: Align(
        alignment: Alignment.bottomRight,
        child: Text(
          expression,
          style: const TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}

class CalculatorButtons extends StatelessWidget {
  final List<CalculatorButtonModel> buttons;
  final Function(String) onButtonPressed;

  const CalculatorButtons(
      {super.key, required this.buttons, required this.onButtonPressed});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemBuilder: (context, index) {
        return CalculatorButton(
          model: buttons[index],
          onPressed: () => onButtonPressed(buttons[index].value),
        );
      },
      itemCount: buttons.length,
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final CalculatorButtonModel model;
  final Function onPressed;

  const CalculatorButton(
      {super.key, required this.model, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => onPressed(),
          child: Text(
            model.label,
            style: const TextStyle(fontSize: 24.0),
          ),
        ),
      ),
    );
  }
}

class CalculatorButtonModel {
  final String label;
  final String value;

  CalculatorButtonModel({required this.label, required this.value});
}

class CalculatorLogic {
  late String _expression;

  String get expression => _expression;

  List<CalculatorButtonModel> buttons = [
    CalculatorButtonModel(label: 'AC', value: 'AC'),
    CalculatorButtonModel(label: 'C', value: 'C'),
    CalculatorButtonModel(label: '/', value: '/'),
    CalculatorButtonModel(label: '*', value: '*'),
    CalculatorButtonModel(label: '7', value: '7'),
    CalculatorButtonModel(label: '8', value: '8'),
    CalculatorButtonModel(label: '9', value: '9'),
    CalculatorButtonModel(label: '+', value: '+'),
    CalculatorButtonModel(label: '4', value: '4'),
    CalculatorButtonModel(label: '5', value: '5'),
    CalculatorButtonModel(label: '6', value: '6'),
    CalculatorButtonModel(label: '-', value: '-'),
    CalculatorButtonModel(label: '1', value: '1'),
    CalculatorButtonModel(label: '2', value: '2'),
    CalculatorButtonModel(label: '3', value: '3'),
    CalculatorButtonModel(label: '%', value: '%'),
    CalculatorButtonModel(label: '0', value: '0'),
    CalculatorButtonModel(label: '.', value: '.'),
    CalculatorButtonModel(label: '=', value: '='),
  ];

  CalculatorLogic() {
    _expression = '';
  }

  void onButtonPressed(String buttonText) {
    if (buttonText == 'C') {
      _expression = '';
    } else if (buttonText == 'AC') {
      if (_expression.isNotEmpty) {
        _expression = _expression.substring(0, _expression.length - 1);
      }
    } else if (buttonText == '=') {
      try {
        _expression = evaluateExpression(_expression).toString();
      } catch (e) {
        _expression = 'Error';
      }
    } else if (_isOperator(buttonText)) {
      // Check if the last character is not an operator
      if (_expression.isNotEmpty &&
          !_isOperator(_expression[_expression.length - 1])) {
        _expression += buttonText;
      }
    } else {
      _expression += buttonText;
    }
  }

  bool _isOperator(String buttonText) {
    return buttonText == '+' ||
        buttonText == '-' ||
        buttonText == '*' ||
        buttonText == '/';
  }

  double evaluateExpression(String expression) {
    try {
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      return exp.evaluate(EvaluationType.REAL, cm);
    } catch (e) {
      throw Exception("Invalid expression");
    }
  }
}
