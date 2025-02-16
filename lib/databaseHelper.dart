import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Singleton pattern
  static DatabaseHelper? _instance;
  static Database? _database;

  final String _tableProfile = 'profile';
  static final String columnId = 'id';
  static final String columnName = 'name';
  static final String columnPhoneNumber = 'phone_number';
  static final String columnEmail = 'email';
  static final String columnDob = 'dob';
  static final String columnPregnancyFrom = 'pregnancy_from';
  static final String columnExpectedDay = 'expected_day';
  static final String columnBio = 'bio';

  final String _tableKickCounter = 'kickCounter';
  static final String columnkickcounterId = 'id';
  static final String columnFirstTime = 'first_time';
  static final String columnLastTime = 'last_time';
  static final String columnkickcount = 'kick_count';
  static final String columncurrectdate = 'current_date';

  final String _tableAppointments = 'appointments';
  static final String colappointmentId = 'id';
  static final String colappointmentDate = 'appointment_date';
  static final String colappointmentTitle = 'appointment_title';
  static final String colappointmentDescription = 'appointment_desc';

  final String _tableWeights = 'weights';
  static final String colweightId = 'id';
  static final String colweightDate = 'weight_date';
  static final String colweight = 'weight';




  // Private constructor
  DatabaseHelper._createInstance();

  // Factory constructor
  factory DatabaseHelper() {
    _instance ??= DatabaseHelper._createInstance();
    return _instance!;
  }

  // Getter for the database
  Future<Database> get database async {
    _database ??= await _initializeDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initializeDatabase() async {
    String path = join(await getDatabasesPath(), 'bumpie.db');
    return await openDatabase(
      path,
      version: 4, // Increment the version number here
      onCreate: _createDb,
      onUpgrade: _onUpgrade,
    );
  }

  // Create the database tables
  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableProfile (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT,
        $columnPhoneNumber TEXT,
        $columnEmail TEXT,
        $columnDob TEXT,
        $columnPregnancyFrom TEXT,
        $columnExpectedDay TEXT,
        $columnBio TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $_tableKickCounter (
        $columnkickcounterId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnFirstTime TEXT,
        $columnLastTime TEXT,
        $columnkickcount TEXT,
        $columncurrectdate TEXT
      )
    ''');

    await db.execute('''
CREATE TABLE $_tableAppointments (
  $colappointmentId INTEGER PRIMARY KEY AUTOINCREMENT,
  $colappointmentDate TEXT,
  $colappointmentTitle TEXT,
  $colappointmentDescription TEXT
)
''');

    await db.execute('''
CREATE TABLE $_tableWeights (
  $colweightId INTEGER PRIMARY KEY AUTOINCREMENT,
  $colweightDate TEXT,
  $colweight TEXT
)
''');


  }

  // Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $_tableKickCounter (
          $columnkickcounterId INTEGER PRIMARY KEY AUTOINCREMENT,
          $columnFirstTime TEXT,
          $columnLastTime TEXT,
          $columnkickcount TEXT
        )
      ''');
    }
    else if(oldVersion<3){
      await db.execute('''
CREATE TABLE IF NOT EXISTS $_tableAppointments (
  $colappointmentId INTEGER PRIMARY KEY AUTOINCREMENT,
  $colappointmentDate TEXT,
  $colappointmentTitle TEXT,
  $colappointmentDescription TEXT
)
''');

    }
    else if (oldVersion<4){
      await db.execute('''
CREATE TABLE IF NOT EXISTS $_tableWeights (
  $colweightId INTEGER PRIMARY KEY AUTOINCREMENT,
  $colweightDate TEXT,
  $colweight TEXT
)
''');

    }
  }

  // Delete the database
  Future<void> deleteDatabase() async {
    final path = join(await getDatabasesPath(), 'bumpie.db');
    await databaseFactory.deleteDatabase(path);
  }

  // Insert a profile into the database
  Future<void> insertProfile(Map<String, dynamic> profile) async {
    final db = await database;
    await db.insert(
      _tableProfile,
      profile,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getProfile() async {
    Database db = await database;
    return await db.query(_tableProfile);
  }

  Future<void> clearProfileTable() async {
    final db = await database;
    await db.delete(_tableProfile);
  }

  Future<void> insertKickCounter(Map<String, dynamic> kickCounter) async {
    final db = await database;
    await db.insert(
      _tableKickCounter,
      kickCounter,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getKickCounterData() async {
    Database db = await database;
    return await db.query(
      _tableKickCounter,
      where: 'kick_count > ?',
      whereArgs: [0],
    );
  }

  Future<List<Map<String, dynamic>>> getWeeklyKickCounts() async {
    final db = await database;

    final List<Map<String, dynamic>> result = await db.rawQuery('''
  SELECT strftime('%W', $columncurrectdate) as weekNumber, SUM(CAST($columnkickcount AS INTEGER)) as totalKicks
  FROM $_tableKickCounter
  GROUP BY weekNumber
  ORDER BY weekNumber ASC
  ''');

    return result;
  }

  Future<void> insertAppointements(Map<String, dynamic> Appointments) async{
    final db = await database;
    db.insert(_tableAppointments,
        Appointments,
      conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAppointementofday(String date) async{
    Database db = await database;

    var result = await db.query(
      _tableAppointments,
    where: '$colappointmentDate =?',
    whereArgs: [date],
    );
    return result;
  }

  Future<int> insertWeight(String date, double weight) async {
    Database db = await database;
    return await db.insert(_tableWeights, {DatabaseHelper.colweightDate: date, DatabaseHelper.colweight: weight});
  }

  Future<List<Map<String, dynamic>>> getWeights() async {
    Database db = await database;
    return await db.query(_tableWeights);
  }

  Future<String> getPregnancyFrom() async {
    Database db = await database;
    var result = await db.query(
      _tableProfile,
      columns: [columnPregnancyFrom],
    );
    if (result.isNotEmpty) {
      return result.first[columnPregnancyFrom] as String;
    }
    return "00";
  }
}
