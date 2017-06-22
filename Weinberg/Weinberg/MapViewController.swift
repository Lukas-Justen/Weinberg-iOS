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
 * The class MapViewController displays the Map and drvar the fields as polygons on the map.
 * If a field is already done the controller will use a green color in order to show it's done-status.
 * Otherwise the controller will use a red color. You can click at the Polygons in order to change
 * their status und get mor information about the field.
 */
class MapViewController: UIViewController {
 
    // The MapView which displays the satellite-map
    @IBOutlet weak var mapView: MKMapView!
    // The FloatingActionButton for confirming the boundaries of the new field
    @IBOutlet weak var fabCreate: UIView!
    
    // The RealmInstance in order to access the database
    let realm = try! Realm()
    
    var editable: Bool = false
    var editCoordinates: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    var editPolygon: MKPolygon?
    var editAnnotations: [MKAnnotation] = [MKAnnotation]()
    
    // The operation the map currently displays
    static var currentOperation: Operation?
    
    
    
    /*
     * The ViewController creates polygons and adds them to the map.
     */
    override func viewDidLoad() {
        if (MapViewController.currentOperation == nil) {
            MapViewController.currentOperation = realm.objects(Operation.self).first
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateOperation), name: .operationSelected, object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(createNewField), name: .createNewField, object:nil)
        updateOperation()
        redrawAllPolygons()
    }
    
    func updateOperation() {
        navigationItem.title = MapViewController.currentOperation?.name
    }
    
    @IBAction func createNewField(_ sender: Any) {
        editable = true
    }
    
    @IBAction func unwindToMap(segue:UIStoryboardSegue){}
    
    @IBAction func createNewVertex(_ sender: UITapGestureRecognizer) {
        if editable {
            let touchlocation = sender.location(in: mapView)
            let locationCoordinate = mapView.convert(touchlocation, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = locationCoordinate
            annotation.title = String(editAnnotations.count)
            mapView.addAnnotation(annotation)
            editAnnotations.append(annotation)
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
        let coordinates:List<LatLng> = List<LatLng>()
        for coord in editCoordinates {
            let myLatLng = LatLng()
            myLatLng.lng = coord.longitude
            myLatLng.lat = coord.latitude
            coordinates.append(myLatLng)
        }
        let field: Field = Field()
        let storyBoard: UIStoryboard = UIStoryboard(name:"Field",bundle:nil)
        let addController : AddFieldViewController = storyBoard.instantiateViewController(withIdentifier: "AddField") as! AddFieldViewController
        field.boundaries = coordinates
        addController.newField = field
        self.navigationController?.pushViewController(addController, animated: true)
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.remove(editPolygon!)
        editable = false
        editPolygon = nil
        editCoordinates = [CLLocationCoordinate2D]()
        fabCreate.isHidden = true
    }
    
    func redrawAllPolygons() -> Void {
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        
        MapViewController.currentOperation = realm.objects(Operation.self).filter("name = %@", (MapViewController.currentOperation?.name)!).first
        let doneFields:List<Field> = (MapViewController.currentOperation?.done)!
        for f in doneFields {
            drawField(field: f, status: "done")
        }
        let todoFields:List<Field> = (MapViewController.currentOperation?.todo)!
        for f in todoFields {
            drawField(field: f, status: "todo")
        }
    }
    
    func drawField(field:Field, status:String) -> Void{
        var coordinates: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        for ll in field.boundaries {
            coordinates.append(CLLocationCoordinate2D(latitude: ll.lat, longitude: ll.lng))
        }
        let polygon = MKPolygon(coordinates: &coordinates, count: coordinates.count)
        polygon.title = status
        mapView.add(polygon)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        redrawAllPolygons()
    }
    
}



/*
 * By implementing functions of the MKMapViewDelegate protocol the ViewController can change the color
 * of the polygons or drag markers.
 */
extension MapViewController: MKMapViewDelegate {
    
    /*
     * Changes the color of the polygons on the map
     */
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
    
    /* 
     * Makes the annotations on the map dragable
     */
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        /*if (editPolygon != nil) {
            mapView.remove(editPolygon!)
        }
        let ann: MKAnnotation = view as! MKAnnotation
        editAnnotations[Int(ann.title.to)]
        editCoordinates.append(locationCoordinate)
        editPolygon = MKPolygon(coordinates: &editCoordinates, count: editCoordinates.count)
        editPolygon?.title = "edit"
        mapView.add(editPolygon!)*/
    }
    
}

/*
 * Notification starts the process for creating a new field
 */
extension Notification.Name {
    static let createNewField = Notification.Name("createNewField")
}
