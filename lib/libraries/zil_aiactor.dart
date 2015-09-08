part of zil;

class AIActor extends ZilActor {
  Goal currentGoal;

  void update({Room currentRoom: null, bool describe: true}) {
    if (currentGoal == null || currentGoal.completed || currentGoal.failed) {
      // When nothing else is going on, switch to autonomous thinking mode.
      currentGoal = new Think(this);
    }
    var reports = currentGoal._processInternal();
    if (_zil.player.isInSameRoomAs(this) && describe) {
      // Only report if player is around.
      storyline.reports.addAll(reports);
    }
  }

  AIActor(Zil zil, String name, {bool nameIsProperNoun: false,
      int team: Actor.NEUTRAL, bool isPlayer: false,
      Pronoun pronoun: Pronoun.IT})
      : super(zil, name,
          nameIsProperNoun: nameIsProperNoun,
          team: team,
          isPlayer: isPlayer,
          pronoun: pronoun);
}
