import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MyApp());
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager().registerOneOffTask("task-identifier", "sendEmailTask");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Background Emailer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade900,
        title: const Text("Background Emailer",
            style: TextStyle(color: Colors.white)),
      ),
      body: const Center(
        child: Text(
          "Daily background task scheduled.",
        ),
      ),
    );
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await sendEmail();
    return Future.value(true);
  });
}

// DB Helper
class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'transDB.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''CREATE TABLE Transactions(
          TransID INTEGER PRIMARY KEY,
          TransDesc TEXT,
          TransStatus TEXT,
          TransDateTime TEXT
        )''');

        await db.execute('''INSERT INTO Transactions(
          TransDesc,
          TransStatus,
          TransDateTime
        ) VALUES(
          'UpdateTask',
          'Success',
          '31-10-2023 00:51'
        )''');

        await db.execute('''INSERT INTO Transactions(
          TransDesc,
          TransStatus,
          TransDateTime
        ) VALUES(
          'UpdateStatus',
          'Pending',
          '31-10-2023 00:52'
        )''');

        await db.execute('''INSERT INTO Transactions(
          TransDesc,
          TransStatus,
          TransDateTime
        ) VALUES(
          'UpdatePerson',
          'Error',
          '31-10-2023 00:53'
        )''');

        await db.execute('''INSERT INTO Transactions(
          TransDesc,
          TransStatus,
          TransDateTime
        ) VALUES(
          'UpdateTask',
          'Success',
          '31-10-2023 00:54'
        )''');

        await db.execute('''INSERT INTO Transactions(
          TransDesc,
          TransStatus,
          TransDateTime
        ) VALUES(
          'UpdateStatus',
          'Pending',
          '31-10-2023 00:55'
        )''');
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getErrorRecords() async {
    final db = await database;
    return await db
        .query('Transactions', where: 'TransStatus = ?', whereArgs: ['Error']);
  }
}

Future<void> sendEmail() async {
  final List<Map<String, dynamic>> errors = await DBHelper.getErrorRecords();

  // Send Email Code
}
