-- ============================================================
-- Сбор данных для анализа маркетплейса
-- Период: 2024 год
-- Источник: pa_graduate
-- ============================================================
--
-- Примечание: таблица Campaign_costs (маркетинговые расходы
-- по каналам и месяцам) предоставлена в готовом виде и не
-- требует отдельного запроса.
-- ============================================================


-- ------------------------------------------------------------
-- 1. Пользователи
-- Регистрации за 2024 год с демографическими параметрами
-- и когортной разбивкой по неделе и месяцу
-- ------------------------------------------------------------

SELECT
    us.user_id,
    registration_date,
    user_params->>'age'            AS age,
    user_params->>'gender'         AS gender,
    user_params->>'region'         AS region,
    user_params->>'acq_channel'    AS acq_channel,
    user_params->>'buyer_segment'  AS buyer_segment,
    date_trunc('week',  registration_date)::date AS cohort_week,
    date_trunc('month', registration_date)::date AS cohort_month
FROM pa_graduate.Users AS us
WHERE registration_date >= '2024-01-01'
  AND registration_date  < '2025-01-01'
ORDER BY registration_date;


-- ------------------------------------------------------------
-- 2. События
-- Все пользовательские события за 2024 год.
-- Через JOIN с Product_dict подтягивается название товара
-- ------------------------------------------------------------

SELECT
    event_id,
    user_id,
    timestamp                          AS event_date,
    event_type,
    event_params->>'os'                AS os,
    event_params->>'device'            AS device,
    product_name,
    date_trunc('week',  timestamp)::date AS event_week,
    date_trunc('month', timestamp)::date AS event_month
FROM pa_graduate.Events AS ev
LEFT JOIN pa_graduate.Product_dict AS pr ON pr.product_id = ev.product_id
WHERE timestamp >= '2024-01-01'
  AND timestamp  < '2025-01-01'
ORDER BY event_date;


-- ------------------------------------------------------------
-- 3. Заказы
-- Все заказы за 2024 год с товарами и суммами.
-- Через JOIN с Product_dict подтягивается название и категория товара.
-- Выручка маркетплейса = 5% от total_price
-- ------------------------------------------------------------

SELECT
    order_id,
    user_id,
    order_date,
    product_name,
    quantity,
    unit_price,
    total_price,
    category_name,
    date_trunc('week',  order_date)::date AS order_week,
    date_trunc('month', order_date)::date AS order_month
FROM pa_graduate.Orders AS o
LEFT JOIN pa_graduate.Product_dict AS pr ON pr.product_id = o.product_id
WHERE order_date >= '2024-01-01'
  AND order_date  < '2025-01-01'
ORDER BY order_date;
