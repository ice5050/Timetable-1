Rails.application.routes.draw do

  resources :students, only: :index do
    get 'stu_info', on: :member
  end

  resources :generates, path: 'sync', only: [:index, :create] do
    get 'create_table', on: :member
  end

  resources :homepages, only: [:index]
  resources :search, only: [:index, :create]
  resources :regularexams

  resources :settings, only: [:index] do
    member do
      get 'edit_day'
      patch 'update_day'
      delete 'delete_day'
      get 'edit_time'
      patch 'update_time'
      delete 'delete_time'
    end
  end

  devise_for :users

  resources :users, only: [] do
    resources :tables, path: '/' do
      member do
        get 'reset'
        get 'add_class'
      end
      resources :classtables do
        member do
          get 'copy'
          post 'update_exam_midterm'
          get 'clear_manual_midterm'
          post 'update_exam_final'
          get 'clear_manual_final'
        end
      end
      resources :search, only: [:index, :create]
      resources :midtermtables, only: [:index, :edit]
      resources :finaltables, only: [:index, :edit]
    end
  end

  namespace :api do
    resources :generates, only: :index
    resources :midtermexam, only: :index
    resources :finalexam, only: :index
  end

  root "homepages#index"
end
