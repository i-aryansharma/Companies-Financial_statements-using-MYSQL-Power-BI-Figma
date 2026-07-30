CREATE DATABASE Finance_db;
USE Finance_db;

CREATE TABLE company(
company_id INT PRIMARY KEY,
company_name VARCHAR(50),
industry VARCHAR(40),
country VARCHAR(30),
founded_year DATE,
ceo_name VARCHAR(50)
);


CREATE TABLE income_statement(
statement_id INT PRIMARY KEY,
company_id INT,
year INT,
month INT,
revenue DECIMAL(15,2),
cost_of_goods_sold DECIMAL(15,2),
operating_expenses DECIMAL(15,2),
interest_expense DECIMAL(15,2),
tax_expense DECIMAL(15,2),
FOREIGN KEY (company_id) REFERENCES company(company_id)
);


CREATE TABLE balance_sheet(
balance_id INT PRIMARY KEY,
company_id INT NOT NULL,
year INT NOT NULL,
month TINYINT NOT NULL CHECK (month BETWEEN 1 AND 12),
cash DECIMAL(15,2) NOT NULL,
inventory DECIMAL(15,2) NOT NULL,
accounts_receivable DECIMAL(15,2) NOT NULL,
fixed_assets DECIMAL(15,2) NOT NULL,
accounts_payable DECIMAL(15,2) NOT NULL,
short_term_debt DECIMAL(15,2) NOT NULL,
long_term_debt DECIMAL(15,2) NOT NULL,
equity DECIMAL(15,2) NOT NULL,
FOREIGN KEY (company_id) REFERENCES company(company_id)
);


CREATE TABLE cash_flow(
cashflow_id INT PRIMARY KEY,
company_id INT NOT NULL,
year INT NOT NULL,
month TINYINT NOT NULL CHECK (month BETWEEN 1 AND 12),
operating_cash_flow DECIMAL(15,2) NOT NULL,
investing_cash_flow DECIMAL(15,2) NOT NULL,
financing_cash_flow DECIMAL(15,2) NOT NULL,
FOREIGN KEY (company_id) REFERENCES company(company_id)
);


LOAD DATA LOCAL INFILE 'D:/End to end project/company.csv'
INTO TABLE company
FIELDS TERMINATED BY ','
ENCLOSED BY ""
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
SELECT * FROM company;



LOAD DATA LOCAL INFILE 'D:/End to end project/income_statement.csv'
INTO TABLE income_statement
FIELDS TERMINATED BY ','
ENCLOSED BY ""
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


LOAD DATA LOCAL INFILE 'D:/End to end project/balance_sheet.csv'
INTO TABLE balance_sheet
FIELDS TERMINATED BY ','
ENCLOSED BY ""
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


LOAD DATA LOCAL INFILE 'D:/End to end project/cash_flow.csv'
INTO TABLE cash_flow
FIELDS TERMINATED BY ','
ENCLOSED BY ""
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM company 
WHERE company_name IS NULL;
-- --------------------------------------------------------Monthly Revenue Trend--------------------------------------------------------
CREATE VIEW monthly_revenue_trend AS 
SELECT 	i.company_id,
		c.company_name,
		i.year,
		i.month,
        SUM(i.revenue) AS total_revenue
FROM income_statement i
INNER JOIN company c
ON i.company_id = c.company_id
GROUP BY 	i.company_id,
			c.company_name,
			i.year,
			i.month
ORDER BY 	i.company_id,
			c.company_name,
			i.year, 
			i.month;
SELECT * FROM monthly_revenue_trend;


-- -----------------------------------------------------Company Gross Profit-------------------------------------------------------------------
CREATE VIEW company_gross_profit AS
SELECT 	i.company_id,
		c.company_name,
		i.year,
        i.month,
        SUM(i.revenue) AS Total_revenue,
        SUM(i.cost_of_goods_sold) AS Total_COGS,
        SUM(i.revenue)
        - SUM(i.cost_of_goods_sold) AS Total_Gross_Profit
FROM income_statement i
INNER JOIN company c
ON i.company_id = c.company_id
GROUP BY	i.company_id,
			c.company_name,
			i.year,
			i.month
ORDER BY	i.company_id,
			c.company_name,
			i.year,
			i.month;
SELECT * FROM company_gross_profit;

-- -------------------------------------------------------Company Operating Profit ----------------------------------------------------------
CREATE VIEW company_operating_profit AS
SELECT 	i.company_id,
		c.company_name,
		i.year,
        i.month,
        SUM(i.revenue) AS Totat_revenue,
        SUM(i.cost_of_goods_sold) AS Total_COGS,
        SUM(i.operating_expenses) AS Total_operating_expenses,
        
        SUM(i.revenue)
				- SUM(i.cost_of_goods_sold)
                - SUM(i.operating_expenses) AS Total_Operating_Profit
FROM income_statement i
JOIN company c
ON i.company_id = c.company_id
GROUP BY 	i.company_id,
			c.company_name,
			i.year,
			i.month
ORDER BY	i.company_id,
			c.company_name,
			i.year,
			i.month;
SELECT * FROM company_operating_profit;

-- -----------------------------------------------------------Company Net Profit -------------------------------------------------------------------------
CREATE VIEW company_net_profit AS 
SELECT 	i.company_id,
		c.company_name,
		i.year,
        i.month,
        
        SUM(i.revenue) AS Total_revenue,
        SUM(i.cost_of_goods_sold) AS Total_COGS,
        SUM(i.operating_expenses) AS Total_operating_expenses,
        SUM(i.interest_expense) AS Total_interest_expenses,
        SUM(i.tax_expense) AS Tax,
        
        SUM(i.revenue)
			- SUM(i.cost_of_goods_sold)
			- SUM(i.operating_expenses)
			- SUM(i.interest_expense)
			- SUM(i.tax_expense) AS total_net_profit
FROM income_statement i
JOIN company c
ON i.company_id = c.company_id
GROUP BY 	i.company_id,
			c.company_name,
            i.year,
            i.month
ORDER BY 	i.company_id,
			c.company_name,
            i.year,
            i.month;
SELECT * FROM company_net_profit;
            
-- -----------------------------------------------------Monthly Profit Trend------------------------------------------------------------------
CREATE VIEW company_monthly_profit AS
SELECT 	i.company_id,
		c.company_name,
        i.year,
        i.month,
        
        SUM(i.revenue 	- i.cost_of_goods_sold
						- i.operating_expenses
                        - i.interest_expense
                        - i.tax_expense
			) AS Monthly_profit
FROM income_statement i
JOIN company c
ON i.company_id = c.company_id

GROUP BY 	i.company_id,
			c.company_name,
            i.year,
            i.month
            
ORDER BY 	i.company_id,
			c.company_name,
            i.year,
            i.month;
SELECT * FROM company_monthly_profit;
-- -----------------------------------------------------Company Yearly Net Profit-----------------------------------------------------------
CREATE VIEW company_yearly_net_profit AS
SELECT	i.company_id,
		c.company_name,
        i.year,
        SUM(i.revenue 	- i.cost_of_goods_sold
						- i.operating_expenses
                        - i.interest_expense
                        - i.tax_expense
			) AS Yearly_profit
FROM income_statement i
JOIN company c
ON i.company_id = c.company_id

GROUP BY 	i.company_id,
			c.company_name,
            i.year
            
ORDER BY 	i.company_id,
			c.company_name,
            i.year;
SELECT * FROM company_yearly_net_profit;
-- ----------------------------------------------Company Yearly Profit-----------------------------------------------------------
CREATE VIEW company_yearly_revenue AS
SELECT 	i.company_id,
		c.company_name,
        i.year,
        SUM(i.revenue) AS Yearly_revenue
FROM income_statement i
JOIN company c
ON i.company_id = c.company_id

GROUP BY 	i.company_id,
			c.company_name,
            i.year
            
ORDER BY 	i.company_id,
			c.company_name,
            i.year;

SELECT * FROM company_yearly_revenue;

-- -------------------------------------------Company Gross profit margin ---------------------------------------------------------
CREATE VIEW company_gross_profit_margin AS
SELECT 	i.company_id,
		c.company_name,
        i.year,
        i.month,
        ROUND((SUM(i.revenue) - SUM(i.cost_of_goods_sold)) * 100.0 / SUM(i.revenue), 2) AS gross_profit_margin
FROM income_statement i
JOIN company c
ON i.company_id = c.company_id

GROUP BY	i.company_id,
			c.company_name,
            i.year,
            i.month
            
ORDER BY 	i.company_id,
            i.year,
            i.month;
SELECT * FROM company_gross_profit_margin;
-- ------------------------------------------------Company Net profit Margin-----------------------------------------------------
CREATE VIEW company_net_profit_margin AS
SELECT	i.company_id,
		c.company_name,
        i.year,
        i.month,
        ROUND(
        (SUM(i.revenue) - SUM(i.cost_of_goods_sold)
						- SUM(i.operating_expenses) 
                        - SUM(i.interest_expense) 
                        - SUM(i.tax_expense)
		) * 100.0 / SUM(i.revenue), 2
        ) AS Company_net_profit_margin
FROM income_statement i
JOIN company c
ON i.company_id = c.company_id
GROUP BY 	i.company_id,
			c.company_name,
            i.year,
            i.month
            
ORDER BY 	i.company_id,
			c.company_name,
            i.year,
            i.month;
SELECT * FROM company_net_profit_margin;	


-- ------------------------------------------Month-over-month revenue growth-----------------------------------------------------
CREATE VIEW MoM_growth_percentage AS
SELECT		mr.company_id,
			c.company_name,
            mr.year,
            mr.month,
            
            LAG(mr.total_revenue)
				OVER(PARTITION BY mr.company_id ORDER BY mr.year, mr.month) AS previous_month_revenue,
                
			ROUND( mr.total_revenue - 
					LAG(mr.total_revenue)
						OVER(PARTITION BY mr.company_id ORDER BY mr.year, mr.month)
					* 100.0 / 
					LAG(mr.total_revenue)
						OVER(PARTITION BY mr.company_id ORDER BY mr.year, mr.month),2) AS Mom_growth_percentage
FROM monthly_revenue_trend mr
JOIN company c
ON mr.company_id = c.company_id;

SELECT * FROM MoM_growth_percentage;


-- ------------------------------------------------Running Total Revenue------------------------------------------------------
CREATE VIEW Running_total_revenue AS
SELECT 	t.company_id,
		c.company_name,
        t.year,
        t.month,
        t.revenue,
        SUM(t.revenue) OVER(
							PARTITION BY t.company_id
                            ORDER BY t.year, t.month
		) AS Cumulative_revenue
FROM (
	SELECT 
			company_id,
            year,
            month,
            SUM(revenue) AS revenue
    FROM income_statement
    GROUP BY company_id, year, month
) AS t
JOIN company c
ON t.company_id = c.company_id
ORDER BY 	t.company_id,
			t.year,
            t.month;
SELECT * FROM Running_total_revenue;

-- --------------------------------------Top 5 highest revenue by month--------------------------------------------------------
CREATE VIEW top_5_months_by_revenue AS
SELECT
		company_id,
        company_name,
        year,
        month,
        revenue
FROM (
		SELECT 	i.company_id,
				c.company_name,
				i.year,
                i.month,
                i.revenue,
                ROW_NUMBER() OVER(PARTITION BY i.company_id ORDER BY i.revenue DESC) AS rn
        FROM income_statement i
        JOIN company c
        ON c.company_id = i.company_id
        ) AS t
WHERE rn <= 5
ORDER BY 
		company_id,
        revenue DESC;


SELECT * FROM top_5_months_by_revenue;





