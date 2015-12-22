class SearchController < ApplicationController
    def index
        require 'rest-client'
        require 'open-uri'
        require 'rubygems'
        require 'nokogiri'

        @REQUEST_URL = ""
        
        if params[:user_id] and params[:table_id]
            @user = User.find(params[:user_id])
            @table = @user.tables.find(params[:table_id])
            link = @table.semester.to_s + @table.year.to_s
            @REQUEST_URL = "https://www3.reg.cmu.ac.th/regist#{link}/public/search.php"
        else
            @REQUEST_URL = "https://www3.reg.cmu.ac.th/regist258/public/search.php"
        end

        @td = 1
        if params[:code]
            @code = params[:code].to_s
            if @code.length == 3
                op = "precourse"
                page = RestClient.post(@REQUEST_URL, {'precourse'=> @code, 'op'=> 'precourse' })
            elsif @code.length == 6
                op = "bycourse"
                page = RestClient.post(@REQUEST_URL, {'s_course1'=> @code, 'op'=> 'bycourse' })
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
            user = User.find(params[:user_id])
            table = user.tables.find(params[:table_id])
            code = params.require(:search).permit(:code)["code"]
            redirect_to user_table_search_index_path(user, table, code: code)
        else
            code = params.require(:search).permit(:code)["code"]
            redirect_to search_index_path(code: code)
        end
    end
    
end
