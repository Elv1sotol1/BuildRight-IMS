USE buildright_db;

INSERT INTO users (username, full_name, email, password_hash, role, status)
VALUES (
    'admin',
    'System Administrator',
    'admin@buildright.com',
    '$2b$12$placeholderhashreplacedonsetup',
    'Admin',
    'Active'
);
