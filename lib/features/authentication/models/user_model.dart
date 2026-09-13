import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edutrack/utils/constant/keys.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String profileImage;
  final String studentId;
  final String teacherId;
  final String department;
  final String batch;
  final String designation;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.profileImage,
    required this.studentId,
    required this.teacherId,
    required this.department,
    required this.batch,
    required this.designation,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Empty User
  static UserModel empty() => UserModel(
    uid: '',
    name: '',
    email: '',
    phone: '',
    role: '',
    profileImage: '',
    studentId: '',
    teacherId: '',
    department: '',
    batch: '',
    designation: '',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  /// From JSON (Firestore)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json[SUserFields.uid] ?? '',
      name: json[SUserFields.name] ?? '',
      email: json[SUserFields.email] ?? '',
      phone: json[SUserFields.phone] ?? '',
      role: json[SUserFields.role] ?? '',
      profileImage: json[SUserFields.profileImage] ?? '',
      studentId: json[SUserFields.studentId] ?? '',
      teacherId: json[SUserFields.teacherId] ?? '',
      department: json[SUserFields.department] ?? '',
      batch: json[SUserFields.batch] ?? '',
      designation: json[SUserFields.designation] ?? '',
      createdAt: (json[SUserFields.createdAt] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (json[SUserFields.updatedAt] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      SUserFields.uid: uid,
      SUserFields.name: name,
      SUserFields.email: email,
      SUserFields.phone: phone,
      SUserFields.role: role,
      SUserFields.profileImage: profileImage,
      SUserFields.studentId: studentId,
      SUserFields.teacherId: teacherId,
      SUserFields.department: department,
      SUserFields.batch: batch,
      SUserFields.designation: designation,
      SUserFields.createdAt: createdAt,
      SUserFields.updatedAt: updatedAt,
    };
  }

  /// Copy with
  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? role,
    String? profileImage,
    String? studentId,
    String? teacherId,
    String? department,
    String? batch,
    String? designation,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      profileImage: profileImage ?? this.profileImage,
      studentId: studentId ?? this.studentId,
      teacherId: teacherId ?? this.teacherId,
      department: department ?? this.department,
      batch: batch ?? this.batch,
      designation: designation ?? this.designation,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}