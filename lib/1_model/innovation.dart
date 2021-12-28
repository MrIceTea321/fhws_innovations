import 'package:fhws_innovations/1_model/student_object.dart';

class Innovation {
  final String uniqueInnovationHash;
  final BigInt votingCount;
  final Student creator;
  final String title;
  final String description;

  // TODO change to unit8 list

  Innovation( {
    required this.uniqueInnovationHash,
    required this.votingCount,
    required this.creator,
    required this.title,
    required this.description,
  });

  @override
  String toString() {
    return 'Innovation{uniqueInnovationHash: $uniqueInnovationHash, votingCount: $votingCount, creator: $creator, title: $title, description: $description}';
  }
}
