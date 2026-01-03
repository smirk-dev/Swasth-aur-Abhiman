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
      'English': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhW3_zO2fS_K-fU_7_m6',
      'Hindi / Regional Language': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhU8N-m-V93vBfB93f0M',
      'Mathematics': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhX1DUx2RPfhk-n8e3Y05mhr',
      'Environmental Studies (EVS)': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhW_7w_88E_gR-w3R1-k',
      'General Knowledge': 'https://www.youtube.com/playlist?list=PLnCcvHTIyuPS_OyjYefDCEazz7ROCGCjH',
      'Art & Craft': 'https://www.youtube.com/playlist?list=PLw7RjvenAfpZMnF3zGvlOeIvzzC8-1AF3',
      'Physical Education': 'https://www.youtube.com/playlist?list=PL2hDszH4XLgW5pKU7Ec6nthuygZdteRiF',
      'Moral Science / Value Education': 'https://www.youtube.com/playlist?list=PLW6ZJtqCeoWstnN04GvB9IeA4P_mY5_Vj',
      'Computer Studies': 'https://www.youtube.com/playlist?list=PL598I6QjK6X',
    },

    4: {
      'English': 'https://www.youtube.com/playlist?list=PLsqi2UgTnk1Q368bb3-dQJ7AiH4tOTUym',
      'Hindi / Regional Language': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhVUqGmD0KcynhMmVBby1Yiz',
      'Mathematics': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhUq-9AmpEqnvqE6-L9ah7KP',
      'Environmental Studies (EVS)': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhV1v1W8L_67_8_U9',
      'General Knowledge': 'https://www.youtube.com/watch?v=8pNk_aTr_YM',
      'Art & Craft': 'https://www.youtube.com/watch?v=IpYzvjETzOU',
      'Physical Education': 'https://www.youtube.com/watch?v=nS0UCpCanrM',
      'Moral Science / Value Education': 'https://www.youtube.com/playlist?list=PLW6ZJtqCeoWstnN04GvB9IeA4P_mY5_Vj',
      'Computer Studies': 'https://www.youtube.com/playlist?list=PLW6ZJtqCeoWt5Tdj6KsQeqmn7m2YRHhVN',
    },

    5: {
      'English': 'http://www.youtube.com/playlist?list=PLVLoWQFkZbhUOY_a1-hgpQFc22MZ8Qqo1',
      'Hindi / Regional Language': 'http://www.youtube.com/playlist?list=PLVLoWQFkZbhXum5pD97IJOVSSFzNRLPax',
      'Mathematics': 'http://www.youtube.com/playlist?list=PLVLoWQFkZbhV0kPS6-8eWJw2GuBSSkjYD',
      'Environmental Studies (EVS)': 'http://www.youtube.com/playlist?list=PLVLoWQFkZbhVxyA3K-Ru0kuVTqhgqOJmO',
      'General Knowledge': 'http://www.youtube.com/playlist?list=PLVLoWQFkZbhUFLnB3mOnvSrmUe5xSKxe9',
      'Art & Craft': 'https://www.youtube.com/playlist?list=PLw7RjvenAfpZMnF3zGvlOeIvzzC8-1AF3',
      'Physical Education': 'https://www.youtube.com/playlist?list=PL2hDszH4XLgW5pKU7Ec6nthuygZdteRiF',
      'Moral Science / Value Education': 'https://www.youtube.com/playlist?list=PLW6ZJtqCeoWstnN04GvB9IeA4P_mY5_Vj',
      'Computer Studies': 'http://www.youtube.com/playlist?list=PLVLoWQFkZbhX7KHCxcjCnC5LtpRojrsHq',
    },

    6: {
      'English': 'https://www.youtube.com/results?search_query=class+6+english+playlist',
      'Hindi / Regional Language': 'https://www.youtube.com/results?search_query=class+6+hindi+playlist',
      'Mathematics': 'https://www.youtube.com/results?search_query=class+6+mathematics+playlist',
      'Science': 'https://www.youtube.com/results?search_query=class+6+science+playlist',
      'History': 'https://www.youtube.com/results?search_query=class+6+history+playlist',
      'Geography': 'https://www.youtube.com/results?search_query=class+6+geography+playlist',
      'Civics': 'https://www.youtube.com/results?search_query=class+6+civics+playlist',
      'Sanskrit / Third Language': 'https://www.youtube.com/results?search_query=class+6+sanskrit+playlist',
      'Computer Science / ICT': 'https://www.youtube.com/results?search_query=class+6+computer+science+playlist',
      'Art Education': 'https://www.youtube.com/results?search_query=class+6+art+education+playlist',
      'Physical Education': 'https://www.youtube.com/results?search_query=class+6+physical+education+playlist',
      'Moral Science / Value Education': 'https://www.youtube.com/results?search_query=class+6+moral+science+playlist',
    },

    7: {
      'English': 'https://www.youtube.com/results?search_query=class+7+english+playlist',
      'Hindi / Regional Language': 'https://www.youtube.com/results?search_query=class+7+hindi+playlist',
      'Mathematics': 'https://www.youtube.com/results?search_query=class+7+mathematics+playlist',
      'Science': 'https://www.youtube.com/results?search_query=class+7+science+playlist',
      'History': 'https://www.youtube.com/results?search_query=class+7+history+playlist',
      'Geography': 'https://www.youtube.com/results?search_query=class+7+geography+playlist',
      'Civics': 'https://www.youtube.com/results?search_query=class+7+civics+playlist',
      'Sanskrit / Third Language': 'https://www.youtube.com/results?search_query=class+7+sanskrit+playlist',
      'Computer Science / ICT': 'https://www.youtube.com/results?search_query=class+7+computer+science+playlist',
      'Art Education': 'https://www.youtube.com/results?search_query=class+7+art+education+playlist',
      'Physical Education': 'https://www.youtube.com/results?search_query=class+7+physical+education+playlist',
      'Moral Science / Value Education': 'https://www.youtube.com/results?search_query=class+7+moral+science+playlist',
    },

    8: {
      'English': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhW_W_7o6oO-r9V3-U',
      'Hindi / Regional Language': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhU_pLe6BbM1dOD2wcfHiuXC',
      'Mathematics': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhX6Q9v_36_S9S_E',
      'Science': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhVxyA3K-Ru0kuVTqhgqOJmO',
      'Physics': 'https://www.youtube.com/playlist?list=PLrtKTzggq268L-nJp75KkK-UfV5Lg',
      'Chemistry': 'https://www.youtube.com/playlist?list=PLrtKTzggq269N-ZzYj7Y-MvJ3V0l',
      'Biology': 'https://www.youtube.com/playlist?list=PLrtKTzggq268R_m_8f228oX0XWjL6Jc5n',
      'Social Science': 'https://www.youtube.com/playlist?list=PLz18M0aaL7ANDA7bZ46PW7d3wJkylJP3-',
      'History': 'https://www.youtube.com/playlist?list=PLz18M0aaL7ANBCu8UzGfpUXw6CDc39amG',
      'Geography': 'https://www.youtube.com/playlist?list=PLrtKTzggq2695v9m6_YxK3t5_d99CisqL',
      'Civics': 'https://www.youtube.com/playlist?list=PLUGFATmVBid8sWYKsullvu0bOVk05y37i',
      'Economics (introductory)': 'https://www.youtube.com/playlist?list=PLrtKTzggq268vN0I-n0P9DCHq0p_f4S4G',
      'Sanskrit / Third Language': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhWKcVPBop5u7gDhlPUj33v9',
      'Computer Science / ICT': 'https://www.youtube.com/playlist?list=PLxlGPLijthUKhJr0WXp_JFXcfYfdNkYDX',
      'Art Education': 'https://www.youtube.com/playlist?list=PL2hDszH4XLgW5pKU7Ec6nthuygZdteRiF',
      'Physical Education': 'https://www.youtube.com/playlist?list=PL2hDszH4XLgW5pKU7Ec6nthuygZdteRiF',
      'Moral Science / Value Education': 'https://www.youtube.com/playlist?list=PLW6ZJtqCeoWstnN04GvB9IeA4P_mY5_Vj',
    },

    9: {
      'English': 'https://www.youtube.com/playlist?list=PLrtKTzggq26_91FEDsuxhwWZYztUDnU7',
      'Hindi / Regional Language': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhXum5pD97IJOVSSFzNRLPax',
      'Mathematics': 'https://www.youtube.com/playlist?list=PLrtKTzggq268R_m_8f228oX0XWjL6Jc5n',
      'Science': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhXmX6v6_5iJ3q2f0J2_mD8S',
      'Physics': 'https://www.youtube.com/playlist?list=PLUGFATmVBid9qY1ZqX-zU_FpL-oA008hX',
      'Chemistry': 'https://www.youtube.com/playlist?list=PLUGFATmVBid8D4j-WvRIn_70HlM4xWd_Q',
      'Biology': 'https://www.youtube.com/playlist?list=PLUGFATmVBid9I08W9_vU6N0K-XGvL6i1P',
      'Social Science': 'https://www.youtube.com/playlist?list=PLrtKTzggq268Sh5ID6uF4irYFTfyChiKy',
      'History': 'https://www.youtube.com/playlist?list=PLrtKTzggq26_E6qUvD0D6_pW76_y_K4l8',
      'Geography': 'https://www.youtube.com/playlist?list=PLrtKTzggq2695v9m6_YxK3t5_d99CisqL',
      'Political Science': 'https://www.youtube.com/playlist?list=PLrtKTzggq26-I4yLwV-Kq_gO_zbeuYmE9',
      'Economics': 'https://www.youtube.com/playlist?list=PLrtKTzggq268vN0I-n0P9DCHq0p_f4S4G',
    },

    10: {
      'English': 'https://www.youtube.com/playlist?list=PLrtKTzggq26_y8f8XaeZRL7VnS5v_mBfG',
      'Hindi / Regional Language': 'https://www.youtube.com/playlist?list=PLz18M0aaL7AMn5y8rP-X0pY1-X8k-N3p7',
      'Mathematics': 'https://www.youtube.com/playlist?list=PLrtKTzggq268R_m_8f228oX0XWjL6Jc5n',
      'Science': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhXmX6v6_5iJ3q2f0J2_mD8S',
      'Physics': 'https://www.youtube.com/playlist?list=PLrtKTzggq268L-nJp75KkK-UfV5Lg',
      'Chemistry': 'https://www.youtube.com/playlist?list=PLrtKTzggq269N-ZzYj7Y-MvJ3V0l',
      'Biology': 'https://www.youtube.com/playlist?list=PLUGFATmVBid9I08W9_vU6N0K-XGvL6i1P',
      'Social Science': 'https://www.youtube.com/playlist?list=PLrtKTzggq268Sh5ID6uF4irYFTfyChiKy',
      'History': 'https://www.youtube.com/playlist?list=PLrtKTzggq26_E6qUvD0D6_pW76_y_K4l8',
      'Geography': 'https://www.youtube.com/playlist?list=PLrtKTzggq2695v9m6_YxK3t5_d99CisqL',
      'Political Science': 'https://www.youtube.com/playlist?list=PLrtKTzggq26-I4yLwV-Kq_gO_zbeuYmE9',
      'Economics': 'https://www.youtube.com/playlist?list=PLrtKTzggq268vN0I-n0P9DCHq0p_f4S4G',
    },

    11: {
      // Science Stream
      'English': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhVWaTIGB27JMv0btP9bbJb2',
      'Physics': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhX9i59Uq4Uzt82mNAl5lkj8',
      'Chemistry': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhXlv6f9y_XUpWqI',
      'Mathematics': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhV0kPS6-8eWJw2GuBSSkjYD',
      'Biology': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhU_pLe6BbM1dOD2wcfHiuXC',
      'Computer Science': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhVVFPPzL8qk1YdcS35-l5u_',

      // Commerce Stream
      'Accountancy': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhVnojZEhD6XHce88AV2Rs13',
      'Business Studies': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhUX5KerhrM8O65KnBcvJKes',
      'Economics': 'https://www.youtube.com/playlist?list=PLrtKTzggq268vN0I-n0P9DCHq0p_f4S4G',
      'Informatics Practices': 'https://www.youtube.com/playlist?list=PLdFqKUpCmQ8pNbhKf84EajB5mcU7P9jvH',

      // Arts Stream
      'History': 'https://www.youtube.com/playlist?list=PLGrgIWihe6WaeoVpgVOKJcVuwO22nCf1v',
      'Geography': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhV_m_eYhYyS6S9M',
      'Political Science': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhXum5pD97IJOVSSFzNRLPax',
      'Psychology': 'https://www.youtube.com/playlist?list=PLPMPYhLl4LyoaaOZs4R0c8yoceHX1Blb5',
      'Sociology': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhVxyA3K-Ru0kuVTqhgqOJmO',

      // Additional Subjects
      'Physical Education': 'https://www.youtube.com/playlist?list=PL2hDszH4XLgW5pKU7Ec6nthuygZdteRiF',
      'Fine Arts': 'https://www.youtube.com/playlist?list=PLW6ZJtqCeoWstnN04GvB9IeA4P_mY5_Vj',
    },

    12: {
      // Science Stream
      'English': 'https://www.youtube.com/playlist?list=PL3s-GF0G43lRqpoBOB3WEp5A_C2V6OcFq',
      'Physics': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhU6U0BhqGieiARjUYmyoa8p',
      'Chemistry': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhVdStvLVoS3kU7RBaJR4JTR',
      'Mathematics': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhW-2v8-Yidq3H6X7i99-m_A',
      'Biology': 'https://www.youtube.com/playlist?list=PLPsaj0rTW2JOI_34IHOqv3Pi7dGoBZEj5',
      'Computer Science': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhVVFPPzL8qk1YdcS35-l5u_',

      // Commerce Stream
      'Accountancy': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhWtF1CTYtmePxD-MvMW_158',
      'Business Studies': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhWE-_sajacSj-q0dlH6U6cc',
      'Economics': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhU-U2_929fUu6Kog55K-mSj',
      'Informatics Practices': 'https://www.youtube.com/playlist?list=PLdFqKUpCmQ8pNbhKf84EajB5mcU7P9jvH',

      // Arts Stream
      'History': 'https://www.youtube.com/playlist?list=PL5Z7ZVj5DNVf6jt-TSK3n8BW1M23nJ1jA',
      'Geography': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhW6m6_uH-RreM7VbI',
      'Political Science': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhXum5pD97IJOVSSFzNRLPax',
      'Sociology': 'https://www.youtube.com/playlist?list=PLVLoWQFkZbhVxyA3K-Ru0kuVTqhgqOJmO',

      // Common Electives
      'Physical Education': 'https://www.youtube.com/playlist?list=PL2hDszH4XLgW5pKU7Ec6nthuygZdteRiF',
      'Psychology': 'https://www.youtube.com/playlist?list=PLPMPYhLl4LyoaaOZs4R0c8yoceHX1Blb5',
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

