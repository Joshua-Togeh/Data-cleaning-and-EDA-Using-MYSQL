# Data Cleaning Steps Performed on the Layoff Dataset  

I downloaded the **layoff dataset** from *Alex The Analyst's* GitHub page and performed the following cleaning steps:  

## 1. Removed Duplicate Records  
- Checked for and eliminated any duplicate entries to ensure data integrity.  

## 2. Standardized the Data  
- Removed unnecessary white spaces in text fields.  
- Standardized similar records:
  - For example, in the **Industry** column, "Crypto" and "Cryptocurrency" were unified as "Crypto."  
- Corrected inconsistent data types:
  - The **Date** column was originally stored as **TEXT**, so it was converted to the correct **DATE** format.  

## 3. Handled Missing and Null Values  
- Identified and either updated or removed null/missing values to ensure data completeness.  

## 4. Removed Unwanted Columns  
- Dropped irrelevant columns that were not needed for analysis.  
