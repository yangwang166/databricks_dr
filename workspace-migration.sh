#!/bin/bash

### MIGRATE FROM Source TO Target ######################################################
### Yang Wang (yang.wang@databricks.com)

### REQUIREMENTS ###############################################################
# - databricks cli tool installed and configured with workspaces to export from
# - clone of https://github.com/databrickslabs/migrate at a given path
# - `sudo python3 setup.py install` in cloned directory

### VARS #######################################################################
# the workspace profile mappings within .databrickscfg
# Format: ( <export-1>,<import-1> <export-2>,<import-2> <export-3>,<import-3> )
config_profiles=(
    source1,target1
)
# path where https://github.com/databrickslabs/migrate has been cloned
migrate_tool_path="/Users/yang.wang/git/migrate/"
# path where workspace assets are exports to
export_directory="/Users/yang.wang/git/migrate/backup/"

### EXPORT & IMPORT ############################################################
rm -rf $export_directory/
mkdir $export_directory
cd $migrate_tool_path

ws_export=source1
ws_import=target1

echo "EXPORTING FROM (${ws_export}) AND IMPORTING TO (${ws_import})"

# export
python3 export_db.py \
    --profile $ws_export \
    --set-export-dir $export_directory/$ws_export \
    --users \
    --clusters \
    --jobs \
    --workspace \
    --download \
    --workspace-acls \
    --metastore-unicode \
    --azure

# import
python3 import_db.py \
    --profile $ws_import \
    --set-export-dir $export_directory/$ws_export \
    --users \
    --clusters \
    --jobs \
    --workspace \
    --workspace-acls \
    --metastore-unicode \
    --get-repair-log \
    --pause-all-jobs \
    --azure

echo "---------------------------------------------------"
