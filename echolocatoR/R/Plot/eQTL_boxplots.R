
createDT <- function(DF, caption="", scrollY=400){
  data <- DT::datatable(DF, caption=caption,
                        extensions = 'Buttons',
                        options = list( dom = 'Bfrtip',
                                        buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
                                        scrollY = scrollY, scrollX=T, scrollCollapse = T, paging = F,
                                        columnDefs = list(list(className = 'dt-center', targets = "_all"))
                        )
  )
  return(data)
}

subset_genotype_data <- function(snp_list, 
                                 genotype_path = "/sc/orga/projects/ad-omics/data/fairfax/volunteer_421.impute2.dosage", sep=" "){  
  # NOTE: "volunteer_421.impute2.dosage" is the file you want to subset from! 
  printer("Extracting subset of SNPs from",genotype_path)
    if(endsWith(genotype_path,".gz")){
      printer("Unzipping with zcat first...")
      cmd <- paste0("zcat ",genotype_path," | grep -E '",paste0(snp_list %>% unique(), collapse="|"),"'") 
    }
   cmd <- paste0("grep -E '",paste0(snp_list %>% unique(), collapse="|"),"' ", genotype_path)
   geno <- data.table::fread(text = system(cmd, intern = T),
                               sep = sep, header = F) 
  return(geno)
}

## Get probe IDs for gene 
probes_mapping <- function(probe_path.="./Data/QTL/Fairfax_2014/gene.ILMN.map", gene_list){
  printer("++ Extracting probe info")
  cmd <- paste0("grep -E '", paste0(gene_list, collapse="|"),"' ",probe_path.)
  col_names <- data.table::fread(probe_path., sep="\t", nrows = 0) %>% colnames()
  probe_map <- data.table::fread(text = system(cmd, intern = T), 
                                 sep = "\t", header = F, col.names = col_names)
  if(dim(probe_map)[1]==0){
    stop("Could not identify gene in the probe mapping file: ",paste(gene_list, collapse=", "))
  }
  # Subset just to make sure you didn't accidentally grep other genes
  probe_map <- subset(probe_map, GENE %in% gene_list)
  return(probe_map)
}
 
eQTL_boxplots <- function(snp_list,
                         eQTL_SS_paths = file.path("Data/eQTL/Fairfax_2014",
                                                   c("CD14/LRRK2/LRRK2_Fairfax_CD14.txt",
                                                     "IFN/LRRK2/LRRK2_Fairfax_IFN.txt",
                                                     "LPS2/LRRK2/LRRK2_Fairfax_LPS2.txt",
                                                     "LPS24/LRRK2/LRRK2_Fairfax_LPS24.txt")),
                         expression_paths = file.path("Data/eQTL/Fairfax_2014",
                                                      c("CD14/CD14.47231.414.b.txt",
                                                        "IFN/IFN.47231.367.b.txt",
                                                        "LPS2/LPS2.47231.261.b.txt",
                                                        "LPS24/LPS24.47231.322.b.txt")),
                         genotype_path = "Data/eQTL/Fairfax_2014/geno.subset.txt", 
                         subset_genotype_file = F,
                         probe_path = "Data/eQTL/Fairfax_2014/gene.ILMN.map",
                         .fam_path = "Data/eQTL/Fairfax_2014/volunteers_421.fam",
                         gene = "LRRK2",
                         show_plot = T,
                         SS_annotations = T,
                         interact = T){
  # Helper function
  printer <- function(..., v=T){if(v){print(paste(...))}}
  
  # Expression
  
  ## Subset expression data
  get_expression_data <- function(expression_paths, gene., probe_path){
    printer("")
    printer("+ Processsing Expression data")
    # Find which probes for search for 
    probe_map <- probes_mapping(probe_path. = probe_path, gene_list = gene.)
    probe_list <- probe_map$PROBE_ID %>% unique()
    # Find the subjects that exist in all datasets
    # common_subjects <- lapply(expression_paths, function(x){
    #   col_names <- data.table::fread(x, sep="\t", header = T, nrows = 0) %>% colnames() 
    #   col_names <- col_names[-1]
    # }) 
    # Reduce(intersect, common_subjects)
    
    exp_dat <- lapply(expression_paths, function(x, gene.= gene, probe_list.=probe_list){
      condition = basename(dirname(x))
      printer("++",condition) 
      # grep rows with the probe names
      cmd <- paste0("grep -E '", paste0(probe_list., collapse="|"),"' ",x)
      col_names <- data.table::fread(x, sep="\t", header = T, nrows = 0) %>% colnames()
      exprs <- data.table::fread(text = system(cmd, intern = T), 
                                 sep = "\t", header = F, col.names = col_names)
      ## Subset just to be sure contains probes
      exp_sub <- subset(exprs, PROBE_ID %in% probe_list.)
      # Add condition col
      exp_sub <- cbind( data.table::data.table(Condition = condition), exp_sub)
      # Melt subject IDs into single column
      subjects_IDs <- colnames(exp_sub)[!colnames(exp_sub) %in% c("Condition", "PROBE_ID")]
      exp_melt <- reshape2::melt(exp_sub, id.vars = c("Condition", "PROBE_ID"), 
                                 measure.vars = subjects_IDs,
                                 variable.name = "Subject_ID", 
                                 value.name = "Expression")
    }) %>% data.table::rbindlist() 
    # Only use the probe with the highest average expression across individuals
    probe_means <- exp_dat %>% dplyr::group_by(PROBE_ID) %>% summarise(meanExp = mean(Expression))
    winning_probe <- subset(probe_means,  meanExp == max(meanExp))$PROBE_ID
    exp_dat <- subset(exp_dat, PROBE_ID == winning_probe)
    return(exp_dat)
  } 
  exp_data <- get_expression_data(expression_paths, gene, probe_path)
  
  # eQTL SUMMARY STATS
  get_SumStats_data <- function(eQTL_SS_paths, gene){
    printer("")
    printer("+ Processing Summary Stats data")
    SS <- lapply(eQTL_SS_paths, function(qx, gene.=gene){
      dat <- data.table::fread(qx, sep="\t", header=T) 
      condition <- basename(dirname(dirname(qx))) 
      dat <- dat %>% dplyr::rename(PROBE_ID="gene", Effect="beta", P="p-value")
      dat <- cbind(data.table::data.table(Condition = condition, Gene = gene.),
                   dat)
    }) %>% data.table::rbindlist()
    return(SS)
  }
  SS_data <- get_SumStats_data(eQTL_SS_paths, gene)
  # IMPORTANT! Subset according to the probes in the expression data.
  SS_data <- subset(SS_data, PROBE_ID == exp_data$PROBE_ID %>% unique() )
  
  # GENOTYPE 
  get_genotype_data <- function(genotype_path, .fam_path, subset_genotype_file = F, probe_ID. = NA){
    printer("")
    printer("+ Processing Genotype data") 
    if(subset_genotype_file){
      geno_subset <- subset_genotype_data(probe_ID. = probe_ID)
    } else { 
      geno_subset <- data.table::fread(genotype_path, sep=" ", header=F, stringsAsFactors = F)
    }
    # Add column names
    first_cols <- c("CHR","SNP","POS","A1","A2") 
    subject_IDs <- data.table::fread(.fam_path, stringsAsFactors = F)$V1
    colnames(geno_subset) <- c(first_cols,  subject_IDs) 
    ## Melt subject IDs into single column
    geno_melt <- geno_subset %>% reshape2::melt(geno_subset, id.vars = c("CHR","SNP","POS","A1","A2"),
                                                measure.vars = as.character(subject_IDs),
                                                variable.name = "Subject_ID", 
                                                value.name = "Genotype" ) %>% 
      dplyr::mutate(Genotype = round(as.numeric(Genotype),0) %>% as.factor())
    # Translate numeric genotypes to letters 
    # geno_melt <- geno_melt %>%  dplyr::rename(Genotype_int = Genotype) %>% 
    #   dplyr::mutate(Genotype = ifelse(Genotype_int == 0, paste0(A1,"/",A1),
    #                                   ifelse(Genotype_int == 1, paste0(A1,"/",A2),
    #                                          ifelse(Genotype_int == 2, paste0(A2,"/",A2), NA))) )
    return(geno_melt)
  }
  geno_data <- get_genotype_data(genotype_path, .fam_path, probe_ID. = unique(SS_data$PROBE_ID))
  
  
  
  
  # MERGE: SS + EXP + GENO
  merge_SS.EXP.GENO <- function(SS_data, geno_data, exp_data){
    printer("")
    printer("+ Merging Summary Stats, Genotype, and Expression data")
    ## SS + Genotype
    SS_geno <- data.table:::merge.data.table(SS_data[,c("Gene","CHR","POS","Condition","Effect","t-stat","P","FDR")],
                                  geno_data,
                                  by = c("CHR","POS"))
    ## SS/Genotype + Expression
    SS_geno_exp <- data.table:::merge.data.table(SS_geno, 
                                                 exp_data,
                                                 by = c("Condition","Subject_ID")) 
    # SS_geno_exp <- dplyr::mutate(SS_geno_exp, Expression = Expression %>% as.numeric()) 
    return(SS_geno_exp)
  }
  SS_geno_exp <- merge_SS.EXP.GENO(SS_data, geno_data, exp_data)
  
   
  
  if(show_plot){
    printer("")
    printer("+ Plotting eQTLs")
    # Get 1 effect size per Condition x SNP combination
    d <- 4
    labels <- subset(SS_geno_exp , select = c("CHR","POS","PROBE_ID","Condition","SNP","Effect","P","FDR")) %>%  
      dplyr::mutate(FDR_sig = ifelse(as.numeric(FDR) < 1.34e-05, "FDR < 1.34e-05**",paste0("FDR = ", formatC(FDR, format = "e", digits = 2))),
                    FDR_scient = paste0("FDR = ", formatC(FDR, format = "e", digits = 2), ifelse(as.numeric(FDR) < 1.34e-05, "**","") ),
                    P_sig = ifelse(as.numeric(P) < 0.05, "P < 0.05",paste0("P = ", formatC(P, format = "e", digits = 2))),
                    Beta = format(round(Effect,d), nsmall=d), 
                    P = paste("P =",formatC(P, format = "e", digits = 2)),
                    FDR = paste("FDR =",formatC(FDR, format = "e", digits = 2))
                                ) %>% 
      arrange(SNP, Condition) %>% 
      unique()  
    
    bp <- ggplot(data = SS_geno_exp, aes(x = Genotype, y = Expression, fill=SNP)) + 
      geom_boxplot(show.legend = F) + 
      geom_jitter(aes(alpha=.5), width =.2,  show.legend = F) +  
      facet_grid(facets = SNP~Condition) + 
      theme_bw()
    if(SS_annotations){
      bp <- bp + annotate("text", label = paste("Beta =",labels$Beta,";", labels$P,";",labels$FDR_scient), 
               size = 4, x = 2, y = 7.5)
    }
    
    if(interact){
     print(plotly::ggplotly(bp)) 
    } else {
      print(bp) 
    }
   
  } 
  return(SS_geno_exp)
}
