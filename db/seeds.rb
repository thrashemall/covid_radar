ActiveRecord::Base.logger = Logger.new(STDOUT)

Countries::UpsertService.new.call
Infections::UpsertService.new.call
