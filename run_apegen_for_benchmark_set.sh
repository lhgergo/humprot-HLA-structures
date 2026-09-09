#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <path_to_csv_file>"
    exit 1
fi

CSV_FILE="$1"
OUTPUT_BASE_DIR="outputs"

# Check if the file actually exists
if [ ! -f "$CSV_FILE" ]; then
    echo "Error: File '$CSV_FILE' not found."
    exit 1
fi

# Ensure the base outputs directory exists
mkdir -p "$OUTPUT_BASE_DIR"

# Loop through the CSV file line by line
while IFS=',' read -r peptide allele || [ -n "$peptide" ]; do
    
    # Strip any potential carriage returns (\r) from Windows-formatted CSVs and trim spaces
    peptide=$(echo "$peptide" | tr -d '\r' | xargs)
    allele=$(echo "$allele" | tr -d '\r' | xargs)

    # Skip the header row or empty lines
    if [[ "$peptide" == "peptide" || -z "$peptide" || -z "$allele" ]]; then
        continue
    fi

    echo "--------------------------------------------------"
    echo "Processing: Peptide=$peptide, Allele=$allele"
    echo "--------------------------------------------------"

    # Safety step: Ensure structure exists before running python, just in case
    mkdir -p intermediate_files/results
    mkdir -p intermediate_files/MODELLER_output

    # Execute the python command
    python New_APE-Gen.py "$peptide" "$allele" --verbose

    # Sanitize the allele name to replace special characters (like * or :) with underscores 
    sanitized_allele=$(echo "$allele" | tr '*:' '_')
    folder_name="${sanitized_allele}_${peptide}"

    # Check if intermediate_files exists before trying to move it
    if [ -d "intermediate_files" ]; then
        echo "Moving intermediate files to ${OUTPUT_BASE_DIR}/${folder_name}..."
        
        # 1. Move intermediate_files to outputs/<allele>_<peptide>
        mv intermediate_files "$OUTPUT_BASE_DIR/$folder_name"
        
        # 2. Remove the old intermediate_files directory (if mv left any lingering artifacts)
        rm -rf intermediate_files
        
        # 3. Create a fresh intermediate_files directory with its required sub-folders
        mkdir -p intermediate_files/results
        mkdir -p intermediate_files/MODELLER_output
    else
        echo "Warning: intermediate_files directory not found for this run."
        # If it magically vanished, recreate it for the next run safely
        mkdir -p intermediate_files/results
        mkdir -p intermediate_files/MODELLER_output
    fi

done < "$CSV_FILE"

echo "--------------------------------------------------"
echo "All runs completed successfully!"