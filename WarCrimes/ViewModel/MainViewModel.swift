//
//  MainViewModel.swift
//  WarCrimes
//

import UIKit

class MainViewModel {
    
    private var allEvents: Reactive<[CrimeEvent]> = Reactive.init([])
    var events: Reactive<[CrimeEvent]> = Reactive.init([])
    
    private var allNames: [String: Names]!
    var names: Names!

    private var selectedLanguage: Languages = .en
    
    var eventsStatistics: Reactive<[String: [CrimeEvent]]> = .init([:])
    var qualificationStatistics: Reactive<[String: [CrimeEvent]]> = .init([:])
    var statusStatistics: Reactive<[String: [CrimeEvent]]> = .init([:])
    var affectedStatistics: Reactive<[String: [CrimeEvent]]> = .init([:])
    
    var dataLoaded: Reactive<Bool> = .init(false)
    
    // MapConfig Settings
    var mapSettings: Reactive<MapSettings> = .init(.standard)
    var fromDate: Reactive<Date?> = .init(nil)
    var toDate: Reactive<Date?> = .init(nil)
    
    init(repo: Repository) {
        allNames = repo.names
        names = allNames[selectedLanguage.rawValue]!
        
        repo.crimeEvents.bind(listener: { events in
            self.allEvents.value = events
            self.events.value = events
        })
        
        allEvents.bind { events in
            self.dataLoaded.value = !events.isEmpty
            self.generateEventStats()
        }

        fromDate.bind { date in
            guard let date = date else { return }
            self.events.value = self.allEvents.value.filter { crimeEvent in
                if let till = self.toDate.value {
                    return (crimeEvent.from >= date) && (crimeEvent.till <= till)
                }
                return (crimeEvent.from >= date)
            }
        }
        
        toDate.bind { date in
            guard let date = date else { return }
            self.events.value = self.allEvents.value.filter { crimeEvent in
                if let from = self.fromDate.value {
                    return (crimeEvent.from >= from) && (crimeEvent.till <= date)
                }
                return crimeEvent.till <= date
            }
        }
        
    }
    
    // MARK: Compute Event Stats-
    /*
     For each category: (Crime, Status, Qualifications, Affected) - The Stats are in form of [key: [CrimeEvent]]
     All stats are generated from a single loop.
     */
    func generateEventStats() {
        var result = [String: [CrimeEvent]].init()
        var qualificationResult = [String: [CrimeEvent]].init()
        var statusResult = [String: [CrimeEvent]].init()
        var affectedResult = [String: [CrimeEvent]].init()
        
        allEvents.value.forEach { crimeEvent in
                        
            crimeEvent.event.forEach { event in
                guard let str = self.names.event[event], !str.isEmpty else { return }
                if result[event] == nil {
                    result[event] = [crimeEvent]
                } else {
                    result[event]?.append(crimeEvent)
                }
            }
            
            crimeEvent.qualification?.forEach { qualification in
                guard let str = self.names.qualification[qualification], !str.isEmpty else { return }
                if qualificationResult[qualification] == nil {
                    qualificationResult[qualification] = [crimeEvent]
                } else {
                    qualificationResult[qualification]?.append(crimeEvent)
                }
            }
            
            crimeEvent.objectStatus?.forEach { status in
                guard let str = self.names.object_status[status], !str.isEmpty else { return }
                if statusResult[status] == nil {
                    statusResult[status] = [crimeEvent]
                } else {
                    statusResult[status]?.append(crimeEvent)
                }
            }
            
            crimeEvent.affectedType?.forEach { affected in
                guard let str = self.names.affected_type[affected], !str.isEmpty else { return }
                if affectedResult[affected] == nil {
                    affectedResult[affected] = [crimeEvent]
                } else {
                    affectedResult[affected]?.append(crimeEvent)
                }
            }
            
        }

        qualificationStatistics.value = qualificationResult
        eventsStatistics.value = result
        statusStatistics.value = statusResult
        affectedStatistics.value = affectedResult
    }
    
    func languageChanged(to value: Languages) {
        selectedLanguage = value
        names = allNames[selectedLanguage.rawValue]!
        events.invokeAllListeners()
    }

}

// MARK: ChartStats
extension MainViewModel: ChartStats {
    var eventStats: [ChartData] {
        eventsStatistics.value.map({ (key: String, value: [CrimeEvent]) in
            ChartData(label: names.event[key]!, value: value.count, bgColor: ColorSet.colorsForEvents[key]!)
        })
    }
    
    var qualificationStats: [ChartData] {
        qualificationStatistics.value.map({ (key: String, value: [CrimeEvent]) in
            ChartData(label: names.qualification[key]!, value: value.count, bgColor: ColorSet.colorsForQualifications[key]!)
        })
    }
    
    var statusStats: [ChartData] {
        statusStatistics.value.map({ (key: String, value: [CrimeEvent]) in
            ChartData(label: names.object_status[key]!, value: value.count, bgColor: ColorSet.colorsForStatus[key]!)
        })
    }
    
    var affectedStats: [ChartData] {
        affectedStatistics.value.map { (key: String, value: [CrimeEvent]) in
            ChartData(label: names.affected_type[key]!, value: value.count, bgColor: ColorSet.colorsForAffected[key]!)
        }
    }
}

// MARK: MapConfig
extension MainViewModel: MapConfig {}
