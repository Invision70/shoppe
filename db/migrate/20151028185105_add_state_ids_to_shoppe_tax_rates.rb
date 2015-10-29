class AddStateIdsToShoppeTaxRates < ActiveRecord::Migration
  def change
    add_column :shoppe_tax_rates, :state_ids, :text
  end
end
