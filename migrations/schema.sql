CREATE DATABASE IF NOT EXISTS buildright_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE buildright_db;

CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('Admin', 'Manager', 'Staff') NOT NULL DEFAULT 'Staff',
    status ENUM('Active', 'Inactive') NOT NULL DEFAULT 'Active',
    failed_login_attempts INT NOT NULL DEFAULT 0,
    locked_until DATETIME NULL,
    last_login DATETIME NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_role (role),
    INDEX idx_status (status)
);

CREATE TABLE IF NOT EXISTS categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO categories (name, description) VALUES
('Power Tools', 'Electric and battery powered tools'),
('Hand Tools', 'Manual hand-operated tools'),
('Safety Equipment', 'Protective gear and safety items'),
('Heavy Equipment', 'Large machinery and equipment'),
('Materials', 'Raw construction materials'),
('Consumables', 'Items used up during construction');

CREATE TABLE IF NOT EXISTS suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    contact_person VARCHAR(100) NULL,
    phone VARCHAR(30) NULL,
    email VARCHAR(100) NULL,
    address TEXT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_supplier_name (name)
);

CREATE TABLE IF NOT EXISTS inventory_items (
    item_id VARCHAR(20) NOT NULL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT NULL,
    category_id INT NOT NULL,
    unit_of_measure VARCHAR(30) NOT NULL,
    unit_cost DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
    current_stock INT NOT NULL DEFAULT 0,
    reorder_level INT NOT NULL DEFAULT 0,
    supplier_id INT NULL,
    status ENUM('Active', 'Discontinued', 'Out of Stock') NOT NULL DEFAULT 'Active',
    image_path VARCHAR(255) NULL,
    created_by INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id) ON DELETE SET NULL,
    FOREIGN KEY (created_by) REFERENCES users(user_id),
    INDEX idx_item_name (name),
    INDEX idx_item_category (category_id),
    INDEX idx_item_status (status),
    CONSTRAINT chk_stock_non_negative CHECK (current_stock >= 0),
    CONSTRAINT chk_cost_non_negative CHECK (unit_cost >= 0),
    CONSTRAINT chk_reorder_non_negative CHECK (reorder_level >= 0)
);

CREATE TABLE IF NOT EXISTS transactions (
    txn_id INT AUTO_INCREMENT PRIMARY KEY,
    item_id VARCHAR(20) NOT NULL,
    transaction_type ENUM('Inflow', 'Outflow') NOT NULL,
    sub_type ENUM('Purchase', 'Return', 'Adjustment', 'Sale', 'Loan', 'Damage', 'Theft', 'Write-off') NOT NULL,
    quantity INT NOT NULL,
    unit_cost DECIMAL(12, 2) NOT NULL,
    total_value DECIMAL(14, 2) GENERATED ALWAYS AS (quantity * unit_cost) STORED,
    reference_number VARCHAR(50) NULL,
    notes TEXT NULL,
    transaction_date DATE NOT NULL,
    performed_by INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (item_id) REFERENCES inventory_items(item_id),
    FOREIGN KEY (performed_by) REFERENCES users(user_id),
    INDEX idx_txn_item (item_id),
    INDEX idx_txn_date (transaction_date),
    INDEX idx_txn_type (transaction_type),
    INDEX idx_txn_user (performed_by),
    CONSTRAINT chk_quantity_positive CHECK (quantity > 0)
);

CREATE TABLE IF NOT EXISTS audit_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL,
    action VARCHAR(100) NOT NULL,
    table_name VARCHAR(50) NOT NULL,
    record_id VARCHAR(50) NULL,
    old_values JSON NULL,
    new_values JSON NULL,
    ip_address VARCHAR(45) NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_audit_user (user_id),
    INDEX idx_audit_action (action),
    INDEX idx_audit_table (table_name),
    INDEX idx_audit_created (created_at)
);

CREATE TABLE IF NOT EXISTS password_reset_tokens (
    token_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    token VARCHAR(255) NOT NULL UNIQUE,
    expires_at DATETIME NOT NULL,
    used TINYINT(1) NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_token (token)
);

CREATE TABLE IF NOT EXISTS backups (
    backup_id INT AUTO_INCREMENT PRIMARY KEY,
    filename VARCHAR(255) NOT NULL,
    file_size_bytes BIGINT NULL,
    backup_type ENUM('Manual', 'Scheduled') NOT NULL DEFAULT 'Manual',
    status ENUM('Completed', 'Failed') NOT NULL DEFAULT 'Completed',
    performed_by INT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (performed_by) REFERENCES users(user_id) ON DELETE SET NULL
);

DELIMITER //
CREATE TRIGGER IF NOT EXISTS trg_auto_item_status
AFTER UPDATE ON inventory_items
FOR EACH ROW
BEGIN
    IF NEW.current_stock = 0 AND NEW.status = 'Active' THEN
        UPDATE inventory_items SET status = 'Out of Stock' WHERE item_id = NEW.item_id;
    END IF;
    IF NEW.current_stock > 0 AND OLD.status = 'Out of Stock' THEN
        UPDATE inventory_items SET status = 'Active' WHERE item_id = NEW.item_id;
    END IF;
END//
DELIMITER ;
