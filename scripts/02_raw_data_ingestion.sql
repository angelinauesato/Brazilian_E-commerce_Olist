
/*
Download dataset from: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce?resource=download

I uploaded to the internal stage in snowflake.
UTIL_DB/ PUBLIC/MY_INTERNAL_STAGE/olist
*/


CREATE OR REPLACE FILE FORMAT olist_db.raw_olist.COMMACOLSEP_ONEHEADROW 
    TYPE = 'CSV'
    FIELD_DELIMITER = ',' 
    SKIP_HEADER = 1 
    FIELD_OPTIONALLY_ENCLOSED_BY = '"' -- This handles the "rio de janeiro, brasil" issue
    EMPTY_FIELD_AS_NULL = TRUE
    ERROR_ON_COLUMN_COUNT_MISMATCH = FALSE -- Optional: helps if rows have trailing commas
    ;


create table if not exists olist_db.raw_olist.olist_customers(
customer_id VARCHAR,
customer_unique_id VARCHAR,
customer_zip_code_prefix VARCHAR,
customer_city VARCHAR,
customer_state VARCHAR
);

copy into olist_customers
from @util_db.public.MY_INTERNAL_STAGE/olist/
files = ( 'olist_customers_dataset.csv')
file_format = ( format_name=olist_db.raw_olist.COMMACOLSEP_ONEHEADROW );

create table if not exists olist_db.raw_olist.olist_geolocation(
geolocation_zip_code_prefix VARCHAR,
geolocation_lat VARCHAR,
geolocation_lng VARCHAR,
geolocation_city VARCHAR,
geolocation_state VARCHAR
);

copy into olist_geolocation
from @util_db.public.MY_INTERNAL_STAGE/olist/
files = ( 'olist_geolocation_dataset.csv')
file_format = ( format_name=olist_db.raw_olist.COMMACOLSEP_ONEHEADROW );

create table if not exists olist_db.raw_olist.olist_order_items(
order_id VARCHAR,
order_item_id VARCHAR,
product_id VARCHAR,
seller_id VARCHAR,
shipping_limit_date VARCHAR,
price VARCHAR,
freight_value VARCHAR
);

copy into olist_order_items
from @util_db.public.MY_INTERNAL_STAGE/olist/
files = ( 'olist_order_items_dataset.csv')
file_format = ( format_name=olist_db.raw_olist.COMMACOLSEP_ONEHEADROW );

olist_order_payments(
order_id VARCHAR,
payment_sequential VARCHAR,
payment_type VARCHAR,
payment_installments VARCHAR,
payment_value VARCHAR
);

copy into olist_order_payments
from @util_db.public.MY_INTERNAL_STAGE/olist/
files = ( 'olist_order_payments_dataset.csv')
file_format = ( format_name=olist_db.raw_olist.COMMACOLSEP_ONEHEADROW );

create table if not exists olist_db.raw_olist.olist_order_reviews(
review_id VARCHAR,
order_id VARCHAR,
review_score VARCHAR,
review_comment_title VARCHAR,
review_comment_message VARCHAR,
review_creation_date VARCHAR,
review_answer_timestamp VARCHAR
);

copy into olist_order_reviews
from @util_db.public.MY_INTERNAL_STAGE/olist/
files = ( 'olist_order_reviews_dataset.csv')
file_format = ( format_name=olist_db.raw_olist.COMMACOLSEP_ONEHEADROW );

create table if not exists olist_db.raw_olist.olist_orders(
order_id VARCHAR,
customer_id VARCHAR,
order_status VARCHAR,
order_purchase_timestamp VARCHAR,
order_approved_at VARCHAR,
order_delivered_carrier_date VARCHAR,
order_delivered_customer_date VARCHAR,
order_estimated_delivery_date VARCHAR
);

copy into olist_orders
from @util_db.public.MY_INTERNAL_STAGE/olist/
files = ( 'olist_orders_dataset.csv')
file_format = ( format_name=olist_db.raw_olist.COMMACOLSEP_ONEHEADROW );

create table if not exists olist_db.raw_olist.olist_products(
product_id VARCHAR,
product_category_name VARCHAR,
product_name_lenght VARCHAR,
product_description_lenght VARCHAR,
product_photos_qty VARCHAR,
product_weight_g VARCHAR,
product_length_cm VARCHAR,
product_height_cm VARCHAR,
product_width_cm VARCHAR
);

copy into olist_products
from @util_db.public.MY_INTERNAL_STAGE/olist/
files = ( 'olist_products_dataset.csv')
file_format = ( format_name=olist_db.raw_olist.COMMACOLSEP_ONEHEADROW );

create table if not exists olist_db.raw_olist.olist_sellers(
seller_id VARCHAR,
seller_zip_code_prefix VARCHAR,
seller_city VARCHAR,
seller_state VARCHAR
);

copy into olist_sellers
from @util_db.public.MY_INTERNAL_STAGE/olist/
files = ( 'olist_sellers_dataset.csv')
file_format = ( format_name=olist_db.raw_olist.COMMACOLSEP_ONEHEADROW );

create table if not exists olist_db.raw_olist.product_category_name_translation(
product_category_name VARCHAR,
product_category_name_english VARCHAR
);

copy into product_category_name_translation
from @util_db.public.MY_INTERNAL_STAGE/olist/
files = ( 'product_category_name_translation.csv')
file_format = ( format_name=olist_db.raw_olist.COMMACOLSEP_ONEHEADROW );

SELECT $1, $2,-- $3, $4 --, $5, $6, $7, $8, $9
FROM @util_db.public.MY_INTERNAL_STAGE/olist/product_category_name_translation.csv
(file_format => olist_db.raw_olist.COMMACOLSEP_ONEHEADROW );
