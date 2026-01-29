/// Shared checklist entity for shared items
class SharedChecklistEntity {
  final String id;
  final String title;
  final String? description;
  final String ownerName;
  final String ownerInitials;
  final String ownerColor;
  final String permission; // 'edit' or 'view'
  final String sharedTime;
  final int totalTasks;
  final int completedTasks;
  final bool isSharedByMe;
  final int? collaboratorCount;

  const SharedChecklistEntity({
    required this.id,
    required this.title,
    this.description,
    required this.ownerName,
    required this.ownerInitials,
    required this.ownerColor,
    required this.permission,
    required this.sharedTime,
    required this.totalTasks,
    required this.completedTasks,
    this.isSharedByMe = false,
    this.collaboratorCount,
  });

  double get progress => totalTasks > 0 ? completedTasks / totalTasks : 0.0;
  int get progressPercent => (progress * 100).round();
  bool get isCompleted => progress == 1.0;
  bool get canEdit => permission == 'edit';

  static List<SharedChecklistEntity> sampleSharedWithMe() {
    return [
      const SharedChecklistEntity(
        id: 'shared-1',
        title: 'Marketing Campaign Q1',
        description: 'Q1 2025 marketing campaign launch checklist with all deliverables',
        ownerName: 'Sarah Miller',
        ownerInitials: 'SM',
        ownerColor: '#E07B4C',
        permission: 'edit',
        sharedTime: '2 days ago',
        totalTasks: 10,
        completedTasks: 3,
      ),
      const SharedChecklistEntity(
        id: 'shared-2',
        title: 'Product Roadmap 2025',
        description: 'Annual product planning and feature prioritization',
        ownerName: 'Mike Kim',
        ownerInitials: 'MK',
        ownerColor: '#8B9A6D',
        permission: 'view',
        sharedTime: '1 week ago',
        totalTasks: 20,
        completedTasks: 13,
      ),
      const SharedChecklistEntity(
        id: 'shared-3',
        title: 'Sprint 23 Tasks',
        description: 'Development tasks for current sprint',
        ownerName: 'Alex Lee',
        ownerInitials: 'AL',
        ownerColor: '#00D9C0',
        permission: 'edit',
        sharedTime: 'yesterday',
        totalTasks: 10,
        completedTasks: 8,
      ),
      const SharedChecklistEntity(
        id: 'shared-4',
        title: 'Office Move Checklist',
        description: 'Tasks for relocating to the new office space',
        ownerName: 'Jane Wilson',
        ownerInitials: 'JW',
        ownerColor: '#C4A484',
        permission: 'view',
        sharedTime: '3 days ago',
        totalTasks: 15,
        completedTasks: 15,
      ),
    ];
  }

  static List<SharedChecklistEntity> sampleSharedByMe() {
    return [
      const SharedChecklistEntity(
        id: 'my-shared-1',
        title: 'Project Launch',
        description: 'Launch the new marketing website with all features',
        ownerName: '3 collaborators',
        ownerInitials: '',
        ownerColor: '',
        permission: 'edit',
        sharedTime: '5 days ago',
        totalTasks: 5,
        completedTasks: 2,
        isSharedByMe: true,
        collaboratorCount: 3,
      ),
      const SharedChecklistEntity(
        id: 'my-shared-2',
        title: 'Team Onboarding',
        description: 'Onboarding checklist for new team members',
        ownerName: '1 collaborator',
        ownerInitials: '',
        ownerColor: '',
        permission: 'edit',
        sharedTime: '2 weeks ago',
        totalTasks: 6,
        completedTasks: 6,
        isSharedByMe: true,
        collaboratorCount: 1,
      ),
    ];
  }
}
