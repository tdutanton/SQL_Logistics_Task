-- 1. Клиенты (отправители и получатели)
CREATE TABLE clients (
    client_id SERIAL PRIMARY KEY,
    company_name VARCHAR(150),          -- NULL, если физическое лицо
    full_name VARCHAR(120),             -- NULL, если юрлицо
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    address TEXT NOT NULL,
    is_company BOOLEAN NOT NULL,        -- true = юрлицо, false = физлицо
    created_at TIMESTAMP DEFAULT NOW(),
    
    -- Ограничение: либо company_name, либо full_name должно быть заполнено
    CONSTRAINT chk_client_name CHECK (
        (is_company AND company_name IS NOT NULL AND full_name IS NULL) OR
        (NOT is_company AND full_name IS NOT NULL AND company_name IS NULL)
    )
);

-- 2. Автомобили
CREATE TABLE vehicles (
    vehicle_id SERIAL PRIMARY KEY,
    license_plate VARCHAR(15) UNIQUE NOT NULL,  -- гос. номер
    model VARCHAR(100) NOT NULL,
    max_payload_kg NUMERIC(10,2) NOT NULL CHECK (max_payload_kg > 0),
    status VARCHAR(20) NOT NULL CHECK (status IN ('available', 'in_transit', 'maintenance')),
    acquired_at DATE NOT NULL
);

-- 3. Водители
CREATE TABLE drivers (
    driver_id SERIAL PRIMARY KEY,
    full_name VARCHAR(120) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    license_number VARCHAR(30) UNIQUE NOT NULL,
    license_expiry DATE NOT NULL,
    hired_at DATE NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('active', 'suspended', 'fired'))
);

-- 4. Заказы на перевозку
CREATE TABLE shipments (
    shipment_id SERIAL PRIMARY KEY,
    client_id INT NOT NULL REFERENCES clients(client_id),
    driver_id INT NOT NULL REFERENCES drivers(driver_id),
    vehicle_id INT NOT NULL REFERENCES vehicles(vehicle_id),
    origin_address TEXT NOT NULL,       -- откуда
    destination_address TEXT NOT NULL,  -- куда
    scheduled_departure TIMESTAMP NOT NULL,
    actual_departure TIMESTAMP,
    actual_arrival TIMESTAMP,
    status VARCHAR(20) NOT NULL CHECK (status IN ('scheduled', 'in_transit', 'delivered', 'cancelled')),
    created_at TIMESTAMP DEFAULT NOW(),
      
    -- Ограничение: дата прибытия >= дата отправки
    CONSTRAINT chk_dates CHECK (
        actual_arrival IS NULL OR actual_departure IS NULL OR actual_arrival >= actual_departure
    )
);

-- 5. Грузы (в рамках одного заказа может быть несколько грузов)
CREATE TABLE cargoes (
    cargo_id SERIAL PRIMARY KEY,
    shipment_id INT NOT NULL REFERENCES shipments(shipment_id) ON DELETE CASCADE,
    description TEXT NOT NULL,
    weight_kg NUMERIC(10,2) NOT NULL CHECK (weight_kg > 0),
    volume_m3 NUMERIC(8,3) NOT NULL CHECK (volume_m3 > 0),
    cargo_type VARCHAR(50) NOT NULL,
    declared_value NUMERIC(14,2) CHECK (declared_value >= 0)
);
