import 'package:fhws_innovations/1_model/student_object.dart';

class Innovation {
  final String title;
  final String description;
  final Student creator;
  // TODO change to unit8 list
  final String uniqueInnovationHash;
  int votingCount = 0;

  Innovation(
      this.creator, this.title, this.description, this.uniqueInnovationHash);

  void setVote(bool like) {
    if (like) {
      votingCount + 1;
    }
  }

  void removeVote(bool removeLike) {
    if (removeLike) {
      votingCount - 1;
    }
  }

  int getAllVotesForInnovation() {
    return votingCount;
  }
}
