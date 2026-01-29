/// User entity representing app user
class UserEntity {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String initials;
  final bool isPro;
  final int checklistCount;
  final int completedCount;
  final int tasksDone;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.initials,
    this.isPro = false,
    this.checklistCount = 0,
    this.completedCount = 0,
    this.tasksDone = 0,
  });

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    String? initials,
    bool? isPro,
    int? checklistCount,
    int? completedCount,
    int? tasksDone,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      initials: initials ?? this.initials,
      isPro: isPro ?? this.isPro,
      checklistCount: checklistCount ?? this.checklistCount,
      completedCount: completedCount ?? this.completedCount,
      tasksDone: tasksDone ?? this.tasksDone,
    );
  }

  static UserEntity defaultUser() {
    return const UserEntity(
      id: '1',
      name: 'John Doe',
      email: 'john.doe@example.com',
      initials: 'JD',
      isPro: true,
      checklistCount: 12,
      completedCount: 8,
      tasksDone: 47,
    );
  }

  /// Create from JSON (API response)
  factory UserEntity.fromJson(Map<String, dynamic> json) {
    final name = json['name'] ?? '';
    final nameParts = name.split(' ');
    final initials = nameParts.length >= 2
        ? '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase()
        : name.isNotEmpty ? name[0].toUpperCase() : 'U';

    return UserEntity(
      id: json['_id'] ?? json['id'] ?? '',
      name: name,
      email: json['email'] ?? '',
      avatarUrl: json['avatar'],
      initials: initials,
      isPro: json['plan'] != null && json['plan'] != 'free',
      checklistCount: json['stats']?['totalChecklists'] ?? 0,
      completedCount: json['stats']?['completedChecklists'] ?? 0,
      tasksDone: json['stats']?['totalCompletedTasks'] ?? 0,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatarUrl,
    };
  }
}
