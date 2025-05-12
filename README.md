# NPS Library Interactive Map

This project is an interactive web map for exploring National Park Service (NPS) digital library records using spatial search. Inspired by [Open Parks Network](https://openparksnetwork.org/map/), it allows users to search by keyword and view associated metadata on a map.

## What It Does

- Displays points from tens of thousands of digitized records on a map.
- Enables keyword search to filter results by title.
- Popups show all available metadata, including external links.
- Uses ESRI topographic basemap for intuitive navigation.

## Project Structure

<pre> ├── data/
    ├── sample-data/
        ├──  IRMA_enhanced_reports_1.json
        ├──  IRMA_enhanced_reports_2.json
        ├── ... 
    ├── sample-data-part001.geojson
    ├── sample-data-part002.geojson
    ├── ... 
    ├── manifest.json # List of all GeoJSON chunks 
├── js/
    ├── main.js # Map logic and search behavior 
├── R-script/
    ├── convert_to_geojson_pointonly.R # R script to convert raw JSON to GeoJSON
├── tools/
    ├── make-manifest.js # Node script to generate manifest.json  
├── index.html # Main map interface 
├── README.md # Project documentation </pre>
