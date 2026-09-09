# NOTE: pymol is required for 3D structure alignment and figure generation
pymol.align <- function(pdbpath_ref, pdbpath_target, outpath, alpha_chain_ref = "A", alpha_chain_target = "A", ignore.stdout = T, return_command = FALSE) {
  pymol_cmds_vec <- c(
    paste0("cd ", getwd()),
    paste0("load ", pdbpath_ref, ", struct_ref"),
    paste0("load ", pdbpath_target, ", struct_target"),
    paste0("align struct_target and chain ", alpha_chain_target,
           ", struct_ref and chain ", alpha_chain_ref,
           ",quiet=1"),
    paste0("save ", outpath, ", struct_target")
  )
  
  pymol_cmd_whole <- pymol_cmds_vec %>% paste0(collapse = "; ")
  cmd <- paste0('pymol -cq -d "', pymol_cmd_whole, '"')
  system(cmd, ignore.stdout = ignore.stdout)
  
  if(return_command) return(cmd)
}

# pymol.align.subseq: a variant of the pymol.align function that identifies a specific region of the HLA structures to be kept for alignment
pymol.align.subseq <- function(pdbpath_ref, pdbpath_target, outpath,
                               subseq,
                               alpha_chain_ref = "A", alpha_chain_target = "A",
                               ignore.stdout = T, return_command = FALSE) {
  
  # identifying the important sequence range
  pdbobj_ref <- bio3d::read.pdb(pdbpath_ref)
  pdbobj_target <- bio3d::read.pdb(pdbpath_target)
  
  hlaseq_ref <- bio3d::trim.pdb(pdbobj_ref,
                                pdbobj_ref %>% atom.select(chain = alpha_chain_ref)) %>%
    pdbseq() %>% paste0(collapse = "") %>% Biostrings::AAStringSet()
  hlaseq_target <- bio3d::trim.pdb(pdbobj_target,
                                   pdbobj_target %>% atom.select(chain = alpha_chain_target)) %>%
    pdbseq() %>% paste0(collapse = "") %>% Biostrings::AAStringSet()
  
  algnobj_ref <- pwalign::pairwiseAlignment(subseq, hlaseq_ref)
  algnobj_target <- pwalign::pairwiseAlignment(subseq, hlaseq_target)
  
  aacords_ref <- pwalign::as.matrix(algnobj_ref) %>% as.vector %>% equals("-") %>% `!`() %>% which
  aacords_target <- pwalign::as.matrix(algnobj_target) %>% as.vector %>% equals("-") %>% `!`() %>% which
  
  startpos_ref <- aacords_ref %>% min
  endpos_ref <- aacords_ref %>% max
  startpos_target <- aacords_target %>% min
  endpos_target <- aacords_target %>% max
  
  pymol_cmds_vec <- c(
    paste0("cd ", getwd()),
    paste0("load ", pdbpath_ref, ", struct_ref"),
    paste0("load ", pdbpath_target, ", struct_target"),
    paste0("align struct_target and chain ", alpha_chain_target,
           " and resi ", startpos_target, "-", endpos_target,
           
           ", struct_ref and chain ", alpha_chain_ref, " and resi ", startpos_ref, "-", endpos_ref,
           ", quiet=1"),
    paste0("save ", outpath, ", struct_target")
  )
  
  pymol_cmd_whole <- pymol_cmds_vec %>% paste0(collapse = "; ")
  
  cmd <- paste0('pymol -cq -d "', pymol_cmd_whole, '"')
  system(cmd, ignore.stdout = ignore.stdout)
  
  if(return_command) return(cmd)
}

RMSD.pdb <- function(x, y, path_input = TRUE, fit = TRUE, elety = NULL, type = NULL, string = NULL, chain_x = NULL, chain_y = NULL) {
  if(path_input) {
    pdbobj_x <- bio3d::read.pdb(x)
    pdbobj_y <- bio3d::read.pdb(y)
  } else {
    pdbobj_x <- x
    pdbobj_y <- y
  }
  
  if(!is.null(elety)) {
    pdbobj_x <- bio3d::trim.pdb(pdbobj_x, bio3d::atom.select(pdbobj_x, elety = elety, chain = chain_x, type = type, string = string))
    pdbobj_y <- bio3d::trim.pdb(pdbobj_y, bio3d::atom.select(pdbobj_y, elety = elety, chain = chain_y, type = type, string = string))
  }
  
  bio3d::rmsd(pdbobj_x, pdbobj_y, fit = fit)
}

CalcSeqSim.jl <- function(x, y, mtx) {
  if(length(x) == 1) {
    JuliaCall::julia_call(func_name = "CalcSeqSim", x, y, mtx)
  } else {
    JuliaCall::julia_call(func_name = "CalcSeqSim.", x, y, list(mtx)) # use vectorization upon multiple sequences in input
  }
}

# based on https://stackoverflow.com/questions/61749815/convert-scientific-notation-e-to-10y-with-superscripts-in-geom-text
expSup <- function(w, digits = 0) {
  ifelse(w == 0, "0", 
         sprintf(paste0("%.", digits, "f %%*%% 10^%d"), 
                 w / 10^floor(log10(abs(w))), 
                 as.integer(floor(log10(abs(w))))) # Convert to integer here
  )
}

PrettyPvalues <- function(pval, digits = 3, var_name = "italic(P)", only_number = FALSE) {
  if (pval == 0) {
    outval <- paste0('paste("2.2 x", 10 ^ -16)')
  } else if(pval < 1e-03) {
    pval_str <- pval %>% format(digits = digits, scientific = TRUE)
    pval_components <- pval_str %>% strsplit("e-") %>% unlist()
    if(pval_components[1] == "1") pval_components[1] <- "1.0"
    outval <- paste0('paste(', pval_components[1], ', " x ", 10 ^ -', pval_components[2], ')')
    
  } else {
    pval_str <- round(pval, digits = 3) %>% as.character
    outval <- paste0('paste(', pval_str, ')')
  }
  
  if(!only_number) {
    # outval <- outval %>% gsub("paste\\(", "", .) %>% paste0('paste(italic(', var_name, '), " = ", ', .)
    outval <- outval %>% gsub("paste\\(", "", .) %>% paste0('paste(', var_name, ', " = ", ', .)
    if(pval == 0) outval %<>% gsub("=", "<", .)
  }
  
  return(outval)
}

PrettyPvalues <- Vectorize(PrettyPvalues, vectorize.args = "pval")
