//
//  MainViewController.swift
//  SomeVehicle
//
//  Created by 장기화 on 2022/07/25.
//

import UIKit
import MapKit
import SnapKit

class MainViewController: UIViewController {
    let initialLocation = CLLocation(latitude: 37.54330366639085,
                                     longitude: 127.04455548501139)
    
    private let locationManager = CLLocationManager()
    private let networkManager = NetworkManager()
    private var myLocationPin: MyAnnotation?
    private var zoneList = [Zone]()
    
    private lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.delegate = self
        return view
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBackground
        button.setTitle(" 즐겨찾는 존 ", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setImage(UIImage(named: "ic24_favorite_black"), for: .normal)
        button.layer.cornerRadius = 22
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(tapFavoriteButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var currentLocationButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBackground
        button.setImage(UIImage(named: "ic24_my_location"), for: .normal)
        button.layer.cornerRadius = 22
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(tapCurrentLocationButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        checkLocationAuth()
        
        Task {
            await fetchZone()
            addZonePin()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
        
    }
    
    @objc private func tapCurrentLocationButton() {
        checkLocationAuth()
    }
    
    @objc private func tapFavoriteButton() {
        let vc = FavoriteViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    private func checkLocationAuth() {
        locationManager.requestWhenInUseAuthorization()
        addMyLocationPin()
        
        switch CLLocationManager.authorizationStatus() {
        case .denied, .restricted, .notDetermined:
            mapView.centerToLocation(initialLocation)
//            move to settings logic for allow authorization.
        case .authorized, .authorizedAlways, .authorizedWhenInUse:
            guard let location = locationManager.location else { return }
            mapView.centerToLocation(location)
        default:
            break
        }
    }
    
    private func addMyLocationPin() {
        if myLocationPin == nil {
            guard let location = locationManager.location else { return }
            let lati = CLLocationDegrees(location.coordinate.latitude)
            let long = CLLocationDegrees(location.coordinate.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lati, longitude: long)
            myLocationPin = MyAnnotation(coordinate: coordinate)
        }
        guard let pin = myLocationPin else { return }
        mapView.addAnnotation(pin)
    }
    
    private func addZonePin() {
        for i in 0...zoneList.count - 1 {
            let lati = CLLocationDegrees(zoneList[i].location.lat)
            let long = CLLocationDegrees(zoneList[i].location.lng)
            let location = CLLocationCoordinate2D(latitude: lati, longitude: long)
            let pin = ZoneAnnotation(coordinate: location, id: zoneList[i].id, name: zoneList[i].name, alias: zoneList[i].alias)
            mapView.addAnnotations([pin])
        }
    }
    
    private func fetchZone() async {
        let data = await networkManager.getZones()
        switch data {
        case .success(let zone):
            zoneList = zone
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    private func setLayout() {
        navigationItem.backButtonTitle = ""
        
        [mapView, favoriteButton, currentLocationButton]
            .forEach { view.addSubview($0) }
        
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        favoriteButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(60)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(44)
            $0.width.equalTo(119)
        }
        
        currentLocationButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(28)
            $0.height.width.equalTo(44)
        }
        
        setButtonsShadow()
    }
    
    private func setButtonsShadow() {
        [favoriteButton, currentLocationButton].forEach {
            $0.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).cgColor
            $0.layer.shadowOpacity = 1
            $0.layer.shadowOffset = CGSize(width: 0, height: 3)
            $0.layer.shadowRadius = 3
            $0.layer.masksToBounds = false
            $0.layoutIfNeeded()
        }
    }
}

private extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 500) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}

extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        var annotationView: MKAnnotationView?
        
        if let annotation = annotation as? MyAnnotation {
            annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MyAnnotation.identifier)
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: MyAnnotation.identifier)
            annotationView?.annotation = annotation
            annotationView?.image = UIImage(named: "img_current")
        } else if let annotation = annotation as? ZoneAnnotation {
            annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: ZoneAnnotation.identifier)
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: ZoneAnnotation.identifier)
            annotationView?.annotation = annotation
            annotationView?.image = UIImage(named: "img_zone_shadow")
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let zoneInfo = view.annotation as? ZoneAnnotation else { return }
        MKMapView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut) {
            let location = CLLocation(latitude: zoneInfo.coordinate.latitude, longitude: zoneInfo.coordinate.longitude)
            mapView.centerToLocation(location)
        } completion: { [weak self] _ in
            let vc = DetailViewController(zone: zoneInfo)
            self?.navigationController?.pushViewController(vc, animated: true)
            mapView.deselectAnnotation(zoneInfo, animated: false)
        }
    }
}

extension MainViewController: FavoriteViewControllerDelegate {
    func tapDismissButton(zone: FavoriteZone) {
        let lati = CLLocationDegrees(zone.latitude)!
        let long = CLLocationDegrees(zone.longitude)!
        let location = CLLocation(latitude: lati, longitude: long)
        
        MKMapView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut) {
            self.mapView.centerToLocation(location)
        } completion: { [weak self] _ in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                let coordinate = CLLocationCoordinate2D(latitude: lati, longitude: long)
                let annotation = ZoneAnnotation(coordinate: coordinate, id: zone.id, name: zone.name, alias: zone.alias)
                self?.navigationController?.pushViewController(DetailViewController(zone: annotation), animated: true)
            }
        }
    }
}
