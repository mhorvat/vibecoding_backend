-- 1. Generiranje KUPACA (Customers)
INSERT INTO "customers" (name, email)
SELECT
    'Kupac ' || n,
    'kupac.' || n || '@example.com'
FROM generate_series(1, 5000) AS n;

-- 2. Generiranje PROIZVODA (Products)
INSERT INTO "products" (name, description, price, category)
SELECT
    'Proizvod ' || n,
    'Detaljan opis za proizvod ' || n,
    -- Cijena između 10.00 i 1010.00
    (random() * 1000 + 10)::numeric(10, 2),
    -- Nasumično odaberi jednu od 5 kategorija
    (ARRAY['Elektronika', 'Odjeća', 'Knjige', 'Kućanstvo', 'Sport'])[floor(random() * 5 + 1)]
FROM generate_series(1, 20000) AS n;

-- 3. Generiranje NARUDŽBI (Orders)
INSERT INTO "orders" ("order_date", "customer_id")
SELECT
    -- Nasumični datum i vrijeme u zadnjih 5 godina
    NOW() - (random() * 365 * 5) * '1 day'::interval,
    -- Nasumični ID kupca od 1 do 5000
    floor(random() * 5000 + 1)::bigint
FROM generate_series(1, 50000) AS n;

-- 4. Generiranje STAVKI NARUDŽBI (OrderItems)
DO $$
DECLARE
    order_id bigint;
    num_items int;
    i int;
BEGIN
    -- Petlja kroz svaku narudžbu koja je upravo stvorena
    FOR order_id IN SELECT id FROM "orders" LOOP
        -- Svaka narudžba će imati između 1 i 7 stavki
        num_items := floor(random() * 7 + 1);
        FOR i IN 1..num_items LOOP
            INSERT INTO "order_items" ("order_id", "product_id", "quantity")
            VALUES (
                order_id,
                -- Nasumični ID proizvoda od 1 do 20000
                floor(random() * 20000 + 1)::bigint,
                -- Količina od 1 do 5
                floor(random() * 5 + 1)
            );
        END LOOP;
    END LOOP;
END $$;