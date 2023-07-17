DROP TABLE IF EXISTS internet_services;

CREATE TABLE internet_services(
	internet_service_id SERIAL PRIMARY KEY,
	customer_id TEXT,
	internet_service TEXT,
	FOREIGN KEY (customer_id) REFERENCES customer (customer_id)
);

COPY internet_services (customer_id,internet_service)
FROM 'C:\LabFiles\Services.csv'
DELIMITER ',' CSV HEADER;

SELECT *
FROM internet_services

CREATE TABLE internet_services_churn AS
SELECT i.internet_service, ROUND(AVG(c.tenure), 2) AS avg_tenure, COUNT(*) AS total_customers,
       COUNT(CASE WHEN c.churn = 'Yes' THEN 1 END) AS churned_customers
FROM customer c
JOIN internet_services i ON c.customer_id = i.customer_id
GROUP BY i.internet_service;

SELECT *
FROM internet_services_churn;

CREATE OR REPLACE FUNCTION load_internet_services()
  RETURNS VOID
  LANGUAGE plpgsql
AS $$
BEGIN
  EXECUTE 'COPY internet_services (customer_id, internet_service)
           FROM ''c:\LabFiles\Services.csv''
           DELIMITER '','' CSV HEADER';
END;
$$;

SELECT load_internet_services();

SELECT * FROM internet_services;
