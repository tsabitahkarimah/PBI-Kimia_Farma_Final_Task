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

