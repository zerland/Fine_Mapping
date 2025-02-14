# Fine_Mapping

#### echolocatoR is an open-source R library that wraps, integrates and extends several commonly used genetic and functional fine mapping tools, as well as annotation and enrichment tools. 
#### Here, we fine-map loci from recent GWAS to identify causal genetic variants that have been previously associated with Parkinson's Disease (PD) or Alzheimer's Disease (PD).  
#### All data and results can viewed and downloaded via the following interactive Rmarkdown output files below.  


<hr><hr>

## Download
### Clone github repo
`git clone https://github.com/RajLabMSSM/Fine_Mapping.git`  

## Clone submodule repos  
```
git submodule init 
git submodule update
```



## Current Results  

### Parkinson's Disease  

#### [Fine-mapping 78 + PolyFun & UKBiobank LD](https://rajlabmssm.github.io/Fine_Mapping/Fine_Mapping_PD_results.html) 
#### [Genetic Fine-mapping 78 Loci](https://rajlabmssm.github.io/Fine_Mapping/Fine_Mapping_PD.html) 
- Most recent version of fine-mapping, on all 78 loci. Note that currently the plots are shifted over a tab or two from their respective loci (working on fixing this).  
#### [Functional Fine-mapping of LRRK2 Locus](https://rajlabmssm.github.io/Fine_Mapping/Fine_Mapping.Functional.html) 
- Functional fine-mapping of the LRRK2 locus using PAINTOR.
- eQTL boxplots of selected LRRK2 SNPs using the Fairfax et al. (2014) eQTL summary statistics from monocytes.
#### [Annotation & Enrichment](https://rajlabmssm.github.io/Fine_Mapping/Fine_Mapping.Enrichment.html)  
- Annotation of all 78 loci usig Biomart and HaploReg.  
- Enrichment tests on all 78 loci using fGWAS.
- Enrichment tests on LRRK2 locus using GoShifter.  
#### [eQTL Boxplot Demo](https://rajlabmssm.github.io/Fine_Mapping/eQTL_boxplots_demo.html)
 

<br>

## Workflow  

![echoFlow](./echolocatoR/images/echolocatoR_flowchart.png)

<br>

## Fine-mapping Tools  

Currently implemented:  
### [susieR](https://github.com/stephenslab/susieR)  
### [FINEMAP](http://www.christianbenner.com)  
### [ABF](https://cran.r-project.org/web/packages/coloc/vignettes/vignette.html)
### [GCTA-COJO](https://cnsgenomics.com/software/gcta/#COJO)
### [PAINTOR](https://github.com/gkichaev/PAINTOR_V3.0)  
### [fGWAS](https://github.com/joepickrell/fgwas)  
### [coloc](https://cran.r-project.org/web/packages/coloc/vignettes/vignette.html)   

Planning to implement:  
### [CAVIAR](http://genetics.cs.ucla.edu/caviar/)  
### [CAVIAR-BF](https://www.ncbi.nlm.nih.gov/pubmed/25948564)  
### [eCAVIAR](http://genetics.cs.ucla.edu/caviar/)  
### [DAP](https://github.com/xqwen/dap)  

<br>

## Annotation & Enrichment Tools  

### [HaploR](https://cran.r-project.org/web/packages/haploR/vignettes/haplor-vignette.html)  
### [XGR](http://xgr.r-forge.r-project.org)  
### [fGWAS](https://github.com/joepickrell/fgwas)  
### [GoShifter](https://github.com/immunogenomics/goshifter)  

<br>


## Datasets

### Parkinson's Disease GWAS  
#### [Nalls et al. (2019) & 23andMe](https://www.biorxiv.org/content/10.1101/388165v3)  
- Both Nalls et al. (2019) summary stats and 1000 Genomes Project LD calculations used human genome annotation GRCh37.

### Alzheimer's Disease GWAS

#### [Lambert et al. (2013)](https://www.nature.com/articles/ng.2802)
#### [Marioni et al. (2018)](https://www.nature.com/articles/s41398-018-0150-6)
#### [Posthuma et al. (2018)](https://www.nature.com/articles/s41588-018-0311-9)
#### [Kunkle et al. (2019)](https://www.nature.com/articles/s41588-019-0358-2)

### LD Reference Panels  

#### [UK Biobank](https://www.ukbiobank.ac.uk)
#### [1000 Genomes Phase 1](https://www.internationalgenome.org)  
#### [1000 Genomes Phase 3](https://www.internationalgenome.org)  


### QTL

#### [eQTL: MESA](https://www.nhlbi.nih.gov/science/multi-ethnic-study-atherosclerosis-mesa)  
- AFA, CAU & HIS subpopulations.    

#### [eQTL: Fairfax et al. (2014)](https://science.sciencemag.org/content/343/6175/1246949)  
- Monocytes and macrophages.  

#### [e/c/isoQTL & HiC: psychENCODE](http://resource.psychencode.org)  
- expression QTL (eQTL), chromatin QTL (cQTL) and isoform QTL (isoQTL) from Control, Schizophrenia, Bipolar Disorder, and Autism Spectrum Disorder populations.  


<hr><hr>

## Author

<a href="https://bschilder.github.io/BMSchilder/" target="_blank">Brian M. Schilder, Bioinformatician II</a>  
<a href="https://rajlab.org" target="_blank">Raj Lab</a>  
<a href="https://icahn.mssm.edu/about/departments/neuroscience" target="_blank">Department of Neuroscience, Icahn School of Medicine at Mount Sinai</a>  
![Sinai](./web/images/sinai.png)

