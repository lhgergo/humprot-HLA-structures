delete all

cd ~/Dokumentumok/LABOR/humprot-A0201-structures/data/dataset_preparation_1
load pdb_files_experimental_separated_aligned_260703/7JYW_1.pdb
load mhcfine_output_pdbdb_review_260703/A2402.TYQWIIRNW.pdb

show cartoon
set cartoon_fancy_helices, 1

hide everything, 7JYW_1 and chain A+B
color grey90, A2402.TYQWIIRNW and chain A
color yellow, A2402.TYQWIIRNW and chain B
color blue, 7JYW_1 and chain C
remove solvent

bg_color white
set ray_opaque_background, off
hide labels
set internal_gui, 0
set ray_shadow, 0
turn x, 140
turn z, 180
turn y, 20
center A2402.TYQWIIRNW and chain B
zoom A2402.TYQWIIRNW and chain B, 15

show sticks, 7JYW_1 and chain C
show sticks, A2402.TYQWIIRNW and chain B

png 7JYW_1_TYQWIIRNW.png, width=2400, height=1800, ray=1

load pdb_files_experimental_separated_aligned_260703/7JYV_1.pdb
load mhcfine_output_pdbdb_review_260703/A2402.YFSPIRVTF.pdb

align 7JYV_1 and chain A, A2402.TYQWIIRNW and chain A
align A2402.YFSPIRVTF and chain A, A2402.TYQWIIRNW and chain A
remove solvent
hide everything, 7JYV_1 and chain A+B
hide everything, A2402.TYQWIIRNW
hide everything, 7JYW_1
color grey90, A2402.YFSPIRVTF and chain A
color yellow, A2402.YFSPIRVTF and chain B
remove hetero
remove resn GOL
color blue, 7JYV_1 and chain C

center A2402.TYQWIIRNW and chain B
zoom A2402.TYQWIIRNW and chain B, 15

show sticks, 7JYV_1 and chain C
show sticks, A2402.YFSPIRVTF and chain B

png 7JYV_1_YLQPRTFLL.png, width=2400, height=1800, ray=1
