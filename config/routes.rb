Rails.application.routes.draw do
  # devise_for :users
  resources :dates, only: [:index, :create, :destroy, :show, :edit, :update] do
    resources :records, only: [:create, :destroy]
  end

  resources :feedpod_dates, only: [:index, :create, :destroy, :show, :edit, :update] do
    resources :feedpod_records, only: [:create, :destroy]
  end

  resources :insights, only: [:index]

  get 'statics/exhibit'
  get 'statics/dev'

  root 'insights#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
