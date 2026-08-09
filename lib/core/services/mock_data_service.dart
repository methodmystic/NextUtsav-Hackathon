import '../models/models.dart';

class MockDataService {
  static final List<College> colleges = [
    const College(
      id: 'dypcoe-akurdi',
      name: 'D Y Patil College of Engineering',
      logoUrl: 'https://images.unsplash.com/photo-1562774053-701939374585?w=200',
      domain: 'dypcoeakurdi.ac.in',
    ),
  ];

  static final List<Club> clubs = [
    Club(
      id: 'gdgc-dypcoe',
      name: 'GDGC DYPCOE',
      description: 'Google Developer Groups on Campus - DYPCOE. Building a global community of curious developers.',
      logoUrl: 'https://www.gstatic.com/devrel-devsite/prod/v7b78f7.../developers/images/touchicon-180.png', // Placeholder for GDG logo
      coverUrl: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&q=80',
      collegeId: 'dypcoe-akurdi',
      category: 'Technical',
      memberCount: 250,
      followersCount: 1200,
      achievements: ['Best Tech Club 2023', 'Google Cloud Partner'],
      coreTeam: [
        const ClubMember(name: 'Ganesh Dhadke', role: 'GDGoC Organizer', avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=Ganesh'),
        const ClubMember(name: 'Siddhant Kadam', role: 'Cybersecurity Lead', avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=Siddhant'),
        const ClubMember(name: 'Tanishka Muttha', role: 'Cybersecurity Lead', avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=Tanishka'),
        const ClubMember(name: 'Sankalp Panchabhai', role: 'Web Lead', avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=Sankalp'),
        const ClubMember(name: 'Varun Nagote', role: 'DSA-CP Lead', avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=Varun'),
        const ClubMember(name: 'Atharva Jagtap', role: 'Android Lead', avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=AtharvaJ'),
        const ClubMember(name: 'Atharva Darpude', role: 'AI/ML Lead', avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=AtharvaD'),
        const ClubMember(name: 'Pranav Gaikwad', role: 'Social Media Lead', avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=Pranav'),
        const ClubMember(name: 'Vaishnavi Gawande', role: 'Media Lead', avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=Vaishnavi'),
        const ClubMember(name: 'Janhavi Ghanghav', role: 'Management Lead', avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=Janhavi'),
        const ClubMember(name: 'Nitin Daiya', role: 'Management Lead', avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=Nitin'),
        const ClubMember(name: 'Kaushal Abojwar', role: 'Design Lead', avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=Kaushal'),
        const ClubMember(name: 'Sarvesh Chavan', role: 'Design Lead', avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=Sarvesh'),
        const ClubMember(name: 'Sakshi Chaudhary', role: 'Design Lead', avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=Sakshi'),
        const ClubMember(name: 'Rutuja Chaudhari', role: 'Documentation Lead', avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=Rutuja'),
      ],
    ),
    const Club(
      id: 'itesa.dyp',
      name: 'ITESA',
      description: 'Information Technology Engineering Students Association. The heart of IT innovation at DYPCOE.',
      logoUrl: 'https://images.unsplash.com/photo-1517048676732-d65bc937f952?w=200&q=80',
      coverUrl: 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=800',
      collegeId: 'dypcoe-akurdi',
      category: 'Departmental',
      memberCount: 450,
      followersCount: 1850,
      achievements: ['National Quality Award', '50+ Events Hosted'],
    ),
    const Club(
      id: 'acesdypcoe',
      name: 'ACES',
      description: 'Association of Computer Engineering Students. Empowering Future Computer Scientists.',
      logoUrl: 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=200&q=80',
      coverUrl: 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=800',
      collegeId: 'dypcoe-akurdi',
      category: 'Departmental',
      memberCount: 500,
      followersCount: 1500,
      achievements: ['Oldest Student Body', 'HackOverflow Founders'],
    ),
  ];

  static final List<Event> events = [
    Event(
      id: 'devsummit-26',
      clubId: 'gdgc-dypcoe',
      clubName: 'GDGC DYPCOE',
      clubLogoUrl: 'https://images.unsplash.com/photo-1542831371-29b0f74f9713?w=200&q=80',
      title: 'DevSummit ’26',
      description: 'Expert speakers 🤝 Networking with tech minds... Don’t miss the biggest student tech conference of the year!',
      posterUrl: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&q=80',
      date: DateTime.now().add(const Duration(days: 15)),
      venue: 'DYPCOE Auditorium',
      registrationDeadline: DateTime.now().add(const Duration(days: 10)),
      tags: ['Summit', 'GDGC'],
    ),
  ];

  static final List<Post> posts = [
    Post(
      id: 'p1',
      clubId: 'gdgc-dypcoe',
      clubName: 'GDGC DYPCOE',
      clubLogoUrl: 'https://images.unsplash.com/photo-1542831371-29b0f74f9713?w=200&q=80',
      imageUrl: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800&q=80',
      caption: '🚀 DevSummit ’26 is HERE! Expert speakers 🤝 Networking with tech minds... Don’t miss the biggest student tech conference of the year!',
      likeCount: 542,
      commentCount: 84,
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    Post(
      id: 'p2',
      clubId: 'itesa.dyp',
      clubName: 'ITESA',
      clubLogoUrl: 'https://images.unsplash.com/photo-1517048676732-d65bc937f952?w=200&q=80',
      imageUrl: 'https://images.unsplash.com/photo-1529336953128-a85760f58cb5?w=800&q=80',
      caption: 'Something\'s blooming🌀 ITESA MERCH reveal soon...🔥⏳ #ITESA #MERCH',
      likeCount: 215,
      commentCount: 45,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Post(
      id: 'p3',
      clubId: 'acesdypcoe',
      clubName: 'ACES',
      clubLogoUrl: 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=200&q=80',
      imageUrl: 'https://images.unsplash.com/photo-1552820728-8b83bb6b773f?w=800&q=80',
      caption: 'Two games. One brain. No mercy. 🎮⚡ Take on the Quick Dual Challenge and prove your reflexes. Ready to play?',
      likeCount: 389,
      commentCount: 22,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  static final List<AppUser> users = [
    const AppUser(
      id: 'u1',
      name: 'Aditya Kalra',
      email: 'aditya.student@dypcoeakurdi.ac.in',
      avatarUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=200',
      collegeId: 'dypcoe-akurdi',
      followedClubs: ['gdgc-dypcoe', 'acesdypcoe'],
      xpPoints: 1250,
      badges: ['GDGC Member', 'Code-Crush Winner'],
      interests: ['Coding', 'AI/ML', 'Design'],
      semester: '6th',
      branch: 'B.E Computer Engineering',
      bio: 'Full Stack Dev | Flutter Enthusiast | AI Explorer. Building the future of campus life 🚀',
      githubUrl: 'https://github.com/aditya',
      linkedinUrl: 'https://linkedin.com/in/aditya',
      leetcodeUrl: 'https://leetcode.com/aditya',
      hackerrankUrl: 'https://hackerrank.com/aditya',
    ),
    const AppUser(
      id: 'u2',
      name: 'Dr. Sanjay Agarwal',
      email: 'sanjay.faculty@dypcoeakurdi.ac.in',
      avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=Sanjay',
      collegeId: 'dypcoe-akurdi',
      role: 'Faculty',
      assignedClubs: ['gdgc-dypcoe'],
      branch: 'Computer Engineering',
    ),
  ];

  static final List<CollegeCalendarItem> calendarItems = [
    CollegeCalendarItem(
      id: 'cal1',
      title: 'Unit Test 1',
      type: 'Exam',
      date: DateTime.now().add(const Duration(days: 3)),
      description: 'First internal assessment for all branches.',
    ),
    CollegeCalendarItem(
      id: 'cal2',
      title: 'Holi Break',
      type: 'Holiday',
      date: DateTime.now().add(const Duration(days: 7)),
      description: 'College closed for Holi festival.',
    ),
    CollegeCalendarItem(
      id: 'cal3',
      title: 'Annual Sports Meet',
      type: 'Event',
      date: DateTime.now().add(const Duration(days: 20)),
      description: 'Mega sports event at DYP grounds.',
    ),
  ];

  static final List<Badge> badges = [
    Badge(
      id: 'b1',
      name: 'Hackathon Hero',
      iconUrl: 'https://images.unsplash.com/photo-1599305090598-fe179d501c27?w=200',
      description: 'Participated in a college hackathon.',
      earnedAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
  ];

  static final List<Certificate> certificates = [
    Certificate(
      id: 'c1',
      eventId: 'devsummit-26',
      eventName: 'DevSummit ’26 Participant',
      issuedAt: DateTime.now().subtract(const Duration(days: 5)),
      downloadUrl: '#',
    ),
  ];

  static final List<String> categories = [
    'Technical', 'Cultural', 'Sports', 'Departmental', 'Social', 'Entrepreneurship',
  ];

  static final List<String> interestTags = [
    'Coding', 'Design', 'Music', 'Dance', 'Sports', 'Photography', 'AI/ML', 'Literature', 'Social Work',
  ];

  static final List<AppNotification> notifications = [
    AppNotification(
      id: 'n1',
      type: 'event',
      title: 'New Event: DevSummit ’26',
      body: 'Register now for the biggest tech conference on campus!',
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
  ];

  static final List<RecruitmentRole> recruitmentRoles = [
    RecruitmentRole(
      id: 'r1',
      clubId: 'gdgc-dypcoe',
      clubName: 'GDGC DYPCOE',
      clubLogoUrl: 'https://images.unsplash.com/photo-1542831371-29b0f74f9713?w=200&q=80',
      roleTitle: 'Technical Lead',
      description: 'Lead the tech team and organize DevSummit.',
      deadline: DateTime.now().add(const Duration(days: 5)),
      applicantsCount: 12,
    ),
  ];

  static final List<Application> applications = [];
}
