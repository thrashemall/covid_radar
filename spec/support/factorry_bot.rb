RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

Dir[Rails.root.join('spec', 'factories', '**/*.rb')].each(&method(:require))
