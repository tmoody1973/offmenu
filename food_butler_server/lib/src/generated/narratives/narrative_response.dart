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
import 'package:food_butler_server/src/generated/protocol.dart' as _i2;

/// Response structure for generated tour narratives.
abstract class NarrativeResponse
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  NarrativeResponse._({
    required this.intro,
    required this.descriptions,
    required this.transitions,
    required this.generatedAt,
    required this.cached,
    required this.ttlRemainingSeconds,
    required this.fallbackUsed,
    required this.failedTypes,
  });

  factory NarrativeResponse({
    required String intro,
    required List<String> descriptions,
    required List<String> transitions,
    required DateTime generatedAt,
    required bool cached,
    required int ttlRemainingSeconds,
    required bool fallbackUsed,
    required List<String> failedTypes,
  }) = _NarrativeResponseImpl;

  factory NarrativeResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return NarrativeResponse(
      intro: jsonSerialization['intro'] as String,
      descriptions: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['descriptions'],
      ),
      transitions: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['transitions'],
      ),
      generatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['generatedAt'],
      ),
      cached: jsonSerialization['cached'] as bool,
      ttlRemainingSeconds: jsonSerialization['ttlRemainingSeconds'] as int,
      fallbackUsed: jsonSerialization['fallbackUsed'] as bool,
      failedTypes: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['failedTypes'],
      ),
    );
  }

  /// Tour introduction narrative (50-75 words).
  String intro;

  /// Restaurant description narratives (75-100 words each).
  List<String> descriptions;

  /// Transition narratives between stops (25-40 words each).
  List<String> transitions;

  /// When the narratives were generated.
  DateTime generatedAt;

  /// Whether the response was served from cache.
  bool cached;

  /// Remaining cache TTL in seconds (0 if freshly generated).
  int ttlRemainingSeconds;

  /// Whether any fallback text was used.
  bool fallbackUsed;

  /// List of narrative types that failed and used fallback.
  List<String> failedTypes;

  /// Returns a shallow copy of this [NarrativeResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NarrativeResponse copyWith({
    String? intro,
    List<String>? descriptions,
    List<String>? transitions,
    DateTime? generatedAt,
    bool? cached,
    int? ttlRemainingSeconds,
    bool? fallbackUsed,
    List<String>? failedTypes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NarrativeResponse',
      'intro': intro,
      'descriptions': descriptions.toJson(),
      'transitions': transitions.toJson(),
      'generatedAt': generatedAt.toJson(),
      'cached': cached,
      'ttlRemainingSeconds': ttlRemainingSeconds,
      'fallbackUsed': fallbackUsed,
      'failedTypes': failedTypes.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'NarrativeResponse',
      'intro': intro,
      'descriptions': descriptions.toJson(),
      'transitions': transitions.toJson(),
      'generatedAt': generatedAt.toJson(),
      'cached': cached,
      'ttlRemainingSeconds': ttlRemainingSeconds,
      'fallbackUsed': fallbackUsed,
      'failedTypes': failedTypes.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _NarrativeResponseImpl extends NarrativeResponse {
  _NarrativeResponseImpl({
    required String intro,
    required List<String> descriptions,
    required List<String> transitions,
    required DateTime generatedAt,
    required bool cached,
    required int ttlRemainingSeconds,
    required bool fallbackUsed,
    required List<String> failedTypes,
  }) : super._(
         intro: intro,
         descriptions: descriptions,
         transitions: transitions,
         generatedAt: generatedAt,
         cached: cached,
         ttlRemainingSeconds: ttlRemainingSeconds,
         fallbackUsed: fallbackUsed,
         failedTypes: failedTypes,
       );

  /// Returns a shallow copy of this [NarrativeResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  NarrativeResponse copyWith({
    String? intro,
    List<String>? descriptions,
    List<String>? transitions,
    DateTime? generatedAt,
    bool? cached,
    int? ttlRemainingSeconds,
    bool? fallbackUsed,
    List<String>? failedTypes,
  }) {
    return NarrativeResponse(
      intro: intro ?? this.intro,
      descriptions: descriptions ?? this.descriptions.map((e0) => e0).toList(),
      transitions: transitions ?? this.transitions.map((e0) => e0).toList(),
      generatedAt: generatedAt ?? this.generatedAt,
      cached: cached ?? this.cached,
      ttlRemainingSeconds: ttlRemainingSeconds ?? this.ttlRemainingSeconds,
      fallbackUsed: fallbackUsed ?? this.fallbackUsed,
      failedTypes: failedTypes ?? this.failedTypes.map((e0) => e0).toList(),
    );
  }
}
