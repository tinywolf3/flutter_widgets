import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';
import 'package:hovering/hovering.dart';

/*
  DropdownTextField(
    label: Text('이름: '),
    textController: _txtName,
    hintText: '검색할 이름을 선택하십시오.',
    dropItems: _listNames,
    initItem: 0,
    onChanged: (value) {
      print(value);
    },
  ),
 */

class DropdownTextField extends StatefulWidget {
  final Text? label;
  final TextEditingController? textController;
  final Color? textColor;
  final TextInputType keyboardType;
  final String? hintText;
  final Color? hintColor;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final List<String> dropItems;
  final int initItem; // 초기 아이템
  final bool item0direct; // 0번째 아이템을 직접입력으로 취급할 경우 true로 설정
  final Color? dropTextColor;
  final Color? dropButtonColor;
  final Color? dropHoverColor;
  final Color? dropListColor;
  final void Function(String?)? onChanged;
  final void Function(int)? onItemChanged;

  DropdownTextField({ Key? key,
    this.label,
    this.textController,
    this.textColor,
    this.keyboardType = TextInputType.text,
    this.hintText,
    this.hintColor,
    this.enabledBorderColor,
    this.focusedBorderColor,
    this.dropItems = const [''],
    this.initItem = 0,
    this.item0direct = true,
    this.dropTextColor,
    this.dropButtonColor,
    this.dropHoverColor,
    this.dropListColor,
    this.onChanged,
    this.onItemChanged,
  }): super(key: key);

  @override
  _DropdownTextFieldState createState() => _DropdownTextFieldState();
}

class _DropdownTextFieldState extends State<DropdownTextField> {
  final _borderRadiusLeft = BorderRadius.only(
    topLeft: Radius.circular(5),
    bottomLeft: Radius.circular(5),
  );
  final _borderRadiusRight = BorderRadius.only(
    topRight: Radius.circular(5),
    bottomRight: Radius.circular(5),
  );
  final _textNode = FocusNode();

  late final TextEditingController _controller;
  late int _value;

  @override
  initState(){
    _controller = widget.textController ?? TextEditingController();
    if (widget.initItem < 0 || widget.initItem >= widget.dropItems.length)
      _value = 0;
    else
      _value = widget.initItem;
    super.initState();
  }

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
              child: widget.label ?? Container(),
            ),
            TableCell(
              child: TextField(
                controller: _controller,
                style: TextStyle(color: widget.textColor ?? (Theme.of(context).textTheme.subtitle1?.color ?? Theme.of(context).primaryColorDark)),
                keyboardType: widget.keyboardType,
                focusNode: _textNode,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(10),
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
                  final idx = widget.dropItems.indexOf(value);
                  if (idx >= 0) {
                    setState(() {
                      _value = idx;
                    });
                  }
                  else if (widget.item0direct) {
                    setState(() {
                      _value = 0;
                    });
                  }
                  if (widget.onChanged != null)
                    widget.onChanged!(value);
                },
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.fill,
              child: HoverAnimatedContainer(
                decoration: BoxDecoration(
                  color: widget.dropButtonColor ?? Theme.of(context).primaryColor,
                  borderRadius: _borderRadiusRight,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.5),
                      offset: Offset(0, 1.0),
                      blurRadius: 2.0,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                hoverDecoration: BoxDecoration(
                  color: widget.dropHoverColor ?? Color.alphaBlend(Theme.of(context).primaryColorLight.withOpacity(0.24), Theme.of(context).primaryColor),
                  borderRadius: _borderRadiusRight,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.5),
                      offset: Offset(0, 2.0),
                      blurRadius: 4.0,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Container(
                  margin: const EdgeInsets.only(left: 5),
                  child: Center(
                    child: DropdownButton(
                      value: _value,
                      items: enumerate(widget.dropItems).map(
                            (element) {
                          return DropdownMenuItem (
                            value: element.index,
                            child: Text(element.value),
                          );
                        },
                      ).toList(),
                      onChanged: (index) {
                        setState(() {
                          _value = index as int? ?? 0;
                          if (!widget.item0direct || _value != 0) {
                            _controller.text = widget.dropItems[_value];
                          }
                          _controller.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: _controller.text.length);
                          FocusScope.of(context).requestFocus(_textNode);
                          if (widget.onItemChanged != null)
                            widget.onItemChanged!(_value);
                          if (widget.onChanged != null)
                            widget.onChanged!(_controller.text);
                        });
                      },
                      isDense: true,
                      style: TextStyle(color: widget.dropTextColor ?? (Theme.of(context).accentTextTheme.button?.color ?? Theme.of(context).secondaryHeaderColor)),
                      iconEnabledColor: widget.dropTextColor ?? (Theme.of(context).accentTextTheme.button?.color ?? Theme.of(context).secondaryHeaderColor),
                      iconDisabledColor: Theme.of(context).disabledColor,
                      dropdownColor: widget.dropListColor ?? Theme.of(context).primaryColor,
                      underline: SizedBox(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
