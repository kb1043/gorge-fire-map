# Data Sources & Methodology

## Parcel Data

| Source | Records | Area |
|--------|---------|------|
| Original Google Sheets database (`gorge_residential_database_v4`) | 18,635 | Hood River, Wasco, Klickitat, Skamania counties |
| Klickitat County Assessor Parcels 2026 (ArcGIS) | 1,099 (new) | Burdoin fire vicinity |
| **Total** | **19,734** | |

**Klickitat County parcel source:**
`https://services9.arcgis.com/jOyAPi8TFd9XL78l/arcgis/rest/services/KlickitatParcels_2026/FeatureServer/0`
- Queried residential use codes (11, 12, 13, 14, 18, 19) within the Burdoin fire area bbox
- Fields used: PARCEL_NUM, ADDRESS, NAME, USECODE, ACRES, LAND, IMPRV, TOTAL_AV
- Centroid calculated from polygon ring vertices

## Fire Perimeters

All perimeters from **NIFC WFIGS Interagency Fire Perimeters** (public domain, US federal data):
`https://services3.arcgis.com/T4QMspbfLg3qTGWY/arcgis/rest/services/WFIGS_Interagency_Perimeters/FeatureServer/0`

| Fire | Year | Acres | Location | Cause |
|------|------|-------|----------|-------|
| Rowena | 2025 | 3,700 | 2 mi NW of The Dalles, Wasco Co, OR | Human |
| Burdoin | 2025 | 10,675 | 5 mi W of Lyle, Klickitat Co, WA | Human |
| Tunnel Five | 2023 | 529 | Skamania Co, WA | Human |
| Mosier Creek | 2020 | 985 | 2 mi S of Mosier, Wasco Co, OR | Human |
| Whisky Creek | 2024 | 3,240 | 6 mi SE of Cascade Locks, Hood River Co, OR | Human |
| Microwave Tower | 2024 | 1,314 | 1 mi WSW of Mosier, Hood River Co, OR | Human |
| Big Hollow | 2020 | 24,995 | Skamania Co, WA | Human |
| Wrentham Market | 2021 | 5,798 | 7 mi SE of The Dalles, Wasco Co, OR | Undetermined |

## Firewise USA® Sites

**Source:** NFPA Firewise USA® Sites In Good Standing (2024)
`https://services1.arcgis.com/0V03GIVRCAoxbtdR/arcgis/rest/services/Firewise_sites_In_Good_Standing_2024/FeatureServer/0`

- Queried State = 'OR' or 'WA'
- Filtered to Gorge-area counties + geographic bounding box (45.4–46.0 lat, -122.3 to -120.5 lng)
- 34 unique certified communities in/near the Gorge
- Fields: Name, City, County, State, ResidentCount, ApprovalYear, Status

## Wildfire Hazard Potential (WHP)

**Original parcels:** USFS Wildfire Hazard Potential 2023 (already populated in source database)
**New parcels (1,099):** Nearest-neighbor interpolation from existing WHP-classified parcels within the Burdoin area (2,713 reference points). Labeled as "Nearest-neighbor interpolation from USFS WHP 2023" in source field.

Classes: Non-burnable, Very Low, Low, Moderate, High, Very High

## Evacuation Zones (Corrected)

**Methodology:** Estimated proximity zones based on distance from NIFC fire perimeter:
- Level 3 (GO NOW) = inside fire perimeter
- Level 2 (BE SET) = within 1.5 miles of perimeter
- Level 1 (BE READY) = within 5 miles of perimeter

**Correction applied:** Evacuation zone estimates are now limited to the fire's origin state:
- Burdoin zones: Washington parcels only (fire was in Klickitat County, WA)
- Rowena zones: Oregon parcels only (fire was in Wasco County, OR)

**Rationale:** The original database applied a simple buffer regardless of state boundaries. The Columbia River forms a natural barrier, and actual evacuation orders are issued by individual county emergency management agencies within their jurisdiction. Oregon counties did not issue evacuation orders for the Burdoin fire (WA), and vice versa.

⚠️ **These are NOT official evacuation orders.** They are modeled proximity estimates. Actual evacuation orders come from county emergency management and may differ significantly.

## Distance to Fire

Calculated as haversine distance (miles) from parcel centroid to nearest point on fire perimeter polygon. Negative values indicate the parcel is inside the burn perimeter.

## Burn Area Status

Point-in-polygon test: parcel centroid tested against fire perimeter polygon using ray-casting algorithm. Source: NIFC WFIGS perimeter polygons.
