Rails.application.routes.draw do
  get 'home/index'

  root 'home#index'

  post 'summarization', to: 'summarization#create'
end
