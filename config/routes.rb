Rails.application.routes.draw do

  root to: "public/homes#top"
  get "/about" => "homes#about", as: "about"


 devise_for :users,skip: [:passwords], controllers: {
 registrations: "public/registrations",
 sessions: 'public/sessions'
 }
 devise_scope :user do
    post '/users/guest_sign_in', to: 'public/sessions#new_guest'
 end

 scope module: :public do
    resources :posts, only: [:new, :create, :index, :show, :edit, :update, :destroy]
 end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

 devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
 sessions: "admin/sessions"
}

namespace :admin do
    resources :categories, only:[:index,:create,:edit,:update,:show]
end

end
