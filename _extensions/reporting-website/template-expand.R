if(!require(yaml)){ 
    simpleError("Please install the yaml package")
} 


template_files <- list.files(pattern="*-template.qmd", 
                            recursive=TRUE, 
                            ignore.case=TRUE,  full.names=TRUE)

if(length(template_files)==0){
    stop("No template files found, skipping processing")
}
yml_files <- gsub("qmd$", "yml", template_files)



for(ii in seq_along(template_files)){
    template <- readLines(template_files[ii])
    vars <- read_yaml(yml_files[ii])
    if("data" %in% names(vars)){
        ## Loading data if is set
        eval(parse(text=vars$data))
    }

    items <- unlist(vars$items, recursive=FALSE)
    for(jj in seq_along(items)){

        if("filename" %in% names(items[[jj]])) {
            eval(parse(text=paste0("tmp_df <- ", items[[jj]]$subset)))
            write.csv(tmp_df, items[[jj]]$filename, row.names=F)
        }
    }

}
