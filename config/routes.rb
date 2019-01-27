Rails.application.routes.draw do
  # devise_for :users
  resources :dates, only: [:index, :create, :destroy, :show, :edit, :update] do
    resources :records, only: [:create, :destroy]
  end

  root 'dates#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
