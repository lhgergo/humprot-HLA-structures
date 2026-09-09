delete all

cd ~/Dokumentumok/LABOR/humprot-A0201-structures/data/dataset_preparation_1
load pdb_files_experimental_separated_aligned_260703/7KGO_1.pdb
load mhcfine_output_pdbdb_review_260703/A0201.ILLNKHIDA.pdb

show cartoon
set cartoon_fancy_helices, 1

hide everything, 7KGO_1 and chain A+B
color grey90, A0201.ILLNKHIDA and chain A
color yellow, A0201.ILLNKHIDA and chain B
color blue, 7KGO_1 and chain C
remove solvent

bg_color white
set ray_opaque_background, off
hide labels
set internal_gui, 0
set ray_shadow, 0
turn x, 140
turn z, 180
turn y, 20
center A0201.ILLNKHIDA and chain B
zoom A0201.ILLNKHIDA and chain B, 15

show sticks, 7KGO_1 and chain C
show sticks, A0201.ILLNKHIDA and chain B

png 7KGO_1_ILLNKHIDA.png, width=2400, height=1800, ray=1

load pdb_files_experimental_separated_aligned_260703/7UM2_1.pdb
load mhcfine_output_pdbdb_review_260703/A0201.TIADYNYKL.pdb

align 7UM2_1 and chain A, A0201.ILLNKHIDA and chain A
align A0201.TIADYNYKL and chain A, A0201.ILLNKHIDA and chain A
remove solvent
hide everything, 7UM2_1 and chain A+B
hide everything, A0201.ILLNKHIDA
hide everything, 7KGO_1
color grey90, A0201.TIADYNYKL and chain A
color yellow, A0201.TIADYNYKL and chain B
remove hetero
remove resn GOL
color blue, 7UM2_1 and chain C

center A0201.ILLNKHIDA and chain B
zoom A0201.ILLNKHIDA and chain B, 15

show sticks, 7UM2_1 and chain C
show sticks, A0201.TIADYNYKL and chain B

png 7UM2_1_TIADYNYKL.png, width=2400, height=1800, ray=1
