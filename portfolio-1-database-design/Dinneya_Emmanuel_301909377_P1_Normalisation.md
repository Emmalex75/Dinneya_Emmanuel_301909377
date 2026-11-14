# Bank / Fintech Platform — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| account_id | payment records (list) |
| --- | --- |
| 201 | [301] |
| 202 | [302] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| payment.payment_id | payment.account_id | payment.payment_ref | account.account_id | account.customer_id | account.account_ref | customer.customer_id | customer.full_name |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 301 | 201 | PAY-2001 | 201 | 101 | ACCT-1001 | 101 | Avery Chen |
| 302 | 202 | PAY-2002 | 202 | 102 | ACCT-1002 | 102 | Jordan Patel |

Key: payment_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## payment_example

| payment.payment_id | payment.account_id | payment.payment_ref | account.account_id | account.customer_id | account.account_ref | customer.customer_id | customer.full_name |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 301 | 201 | PAY-2001 | 201 | 101 | ACCT-1001 | 101 | Avery Chen |
| 302 | 202 | PAY-2002 | 202 | 102 | ACCT-1002 | 102 | Jordan Patel |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## customer

| customer_id | full_name | email | created_at |
| --- | --- | --- | --- |
| 101 | Avery Chen | avery.chen@example.test | 2026-01-10T09:00:00+00:00 |
| 102 | Jordan Patel | jordan.patel@example.test | 2026-01-11T10:30:00+00:00 |

## account

| account_id | customer_id | account_ref | opened_on | available_balance | status |
| --- | --- | --- | --- | --- | --- |
| 201 | 101 | ACCT-1001 | 2026-01-12 | 1250.75 | active |
| 202 | 102 | ACCT-1002 | 2026-01-13 | 500 | active |

## payment

| payment_id | account_id | payment_ref | amount | posted_at | status |
| --- | --- | --- | --- | --- | --- |
| 301 | 201 | PAY-2001 | 42.5 | 2026-02-01T14:15:00+00:00 | completed |
| 302 | 202 | PAY-2002 | 18 | 2026-02-02T13:45:00+00:00 | pending |

## Dependencies

- customer: (customer_id) → full_name, email, created_at
- account: (account_id) → customer_id, account_ref, opened_on, available_balance, status
- payment: (payment_id) → account_id, payment_ref, amount, posted_at, status

Joining the decomposed sample tables reproduces the original 2 example rows. The design assumes the declared keys describe the relevant business dependencies.
