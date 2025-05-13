# NPS Library Interactive Map

This project is an interactive web map for exploring National Park Service (NPS) digital library records using spatial search. Inspired by [Open Parks Network](https://openparksnetwork.org/map/), it allows users to search by keyword and view associated metadata on a map.

## Live Map

You can view the interactive map at:

**[https://dutcherj.github.io/nps-library-map/](https://dutcherj.github.io/nps-library-map/)** 


## Screenshots

### Full Map View
<img src="https://drive.google.com/uc?export=view&id=1GWcGjOnQqATqjrnYjuYfdjMVe4noIVde" alt="QR Code" width="1000"/>

### Search Results Example
<img src="https://drive.google.com/uc?export=view&id=1gNaiFcW-DkJ6Yq90y0TZ_X46A5Q-z01g" alt="QR Code" width="1000"/>

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

## How It Works

### 1. Convert & Split Source Data

- Raw JSON files were processed using `convert_to_geojson_pointonly.R`.
- Each record was converted into a GeoJSON `Feature` with a `Point` or `MultiPoint` geometry.
- Resulting files were split into a maximum of 10MB chunks to meet GitHub's file limitions.

### 2. Build a Manifest

- `make-manifest.js` scans the `data/` folder and lists all `.geojson` files in a single `manifest.json`.
- This allows the map to dynamically load and merge all spatial records.

### 3. Map & Search Interface

- Built with [Leaflet](https://leafletjs.com/) and [ESRI Leaflet](https://developers.arcgis.com/esri-leaflet/).
- Users can search for any keyword in record titles.
- Matching features are displayed as clickable map markers.
- Metadata is shown in popups with optional links.

## Getting Started

1. **Clone this repo** or download the ZIP.
2. Make sure all files are in place, including:
   - The `data/` folder with `.geojson` chunks and `manifest.json`
   - The `js/main.js` and `index.html`
3. Open `index.html` in any modern browser.

## Searching the Map

- Type a keyword into the search box (e.g., "wolf" or "mercury").
- Press `Enter` or click **Search**.
- Only matching results will be shown on the map.
- Click markers to view full metadata.

## Who This Is For

- NPS and library staff seeking spatial access to digital holdings
- Researchers and public users exploring historical documents
- Developers looking to adapt or extend this open-source, browser-based map

## Dependencies

This tool uses the following external libraries (loaded via CDN):

- [Leaflet](https://leafletjs.com/)
- [Leaflet Draw](https://github.com/Leaflet/Leaflet.draw)
- [ESRI Leaflet](https://developers.arcgis.com/esri-leaflet/)
- [Leaflet MarkerCluster](https://github.com/Leaflet/Leaflet.markercluster)

## Optional Scripts

If modifying the dataset:

- Run the R script `convert_to_geojson_pointonly.R` to regenerate GeoJSON from raw JSON.
- Run `node tools/make-manifest.js` to update the manifest list after adding or removing `.geojson` files.

## Acknowledgments

- Modeled after the excellent work done by the [Open Parks Network](https://openparksnetwork.org/)
- Built using open-source libraries and publicly available basemaps

