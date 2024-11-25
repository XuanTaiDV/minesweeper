Rails.application.routes.draw do
  root "mines_boards#index"

  resources :mines_boards, only: %i[index show create], param: :name_slug
end
