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

/// Generated tour result with all metadata.
abstract class TourResult
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  TourResult._({
    this.id,
    required this.requestId,
    required this.stopsJson,
    required this.confidenceScore,
    required this.routePolyline,
    required this.routeLegsJson,
    required this.totalDistanceMeters,
    required this.totalDurationSeconds,
    required this.isPartialTour,
    this.warningMessage,
    this.tourTitle,
    this.tourIntroduction,
    this.tourVibe,
    this.tourClosing,
    this.curatedTourJson,
    required this.createdAt,
  });

  factory TourResult({
    int? id,
    required int requestId,
    required String stopsJson,
    required int confidenceScore,
    required String routePolyline,
    required String routeLegsJson,
    required int totalDistanceMeters,
    required int totalDurationSeconds,
    required bool isPartialTour,
    String? warningMessage,
    String? tourTitle,
    String? tourIntroduction,
    String? tourVibe,
    String? tourClosing,
    String? curatedTourJson,
    required DateTime createdAt,
  }) = _TourResultImpl;

  factory TourResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return TourResult(
      id: jsonSerialization['id'] as int?,
      requestId: jsonSerialization['requestId'] as int,
      stopsJson: jsonSerialization['stopsJson'] as String,
      confidenceScore: jsonSerialization['confidenceScore'] as int,
      routePolyline: jsonSerialization['routePolyline'] as String,
      routeLegsJson: jsonSerialization['routeLegsJson'] as String,
      totalDistanceMeters: jsonSerialization['totalDistanceMeters'] as int,
      totalDurationSeconds: jsonSerialization['totalDurationSeconds'] as int,
      isPartialTour: jsonSerialization['isPartialTour'] as bool,
      warningMessage: jsonSerialization['warningMessage'] as String?,
      tourTitle: jsonSerialization['tourTitle'] as String?,
      tourIntroduction: jsonSerialization['tourIntroduction'] as String?,
      tourVibe: jsonSerialization['tourVibe'] as String?,
      tourClosing: jsonSerialization['tourClosing'] as String?,
      curatedTourJson: jsonSerialization['curatedTourJson'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = TourResultTable();

  static const db = TourResultRepository._();

  @override
  int? id;

  /// Reference to the original request.
  int requestId;

  /// Ordered array of tour stops as JSON.
  String stopsJson;

  /// Tour confidence score (0-100).
  int confidenceScore;

  /// Encoded route polyline for map rendering.
  String routePolyline;

  /// Per-leg route summaries as JSON.
  String routeLegsJson;

  /// Total tour distance in meters.
  int totalDistanceMeters;

  /// Total tour duration in seconds.
  int totalDurationSeconds;

  /// Whether this is a partial tour (fewer stops than requested).
  bool isPartialTour;

  /// Warning message when partial tour or other issues.
  String? warningMessage;

  /// Creative title/theme for the tour (from AI curation).
  String? tourTitle;

  /// Opening narrative that sets the stage for the journey.
  String? tourIntroduction;

  /// The overall vibe/mood of the tour.
  String? tourVibe;

  /// Closing narrative wrapping up the experience.
  String? tourClosing;

  /// Full curated tour JSON from Perplexity (contains stories, dish details, tips).
  String? curatedTourJson;

  /// When the result was created.
  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [TourResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  TourResult copyWith({
    int? id,
    int? requestId,
    String? stopsJson,
    int? confidenceScore,
    String? routePolyline,
    String? routeLegsJson,
    int? totalDistanceMeters,
    int? totalDurationSeconds,
    bool? isPartialTour,
    String? warningMessage,
    String? tourTitle,
    String? tourIntroduction,
    String? tourVibe,
    String? tourClosing,
    String? curatedTourJson,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TourResult',
      if (id != null) 'id': id,
      'requestId': requestId,
      'stopsJson': stopsJson,
      'confidenceScore': confidenceScore,
      'routePolyline': routePolyline,
      'routeLegsJson': routeLegsJson,
      'totalDistanceMeters': totalDistanceMeters,
      'totalDurationSeconds': totalDurationSeconds,
      'isPartialTour': isPartialTour,
      if (warningMessage != null) 'warningMessage': warningMessage,
      if (tourTitle != null) 'tourTitle': tourTitle,
      if (tourIntroduction != null) 'tourIntroduction': tourIntroduction,
      if (tourVibe != null) 'tourVibe': tourVibe,
      if (tourClosing != null) 'tourClosing': tourClosing,
      if (curatedTourJson != null) 'curatedTourJson': curatedTourJson,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TourResult',
      if (id != null) 'id': id,
      'requestId': requestId,
      'stopsJson': stopsJson,
      'confidenceScore': confidenceScore,
      'routePolyline': routePolyline,
      'routeLegsJson': routeLegsJson,
      'totalDistanceMeters': totalDistanceMeters,
      'totalDurationSeconds': totalDurationSeconds,
      'isPartialTour': isPartialTour,
      if (warningMessage != null) 'warningMessage': warningMessage,
      if (tourTitle != null) 'tourTitle': tourTitle,
      if (tourIntroduction != null) 'tourIntroduction': tourIntroduction,
      if (tourVibe != null) 'tourVibe': tourVibe,
      if (tourClosing != null) 'tourClosing': tourClosing,
      if (curatedTourJson != null) 'curatedTourJson': curatedTourJson,
      'createdAt': createdAt.toJson(),
    };
  }

  static TourResultInclude include() {
    return TourResultInclude._();
  }

  static TourResultIncludeList includeList({
    _i1.WhereExpressionBuilder<TourResultTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TourResultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TourResultTable>? orderByList,
    TourResultInclude? include,
  }) {
    return TourResultIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TourResult.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(TourResult.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TourResultImpl extends TourResult {
  _TourResultImpl({
    int? id,
    required int requestId,
    required String stopsJson,
    required int confidenceScore,
    required String routePolyline,
    required String routeLegsJson,
    required int totalDistanceMeters,
    required int totalDurationSeconds,
    required bool isPartialTour,
    String? warningMessage,
    String? tourTitle,
    String? tourIntroduction,
    String? tourVibe,
    String? tourClosing,
    String? curatedTourJson,
    required DateTime createdAt,
  }) : super._(
         id: id,
         requestId: requestId,
         stopsJson: stopsJson,
         confidenceScore: confidenceScore,
         routePolyline: routePolyline,
         routeLegsJson: routeLegsJson,
         totalDistanceMeters: totalDistanceMeters,
         totalDurationSeconds: totalDurationSeconds,
         isPartialTour: isPartialTour,
         warningMessage: warningMessage,
         tourTitle: tourTitle,
         tourIntroduction: tourIntroduction,
         tourVibe: tourVibe,
         tourClosing: tourClosing,
         curatedTourJson: curatedTourJson,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [TourResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  TourResult copyWith({
    Object? id = _Undefined,
    int? requestId,
    String? stopsJson,
    int? confidenceScore,
    String? routePolyline,
    String? routeLegsJson,
    int? totalDistanceMeters,
    int? totalDurationSeconds,
    bool? isPartialTour,
    Object? warningMessage = _Undefined,
    Object? tourTitle = _Undefined,
    Object? tourIntroduction = _Undefined,
    Object? tourVibe = _Undefined,
    Object? tourClosing = _Undefined,
    Object? curatedTourJson = _Undefined,
    DateTime? createdAt,
  }) {
    return TourResult(
      id: id is int? ? id : this.id,
      requestId: requestId ?? this.requestId,
      stopsJson: stopsJson ?? this.stopsJson,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      routePolyline: routePolyline ?? this.routePolyline,
      routeLegsJson: routeLegsJson ?? this.routeLegsJson,
      totalDistanceMeters: totalDistanceMeters ?? this.totalDistanceMeters,
      totalDurationSeconds: totalDurationSeconds ?? this.totalDurationSeconds,
      isPartialTour: isPartialTour ?? this.isPartialTour,
      warningMessage: warningMessage is String?
          ? warningMessage
          : this.warningMessage,
      tourTitle: tourTitle is String? ? tourTitle : this.tourTitle,
      tourIntroduction: tourIntroduction is String?
          ? tourIntroduction
          : this.tourIntroduction,
      tourVibe: tourVibe is String? ? tourVibe : this.tourVibe,
      tourClosing: tourClosing is String? ? tourClosing : this.tourClosing,
      curatedTourJson: curatedTourJson is String?
          ? curatedTourJson
          : this.curatedTourJson,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class TourResultUpdateTable extends _i1.UpdateTable<TourResultTable> {
  TourResultUpdateTable(super.table);

  _i1.ColumnValue<int, int> requestId(int value) => _i1.ColumnValue(
    table.requestId,
    value,
  );

  _i1.ColumnValue<String, String> stopsJson(String value) => _i1.ColumnValue(
    table.stopsJson,
    value,
  );

  _i1.ColumnValue<int, int> confidenceScore(int value) => _i1.ColumnValue(
    table.confidenceScore,
    value,
  );

  _i1.ColumnValue<String, String> routePolyline(String value) =>
      _i1.ColumnValue(
        table.routePolyline,
        value,
      );

  _i1.ColumnValue<String, String> routeLegsJson(String value) =>
      _i1.ColumnValue(
        table.routeLegsJson,
        value,
      );

  _i1.ColumnValue<int, int> totalDistanceMeters(int value) => _i1.ColumnValue(
    table.totalDistanceMeters,
    value,
  );

  _i1.ColumnValue<int, int> totalDurationSeconds(int value) => _i1.ColumnValue(
    table.totalDurationSeconds,
    value,
  );

  _i1.ColumnValue<bool, bool> isPartialTour(bool value) => _i1.ColumnValue(
    table.isPartialTour,
    value,
  );

  _i1.ColumnValue<String, String> warningMessage(String? value) =>
      _i1.ColumnValue(
        table.warningMessage,
        value,
      );

  _i1.ColumnValue<String, String> tourTitle(String? value) => _i1.ColumnValue(
    table.tourTitle,
    value,
  );

  _i1.ColumnValue<String, String> tourIntroduction(String? value) =>
      _i1.ColumnValue(
        table.tourIntroduction,
        value,
      );

  _i1.ColumnValue<String, String> tourVibe(String? value) => _i1.ColumnValue(
    table.tourVibe,
    value,
  );

  _i1.ColumnValue<String, String> tourClosing(String? value) => _i1.ColumnValue(
    table.tourClosing,
    value,
  );

  _i1.ColumnValue<String, String> curatedTourJson(String? value) =>
      _i1.ColumnValue(
        table.curatedTourJson,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );
}

class TourResultTable extends _i1.Table<int?> {
  TourResultTable({super.tableRelation}) : super(tableName: 'tour_results') {
    updateTable = TourResultUpdateTable(this);
    requestId = _i1.ColumnInt(
      'requestId',
      this,
    );
    stopsJson = _i1.ColumnString(
      'stopsJson',
      this,
    );
    confidenceScore = _i1.ColumnInt(
      'confidenceScore',
      this,
    );
    routePolyline = _i1.ColumnString(
      'routePolyline',
      this,
    );
    routeLegsJson = _i1.ColumnString(
      'routeLegsJson',
      this,
    );
    totalDistanceMeters = _i1.ColumnInt(
      'totalDistanceMeters',
      this,
    );
    totalDurationSeconds = _i1.ColumnInt(
      'totalDurationSeconds',
      this,
    );
    isPartialTour = _i1.ColumnBool(
      'isPartialTour',
      this,
    );
    warningMessage = _i1.ColumnString(
      'warningMessage',
      this,
    );
    tourTitle = _i1.ColumnString(
      'tourTitle',
      this,
    );
    tourIntroduction = _i1.ColumnString(
      'tourIntroduction',
      this,
    );
    tourVibe = _i1.ColumnString(
      'tourVibe',
      this,
    );
    tourClosing = _i1.ColumnString(
      'tourClosing',
      this,
    );
    curatedTourJson = _i1.ColumnString(
      'curatedTourJson',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final TourResultUpdateTable updateTable;

  /// Reference to the original request.
  late final _i1.ColumnInt requestId;

  /// Ordered array of tour stops as JSON.
  late final _i1.ColumnString stopsJson;

  /// Tour confidence score (0-100).
  late final _i1.ColumnInt confidenceScore;

  /// Encoded route polyline for map rendering.
  late final _i1.ColumnString routePolyline;

  /// Per-leg route summaries as JSON.
  late final _i1.ColumnString routeLegsJson;

  /// Total tour distance in meters.
  late final _i1.ColumnInt totalDistanceMeters;

  /// Total tour duration in seconds.
  late final _i1.ColumnInt totalDurationSeconds;

  /// Whether this is a partial tour (fewer stops than requested).
  late final _i1.ColumnBool isPartialTour;

  /// Warning message when partial tour or other issues.
  late final _i1.ColumnString warningMessage;

  /// Creative title/theme for the tour (from AI curation).
  late final _i1.ColumnString tourTitle;

  /// Opening narrative that sets the stage for the journey.
  late final _i1.ColumnString tourIntroduction;

  /// The overall vibe/mood of the tour.
  late final _i1.ColumnString tourVibe;

  /// Closing narrative wrapping up the experience.
  late final _i1.ColumnString tourClosing;

  /// Full curated tour JSON from Perplexity (contains stories, dish details, tips).
  late final _i1.ColumnString curatedTourJson;

  /// When the result was created.
  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
    id,
    requestId,
    stopsJson,
    confidenceScore,
    routePolyline,
    routeLegsJson,
    totalDistanceMeters,
    totalDurationSeconds,
    isPartialTour,
    warningMessage,
    tourTitle,
    tourIntroduction,
    tourVibe,
    tourClosing,
    curatedTourJson,
    createdAt,
  ];
}

class TourResultInclude extends _i1.IncludeObject {
  TourResultInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => TourResult.t;
}

class TourResultIncludeList extends _i1.IncludeList {
  TourResultIncludeList._({
    _i1.WhereExpressionBuilder<TourResultTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TourResult.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => TourResult.t;
}

class TourResultRepository {
  const TourResultRepository._();

  /// Returns a list of [TourResult]s matching the given query parameters.
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
  Future<List<TourResult>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TourResultTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TourResultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TourResultTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<TourResult>(
      where: where?.call(TourResult.t),
      orderBy: orderBy?.call(TourResult.t),
      orderByList: orderByList?.call(TourResult.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [TourResult] matching the given query parameters.
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
  Future<TourResult?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TourResultTable>? where,
    int? offset,
    _i1.OrderByBuilder<TourResultTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<TourResultTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<TourResult>(
      where: where?.call(TourResult.t),
      orderBy: orderBy?.call(TourResult.t),
      orderByList: orderByList?.call(TourResult.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [TourResult] by its [id] or null if no such row exists.
  Future<TourResult?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<TourResult>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [TourResult]s in the list and returns the inserted rows.
  ///
  /// The returned [TourResult]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<TourResult>> insert(
    _i1.Session session,
    List<TourResult> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<TourResult>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [TourResult] and returns the inserted row.
  ///
  /// The returned [TourResult] will have its `id` field set.
  Future<TourResult> insertRow(
    _i1.Session session,
    TourResult row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<TourResult>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [TourResult]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<TourResult>> update(
    _i1.Session session,
    List<TourResult> rows, {
    _i1.ColumnSelections<TourResultTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<TourResult>(
      rows,
      columns: columns?.call(TourResult.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TourResult]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TourResult> updateRow(
    _i1.Session session,
    TourResult row, {
    _i1.ColumnSelections<TourResultTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<TourResult>(
      row,
      columns: columns?.call(TourResult.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TourResult] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TourResult?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<TourResultUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<TourResult>(
      id,
      columnValues: columnValues(TourResult.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TourResult]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<TourResult>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<TourResultUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<TourResultTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<TourResultTable>? orderBy,
    _i1.OrderByListBuilder<TourResultTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<TourResult>(
      columnValues: columnValues(TourResult.t.updateTable),
      where: where(TourResult.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TourResult.t),
      orderByList: orderByList?.call(TourResult.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [TourResult]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<TourResult>> delete(
    _i1.Session session,
    List<TourResult> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<TourResult>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [TourResult].
  Future<TourResult> deleteRow(
    _i1.Session session,
    TourResult row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TourResult>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<TourResult>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<TourResultTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<TourResult>(
      where: where(TourResult.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<TourResultTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<TourResult>(
      where: where?.call(TourResult.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
