# Layoffs Dataset Analysis

This project analyses the global layoffs dataset, focusing on trends across companies, industries, and locations. It evaluates the impact of layoffs by company, industry, and geography, providing insights into workforce reductions, company stages, and fundraising history.

---

## Dataset Overview

The dataset includes:

- **Company**: Name of the company that conducted layoffs  
- **Industry**: Sector the company belongs to (e.g., Tech, Finance)  
- **Location**: Geographic location (city/country) of the company  
- **Laid Off Count**: Number of employees laid off  
- **Percentage Laid Off**: Proportion of total workforce affected  
- **Date**: Date of the layoff event  
- **Stage**: Company's funding or business stage (e.g., Series A, Public)  
- **Country**: Country where the company is.
- **Funds Raised (Millions)**: Total funds raised by the company in millions
- **Source**: The source where the information was gotten from
- **Date Added**: The date the information was added to the dataset

---

## Tasks Performed

### 1. **Data Cleaning**
- Removed **duplicate entries**
- Standardised data formatting for:
  - Company names
  - Industry labels
  - Dates
- Updated **null and blank values** with relevant data or placeholder tags
- Removed **unnecessary or redundant columns**

### 2. **Exploratory Data Analysis (EDA)**
- Identified companies with the **highest number of layoffs**
- Analysed layoff trends by:
  - **Industry**
  - **Geography**
  - **Date**
  - **Company stage**
- Assessed **correlation between funds raised and layoffs**

---

## Key Findings

- Industries like Intel, Amazon, Meta, Microsoft, Tesla are the top 5 companies with the highest layoffs.
- Companies in United States, India, Germany, United Kingdom reported higher layoff rates.
- Most layoffs occurred in January 2023 with a total of **89,709** globally.
- There is a weak correlation between funding raised and layoff decisions.

---

## Folder Structure
    ├── README.md
    ├── data
    │   ├── correlation_btw_funds_raised_vs_percent_lay_off.csv
    │   ├── layoff_data_cleaned.csv
    │   ├── layoffs.csv
    │   ├── layoffs_by_geography.csv
    │   ├── layoffs_by_industry.csv
    │   ├── layoffs_by_industry_per_year.csv
    │   └── layoffs_rank_of_companies.csv
    ├── requirements.txt
    ├── scripts
    │   ├── correlation_data.ipynb
    │   └── layoffs_data.sql
    └── visuals
        ├── layoff_by_industry_page-0001.jpg
        ├── top_layoff_by_company_page-0001.jpg
        └── top_layoff_by_geography_page-0001.jpg

## Tools & Libraries
- SQL, Pandas
- PowerBI

## Future Improvements
- Build an interactive dashboard using Dash
- Merge with external funding databases

## Data Source
- https://www.kaggle.com/datasets/swaptr/layoffs-2022

## Acknowledgement
- Thanks to the contributors and platforms that provided the dataset and inspiration for this analysis.

