import 'dart:convert';

import 'package:doit/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHeroPage extends StatefulWidget {
  const MyHeroPage({super.key});

  @override
  State<MyHeroPage> createState() => _MyHeroPageState();
}

class _MyHeroPageState extends State<MyHeroPage> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  late List<List<dynamic>> _task = [];
  late List<List<dynamic>> _display = [];
  late List<List<dynamic>> _historyTask = [
    [0, 'Installed Successfully', true],
  ];
  bool show = false;
  bool showTaskTextField = false;
  bool _shiftPage = true;
  int completed = 0, incomplete = 0;
  int id = 5;
  int history = 0;
  int indexPositionForHistory = 0;
  int containerShowTime = 0, days = 2;

  @override
  void initState() {
    _loadTodos();
    _decider();
    _updateDrawer();
    Future.delayed(const Duration(milliseconds: 2725), () {
      setState(() {
        _shiftPage = false;
      });
    });
    super.initState();
  }

  Future<void> _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final loadedTodosString = prefs.getString('task') ?? '[]';
    _task = List<List<dynamic>>.from(jsonDecode(loadedTodosString));
    _decider();
    _updateDrawer();
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedTodos = jsonEncode(_task);
    await prefs.setString('task', encodedTodos);
  }

  Future<void> refresh() async {
    _toast("Refreshing All Data's");
    _decider();
    _updateDrawer();
    return await Future.delayed(const Duration(milliseconds: 1500));
  }

  void _decider() {
    setState(() {
      _display = [];
      _historyTask = [
        [0, 'Installed Successfully', true],
      ];
    });
    for (var i in _task) {
      if (!i[2]) {
        setState(() {
          _display.add(i);
        });
      } else {
        setState(() {
          _historyTask.add(i);
        });
      }
    }
  }

  toggleStackTextField() {
    setState(() {
      showTaskTextField = !showTaskTextField;
    });
  }

  void _toast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: colorOther,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color_60,
      appBar: AppBar(
        backgroundColor: color_60,
        foregroundColor: color_30,
        title: const Text(
          'Do IT',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            wordSpacing: 3.5,
          ),
        ),
      ),
      endDrawer: _drawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            showTaskTextField = !showTaskTextField;
          });
        },
        backgroundColor: color_60,
        child: Icon(
          Icons.add,
          color: color_30,
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.only(
          left: 5.0,
          right: 5.0,
          bottom: 5.0,
        ),
        decoration: BoxDecoration(
          color: color_30,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: _shiftPage ? _loader() : _body(),
      ),
    );
  }

  Widget _drawer() {
    return Drawer(
      backgroundColor: color_60,
      child: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.22,
            alignment: Alignment.bottomLeft,
            decoration: BoxDecoration(
              color: color_60,
            ),
            child: Center(
              child: Text(
                'Do IT',
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.w700,
                  color: color_30,
                  shadows: const [
                    Shadow(
                      offset: Offset(7, 7),
                      blurRadius: 15.0,
                      color: Colors.black38,
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            padding: const EdgeInsets.only(
              left: 20.0,
            ),
            color: color_60,
            child: Container(
              height: MediaQuery.of(context).size.height * (1 - 0.265),
              decoration: BoxDecoration(
                color: color_30,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 32, left: 32, right: 30),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.dangerous,
                          color: Colors.red,
                          shadows: [
                            Shadow(
                              offset: Offset(5, 5),
                              blurRadius: 10.5,
                              color: Colors.black12,
                            )
                          ],
                        ),
                        const Text(
                          "    Incomplete",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "$incomplete",
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 32, left: 32, right: 30),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_rounded,
                          color: colorOther,
                          shadows: const [
                            Shadow(
                              offset: Offset(5, 5),
                              blurRadius: 10.5,
                              color: Colors.black12,
                            )
                          ],
                        ),
                        Text(
                          "    Completed",
                          style: TextStyle(
                            color: colorOther,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                child: show
                                    ? Icon(
                                        Icons.arrow_drop_down,
                                        color: colorOther,
                                      )
                                    : Icon(
                                        Icons.arrow_left_sharp,
                                        color: colorOther,
                                      ),
                                onTap: () {
                                  setState(() {
                                    show = !show;
                                  });
                                },
                              ),
                              Text(
                                show ? "${_historyTask.length}" : "$completed",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: colorOther,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _historyListView(),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          'Powered by : ',
                          style: TextStyle(
                            color: colorOther,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 20),
                    child: TextButton(
                      child: Text(
                        'ByteWise Creator',
                        style: TextStyle(
                          color: colorOther,
                        ),
                      ),
                      onPressed: () {
                        launch('https://bitwisesample.netlify.app/');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        LiquidPullToRefresh(
          onRefresh: refresh,
          showChildOpacityTransition: false,
          backgroundColor: color_30,
          borderWidth: 1.5,
          color: color_60,
          height: MediaQuery.of(context).size.height * 0.25,
          animSpeedFactor: 2,
          child: SizedBox(
            child: ReorderableListView(
                children: [
                  for (int i = 0; i < _display.length; i++)
                    Padding(
                      key: ValueKey(_display[i]),
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 60,
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.5, horizontal: 20),
                        decoration: BoxDecoration(
                          color: color_60.withOpacity(.15),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (_display[i][2])
                              Container(
                                margin: const EdgeInsets.only(
                                  right: 12.5,
                                ),
                                height: 40,
                                width: 40,
                                child: Image.asset(
                                  'assets/images/completed.png',
                                ),
                              ),
                            Text(
                              _display[i][1],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: colorOther,
                                decoration: _display[i][2]
                                    ? TextDecoration.lineThrough
                                    : null,
                                fontSize: 17.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  _modifyTask(_display[i][0]);
                                  _updateDrawer();
                                  _saveTodos();
                                },
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    _display[i][2]
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank_sharp,
                                    color: colorOther,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                ],
                onReorder: (int oldIndex, int newIndex) {
                  _shuffle(oldIndex, newIndex);
                }),
          ),
        ),
        _textFieldShow(),
      ],
    );
  }

  Widget _loader() {
    return ListView.builder(
      itemCount: MediaQuery.of(context).size.height ~/ 80,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 1),
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8.5, horizontal: 20),
            decoration: BoxDecoration(
              color: color_60.withOpacity(.125),
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    right: 12.5,
                  ),
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.5)),
                  ),
                  child: LinearProgressIndicator(
                    borderRadius: const BorderRadius.all(Radius.circular(5.5)),
                    backgroundColor: color_30,
                    color: color_60.withOpacity(0.065),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(
                      right: 12.5,
                      bottom: 10,
                    ),
                    height: 8,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6.5)),
                    ),
                    child: LinearProgressIndicator(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(6.5)),
                      backgroundColor: color_30,
                      color: color_60.withOpacity(0.065),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    right: 12.5,
                  ),
                  height: 15,
                  width: 15,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(3.5)),
                  ),
                  child: LinearProgressIndicator(
                    borderRadius: const BorderRadius.all(Radius.circular(3.5)),
                    backgroundColor: color_30,
                    color: color_60.withOpacity(0.065),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _textFieldShow() {
    return Visibility(
      visible: showTaskTextField,
      child: Container(
        alignment: const Alignment(0, 0),
        child: Container(
          decoration: BoxDecoration(
            color: color_60.withOpacity(0.7275),
            borderRadius: const BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          width: MediaQuery.of(context).size.width * .75,
          child: Padding(
            padding: const EdgeInsets.all(26.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min, // Constrain card height
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Let\'s Do It!',
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.w700,
                      color: color_30,
                    ),
                  ),
                  const SizedBox(height: 26.0),
                  Container(
                    padding:
                        const EdgeInsets.only(bottom: 1.0, right: 10, left: 15),
                    decoration: BoxDecoration(
                      color: color_30.withOpacity(0.17727),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: TextFormField(
                      controller: _textController,
                      cursorColor: color_30,
                      autocorrect: false,
                      textAlign: TextAlign.end,
                      style: TextStyle(color: color_30),
                      decoration: InputDecoration(
                        fillColor: color_60,
                        focusColor: color_60,
                        hoverColor: color_60,
                        labelText: 'Create Task Here',
                        labelStyle: TextStyle(color: color_30),
                        hintText: '',
                        border: InputBorder.none,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'I think \'You forget to Enter TASK\'';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 26.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _toast('We need to Create A Task');
                          toggleStackTextField();
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: color_30,
                          backgroundColor: color_60,
                        ),
                        child: const Text('Do After'),
                      ),
                      GestureDetector(
                        onDoubleTap: () {
                          if (_formKey.currentState!.validate()) {
                            _addItems(capitalizeString(_textController.text));
                            _decider();
                            _updateDrawer();
                            _saveTodos();
                            toggleStackTextField();
                            setState(() {
                              _textController.clear();
                            });
                            _toast("Let's Do Successfully");
                          }
                        },
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _toast('Double Tap to Conform');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: color_30,
                            backgroundColor: color_60, // Change text color here
                          ),
                          child: const Text(
                            'Do This',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _historyListView() {
    return Visibility(
      visible: show,
      child: Container(
        margin: const EdgeInsets.only(top: 8.0, right: 10.0, left: 10.0),
        height: MediaQuery.of(context).size.height * 0.46,
        decoration: BoxDecoration(
          color: color_60.withOpacity(0.1),
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 20.0,
                bottom: 7.5,
              ),
              child: Text(
                'Complete History',
                style:
                    TextStyle(fontWeight: FontWeight.w600, color: colorOther),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                  height: (MediaQuery.of(context).size.height * 0.45) - 50,
                  child: ListView.builder(
                      itemCount: _historyTask.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, left: 10.0, right: 10.0),
                          child: Container(
                            height: 32.5,
                            width: 0,
                            padding: const EdgeInsets.all(7.5),
                            decoration: BoxDecoration(
                                color: color_60.withOpacity(.225),
                                borderRadius: BorderRadius.circular(5.5)),
                            child: Text(
                              '${_historyTask[index][1]}',
                              style: TextStyle(
                                color: colorOther,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      })),
            ),
          ],
        ),
      ),
    );
  }

  String capitalizeString(String str) {
    List<String> chars = str.split('');
    chars[0] = chars[0].toUpperCase();
    return chars.join('');
  }

  void _addItems(String task) {
    if (task.length > 20) {
      setState(() {
        task = '${task.substring(0, 20)}...';
      });
    }
    setState(() {
      _task.add([DateTime.now().millisecondsSinceEpoch, task, false]);
      id += 1;
    });
    _decider();
    //_saveTodos();
  }

  void _modifyTask(int taskId) {
    for (int i = 0; i < _task.length; i++) {
      if (_task[i][0] == taskId) {
        setState(() {
          _task[i][2] = !_task[i][2];
        });
      }
    }
  }

  void _updateDrawer() {
    setState(() {
      completed = 0;
      incomplete = 0;
    });
    for (var i in _display) {
      if (i[2]) {
        setState(() {
          completed += 1;
        });
      } else {
        incomplete += 1;
      }
    }
  }

  void _shuffle(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex--;
      }

      final tile = _display.removeAt(oldIndex);

      _display.insert(newIndex, tile);
    });
  }
}
