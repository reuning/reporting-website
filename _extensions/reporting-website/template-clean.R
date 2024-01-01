
if (!require(yaml)) {
    simpleError("Please install the yaml package")
}


template_files <- list.files(pattern = "*-template.qmd",
                             recursive = TRUE,
                             ignore.case = TRUE,  full.names = TRUE)

if (length(template_files) == 0) {
    stop("No template files found, skipping processing")
}
yml_files <- gsub("qmd$", "yml", template_files)

if("keep-files" %in% names(yml_files)){
    if(yml_files$keep_files == TRUE) stop("Not data deleting files")
}

for (ii in seq_along(template_files)){

    all_vars <- read_yaml(yml_files[ii])

    items <- unlist(all_vars$items, recursive = FALSE)
    for (jj in seq_along(items)){

        if ("data" %in% names(items[[jj]])) {
            file.remove(items[[jj]]$data$filename)
        }

    }
}