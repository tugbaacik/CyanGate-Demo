# Overview
This project was developed to centrally manage and visualize payment risks by account within our organization using the Lightning Web Component (LWC), Apex, and custom objects. The solution allows users to select an account, view existing payments for that account, and quickly create new payment records from the same interface.

# Object Schema
<img width="1887" height="650" alt="image" src="https://github.com/user-attachments/assets/8425b0b1-5c7f-47f4-b23f-1d6bfdac25fc" />

# Master-Detail vs Lookup Relationship Choice
Chosen Relationship: Master-Detail relationship
Reason of choosing this relationship: The Master-Detail relationship is used to establish a tight dependency between one object (Detail) and another (Master). I chose this relationship because a payment record (Payment__c) cannot be considered a logical entity without an Account, and the Payment record must be linked to the Account. Two critical features of Master-Detail support this project: First, for data integrity, when the Master record is deleted, Detail records are automatically deleted (cascade delete). Second, and most importantly, for financial analysis, it provides the ability to create Roll-Up Summary Fields on the Master object that sum, count, or average the Detail object's fields. This capability is essential for the primary output of our project, the visualization of the total financial risk (Sum of Amount) by Account on the Dashboard.

# Test Coverage Percentage

<img width="1918" height="477" alt="test coverage" src="https://github.com/user-attachments/assets/48d31bbb-b3ca-4844-aa35-c2183de9179d" />
Note: Test coverage percentage is circled in red

# Report
Filters: Due date and Amount
<img width="1919" height="716" alt="image" src="https://github.com/user-attachments/assets/0017f7dd-e14f-4c80-aca1-5476e0c038db" />

# Dashboard
<img width="1898" height="744" alt="image" src="https://github.com/user-attachments/assets/dad354aa-d0fc-495f-9394-6fd4da9a48df" />

 Dashboard offers three main components that enable managers to make instantaneous decisions:

1. Gauge Chart:

Measure: Sum of Amount. Shows the total financial risk for the next month.

2. Bar Chart:

Grouping: Account Name. Shows the accounts with the highest debt.

3. Metric:

Measure: Record Count. Shows the total number of urgent payments to be tracked.

# Images of App Pages

<img width="1902" height="749" alt="image" src="https://github.com/user-attachments/assets/ab1b8daf-6e39-474a-891b-9bb49877e22e" />

<img width="1906" height="745" alt="image" src="https://github.com/user-attachments/assets/8464663a-140b-4d57-bc39-21ac3b61478c" />

<img width="1885" height="750" alt="image" src="https://github.com/user-attachments/assets/58071746-3df5-411a-bd80-622edbe76d08" />
