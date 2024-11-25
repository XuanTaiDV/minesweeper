class CreateMinesBoards < ActiveRecord::Migration[7.0]
  def change
    create_table :mines_boards do |t|
      t.string :name
      t.string :name_slug
      t.string :email_address
      t.text :matrix

      t.timestamps
    end
  end
end
