-- Quan-dun reagent inventory schema
create table if not exists reagents (
  id serial primary key,
  code text not null default '',
  name text not null default '',
  category text not null default '',
  specification text not null default '',
  manufacturer text not null default '',
  unit text not null default '盒',
  stock_quantity integer not null default 0,
  min_stock integer not null default 0,
  storage_condition text not null default '',
  location text not null default '',
  expiry_date text not null default '',
  registration_number text not null default '',
  notes text not null default '',
  scan_rule text not null default '',
  scan_segments text not null default '[]',
  lot_number text not null default '',
  production_date text not null default '',
  raw_barcode text not null default '',
  supplier text not null default '',
  unit_price integer not null default 0,
  created_at timestamptz not null default now()
);
create index if not exists reagents_code_idx on reagents (code);
create index if not exists reagents_scan_rule_idx on reagents (scan_rule);

create table if not exists stock_records (
  id serial primary key,
  reagent_id integer not null references reagents(id),
  type text not null,
  quantity integer not null,
  lot_number text not null default '',
  expiry_date text not null default '',
  production_date text not null default '',
  note text not null default '',
  operator text not null default '',
  department text not null default '',
  reason text not null default '',
  created_at timestamptz not null default now()
);
create index if not exists stock_records_reagent_idx on stock_records (reagent_id);
create index if not exists stock_records_created_idx on stock_records (created_at desc);

create table if not exists purchase_orders (
  id serial primary key,
  status text not null default 'submitted',
  note text not null default '',
  item_count integer not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists purchase_order_items (
  id serial primary key,
  order_id integer not null references purchase_orders(id) on delete cascade,
  reagent_id integer not null references reagents(id),
  quantity integer not null,
  unit text not null default '',
  name text not null default '',
  manufacturer text not null default '',
  specification text not null default '',
  supplier text not null default ''
);
