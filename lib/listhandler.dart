//
// // void countComplete() {
// //   setState(() {
// //     completed = historyDoItList.length;
// //   });
// // }
// //
// // void countInComplete() {
// //   int count = 0;
// //   for (var element in _doItHandler.doItList) {
// //     if (!element[1]) {
// //       count++;
// //     }
// //   }
// //   setState(() {
// //     incomplete = count;
// //   });
// // }
//
// import 'package:shared_preferences/shared_preferences.dart';
//
// class Task {
//   final String title;
//   bool completed;
//
//   Task({required this.title, this.completed = false});
//
//   Map<String, dynamic> toMap() {
//     return {
//       'title': title,
//       'completed': completed,
//     };
//   }
//
//   static Task fromMap(Map<String, dynamic> map) {
//     return Task(
//       title: map['title'] as String,
//       completed: map['completed'] as bool,
//     );
//   }
// }
//
// List<Task> tasks = [];
//
// Future<void> loadTasks() async {
//   final prefs = await SharedPreferences.getInstance();
//   final tasksData = prefs.getStringList('tasks');
//   if (tasksData != null) {
//     tasks = tasksData.map((data) => Task.fromMap(jsonDecode(data))).toList();
//   }
// }
//
// Future<void> saveTasks() async {
//   final prefs = await SharedPreferences.getInstance();
//   final tasksJson = tasks.map((task) => jsonEncode(task.toMap())).toList();
//   await prefs.setStringList('tasks', tasksJson);
// }
//
// @override
// void initState() {
//   super.initState();
//   loadTasks();
// }
//
// @override
// void dispose() {
//   super.dispose();
//   saveTasks();
// }
//
//
// // void updated() {
// //   setState(() {
// //     display = _doItHandler.doItList;
// //   });
// // }
// //
// // toggleStackTextField() {
// //   setState(() {
// //     showTaskTextField = !showTaskTextField;
// //   });
// // }
// //
// // String capitalizeString(String str) {
// //   List<String> chars = str.split('');
// //   chars[0] = chars[0].toUpperCase();
// //   return chars.join('');
// // }
// //
// // void drawerUpdate() {
// //   countComplete();
// //   countInComplete();
// // }
// //
// // Future<void> refresh() async {
// //   onRefresh();
// //   _toast("Refreshing All Data's");
// //   return await Future.delayed(const Duration(milliseconds: 1500));
// // }
// //
// // bool checkElement(List<List<dynamic>> array, dynamic element) {
// //   for (var row in array) {
// //     if (row.contains(element)) {
// //       return true;
// //     }
// //   }
// //   return false;
// // }
// //
// // void addHistory() {
// //   if (!checkElement(historyDoItList, history)) {
// //     setState(() {
// //       historyDoItList.add([
// //         display[indexPositionForHistory][0],
// //         display[indexPositionForHistory][2]
// //       ]);
// //     });
// //   } else {
// //     setState(() {
// //       historyDoItList.remove([
// //         display[indexPositionForHistory][0],
// //         display[indexPositionForHistory][2]
// //       ]);
// //     });
// //   }
// //
// //   countComplete();
// // }
// //
// // onRefresh() {
// //   deleteItems();
// //   deleteItems();
// //   deleteItems();
// //   deleteItems();
// //   deleteItems();
// //   updated();
// // }
// //
// // void shuffle(int oldIndex, int newIndex) {
// //   setState(() {
// //     if (oldIndex < newIndex) {
// //       newIndex--;
// //     }
// //
// //     final tile = _doItHandler.doItList.removeAt(oldIndex);
// //
// //     _doItHandler.doItList.insert(newIndex, tile);
// //   });
// //
// //   updated();
// // }
// //
// // void _toast(String msg) {
// //   Fluttertoast.showToast(
// //     msg: msg,
// //     toastLength: Toast.LENGTH_SHORT,
// //     gravity: ToastGravity.CENTER,
// //     timeInSecForIosWeb: 1,
// //     backgroundColor: color_60,
// //     textColor: Colors.white,
// //     fontSize: 16.0,
// //   );
// // }
