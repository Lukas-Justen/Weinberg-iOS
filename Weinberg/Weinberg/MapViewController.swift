//
//  MapViewController.swift
//  Weinberg
//
//  Created by Student on 02.06.17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

/*
 * @author Lukas Justen
 * @email lukas.justen@th-bingen.de
 * @version 1.0
 *
 * The class MapViewController displays the Map and draws the fields as polygons on the map.
 * If a field is already done the controller will use a green color in order to show it's done-status.
 * Otherwise the controller will use a red color. You can click at the Polygons in order to change
 * their status und get mor information about the field.
 */
class MapViewController: UIViewController {
 
    // The MapView which displays the satelite-map
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var fabCreate: UIView!
    
    // The RealmInstance in order to access the database
    let realm = try! Realm()
    
    // The operation the map currently displays
    static var currentOperation: Operation?
    var editable: Bool = false
    var editCoordinates: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    var editPolygon: MKPolygon?
    
    /*
     * The ViewController creates polygons and adds them to the map.
     */
    override func viewDidLoad() {
        var coordinates: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        coordinates.append(CLLocationCoordinate2D(latitude: 49.0,longitude: 7.50))
        coordinates.append(CLLocationCoordinate2D(latitude: 52.0,longitude: 10.0))
        coordinates.append(CLLocationCoordinate2D(latitude: 48.6,longitude: 12.13))
        let myPolygon: MKPolygon = MKPolygon(coordinates: &coordinates, count: coordinates.count)
        myPolygon.title = "done"
        mapView.add(myPolygon)
        
        var coordinates2: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        coordinates2.append(CLLocationCoordinate2D(latitude: 45.0,longitude: 5.50))
        coordinates2.append(CLLocationCoordinate2D(latitude: 50.0,longitude: 10.0))
        coordinates2.append(CLLocationCoordinate2D(latitude: 48.6,longitude: 12.13))
        let myPolygon2: MKPolygon = MKPolygon(coordinates: &coordinates2, count: coordinates2.count)
        myPolygon2.title = "todo"
        mapView.add(myPolygon2)
        
        if (MapViewController.currentOperation == nil) {
            MapViewController.currentOperation = realm.objects(Operation.self).first
        }
        
        updateOperationAndMap()
        NotificationCenter.default.addObserver(self, selector: #selector(updateOperationAndMap), name: .operationSelected, object:nil)
    }
    
    func updateOperationAndMap() {
        navigationItem.title = MapViewController.currentOperation?.name
    }
    
    @IBAction func createNewField(_ sender: Any) {
        editable = true
    }
    
    
    @IBAction func createNewVertex(_ sender: UITapGestureRecognizer) {
        if editable {
            let touchlocation = sender.location(in: mapView)
            let locationCoordinate = mapView.convert(touchlocation, toCoordinateFrom: mapView)
            print("Lat: \(locationCoordinate.latitude) Lng: \(locationCoordinate.longitude)")
            let annotation = MKPointAnnotation()
            annotation.coordinate = locationCoordinate
            mapView.addAnnotation(annotation)
            editCoordinates.append(locationCoordinate)
            if (editPolygon != nil) {
                mapView.remove(editPolygon!)
            }
            editPolygon = MKPolygon(coordinates: &editCoordinates, count: editCoordinates.count)
            editPolygon?.title = "edit"
            mapView.add(editPolygon!)
            if (editCoordinates.count >= 3) {
                fabCreate.isHidden = false
            }
         }
    }
    
    @IBAction func confirmNewField(_ sender: Any) {
        
    }
}



/*
 * By implementing functions of the MKMapViewDelegate protocol the ViewController can change the color
 * of the polygons.
 */
extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolygon {
            let polygonView = MKPolygonRenderer(overlay: overlay)
            switch (overlay as! MKPolygon).title! {
            case "done":
                polygonView.strokeColor = UIColor(red: CGFloat(156.0/255.0), green: CGFloat(223.0/255.0), blue: CGFloat(94.0/255.0), alpha: CGFloat(0.8))
                polygonView.fillColor = UIColor(red: CGFloat(156.0/255.0), green: CGFloat(223.0/255.0), blue: CGFloat(94.0/255.0), alpha: CGFloat(0.5))
                break
            case "todo":
                polygonView.strokeColor = UIColor(red: CGFloat(173.0/255.0), green: CGFloat(20.0/255.0), blue: CGFloat(87.0/255.0), alpha: CGFloat(0.8))
                polygonView.fillColor = UIColor(red: CGFloat(173.0/255.0), green: CGFloat(20.0/255.0), blue: CGFloat(87.0/255.0), alpha: CGFloat(0.5))
                break
            default:
                polygonView.strokeColor = UIColor(red: CGFloat(8.0/255.0), green: CGFloat(126.0/255.0), blue: CGFloat(139.0/255.0), alpha: CGFloat(0.8))
                polygonView.fillColor = UIColor(red: CGFloat(8.0/255.0), green: CGFloat(126.0/255.0), blue: CGFloat(139.0/255.0), alpha: CGFloat(0.5))
                break
            }
            return polygonView
        }
        return MKPolygonRenderer(overlay: overlay)
    }    
}
