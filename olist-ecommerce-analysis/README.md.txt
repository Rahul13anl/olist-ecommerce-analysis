# Olist E-Commerce Sales and Customer Analysis

One-line summary: I analysed about 100K marketplace orders to find why growth is slowing, customers are not returning and deliveries are late, using Excel, SQL, Python and Power BI.

## Business problem
Management sees slowing sales growth, low repeat purchases and late deliveries, and wants to know why and what to do.

## Dataset
Olist Brazilian E-Commerce Public Dataset (Kaggle), about 100K orders, 2016-2018, 9 tables.
Link: https://www.kaggle.com/datasets/Olistbr/brazilian-ecommerce
The data files are not stored in this repository. Download them and place the CSVs in data/raw/.

## Questions answered
1. How is revenue trending, and is it growing or slowing?
   • Finding: Revenue grew steadily through 2017, peaked in November 2017, and stayed higher in 2018 than in the same months of 2017 until the data ends. The sharp drop in Sep to Oct 
              2018 is incomplete data, not a business decline.
   • Evidence: November 2017 revenue was [₹ 9,87,765.37], [52.3%] above October (SQL Q1, Excel pivot, Page 1). Total delivered revenue was [₹ 1,32,21,498.11] across [96478] orders,
                with an average order value of [137].
   • Recommendation: Treat growth as healthy but seasonal. Plan stock, seller capacity and delivery staffing before November every year.


2. Which categories and states drive revenue?
   • Finding: Revenue is concentrated in a few categories and one state, which is a concentration risk. Some high-revenue categories also rate poorly.
   • Evidence: The top 10 categories make [8475957.5] of revenue, led by [Watches_gifts], [Health_beauty] and [Bed_bath_table] (SQL Q2, Page 2). Sao Paulo (SP) alone makes [18,59,557] of 
                revenue (SQL Q3). [ Bed_bath_table,Furniture_decor,Computers_accessories] have high revenue but an average score of [3.92,3.94,3.98], below the overall [4.16] 
                (Python scatter chart).
   • Recommendation: Run promotions in the next 3 to 5 states by revenue to reduce dependence on SP. Review sellers and product listings in high-revenue, low-rating categories 
     before promoting them further.


3. Who are the best customers, and why do most not buy again?
   • Finding: Almost all customers buy once and never return. Retention is the biggest problem in the business.
   • Evidence: Only [3.0]% of customers placed more than one order (SQL Q7, Page 3). Month-1 retention is below [0.72]% in every cohort (Python heatmap). RFM segments: [36941 ] At-Risk, 
               [35769] Lost, [1566 , 1235] Loyal and Champions combined (Python RFM). The top 20 customers by lifetime spend contribute [107713] (SQL Q6).
   • Recommendation: Send a re-engagement offer [30 to 60] days after the first order, starting with the At-Risk segment. Build a simple loyalty reward for second and third 
                     purchases. Track repeat rate monthly as the main retention KPI.

4. Does late delivery hurt customer satisfaction?
    • Finding: Yes. Late orders get far lower reviews, and the score keeps falling as the delay grows. The problem is concentrated: most orders arrive on time.
    • Evidence: On-time orders average [4.29]% stars and late orders [2.27]% , a gap of [-2.02]% stars (SQL Q9, Page 3). [6.8]% of orders are late (SQL Q4, Excel Summary). 
                 Review score by delay   bucket: [3.29%], [2.10%], [1.68%], [ 1.72%] (Python chart).
    • Recommendation: Set delivery targets for sellers and carriers, and notify customers early when an order will miss its date. Set honest delivery estimates so fewer orders count 
                       as late.

5. Which regions and sellers cause problems?
    • Finding: Delivery speed varies widely by region, and some high-revenue sellers have poor ratings or late shipments.
     • Evidence: [PE] averages [18.4] days against [8.7] days in [SP] (SQL Q5, Page 3). [20] of the top 20 sellers have an average score below [13] or a late rate above
                  [6.8]% (seller query).
      • Recommendation: Review carriers and consider regional fulfilment for the slowest states. Set minimum rating and on-time thresholds for sellers, and review those who fall 
                        below them.

## Tools and what I did with each
- Excel: cleaned orders, built pivot tables and a summary sheet (SUMIFS, COUNTIFS, XLOOKUP).
- SQL (PostgreSQL): answered 10 business questions with joins, CTEs and window functions.
- Python (pandas, matplotlib, seaborn): cleaning, RFM segmentation, cohort retention, delivery vs review analysis.
- Power BI: 3-page dashboard with DAX measures and slicers.

## Key definitions
- Revenue = sum of item prices on delivered orders (freight excluded), in R$.
- Late = delivered after the estimated date (date only).
- Customers counted by customer_unique_id.

## Key findings and recommendations
1. Retention: only 3.0% of customers ordered again. Recommendation: re-engagement offer 30-60 days after first order.
2. Late delivery: late orders score 2.27 stars lower. Recommendation: delivery targets and early delay alerts.
3. Regions: slowest state takes 18.4 days vs 8.7 days in the fastest. Recommendation: improve carriers and estimates.
4. Concentration: top 10 categories make 62.4% of revenue, SP makes 38.3%. Recommendation: grow in other states.
5. Sellers: some top sellers have low ratings or late shipments. Recommendation: performance thresholds.
6. Seasonality: November 2017 peak [₹ 9,87,765.37]. Recommendation: plan stock and staffing early.

## Dashboard
![Executive Summary](images/page1.png)
![Products and Sales](images/page2.png)
![Customer and Delivery](images/page3.png)

## Limitations
- 2016-2018 sample, not current.
- No cost data, so revenue only.
- Sep-Oct 2018 incomplete and excluded from trends.
- Late delivery and low reviews are linked, but this analysis does not prove cause.

## Repository structure
data/ (not uploaded), excel/, sql/, python/, powerbi/, images/

## How to reproduce
1. Download the dataset into data/raw/.
2. Run the SQL files in order.
3. Run the notebooks in python/.
4. Open powerbi/project