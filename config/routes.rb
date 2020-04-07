Rails.application.routes.draw do
  namespace :bot do
    resource :commands, only: [] do
      post :country
      post :chart
      post :top
      post :compare
      post :about

      match '*path', to: 'commands#not_found', via: :post
    end

    resource :plain, only: %i[create]
  end
end
