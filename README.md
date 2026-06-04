# Columbia River Gorge Fire Risk Interactive Web Map

An interactive web map visualizing 18,636 residential parcels in the Columbia River Gorge (OR/WA) overlaid with the 2025 Rowena and Burdoin fire perimeters.

## Data Sources

| Layer | Source | Records |
|-------|--------|---------|
| Parcels | [Google Sheets database](https://docs.google.com/spreadsheets/d/15T5S3f32aadp03fOdL-AYRf2p02wgLsC0BWDKFz8wEU/) | 18,636 |
| Rowena Fire perimeter | [NIFC WFIGS](https://data-nifc.opendata.arcgis.com/datasets/nifc::wfigs-interagency-fire-perimeters) | 3,700 acres |
| Burdoin Fire perimeter | [NIFC WFIGS](https://data-nifc.opendata.arcgis.com/datasets/nifc::wfigs-interagency-fire-perimeters) | 10,675 acres |

## Fire Details (from NIFC/IRWIN)

**Rowena Fire (2025)**
- Location: 2 miles NW of The Dalles, OR (Wasco County)
- Size: 3,700 acres | Cause: Human
- Containment: 99% | Cost: $9.3M
- Discovery: June 11, 2025

**Burdoin Fire (2025)**
- Location: 5 miles W of Lyle, WA (Klickitat County)
- Size: 10,675 acres | Cause: Human
- Containment: 95% | Cost: $19.2M
- Discovery: July 18, 2025

## How to Run

### Option A: Local (simplest)
```bash
cd fire-gis-map
python3 -m http.server 8080
# Open http://localhost:8080
```

### Option B: Deploy to GitHub Pages
```bash
# Push this folder to a GitHub repo, enable Pages on main branch
# All files are static — no server needed
```

### Option C: Deploy to Netlify/Vercel
Drop the `fire-gis-map/` folder into Netlify or Vercel. Zero config needed.

## Features

- **Interactive parcels**: Click any parcel to see address, fire risk, evacuation zone, damage level, assessed value
- **Fire perimeters**: Rowena (red) and Burdoin (purple) final perimeters from NIFC
- **Color coding**: Switch between Wildfire Hazard Potential, evacuation zones, burn areas, or county
- **Multiple basemaps**: Street, Satellite (Esri), Topographic
- **Layer toggles**: Show/hide parcels and each fire perimeter independently

## Files

| File | Description | Size |
|------|-------------|------|
| `index.html` | Complete web map (Leaflet + all UI) | 17 KB |
| `parcels_web.geojson` | Optimized parcel points (key fields only) | 6.4 MB |
| `parcels.geojson` | Full parcel GeoJSON (all fields, no source cols) | 18 MB |
| `gorge_residential_database.csv` | Raw CSV export from Google Sheets | 33 MB |
| `rowena_perimeter.geojson` | Rowena fire perimeter from NIFC WFIGS | 167 KB |
| `burdoin_perimeter.geojson` | Burdoin fire perimeter from NIFC WFIGS | 359 KB |
| `fetch_perimeters.sh` | Script to re-fetch perimeters from NIFC API | 1 KB |

## How It Was Built

1. **Exported parcel data** from the Google Sheet's `gorge_residential_database_v4` tab (18,636 rows with lat/lng, fire risk, evacuation zones, etc.)
2. **Converted to GeoJSON** using Python — each row becomes a Point feature with its lat/lng
3. **Fetched fire perimeters** from NIFC's public ArcGIS Feature Service (WFIGS Interagency Fire Perimeters) as GeoJSON
4. **Built interactive map** with Leaflet.js — no accounts, API keys, or server infrastructure needed

## Do You Need a GIS Account?

**No.** This setup is entirely free and account-free:
- Leaflet.js is open-source (BSD)
- OpenStreetMap tiles are free
- NIFC fire data is public domain (US government)
- No Mapbox/Google/Esri account required for the base functionality

If you want to add features later:
- **Mapbox** (free tier: 50K map loads/mo) — nicer styles, vector tiles for faster rendering
- **ArcGIS Online** (free public account) — if you want to use Esri's ecosystem
- **QGIS** (free desktop GIS) — for advanced spatial analysis offline

## Performance Notes

With 18,636 points, the map loads in ~2-3 seconds on modern hardware. If you need faster:
- Use Mapbox GL JS with vector tiles (renders on GPU)
- Convert to PMTiles format for static hosting
- Use clustering at lower zoom levels (already supported by the code structure)

## Updating the Data

To refresh fire perimeters (e.g., if fires are still active):
```bash
bash fetch_perimeters.sh
```

To re-export parcel data from Google Sheets:
```bash
python3 -c "
import urllib.request
url = 'https://docs.google.com/spreadsheets/d/15T5S3f32aadp03fOdL-AYRf2p02wgLsC0BWDKFz8wEU/gviz/tq?tqx=out:csv&sheet=gorge_residential_database_v4'
data = urllib.request.urlopen(url).read().decode('utf-8')
open('gorge_residential_database.csv', 'w').write(data)
"
```
