//
//  MapView.swift
//  Let's Go
//
//  Created by Vanya Bogdantsev on 23.09.2023.
//

import UIKit
import YandexMapsMobile
import Nuke

final class MapView: UIView {
    
    let mapView = YMKMapView()
    /// mapView.mapWindow.map
    var map: YMKMap {
        mapView.mapWindow.map
    }
    let userLocationLayer: YMKUserLocationLayer
    var clusteredColletion: YMKClusterizedPlacemarkCollection?
    
    init() {
        userLocationLayer = YMKMapKit.sharedInstance().createUserLocationLayer(with: mapView.mapWindow)
        super.init(frame: .zero)
        layout()
        setStyle()
        clusteredColletion = map.mapObjects.addClusterizedPlacemarkCollection(with: self)
        userLocationLayer.setVisibleWithOn(true)
        userLocationLayer.isHeadingEnabled = true
        userLocationLayer.setObjectListenerWith(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(mapView)
    }
    
    private func setStyle() {
        map.isRotateGesturesEnabled = false
        map.isNightModeEnabled = true
    }
    
    func addPlacemarks(_ placemarks: Placemarks) {
        clusteredColletion?.clear()
        placemarks.forEach { placemarkModel in
            let placemark = clusteredColletion?.addPlacemark()
            let style = YMKIconStyle()
            if let urlString = placemarkModel.pinURL,
               let url = URL(string: urlString) {
                Task {
                    do {
                        let image = try await ImagePipeline.shared.image(for: url)
                        style.scale = 1.3
                        placemark?.setIconWith(image, style: style)
                    } catch {
                        style.scale = 0.4
                        placemark?.setIconWith(Images.default_placemark ?? UIImage(), style: style)
                    }
                }
            } else {
                style.scale = 0.4
                placemark?.setIconWith(Images.default_placemark ?? UIImage(), style: style)
            }
            placemark?.geometry = YMKPoint(latitude: placemarkModel.latitude, longitude: placemarkModel.longitude)
            clusteredColletion?.clusterPlacemarks(withClusterRadius: 60, minZoom: 9)
        }
    }
    
}

extension MapView: YMKClusterListener {
    func onClusterAdded(with cluster: YMKCluster) {
        cluster.appearance.setIconWith(clusterImage(cluster.size))
    }
    
    func clusterImage(_ clusterSize: UInt) -> UIImage {
        let scale = UIScreen.main.scale
        let text = (clusterSize as NSNumber).stringValue
        let font = UIFont.systemFont(ofSize: 10 * scale)
        let size = text.size(withAttributes: [NSAttributedString.Key.font: font])
        let textRadius = sqrt(size.height * size.height + size.width * size.width) / 2
        let internalRadius = textRadius + 5 * scale
        let externalRadius = internalRadius + 3 * scale
        let iconSize = CGSize(width: externalRadius * 2, height: externalRadius * 2)
        
        UIGraphicsBeginImageContext(iconSize)
        let ctx = UIGraphicsGetCurrentContext()!
        
        ctx.setFillColor(Colors.letsgo_main_red.cgColor)
        ctx.fillEllipse(in: CGRect(
            origin: .zero,
            size: CGSize(width: 2 * externalRadius, height: 2 * externalRadius)));
        
        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fillEllipse(in: CGRect(
            origin: CGPoint(x: externalRadius - internalRadius, y: externalRadius - internalRadius),
            size: CGSize(width: 2 * internalRadius, height: 2 * internalRadius)));
        
        (text as NSString).draw(
            in: CGRect(
                origin: CGPoint(x: externalRadius - size.width / 2, y: externalRadius - size.height / 2),
                size: size),
            withAttributes: [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: UIColor.black])
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        return image
    }
}

extension MapView: YMKUserLocationObjectListener {
    func onObjectAdded(with view: YMKUserLocationView) {
        let pinPlacemark = view.pin
        
        pinPlacemark.setIconWith(
            Images.user_location ?? UIImage(),
            style:YMKIconStyle(
                anchor: CGPoint(x: 0.5, y: 0.5) as NSValue,
                rotationType:YMKRotationType.rotate.rawValue as NSNumber,
                zIndex: 1,
                flat: true,
                visible: true,
                scale: 1.4,
                tappableArea: nil))
    }
    
    func onObjectRemoved(with view: YMKUserLocationView) {
        
    }
    
    func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {
        
    }
}
