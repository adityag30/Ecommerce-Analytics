# E-Commerce Sales & Customer Segmentation Analytics

An end-to-end data analytics project analyzing **400K+ e-commerce transactions** using Python, SQL, K-Means clustering, and Power BI to identify sales trends, customer behavior, and actionable business insights.

## 📌 Project Workflow

```text
Data Cleaning → EDA → RFM Analysis → K-Means
                     ↓
              Customer Segmentation
                     ↓
             SQL Business Analysis
                     ↓
               Power BI Dashboard
```

## 🛠️ Tech Stack

- **Python:** Pandas, NumPy, Matplotlib, Scikit-learn
- **Machine Learning:** RFM Analysis, K-Means Clustering
- **Database:** MySQL, SQL
- **Visualization:** Power BI
- **Tools:** Jupyter Notebook, Git, GitHub

## 📊 Dataset

**Online Retail II** dataset containing historical e-commerce transactions.

- **400,916** cleaned transactions
- **4,312** customers
- Product, transaction, customer, date, and country information

## 🧹 Data Analysis

Performed:

- Data cleaning and preprocessing
- Exploratory Data Analysis
- Revenue and sales trend analysis
- RFM customer analysis
- K-Means customer segmentation

## 👥 Customer Segmentation

K-Means identified four customer segments:

| Segment | Customers | Avg. Monetary |
|---|---:|---:|
| High-Value Loyal | 778 | 7381.58 |
| Potential Loyalist | 1211 | 1759.99 |
| New / Occasional | 945 | 532.08 |
| At-Risk / Lost | 1378 | 305.66 |

## 🗄️ SQL Analysis

Used MySQL to perform:

- Revenue and order analysis
- Monthly sales analysis
- Top products and countries
- Customer spending analysis
- Repeat customer analysis
- CTEs, subqueries, joins, and window functions
- Customer segment analysis

## 📊 Power BI Dashboard

Built an interactive dashboard containing:

- Total Revenue
- Total Orders
- Total Customers
- Average Order Value
- Monthly Revenue Trend
- Top 10 Products
- Customer Segmentation
- Revenue by Customer Segment
- Country and Date Filters

## 💡 Key Insights

- **18% of customers generated 65.27% of total revenue.**
- **32% of customers were classified as At-Risk/Lost**, contributing only 4.79% of revenue.
- **Potential Loyalists contributed 24.22% of revenue**, making them an important growth opportunity.
- High-value customers were identified as the primary retention priority.

## 📁 Project Structure

```text
Ecommerce-Analytics/
├── data/
│   └── processed/
├── notebooks/
│   └── ecommerce_analysis.ipynb
├── sql/
│   └── analysis.sql
├── src/
├── dashboard/
│   └── ecommerce_sales_customer_analytics.pbix
├── .gitignore
└── README.md
```

## 🚀 Future Improvements

- Customer churn prediction
- Customer Lifetime Value prediction
- Sales forecasting
- Product recommendation system

## 👨‍💻 Author

**Aditya Kumar Garg**  
B.Tech CSE (AI & Data Science)

**Python | SQL | Machine Learning | Power BI | MySQL**
