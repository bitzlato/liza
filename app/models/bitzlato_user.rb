class BitzlatoUser < BitzlatoRecord
  self.table_name = 'user'

  has_many :wallets, class_name: 'BitzlatoWallet', foreign_key: :user_id

  def self.market_user
    find ENV.fetch('BITZLATO_MARKET_USER_ID')
  end
end
