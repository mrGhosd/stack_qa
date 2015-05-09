Rails.application.routes.default_url_options[:host] = 'http://localhost:3000'
Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: {sessions: 'sessions', registrations: 'registrations', :omniauth_callbacks => "omniauth_callbacks" }

  mount RedactorRails::Engine => '/redactor_rails'

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  root "questions#index"
  post "/widget", controller: :application, action: :widget_data
  get "/search", to: "search#index"

  concern :commentable do
    resources :comments
  end

  concern :rating do
    post :rate
  end

  resources :categories
  resources :users, except: [:new, :create]
  resources :questions, concerns: [:commentable, :rating] do
    collection do
      post :filter
      get :tag
    end

    post :sign_in_question, on: :member
    resources :answers, concerns: [:commentable, :rating] do
      post :helpfull, on: :member
    end
  end

  namespace :admin do
    resources :categories
  end

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end
      resources :questions, concerns: [:rating, :commentable] do
        resources :answers, concerns: [:rating, :commentable] do
          post :helpfull, on: :member
        end
      end
      resources :users do
        member do
          get :questions
          get :answers
          get :comments
        end
      end
      resources :categories do
        get :questions, on: :member
      end
    end
  end
end
