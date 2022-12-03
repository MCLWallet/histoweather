//
//  DayWeatherPresistance.swift
//  HistoWeather
//
//  Created by Milos Stojiljkovic on 02.12.22.
//

import CoreData

/**
 # Persistence for `Friend`

 Offers different `NSFetchRequest` and functions to manipulate `Friend` in the database.
 */
struct DayWeatherPersistence {

    private let context = PersistenceController.shared.backgroundContext

    static func fetchFriends() -> NSFetchRequest<DayWeather> {
        print("fetching")
        let request = DayWeather.fetchRequest()
        request.sortDescriptors = []
        return request
    }

//    static func fetchFriend(identifier: UUID) -> NSFetchRequest<Friend> {
//        let request = Friend.fetchRequest()
//        request.predicate = NSPredicate(format: "%K == %@", #keyPath(Friend.identifier), identifier as CVarArg)
//        request.sortDescriptors = []
//        return request
//    }
//
    func addDayWeather(from weather: Weather) async {
        print("adding Weather")
        await context.perform {
            //            _ = apiFriends.map { Friend(apiFriend: $0, context: context) }
            _ = DayWeather(weather: weather, context: context) }
            context.saveContext()
        }
    }
//
//    func addFriend(from apiFriend: ApiFriend) async {
//        await context.perform {
//            _ = Friend(apiFriend: apiFriend, context: context)
//            context.saveContext()
//        }
//    }
//
//    func removeAllFriends() async throws {
//        try await context.perform {
//
//            try context.fetch(FriendPersistence.fetchFriends()).forEach {
//                context.delete($0)
//            }
//
//            context.saveContext()
//        }
//    }
//
//    func deleteFriend(friend: Friend) async {
//        await context.perform {
//            context.delete(context.object(with: friend.objectID))
//            context.saveContext()
//        }
//    }
//
//    func updateFriend(identifier: UUID,
//                      name: String,
//                      bestFriendScore: Int) async throws {
//
//        try await context.perform {
//            let friend = try context.fetch(FriendPersistence.fetchFriend(identifier: identifier)).first
//            friend?.name = name
//            friend?.bestFriendScore = Int16(bestFriendScore)
//            context.saveContext()
//        }
//    }
//}

extension DayWeather {

    convenience init(weather: Weather,
                     context: NSManagedObjectContext) {
        self.init(context: context)
        self.latitude = weather.latitude;
        self.longitude = weather.longitude;
        print("\(weather.longitude)dayweather init")
//        self.identifier = apiFriend.identifier
//        self.name = apiFriend.name
//        self.bestFriendScore = Int16(apiFriend.bestFriendScore)
    }
}
