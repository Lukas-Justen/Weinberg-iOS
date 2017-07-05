//
//  MapDrawer.swift
//  Weinberg
//
//  Created by ema on 04.07.17.
//  Copyright © 2017 Student. All rights reserved.
//

import Foundation
import MapKit
import RealmSwift



/*
 * @author Lukas Justen
 * @email lukas.justen@th-bingen.de
 * @version 1.0
 *
 * The class MapDrawer starts the marking process for a new field. It handles the arrays
 * which contain the data for the new field. When a marker is dragged it will updates
 * the mapView immediatley.
 */
class MapDrawer {
    
    
    
    // Variables for marking a new Field on the map
    var editable: Bool = false
    var editCoordinates: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    var editPolygon: MKFieldPolygon?
    var editAnnotations: [MKAnnotation] = [MKAnnotation]()
    
    // The radius of the earth in order to calculate the size of a polygon
    let earthRadius = 6378137.0    
    // The MapView which displays the satellite-map
    let mapView:MKMapView?
    // The FloatingActionButton for confirming the boundaries of the new field
    let fabCreate:UIView?
    // The label in order to tell the user to mark the area of the new field
    let labelMarkPoints:UILabel?
    
    
    
    /*
     * Initializes the MapDrawer with the necessary Views
     */
    init(mapView:MKMapView, fabCreate: UIView, labelMarkPoints: UILabel) {
        self.mapView = mapView
        self.fabCreate = fabCreate
        self.labelMarkPoints = labelMarkPoints
    }
    
    /*
     * Creates a new dragable PointAnnotation which serves as a vertex of the field
     */
    func createNewVertex(locationCoordinate:CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        annotation.title = String(editAnnotations.count)
        mapView?.addAnnotation(annotation)
        editAnnotations.append(annotation)
        editCoordinates.append(locationCoordinate)
        if (editPolygon != nil) {
            mapView?.remove(editPolygon!)
        }
        editPolygon = MKFieldPolygon(coordinates: &editCoordinates, count: editCoordinates.count)
        editPolygon?.status = "edit"
        mapView?.add(editPolygon!)
        if (editCoordinates.count >= 3) {
            fabCreate?.isHidden = false
            labelMarkPoints?.isHidden = true
        }
    }
    
    /*
     * Creates a new Field which can be saved into the realm.
     */
    func createNewField() -> Field {
        let coordinates:List<LatLng> = List<LatLng>()
        for coord in editCoordinates {
            let myLatLng = LatLng()
            myLatLng.lng = coord.longitude
            myLatLng.lat = coord.latitude
            coordinates.append(myLatLng)
        }
        let field: Field = Field()
        field.boundaries = coordinates
        field.area = Int64(computeArea(locations: editCoordinates))
        return field
    }
    
    /*
     * Calculates the area given by the coordinates.
     */
    func computeArea(locations: [CLLocationCoordinate2D]) -> Double {
        guard locations.count > 2 else { return 0 }
        var area = 0.0
        
        for i in 0..<locations.count {
            let p1 = locations[i > 0 ? i - 1 : locations.count - 1]
            let p2 = locations[i]
            
            area += MapDrawer.radians(degrees: p2.longitude - p1.longitude) * (2 + sin(MapDrawer.radians(degrees: p1.latitude)) + sin(MapDrawer.radians(degrees: p2.latitude)) )
        }
        
        area = -(area * earthRadius * earthRadius / 2);
        
        return max(area, -area)
    }
    
    /*
     * Converts degrees to radians.
     */
    static func radians(degrees: Double) -> Double {
        return degrees * Double.pi / 180;
    }
    
    /*
     * Resets the state of the MapDrawer in order to mark a new field
     */
    func reset() {
        if (editPolygon != nil) {
            mapView?.remove(editPolygon!)
        }
        mapView?.removeAnnotations((mapView?.annotations)!)
        editable = false
        editPolygon = nil
        editAnnotations = [MKAnnotation]()
        editCoordinates = [CLLocationCoordinate2D]()
        fabCreate?.isHidden = true
        labelMarkPoints?.isHidden = true
    }
    
    /*
     * Hanldes the drop event of an annotation and updates all arrays
     */
    func dragAndDropAnnotation(view:MKAnnotationView) {
        let pinAnnotationView: MKPinAnnotationView = view as! MKPinAnnotationView
        let pointAnnotation = pinAnnotationView.annotation as! MKPointAnnotation
        let position:Int = Int(pointAnnotation.title!)!
        editAnnotations[position] = pinAnnotationView.annotation!
        editCoordinates[position] = (pinAnnotationView.annotation?.coordinate)!
        if (editPolygon != nil) {
            mapView?.remove(editPolygon!)
        }
        editPolygon = MKFieldPolygon(coordinates: &editCoordinates, count: editCoordinates.count)
        editPolygon?.status = "edit"
        mapView?.add(editPolygon!)
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
        mapView?.add(polygon)
    }
    
}
