CREATE DATABASE concepts;
USE concepts;
-- CREATING AUTHOR TABLE
CREATE TABLE AUTHOR(
Author_ID VARCHAR(50),
Author_Name VARCHAR(50)
);
ALTER TABLE AUTHOR ALTER COLUMN Author_ID VARCHAR(50) NOT NULL; 
ALTER TABLE AUTHOR ADD CONSTRAINT PK_AUTHOR PRIMARY KEY(Author_ID);
CREATE TABLE PUBLISHER(
Publisher_ID VARCHAR(50) PRIMARY KEY,
Publisher_Name VARCHAR(50)
);
CREATE TABLE BOOKS(
Book_ID VARCHAR(50) PRIMARY KEY,
Book_Name VARCHAR(50),
Author_ID VARCHAR(50) REFERENCES AUTHOR,
Price DECIMAL(18,3),
Publisher_ID VARCHAR(50) REFERENCES PUBLISHER,
);
CREATE TABLE CREDIT_CARD_DETAILS(
Credit_Card_Number VARCHAR(50) PRIMARY KEY,
Credit_Card_Type VARCHAR(50),
Expiry_Date DATE
);
CREATE TABLE CUSTOMER(
Customer_ID VARCHAR(50) PRIMARY KEY,
Customer_Name VARCHAR(50),
Street_Address VARCHAR(50),
City VARCHAR(50),
Phone_Number VARCHAR(50),
Credit_Card_Number VARCHAR(50) REFERENCES Credit_Card_Details
);
CREATE TABLE SHIPPING_TYPE(
Shipping_Type VARCHAR(50) PRIMARY KEY,
Shipping_Price DECIMAL(18,3)
);
CREATE TABLE SHOPPING_CART(
Shopping_Cart_ID DECIMAL(18,3) PRIMARY KEY,
Book_ID VARCHAR(50) REFERENCES BOOKS,
Price DECIMAL(18,3),
Date DATE,
Quantity DECIMAL(18,3)
);
CREATE TABLE ORDER_DETAILS(
Order_ID DECIMAL(18,3) PRIMARY KEY,
Customer_ID VARCHAR(50) REFERENCES CUSTOMER,
Shipping_Type VARCHAR(50) REFERENCES SHIPPING_TYPE,
Date_Of_Purchase DATE,
Shopping_Cart_ID DECIMAL(18,3) REFERENCES SHOPPING_CART
);
CREATE TABLE PURCHASE_HISTORY(
Customer_ID VARCHAR(50) REFERENCES CUSTOMER,
Order_ID DECIMAL(18,3) REFERENCES ORDER_DETAILS
);

INSERT INTO AUTHOR VALUES ('a1','Suzanne Collins'),('a2','William Cooper');
INSERT INTO BOOKS VALUES('b1','Behold A Pale Horse','a2',499.23,'p1'),('b2','The Hunger Games','a1',792.41,'p2');
INSERT INTO CUSTOMER VALUES('c1','Dhara Sojitra','Raiya Street','Rajkot','9898945214','123'),('c2','Ayaz Arbi','Wall Street','New York','6598241574','456');
INSERT INTO CREDIT_CARD_DETAILS VALUES ('123','VISA','2026-09-11'),('456','RUPAY','2027-04-12');
INSERT INTO PUBLISHER VALUES('p1','Priyank Dave'),('p2','Yashvi Khunt');
INSERT INTO ORDER_DETAILS VALUES(1,'c1','Air Freight','2023-07-09',4),(2,'c1','Air Freight','2023-06-08',1),(3,'c2','Ground Freight','2023-04-10',3),(4,'c2','Ocean Freight','2023-06-11',2);
INSERT INTO SHIPPING_TYPE VALUES('Air Freight',567.45),('Ocean Freight',789.63),('Ground Freight',255.12);
INSERT INTO SHOPPING_CART VALUES(1,'b2',14.4,'2023-06-08',2),(2,'b2',16.50,'2023-06-11',1),(3,'b1',23.62,'2023-04-10',1),(4,'b1',29.8,'2023-07-09',1);
INSERT INTO PURCHASE_HISTORY VALUES('c1',1),('c2',2),('c1',3),('c2',4);

-- Create the view for the Customer_Details. View should include the columns: Customer Name, Customer Address and details of the order placed by customer.
CREATE VIEW view_customer_details AS 
SELECT Customer_Name,Street_Address AS Customer_Address,Date_of_Purchase FROM CUSTOMER INNER JOIN ORDER_DETAILS ON CUSTOMER.Customer_ID = ORDER_DETAILS.Customer_ID;

-- Create a report that contains each customer's history of purchasing books. Be sure to include the cusotmer name, customer ID, book ID, DOP and shopping card ID.
CREATE VIEW view_customer_history AS 
SELECT Customer_Name,CUSTOMER.Customer_ID AS Customer_ID,Book_ID,Date_of_Purchase,a.Shopping_Cart_ID AS Shopping_Cart_ID FROM CUSTOMER INNER JOIN
(
SELECT Book_ID,Date_of_Purchase,ORDER_DETAILS.Shopping_Cart_ID,Customer_ID FROM ORDER_DETAILS INNER JOIN SHOPPING_CART ON ORDER_DETAILS.Shopping_Cart_ID = SHOPPING_CART.Shopping_Cart_ID
) AS a
ON CUSTOMER.Customer_ID = a.Customer_ID;