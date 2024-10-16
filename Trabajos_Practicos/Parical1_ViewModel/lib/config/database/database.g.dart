// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  BreedsDao? _breedsDaoInstance;

  UsersDao? _usersDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Breed` (`id` INTEGER, `breed` TEXT NOT NULL, `weight` TEXT NOT NULL, `height` TEXT NOT NULL, `origin` TEXT NOT NULL, `lifeExpectancy` TEXT NOT NULL, `description` TEXT NOT NULL, `posterUrl_1` TEXT, `posterUrl_2` TEXT, `posterUrl_3` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `User` (`id` INTEGER, `name` TEXT NOT NULL, `lastName` TEXT NOT NULL, `email` TEXT NOT NULL, `password` TEXT NOT NULL, `age` TEXT NOT NULL, `location` TEXT NOT NULL, `city` TEXT NOT NULL, `profileImg` TEXT, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  BreedsDao get breedsDao {
    return _breedsDaoInstance ??= _$BreedsDao(database, changeListener);
  }

  @override
  UsersDao get usersDao {
    return _usersDaoInstance ??= _$UsersDao(database, changeListener);
  }
}

class _$BreedsDao extends BreedsDao {
  _$BreedsDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _breedInsertionAdapter = InsertionAdapter(
            database,
            'Breed',
            (Breed item) => <String, Object?>{
                  'id': item.id,
                  'breed': item.breed,
                  'weight': item.weight,
                  'height': item.height,
                  'origin': item.origin,
                  'lifeExpectancy': item.lifeExpectancy,
                  'description': item.description,
                  'posterUrl_1': item.posterUrl_1,
                  'posterUrl_2': item.posterUrl_2,
                  'posterUrl_3': item.posterUrl_3
                }),
        _breedUpdateAdapter = UpdateAdapter(
            database,
            'Breed',
            ['id'],
            (Breed item) => <String, Object?>{
                  'id': item.id,
                  'breed': item.breed,
                  'weight': item.weight,
                  'height': item.height,
                  'origin': item.origin,
                  'lifeExpectancy': item.lifeExpectancy,
                  'description': item.description,
                  'posterUrl_1': item.posterUrl_1,
                  'posterUrl_2': item.posterUrl_2,
                  'posterUrl_3': item.posterUrl_3
                }),
        _breedDeletionAdapter = DeletionAdapter(
            database,
            'Breed',
            ['id'],
            (Breed item) => <String, Object?>{
                  'id': item.id,
                  'breed': item.breed,
                  'weight': item.weight,
                  'height': item.height,
                  'origin': item.origin,
                  'lifeExpectancy': item.lifeExpectancy,
                  'description': item.description,
                  'posterUrl_1': item.posterUrl_1,
                  'posterUrl_2': item.posterUrl_2,
                  'posterUrl_3': item.posterUrl_3
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Breed> _breedInsertionAdapter;

  final UpdateAdapter<Breed> _breedUpdateAdapter;

  final DeletionAdapter<Breed> _breedDeletionAdapter;

  @override
  Future<List<Breed>> findAllBreeds() async {
    return _queryAdapter.queryList('SELECT * FROM Breed',
        mapper: (Map<String, Object?> row) => Breed(
            id: row['id'] as int?,
            breed: row['breed'] as String,
            weight: row['weight'] as String,
            height: row['height'] as String,
            origin: row['origin'] as String,
            posterUrl_1: row['posterUrl_1'] as String?,
            posterUrl_2: row['posterUrl_2'] as String?,
            posterUrl_3: row['posterUrl_3'] as String?,
            lifeExpectancy: row['lifeExpectancy'] as String,
            description: row['description'] as String));
  }

  @override
  Future<Breed?> findBreedById(int id) async {
    return _queryAdapter.query('SELECT * FROM Breed where id = ?1',
        mapper: (Map<String, Object?> row) => Breed(
            id: row['id'] as int?,
            breed: row['breed'] as String,
            weight: row['weight'] as String,
            height: row['height'] as String,
            origin: row['origin'] as String,
            posterUrl_1: row['posterUrl_1'] as String?,
            posterUrl_2: row['posterUrl_2'] as String?,
            posterUrl_3: row['posterUrl_3'] as String?,
            lifeExpectancy: row['lifeExpectancy'] as String,
            description: row['description'] as String),
        arguments: [id]);
  }

  @override
  Future<void> insertBreed(Breed breed) async {
    await _breedInsertionAdapter.insert(breed, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateBreed(Breed breed) async {
    await _breedUpdateAdapter.update(breed, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteBreed(Breed breed) async {
    await _breedDeletionAdapter.delete(breed);
  }
}

class _$UsersDao extends UsersDao {
  _$UsersDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _userInsertionAdapter = InsertionAdapter(
            database,
            'User',
            (User item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'lastName': item.lastName,
                  'email': item.email,
                  'password': item.password,
                  'age': item.age,
                  'location': item.location,
                  'city': item.city,
                  'profileImg': item.profileImg
                }),
        _userUpdateAdapter = UpdateAdapter(
            database,
            'User',
            ['id'],
            (User item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'lastName': item.lastName,
                  'email': item.email,
                  'password': item.password,
                  'age': item.age,
                  'location': item.location,
                  'city': item.city,
                  'profileImg': item.profileImg
                }),
        _userDeletionAdapter = DeletionAdapter(
            database,
            'User',
            ['id'],
            (User item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'lastName': item.lastName,
                  'email': item.email,
                  'password': item.password,
                  'age': item.age,
                  'location': item.location,
                  'city': item.city,
                  'profileImg': item.profileImg
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<User> _userInsertionAdapter;

  final UpdateAdapter<User> _userUpdateAdapter;

  final DeletionAdapter<User> _userDeletionAdapter;

  @override
  Future<List<User>> findAllUsers() async {
    return _queryAdapter.queryList('SELECT * FROM User',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            name: row['name'] as String,
            lastName: row['lastName'] as String,
            email: row['email'] as String,
            age: row['age'] as String,
            location: row['location'] as String,
            city: row['city'] as String,
            password: row['password'] as String,
            profileImg: row['profileImg'] as String?));
  }

  @override
  Future<User?> findUserById(int id) async {
    return _queryAdapter.query('SELECT * FROM User where id = ?1',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as int?,
            name: row['name'] as String,
            lastName: row['lastName'] as String,
            email: row['email'] as String,
            age: row['age'] as String,
            location: row['location'] as String,
            city: row['city'] as String,
            password: row['password'] as String,
            profileImg: row['profileImg'] as String?),
        arguments: [id]);
  }

  @override
  Future<void> insertUser(User user) async {
    await _userInsertionAdapter.insert(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateUser(User user) async {
    await _userUpdateAdapter.update(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteUser(User user) async {
    await _userDeletionAdapter.delete(user);
  }
}
