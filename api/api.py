import secrets
from config import DATABASE_CONFIG
from flask import Flask, jsonify, request, session
from flask_sqlalchemy import SQLAlchemy
import mysql.connector
import uuid
from config import DATABASE_CONFIG  # Import the database configuration

app = Flask(__name__)

# Set the secret key for the Flask application
app.secret_key = secrets.token_hex(16)

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


# Route to insert a new menu item
@app.route('/add_menu_items', methods=['POST'])
def insert_menu_item():
    try:
        # Connect to the database
        connection = mysql.connector.connect(**DATABASE_CONFIG)
        cursor = connection.cursor(dictionary=True)

        # Get menu item data from the request
        data = request.get_json()
        name = data.get('name')
        description = data.get('description')
        price = data.get('price')
        category = data.get('category')  # Retrieve category as string
        image_url = data.get('image_url')

        # Validate that all required fields are provided
        if not name or not description or not price or not category or not image_url:
            return jsonify({'error': 'All fields are required'}), 400

        # Generate a UUID for item_id
        item_id = str(uuid.uuid4())

        # Insert the new menu item into the database
        query = "INSERT INTO menu_items (item_id, name, description, price, category, image_url) VALUES (%s, %s, %s, %s, %s, %s)"
        params = (item_id, name, description, price, category, image_url)
        cursor.execute(query, params)

        # Commit the transaction
        connection.commit()

        return jsonify({'message': 'Menu item added successfully'}), 201

    except Exception as e:
        print(f'Error: {e}')
        return jsonify({'error': 'Internal Server Error'}), 500

    finally:
        print(f'Data received: {data}')
        if connection:
            connection.close()


# Update menu item
@app.route('/update_menu_items', methods=['PUT'])
def update_menu_item():
    try:
        # Connect to the database
        connection = mysql.connector.connect(**DATABASE_CONFIG)
        cursor = connection.cursor(dictionary=True)

        # Get menu item data from the request
        data = request.get_json()
        item_id = data.get('item_id')
        name = data.get('name')
        description = data.get('description')
        price = data.get('price')
        category = data.get('category')  # Retrieve category as string
        image_url = data.get('image_url')

        # Validate that all required fields are provided
        if not item_id or not name or not description or not price or not category or not image_url:
            return jsonify({'error': 'All fields are required'}), 400

        # Update the menu item into the database
        query = "UPDATE menu_items SET name = %s, description = %s, price = %s, category = %s, image_url = %s WHERE item_id = %s"
        params = (name, description, price, category, image_url, item_id)
        cursor.execute(query, params)

        # Commit the transaction
        connection.commit()

        return jsonify({'message': 'Menu item updated successfully'}), 201

    except Exception as e:
        print(f'Error: {e}')
        return jsonify({'error': 'Internal Server Error'}), 500

    finally:
        print(f'Data received: {data}')
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

        query = """
            SELECT 
                o.order_id, 
                c.name as customer_name,
                m.name as item_name,
                o.quantity, 
                o.total_price, 
                o.status 
            FROM orders o
            JOIN users c ON o.customer_id = c.user_id
            JOIN menu_items m ON o.item_id = m.item_id
        """
        cursor.execute(query)
        orders = cursor.fetchall()

        orders_list = []
        for order in orders:
            orders_list.append({
                'order_id': order['order_id'],
                'customer_name': order['customer_name'],
                'item_name': order['item_name'],
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


@app.route('/update_order_status', methods=['PUT'])
def update_order_status():
    try:
        # Connect to the database
        connection = mysql.connector.connect(**DATABASE_CONFIG)
        cursor = connection.cursor(dictionary=True)

        # Get order data from the request
        data = request.get_json()
        order_id = data.get('order_id')
        new_status = data.get('new_status')

        # Validate that all required fields are provided
        if not order_id or not new_status:
            return jsonify({'error': 'Order ID and new status are required'}), 400

        # Check if the new status is valid
        valid_statuses = {'Processing', 'Confirmed', 'Delivered'}
        if new_status not in valid_statuses:
            return jsonify({'error': 'Invalid status'}), 400

        # Update the order status in the database
        query = "UPDATE orders SET status = %s WHERE order_id = %s"
        params = (new_status, order_id)
        cursor.execute(query, params)

        # Commit the transaction
        connection.commit()

        return jsonify({'message': 'Order status updated successfully'}), 200

    except Exception as e:
        print(f'Error: {e}')
        return jsonify({'error': 'Internal Server Error'}), 500

    finally:
        print(f'Data received: {data}')
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

        # If user exists, store user_id in session and return all user data
        if user:
            session['user_id'] = user['user_id']

            # Fetch all data for the user
            user_data_query = "SELECT * FROM users WHERE user_id = %s"
            user_data_params = (user['user_id'],)
            cursor.execute(user_data_query, user_data_params)
            user_data = cursor.fetchone()

            # Ensure user_data is present in the response
            if user_data:
                return jsonify({
                    'message': 'Login successful',
                    'userData': user_data
                }), 200
            else:
                return jsonify({'error': 'Invalid response from the server'}), 500

        else:
            return jsonify({'error': 'Invalid email or password'}), 401

    except Exception as e:
        return jsonify({'error': str(e)})

    finally:
        if cursor:
            cursor.close()


# ...

# @app.route('/home', methods=['GET'])
# def home():
#     # Check if user is logged in by checking if user_id is in session
#     if 'user_id' in session:
#         return jsonify({'message': 'Welcome to the Home Page'})
#     else:
#         return jsonify({'error': 'Unauthorized'}), 401

# # ...


@app.route('/place_order', methods=['POST'])
def place_order():
    try:
        # Connect to the database
        connection = mysql.connector.connect(**DATABASE_CONFIG)
        cursor = connection.cursor(dictionary=True)

        # Get order data from the request
        data = request.get_json()
        customer_id = data.get('customer_id')
        item_id = data.get('item_id')
        quantity = data.get('quantity')

        # Validate that all required fields are provided
        if not customer_id or not item_id or not quantity:
            return jsonify({'error': 'Customer ID, Item ID, and Quantity are required'}), 400

        # Fetch the item price based on item_id from the menu_items table
        query = "SELECT price FROM menu_items WHERE item_id = %s"
        cursor.execute(query, (item_id,))
        item = cursor.fetchone()

        # Check if the item exists
        if not item:
            return jsonify({'error': 'Item not found'}), 404

        # Calculate total price using the actual item price
        item_price = item['price']
        total_price = quantity * item_price

        # Generate a UUID for order_id
        order_id = str(uuid.uuid4())

        # Insert the order into the database
        query = "INSERT INTO orders (order_id, customer_id, item_id, quantity, total_price, status) VALUES (%s, %s, %s, %s, %s, %s)"
        params = (order_id, customer_id, item_id,
                  quantity, total_price, 'Processing')
        cursor.execute(query, params)

        # Commit the transaction
        connection.commit()

        return jsonify({'message': 'Order placed successfully'}), 201

    except Exception as e:
        print(f'Error: {e}')
        return jsonify({'error': 'Internal Server Error'}), 500

    finally:
        if connection:
            connection.close()


@app.route('/admin/login', methods=['POST'])
def admin_login():
    try:
        connection = mysql.connector.connect(**DATABASE_CONFIG)
        cursor = connection.cursor(dictionary=True)

        data = request.get_json()
        username = data.get('username')
        password = data.get('password')

        # Validate that both username and password are provided
        if not username or not password:
            return jsonify({'error': 'Username and password are required'}), 400

        # Query the database to check if the admin exists
        query = "SELECT * FROM admin WHERE username = %s AND password = %s"
        params = (username, password)
        cursor.execute(query, params)
        admin = cursor.fetchone()

        # If admin exists, return success message
        if admin:
            return jsonify({'message': 'Admin login successful'}), 200
        else:
            return jsonify({'error': 'Invalid username or password'}), 401

    except Exception as e:
        return jsonify({'error': str(e)})

    finally:
        if cursor:
            cursor.close()
        if connection:
            connection.close()


@app.route('/logout', methods=['POST'])
def logout():
    try:
        connection = mysql.connector.connect(**DATABASE_CONFIG)
        cursor = connection.cursor(dictionary=True)
        data = request.get_json()

        user_id = data.get('user_id')

        if not user_id:
            return jsonify({'error': 'User ID is required'}), 400

        # Perform logout actions if needed

        return jsonify({'message': 'Logout successful'}), 200

    except Exception as e:
        return jsonify({'error': str(e)})

    finally:
        if cursor:
            cursor.close()


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
        profile_picture_url = data.get('profile_picture_url')  # Added line

        # Validate that all required fields are provided
        if not name or not email or not password or not sex or not address or not birthdate:
            return jsonify({'error': 'All fields are required'}), 400

        # Generate a UUID for user_id
        user_id = str(uuid.uuid4())

        # Insert the new user into the database
        # Modified line
        query = "INSERT INTO users (user_id, name, email, password, sex, address, birthdate, profile_picture_url) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"
        params = (user_id, name, email, password, sex, address,
                  birthdate, profile_picture_url)  # Modified line
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
