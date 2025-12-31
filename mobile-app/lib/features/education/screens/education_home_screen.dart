import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/api_service.dart';
import '../../../widgets/cards/education_card.dart';
import '../../../core/models/video.dart';
import 'video_player_screen.dart';

class EducationHomeScreen extends ConsumerStatefulWidget {
  const EducationHomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EducationHomeScreenState();
}

class _EducationHomeScreenState extends ConsumerState<EducationHomeScreen> {
  int selectedClass = 10;
  String selectedSubject = 'All';
  String searchQuery = '';
  List<Video> videos = [];
  bool loading = false;

  final subjects = ['All', 'Mathematics', 'Science', 'English', 'Hindi', 'Social Studies'];

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    setState(() => loading = true);
    try {
      final api = ref.read(apiServiceProvider);
      final fetched = await api.getVideosByClass(selectedClass);
      setState(() => videos = fetched);
    } catch (e) {
      // handle
    } finally {
      setState(() => loading = false);
    }
  }

  void _onClassSelected(int classNumber) {
    setState(() => selectedClass = classNumber);
    _loadVideos();
  }

  void _onSubjectSelected(String subject) async {
    setState(() => selectedSubject = subject);
    setState(() => loading = true);
    try {
      final api = ref.read(apiServiceProvider);
      if (subject == 'All') {
        final fetched = await api.getVideosByClass(selectedClass);
        setState(() => videos = fetched);
      } else {
        final fetched = await api.getVideosByClassAndSubject(selectedClass, subject);
        setState(() => videos = fetched);
      }
    } catch (e) {
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = videos.where((v) => v.title.toLowerCase().contains(searchQuery.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Education')),
      body: Column(
        children: [
          // Class selector
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 12,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemBuilder: (context, index) {
                final cnum = index + 1;
                final selected = cnum == selectedClass;
                return GestureDetector(
                  onTap: () => _onClassSelected(cnum),
                  child: Container(
                    margin: EdgeInsets.only(right: 8),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? Theme.of(context).primaryColor : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(child: Text('Class $cnum', style: TextStyle(color: selected ? Colors.white : Colors.black))),
                  ),
                );
              },
            ),
          ),

          // Subject filter
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final s = subjects[index];
                final selected = s == selectedSubject;
                return GestureDetector(
                  onTap: () => _onSubjectSelected(s),
                  child: Container(
                    margin: EdgeInsets.only(right: 8),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? Theme.of(context).primaryColor : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(s, style: TextStyle(color: selected ? Colors.white : Colors.black)),
                  ),
                );
              },
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: TextField(
              decoration: InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search videos...'),
              onChanged: (v) => setState(() => searchQuery = v),
            ),
          ),

          // Content
          Expanded(
            child: loading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: EdgeInsets.all(12),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final v = filtered[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: EducationCard(
                          title: v.title,
                          subtitle: '${v.ageGroup} • ${v.subject}',
                          thumbnailUrl: v.thumbnailUrl,
                          durationSeconds: v.durationSeconds,
                          rating: v.rating,
                          isFree: v.isFree,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => VideoPlayerScreen(video: v)),
                            );
                          },
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
