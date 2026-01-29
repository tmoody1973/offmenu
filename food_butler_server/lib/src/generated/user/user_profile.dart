/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../user/food_philosophy.dart' as _i2;
import '../user/adventure_level.dart' as _i3;

/// User profile and preferences collected during onboarding.
/// Used to personalize recommendations, The Daily, and the Serendipity Engine.
abstract class UserProfile
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  UserProfile._({
    this.id,
    required this.userId,
    this.foodPhilosophy,
    this.adventureLevel,
    this.familiarCuisines,
    this.wantToTryCuisines,
    this.dietaryRestrictions,
    this.homeCity,
    this.homeState,
    this.homeCountry,
    this.homeLatitude,
    this.homeLongitude,
    this.additionalCities,
    required this.onboardingCompleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile({
    int? id,
    required String userId,
    _i2.FoodPhilosophy? foodPhilosophy,
    _i3.AdventureLevel? adventureLevel,
    String? familiarCuisines,
    String? wantToTryCuisines,
    String? dietaryRestrictions,
    String? homeCity,
    String? homeState,
    String? homeCountry,
    double? homeLatitude,
    double? homeLongitude,
    String? additionalCities,
    required bool onboardingCompleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UserProfileImpl;

  factory UserProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserProfile(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as String,
      foodPhilosophy: jsonSerialization['foodPhilosophy'] == null
          ? null
          : _i2.FoodPhilosophy.fromJson(
              (jsonSerialization['foodPhilosophy'] as String),
            ),
      adventureLevel: jsonSerialization['adventureLevel'] == null
          ? null
          : _i3.AdventureLevel.fromJson(
              (jsonSerialization['adventureLevel'] as String),
            ),
      familiarCuisines: jsonSerialization['familiarCuisines'] as String?,
      wantToTryCuisines: jsonSerialization['wantToTryCuisines'] as String?,
      dietaryRestrictions: jsonSerialization['dietaryRestrictions'] as String?,
      homeCity: jsonSerialization['homeCity'] as String?,
      homeState: jsonSerialization['homeState'] as String?,
      homeCountry: jsonSerialization['homeCountry'] as String?,
      homeLatitude: (jsonSerialization['homeLatitude'] as num?)?.toDouble(),
      homeLongitude: (jsonSerialization['homeLongitude'] as num?)?.toDouble(),
      additionalCities: jsonSerialization['additionalCities'] as String?,
      onboardingCompleted: jsonSerialization['onboardingCompleted'] as bool,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = UserProfileTable();

  static const db = UserProfileRepository._();

  @override
  int? id;

  /// The user ID (from Serverpod auth).
  String userId;

  /// User's food philosophy - story vs dish preference.
  _i2.FoodPhilosophy? foodPhilosophy;

  /// User's adventure/exploration style.
  _i3.AdventureLevel? adventureLevel;

  /// Cuisines the user is familiar with (comma-separated).
  String? familiarCuisines;

  /// Cuisines the user wants to explore (comma-separated).
  String? wantToTryCuisines;

  /// Dietary restrictions (comma-separated: vegetarian, vegan, gluten-free, etc).
  String? dietaryRestrictions;

  /// User's home city for local recommendations.
  String? homeCity;

  /// User's home state/region.
  String? homeState;

  /// User's home country.
  String? homeCountry;

  /// Latitude of user's home location.
  double? homeLatitude;

  /// Longitude of user's home location.
  double? homeLongitude;

  /// Additional cities for personalized content (JSON array, up to 10).
  /// Format: [{"city":"Seattle","state":"WA","country":"USA","lat":47.6,"lng":-122.3}]
  String? additionalCities;

  /// Whether onboarding has been completed.
  bool onboardingCompleted;

  /// When preferences were created.
  DateTime createdAt;

  /// When preferences were last updated.
  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserProfile copyWith({
    int? id,
    String? userId,
    _i2.FoodPhilosophy? foodPhilosophy,
    _i3.AdventureLevel? adventureLevel,
    String? familiarCuisines,
    String? wantToTryCuisines,
    String? dietaryRestrictions,
    String? homeCity,
    String? homeState,
    String? homeCountry,
    double? homeLatitude,
    double? homeLongitude,
    String? additionalCities,
    bool? onboardingCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserProfile',
      if (id != null) 'id': id,
      'userId': userId,
      if (foodPhilosophy != null) 'foodPhilosophy': foodPhilosophy?.toJson(),
      if (adventureLevel != null) 'adventureLevel': adventureLevel?.toJson(),
      if (familiarCuisines != null) 'familiarCuisines': familiarCuisines,
      if (wantToTryCuisines != null) 'wantToTryCuisines': wantToTryCuisines,
      if (dietaryRestrictions != null)
        'dietaryRestrictions': dietaryRestrictions,
      if (homeCity != null) 'homeCity': homeCity,
      if (homeState != null) 'homeState': homeState,
      if (homeCountry != null) 'homeCountry': homeCountry,
      if (homeLatitude != null) 'homeLatitude': homeLatitude,
      if (homeLongitude != null) 'homeLongitude': homeLongitude,
      if (additionalCities != null) 'additionalCities': additionalCities,
      'onboardingCompleted': onboardingCompleted,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserProfile',
      if (id != null) 'id': id,
      'userId': userId,
      if (foodPhilosophy != null) 'foodPhilosophy': foodPhilosophy?.toJson(),
      if (adventureLevel != null) 'adventureLevel': adventureLevel?.toJson(),
      if (familiarCuisines != null) 'familiarCuisines': familiarCuisines,
      if (wantToTryCuisines != null) 'wantToTryCuisines': wantToTryCuisines,
      if (dietaryRestrictions != null)
        'dietaryRestrictions': dietaryRestrictions,
      if (homeCity != null) 'homeCity': homeCity,
      if (homeState != null) 'homeState': homeState,
      if (homeCountry != null) 'homeCountry': homeCountry,
      if (homeLatitude != null) 'homeLatitude': homeLatitude,
      if (homeLongitude != null) 'homeLongitude': homeLongitude,
      if (additionalCities != null) 'additionalCities': additionalCities,
      'onboardingCompleted': onboardingCompleted,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static UserProfileInclude include() {
    return UserProfileInclude._();
  }

  static UserProfileIncludeList includeList({
    _i1.WhereExpressionBuilder<UserProfileTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserProfileTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserProfileTable>? orderByList,
    UserProfileInclude? include,
  }) {
    return UserProfileIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserProfile.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserProfile.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserProfileImpl extends UserProfile {
  _UserProfileImpl({
    int? id,
    required String userId,
    _i2.FoodPhilosophy? foodPhilosophy,
    _i3.AdventureLevel? adventureLevel,
    String? familiarCuisines,
    String? wantToTryCuisines,
    String? dietaryRestrictions,
    String? homeCity,
    String? homeState,
    String? homeCountry,
    double? homeLatitude,
    double? homeLongitude,
    String? additionalCities,
    required bool onboardingCompleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         foodPhilosophy: foodPhilosophy,
         adventureLevel: adventureLevel,
         familiarCuisines: familiarCuisines,
         wantToTryCuisines: wantToTryCuisines,
         dietaryRestrictions: dietaryRestrictions,
         homeCity: homeCity,
         homeState: homeState,
         homeCountry: homeCountry,
         homeLatitude: homeLatitude,
         homeLongitude: homeLongitude,
         additionalCities: additionalCities,
         onboardingCompleted: onboardingCompleted,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [UserProfile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserProfile copyWith({
    Object? id = _Undefined,
    String? userId,
    Object? foodPhilosophy = _Undefined,
    Object? adventureLevel = _Undefined,
    Object? familiarCuisines = _Undefined,
    Object? wantToTryCuisines = _Undefined,
    Object? dietaryRestrictions = _Undefined,
    Object? homeCity = _Undefined,
    Object? homeState = _Undefined,
    Object? homeCountry = _Undefined,
    Object? homeLatitude = _Undefined,
    Object? homeLongitude = _Undefined,
    Object? additionalCities = _Undefined,
    bool? onboardingCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      foodPhilosophy: foodPhilosophy is _i2.FoodPhilosophy?
          ? foodPhilosophy
          : this.foodPhilosophy,
      adventureLevel: adventureLevel is _i3.AdventureLevel?
          ? adventureLevel
          : this.adventureLevel,
      familiarCuisines: familiarCuisines is String?
          ? familiarCuisines
          : this.familiarCuisines,
      wantToTryCuisines: wantToTryCuisines is String?
          ? wantToTryCuisines
          : this.wantToTryCuisines,
      dietaryRestrictions: dietaryRestrictions is String?
          ? dietaryRestrictions
          : this.dietaryRestrictions,
      homeCity: homeCity is String? ? homeCity : this.homeCity,
      homeState: homeState is String? ? homeState : this.homeState,
      homeCountry: homeCountry is String? ? homeCountry : this.homeCountry,
      homeLatitude: homeLatitude is double? ? homeLatitude : this.homeLatitude,
      homeLongitude: homeLongitude is double?
          ? homeLongitude
          : this.homeLongitude,
      additionalCities: additionalCities is String?
          ? additionalCities
          : this.additionalCities,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class UserProfileUpdateTable extends _i1.UpdateTable<UserProfileTable> {
  UserProfileUpdateTable(super.table);

  _i1.ColumnValue<String, String> userId(String value) => _i1.ColumnValue(
    table.userId,
    value,
  );

  _i1.ColumnValue<_i2.FoodPhilosophy, _i2.FoodPhilosophy> foodPhilosophy(
    _i2.FoodPhilosophy? value,
  ) => _i1.ColumnValue(
    table.foodPhilosophy,
    value,
  );

  _i1.ColumnValue<_i3.AdventureLevel, _i3.AdventureLevel> adventureLevel(
    _i3.AdventureLevel? value,
  ) => _i1.ColumnValue(
    table.adventureLevel,
    value,
  );

  _i1.ColumnValue<String, String> familiarCuisines(String? value) =>
      _i1.ColumnValue(
        table.familiarCuisines,
        value,
      );

  _i1.ColumnValue<String, String> wantToTryCuisines(String? value) =>
      _i1.ColumnValue(
        table.wantToTryCuisines,
        value,
      );

  _i1.ColumnValue<String, String> dietaryRestrictions(String? value) =>
      _i1.ColumnValue(
        table.dietaryRestrictions,
        value,
      );

  _i1.ColumnValue<String, String> homeCity(String? value) => _i1.ColumnValue(
    table.homeCity,
    value,
  );

  _i1.ColumnValue<String, String> homeState(String? value) => _i1.ColumnValue(
    table.homeState,
    value,
  );

  _i1.ColumnValue<String, String> homeCountry(String? value) => _i1.ColumnValue(
    table.homeCountry,
    value,
  );

  _i1.ColumnValue<double, double> homeLatitude(double? value) =>
      _i1.ColumnValue(
        table.homeLatitude,
        value,
      );

  _i1.ColumnValue<double, double> homeLongitude(double? value) =>
      _i1.ColumnValue(
        table.homeLongitude,
        value,
      );

  _i1.ColumnValue<String, String> additionalCities(String? value) =>
      _i1.ColumnValue(
        table.additionalCities,
        value,
      );

  _i1.ColumnValue<bool, bool> onboardingCompleted(bool value) =>
      _i1.ColumnValue(
        table.onboardingCompleted,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class UserProfileTable extends _i1.Table<int?> {
  UserProfileTable({super.tableRelation}) : super(tableName: 'user_profiles') {
    updateTable = UserProfileUpdateTable(this);
    userId = _i1.ColumnString(
      'userId',
      this,
    );
    foodPhilosophy = _i1.ColumnEnum(
      'foodPhilosophy',
      this,
      _i1.EnumSerialization.byName,
    );
    adventureLevel = _i1.ColumnEnum(
      'adventureLevel',
      this,
      _i1.EnumSerialization.byName,
    );
    familiarCuisines = _i1.ColumnString(
      'familiarCuisines',
      this,
    );
    wantToTryCuisines = _i1.ColumnString(
      'wantToTryCuisines',
      this,
    );
    dietaryRestrictions = _i1.ColumnString(
      'dietaryRestrictions',
      this,
    );
    homeCity = _i1.ColumnString(
      'homeCity',
      this,
    );
    homeState = _i1.ColumnString(
      'homeState',
      this,
    );
    homeCountry = _i1.ColumnString(
      'homeCountry',
      this,
    );
    homeLatitude = _i1.ColumnDouble(
      'homeLatitude',
      this,
    );
    homeLongitude = _i1.ColumnDouble(
      'homeLongitude',
      this,
    );
    additionalCities = _i1.ColumnString(
      'additionalCities',
      this,
    );
    onboardingCompleted = _i1.ColumnBool(
      'onboardingCompleted',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final UserProfileUpdateTable updateTable;

  /// The user ID (from Serverpod auth).
  late final _i1.ColumnString userId;

  /// User's food philosophy - story vs dish preference.
  late final _i1.ColumnEnum<_i2.FoodPhilosophy> foodPhilosophy;

  /// User's adventure/exploration style.
  late final _i1.ColumnEnum<_i3.AdventureLevel> adventureLevel;

  /// Cuisines the user is familiar with (comma-separated).
  late final _i1.ColumnString familiarCuisines;

  /// Cuisines the user wants to explore (comma-separated).
  late final _i1.ColumnString wantToTryCuisines;

  /// Dietary restrictions (comma-separated: vegetarian, vegan, gluten-free, etc).
  late final _i1.ColumnString dietaryRestrictions;

  /// User's home city for local recommendations.
  late final _i1.ColumnString homeCity;

  /// User's home state/region.
  late final _i1.ColumnString homeState;

  /// User's home country.
  late final _i1.ColumnString homeCountry;

  /// Latitude of user's home location.
  late final _i1.ColumnDouble homeLatitude;

  /// Longitude of user's home location.
  late final _i1.ColumnDouble homeLongitude;

  /// Additional cities for personalized content (JSON array, up to 10).
  /// Format: [{"city":"Seattle","state":"WA","country":"USA","lat":47.6,"lng":-122.3}]
  late final _i1.ColumnString additionalCities;

  /// Whether onboarding has been completed.
  late final _i1.ColumnBool onboardingCompleted;

  /// When preferences were created.
  late final _i1.ColumnDateTime createdAt;

  /// When preferences were last updated.
  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    foodPhilosophy,
    adventureLevel,
    familiarCuisines,
    wantToTryCuisines,
    dietaryRestrictions,
    homeCity,
    homeState,
    homeCountry,
    homeLatitude,
    homeLongitude,
    additionalCities,
    onboardingCompleted,
    createdAt,
    updatedAt,
  ];
}

class UserProfileInclude extends _i1.IncludeObject {
  UserProfileInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => UserProfile.t;
}

class UserProfileIncludeList extends _i1.IncludeList {
  UserProfileIncludeList._({
    _i1.WhereExpressionBuilder<UserProfileTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserProfile.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UserProfile.t;
}

class UserProfileRepository {
  const UserProfileRepository._();

  /// Returns a list of [UserProfile]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<UserProfile>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserProfileTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserProfileTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserProfileTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UserProfile>(
      where: where?.call(UserProfile.t),
      orderBy: orderBy?.call(UserProfile.t),
      orderByList: orderByList?.call(UserProfile.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [UserProfile] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<UserProfile?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserProfileTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserProfileTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserProfileTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UserProfile>(
      where: where?.call(UserProfile.t),
      orderBy: orderBy?.call(UserProfile.t),
      orderByList: orderByList?.call(UserProfile.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [UserProfile] by its [id] or null if no such row exists.
  Future<UserProfile?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UserProfile>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [UserProfile]s in the list and returns the inserted rows.
  ///
  /// The returned [UserProfile]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UserProfile>> insert(
    _i1.Session session,
    List<UserProfile> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UserProfile>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UserProfile] and returns the inserted row.
  ///
  /// The returned [UserProfile] will have its `id` field set.
  Future<UserProfile> insertRow(
    _i1.Session session,
    UserProfile row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserProfile>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserProfile]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserProfile>> update(
    _i1.Session session,
    List<UserProfile> rows, {
    _i1.ColumnSelections<UserProfileTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserProfile>(
      rows,
      columns: columns?.call(UserProfile.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserProfile]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserProfile> updateRow(
    _i1.Session session,
    UserProfile row, {
    _i1.ColumnSelections<UserProfileTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserProfile>(
      row,
      columns: columns?.call(UserProfile.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserProfile] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserProfile?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<UserProfileUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<UserProfile>(
      id,
      columnValues: columnValues(UserProfile.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserProfile]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<UserProfile>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<UserProfileUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<UserProfileTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserProfileTable>? orderBy,
    _i1.OrderByListBuilder<UserProfileTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<UserProfile>(
      columnValues: columnValues(UserProfile.t.updateTable),
      where: where(UserProfile.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserProfile.t),
      orderByList: orderByList?.call(UserProfile.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [UserProfile]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserProfile>> delete(
    _i1.Session session,
    List<UserProfile> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserProfile>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserProfile].
  Future<UserProfile> deleteRow(
    _i1.Session session,
    UserProfile row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserProfile>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserProfile>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserProfileTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserProfile>(
      where: where(UserProfile.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserProfileTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserProfile>(
      where: where?.call(UserProfile.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
