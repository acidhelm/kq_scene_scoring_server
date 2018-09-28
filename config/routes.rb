Rails.application.routes.draw do
    root "application#root"
    resources :users
end

