class AddDateToCurrency < ActiveRecord::Migration[5.2]
  def change
    add_column :currencies, :date, :datetime
  end
end
