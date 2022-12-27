//
//  SettingsViewController.swift
//  WarCrimes
//

import UIKit


class SettingsViewController: UIViewController {
    
    var viewModel: MapConfig!
    
    
    @IBOutlet weak var fromDate: UIDatePicker!
    @IBOutlet weak var tillDate: UIDatePicker!
    
    
    class func make(with viewModel: MainViewModel) -> SettingsViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        vc.viewModel = viewModel
        return vc
    }
    
    @IBAction func mapTypeChanged(_ sender: UISegmentedControl) {
        viewModel.mapSettings.value = MapSettings.init(rawValue: sender.selectedSegmentIndex) ?? .standard
    }
    
    
    @IBAction func didChangeFromDate(_ sender: UIDatePicker) {
        viewModel.fromDate.value = sender.date
        tillDate.minimumDate = sender.date
    }
    
    @IBAction func didChangeTillDate(_ sender: UIDatePicker) {
        viewModel.toDate.value = sender.date
        fromDate.maximumDate = sender.date
    }
    
    var navBtn: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Settings"

        
        let menuItems = Languages.allCases.map { lang in
            UIAction.init(title: lang.rawValue, state: .on) { _ in self.langSelected(lang) }
        }
        let menu = UIMenu(title: "Select Language", options: .singleSelection, children: menuItems)
        
        navBtn = UIBarButtonItem(title: "en" , menu: menu)
        let navMenu = [navBtn!]
        self.navigationItem.leftBarButtonItems = navMenu

    }

    func langSelected(_ value: Languages) {
        navBtn?.title = value.rawValue
        viewModel.languageChanged(to: value)
    }
    
}

// MARK: - MapSettings
enum MapSettings: Int {
    case standard = 0
    case satellite = 1
}

// MARK: - MapConfig
protocol MapConfig {
    var mapSettings: Reactive<MapSettings> { get set }
    var fromDate: Reactive<Date?> { get set }
    var toDate: Reactive<Date?> { get set }
    func languageChanged(to value: Languages)
}
