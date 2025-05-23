import sqlite3
import tkinter as tk
from tkinter import ttk, messagebox
from PIL import Image, ImageTk
from material_calc import calculate_material_quantity
import sys
import os
import shutil

def resource_path(relative_path):
    try:
        base_path = sys._MEIPASS
    except AttributeError:
        base_path = os.path.abspath(".")
    
    return os.path.join(base_path, relative_path)

def get_permanent_db_path():
    if getattr(sys, 'frozen', False):
        base_path = os.path.dirname(sys.executable)
    else:
        base_path = os.path.abspath(".")
    
    return os.path.join(base_path, 'wallpaper_company.db')

def initialize_database():
    permanent_db_path = get_permanent_db_path()
    if not os.path.exists(permanent_db_path):
        try:
            temp_db_path = resource_path('wallpaper_company.db')
            if os.path.exists(temp_db_path):
                shutil.copy(temp_db_path, permanent_db_path)
            else:
                conn = sqlite3.connect(permanent_db_path)
                cursor = conn.cursor()
                with open(resource_path('schema.sql'), 'r') as f:
                    cursor.executescript(f.read())
                with open(resource_path('schema2.sql'), 'r') as f:
                    cursor.executescript(f.read())
                with open(resource_path('data.sql'), 'r') as f:
                    cursor.executescript(f.read())
                with open(resource_path('data_import.sql'), 'r') as f:
                    cursor.executescript(f.read())
                conn.commit()
                conn.close()
                messagebox.showinfo("Информация", "База данных была создана заново. Пожалуйста, перезапустите приложение.")
                sys.exit(0)
        except FileNotFoundError as e:
            messagebox.showerror("Ошибка", f"Не удалось создать базу данных: {str(e)}. Убедитесь, что файлы schema.sql, schema2.sql, data.sql, data_import.sql доступны.")
            sys.exit(1)

    return permanent_db_path

try:
    db_path = initialize_database()
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()
except sqlite3.OperationalError as e:
    messagebox.showerror("Ошибка", f"Не удалось подключиться к базе данных: {str(e)}. Убедитесь, что файл 'wallpaper_company.db' доступен.")
    sys.exit(1)

def calculate_product_cost(product_id):
    cursor.execute("""
        SELECT m.unit_price, pm.required_quantity
        FROM product_material pm
        JOIN material m ON pm.material_id = m.material_id
        WHERE pm.product_id = ?
    """, (product_id,))
    materials = cursor.fetchall()
    total_cost = sum(float(m[0]) * float(m[1]) for m in materials)
    return max(0, round(total_cost, 2))

def clear_scrollable_frame():
    for widget in scrollable_frame.winfo_children():
        widget.destroy()

def display_products():
    clear_scrollable_frame()

    cursor.execute("""
        SELECT p.product_id, pt.name AS type_name, p.name, p.article, p.min_partner_price, p.roll_width
        FROM product p
        JOIN product_type pt ON p.product_type_id = pt.product_type_id
    """)
    products = cursor.fetchall()

    for product in products:
        product_id, type_name, name, article, price, width = product
        cost = calculate_product_cost(product_id)

        product_frame = tk.Frame(scrollable_frame, bg="#FFFFFF", bd=2, relief="groove")
        product_frame.pack(fill="x", padx=10, pady=5)

        left_frame = tk.Frame(product_frame, bg="#FFFFFF")
        left_frame.pack(side="left", padx=10)

        tk.Label(left_frame, text=f"{type_name} | {name}", font=("Gabriola", 14, "bold"), fg="#2D6033", bg="#FFFFFF").pack(anchor="w")
        tk.Label(left_frame, text=f"Артикул: {article}", font=("Gabriola", 12), bg="#FFFFFF").pack(anchor="w")
        tk.Label(left_frame, text=f"Минимальная стоимость: {price} р", font=("Gabriola", 12), bg="#FFFFFF").pack(anchor="w")
        tk.Label(left_frame, text=f"Ширина: {width} м", font=("Gabriola", 12), bg="#FFFFFF").pack(anchor="w")

        right_frame = tk.Frame(product_frame, bg="#BBD9B2", width=150)
        right_frame.pack(side="right", padx=10)

        tk.Label(right_frame, text="Стоимость (р)", font=("Gabriola", 14, "bold"), fg="#2D6033", bg="#BBD9B2").pack(pady=5)
        tk.Label(right_frame, text=f"{cost} р", font=("Gabriola", 12), bg="#BBD9B2").pack()

        edit_button = tk.Button(right_frame, text="Редактировать", font=("Gabriola", 12), bg="#2D6033", fg="#FFFFFF",
                                command=lambda pid=product_id: open_edit_form(pid))
        edit_button.pack(pady=5)
        materials_button = tk.Button(right_frame, text="Показать материалы", font=("Gabriola", 12), bg="#2D6033", fg="#FFFFFF",
                                     command=lambda pid=product_id: show_materials(pid))
        materials_button.pack(pady=5)

def open_edit_form(product_id=None):
    edit_window = tk.Toplevel(root)
    edit_window.title("Редактировать продукт" if product_id else "Добавить продукт")
    edit_window.configure(bg="#FFFFFF")
    edit_window.geometry('400x500+300+200')
    edit_window.resizable(width=False, height=False)

    cursor.execute("SELECT product_type_id, name FROM product_type WHERE product_type_id != 1")
    product_types = cursor.fetchall()
    type_names = [pt[1] for pt in product_types]
    type_ids = {pt[1]: pt[0] for pt in product_types}

    article_var = tk.StringVar()
    type_var = tk.StringVar(value=type_names[0] if type_names else "")
    name_var = tk.StringVar()
    price_var = tk.StringVar()
    width_var = tk.StringVar()

    if product_id:
        cursor.execute("""
            SELECT p.article, pt.name, p.name, p.min_partner_price, p.roll_width
            FROM product p
            JOIN product_type pt ON p.product_type_id = pt.product_type_id
            WHERE p.product_id = ?
        """, (product_id,))
        product = cursor.fetchone()
        if product:
            article_var.set(product[0])
            type_var.set(product[1])
            name_var.set(product[2])
            price_var.set(str(product[3]))
            width_var.set(str(product[4]))

    tk.Label(edit_window, text="Артикул:", font=("Gabriola", 12), bg="#FFFFFF").pack(pady=5)
    tk.Entry(edit_window, textvariable=article_var, font=("Gabriola", 12)).pack(pady=5)

    tk.Label(edit_window, text="Тип продукта:", font=("Gabriola", 12), bg="#FFFFFF").pack(pady=5)
    ttk.Combobox(edit_window, textvariable=type_var, values=type_names, font=("Gabriola", 12), state="readonly").pack(pady=5)

    tk.Label(edit_window, text="Наименование:", font=("Gabriola", 12), bg="#FFFFFF").pack(pady=5)
    tk.Entry(edit_window, textvariable=name_var, font=("Gabriola", 12)).pack(pady=5)

    tk.Label(edit_window, text="Минимальная стоимость (р):", font=("Gabriola", 12), bg="#FFFFFF").pack(pady=5)
    tk.Entry(edit_window, textvariable=price_var, font=("Gabriola", 12)).pack(pady=5)

    tk.Label(edit_window, text="Ширина рулона (м):", font=("Gabriola", 12), bg="#FFFFFF").pack(pady=5)
    tk.Entry(edit_window, textvariable=width_var, font=("Gabriola", 12)).pack(pady=5)

    def save_product():
        try:
            article = article_var.get().strip()
            if not article:
                raise ValueError("Артикул не может быть пустым.")

            name = name_var.get().strip()
            if not name:
                raise ValueError("Наименование не может быть пустым.")

            price = float(price_var.get())
            if price < 0:
                raise ValueError("Минимальная стоимость не может быть отрицательной.")

            width = float(width_var.get())
            if width < 0:
                raise ValueError("Ширина рулона не может быть отрицательной.")

            product_type_id = type_ids[type_var.get()]

            if product_id:
                cursor.execute("""
                    UPDATE product
                    SET article = ?, product_type_id = ?, name = ?, min_partner_price = ?, roll_width = ?
                    WHERE product_id = ?
                """, (article, product_type_id, name, price, width, product_id))
            else:
                cursor.execute("""
                    INSERT INTO product (article, product_type_id, name, min_partner_price, roll_width)
                    VALUES (?, ?, ?, ?, ?)
                """, (article, product_type_id, name, price, width))

            conn.commit()
            edit_window.destroy()
            display_products()

        except ValueError as ve:
            messagebox.showerror("Ошибка", str(ve), parent=edit_window)
        except tk.TclError:
            messagebox.showerror("Ошибка", "Пожалуйста, введите корректные числовые значения для стоимости и ширины.", parent=edit_window)
        except Exception as e:
            messagebox.showerror("Ошибка", f"Произошла ошибка: {str(e)}", parent=edit_window)

    tk.Button(edit_window, text="Сохранить", font=("Gabriola", 12), bg="#2D6033", fg="#FFFFFF", command=save_product).pack(pady=10)
    tk.Button(edit_window, text="Назад", font=("Gabriola", 12), bg="#2D6033", fg="#FFFFFF", command=edit_window.destroy).pack(pady=5)

def show_materials(product_id):
    materials_window = tk.Toplevel(root)
    materials_window.title("Материалы для продукта")
    materials_window.configure(bg="#FFFFFF")
    materials_window.geometry('600x700+400+150')
    materials_window.resizable(width=False, height=False)

    cursor.execute("SELECT product_type_id FROM product WHERE product_id = ?", (product_id,))
    product_type_id = cursor.fetchone()[0]

    cursor.execute("""
        SELECT m.material_id, m.name, pm.required_quantity, m.stock_quantity
        FROM product_material pm
        JOIN material m ON pm.material_id = m.material_id
        WHERE pm.product_id = ?
    """, (product_id,))
    materials = cursor.fetchall()

    canvas = tk.Canvas(materials_window, bg="#FFFFFF")
    scrollbar = ttk.Scrollbar(materials_window, orient="vertical", command=canvas.yview)
    scrollable_frame = ttk.Frame(canvas, style="Custom.TFrame")

    scrollable_frame.bind("<Configure>", lambda e: canvas.configure(scrollregion=canvas.bbox("all")))
    canvas.create_window((0, 0), window=scrollable_frame, anchor="nw")
    canvas.configure(yscrollcommand=scrollbar.set)

    canvas.pack(side="left", fill="both", expand=True)
    scrollbar.pack(side="right", fill="y")

    tree = ttk.Treeview(scrollable_frame, columns=("Material", "Quantity"), show="headings", height=10)
    tree.heading("Material", text="Наименование материала")
    tree.heading("Quantity", text="Необходимое количество")
    tree.column("Material", width=300)
    tree.column("Quantity", width=150)
    tree.pack(pady=10)

    material_mapping = {}
    for material in materials:
        material_id, name, req_quantity, stock = material
        row_id = tree.insert("", "end", values=(name, f"{req_quantity}"))
        material_mapping[row_id] = (material_id, stock)

    calc_frame = ttk.Frame(scrollable_frame, style="Custom.TFrame")
    calc_frame.pack(pady=10, padx=10, fill="x")

    tk.Label(calc_frame, text="Рассчитать количество материала", font=("Gabriola", 14, "bold"), fg="#2D6033", bg="#FFFFFF").grid(row=0, column=0, columnspan=2, pady=5)

    selected_material_label = tk.Label(calc_frame, text="Выберите материал из таблицы выше", font=("Gabriola", 12), fg="#2D6033", bg="#FFFFFF")
    selected_material_label.grid(row=1, column=0, columnspan=2, pady=5)

    tk.Label(calc_frame, text="Количество продукции:", font=("Gabriola", 12), bg="#FFFFFF").grid(row=2, column=0, pady=5, sticky="e")
    product_quantity_var = tk.StringVar()
    tk.Entry(calc_frame, textvariable=product_quantity_var, font=("Gabriola", 12)).grid(row=2, column=1, pady=5)

    tk.Label(calc_frame, text="Параметр 1 (например, длина, м):", font=("Gabriola", 12), bg="#FFFFFF").grid(row=3, column=0, pady=5, sticky="e")
    param1_var = tk.StringVar()
    tk.Entry(calc_frame, textvariable=param1_var, font=("Gabriola", 12)).grid(row=3, column=1, pady=5)

    tk.Label(calc_frame, text="Параметр 2 (например, ширина, м):", font=("Gabriola", 12), bg="#FFFFFF").grid(row=4, column=0, pady=5, sticky="e")
    param2_var = tk.StringVar()
    tk.Entry(calc_frame, textvariable=param2_var, font=("Gabriola", 12)).grid(row=4, column=1, pady=5)

    tk.Label(calc_frame, text="Количество на складе:", font=("Gabriola", 12), bg="#FFFFFF").grid(row=5, column=0, pady=5, sticky="e")
    stock_quantity_var = tk.StringVar()
    stock_entry = tk.Entry(calc_frame, textvariable=stock_quantity_var, font=("Gabriola", 12), state="readonly")
    stock_entry.grid(row=5, column=1, pady=5)

    def on_material_select(event):
        selected_item = tree.selection()
        if selected_item:
            material_id, stock = material_mapping[selected_item[0]]
            material_name = tree.item(selected_item[0], "values")[0]
            selected_material_label.config(text=f"Выбранный материал: {material_name}")
            stock_quantity_var.set(str(stock))

    tree.bind("<<TreeviewSelect>>", on_material_select)

    def calculate_material():
        selected_item = tree.selection()
        if not selected_item:
            messagebox.showerror("Ошибка", "Пожалуйста, выберите материал из таблицы.", parent=materials_window)
            return

        material_id, stock = material_mapping[selected_item[0]]
        try:
            product_quantity = int(product_quantity_var.get())
            param1 = float(param1_var.get())
            param2 = float(param2_var.get())
            stock_quantity = float(stock_quantity_var.get())

            result = calculate_material_quantity(cursor, product_type_id, material_id, product_quantity, param1, param2, stock_quantity)
            if result == -1:
                messagebox.showerror("Ошибка", "Неверные параметры: проверьте введенные значения.", parent=materials_window)
            else:
                material_name = tree.item(selected_item[0], "values")[0]
                messagebox.showinfo("Результат", f"Необходимое количество материала '{material_name}': {result}", parent=materials_window)

        except ValueError as ve:
            messagebox.showerror("Ошибка", "Пожалуйста, введите корректные числовые значения.", parent=materials_window)
        except Exception as e:
            messagebox.showerror("Ошибка", f"Произошла ошибка: {str(e)}", parent=materials_window)

    tk.Button(calc_frame, text="Рассчитать", font=("Gabriola", 12), bg="#2D6033", fg="#FFFFFF", command=calculate_material).grid(row=6, column=0, columnspan=2, pady=10)

    tk.Button(calc_frame, text="Назад", font=("Gabriola", 12), bg="#2D6033", fg="#FFFFFF",
              command=materials_window.destroy).grid(row=7, column=0, columnspan=2, pady=5)

root = tk.Tk()
root.title("Система управления продукцией")
root.configure(bg="#FFFFFF")
root.geometry('900x900+200+100')
root.resizable(width=False, height=False)

try:
    icon_path = resource_path("res/icon.ico")
    root.iconbitmap(icon_path)
except tk.TclError:
    pass

try:
    logo_path = resource_path("res/logo.png")
    logo_img = Image.open(logo_path)
    logo_img = logo_img.resize((100, 100), Image.Resampling.LANCZOS)
    logo_photo = ImageTk.PhotoImage(logo_img)
    logo_label = tk.Label(root, image=logo_photo, bg="#FFFFFF")
    logo_label.image = logo_photo
    logo_label.pack(pady=10)
except FileNotFoundError:
    pass

add_button = tk.Button(root, text="Добавить продукт", font=("Gabriola", 12), bg="#2D6033", fg="#FFFFFF", command=open_edit_form)
add_button.pack(pady=10)

canvas = tk.Canvas(root, bg="#FFFFFF")
scrollbar = ttk.Scrollbar(root, orient="vertical", command=canvas.yview)
scrollable_frame = ttk.Frame(canvas, style="Custom.TFrame")

scrollable_frame.bind("<Configure>", lambda e: canvas.configure(scrollregion=canvas.bbox("all")))
canvas.create_window((0, 0), window=scrollable_frame, anchor="nw")
canvas.configure(yscrollcommand=scrollbar.set)

canvas.pack(side="left", fill="both", expand=True)
scrollbar.pack(side="right", fill="y")

def on_mouse_wheel(event):
    canvas.yview_scroll(int(-1*(event.delta/120)), "units")

root.bind_all("<MouseWheel>", on_mouse_wheel)

display_products()

root.mainloop()

conn.close()