//
//  ProspectsView-ViewModel.swift
//  HotProspects
//
//  Created by Grace couch on 27/11/2024.
//
import CodeScanner
import SwiftData
import SwiftUI
import NotificationCenter

@Observable
class ProspectsViewModel {
    enum Filter {
        case none, contacted, uncontacted
    }

    var isShowingScanner = false
    var selectedProspects = Set<Prospect>()
    var filter: Filter = .none

    var title: String {
        switch filter {
        case .none:
            "Everyone"
        case .contacted:
            "Contacted People"
        case .uncontacted:
            "Uncontacted People"
        }
    }

    init(isShowingScanner: Bool = false, selectedProspects: Set<Prospect> = Set<Prospect>()) {
        self.isShowingScanner = isShowingScanner
        self.selectedProspects = selectedProspects
    }

    func handleScan(result: Result<ScanResult, ScanError>, modelContext: ModelContext) {
        isShowingScanner = false

        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }

            let prospect = Prospect(name: details[0], emailAddress: details[1], isContacted: false)
            modelContext.insert(prospect)

        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }

    func delete(modelContext: ModelContext) {
        for prospect in selectedProspects {
            modelContext.delete(prospect)
        }
    }

    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()

        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default

            var dateComponent = DateComponents()
            dateComponent.hour = 9
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent,
                                                        repeats: false)

            let request = UNNotificationRequest(identifier: UUID().uuidString,
                                                content: content,
                                                trigger: trigger)
            center.add(request)
        }

        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else if let error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}
