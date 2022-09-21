class AddSaltToManualSessionToken < ActiveRecord::Migration[7.0]
  def change
    add_column :manual_session_tokens, :salt, :string
  end
end
