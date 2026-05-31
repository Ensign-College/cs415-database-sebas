CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE address_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE addresses (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    address_type_id INTEGER NOT NULL REFERENCES address_types(id),
    street_line_1 VARCHAR(255) NOT NULL,
    street_line_2 VARCHAR(255),
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(100) NOT NULL DEFAULT 'United States',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE phone_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE phones (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    phone_type_id INTEGER NOT NULL REFERENCES phone_types(id),
    phone_number VARCHAR(30) NOT NULL,
    extension VARCHAR(10),
    is_primary BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE user_infos (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    birth_date DATE,
    occupation VARCHAR(100),
    bio TEXT,
    website VARCHAR(255),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE pages (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(150) NOT NULL,
    slug VARCHAR(180) NOT NULL UNIQUE,
    content TEXT NOT NULL,
    is_published BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_addresses_user_id ON addresses(user_id);
CREATE INDEX idx_addresses_address_type_id ON addresses(address_type_id);
CREATE INDEX idx_phones_user_id ON phones(user_id);
CREATE INDEX idx_phones_phone_type_id ON phones(phone_type_id);
CREATE INDEX idx_pages_user_id ON pages(user_id);

INSERT INTO users (username, email, first_name, last_name, password_hash) VALUES
    ('svargas', 'sebastian.vargas@example.com', 'Sebastian', 'Vargas', 'not-for-production'),
    ('amartinez', 'ana.martinez@example.com', 'Ana', 'Martinez', 'not-for-production'),
    ('jlee', 'jordan.lee@example.com', 'Jordan', 'Lee', 'not-for-production');

INSERT INTO address_types (name, description) VALUES
    ('Home', 'Primary home address'),
    ('Work', 'Work or office address'),
    ('Billing', 'Billing address');

INSERT INTO addresses (
    user_id,
    address_type_id,
    street_line_1,
    street_line_2,
    city,
    state,
    postal_code,
    country
) VALUES
    (1, 1, '123 Mountain View Dr', NULL, 'Denver', 'CO', '80202', 'United States'),
    (1, 2, '800 Campus Way', 'Suite 210', 'Denver', 'CO', '80204', 'United States'),
    (2, 1, '456 Lake Street', 'Apt 12', 'Boulder', 'CO', '80301', 'United States'),
    (3, 3, '789 Aspen Ave', NULL, 'Fort Collins', 'CO', '80521', 'United States');

INSERT INTO phone_types (name, description) VALUES
    ('Mobile', 'Personal mobile phone'),
    ('Home', 'Home phone'),
    ('Work', 'Work phone');

INSERT INTO phones (user_id, phone_type_id, phone_number, extension, is_primary) VALUES
    (1, 1, '303-555-0101', NULL, TRUE),
    (1, 3, '303-555-0188', '204', FALSE),
    (2, 1, '720-555-0122', NULL, TRUE),
    (3, 2, '970-555-0143', NULL, TRUE);

INSERT INTO user_infos (user_id, birth_date, occupation, bio, website) VALUES
    (1, '2002-08-14', 'Student', 'Computer science student building a database API.', 'https://example.com/sebastian'),
    (2, '2001-03-22', 'Designer', 'Enjoys clean interfaces and reliable data.', 'https://example.com/ana'),
    (3, '2000-11-05', 'Developer', 'Likes backend systems and practical projects.', 'https://example.com/jordan');

INSERT INTO pages (user_id, title, slug, content, is_published) VALUES
    (1, 'Welcome Page', 'welcome-page', 'This is the first sample page for the CS415 database.', TRUE),
    (1, 'Database Notes', 'database-notes', 'Notes about PostgreSQL tables, keys, and relationships.', TRUE),
    (2, 'Design Journal', 'design-journal', 'A short page about designing user-friendly data views.', TRUE),
    (3, 'Backend Checklist', 'backend-checklist', 'A checklist for connecting Django models to PostgreSQL.', FALSE);
