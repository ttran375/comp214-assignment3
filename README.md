# Assignment #3 – Working with Procedures

## Question 1 (5 marks)

Create a procedure named DDPROJ_SP that retrieves project information for a specific project
based on a project ID. The procedure should have two parameters: one to accept a project ID
value and another to return all data for the specified project. Use a record variable to have the
procedure return all database column values for the selected project. Test the procedure with an
anonymous block.

## Question 2 (5 marks)

Create a procedure named DDPAY_SP that identifies whether a donor currently has an active
pledge with monthly payments. A donor ID is the input to the procedure. Using the donor ID, the
procedure needs to determine whether the donor has any currently active pledges based on the
status field and is on a monthly payment plan. If so, the procedure is to return the Boolean value
TRUE. Otherwise, the value FALSE should be returned. Test the procedure with an anonymous
block.

## Question 3 (5 marks)

Create a procedure named DDCKPAY_SP that confirms whether a monthly pledge payment is
the correct amount. The procedure needs to accept two values as input: a payment amount and a
pledge ID. Based on these inputs, the procedure should confirm that the payment is the correct
monthly increment amount, based on pledge data in the database. If it isn’t, a custom Oracle
error using error number 20050 and the message “Incorrect payment amount - planned payment
= ??” should be raised. The ?? should be replaced by the correct payment amount. The database
query in the procedure should be formulated so that no rows are returned if the pledge isn’t on a
monthly payment plan or the pledge isn’t found. If the query returns no rows, the procedure
should display the message “No payment information.” Test the procedure with the pledge ID
104 and the payment amount $25. Then test with the same pledge ID but the payment amount
$20. Finally, test the procedure with a pledge ID for a pledge that doesn’t have monthly
payments associated with it.

## Question 4 (5 marks)

As a shopper selects products on the Brewbean’s site, a procedure is needed to add a newly
selected item to the current shopper’s basket. Create a procedure named BASKET_ADD_SP that
accepts a product ID, basket ID, price, quantity, size code option (1 or 2), and form code option
(3 or 4) and uses this information to add a new item to the BB_BASKETITEM table. The table’s
PRIMARY KEY column is generated by BB_IDBASKETITEM_SEQ. Run the procedure with
the following values:
• Basket ID—14
• Product ID—8
• Price—10.80
• Quantity—1
• Size code—2
• Form code—4
