import 'package:calculator_app/calcButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorView extends StatefulWidget {
  const CalculatorView({Key? key}) : super(key: key);

  @override
  State<CalculatorView> createState() => _CalculatorViewState();
}

//we use these variables to descibe the view state of the calculator interface
//we set the equation size smaller and the result font size relatively larger
// string variables of the equation, result and expression are set to 0
class _CalculatorViewState extends State<CalculatorView> {
  String equation = "0";
  String result = "0";
  String expression = "0";
  double equationFontSize = 30.0;
  double resultFontSize = 40.0;

  buttonPressed(String buttonText) {
// used to check if the result contains a decimal
    String doesContainDecimal(dynamic result) {
      if (result.toString().contains('.')) {
        List<String> splitDecimal = result.toString().split('.');
        if (!(int.parse(splitDecimal[1]) > 0)) {
          return result = splitDecimal[0].toString();
        }
      }

      return result;
    }

    setState(() {
      if (buttonText == "AC") {
        equation = "0";
        result = "0";
      } else if (buttonText == "⌫") {
        equation = equation.substring(0, equation.length - 1);

        if (equation == "") {
          equation = "0";
        }
      } else if (buttonText == "+/-") {
        if (equation[0] != '-') {
          equation = '-$equation';
        } else {
          equation = equation.substring(1);
        }
      } else if (buttonText == "=") {
        expression = equation;
        expression = expression.replaceAll('×', '*');
        expression = expression.replaceAll('÷', '/');
        expression = expression.replaceAll('%', '%');

        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);

          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
          if (expression.contains('%')) {
            result = doesContainDecimal(result);
          }
        } catch (e) {
          result = "Error";
        }
      } else {
        if (equation == "0") {
          equation = buttonText;
        } else {
          equation = equation + buttonText;
        }
      }
    });

    //the logic behing the calculator is now completed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orange,
        leading: const Icon(
          Icons.settings,
          color: Colors.orange,
        ),
        actions: const [
          Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Text(
                'DEG',
                style: TextStyle(color: Colors.white),
              )),
          SizedBox(width: 20),
        ],
      ),

      //now in the body property of the scaffold widget we shall add the main axis allignment.end to
      //ensure that the children of the column are alligned towards the bottom of the screen

      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Align(
              alignment: Alignment.bottomRight,
              //to ensure all the elements of the column allign in the bottom of the screen
              child: SingleChildScrollView(
                //we add a scroll view on a horizontal axis
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .end, //we then add a row with its edgeinsets and the result variable t
                      //to display the result
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: Text(result,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 80,
                                ))),
                        const Icon(
                          Icons.more_vert,
                          color: Colors.orange,
                          size: 30,
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                    Row(
                      //we now add another row to display the equation that we type in the calculator

                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Text(
                            equation,
                            style: const TextStyle(
                              fontSize: 40,
                              color: Colors.white38,
                            ),
                          ),
                        ),
                        IconButton(
                          //we  now add an icon button for backspace
                          icon: const Icon(Icons.backspace_outlined,
                              color: Colors.orange, size: 30),
                          onPressed: () {
                            buttonPressed("⌫");
                          },
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ),

//now we shall add the calculator buttons that allow users to input their numbers in order to perform calculations
//we shall add them in a grid view/in rows and columns so they are easily accessible by user
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              ///this allignment keeps all the children buttons spaced evernly
              children: [
//we use the calcbutton function that has variables of button text, color, and the buttonpressed funtion
//on top we shall add multiply, divide, moduolo and the AC buttons- like in a physical calculator
                calcButton('AC', Colors.white10, () => buttonPressed('AC')),
                calcButton('%', Colors.white10, () => buttonPressed('%')),
                calcButton('÷', Colors.white10, () => buttonPressed('÷')),
                calcButton('x', Colors.white10, () => buttonPressed('x')),
              ],
            ),
            const SizedBox(height: 2),

//now we add the next row which has the numerals 7,8,9 and the minus operator

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                calcButton(
                    '7',
                    Colors.white24,
                    () => buttonPressed(
                        '7')), //we give the numerals slightly different color from the other buttons for a better UI
                calcButton('8', Colors.white24, () => buttonPressed('8')),
                calcButton('9', Colors.white24, () => buttonPressed('9')),
                calcButton('-', Colors.white, () => buttonPressed('-'))
              ],
            ),
            const SizedBox(height: 2),
//we now create another row in a sized box, containing the next four numerals 4,5,6,and + operator at the end so it alligns with the - operator above

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                calcButton('4', Colors.white24, () => buttonPressed('4')),
                calcButton('5', Colors.white24, () => buttonPressed('5')),
                calcButton('6', Colors.white24, () => buttonPressed('6')),
                calcButton('+', Colors.white24, () => buttonPressed('+'))
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceEvenly, //these are the last 3 buttons left and we need a symmetric arrangment
              children: [
                Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // so we add the column in this row so that the spacearound allignment can be implemented, now in this column we shall add a row
                  children: [
                    Row(
                      children: [
                        calcButton(
                            '1', Colors.white24, () => buttonPressed('1')),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.08),
                        calcButton(
                            '2', Colors.white24, () => buttonPressed('2')),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.08),
                        calcButton(
                            '3', Colors.white24, () => buttonPressed('3')),
                      ],
                    ),
//now we add a final row containing the +/- button, 0 button and the decimal button '.'

                    const SizedBox(
                      height: 2,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        calcButton(
                            '+/-', Colors.white24, () => buttonPressed('+/-')),
                        // since we have 3 buttons, we'll use sizedboxes to add some space between them,

                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.08),
                        calcButton(
                            '0', Colors.white24, () => buttonPressed('0')),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.08,
                        ),
                        calcButton(
                            '.', Colors.white10, () => buttonPressed('.')),
                      ],
                    ),
                  ],
                  //this is the main action button so we turn it orange
                ),
                calcButton('=', Colors.orange, () => buttonPressed('=')),
              ],
            ),
          ],
        ),
      ),
    );

    //the user interface of the calculator is now completed,
  }
}
