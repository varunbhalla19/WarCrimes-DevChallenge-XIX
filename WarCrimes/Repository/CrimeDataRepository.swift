//
//  CrimeDataRepository.swift
//  WarCrimes
//

import Foundation

protocol Repository {
    var names: [String: Names]! { get }
    var crimeEvents: Reactive<[CrimeEvent]> { get }
}

class CrimeDataRepository: Repository {
    
    private let namesFileName: String
    private let eventsFileName: String
    
    var names: [String: Names]!
    var crimeEvents: Reactive<[CrimeEvent]> = .init([])

    init(name: String = "names", event: String = "event") {

        self.namesFileName = name
        self.eventsFileName = event

        names = fetchNames()
        fetchEvent { crimeEvents in
            var final = [CrimeEvent].init()
            for var event in crimeEvents.allEvents {
                if let key = event.event.first, let str = self.names["en"]!.event[key], str.count > 0 {
                    event.name = key
                    final.append(event)
                }
            }
            self.crimeEvents.value = final
        }
    }
    
    private func fetchNames() -> [String: Names] {
        if let url = Bundle.main.url(forResource: namesFileName, withExtension: "json"),
            let data = try? Data.init(contentsOf: url) {
            do {
                let decoder = JSONDecoder.init()
                let result = try decoder.decode([String: Names].self, from: data)
                return result
            } catch let er as NSError {
                print(er.userInfo)
                fatalError("couldn't fetch names")
            }
        }
        fatalError("couldn't fetch names")
    }

    
    private func fetchEvent( completion: @escaping (AllEvents) -> () ) {
        if let url = Bundle.main.url(forResource: eventsFileName, withExtension: "json") {
            DispatchQueue.global(qos: .userInitiated).async {
                if let data = try? Data.init(contentsOf: url) {
                    let decoder = JSONDecoder.init()
                    decoder.dateDecodingStrategy = .formatted(Formatter.customFormatter)
                    do {
                        let tempresult = try decoder.decode(AllEvents.self, from: data)
                        completion(tempresult)
                    } catch let er as NSError {
                        print(er.userInfo)
                    }
                }
            }
        }
    }

}
