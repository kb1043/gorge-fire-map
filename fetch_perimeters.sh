#!/bin/bash
# Fetch Rowena and Burdoin fire perimeters from NIFC WFIGS service as GeoJSON

echo "Fetching Rowena fire perimeter..."
curl -s "https://services3.arcgis.com/T4QMspbfLg3qTGWY/arcgis/rest/services/WFIGS_Interagency_Perimeters/FeatureServer/0/query?where=poly_IncidentName+LIKE+%27%25Rowena%25%27&outFields=*&f=geojson&returnGeometry=true" > rowena_perimeter.geojson

echo "Fetching Burdoin fire perimeter..."
curl -s "https://services3.arcgis.com/T4QMspbfLg3qTGWY/arcgis/rest/services/WFIGS_Interagency_Perimeters/FeatureServer/0/query?where=poly_IncidentName+LIKE+%27%25Burdoin%25%27&outFields=*&f=geojson&returnGeometry=true" > burdoin_perimeter.geojson

echo "Done. Files saved:"
ls -la *.geojson
