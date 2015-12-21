class SettingsController < ApplicationController
    before_action :require_login

    def index
        @users = User.order("created_at ASC")
        @days = Day.order("id ASC")
        @times = Timer.order("id ASC")
    end

    def edit_day
        @day = Day.find(params[:id])
    end

    def update_day
        @day = Day.find(params[:id])
        @day.update(params_day)
        redirect_to settings_path
    end

    def edit_time
        @time = Timer.find(params[:id])
    end

    def update_time
        @time = Timer.find(params[:id])
        @time.update(params_time)
        redirect_to settings_path
    end

    def delete_day
        @day = Day.find(params[:id])
        @day.destroy
        redirect_to settings_path
    end

    def delete_time
        @time = Timer.find(params[:id])
        @time.destroy
        redirect_to settings_path
    end

    private
        def params_day
            params.require(:day).permit(:day)
        end

        def params_time
            params.require(:time).permit(:time)
        end

        def require_login
          unless current_user.username == 'pondpaun7z'
            redirect_to homepages_path
          end
        end
end
