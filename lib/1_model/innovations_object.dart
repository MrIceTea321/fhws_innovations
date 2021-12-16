import 'package:fhws_innovations/1_model/student_object.dart';
import 'package:flutter/cupertino.dart';

class Innovation {
  final String title;
  final String description;
  final Student creator;

  int likeCount = 0;

  Innovation(this.creator, this.title, this.description);

  void giveLike(bool like) {
    if (like) {
      likeCount + 1;
    }
  }

  void removeLike(bool removeLike) {
    if (removeLike) {
      likeCount - 1;
    }
  }

  int getActualLikeCount() {
    return likeCount;
  }
}
