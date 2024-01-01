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



for (ii in seq_along(template_files)){

    template <- readLines(template_files[ii])
    all_vars <- read_yaml(yml_files[ii])

    if ("data" %in% names(all_vars)) {
        ## Loading data if is set
        eval(parse(text = all_vars$data))
    }

    items <- unlist(all_vars$items, recursive = FALSE)
    file_out <- template
    for (jj in seq_along(items)){

        if ("data" %in% names(items[[jj]])) {
            eval(parse(text = paste0("tmp_df <- ", items[[jj]]$data$subset)))
            write.csv(tmp_df, items[[jj]]$data$filename, row.names = FALSE)

            file_out <- gsub("\\{\\{< template data_filename >\\}\\}",
                             paste0("\"", items[[jj]]$data$filename, "\""),
                             file_out)

        }
        vars <- items[[jj]]
        vars$data <- NULL
        for (kk in seq_along(vars)) {
            file_out <- gsub(paste0("\\{\\{< template ",
                                    names(vars)[kk], " >\\}\\}"),
                             vars[[kk]], file_out)
        }

        writeLines(file_out, paste0(names(items)[[jj]], ".qmd"))
    }

}