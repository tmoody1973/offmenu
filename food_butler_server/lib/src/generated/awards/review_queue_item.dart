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

/// Item in the review queue.
abstract class ReviewQueueItem
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ReviewQueueItem._({
    required this.linkId,
    required this.restaurantName,
    required this.restaurantAddress,
    required this.awardName,
    required this.awardDetails,
    required this.awardType,
    required this.confidenceScore,
  });

  factory ReviewQueueItem({
    required int linkId,
    required String restaurantName,
    required String restaurantAddress,
    required String awardName,
    required String awardDetails,
    required String awardType,
    required double confidenceScore,
  }) = _ReviewQueueItemImpl;

  factory ReviewQueueItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReviewQueueItem(
      linkId: jsonSerialization['linkId'] as int,
      restaurantName: jsonSerialization['restaurantName'] as String,
      restaurantAddress: jsonSerialization['restaurantAddress'] as String,
      awardName: jsonSerialization['awardName'] as String,
      awardDetails: jsonSerialization['awardDetails'] as String,
      awardType: jsonSerialization['awardType'] as String,
      confidenceScore: (jsonSerialization['confidenceScore'] as num).toDouble(),
    );
  }

  /// Restaurant award link ID.
  int linkId;

  /// Restaurant name.
  String restaurantName;

  /// Restaurant address.
  String restaurantAddress;

  /// Award name.
  String awardName;

  /// Award details.
  String awardDetails;

  /// Award type.
  String awardType;

  /// Match confidence score.
  double confidenceScore;

  /// Returns a shallow copy of this [ReviewQueueItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ReviewQueueItem copyWith({
    int? linkId,
    String? restaurantName,
    String? restaurantAddress,
    String? awardName,
    String? awardDetails,
    String? awardType,
    double? confidenceScore,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReviewQueueItem',
      'linkId': linkId,
      'restaurantName': restaurantName,
      'restaurantAddress': restaurantAddress,
      'awardName': awardName,
      'awardDetails': awardDetails,
      'awardType': awardType,
      'confidenceScore': confidenceScore,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReviewQueueItem',
      'linkId': linkId,
      'restaurantName': restaurantName,
      'restaurantAddress': restaurantAddress,
      'awardName': awardName,
      'awardDetails': awardDetails,
      'awardType': awardType,
      'confidenceScore': confidenceScore,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ReviewQueueItemImpl extends ReviewQueueItem {
  _ReviewQueueItemImpl({
    required int linkId,
    required String restaurantName,
    required String restaurantAddress,
    required String awardName,
    required String awardDetails,
    required String awardType,
    required double confidenceScore,
  }) : super._(
         linkId: linkId,
         restaurantName: restaurantName,
         restaurantAddress: restaurantAddress,
         awardName: awardName,
         awardDetails: awardDetails,
         awardType: awardType,
         confidenceScore: confidenceScore,
       );

  /// Returns a shallow copy of this [ReviewQueueItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ReviewQueueItem copyWith({
    int? linkId,
    String? restaurantName,
    String? restaurantAddress,
    String? awardName,
    String? awardDetails,
    String? awardType,
    double? confidenceScore,
  }) {
    return ReviewQueueItem(
      linkId: linkId ?? this.linkId,
      restaurantName: restaurantName ?? this.restaurantName,
      restaurantAddress: restaurantAddress ?? this.restaurantAddress,
      awardName: awardName ?? this.awardName,
      awardDetails: awardDetails ?? this.awardDetails,
      awardType: awardType ?? this.awardType,
      confidenceScore: confidenceScore ?? this.confidenceScore,
    );
  }
}
