# BigQuery-GA4-Analysis
## Project topic
User retention assessment (Retention Rate) using Google Sheets and SQL based on cohort analysis (Cohort Analysis)

## Overview
Two sets of SQL queries written in BigQuery against the public Google Analytics 4 sample dataset (bigquery-public-data.ga4_obfuscated_sample_ecommerce). The dataset contains obfuscated event-level data from the Google Merchandise Store.

The project covers two distinct analytical directions: funnel and conversion analysis across traffic channels and landing pages, and structured exploration of GA4's nested data model using UNNEST, window functions, and partitions.

## Dataset
bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*

Event-based GA4 export with nested RECORD fields: event_params, user_properties, items. Data spans 2020–2021.

## Key activities
Applied Cohort Analysis principles and calculated the Retention Rate metric to evaluate user retention over time.

Extracted data from databases using SQL, including date parsing, event filtering, table joins, cohort calculations, and monthly offset calculations.

Built Cohort Tables in Google Sheets using conditional aggregation, pivot tables, conditional formatting, and a combination of different cell referencing methods.

Compared the behavior of two user groups: Promo Users acquired through promotions and advertising, and Organic Users, and drew conclusions about Acquisition Quality and user Retention






