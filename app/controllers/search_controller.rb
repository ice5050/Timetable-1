class SearchController < ApplicationController
    def index
        require 'rest-client'
        require 'open-uri'
        require 'rubygems'
        require 'nokogiri'

        if params[:user_id] and params[:table_id]
            @user = User.find(params[:user_id])
            @table = @user.tables.find(params[:table_id])
        end

        @td = 1

        @REQUEST_URL = "https://www3.reg.cmu.ac.th/regist258/public/search.php"

        if session[:code].present?
            if session[:code].present? and session[:code]["code"].length == 3
                op = "precourse"
                page = RestClient.post(@REQUEST_URL, {'precourse'=> session[:code]["code"], 'op'=> 'precourse' })
            elsif session[:code].present? and session[:code]["code"].length == 6
                op = "bycourse"
                page = RestClient.post(@REQUEST_URL, {'s_course1'=> session[:code]["code"], 'op'=> 'bycourse' })
            end

            # if page = RestClient.post(@REQUEST_URL, {'precourse'=> session[:code]["code"], 'op'=> op })
                # puts "Success finding search term: 204"
                @npage = Nokogiri::HTML(page)

                @subjects = @npage.css('details summary')
                @details = @npage.css('table[sectionlist]')
            # end
        else 
            redirect_to homepages_path
        end
    end

    def create

        if params[:user_id] and params[:table_id]
            @user = User.find(params[:user_id])
            @table = @user.tables.find(params[:table_id])
            session[:code] = params_code
            redirect_to user_table_search_index_path
        else
            session[:code] = params_code
            redirect_to search_index_path
        end

        
    end

    private
        def params_code
            params.require(:search).permit(:code)
        end
end
