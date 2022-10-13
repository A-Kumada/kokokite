Rails.application.routes.draw do


 devise_for :users,skip: [:passwords], controllers: {
 registrations: "public/registrations",
 sessions: 'public/sessions'
 }
 devise_scope :user do
    post '/users/guest_sign_in', to: 'public/sessions#new_guest'
 end

    root to: "public/homes#top"
    get "/about" => "homes#about", as: "about"
    get '/users/mypage' => 'public/users#show', as: 'mypage'
    get '/users/bookmark' => 'public/homes#bookmark', as: 'bookmark'

 scope module: :public do
    resources :users, only: [:edit, :update, :index]
    resources :posts, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
        resources :comments, only: [:create, :destroy]
        resource :favorites, only: [:create, :destroy]
    end
 end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

 devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
 sessions: "admin/sessions"
}

namespace :admin do
    resources :categories, only:[:index,:create,:edit,:update,:show]
    resources :users, only:[:index, :edit, :update, :show]
end

end
