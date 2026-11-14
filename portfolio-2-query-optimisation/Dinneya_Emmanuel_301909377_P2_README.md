# Bank / Fintech Platform — SQL queries

## 1. Show related payment, account, customer records (up to 20).

```sql
SELECT t0."payment_id" AS "payment_payment_id",
       t0."payment_ref" AS "payment_payment_ref",
       t1."account_id" AS "account_account_id",
       t1."account_ref" AS "account_account_ref",
       t2."customer_id" AS "customer_customer_id",
       t2."full_name" AS "customer_full_name"
FROM portfolio."payment" t0
JOIN portfolio."account" t1 ON t0."account_id" = t1."account_id"
JOIN portfolio."customer" t2 ON t1."customer_id" = t2."customer_id"
ORDER BY t0."payment_id", t1."account_id", t2."customer_id"
LIMIT 20;
```

| payment_payment_id | payment_payment_ref | account_account_id | account_account_ref | customer_customer_id | customer_full_name |
| --- | --- | --- | --- | --- | --- |
| 301 | PAY-2001 | 201 | ACCT-1001 | 101 | Avery Chen |
| 302 | PAY-2002 | 202 | ACCT-1002 | 102 | Jordan Patel |

## 2. Find payment records where posted_at matches "2026-02-01T14:15:00Z" (up to 20).

```sql
SELECT * FROM portfolio."payment"
WHERE "posted_at" IS NOT DISTINCT FROM '2026-02-01T14:15:00Z'
ORDER BY "payment_id"
LIMIT 20;
```

| payment_id | account_id | payment_ref | amount | posted_at | status |
| --- | --- | --- | --- | --- | --- |
| 301 | 201 | PAY-2001 | 42.5 | 2026-02-01T14:15:00+00:00 | completed |

## 3. Count payment records for each account_id (up to 20 groups).

```sql
SELECT "account_id", count(*) AS record_count
FROM portfolio."payment"
GROUP BY "account_id"
ORDER BY record_count DESC, "account_id" NULLS LAST
LIMIT 20;
```

| account_id | record_count |
| --- | --- |
| 201 | 1 |
| 202 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 2.307 | 2.682, 2.307, 2.265 | Sort → Seq Scan | 274 |
| After index | 0.275 | 0.325, 0.27, 0.275 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 55 |

The median execution time changed from 2.307 ms to 0.275 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=2.643..2.646 rows=50 loops=1)
  Seq Scan on payment (actual time=0.022..2.594 rows=50 loops=1)
Planning Time: 0.44 ms
Execution Time: 2.682 ms
```

### Before index, run 2

```text
Sort (actual time=2.273..2.276 rows=50 loops=1)
  Seq Scan on payment (actual time=0.015..2.229 rows=50 loops=1)
Planning Time: 0.382 ms
Execution Time: 2.307 ms
```

### Before index, run 3

```text
Sort (actual time=2.234..2.237 rows=50 loops=1)
  Seq Scan on payment (actual time=0.014..2.198 rows=50 loops=1)
Planning Time: 0.313 ms
Execution Time: 2.265 ms
```

### After index, run 1

```text
Sort (actual time=0.251..0.255 rows=50 loops=1)
  Bitmap Heap Scan on payment (actual time=0.043..0.204 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.025..0.025 rows=50 loops=1)
Planning Time: 0.564 ms
Execution Time: 0.325 ms
```

### After index, run 2

```text
Sort (actual time=0.214..0.217 rows=50 loops=1)
  Bitmap Heap Scan on payment (actual time=0.033..0.178 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.019..0.019 rows=50 loops=1)
Planning Time: 0.48 ms
Execution Time: 0.27 ms
```

### After index, run 3

```text
Sort (actual time=0.219..0.222 rows=50 loops=1)
  Bitmap Heap Scan on payment (actual time=0.033..0.184 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.019..0.019 rows=50 loops=1)
Planning Time: 0.48 ms
Execution Time: 0.275 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Dinneya_Emmanuel_301909377_P2_Queries.sql, then Dinneya_Emmanuel_301909377_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Dinneya_Emmanuel_301909377_P2_QueryResults.png) · [Index comparison](screenshots/Dinneya_Emmanuel_301909377_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

