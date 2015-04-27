class AddDefaultToProd < ActiveRecord::Migration
  def change
    change_column :products, :default_price, :decimal, :precision => 8, :scale => 2, :default => 0
  end
end
