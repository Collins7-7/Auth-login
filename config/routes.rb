Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registration: "users/registrations"
  }

get "/member_details", to: "members#index"

resources :events
resources :bookings

# namespace :api do
#   namespace :v1 do
#     resources :bookings
#   end
# end
 
end
