-- Harden reagent inventory data integrity.
-- Keep this as a new migration so previously-applied migrations remain immutable.

alter table reagents
  add constraint reagents_stock_quantity_nonnegative
  check (stock_quantity >= 0);

alter table reagents
  add constraint reagents_min_stock_nonnegative
  check (min_stock >= 0);

alter table reagents
  add constraint reagents_unit_price_nonnegative
  check (unit_price >= 0);

alter table stock_records
  add constraint stock_records_quantity_positive
  check (quantity > 0);

alter table purchase_order_items
  add constraint purchase_order_items_quantity_positive
  check (quantity > 0);

alter table purchase_orders
  add constraint purchase_orders_item_count_nonnegative
  check (item_count >= 0);

-- Keep inventory status values controlled at the database boundary.
alter table stock_records
  add constraint stock_records_type_valid
  check (type in ('in', 'out', 'adjustment', 'return'));

alter table purchase_orders
  add constraint purchase_orders_status_valid
  check (status in ('draft', 'submitted', 'approved', 'completed', 'cancelled'));

create index if not exists purchase_order_items_order_idx
  on purchase_order_items (order_id);

create index if not exists purchase_order_items_reagent_idx
  on purchase_order_items (reagent_id);
