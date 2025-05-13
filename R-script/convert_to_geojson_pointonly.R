# convert_to_geojson_pointonly.R
# This script processes a directory of JSON files, extracts coordinate data,
# and outputs GeoJSON FeatureCollections split into ~10MB chunks.

library(jsonlite)

# Function to extract coordinates from a string using regex
parse_bbox <- function(s) {
  nums <- as.numeric(
    regmatches(s, gregexpr("-?\\d+\\.?\\d*", s, perl = TRUE))[[1]]
  )
  if (length(nums) >= 4) return(c(nums[1], nums[3]))   # Take first lon, first lat from bounding box
  if (length(nums) >= 2) return(nums[1:2])             # If already lon/lat, return as-is
  NULL                                                 # Return NULL if unusable
}

# Path to directory of raw IRMA JSON records
data_dir <- "." # Replace with your file path

# List all JSON files in the directory
json_files <- list.files(data_dir, "\\.json$", full.names = TRUE)
features   <- list() # Will hold all GeoJSON features

# Loop through each JSON file
for (f in json_files) {
  raw  <- readLines(f, warn = FALSE) # Read the file as lines
  
   # Try parsing as a JSON array first, fall back to line-by-line JSON objects
  recs <- tryCatch(fromJSON(paste(raw, collapse = "\n"), simplifyVector = FALSE),
                   error = function(e) NULL)
  if (is.null(recs)) recs <- lapply(raw, fromJSON, simplifyVector = FALSE)
  if (!is.list(recs[[1]]))
    recs <- lapply(seq_len(nrow(recs)), function(i) as.list(recs[i, ]))
  
  for (rec in recs) {
    # Extract coordinates from long_lat_display, fallback to long_lat
    pairs <- do.call(rbind, lapply(rec$long_lat_display, parse_bbox))
    if (is.null(pairs) || nrow(pairs) == 0) {
      pairs <- do.call(rbind, lapply(rec$long_lat, parse_bbox))
    }
    if (is.null(pairs) || nrow(pairs) == 0) next # Skip if no valid coordinates
    
    pairs <- unique(pairs) # Remove duplicates
    colnames(pairs) <- c("lon", "lat")

    # Create geometry: Point or MultiPoint
    geom <- if (nrow(pairs) == 1) {
      list(type = "Point", coordinates = as.numeric(pairs[1, ]))
    } else {
      list(type = "MultiPoint",
           coordinates = lapply(seq_len(nrow(pairs)),
                                function(i) as.numeric(pairs[i, ])))
    }
    
    # Keep all metadata except coordinate fields
    exclude <- c("long_lat", "long_lat_display")
    props <- rec[ setdiff(names(rec), exclude) ]    # drop those keys
    
    # Rename common keys for consistency
    if (!is.null(props$title)) {
      props$Title <- props$title
      props$title <- NULL
    }
    if (!is.null(props$url)) {
      props$Link  <- props$url
      props$url   <- NULL
    }

    # Add a GeoJSON Feature to the list
    features[[length(features) + 1L]] <- list(
      type       = "Feature",
      properties = props,
      geometry   = geom
    )
  }
}

# Define max size per output file (10 MB)
max_bytes <- 10L * 1024^2

# Estimate size of each feature in bytes
feat_bytes <- vapply(features, function(ft)
  nchar(jsonlite::toJSON(ft, auto_unbox = TRUE, pretty = FALSE), type = "bytes") + 2L,
  integer(1)
)

# Bucket features into groups based on size constraint
bucket <- cumsum(feat_bytes) %/% max_bytes + 1L   # 1, 2, 3, …

# Write each group of features into a separate .geojson file
invisible(Map(function(idx, chunk) {
  outfile <- sprintf("sample-data-part%03d.geojson", idx)
  writeLines(
    jsonlite::toJSON(
      list(type = "FeatureCollection", features = chunk),
      auto_unbox = TRUE, pretty = TRUE
    ),
    outfile
  )
}, sort(unique(bucket)), split(features, bucket)))

cat("Done – wrote", max(bucket), "file(s) under 20 MB each.\n")
