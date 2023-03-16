import 'package:algolia/algolia.dart';
import 'package:ticketing/home/models/event.dart';
import 'package:ticketing/search/constant.dart';

final Algolia algolia =
    Algolia.init(applicationId: ALGOLIA_APP_ID, apiKey: ALGOLIA_API_KEY);

class SearchRepository {
  Future<List<Event>> search(String queryString) async {
    AlgoliaQuery query =
        algolia.instance.index(ALGOLIA_INDEX_NAME).search(queryString);
    AlgoliaQuerySnapshot snapshot = await query.getObjects();
    return snapshot?.hits
        ?.map((e) => AlgoliaEvent.fromAlgoliaQuerySnapshot(e))
        ?.toList();
  }
}

extension AlgoliaEvent on Event {
  static Event fromAlgoliaQuerySnapshot(AlgoliaObjectSnapshot hit) {
    double price = 0;
    try {
      price = double.parse(hit.data['price']);
    } catch (ex) {}
    final loc = hit.data['location'] ?? const {};
    final location =
        EventLocation(name: loc['name'], lat: loc['lat'], lng: loc['lng']);
    final org = hit.data['organizer'] ?? const {};
    final organizer = EventOrganizer(
        name: org['name'],
        description: org['description'],
        facebook: org['facebook'],
        twitter: org['twitter'],
        phone: org['phone']);
    return Event(
      id: hit.objectID,
      title: hit.data['title'],
      price: price,
      description: hit.data['description'],
      imageUrl: hit.data['imageUrl'],
      categories: List<String>.from(hit.data['categories'] ?? []),
      location: location,
      organizer: organizer,
      eventStartDateTime: hit.data['eventStartDateTime'] != null
          ? DateTime.fromMicrosecondsSinceEpoch(hit.data['eventStartDateTime'])
          : null,
      eventEndDateTime: hit.data['eventEndDateTime'] != null
          ? DateTime.fromMicrosecondsSinceEpoch(hit.data['eventEndDateTime'])
          : null,
      createdAt: hit.data['createdAt'] != null
          ? DateTime.fromMicrosecondsSinceEpoch(hit.data['createdAt'])
          : null,
    );
  }
}
