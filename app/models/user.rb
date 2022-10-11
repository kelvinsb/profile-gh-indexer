class User < ApplicationRecord
  validates :name, :githubUser, presence: true
  validates :name, uniqueness: true
  validates :quantityFollowers, :quantityFollowing, :quantityStars, :lastYearContributions,
            numericality: { only_integer: true }, allow_nil: true

  scope :filter_name, lambda { |name|
    where 'name LIKE ?', "%#{sanitize_sql_like(name)}%" unless name.nil?
  }
end
