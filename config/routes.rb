# encoding: utf-8
Appbg::Application.routes.draw do


  resources :users


  resources :field_items


  resources :table_fields do
    get 'field_item', :on => :collection
  end


  resources :identity_tables do

    get 'table_field', :on => :collection
    resources :table_forms

  end


  root :to => 'home#index'
  resources :browse_monitors do

    get 'load_ace', :on => :collection
    get 'load_desc' , :on => :collection
    get 'visit_ace', :on => :collection
    get 'site_time', :on => :collection
    get 'date_destroy', :on => :collection

  end

  controller :session do

    get 'user_login' => :user_login
    post 'user_session' => :user_session
    get 'destroy_session' => :destroy_session

  end

end
