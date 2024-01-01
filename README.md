# Reporting Website

## Installing

```bash
quarto use template reuning/reporting-website
```

This will install the extension and create an example qmd file that you can use as a starting place for your website. You must also install the R package [yaml][https://github.com/vubiostat/r-yaml/]: 

```r
install.packages("yaml") 
```

## Using

Each report type is defined using a `*-template.qmd` and a `*-template.yml`. The qmd file outlines the report while the yaml file provides the different information that will be in each unique report. The yaml file has the following format: 

```yaml
data: ## R code to load the data
keep-files: ## optional, set to TRUE or true to keep each unique data file
items: ## The different pages that will be created
    - PageName1: ## Name of the page you want to create
        var1: Page 1 ## Something to insert into the template
        data:
            subset: ## R code to subset the data
            filename: ## file to save the subset data
    - PageName2: ## Name of the second page
        var1:
        data:
            subset: 
            filename:
    - PageName3:
        var1: 
        data:
            subset: 
            filename: 
```

This setup assumes you have some _shared_ data that you want to subset across the different reports. That data is loaded using the script provided in the `data:` code at the top and then subsets are created and written (using `write.csv()`) for each report. For example, if you had a large dataset called "nlrb.csv" and wanted to create a subset for each union the requisite parts could look like:

```yaml
data: df <- read.csv("nlrb.csv")
items: 
    - SEIU:
        data: 
            subset: df[df$Name=="SEIU",]
            filename: "seiu.csv"
    - IWW:
        data: 
            subset: df[df$Name=="IWW",]
            filename: "iww.csv"

```

The script will also fill in anything in the template flagged using: `{{< template keyword >}}` with *keyword* found in the yaml. If your template includes the lines: 

```md
Data for {{< template unionname >}} from 2010 to {{< template endyear >}}.
```

and your yaml: 

```yaml
items: 
    - SEIU: 
        unionname: Service Employees International Union (SEIU)
        endyear: 2021
    - IWW: 
        unionname: Industrial Workers of the World (IWW)
        endyear: 2018
```

You'll get two qmd files out. The first will look like:

```md
Data for Service Employees International Union (SEIU) from 2010 to 2021.
```

The one special keyword is {{< template data_filename >}} which will be replaced with the filename for the data used in the subset. 

## Example

There is an example [template.qmd](reports/demo-template.qmd) and associated [yaml file](reports/demo-template.yml) in the reports folder. I included an [index.qmd](index.qmd) file to demonstrate how a website might be setup with a homepage, and then the reports in a subfolder. This code generates [the following website](https://reuning.github.io/reporting-website/)

## Warnings/Things to Consider


- You will need to run `quarto render` twice the first time. Quarto currently creates a list of `.qmd` files to process prior to the pre-render scripts, so it will miss the newly created `.qmd` files. In future runs you should only need to run it once (unless new `.qmd` files are created). 
- Right now it only looks at the first level of each "item" in the YAML (except for the data one). This might be improved in future instances. 