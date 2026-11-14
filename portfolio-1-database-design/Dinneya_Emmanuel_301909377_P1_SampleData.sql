-- Fictional sample records for Bank / Fintech Platform.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."customer" ("customer_id", "full_name", "email", "created_at") VALUES (101, 'Avery Chen', 'avery.chen@example.test', '2026-01-10T09:00:00Z');
INSERT INTO portfolio."customer" ("customer_id", "full_name", "email", "created_at") VALUES (102, 'Jordan Patel', 'jordan.patel@example.test', '2026-01-11T10:30:00+00:00');
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_ref", "opened_on", "available_balance", "status") VALUES (201, 101, 'ACCT-1001', '2026-01-12', 1250.75, 'active');
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_ref", "opened_on", "available_balance", "status") VALUES (202, 102, 'ACCT-1002', '2026-01-13', 500, 'active');
INSERT INTO portfolio."payment" ("payment_id", "account_id", "payment_ref", "amount", "posted_at", "status") VALUES (301, 201, 'PAY-2001', 42.5, '2026-02-01T14:15:00Z', 'completed');
INSERT INTO portfolio."payment" ("payment_id", "account_id", "payment_ref", "amount", "posted_at", "status") VALUES (302, 202, 'PAY-2002', 18, '2026-02-02T08:45:00-05:00', 'pending');
COMMIT;
