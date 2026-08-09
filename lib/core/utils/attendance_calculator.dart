class AttendanceCalculator {
  /// Calculates the new attendance percentage if the student attends an event.
  /// 
  /// [currentPercentage] - Students current attendance (e.g. 80.0)
  /// [totalLectures] - Total lectures conducted so far.
  /// [lecturesPerDay] - Average lectures in a single day (default 5 for DYP).
  static Map<String, dynamic> calculateImpact({
    required double currentPercentage,
    required int totalLectures,
    int lecturesPerDay = 5,
  }) {
    // Current attended count
    int currentAttended = ((currentPercentage / 100) * totalLectures).round();
    
    // If student skips 1 day (all lectures that day)
    int newTotal = totalLectures + lecturesPerDay;
    // But they don't attend those new ones, so attended count stays same
    double newPercentage = (currentAttended / newTotal) * 100;
    
    double drop = currentPercentage - newPercentage;
    bool isBelowThreshold = newPercentage < 75.0;
    
    return {
      'newPercentage': double.parse(newPercentage.toStringAsFixed(1)),
      'drop': double.parse(drop.toStringAsFixed(1)),
      'isBelowThreshold': isBelowThreshold,
      'warning': isBelowThreshold 
          ? 'Warning: Attending this event will put you below the 75% threshold.' 
          : 'Safe: You will remain above 75%.',
    };
  }
}
