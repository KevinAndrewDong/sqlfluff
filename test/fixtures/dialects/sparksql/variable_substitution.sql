-- Native Spark substitution is kept verbatim by the raw templater.
SET foo=(1, 3);

SELECT *
FROM t
WHERE bar IN ${foo};

SELECT * FROM t WHERE bar NOT IN ${hivevar:foo};
SELECT * FROM t WHERE bar IN (${foo});
SELECT ${foo} AS result;
SELECT ${threshold} + 1 FROM t WHERE bar = ${foo};
SELECT coalesce(${default_value}, 0) FROM t;
SELECT * FROM ${table_name};
SELECT * FROM ${catalog}.${schema}.${table_name};

SELECT
    ${system:user.name},
    ${env:HOME},
    ${spark:foo},
    ${sparkconf:foo},
    ${hivevar:foo},
    ${hiveconf:spark.sql.shuffle.partitions},
    ${foo-bar},
    ${9value},
    ${under_score};

-- Placeholders within quotes and comments retain their original tokens.
SELECT '${foo}', "${env:HOME}", `${column}` FROM t;
SELECT 1 -- ${foo}
/* ${hiveconf:key} */;

-- Existing named parameters, ordinary literals and IN expressions still parse.
SELECT :value, '$cash', 1.25, true, NULL, DATE '2024-01-01' FROM t;
SELECT * FROM t WHERE bar IN (1, 3) AND foo NOT IN (SELECT foo FROM other_table);
