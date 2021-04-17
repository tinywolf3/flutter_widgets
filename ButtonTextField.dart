import 'package:flutter/material.dart';

/*
  ButtonTextField(
    label: Text('파일: '),
    textController: _txtFilepath,
    hintText: '처리할 파일을 선택하십시오.',
    buttonLabel: Text('선택'),
    onPressed: () {
      _txtValue.text = 'pressed!';
    },
  ),
 */

class ButtonTextField extends StatelessWidget {
  final Widget? label;
  final TextEditingController? textController;
  final TextInputType keyboardType;
  final Color? textColor;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final String? hintText;
  final Color? hintColor;
  final Widget? buttonLabel;
  final void Function(String?)? onChanged;
  final void Function()? onPressed;

  ButtonTextField({ Key? key,
    this.label,
    this.textController,
    this.textColor,
    this.keyboardType = TextInputType.text,
    this.enabledBorderColor,
    this.focusedBorderColor,
    this.hintText,
    this.hintColor,
    this.buttonLabel,
    this.onChanged,
    this.onPressed,
  }): super(key: key);

  final _borderRadiusLeft = BorderRadius.only(
    topLeft: Radius.circular(5),
    bottomLeft: Radius.circular(5),
  );
  final _borderRadiusRight = BorderRadius.only(
    topRight: Radius.circular(5),
    bottomRight: Radius.circular(5),
  );
  final _textNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: IntrinsicColumnWidth(),
        1: FlexColumnWidth(),
        2: IntrinsicColumnWidth(),
      },
      children: [
        TableRow(
          children: [
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: label ?? Container(),
            ),
            TableCell(
              child: TextField(
                controller: textController,
                style: TextStyle(color: textColor ?? (Theme.of(context).textTheme.subtitle1?.color ?? Theme.of(context).primaryColorDark)),
                keyboardType: keyboardType,
                focusNode: _textNode,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(10),
                  hintText: hintText,
                  hintStyle: TextStyle(fontSize: 12.0, fontStyle: FontStyle.italic, color: hintColor ?? Theme.of(context).hintColor),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: _borderRadiusLeft,
                    borderSide: BorderSide(
                      color: enabledBorderColor ?? Theme.of(context).buttonColor,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: _borderRadiusLeft,
                    borderSide: BorderSide(
                      color: focusedBorderColor ?? Theme.of(context).accentColor,
                      width: 2.0,
                    ),
                  ),
                ),
                onChanged: onChanged,
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.fill,
              child: ElevatedButton(
                child: buttonLabel ?? Text(' '),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: _borderRadiusRight,
                  ),
                ),
                onPressed: () {
                  FocusScope.of(context).requestFocus(_textNode);
                  if (onPressed != null)
                    onPressed!();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
