Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'goals#index'

  resources :goals, only: %i[index show new create edit update] do
    get 'summary'

    resources :measurements, shallow: true, only: %i[create destroy] do
      collection do
        get 'table'
      end
    end
  end
end
