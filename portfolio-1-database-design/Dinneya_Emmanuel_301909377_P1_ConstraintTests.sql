-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. customer pk reject. Expected: pk_customer, SQLSTATE 23505.
INSERT INTO portfolio."customer" ("customer_id", "full_name", "email", "created_at")
VALUES (101, 'Primary Key Test', 'pk.test@example.test', '2026-03-01T09:00:00Z');

-- 2. customer unique reject. Expected: uq_customer_0, SQLSTATE 23505.
INSERT INTO portfolio."customer" ("customer_id", "full_name", "email", "created_at")
VALUES (901, 'Unique Test', 'avery.chen@example.test', '2026-03-01T09:00:00Z');

-- 3. customer not null reject. Expected: full_name, SQLSTATE 23502.
INSERT INTO portfolio."customer" ("customer_id", "full_name", "email", "created_at")
VALUES (902, NULL, 'not.null@example.test', '2026-03-01T09:00:00Z');

-- 4. account pk reject. Expected: pk_account, SQLSTATE 23505.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_ref", "opened_on", "available_balance", "status")
VALUES (201, 101, 'ACCT-PK-TEST', '2026-03-01', 10, 'active');

-- 5. account unique reject. Expected: uq_account_0, SQLSTATE 23505.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_ref", "opened_on", "available_balance", "status")
VALUES (903, 101, 'ACCT-1001', '2026-03-01', 10, 'active');

-- 6. account fk reject. Expected: fk_account_0, SQLSTATE 23503.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_ref", "opened_on", "available_balance", "status")
VALUES (904, 999999, 'ACCT-FK-TEST', '2026-03-01', 10, 'active');

-- 7. account check reject. Expected: account_balance_nonnegative, SQLSTATE 23514.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_ref", "opened_on", "available_balance", "status")
VALUES (905, 101, 'ACCT-CHECK-TEST', '2026-03-01', -1, 'active');

-- 8. payment pk reject. Expected: pk_payment, SQLSTATE 23505.
INSERT INTO portfolio."payment" ("payment_id", "account_id", "payment_ref", "amount", "posted_at", "status")
VALUES (301, 201, 'PAY-PK-TEST', 1, '2026-03-01T09:00:00Z', 'completed');

-- 9. payment unique reject. Expected: uq_payment_0, SQLSTATE 23505.
INSERT INTO portfolio."payment" ("payment_id", "account_id", "payment_ref", "amount", "posted_at", "status")
VALUES (906, 201, 'PAY-2001', 1, '2026-03-01T09:00:00Z', 'completed');

-- 10. payment fk reject. Expected: fk_payment_0, SQLSTATE 23503.
INSERT INTO portfolio."payment" ("payment_id", "account_id", "payment_ref", "amount", "posted_at", "status")
VALUES (907, 999998, 'PAY-FK-TEST', 1, '2026-03-01T09:00:00Z', 'completed');

-- 11. payment check reject. Expected: payment_amount_positive, SQLSTATE 23514.
INSERT INTO portfolio."payment" ("payment_id", "account_id", "payment_ref", "amount", "posted_at", "status")
VALUES (908, 201, 'PAY-CHECK-TEST', 0, '2026-03-01T09:00:00Z', 'completed');
