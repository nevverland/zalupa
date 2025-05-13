import math

def calculate_material_quantity(cursor, product_type_id, material_type_id, product_quantity, param1, param2, stock_quantity):
    cursor.execute("SELECT coefficient FROM product_type WHERE product_type_id = ?", (product_type_id,))
    coef_row = cursor.fetchone()
    cursor.execute("SELECT defect_rate FROM material_type WHERE material_type_id = ?", (material_type_id,))
    defect_row = cursor.fetchone()

    if not coef_row or not defect_row or product_quantity < 0 or param1 <= 0 or param2 <= 0 or stock_quantity < 0:
        return -1

    coefficient = coef_row[0]
    defect_rate = defect_row[0]

    base_quantity = param1 * param2 * coefficient
    adjusted_quantity = base_quantity * (1 + defect_rate)
    total_quantity = adjusted_quantity * product_quantity
    required_quantity = math.ceil(total_quantity - stock_quantity)

    return max(0, required_quantity)