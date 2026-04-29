import mysql.connector
from mysql.connector import pooling
from flask import g, current_app

connection_pool = None

def init_db(app):
    global connection_pool
    connection_pool = pooling.MySQLConnectionPool(
        pool_name="buildright_pool",
        pool_size=10,
        host=app.config['DB_HOST'],
        user=app.config['DB_USER'],
        password=app.config['DB_PASSWORD'],
        database=app.config['DB_NAME'],
        autocommit=False
    )

    @app.teardown_appcontext
    def close_connection(exception):
        db = g.pop('db', None)
        if db is not None and db.is_connected():
            db.close()

def get_db():
    if 'db' not in g:
        g.db = connection_pool.get_connection()
    return g.db
