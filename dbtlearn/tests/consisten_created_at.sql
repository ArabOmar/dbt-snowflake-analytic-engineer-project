SELECT * FROM {{ref("fact_reviews")}} f JOIN {{ref('dim_listings_cleansed')}} h
ON f.LISTING_ID = h.LISTING_ID
WHERE h.CREATED_AT >= f.REVIEW_DATE 
LIMIT 10