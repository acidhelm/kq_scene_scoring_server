Rails.application.routes.draw do
    root "sessions#new"

    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout",  to: "sessions#destroy"

    resources :users do
        resources :tournaments do
            post "refresh", on: :member
        end
    end

    get "kiosk/:id", to: "kiosk#show", as: :tournament_kiosk
end
