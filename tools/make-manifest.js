// make-manifest.js
// Generates a manifest.json listing all .geojson files in the /data directory

const fs = require("fs");
const path = require("path");

// Define the path to the /data folder
const dataDir = path.resolve(__dirname, "../data");

// Read all .geojson files in /data and prefix with "data/" for relative pathing
const files = fs
  .readdirSync(dataDir)
  .filter((f) => f.toLowerCase().endsWith(".geojson"))
  .map((f) => `data/${f}`);

// Write the file list to manifest.json in the same directory
fs.writeFileSync(
  path.join(dataDir, "manifest.json"),
  JSON.stringify(files, null, 2)
);

console.log(`✔  Wrote data/manifest.json with ${files.length} files`);
