class CreateAtomicLti1v1Nonces < ActiveRecord::Migration[7.0]
  def change
    create_table :atomic_lti1v1_nonces do |t|
      t.string "nonce"
      t.timestamps
      t.index ["nonce"], name: "index_nonces_on_nonce", unique: true
    end
  end
end
