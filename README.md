# Performance Analytics Dashboard Project: Kimia Farma 2020-2023

## Introduction 
Kimia Farma has initiated a Project-Based Internship program for a Big Data Analytics position to analyze their business performance from 2020 to 2023. The project uses four main datasets containing information about transactions, inventory, products, and branch offices. The final deliverables include a PowerPoint presentation, the BigQuery code stored in GitHub, and a video presentation explaining the entire analysis. This project aims to provide Kimia Farma with valuable insights into their business performance across different regions and time periods.

## Tools
* Google BigQuery (data processing)
* Google Looker Studio (data visualization)

## Process
### 1. Data preparation in BigQuery
Importing the datasets into BigQuery and creating an analysis table that combines all the data and includes calculations for sales and profits using the query below;

```sql
CREATE TABLE kimia_farma.kimia_farma_analysis AS
SELECT
  kf_final_transaction.transaction_id,
  kf_final_transaction.date,
  kf_kantor_cabang.branch_id,
  kf_kantor_cabang.branch_name,
  kf_kantor_cabang.kota,
  kf_kantor_cabang.provinsi,
  kf_kantor_cabang.rating AS rating_cabang,
  kf_final_transaction.customer_name,
  kf_product.product_id,
  kf_product.product_name,
  kf_product.price AS actual_price,
  kf_final_transaction.discount_percentage,
  kf_final_transaction.rating AS rating_transaksi,
FROM kimia_farma.kf_final_transaction
INNER JOIN kimia_farma.kf_kantor_cabang ON kf_final_transaction.branch_id = kf_kantor_cabang.branch_id 
INNER JOIN kimia_farma.kf_product ON kf_final_transaction.product_id = kf_product.product_id;

UPDATE kimia_farma.kimia_farma_analysis
SET 
   persentase_gross_laba = CASE
       WHEN actual_price <= 50000 THEN 0.1
       WHEN actual_price <= 100000 THEN 0.15
       WHEN actual_price <= 300000 THEN 0.2
       WHEN actual_price <= 500000 THEN 0.25
       ELSE 0.3
   END,
   nett_sales = actual_price * (1 - discount_percentage),
   nett_profit = actual_price * (1 - discount_percentage) * 
       CASE 
         WHEN actual_price <= 50000 THEN 0.1
         WHEN actual_price <= 100000 THEN 0.15
         WHEN actual_price <= 300000 THEN 0.2
         WHEN actual_price <= 500000 THEN 0.25
         ELSE 0.3
      END 
WHERE persentase_gross_laba IS NULL
  OR nett_sales IS NULL
  OR nett_profit IS NULL;
```

Main aspects of this data preparation
1. JOIN the tables based on matching branch_id and product_id values from kf_final_transaction, kf_kantor_cabang, and kf_product tables
2. Add new columns based on the calculation of the actual_price

### 2. Data visualization in BigQuery
The dashboard was created from the analysis table, visualizing the summary of the table through snapshot data, sales comparison throughout the years, top performing provinces, braches with highest branch ranking and lower transaction ranking as well as a geo map displaying each provinces nett profit with date control as a filter. 

