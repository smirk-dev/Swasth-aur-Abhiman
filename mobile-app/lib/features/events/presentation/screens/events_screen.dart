import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/event_models.dart';
import '../../providers/event_provider.dart';
import '../widgets/event_card.dart';
import '../widgets/event_filters.dart';
import '../widgets/event_detail_screen.dart';

class EventsScreen extends ConsumerStatefulWidget {
  const EventsScreen({super.key});

  @override
  ConsumerState<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends ConsumerState<EventsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(eventProvider.notifier).loadEvents();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final eventState = ref.watch(eventProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Events'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilters(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: const Icon(Icons.upcoming),
              text: 'Upcoming (${eventState.upcomingEvents.length})',
            ),
            Tab(
              icon: const Icon(Icons.history),
              text: 'Past (${eventState.pastEvents.length})',
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Active Filters Display
          if (eventState.selectedBlock != null ||
              eventState.selectedEventType != null)
            _buildActiveFilters(eventState),

          // Events List
          Expanded(
            child: eventState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildEventsList(eventState.upcomingEvents, isUpcoming: true),
                      _buildEventsList(eventState.pastEvents, isUpcoming: false),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilters(EventState state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      child: Row(
        children: [
          const Text('Filters: ', style: TextStyle(fontWeight: FontWeight.w500)),
          if (state.selectedBlock != null)
            Chip(
              label: Text(state.selectedBlock!),
              onDeleted: () => ref.read(eventProvider.notifier).filterByBlock(null),
              deleteIconColor: Colors.grey,
              visualDensity: VisualDensity.compact,
            ),
          const SizedBox(width: 8),
          if (state.selectedEventType != null)
            Chip(
              label: Text(EventType.getDisplayName(state.selectedEventType!)),
              onDeleted: () =>
                  ref.read(eventProvider.notifier).filterByEventType(null),
              deleteIconColor: Colors.grey,
              visualDensity: VisualDensity.compact,
            ),
          const Spacer(),
          TextButton(
            onPressed: () => ref.read(eventProvider.notifier).clearFilters(),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList(List<Event> events, {required bool isUpcoming}) {
    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isUpcoming ? Icons.event_available : Icons.event_busy,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              isUpcoming
                  ? 'No upcoming events'
                  : 'No past events',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              isUpcoming
                  ? 'Check back later for new events in your area'
                  : 'Past events will appear here',
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(eventProvider.notifier).loadEvents(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return EventCard(
            event: event,
            onTap: () => _openEventDetails(event),
          );
        },
      ),
    );
  }

  void _showFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => EventFilters(
        selectedBlock: ref.read(eventProvider).selectedBlock,
        selectedEventType: ref.read(eventProvider).selectedEventType,
        onBlockChanged: (block) {
          ref.read(eventProvider.notifier).filterByBlock(block);
          Navigator.pop(context);
        },
        onEventTypeChanged: (type) {
          ref.read(eventProvider.notifier).filterByEventType(type);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _openEventDetails(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventDetailScreen(event: event),
      ),
    );
  }
}
