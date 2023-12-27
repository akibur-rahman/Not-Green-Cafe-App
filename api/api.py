# app.py

from flask import Flask, jsonify
from flask_sqlalchemy import SQLAlchemy
import mysql.connector
from config import DATABASE_CONFIG  # Import the database configuration

app = Flask(__name__)

# Configure the database connection using values from the config file
app.config['SQLALCHEMY_DATABASE_URI'] = f"mysql+mysqlconnector://{DATABASE_CONFIG['user']}:{DATABASE_CONFIG['password']}@{DATABASE_CONFIG['host']}/{DATABASE_CONFIG['database']}"
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# Route to get all items from the menu_items table using raw SQL query
@app.route('/menu_items', methods=['GET'])
def get_menu_items():
    try:
        connection = mysql.connector.connect(**DATABASE_CONFIG)
        cursor = connection.cursor(dictionary=True)

        query = "SELECT * FROM menu_items"
        cursor.execute(query)
        menu_items = cursor.fetchall()

        menu_items_list = []
        for item in menu_items:
            menu_items_list.append({
                'item_id': item['item_id'],
                'name': item['name'],
                'description': item['description'],
                'price': item['price'],
                'category': item['category'],
                'image_url': item['image_url']
            })

        return jsonify(menu_items_list)

    except Exception as e:
        return jsonify({'error': str(e)})

    finally:
        if connection:
            connection.close()

# Route to get all orders using raw SQL query
@app.route('/orders', methods=['GET'])
def get_orders_route():
    return get_orders()


def get_orders():
    try:
        connection = mysql.connector.connect(**DATABASE_CONFIG)
        cursor = connection.cursor(dictionary=True)

        query = "SELECT order_id, customer_id, item_id, quantity, total_price, status FROM orders"
        cursor.execute(query)
        orders = cursor.fetchall()

        orders_list = []
        for order in orders:
            orders_list.append({
                'order_id': order['order_id'],
                'customer_id': order['customer_id'],
                'item_id': order['item_id'],
                'quantity': order['quantity'],
                'total_price': order['total_price'],
                'status': order['status']
            })

        return jsonify(orders_list)

    except Exception as e:
        return jsonify({'error': str(e)})

    finally:
        if connection:
            connection.close()


if __name__ == '__main__':
    app.run(debug=True)
