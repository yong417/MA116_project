# MA116 - Statistics II Project

This is the repo for the project in which I used statistical modeling techniques learned from MA 116.

### Data Description

The main dataset `files/TT100-forHire_2009-2018-SCAC self.xlsx` is downloaded from an open-source database. It contains the annual revenue and other useful information of logistics companies along with their SCAC codes from 2009 to 2018.

It also contains the performance rankings and emission factors of each company. The emission factors of interest are grams of CO2 per mile, grams of NOx per mile, and grams of PM per mile.

The following files are extracted from `files/TT100-forHire_2009-2018-SCAC self.xlsx` for preprocessing:
* `files/y2009.txt` - `files/y2018.txt` contains the information of annual revenue.
* `files/scac.txt` matches the company names with their SCAC codes.
* `file/scac_co2` matches the SCAC codes with emission factors.
* `Merged_table.txt` contains the time series data of each company's revenue from 2009 to 2018 indicated by covariate `Year`.

The following files are generated after cleaning any mismatches or nuances and are ready for modeling:
* `transCompany.txt` contains the averaged annual revenue of each company from 2009 to 2018 and the emission factors.
* `final.txt` contains the time series data of each company's revenue from 2009 to 2018 and the emission factors.


### Research Aim

There are two research aims that we try to address:
* Assess the associations between the average annual revenue and the emission factors.
* Assess the time effects on the associations between the annual revenue and the emission factors.

### Key Challenges

1. Some companies might have multiple matched SCAC codes due to changes across year.

2. Some companies might have extremely high revenues in a certain year which seems to be outliers.

3. The information for year 2025 and 2016 is not available.

4. Not all companies have information on record for available years.

### Statistical methods

For Aim 1, a simple linear regression will be used.

For Aim 2, a GEE will be used.

The outlier will be detected using boxplot and Q-Q plot.

### License

[MIT](https://choosealicense.com/licenses/mit/)