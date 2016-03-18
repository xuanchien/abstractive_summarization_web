Rails.application.routes.draw do
  get 'home/index'
	get 'duc_data' => 'duc_data#index'
	get 'duc_data/:id' => 'duc_data#show', as: :duc_data_set

  root 'home#index'

  post 'summarization', to: 'summarization#create'


end
