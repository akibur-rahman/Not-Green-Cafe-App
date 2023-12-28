from flask import Flask, jsonify, request, session
from flask_sqlalchemy import SQLAlchemy
import mysql.connector
from config import DATABASE_CONFIG  # Import the database configuration

app = Flask(__name__)

# Configure the database connection using values from the config file
app.config['SQLALCHEMY_DATABASE_URI'] = f"mysql+mysqlconnector://{DATABASE_CONFIG['user']}:{
    DATABASE_CONFIG['password']}@{DATABASE_CONFIG['host']}/{DATABASE_CONFIG['database']}"
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


@app.route('/login', methods=['POST'])
def login():
    try:
        connection = mysql.connector.connect(**DATABASE_CONFIG)
        cursor = connection.cursor(dictionary=True)
        data = request.get_json()
        email = data.get('email')
        password = data.get('password')

        # Validate that both email and password are provided
        if not email or not password:
            return jsonify({'error': 'Email and password are required'}), 400

        # Query the database to check if the user exists
        query = "SELECT * FROM users WHERE email = %s AND password = %s"
        params = (email, password)
        cursor = connection.cursor(dictionary=True)
        cursor.execute(query, params)
        user = cursor.fetchone()

        # If user exists, store user_id in session and return a success message
        if user:
            session['user_id'] = user['user_id']
            return jsonify({'message': 'Login successful'}), 200
        else:
            return jsonify({'error': 'Invalid email or password'}), 401

    except Exception as e:
        return jsonify({'error': str(e)})

    finally:
        if cursor:
            cursor.close()


# ...

@app.route('/home', methods=['GET'])
def home():
    # Check if user is logged in by checking if user_id is in session
    if 'user_id' in session:
        return jsonify({'message': 'Welcome to the Home Page'})
    else:
        return jsonify({'error': 'Unauthorized'}), 401

# ...


@app.route('/logout', methods=['GET'])
def logout():
    # Clear the session to log out the user
    session.clear()
    return jsonify({'message': 'Logout successful'}), 200


@app.route('/register', methods=['POST'])
def register():
    try:
        connection = mysql.connector.connect(**DATABASE_CONFIG)
        cursor = connection.cursor(dictionary=True)
        data = request.get_json()

        # Extract user data from the request
        name = data.get('name')
        email = data.get('email')
        password = data.get('password')
        sex = data.get('sex')
        address = data.get('address')
        birthdate = data.get('birthdate')

        # Validate that all required fields are provided
        if not name or not email or not password or not sex or not address or not birthdate:
            return jsonify({'error': 'All fields are required'}), 400

        # Insert the new user into the database
        query = "INSERT INTO users (name, email, password, sex, address, birthdate) VALUES (%s, %s, %s, %s, %s, %s)"
        params = (name, email, password, sex, address, birthdate)
        cursor.execute(query, params)
        connection.commit()

        return jsonify({'message': 'Registration successful'}), 200

    except Exception as e:
        return jsonify({'error': str(e)})

    finally:
        if cursor:
            cursor.close()

# Ensure to add this part to close the connection after the server is stopped


@app.teardown_appcontext
def close_connection(exception=None):
    connection = mysql.connector.connect(**DATABASE_CONFIG)
    if connection:
        connection.close()


if __name__ == '__main__':
    app.run(debug=True)
