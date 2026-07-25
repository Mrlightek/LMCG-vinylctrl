Rails.application.routes.draw do
  resources :profiles, param: :slug do
  resources :reviews, only: :create
end
  resources :landing_pages
  resources :dashboards
  resource :session
  resources :profiles, param: :slug
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "landing_pages#index"

  get "/how-it-works", to: "pages#how",      as: :how_it_works
  get "/features",     to: "pages#features",  as: :features
  get "/about",        to: "pages#about",     as: :about
  get "/contact",      to: "pages#contact",   as: :contact
  get "/privacy",      to: "pages#privacy",   as: :privacy
  get "/terms",        to: "pages#terms",     as: :terms
  get "profiles", to: "profiles#show"
  resources :bookings, only: [:create]

    # Waitlist
  resources :waitlist_entries, only: [:create]

  # Public talent marketplace
  get "/browse",        to: "profiles#index",  as: :browse
  resources :profiles,  only: [:show],         param: :slug

  # Dashboard
  namespace :dashboard do
    root "overview#index"
    resource  :overview,     only: [:show]
    resources :bookings do
      member do
        patch :confirm
        patch :decline
        patch :cancel
        patch :complete
        post  :send_contract
      end
      collection { get :calendar }
    end
    resources :gigs,           only: [:index, :show, :create, :destroy] do
      member { post :apply }
    end
    resources :messages, only: [:index, :show, :create]
    resources :contracts, only: [:index, :show, :create, :update] do
      member { post :sign }
    end
    resources :invoices do
      member { post :send_invoice; post :mark_paid }
    end
    resource  :profile,       only: [:show, :edit, :update]
    resource  :availability,  only: [:show, :update]
    resource  :analytics,     only: [:show]
    resources :notifications, only: [:index] do
      collection { post :mark_all_read }
    end
  end

  # API (for mobile app or JS)
  namespace :api do
    namespace :v1 do
      resources :profiles,  only: [:index, :show]
      resources :bookings,  only: [:index, :show, :create, :update]
      resources :gigs,      only: [:index, :show]
      resources :messages,  only: [:index, :create]
    end
  end
end

# # ═══════════════════════════════════════════════════════════════
# # VINYLCTRL — Rails Scaffold
# # Gig booking platform: DJs, Artists, Venues, Event Organizers
# # ═══════════════════════════════════════════════════════════════


# # ── config/routes.rb ────────────────────────────────────────────

# Rails.application.routes.draw do
  #resources :reviews
#   root "pages#home"



#   # Auth (Devise)
#   devise_for :users, controllers: {
#     registrations: "users/registrations",
#     sessions:      "users/sessions"
#   }


# end















