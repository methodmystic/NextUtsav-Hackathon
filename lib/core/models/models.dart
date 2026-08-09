/// All data models for NextUtsav app.
/// These are simple Dart classes with copyWith support.
/// TODO: Migrate to freezed + json_serializable when connecting to real API.

export 'academic_models.dart';

class College {
  final String id;
  final String name;
  final String logoUrl;
  final String domain;

  const College({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.domain,
  });

  College copyWith({String? id, String? name, String? logoUrl, String? domain}) {
    return College(
      id: id ?? this.id,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      domain: domain ?? this.domain,
    );
  }
}

class AppUser {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final String collegeId;
  final List<String> followedClubs;
  final int xpPoints;
  final List<String> badges;
  final List<String> interests;
  final String role; // 'Student', 'Faculty', 'Admin'
  final String? semester;
  final String? branch;
  final String? division;
  final List<String> assignedClubs; // For Faculty
  final String? githubUrl;
  final String? linkedinUrl;
  final String? leetcodeUrl;
  final String? hackerrankUrl;
  final String? bio;

  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.collegeId,
    this.followedClubs = const [],
    this.xpPoints = 0,
    this.badges = const [],
    this.interests = const [],
    this.role = 'Student',
    this.semester,
    this.branch,
    this.division,
    this.assignedClubs = const [],
    this.githubUrl,
    this.linkedinUrl,
    this.leetcodeUrl,
    this.hackerrankUrl,
    this.bio,
  });

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    String? collegeId,
    List<String>? followedClubs,
    int? xpPoints,
    List<String>? badges,
    List<String>? interests,
    String? role,
    String? semester,
    String? branch,
    String? division,
    List<String>? assignedClubs,
    String? githubUrl,
    String? linkedinUrl,
    String? leetcodeUrl,
    String? hackerrankUrl,
    String? bio,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      collegeId: collegeId ?? this.collegeId,
      followedClubs: followedClubs ?? this.followedClubs,
      xpPoints: xpPoints ?? this.xpPoints,
      badges: badges ?? this.badges,
      interests: interests ?? this.interests,
      role: role ?? this.role,
      semester: semester ?? this.semester,
      branch: branch ?? this.branch,
      division: division ?? this.division,
      assignedClubs: assignedClubs ?? this.assignedClubs,
      githubUrl: githubUrl ?? this.githubUrl,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      leetcodeUrl: leetcodeUrl ?? this.leetcodeUrl,
      hackerrankUrl: hackerrankUrl ?? this.hackerrankUrl,
      bio: bio ?? this.bio,
    );
  }
}

class ClubMember {
  final String name;
  final String role;
  final String avatarUrl;

  const ClubMember({
    required this.name,
    required this.role,
    required this.avatarUrl,
  });
}

class Club {
  final String id;
  final String name;
  final String description;
  final String logoUrl;
  final String coverUrl;
  final String collegeId;
  final String category;
  final int memberCount;
  final int followersCount;
  final List<String> achievements;
  final List<ClubMember> coreTeam;

  const Club({
    required this.id,
    required this.name,
    required this.description,
    required this.logoUrl,
    required this.coverUrl,
    required this.collegeId,
    required this.category,
    this.memberCount = 0,
    this.followersCount = 0,
    this.achievements = const [],
    this.coreTeam = const [],
  });

  Club copyWith({
    String? id,
    String? name,
    String? description,
    String? logoUrl,
    String? coverUrl,
    String? collegeId,
    String? category,
    int? memberCount,
    int? followersCount,
    List<String>? achievements,
    List<ClubMember>? coreTeam,
  }) {
    return Club(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      collegeId: collegeId ?? this.collegeId,
      category: category ?? this.category,
      memberCount: memberCount ?? this.memberCount,
      followersCount: followersCount ?? this.followersCount,
      achievements: achievements ?? this.achievements,
      coreTeam: coreTeam ?? this.coreTeam,
    );
  }
}

class Post {
  final String id;
  final String clubId;
  final String clubName;
  final String clubLogoUrl;
  final String imageUrl;
  final String caption;
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final bool isSaved;
  final DateTime createdAt;
  final bool isEvent;
  final String? eventId;

  const Post({
    required this.id,
    required this.clubId,
    required this.clubName,
    required this.clubLogoUrl,
    required this.imageUrl,
    required this.caption,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLiked = false,
    this.isSaved = false,
    required this.createdAt,
    this.isEvent = false,
    this.eventId,
  });

  Post copyWith({
    String? id,
    String? clubId,
    String? clubName,
    String? clubLogoUrl,
    String? imageUrl,
    String? caption,
    int? likeCount,
    int? commentCount,
    bool? isLiked,
    bool? isSaved,
    DateTime? createdAt,
    bool? isEvent,
    String? eventId,
  }) {
    return Post(
      id: id ?? this.id,
      clubId: clubId ?? this.clubId,
      clubName: clubName ?? this.clubName,
      clubLogoUrl: clubLogoUrl ?? this.clubLogoUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      caption: caption ?? this.caption,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      createdAt: createdAt ?? this.createdAt,
      isEvent: isEvent ?? this.isEvent,
      eventId: eventId ?? this.eventId,
    );
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'] ?? '',
      clubId: json['clubId']?['_id'] ?? '',
      clubName: json['clubId']?['name'] ?? 'NextUtsav',
      clubLogoUrl: json['clubId']?['logoUrl'] ?? 'https://api.dicebear.com/7.x/identicon/png?seed=utsav',
      imageUrl: json['imageUrl'] ?? 'https://images.unsplash.com/photo-1540317580384-e5d43616b9aa',
      caption: json['content'] ?? '',
      likeCount: json['likes']?.length ?? 0,
      commentCount: json['commentCount'] ?? 0,
      isLiked: false, 
      isSaved: false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}

class Event {
  final String id;
  final String clubId;
  final String clubName;
  final String clubLogoUrl;
  final String title;
  final String description;
  final String posterUrl;
  final DateTime date;
  final String venue;
  final DateTime registrationDeadline;
  final bool isRegistered;
  final String type; // 'club' or 'college'
  final int volunteerSlotsOpen;
  final List<String> tags;
  final String approvalStatus; // 'Pending', 'Approved', 'Rejected'
  final String? approvedByFacultyId;

  const Event({
    required this.id,
    required this.clubId,
    required this.clubName,
    required this.clubLogoUrl,
    required this.title,
    required this.description,
    required this.posterUrl,
    required this.date,
    required this.venue,
    required this.registrationDeadline,
    this.isRegistered = false,
    this.type = 'club',
    this.volunteerSlotsOpen = 0,
    this.tags = const [],
    this.approvalStatus = 'Pending',
    this.approvedByFacultyId,
  });

  Event copyWith({
    String? id,
    String? clubId,
    String? clubName,
    String? clubLogoUrl,
    String? title,
    String? description,
    String? posterUrl,
    DateTime? date,
    String? venue,
    DateTime? registrationDeadline,
    bool? isRegistered,
    String? type,
    int? volunteerSlotsOpen,
    List<String>? tags,
    String? approvalStatus,
    String? approvedByFacultyId,
  }) {
    return Event(
      id: id ?? this.id,
      clubId: clubId ?? this.clubId,
      clubName: clubName ?? this.clubName,
      clubLogoUrl: clubLogoUrl ?? this.clubLogoUrl,
      title: title ?? this.title,
      description: description ?? this.description,
      posterUrl: posterUrl ?? this.posterUrl,
      date: date ?? this.date,
      venue: venue ?? this.venue,
      registrationDeadline: registrationDeadline ?? this.registrationDeadline,
      isRegistered: isRegistered ?? this.isRegistered,
      type: type ?? this.type,
      volunteerSlotsOpen: volunteerSlotsOpen ?? this.volunteerSlotsOpen,
      tags: tags ?? this.tags,
      approvalStatus: approvalStatus ?? this.approvalStatus,
      approvedByFacultyId: approvedByFacultyId ?? this.approvedByFacultyId,
    );
  }

  bool get isUpcoming => date.isAfter(DateTime.now());
  bool get isPast => date.isBefore(DateTime.now());
  bool get isRegistrationOpen => registrationDeadline.isAfter(DateTime.now());
}

class Badge {
  final String id;
  final String name;
  final String iconUrl;
  final String description;
  final DateTime? earnedAt;

  const Badge({
    required this.id,
    required this.name,
    required this.iconUrl,
    required this.description,
    this.earnedAt,
  });
}

class Certificate {
  final String id;
  final String eventId;
  final String eventName;
  final DateTime issuedAt;
  final String downloadUrl;

  const Certificate({
    required this.id,
    required this.eventId,
    required this.eventName,
    required this.issuedAt,
    required this.downloadUrl,
  });
}

class Application {
  final String id;
  final String clubId;
  final String clubName;
  final String clubLogoUrl;
  final String roleTitle;
  final String status; // 'applied', 'shortlisted', 'rejected', 'selected'
  final DateTime appliedAt;

  const Application({
    required this.id,
    required this.clubId,
    required this.clubName,
    required this.clubLogoUrl,
    required this.roleTitle,
    required this.status,
    required this.appliedAt,
  });

  Application copyWith({String? status}) {
    return Application(
      id: id,
      clubId: clubId,
      clubName: clubName,
      clubLogoUrl: clubLogoUrl,
      roleTitle: roleTitle,
      status: status ?? this.status,
      appliedAt: appliedAt,
    );
  }
}

class AppNotification {
  final String id;
  final String type; // 'event', 'club', 'badge', 'recruitment', 'general'
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;
  final String? targetId;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.isRead = false,
    required this.createdAt,
    this.targetId,
  });

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      type: type,
      title: title,
      body: body,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
      targetId: targetId,
    );
  }
}

class RecruitmentRole {
  final String id;
  final String clubId;
  final String clubName;
  final String clubLogoUrl;
  final String roleTitle;
  final String description;
  final DateTime deadline;
  final int applicantsCount;

  const RecruitmentRole({
    required this.id,
    required this.clubId,
    required this.clubName,
    required this.clubLogoUrl,
    required this.roleTitle,
    required this.description,
    required this.deadline,
    this.applicantsCount = 0,
  });

  bool get isOpen => deadline.isAfter(DateTime.now());
}

class Hackathon {
  final String id;
  final String title;
  final String organizer;
  final String description;
  final String posterUrl;
  final DateTime date;
  final String location; // 'Online', 'In-person' or city
  final String registrationUrl;
  final List<String> tags;
  final String prizePool;
  final bool isNearby;

  const Hackathon({
    required this.id,
    required this.title,
    required this.organizer,
    required this.description,
    required this.posterUrl,
    required this.date,
    required this.location,
    required this.registrationUrl,
    this.tags = const [],
    this.prizePool = 'TBD',
    this.isNearby = false,
  });
}
