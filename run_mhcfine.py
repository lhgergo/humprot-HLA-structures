##################################################
import torch
if not torch.cuda.is_available():
    print("Please check your setup of GPU.")

from src import preprocess, model
import pandas as pd
import os
import gdown

# Load the model
model_path = "data/model/mhc_fine_weights.pt"
if not os.path.exists(model_path):
    file_id = "1gz8uF8DKE0CzyX_WeDGOX7xP69LjpaZT"
    gdown.download(f"https://drive.google.com/uc?id={file_id}", model_path)

# Make msa generator executable
#!chmod +x a3m_generation/msa_run #to be done manually

# setting the input file
input_df = pd.read_csv("/scratch/mmanczinger/mhc-fine/mhcfine_input_humprot_A0201_SB.csv")

# removing entries from the input_df that are already done
import os

# Define the output directory
output_dir = "/scratch/mmanczinger/mhc-fine/output/"  # Replace with your actual output directory

# Add ".pdb" to the end of each value in the "unique_id" column
input_df["filenames"] = input_df["unique_id"].astype(str) + ".pdb"

# Get a list of existing files in the output directory
existing_files = {f for f in os.listdir(output_dir) if os.path.isfile(os.path.join(output_dir, f))}

# Filter the DataFrame to keep only entries whose "unique_id" is not in the existing files
input_df = input_df[~input_df["filenames"].isin(existing_files)]

# enhanced code (by ChatGPT) ensuring the continuous run of predictions even if encountering errors
for index, row in input_df.iterrows():
    unique_id = row[0]
    protein_sequence = row[1]
    peptide_sequence = row[2]

    try:
        # generate or perform MSA data
        a3m_path = os.path.join(os.getcwd(), 'data', 'msa', unique_id, 'mmseqs', 'aggregated.a3m')
        if not os.path.exists(a3m_path):
            preprocess.get_a3m(protein_sequence, a3m_path, unique_id)

        # preprocess data
        np_sample = preprocess.preprocess_for_inference(protein_sequence, peptide_sequence, a3m_path)

        # run alphafold
        my_model = model.Model()
        my_model.inference(np_sample, unique_id)

    except Exception as e:
        print(f"⚠️ Error at row {index} (ID={unique_id}): {e}")
        continue  # skip to next row
