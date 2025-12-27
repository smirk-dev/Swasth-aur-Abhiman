import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event_models.dart';
import '../repositories/event_repository.dart';

class EventState {
  final List<Event> events;
  final List<Event> upcomingEvents;
  final List<Event> pastEvents;
  final bool isLoading;
  final String? error;
  final String? selectedBlock;
  final String? selectedEventType;

  const EventState({
    this.events = const [],
    this.upcomingEvents = const [],
    this.pastEvents = const [],
    this.isLoading = false,
    this.error,
    this.selectedBlock,
    this.selectedEventType,
  });

  EventState copyWith({
    List<Event>? events,
    List<Event>? upcomingEvents,
    List<Event>? pastEvents,
    bool? isLoading,
    String? error,
    String? selectedBlock,
    String? selectedEventType,
  }) {
    return EventState(
      events: events ?? this.events,
      upcomingEvents: upcomingEvents ?? this.upcomingEvents,
      pastEvents: pastEvents ?? this.pastEvents,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedBlock: selectedBlock ?? this.selectedBlock,
      selectedEventType: selectedEventType ?? this.selectedEventType,
    );
  }
}

class EventNotifier extends StateNotifier<EventState> {
  final EventRepository _repository;

  EventNotifier(this._repository) : super(const EventState());

  Future<void> loadEvents({String? block, String? eventType}) async {
    state = state.copyWith(
      isLoading: true,
      selectedBlock: block,
      selectedEventType: eventType,
    );

    try {
      final upcoming = await _repository.getUpcomingEvents(block: block);
      final past = await _repository.getPastEvents(block: block);
      
      // Apply event type filter if specified
      final filteredUpcoming = eventType != null
          ? upcoming.where((e) => e.eventType == eventType).toList()
          : upcoming;
      final filteredPast = eventType != null
          ? past.where((e) => e.eventType == eventType).toList()
          : past;

      state = state.copyWith(
        upcomingEvents: filteredUpcoming,
        pastEvents: filteredPast,
        events: [...filteredUpcoming, ...filteredPast],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void filterByBlock(String? block) {
    loadEvents(block: block, eventType: state.selectedEventType);
  }

  void filterByEventType(String? eventType) {
    loadEvents(block: state.selectedBlock, eventType: eventType);
  }

  void clearFilters() {
    loadEvents();
  }

  Future<Event?> getEventDetails(String eventId) async {
    return await _repository.getEventById(eventId);
  }
}

final eventProvider = StateNotifierProvider<EventNotifier, EventState>((ref) {
  final repository = ref.watch(eventRepositoryProvider);
  return EventNotifier(repository);
});
