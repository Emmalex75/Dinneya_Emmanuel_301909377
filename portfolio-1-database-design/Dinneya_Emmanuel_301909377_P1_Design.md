# Bank / Fintech Platform — database design

My case study records customer, account, payment.

## Users

- Customers using accounts and payments
- Operations staff reviewing payment activity

## Main operations

- Open an account for a customer
- Post or review a payment
- Summarize payment activity

## Entities

| Entity | Information stored |
| --- | --- |
| customer | A person who holds one or more platform accounts. |
| account | An account owned by a customer, with a balance and lifecycle status. |
| payment | A payment posted against one account. |

## customer

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| customer_id | BIGINT | PK | Yes |
| full_name | TEXT |  | Yes |
| email | TEXT | Unique | Yes |
| created_at | TIMESTAMPTZ |  | Yes |
- Unique key: (email).

## account

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| account_id | BIGINT | PK | Yes |
| customer_id | BIGINT | FK | Yes |
| account_ref | TEXT | Unique | Yes |
| opened_on | DATE |  | Yes |
| available_balance | NUMERIC(18,2) |  | Yes |
| status | TEXT |  | Yes |
- customer_id → customer.customer_id
- Unique key: (account_ref).

## payment

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| payment_id | BIGINT | PK | Yes |
| account_id | BIGINT | FK | Yes |
| payment_ref | TEXT | Unique | Yes |
| amount | NUMERIC(18,2) |  | Yes |
| posted_at | TIMESTAMPTZ |  | Yes |
| status | TEXT |  | Yes |
- account_id → account.account_id
- Unique key: (payment_ref).

## Relationships and business rules

- Each customer email identifies at most one customer.
- Every account references an existing customer.
- An account's available balance must not be negative.
- A posted payment must have an amount greater than zero.
- Every payment references an existing account.
- Each payment reference identifies at most one payment.

## Assumptions

- Each account belongs to exactly one customer, and each payment belongs to exactly one account.
- Each entity has a globally unique, single-column identifier primary key.
- Required fields represent NOT NULL requirements; all example records and identifiers are synthetic.
- A payment's account identifies its customer; this exercise does not model transfers between two accounts.

