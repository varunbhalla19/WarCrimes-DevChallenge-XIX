//
//  MapViewController.swift
//  WarCrimes
//

import UIKit
import MapKit
import SwiftUI

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var btnStack: UIStackView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    var viewModel: MainViewModel = MainViewModel.init(repo: CrimeDataRepository.init())
    
    lazy var settingsVC: SettingsViewController = {
        SettingsViewController.make(with: viewModel)
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        setupMapConfig()
        

        bindViewModel()
        
        btnStack.transform = .identity.translatedBy(x: 0, y: 120).scaledBy(x: 1/2, y: 1/2)
        blurView.transform = .identity.translatedBy(x: 0, y: 120).scaledBy(x: 1/2, y: 1/2)
        blurView.layer.cornerRadius = 24
        
    }
    
    private func bindViewModel() {
        viewModel.events.bind { [weak self] events in
            self?.reloadMap(with: events)
        }
        
        viewModel.dataLoaded.bind { [weak self] bool in
            if bool {
                self?.animateViewsToNormal()
            }
        }
        
        viewModel.mapSettings.bind { [weak self] value in
            switch value {
            case .standard:
                self?.mapView.mapType = .standard
            case .satellite:
                self?.mapView.mapType = .satellite
            }
        }

    }
    
    
    
    private func reloadMap(with crimeEvents: [CrimeEvent]){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.addEvents(crimeEvents)
        }
    }
    
    private func addEvents(_ crimeEvents: [CrimeEvent]) {
        DispatchQueue.global(qos: .userInitiated ).async { [weak self] in
            guard let self = self else { return }
            let result = crimeEvents.map { crimeEvent in
                CrimeAnnotation.init(
                    title: self.viewModel.names.event[crimeEvent.name],
                    coordinate: CLLocation.init(latitude: .init(crimeEvent.lat), longitude: .init(crimeEvent.lon)).coordinate,
                    eventId: crimeEvent.name,
                    dateDescription: "\(crimeEvent.from.toString(dateFormat: "dd-MMM")) - \(crimeEvent.till.toString(dateFormat: "dd-MMM"))"
                )
            }
            self.mapView.addAnnotations(result)
            DispatchQueue.main.async {
                if self.viewModel.dataLoaded.value == true {
                    self.descriptionLabel.text = "\(result.count)"
                }
            }
        }
    }
    
    @IBAction func settingsPressed(_ sender: UIButton) {
        let nav = UINavigationController(rootViewController: settingsVC)
            nav.modalPresentationStyle = .pageSheet
            if let sheet = nav.sheetPresentationController {
                sheet.detents = [.medium()]
            }
        present(nav, animated: true, completion: nil)
    }
    
    @IBAction func chartsPressed(_ sender: Any) {
        let vc = UIHostingController(rootView: StatsView.init(viewModel: viewModel))
        self.present(vc, animated: true)
    }

    // MARK: - Map Config
    private func setupMapConfig(){
        let initialLocation = CLLocation.init(latitude: 50.46380724651722, longitude: 30.518928142860606)
        mapView.centerToLocation(initialLocation)
        
        let center = CLLocation.init(latitude: 49.010825946576446, longitude: 31.108730898210204)
        let region = MKCoordinateRegion(
              center: center.coordinate,
              latitudinalMeters: 893000,
              longitudinalMeters: 1316000)
        
        mapView.setCameraBoundary(
          MKMapView.CameraBoundary(coordinateRegion: region),
          animated: true)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 2000000)
        mapView.setCameraZoomRange(zoomRange, animated: true)
        
        mapView.register(CrimeAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(CrimeClusterAnnotationView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)

    }

    // MARK: - Bottom buttons animation
    private func animateViewsToNormal(){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                self.blurView.transform = .identity
                self.btnStack.transform = .identity
            })
        }
    }
    
    
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if annotation is MKUserLocation {
            return nil
        }
        
        guard let crimeAnnotation = annotation as? CrimeAnnotation else { return nil }
        
        let view = CrimeAnnotationView(annotation: annotation, reuseIdentifier: CrimeAnnotationView.ReuseID)
        view.markerTintColor = ColorSet.colorsForEvents[crimeAnnotation.eventId]
        return view

    }
}

// MARK: - MKMapView
private extension MKMapView {    
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 50000
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
