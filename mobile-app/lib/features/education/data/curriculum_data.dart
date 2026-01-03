import 'package:flutter/material.dart';

/// Comprehensive curriculum data for classes 1-12 with class-specific subjects
class CurriculumData {
  static const Map<int, Map<String, dynamic>> classCurriculum = {
    // PRIMARY SCHOOL (Class 1-5)
    1: {
      'name': 'Class 1',
      'stream': null,
      'subjects': [
        'English',
        'Hindi / Regional Language',
        'Mathematics',
        'Environmental Studies (EVS)',
        'General Knowledge',
        'Art & Craft',
        'Physical Education',
        'Moral Science / Value Education',
        'Computer Studies',
      ]
    },
    2: {
      'name': 'Class 2',
      'stream': null,
      'subjects': [
        'English',
        'Hindi / Regional Language',
        'Mathematics',
        'Environmental Studies (EVS)',
        'General Knowledge',
        'Art & Craft',
        'Physical Education',
        'Moral Science / Value Education',
        'Computer Studies',
      ]
    },
    3: {
      'name': 'Class 3',
      'stream': null,
      'subjects': [
        'English',
        'Hindi / Regional Language',
        'Mathematics',
        'Environmental Studies (EVS)',
        'General Knowledge',
        'Art & Craft',
        'Physical Education',
        'Moral Science / Value Education',
        'Computer Studies',
      ]
    },
    4: {
      'name': 'Class 4',
      'stream': null,
      'subjects': [
        'English',
        'Hindi / Regional Language',
        'Mathematics',
        'Environmental Studies (EVS)',
        'General Knowledge',
        'Art & Craft',
        'Physical Education',
        'Moral Science / Value Education',
        'Computer Studies',
      ]
    },
    5: {
      'name': 'Class 5',
      'stream': null,
      'subjects': [
        'English',
        'Hindi / Regional Language',
        'Mathematics',
        'Environmental Studies (EVS)',
        'General Knowledge',
        'Art & Craft',
        'Physical Education',
        'Moral Science / Value Education',
        'Computer Studies',
      ]
    },
    // MIDDLE SCHOOL (Class 6-8)
    6: {
      'name': 'Class 6',
      'stream': null,
      'subjects': [
        'English',
        'Hindi / Regional Language',
        'Mathematics',
        'Science',
        'History',
        'Geography',
        'Civics',
        'Sanskrit / Third Language',
        'Computer Science / ICT',
        'Art Education',
        'Physical Education',
        'Moral Science / Value Education',
      ]
    },
    7: {
      'name': 'Class 7',
      'stream': null,
      'subjects': [
        'English',
        'Hindi / Regional Language',
        'Mathematics',
        'Science',
        'Social Science',
        'History',
        'Geography',
        'Civics',
        'Sanskrit / Third Language',
        'Computer Science / ICT',
        'Art Education',
        'Physical Education',
        'Moral Science / Value Education',
      ]
    },
    8: {
      'name': 'Class 8',
      'stream': null,
      'subjects': [
        'English',
        'Hindi / Regional Language',
        'Mathematics',
        'Science',
        'Physics',
        'Chemistry',
        'Biology',
        'Social Science',
        'History',
        'Geography',
        'Civics',
        'Economics (introductory)',
        'Sanskrit / Third Language',
        'Computer Science / ICT',
        'Art Education',
        'Physical Education',
        'Moral Science / Value Education',
      ]
    },
    // SECONDARY SCHOOL (Class 9-10)
    9: {
      'name': 'Class 9',
      'stream': null,
      'coreSubjects': [
        'English',
        'Hindi / Regional Language',
        'Mathematics',
        'Science',
        'Physics',
        'Chemistry',
        'Biology',
        'Social Science',
        'History',
        'Geography',
        'Political Science',
        'Economics',
      ],
      'optionalSubjects': [
        'Sanskrit',
        'Computer Applications / Information Technology',
        'Artificial Intelligence',
        'Physical Education',
        'Home Science',
        'Music',
        'Painting',
        'Dance',
        'Health & Wellness',
      ],
      'skillSubjects': ['Vocational Subjects'],
    },
    10: {
      'name': 'Class 10',
      'stream': null,
      'coreSubjects': [
        'English',
        'Hindi / Regional Language',
        'Mathematics',
        'Science',
        'Physics',
        'Chemistry',
        'Biology',
        'Social Science',
        'History',
        'Geography',
        'Political Science',
        'Economics',
      ],
      'optionalSubjects': [
        'Sanskrit',
        'Computer Applications / Information Technology',
        'Artificial Intelligence',
        'Physical Education',
        'Home Science',
        'Music',
        'Painting',
        'Dance',
        'Health & Wellness',
      ],
      'skillSubjects': ['Vocational Subjects'],
    },
    // SENIOR SECONDARY SCHOOL - SCIENCE STREAM (Class 11-12)
    11: {
      'name': 'Class 11',
      'scienceStream': [
        'English',
        'Physics',
        'Chemistry',
        'Mathematics',
        'Biology',
        'Computer Science / Informatics Practices',
        'Physical Education',
        'Biotechnology',
        'Psychology',
        'Environmental Science',
        'Engineering Graphics',
        'Home Science',
      ],
      'commerceStream': [
        'English',
        'Accountancy',
        'Business Studies',
        'Economics',
        'Mathematics',
        'Informatics Practices',
        'Entrepreneurship',
        'Physical Education',
        'Legal Studies',
        'Applied Mathematics',
      ],
      'artsStream': [
        'English',
        'History',
        'Geography',
        'Political Science',
        'Economics',
        'Psychology',
        'Sociology',
        'Philosophy',
        'Physical Education',
        'Fine Arts',
        'Music',
        'Dance',
        'Legal Studies',
        'Home Science',
      ],
    },
    12: {
      'name': 'Class 12',
      'scienceStream': [
        'English',
        'Physics',
        'Chemistry',
        'Mathematics',
        'Biology',
        'Computer Science / Informatics Practices',
        'Physical Education',
        'Biotechnology',
        'Psychology',
        'Environmental Science',
        'Engineering Graphics',
        'Home Science',
      ],
      'commerceStream': [
        'English',
        'Accountancy',
        'Business Studies',
        'Economics',
        'Mathematics',
        'Informatics Practices',
        'Entrepreneurship',
        'Physical Education',
        'Legal Studies',
        'Applied Mathematics',
      ],
      'artsStream': [
        'English',
        'History',
        'Geography',
        'Political Science',
        'Economics',
        'Psychology',
        'Sociology',
        'Philosophy',
        'Physical Education',
        'Fine Arts',
        'Music',
        'Dance',
        'Legal Studies',
        'Home Science',
      ],
    },
  };

  /// Get subjects for a specific class
  static List<String> getSubjectsForClass(int classNumber) {
    if (classNumber < 1 || classNumber > 12) {
      return [];
    }

    final classData = classCurriculum[classNumber];
    if (classData == null) return [];

    // Handle streamed classes (11-12)
    if (classData.containsKey('scienceStream')) {
      return classData['scienceStream'] as List<String>;
    }

    // Handle classes with core and optional subjects (9-10)
    if (classData.containsKey('coreSubjects')) {
      final core = classData['coreSubjects'] as List<String>;
      final optional = classData['optionalSubjects'] as List<String>;
      return [...core, ...optional];
    }

    // Standard subjects list
    return (classData['subjects'] as List<dynamic>).cast<String>();
  }

  /// Get subjects for a specific class and stream (for class 11-12)
  static List<String> getSubjectsForClassAndStream(int classNumber, String stream) {
    if (classNumber < 11 || classNumber > 12) {
      return getSubjectsForClass(classNumber);
    }

    final classData = classCurriculum[classNumber];
    if (classData == null) return [];

    final streamKey = '${stream.toLowerCase()}Stream';
    if (classData.containsKey(streamKey)) {
      return (classData[streamKey] as List<String>);
    }

    return [];
  }

  /// Get all available streams for a class (11-12 only)
  static List<String> getStreamsForClass(int classNumber) {
    if (classNumber < 11 || classNumber > 12) {
      return [];
    }

    return ['Science', 'Commerce', 'Arts'];
  }

  /// Get subject icon based on subject name
  static IconData getSubjectIcon(String subject) {
    final lower = subject.toLowerCase();
    if (lower.contains('math')) return Icons.calculate;
    if (lower.contains('science') || lower.contains('physics') || lower.contains('chemistry') || lower.contains('biology')) {
      return Icons.science;
    }
    if (lower.contains('english')) return Icons.menu_book;
    if (lower.contains('hindi') || lower.contains('language')) return Icons.translate;
    if (lower.contains('social') || lower.contains('history') || lower.contains('geography') || lower.contains('civics') || lower.contains('political')) {
      return Icons.public;
    }
    if (lower.contains('evs') || lower.contains('environmental')) return Icons.eco;
    if (lower.contains('art') || lower.contains('painting') || lower.contains('fine arts')) {
      return Icons.palette;
    }
    if (lower.contains('music') || lower.contains('dance')) return Icons.music_note;
    if (lower.contains('computer') || lower.contains('ict') || lower.contains('informatics')) {
      return Icons.computer;
    }
    if (lower.contains('physical') || lower.contains('education')) return Icons.sports_basketball;
    if (lower.contains('economics')) return Icons.trending_up;
    if (lower.contains('accountancy') || lower.contains('business')) return Icons.business;
    if (lower.contains('engineering')) return Icons.engineering;
    if (lower.contains('psychology')) return Icons.psychology;
    if (lower.contains('philosophy')) return Icons.lightbulb;

    return Icons.subject;
  }

  /// Get subject color based on subject name
  static Color getSubjectColor(String subject) {
    final lower = subject.toLowerCase();
    if (lower.contains('math')) return Colors.blue;
    if (lower.contains('science') || lower.contains('physics') || lower.contains('chemistry') || lower.contains('biology')) {
      return Colors.green;
    }
    if (lower.contains('english')) return Colors.orange;
    if (lower.contains('hindi') || lower.contains('language')) return Colors.red;
    if (lower.contains('social') || lower.contains('history') || lower.contains('geography') || lower.contains('civics') || lower.contains('political')) {
      return Colors.purple;
    }
    if (lower.contains('evs') || lower.contains('environmental')) return Colors.teal;
    if (lower.contains('art') || lower.contains('painting') || lower.contains('fine arts')) {
      return Colors.pink;
    }
    if (lower.contains('music') || lower.contains('dance')) return Colors.indigo;
    if (lower.contains('computer') || lower.contains('ict') || lower.contains('informatics')) {
      return Colors.cyan;
    }
    if (lower.contains('physical') || lower.contains('education')) return Colors.amber;
    if (lower.contains('economics') || lower.contains('business')) return Colors.brown;
    if (lower.contains('engineering')) return Colors.grey;
    if (lower.contains('psychology')) return Colors.lightBlue;
    if (lower.contains('philosophy')) return Colors.deepPurple;

    return Colors.blueGrey;
  }

  /// Playlists for specific class subjects (Class 1 & 2)
  static const Map<int, Map<String, String>> _classPlaylists = {
    1: {
      'Mathematics': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhX6Q9',
      'English': 'https://www.youtube.com/playlist?list=PLW6ZJtqCeoWtstTEojp8vTuZ-SKYYdwCg',
      'Hindi / Regional Language': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhU6prff2aiSLBNq94zl6NOS',
      'Environmental Studies (EVS)': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhVkXKKGzdsFsyOO1g7tCc-E',
      'Computer Studies': 'https://www.youtube.com/playlist?list=PL598I6QjK6',
    },

    2: {
      // English (Mridang/Grammar)
      'English': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhW_7I0MIn_D-WpB-2-p_u6i',
      // Hindi (Sarangi/Rimjhim)
      'Hindi / Regional Language': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhWc8MTj3ij7kvByNXxUc6S8',
      // Mathematics (Joyful Math)
      'Mathematics': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhX6Q9v_36_S9S_E',
      // Environmental Studies (EVS)
      'Environmental Studies (EVS)': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhVkXKKGzdsFsyOO1g7tCc-E',
      // General Knowledge (GK)
      'General Knowledge': 'https://www.youtube.com/playlist?list=PLKDnLbfqbMcjNdE90Svs_NTRHpkoCKN3v',
      // Art & Craft
      'Art & Craft': 'https://www.youtube.com/playlist?list=PLw7RjvenAfpZMnF3zGvlOeIvzzC8-1AF3',
      // Physical Education
      'Physical Education': 'https://www.youtube.com/playlist?list=PL2hDszH4XLgW5pKU7Ec6nthuygZdteRiF',
      // Moral Science / Value Education
      'Moral Science / Value Education': 'https://www.youtube.com/playlist?list=PLW6ZJtqCeoWstnN04GvB9IeA4P_mY5_Vj',
      // Computer Studies
      'Computer Studies': 'https://www.youtube.com/playlist?list=PL598I6QjK6X',
    },

    3: {
      // English (Marigold / Santoor): 
   'English': "https://www.youtube.com/playlist?list=PLVLoWQFkZbhW3_zO2fS_K-fU_7_m6"
     // 2. Hindi (Rimjhim / Veena): 
   'Hindi / Regional Language': "https://www.youtube.com/playlist?list=PLVLoWQFkZbhU8N-m-V93vBfB93f0M"
     // 3. Mathematics (Math-Magic): 
   'Mathematics': "https://www.youtube.com/playlist?list=PLVLoWQFkZbhX1DUx2RPfhk-n8e3Y05mhr"
     // 4. Environmental Studies (EVS - Looking Around): 
   'Environmental Studies (EVS)': "https://www.youtube.com/playlist?list=PLVLoWQFkZbhW_7w_88E_gR-w3R1-k"
     // 5. General Knowledge (GK): 
   'General Knowledge': "https://www.youtube.com/playlist?list=PLnCcvHTIyuPS_OyjYefDCEazz7ROCGCjH"
     // 6. Art & Craft: 
   'Art & Craft': "https://www.youtube.com/playlist?list=PLw7RjvenAfpZMnF3zGvlOeIvzzC8-1AF3"
     // 7. Physical Education (K-3 Exercises): 
   'Physical Education': "https://www.youtube.com/playlist?list=PL2hDszH4XLgW5pKU7Ec6nthuygZdteRiF"
     // 8. Moral Science (Value Education): 
   'Moral Science / Value Education': "https://www.youtube.com/playlist?list=PLW6ZJtqCeoWstnN04GvB9IeA4P_mY5_Vj"
     // 9. Computer Studies (Basics): 
   'Computer Studies': "https://www.youtube.com/playlist?list=PL598I6QjK6X"
    },

    4:{
      //English (Marigold): 
   'English': "https://www.youtube.com/playlist?list=PLsqi2UgTnk1Q368bb3-dQJ7AiH4tOTUym"
      //Hindi (Rimjhim): 
   'Hindi / Regional Language': "https://www.youtube.com/playlist?list=PLVLoWQFkZbhVUqGmD0KcynhMmVBby1Yiz"
      //Mathematics (Math-Magic): 
   'Mathematics': "https://www.youtube.com/playlist?list=PLVLoWQFkZbhUq-9AmpEqnvqE6-L9ah7KP"
      //Environmental Studies (EVS - Looking Around): 
   'Environmental Studies (EVS)': "https://www.youtube.com/playlist?list=PLVLoWQFkZbhV1v1W8L_67_8_U9"
      //General Knowledge (GK): 
   'General Knowledge': "https://www.youtube.com/watch?v=8pNk_aTr_YM"
      //Art & Craft: 
   'Art & Craft': "https://www.youtube.com/watch?v=IpYzvjETzOU"
      //Physical Education (Yoga & Basic Motor Movements): 
   'Physical Education': "https://www.youtube.com/watch?v=nS0UCpCanrM"
      //Moral Science (Animated Values): 
   'Moral Science / Value Education': "https://www.youtube.com/playlist?list=PLW6ZJtqCeoWstnN04GvB9IeA4P_mY5_Vj"
      //Computer Studies: 
   'Computer Studies': "https://www.youtube.com/playlist?list=PLW6ZJtqCeoWt5Tdj6KsQeqmn7m2YRHhVN"

    }
  };

  /// Get playlist URL for a given class and subject (if available)
  static String? getPlaylistForClassSubject(int classNumber, String subject) {
    final map = _classPlaylists[classNumber];
    if (map == null) return null;

    // Try exact match
    if (map.containsKey(subject)) return map[subject];

    // Try lower-case contains matching (for alternative subject names)
    final lower = subject.toLowerCase();
    for (final entry in map.entries) {
      if (lower.contains(entry.key.toLowerCase())) return entry.value;
    }

    return null;
  }
}

