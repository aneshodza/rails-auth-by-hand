class CreateManualSessionTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :manual_session_tokens do |t|
      t.string :key
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
