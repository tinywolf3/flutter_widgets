import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/*
  NumberTextField(
    label: Text('질량: '),
    hintText: '대상의 질량을 입력하십시오.',
    stepValue: 0.1,
    unitText: 'kg',
    minValue: 0,
    maxValue: 10,
    onChanged: (value) {
      print(value);
    },
  ),
 */

class NumberTextField extends StatefulWidget {
  final Widget? label;
  final TextEditingController? textController;
  final TextInputType keyboardType;
  final Color? textColor;
  final NumberFormat? format;
  final String? unitText;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final String? hintText;
  final Color? hintColor;
  final double initValue;
  final double minValue;
  final double maxValue;
  final double stepValue;
  final void Function(double)? onChanged;

  NumberTextField({ Key? key,
    this.label,
    this.textController,
    this.textColor,
    this.keyboardType = TextInputType.number,
    this.format,
    this.unitText,
    this.enabledBorderColor,
    this.focusedBorderColor,
    this.hintText,
    this.hintColor,
    this.initValue = 0,
    this.minValue = double.negativeInfinity,
    this.maxValue = double.infinity,
    this.stepValue = 1,
    this.onChanged,
  }) : super(key: key);

  @override
  _NumberTextFieldState createState() => _NumberTextFieldState();
}

class _NumberTextFieldState extends State<NumberTextField> {
  final _borderRadiusLeft = BorderRadius.only(
    topLeft: Radius.circular(5),
    bottomLeft: Radius.circular(5),
  );
  final _borderRadiusCenter = BorderRadius.zero;
  final _borderRadiusRight = BorderRadius.only(
    topRight: Radius.circular(5),
    bottomRight: Radius.circular(5),
  );
  final _textNode = FocusNode();

  late double _value;
  late TextEditingController _controller;
  late NumberFormat _format;
  String _prefix = '';
  Widget? _minmax;
  final _minIcon = Padding(padding: EdgeInsets.only(left: 4),
    child: Icon(Icons.vertical_align_bottom,
      color: Colors.red,
      size: 16,
    ),
  );
  final _maxIcon = Padding(padding: EdgeInsets.only(left: 4),
    child: Icon(Icons.vertical_align_top,
      color: Colors.green,
      size: 16,
    ),
  );

  @override
  initState(){
    if (widget.initValue < widget.minValue)
      _value = widget.minValue;
    else if (widget.initValue > widget.maxValue)
      _value = widget.maxValue;
    else
      _value = widget.initValue;
    _controller = widget.textController ?? TextEditingController();
    _format = NumberFormat("#,##0.#");
    _controller.text = _format.format(_value);
    _textNode.addListener(() {
      _controller.text = _format.format(_value);
      setState(() {
        _prefix = '';
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _textNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth(),
        2: IntrinsicColumnWidth(),
        3: IntrinsicColumnWidth(),
        4: IntrinsicColumnWidth(),
      },
      children: [
        TableRow(
          children: [
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: widget.label ?? Container(),
            ),
            TableCell(
              child: TextField(
                controller: _controller,
                textAlign: TextAlign.right,
                style: TextStyle(color: widget.textColor ?? (Theme.of(context).textTheme.subtitle1?.color ?? Theme.of(context).primaryColorDark)),
                keyboardType: widget.keyboardType,
                focusNode: _textNode,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(10),
                  prefixText: _prefix,
                  prefixIcon: _minmax,
                  prefixIconConstraints: BoxConstraints(
                    minHeight: 1,
                  ),
                  suffixText: widget.unitText,
                  hintText: widget.hintText,
                  hintStyle: TextStyle(fontSize: 12.0, fontStyle: FontStyle.italic, color: widget.hintColor ?? Theme.of(context).hintColor),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: _borderRadiusLeft,
                    borderSide: BorderSide(
                      color: widget.enabledBorderColor ?? Theme.of(context).buttonColor,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: _borderRadiusLeft,
                    borderSide: BorderSide(
                      color: widget.focusedBorderColor ?? Theme.of(context).accentColor,
                      width: 2.0,
                    ),
                  ),
                ),
                onChanged: (value) {
                  var calc = false;
                  var num = double.tryParse(_controller.text);
                  if (num == null) {
                    final evaluator = const ExpressionEvaluator();
                    final exp = Expression.tryParse(_controller.text);
                    if (exp != null) {
                      try {
                        final res = evaluator.eval(exp, {});
                        if (res != null) {
                          num = double.parse(res.toString());
                          calc = true;
                        }
                      } catch(e) {}
                    }
                  }
                  if (num == null)
                    return;
                  _value = num;
                  if (_value <= widget.minValue) {
                    _value = widget.minValue;
                    setState(() {
                      _minmax = _minIcon;
                    });
                  }
                  else if (_value >= widget.maxValue) {
                    _value = widget.maxValue;
                    setState(() {
                      _minmax = _maxIcon;
                    });
                  }
                  else {
                    setState(() {
                      _minmax = null;
                    });
                  }
                  if (calc) {
                    setState(() {
                      _prefix = _format.format(_value) + ' = ';
                    });
                  }
                  else if (_prefix.length > 0) {
                    setState(() {
                      _prefix = '';
                    });
                  }
                  if (widget.onChanged != null) {
                    widget.onChanged!(_value);
                  }
                },
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.fill,
              child: SizedBox(
                width: 32,
                child: ElevatedButton(
                  child: Icon(
                    Icons.remove,
                    size: 16,
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: _borderRadiusCenter,
                    ),
                  ),
                  onPressed: () {
                    _value = ((_value / widget.stepValue).round() - 1) * widget.stepValue;
                    if (_value <= widget.minValue) {
                      _value = widget.minValue;
                      setState(() {
                        _minmax = _minIcon;
                      });
                    }
                    else if (_minmax != null) {
                      setState(() {
                        _minmax = null;
                      });
                    }
                    _controller.text = _format.format(_value);
                    _controller.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: _controller.text.length);
                    if (_prefix.length > 0) {
                      setState(() {
                        _prefix = '';
                      });
                    }
                    FocusScope.of(context).requestFocus(_textNode);
                    if (widget.onChanged != null) {
                      widget.onChanged!(_value);
                    }
                  },
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.fill,
              child: ColoredBox(
                color: Theme.of(context).primaryColor,
                child: SizedBox(
                  width: 1,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: ColoredBox(
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.fill,
              child: SizedBox(
                width: 32,
                child: ElevatedButton(
                  child: Icon(
                    Icons.add,
                    size: 16,
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: _borderRadiusRight,
                    ),
                  ),
                  onPressed: () {
                    _value = ((_value / widget.stepValue).round() + 1) * widget.stepValue;
                    if (_value >= widget.maxValue) {
                      _value = widget.maxValue;
                      setState(() {
                        _minmax = _maxIcon;
                      });
                    }
                    else if (_minmax != null) {
                      setState(() {
                        _minmax = null;
                      });
                    }
                    _controller.text = _format.format(_value);
                    _controller.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: _controller.text.length);
                    if (_prefix.length > 0) {
                      setState(() {
                        _prefix = '';
                      });
                    }
                    FocusScope.of(context).requestFocus(_textNode);
                    if (widget.onChanged != null) {
                      widget.onChanged!(_value);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
