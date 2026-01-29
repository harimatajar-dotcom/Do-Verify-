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
}
