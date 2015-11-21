class MidtermtablesController < ApplicationController
    def index
        @count = 0
        require 'rubygems'
        require 'nokogiri'
        require 'open-uri'

        @user = User.find(params[:user_id])
        @table = @user.tables.find(params[:table_id])
        @classes = @table.classtables.all

        @page = Nokogiri::HTML(open("https://www3.reg.cmu.ac.th/regist258/exam/index.php?type=MIDTERM&term=258"))   

        @day_selected = @page.css("td[width='19%']")
        @time_selected = @page.css("div[align='center']")
        @exam_selected = @page.css("td[width='27%']")

        @days = []

        @day_selected.each do |day|
            @days.push(day.text)
        end

        @exams = []
        
        @exam_selected.each do |exam|
            @exams.push(exam.text.gsub(/[\r\n\t]/, '').split(','))
        end

        @pond = []
        a = @days.count
        b = @exams.count
        i = 0
        j = 0

        while i < a do
            while j < b do 
                @pond.push([@days[i], @exams[j]])
                j += 1
                i += 1 if j % 3 == 0
            end
        end


        # @show = []
        # @time = 0
        # @pond.each_with_index do |a, index| 
        #     @classes.each do |class_| 
        #         if a[1].include? class_.subject_code 
        #             @show.push([index, a[0], class_.subject_code, class_.subject])
        #         end   
        #     end 
        # end 

    end
end

