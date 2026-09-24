class SPromptTemplates {
  SPromptTemplates._();

  /// ---------- 1. Attendance Risk Predictor ----------
  static String attendanceRisk({
    required String studentName,
    required String courseName,
    required double attendancePercent,
    required int
    recentTrend, // +ve = improving, -ve = worsening (last 3 sessions delta)
    required int sessionsRemaining,
  }) {
    return '''
You are an academic risk analyst for a university tracking app.
Analyze the student's attendance and classify risk.

Student: $studentName
Course: $courseName
Current attendance: ${attendancePercent.toStringAsFixed(1)}%
Recent trend (last 3 sessions delta): $recentTrend
Sessions remaining: $sessionsRemaining

Rules:
- Risk = HIGH if attendance < 60 or trend is strongly negative.
- Risk = MEDIUM if attendance < 80 or trend is mildly negative.
- Risk = LOW otherwise.

Return STRICT JSON only, no markdown, no explanation:
{
  "riskLevel": "LOW" | "MEDIUM" | "HIGH",
  "reason": "one short sentence",
  "recommendation": "one short actionable sentence"
}
''';
  }

  /// ---------- 2. Academic Performance Insight ----------
  static String performanceInsight({
    required String studentName,
    required String courseName,
    required double ctAverage,
    required double courseMean,
    required double attendancePercent,
  }) {
    return '''
You are an academic performance coach.
Generate a short, honest, encouraging insight for this student.

Student: $studentName
Course: $courseName
CT average: ${ctAverage.toStringAsFixed(1)} / 20
Course average: ${courseMean.toStringAsFixed(1)} / 20
Attendance: ${attendancePercent.toStringAsFixed(1)}%

Return STRICT JSON only:
{
  "insight": "2-3 sentence insight",
  "tip": "one concrete actionable tip"
}
''';
  }

  /// ---------- 3. CT Reminder ----------
  static String ctReminder({
    required String studentName,
    required String courseName,
    required String ctTitle,
    required String topics,
    required int daysUntil,
    required double attendancePercent,
  }) {
    return '''
Generate a personalized CT reminder for a university student.

Student: $studentName
Course: $courseName
CT: $ctTitle
Topics: $topics
Days until CT: $daysUntil
Student attendance in course: ${attendancePercent.toStringAsFixed(1)}%

Return STRICT JSON only:
{
  "title": "short reminder title",
  "message": "2-3 sentence personalized reminder mentioning urgency and attendance context",
  "suggestedStudyHours": number
}
''';
  }

  /// ---------- 4. Course Report ----------
  static String courseReport({
    required String courseName,
    required String courseCode,
    required int totalStudents,
    required double avgAttendance,
    required double avgCt,
    required int atRiskCount,
  }) {
    return '''
You are a university course analyst. Generate a structured course report.

Course: $courseName ($courseCode)
Students: $totalStudents
Average attendance: ${avgAttendance.toStringAsFixed(1)}%
Average CT marks: ${avgCt.toStringAsFixed(1)} / 20
At-risk students: $atRiskCount

Return STRICT JSON only:
{
  "overview": "2-3 sentence summary",
  "attendanceSummary": "2 sentence analysis",
  "ctSummary": "2 sentence analysis",
  "risks": ["risk 1", "risk 2"],
  "recommendations": ["rec 1", "rec 2", "rec 3"]
}
''';
  }

  /// ---------- 5. Natural Language Search ----------
  static String nlSearch({
    required String role, // "student" or "teacher"
    required String query,
  }) {
    return '''
You are a query parser for a university app.
Convert the user's natural language query into a structured JSON filter.

User role: $role
Query: "$query"

Use only these executable collections: courses, attendance, ct_marks, routines.
Collection fields:
- courses: courseName, courseCode, batch, department
- attendance: courseName, courseCode, status, date
- ct_marks: courseName, courseCode, ctTitle, mark
- routines: day, courseName, courseCode, room
Allowed operators: ==, !=, >, <, >=, <=.
Allowed sorts: asc, desc.

For attendance and ct_marks, courseName/courseCode identify an authorized
course before its nested records are evaluated. Never request another
student's studentId or studentCode. If the question is unsupported, return
collection "courses" with an empty filters list and explain that clearly.

For attendance questions:
- "did I attend/present on [date]" => collection "attendance" with
  courseCode/courseName and date filters; use date format "YYYY-MM-DD" when
  the year is known, otherwise preserve the day and month words.
- "how many classes happened/are recorded" => collection "attendance" with
  only the courseCode/courseName filter.
- "attendance percentage" => collection "attendance" with the course filter
  and no student identity filter.

For teacher questions, use the teacher's authorized courses only:
- "my next class" => collection "routines" with the next class intent.
- "how many CTs happened for [course]" => collection "ct_marks" with the
  course filter and an empty or published-status-compatible CT filter.
- "which students did not attend CT-1 for [course]" => collection "ct_marks"
  with courseCode and ctTitle filters. The app resolves missing or absent
  marks against the authorized enrollment list.

Return STRICT JSON only:
{
  "collection": "one of the allowed collections",
  "filters": [
    { "field": "fieldName", "op": "==", "value": "value" }
  ],
  "sort": { "field": "fieldName", "direction": "desc" } | null,
  "limit": 20,
  "humanReadable": "one-line explanation of what you searched"
}
''';
  }
}
