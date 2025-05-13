import math

def calculate_material_quantity(cursor, product_type_id, material_id, product_quantity, param1, param2, stock_quantity):
    cursor.execute("""
        SELECT mt.material_type_id, mt.defect_rate
        FROM material m
        JOIN material_type mt ON m.material_type_id = mt.material_type_id
        WHERE m.material_id = ?
    """, (material_id,))
    material_row = cursor.fetchone()

    cursor.execute("SELECT coefficient FROM product_type WHERE product_type_id = ?", (product_type_id,))
    coef_row = cursor.fetchone()

    if not material_row or not coef_row or product_quantity < 0 or param1 <= 0 or param2 <= 0 or stock_quantity < 0:
        return -1

    defect_rate = material_row[1]
    coefficient = coef_row[0]

    base_quantity = param1 * param2 * coefficient
    adjusted_quantity = base_quantity * (1 + defect_rate)
    total_quantity = adjusted_quantity * product_quantity
    required_quantity = math.ceil(total_quantity - stock_quantity)

    return max(0, required_quantity)