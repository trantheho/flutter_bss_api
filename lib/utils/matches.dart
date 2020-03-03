import 'package:flutter/widgets.dart';
import 'package:flutter_bss_api/db/database.dart';
import 'package:flutter_bss_api/models/user.dart';


class MatchEngine extends ChangeNotifier {
  final List<Match> _matches;
  int _currrentMatchIndex;
  int _nextMatchIndex;

  MatchEngine({
    List<Match> matches,
  }) : _matches = matches {
    _currrentMatchIndex = 0;
    _nextMatchIndex = 1;
  }

  Match get currentMatch => _matches[_currrentMatchIndex];
  Match get nextMatch => _matches[_nextMatchIndex];

  void cycleMatch() {
    if (currentMatch.decision != Decision.indecided) {
      currentMatch.reset();
      _currrentMatchIndex = _nextMatchIndex;
      _nextMatchIndex =
          _nextMatchIndex < _matches.length - 1 ? _nextMatchIndex + 1 : 0;
      notifyListeners();
    }
  }
}

class Match extends ChangeNotifier {
  final User user;
  DatabaseHelper db = DatabaseHelper();
  Decision decision = Decision.indecided;

  Match({this.user});

  void like() {
    if (decision == Decision.indecided) {
      decision = Decision.like;
      notifyListeners();
    }
    db.saveUser(user);
  }

  void nope() {
    if (decision == Decision.indecided) {
      decision = Decision.nope;
      notifyListeners();
    }
  }

  void superLike() {
    if (decision == Decision.indecided) {
      decision = Decision.superLike;
      notifyListeners();
    }
  }

  void reset() {
    if (decision != Decision.indecided) {
      decision = Decision.indecided;
      notifyListeners();
    }
  }
}

enum Decision {
  indecided,
  nope,
  like,
  superLike,
}
