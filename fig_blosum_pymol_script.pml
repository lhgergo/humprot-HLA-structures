delete all

cd ~/Dokumentumok/LABOR/humprot-A0201-structures/data/dataset_preparation_1

########## creating figure for the LAGIGILTV-TLFDEPPPL pair
load pdb_files_experimental_separated_alignedtoref_260703/2GTW_2.pdb
load pdb_files_experimental_separated_alignedtoref_260703/8FU4_1.pdb

show cartoon
set cartoon_fancy_helices, 1

remove 8FU4_1 and not (chain A+C)
remove 2GTW_2 and not (chain D+F)

hide everything, 8FU4_1 and chain A
color grey90, 2GTW_2 and chain D
color yellow, 2GTW_2 and chain F
color blue, 8FU4_1 and chain C
remove solvent

bg_color white
set ray_opaque_background, off
hide labels
set internal_gui, 0
set ray_shadow, 0
turn x, -45
turn y, -170
turn z, -255
center 2GTW_2 and chain F
zoom 2GTW_2 and chain F, 15

show sticks, 2GTW_2 and chain F
show sticks, 8FU4_1 and chain C

png 2GTW_2_and_8FU4_1.png, width=2400, height=1800, ray=1

########## creating figure for the SLANTVATL-ILSALVGIV pair
load pdb_files_experimental_separated_alignedtoref_260703/1S8D_1.pdb
load pdb_files_experimental_separated_alignedtoref_260703/1EEY_2.pdb

align 1S8D_1.pdb and chain A, 2GTW_2 and chain D
align 1EEY_2.pdb and chain D, 2GTW_2 and chain D

remove 1S8D_1 and not (chain A+C)
remove 1EEY_2 and not (chain D+F)

hide everything, 1EEY_2 and chain D
hide everything, 2GTW_2
hide everything, 8FU4_1

color grey90, 1S8D_1 and chain A
color yellow, 1S8D_1 and chain C
color blue, 1EEY_2 and chain F
remove solvent

bg_color white
set ray_opaque_background, off
hide labels
set internal_gui, 0
set ray_shadow, 0
center 1S8D_1 and chain C
zoom 1S8D_1 and chain C, 12

show sticks, 1S8D_1 and chain C
show sticks, 1EEY_2 and chain F

png 1S8D_1_and_1EEY_2.png, width=2400, height=1800, ray=1
