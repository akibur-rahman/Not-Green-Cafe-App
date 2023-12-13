from flask import Flask, jsonify
from flask_sqlalchemy import SQLAlchemy
import mysql.connector

app = Flask(__name__)

# Configure the database connection
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+mysqlconnector://root:@localhost/notgreencafe'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# Define the MenuItems model


class MenuItem(db.Model):
    __tablename__ = 'menu_items'

    item_id = db.Column(db.String(255), primary_key=True)
    name = db.Column(db.String(255))
    description = db.Column(db.Text)
    price = db.Column(db.Integer)
    category = db.Column(
        db.Enum('Curry', 'Snacks', 'Drinks', 'Set Menu', 'Rice', 'Combo'))
    image_url = db.Column(db.Text)

# Route to get all items from the menu_items table


@app.route('/menu_items', methods=['GET'])
def get_menu_items():
    menu_items = MenuItem.query.all()
    menu_items_list = []
    for item in menu_items:
        menu_items_list.append({
            'item_id': item.item_id,
            'name': item.name,
            'description': item.description,
            'price': item.price,
            'category': item.category,
            'image_url': item.image_url
        })
    return jsonify(menu_items_list)


if __name__ == '__main__':
    app.run(debug=True)
