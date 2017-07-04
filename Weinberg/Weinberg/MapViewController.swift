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
 * their status und get more information about the field itself.
 */
class MapViewController: UIViewController {
 
    
    
    // The MapView which displays the satellite-map
    @IBOutlet weak var mapView: MKMapView!
    // The FloatingActionButton for confirming the boundaries of the new field
    @IBOutlet weak var fabCreate: UIView!
    // The label in order to tell the user to mark the area of the new field
    @IBOutlet weak var labelMarkPoints: UILabel!
    
    // The RealmInstance in order to access the database
    let realm = try! Realm()
    // The radius of the earth in order to calculate the size of a polygon
    let earthRadius = 6378137.0
    
    // Variables for marking a new Field on the map
    var editable: Bool = false
    var editCoordinates: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    var editPolygon: MKFieldPolygon?
    var editAnnotations: [MKAnnotation] = [MKAnnotation]()
    
    
    
    /*
     * Initializes the currentOperation with a random operation if nil and adds an observer for 
     * creating a new field.
     */
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(createNewField), name: .createNewField, object:nil)
    }
    
    /*
     * Starts the marking-process for a new field.
     */
    @IBAction func createNewField(_ sender: Any) {
        editable = true
        self.labelMarkPoints.isHidden = false
    }
    
    /*
     * Unwind segue returns to the map.
     */
    @IBAction func unwindToMap(segue:UIStoryboardSegue){}
    
    /*
     * Adds a new vertex to the map and updates the polygon/field the user is currently creating. If
     * the user isn't in e
     */
    @IBAction func mapClicked(_ sender: UITapGestureRecognizer) {
        let touchlocation = sender.location(in: mapView)
        let locationCoordinate = mapView.convert(touchlocation, toCoordinateFrom: mapView)
        if editable {
            let annotation = MKPointAnnotation()
            annotation.coordinate = locationCoordinate
            annotation.title = String(editAnnotations.count)
            mapView.addAnnotation(annotation)
            editAnnotations.append(annotation)
            editCoordinates.append(locationCoordinate)
            if (editPolygon != nil) {
                mapView.remove(editPolygon!)
            }
            editPolygon = MKFieldPolygon(coordinates: &editCoordinates, count: editCoordinates.count)
            editPolygon?.status = "edit"
            mapView.add(editPolygon!)
            if (editCoordinates.count >= 3) {
                fabCreate.isHidden = false
                labelMarkPoints.isHidden = true
            }
        } else {
            let point:MKMapPoint = MKMapPointForCoordinate(locationCoordinate)
            let overlays = mapView.overlays.filter {o in o is MKPolygon}
            for overlay in overlays {
                showStatusDialog(overlay: overlay, point: point)
            }
        }
    }
    
    /*
     * Determines wether the user tapped on a field. In this case the app shows a dialog
     * with further informationm like fruit and treatment of the field.
     */
    func showStatusDialog(overlay: MKOverlay, point:MKMapPoint) {
        let polygonRenderer = MKPolygonRenderer(overlay: overlay)
        let datPoint = polygonRenderer.point(for: point)
        polygonRenderer.invalidatePath()
        if (polygonRenderer.path.contains(datPoint)) {
            let fieldPolygon:MKFieldPolygon = overlay as! MKFieldPolygon
            let field:Field = fieldPolygon.field!
            let fruit = (field.fruit != "") ? "\nRebsorte: \(field.fruit)" : ""
            let treatment = (field.treatment != "") ? "\nErziehung: \(field.treatment)" : ""
            let area = "\nFläche: \(field.area)"
            let alert = UIAlertController(title: field.name, message: fruit + treatment + area, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil))
            let done:Bool = fieldPolygon.status == "done"
            alert.addAction(UIAlertAction(title: (done) ? "Enthaken" :"Abhaken", style: .default, handler:{(_) in
                if !done {
                    try! self.realm.write {
                        DataManager.shared.currentOperation?.todo.remove(objectAtIndex: (DataManager.shared.currentOperation?.todo.index(of: field))!)
                        DataManager.shared.currentOperation?.done.append(field)
                        DataManager.shared.currentOperation?.doneArea += field.area
                    }
                }else{
                    try! self.realm.write {
                        DataManager.shared.currentOperation!.done.remove(objectAtIndex: (DataManager.shared.currentOperation!.done.index(of: field))!)
                        DataManager.shared.currentOperation?.todo.append(field)
                        DataManager.shared.currentOperation?.doneArea -= field.area
                    }
                }
                self.redrawAllPolygons()
            }))
        }
    }
    
    /*
     * Confirms the marking-process of the new field and opens the AddFieldViewController in order
     * to add further information.
     */
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
        field.area = Int64(regionArea(locations: editCoordinates))
        addController.newField = field
        self.navigationController?.pushViewController(addController, animated: true)
    }
    
    /*
     * Draws all polygons on the map by using the method "drawField"
     */
    func redrawAllPolygons() -> Void {
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        if (DataManager.shared.currentOperation != nil) {
            let doneFields:List<Field> = (DataManager.shared.currentOperation?.done)!
            for f in doneFields {
                drawField(field: f, status: "done")
            }
            let todoFields:List<Field> = (DataManager.shared.currentOperation?.todo)!
            for f in todoFields {
                drawField(field: f, status: "todo")
            }
        }
    }
    
    /*
     * Draws the given field on the map.
     */
    func drawField(field:Field, status:String) -> Void{
        var coordinates: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        for ll in field.boundaries {
            coordinates.append(CLLocationCoordinate2D(latitude: ll.lat, longitude: ll.lng))
        }
        let polygon = MKFieldPolygon(coordinates: &coordinates, count: coordinates.count)
        polygon.status = status
        polygon.field = field
        mapView.add(polygon)
    }
    
    /*
     * If the ViewController is going to appear, the map and the title of the navbar are going
     * to be updated and the Map will zoom on the lattest chosen field.  
     */
    override func viewWillAppear(_ animated: Bool) {
        let span = MKCoordinateSpanMake(CLLocationDegrees(0.005), CLLocationDegrees(0.005))
        
        if(DataManager.shared.currentOperation != nil){
            redrawAllPolygons()
            navigationItem.title = DataManager.shared.currentOperation?.name
        } else {
            mapView.removeOverlays(mapView.overlays)
            mapView.removeAnnotations(mapView.annotations)
            navigationItem.title = "Keine Arbeiten"
        }
        
        if ( DataManager.shared.currentField != nil) {
            mapView.setRegion(MKCoordinateRegionMake((DataManager.shared.currentField)!, span), animated: true)
        }
    }
    
    /*
     * Converts degrees to radians.
     */
    func radians(degrees: Double) -> Double {
        return degrees * Double.pi / 180;
    }
    
    /*
     * Calculates the area given by the coordinates.
     */
    func regionArea(locations: [CLLocationCoordinate2D]) -> Double {
        guard locations.count > 2 else { return 0 }
        var area = 0.0
        
        for i in 0..<locations.count {
            let p1 = locations[i > 0 ? i - 1 : locations.count - 1]
            let p2 = locations[i]
            
            area += radians(degrees: p2.longitude - p1.longitude) * (2 + sin(radians(degrees: p1.latitude)) + sin(radians(degrees: p2.latitude)) )
        }
        
        area = -(area * earthRadius * earthRadius / 2);
        
        return max(area, -area)
    }
    
    /*
     * Marks all fields of this operation as undone and updates the Map
     */
    @IBAction func renewOperation(_ sender: UIBarButtonItem) {
        if (DataManager.shared.currentOperation != nil && (DataManager.shared.currentOperation?.done.count)!>0) {
            let alert = UIAlertController(title: "Zurücksetzen", message: "Wollen Sie wirklich den gesamten Arbeitsschritt zurücksetzen?", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            alert.addAction(UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Zurücksetzen", style: .default, handler:{(_) in
                try! self.realm.write {
                    let operation = DataManager.shared.currentOperation
                    for doneField in (operation?.done)! {
                        operation?.todo.append(doneField)
                    }
                    operation?.doneArea  = 0
                    operation?.done.removeAll()
                }
                self.redrawAllPolygons()
            }))
        }
    }
    
    /*
     * Removes all unnecessary Annotations, Polygons and the FloatingActionButton
     */
    override func viewWillDisappear(_ animated: Bool) {
        if (editPolygon != nil) {
            mapView.remove(editPolygon!)
        }
        mapView.removeAnnotations(mapView.annotations)
        editable = false
        editPolygon = nil
        editAnnotations = [MKAnnotation]()
        editCoordinates = [CLLocationCoordinate2D]()
        fabCreate.isHidden = true
        labelMarkPoints.isHidden = true
    }
    
}



/*
 * By implementing functions of the MKMapViewDelegate protocol the ViewController can change the color
 * of the polygons or drag annotations.
 */
extension MapViewController: MKMapViewDelegate {
    
    /*
     * Changes the color of the polygons on the map.
     */
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolygon {
            let polygonView = MKPolygonRenderer(overlay: overlay)
            switch (overlay as! MKFieldPolygon).status {
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
     * Makes the annotations on the map dragable.
     */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKPointAnnotation {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            pinAnnotationView.isDraggable = true
            pinAnnotationView.animatesDrop = true
            pinAnnotationView.canShowCallout = true
            
            return pinAnnotationView
        }
        return nil
    }
    
    /*
     * Handles the drop event of the annotations.
     */
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        if (oldState == .ending && newState == .none) {
            let pinAnnotationView: MKPinAnnotationView = view as! MKPinAnnotationView
            let pointAnnotation = pinAnnotationView.annotation as! MKPointAnnotation
            let position:Int = Int(pointAnnotation.title!)!
            editAnnotations[position] = pinAnnotationView.annotation!
            editCoordinates[position] = (pinAnnotationView.annotation?.coordinate)!
            if (editPolygon != nil) {
                mapView.remove(editPolygon!)
            }
            editPolygon = MKFieldPolygon(coordinates: &editCoordinates, count: editCoordinates.count)
            editPolygon?.status = "edit"
            mapView.add(editPolygon!)
        }
    }
    
}



/*
 * Notification starts the process for creating a new field
 */
extension Notification.Name {
    
    static let createNewField = Notification.Name("createNewField")
    
}
