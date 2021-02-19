Rails.application.routes.draw do
  	get 'orders/new/:book_id', to: "orders#new", as: "new_order"
	get 'orders/success', to: "orders#success", as: "order_success"
	get "orders/cancel", to: "orders#cancel", as: "order_cancel"
  	devise_for :users
	root to: "books#index"
	get "/books", to: "books#index"
	get "/books/new", to: "books#new", as: "new_book"
	get "/books/:id", to: "books#show", as: "book"
	post "/books", to: "books#create"
	get "/authors", to: "authors#index"
	get "/authors/:id", to: "authors#show", as: "author"
end
