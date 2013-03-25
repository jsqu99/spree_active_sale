class AddTenantIdToActiveSaleTables < ActiveRecord::Migration
  def change
    add_column :spree_active_sales,          :tenant_id, :integer
    add_column :spree_active_sale_events,    :tenant_id, :integer
  end
end
