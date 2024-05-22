class Ranking {
  final String userId;
  final String topicId;
  final int correctAnswers;
  final int totalAttempts;
  final double accuracy;
  final int timeSpent;
  final DateTime lastUpdated;
  final int? rank;
  final int? streak;
  final int? bonusPoints;

  Ranking({
    required this.userId,
    required this.topicId,
    required this.correctAnswers,
    required this.totalAttempts,
    required this.accuracy,
    required this.timeSpent,
    required this.lastUpdated,
    this.rank,
    this.streak,
    this.bonusPoints,
  });
}
