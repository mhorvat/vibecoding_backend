-- 1. GENERATE Customers
INSERT INTO "customers" (name, email)
SELECT
    'Kupac ' || n, -- Name in the format "Kupac 1", "Kupac 2", ..., "Kupac 5000", in English it would be "Customer 1", "Customer 2", etc.
    'kupac.' || n || '@example.com'
FROM generate_series(1, 5000) AS n;

-- 2. GENERATE Products
INSERT INTO "products" (name, description, price, category)
SELECT
    'Proizvod ' || n, -- Name in the format "Proizvod 1", "Proizvod 2", ..., "Proizvod 20000", in English it would be "Product 1", "Product 2", etc.
    'Detaljan opis za proizvod ' || n, -- Description in the format "Detaljan opis za proizvod 1", "Detaljan opis za proizvod 2", ..., "Detailed description for product 1", "Detailed description for product 2", etc.
    -- Price between 10.00 and 1010.00
    (random() * 1000 + 10)::numeric(10, 2),
    -- Randomly select one of the 5 categories (Elektronika, Odjeća, Knjige, Kućanstvo, Sport) with equal probability. In English, it would be Electronics, Clothing, Books, Home, Sports.
    (ARRAY['Elektronika', 'Odjeća', 'Knjige', 'Kućanstvo', 'Sport'])[floor(random() * 5 + 1)]
FROM generate_series(1, 20000) AS n;

-- 3. GENERATE Orders
INSERT INTO "orders" ("order_date", "customer_id")
SELECT
    -- Random date and time in the last 5 years
    NOW() - (random() * 365 * 5) * '1 day'::interval,
    -- Random customer ID between 1 and 5000
    floor(random() * 5000 + 1)::bigint
FROM generate_series(1, 50000) AS n;

-- 4. GENERATE OrderItems
DO $$
DECLARE
    order_id bigint;
    num_items int;
    i int;
BEGIN
    -- Loop through each order that was just created
    FOR order_id IN SELECT id FROM "orders" LOOP
        -- Each order will have between 1 and 7 items (randomly determined)
        num_items := floor(random() * 7 + 1);
        FOR i IN 1..num_items LOOP
            INSERT INTO "order_items" ("order_id", "product_id", "quantity")
            VALUES (
                order_id,
                -- Random product ID between 1 and 20000
                floor(random() * 20000 + 1)::bigint,
                -- Quantity between 1 and 5
                floor(random() * 5 + 1)
            );
        END LOOP;
    END LOOP;
END $$;