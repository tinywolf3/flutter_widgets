# flutter_widgets

flutter로 windows desktop app을 만들다가 쓸만한 Widget 찾지 못할 때마다 간단하게 만들어 봄

## DropdownTextField

드롭다운 리스트가 붙어있는 텍스트필드

![DropdownTextField](https://user-images.githubusercontent.com/7299147/115125396-c3c86100-a002-11eb-93bf-62fb8984acab.gif)

```dart
dependencies:
  quiver:
  hovering:
```

```dart
  DropdownTextField(
    label: Text('이름: '),
    textController: _txtName,
    hintText: '검색할 이름을 선택하십시오.',
    dropItems: _listNames,
    initItem: 0,
    item0direct: true, // 0번째 아이템을 직접입력으로 취급할 경우 true로 설정
    onChanged: (value) {
      print(value);
    },
  ),
```

## ButtonTextField

버튼이 붙어있는 텍스트필드

![ButtonTextField](https://user-images.githubusercontent.com/7299147/115125404-caef6f00-a002-11eb-9696-abd66e17e977.gif)

```dart
  ButtonTextField(
    label: Text('파일: '),
    textController: _txtFilepath,
    hintText: '처리할 파일을 선택하십시오.',
    buttonLabel: Text('선택'),
    onPressed: () {
      _txtFilepath.text = 'D:\\Work\\pressed!';
    },
  ),
```

## NumberTextField

숫자 입력 전용 텍스트필드

![NumberTextField](https://user-images.githubusercontent.com/7299147/115125406-cdea5f80-a002-11eb-9083-692514b100cd.gif)

```dart
dependencies:
  intl:
```

```dart
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
```
