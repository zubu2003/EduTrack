class SKeys {
  // Storage Keys
  static const String rememberMeEmail = 'rememberMeEmail';
  static const String rememberMePassword = 'rememberMePassword';
  static const String rememberMeCheckbox = 'rememberMeCheckbox';
  static const String isFirstTime = 'isFirstTime';
  static const String userRole = 'userRole';

  /// Student email must contain this pattern
  static const String studentEmailPattern = '@student.';

  // Google Sign-In
  static const String googleWebClientId =
      '460723661177-b831lnoh4kgmc2rm8s8tltihhasdu63s.apps.googleusercontent.com';


  //Cloudinary Keys
  static const String cloudname = 'dvhlep9ov';
  static const String apiKey = '723351754777293';
  static const String apiSecret = 'O4G_X5_SyVmMQm7vbz4liXrlkeY';
  static const String uploadPreset = 'edutrack';

  //Cloudinary Folders
  static const String studentProfileFolder = 'edutrack/student_profiles';
  static const String teacherProfileFolder = 'edutrack/teacher_profiles';

}

class SCollections {
  // Firestore Collections
  static const String users = 'users';
  static const String courses = 'courses';
  static const String attendance = 'attendance';
  static const String ctMarks = 'ct_marks';
  static const String routines = 'routines';
}

class SUserFields {
  // User Document Fields
  static const String uid = 'uid';
  static const String name = 'name';
  static const String email = 'email';
  static const String phone = 'phone';
  static const String role = 'role';
  static const String profileImage = 'profileImage';
  static const String profileImagePublicId = 'profileImagePublicId';
  static const String studentId = 'studentId';
  static const String teacherId = 'teacherId';
  static const String department = 'department';
  static const String batch = 'batch';
  static const String designation = 'designation';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
}

class SRoles {
  static const String student = 'student';
  static const String teacher = 'teacher';
}

class SApiUrls {
  // Cloudinary
  static String uploadApi(String cloudName) =>
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload';

  static String deleteApi(String cloudName) =>
      'https://api.cloudinary.com/v1_1/$cloudName/image/destroy';
}