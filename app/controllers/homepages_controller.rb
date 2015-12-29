class HomepagesController < ApplicationController
    def index
        @users = User.all
    end
    
    def resource_name
        :user
    end

    def resource
        @resource ||= User.new
    end

    def devise_mapping
        @devise_mapping ||= Devise.mappings[:user]
    end
end
