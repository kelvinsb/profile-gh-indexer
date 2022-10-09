class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :githubUser
      t.integer :quantityFollowers
      t.integer :quantityFollowing
      t.integer :quantityStars
      t.integer :lastYearContributions
      t.string :avatarUrl
      t.string :organization
      t.string :localization
      t.string :shortUrl
      t.datetime :lastScan

      t.timestamps
    end
  end
end
