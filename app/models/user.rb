# == Schema Information
#
# Table name: users
#
#  id            :bigint           not null, primary key
#  first_name    :string
#  language_code :string
#  last_name     :string
#  uid           :bigint           not null
#  username      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  chat_id       :bigint           not null
#
class User < ApplicationRecord
end
