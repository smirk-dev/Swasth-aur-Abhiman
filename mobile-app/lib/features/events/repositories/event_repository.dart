import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../../core/services/api_service.dart';
import '../models/event_models.dart';

class EventRepository {
  final ApiService _apiService;
  final Box<Event>? _eventsBox;

  EventRepository(this._apiService, this._eventsBox);

  Future<List<Event>> getEvents({String? block, String? eventType}) async {
    try {
      final queryParams = <String, String>{};
      if (block != null) queryParams['block'] = block;
      if (eventType != null) queryParams['eventType'] = eventType;

      final response = await _apiService.get(
        '/events',
        queryParameters: queryParams,
      );

      final events = (response.data as List)
          .map((e) => Event.fromJson(e))
          .toList();

      // Cache events locally
      if (_eventsBox != null) {
        for (final event in events) {
          await _eventsBox!.put(event.id, event);
        }
      }

      return events;
    } catch (e) {
      // Return cached data on error
      if (_eventsBox != null) {
        final cachedEvents = _eventsBox!.values.toList();
        if (block != null) {
          return cachedEvents.where((e) => e.block == block).toList();
        }
        return cachedEvents;
      }
      return [];
    }
  }

  Future<List<Event>> getUpcomingEvents({String? block}) async {
    final events = await getEvents(block: block);
    return events.where((e) => e.isUpcoming || e.isToday).toList()
      ..sort((a, b) => a.eventDate.compareTo(b.eventDate));
  }

  Future<List<Event>> getPastEvents({String? block}) async {
    final events = await getEvents(block: block);
    return events.where((e) => !e.isUpcoming && !e.isToday).toList()
      ..sort((a, b) => b.eventDate.compareTo(a.eventDate));
  }

  Future<Event?> getEventById(String id) async {
    try {
      final response = await _apiService.get('/events/$id');
      return Event.fromJson(response.data);
    } catch (e) {
      // Try from cache
      return _eventsBox?.get(id);
    }
  }

  // For Admin: Create event
  Future<Event> createEvent(Event event) async {
    final response = await _apiService.post(
      '/events',
      data: event.toJson(),
    );
    return Event.fromJson(response.data);
  }

  // For Admin: Update event
  Future<Event> updateEvent(String id, Event event) async {
    final response = await _apiService.put(
      '/events/$id',
      data: event.toJson(),
    );
    return Event.fromJson(response.data);
  }

  // For Admin: Delete event
  Future<void> deleteEvent(String id) async {
    await _apiService.delete('/events/$id');
    await _eventsBox?.delete(id);
  }
}

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  // Note: In production, inject Hive box properly
  return EventRepository(apiService, null);
});
