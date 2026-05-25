import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:morphzing/core/constants/style.dart';
import 'package:morphzing/utils/style/colors.dart';
import 'package:painter/painter.dart';

class PaintingScreen extends StatefulWidget {
  const PaintingScreen({Key? key}) : super(key: key);

  @override
  State<PaintingScreen> createState() => _PaintingScreenState();
}

class _PaintingScreenState extends State<PaintingScreen> {
  bool _finished = false;
  late PainterController _controller = _Controller();

  static PainterController _Controller() {
    PainterController controller = PainterController();
    controller.thickness = 5.0;
    // controller.backgroundColor = greyTextColor.withOpacity(0.1);
    return controller;
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    List<Widget> actions;
    if (_finished) {
      actions = <Widget>[
        IconButton(
          icon: const Icon(Icons.content_copy),
          tooltip: ' Painting',
          onPressed: () => setState(() {
            _finished = false;
            _controller = _Controller();
            _controller.backgroundColor =
                isDark ? whiteColor : greyTextColor.withOpacity(0.1);
          }),
        ),
      ];
    } else {
      actions = <Widget>[
        IconButton(
            icon: Icon(
              Icons.undo,
              color: isDark ? whiteColor : blackTextColor,
            ),
            tooltip: 'Undo',
            onPressed: () {
              if (_controller.isEmpty) {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) => Container(
                    height: 100,
                    color: isDark ? darkBgColor : whiteColor,
                    child: Center(
                        child: Text(
                      'Nothing to undo',
                      style: staticTextStyle(
                          18, isDark ? whiteColor : blackTextColor),
                    )),
                  ),
                );
              } else {
                _controller.undo();
              }
            }),
        IconButton(
            icon: const Icon(
              Icons.delete,
              color: todayColor,
            ),
            tooltip: 'Clear',
            onPressed: _controller.clear),
        // IconButton(
        //     icon: Icon(
        //       Icons.check,
        //       color: isDark ? whiteColor : blackTextColor,
        //     ),
        //     onPressed: () => _show(_controller.finish(), context)),
      ];
    }
    return WillPopScope(
        onWillPop: () async {
          _show(_controller.finish(), context);

          return false;
        },
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: isDark ? darkBgColor : whiteColor,
              title: const Text('Painter Example'),
              actions: actions,
              leading: IconButton(
                onPressed: () {
                  _show(_controller.finish(), context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: isDark ? whiteColor : blackTextColor,
                ),
              ),
              bottom: PreferredSize(
                child: DrawBar(_controller),
                preferredSize: Size(MediaQuery.of(context).size.width, 30.0),
              )),
          body: Center(
              child:
                  AspectRatio(aspectRatio: 1.0, child: Painter(_controller))),
        ));
  }

  void _show(PictureDetails picture, BuildContext context) async {
    _finished = true;
    Get.back(result: await picture.toPNG());
    print(picture.toPNG());

    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (BuildContext context) {
    //       return Scaffold(
    //         appBar: AppBar(
    //           title: const Text('View your image'),
    //         ),
    //         body: Container(
    //           alignment: Alignment.center,
    //           child: FutureBuilder<Uint8List>(
    //             future: picture.toPNG(),
    //             builder:
    //                 (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
    //               switch (snapshot.connectionState) {
    //                 case ConnectionState.done:
    //                   if (snapshot.hasError) {
    //                     return Text('Error: ${snapshot.error}');
    //                   } else {
    //                     return Image.memory(snapshot.data!);
    //                   }
    //                 default:
    //                   return const FractionallySizedBox(
    //                     widthFactor: 0.1,
    //                     child: AspectRatio(
    //                         aspectRatio: 1.0,
    //                         child: CircularProgressIndicator()),
    //                     alignment: Alignment.center,
    //                   );
    //               }
    //             },
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    // );
  }
}

class DrawBar extends StatelessWidget {
  final PainterController _controller;

  DrawBar(this._controller);

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Slider(
                value: _controller.thickness,
                onChanged: (double value) => setState(
                  () {
                    _controller.thickness = value;
                  },
                ),
                min: 1.0,
                max: 20.0,
                inactiveColor: isDark ? darkBgColor : bgColor,
                activeColor: isDark ? whiteColor : blackTextColor,
              );
            },
          ),
        ),
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return RotatedBox(
              quarterTurns: _controller.eraseMode ? 2 : 0,
              child: IconButton(
                  icon: Icon(
                    Icons.create,
                    color: isDark ? whiteColor : blackTextColor,
                  ),
                  tooltip: (_controller.eraseMode ? 'Disable' : 'Enable') +
                      ' eraser',
                  onPressed: () {
                    setState(() {
                      _controller.eraseMode = !_controller.eraseMode;
                    });
                  }));
        }),
        ColorPickerButton(_controller, false),
        // ColorPickerButton(_controller, true),
      ],
    );
  }
}

class ColorPickerButton extends StatefulWidget {
  final PainterController _controller;
  final bool _background;

  ColorPickerButton(this._controller, this._background);

  @override
  _ColorPickerButtonState createState() => _ColorPickerButtonState();
}

class _ColorPickerButtonState extends State<ColorPickerButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(_iconData, color: _color),
        tooltip: widget._background
            ? 'Change background color'
            : 'Change draw color',
        onPressed: _pickColor);
  }

  void _pickColor() {
    Color pickerColor = _color;
    Navigator.of(context)
        .push(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (BuildContext context) {
              return Scaffold(
                  appBar: AppBar(
                    title: const Text('Pick color'),
                  ),
                  body: Container(
                      alignment: Alignment.center,
                      child: ColorPicker(
                        pickerColor: pickerColor,
                        onColorChanged: (Color c) => pickerColor = c,
                      )));
            }))
        .then((_) {
      setState(() {
        _color = pickerColor;
      });
    });
  }

  Color get _color => widget._background
      ? widget._controller.backgroundColor
      : widget._controller.drawColor;

  IconData get _iconData =>
      widget._background ? Icons.format_color_fill : Icons.brush;

  set _color(Color color) {
    if (widget._background) {
      widget._controller.backgroundColor = color;
    } else {
      widget._controller.drawColor = color;
    }
  }
}
