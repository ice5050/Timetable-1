class GeneratesController < ApplicationController
    def index
        require 'rubygems'
        require 'nokogiri'
        require 'open-uri'       
        require 'net/http'

        year = session[:data]["year"]
        semester = session[:data]["semester"]
        link = (semester + year).to_i
        stu_id = session[:data]["stu_id"].to_i

        @i = 0
        @days = Day.order("id ASC")
        @times = Timer.all
        @error = ''

        url = "https://www3.reg.cmu.ac.th/regist#{link}/public/result.php?id=#{stu_id}"
        begin
          file = open(url)
          doc = Nokogiri::HTML(file) do
            # handle doc
        

            @page = Nokogiri::HTML(open("https://www3.reg.cmu.ac.th/regist#{link}/public/result.php?id=#{stu_id}"))   
            
            @subject_code_selected = @page.css("td[width='57'][bgcolor='#E3F1FF']")
            @subject_selected = @page.css("td[width='157'][bgcolor='#E3F1FF']")
            @section_selected  = @page.css("td[width='35'][bgcolor='#FFFFFF']")
            @days_selected  = @page.css("td[width='35'][bgcolor='#E3F1FF']")
            @times_selected = @page.css("td[width='62'][bgcolor='#E3F1FF']")
            @stu_data = @page.css("td[width='62%'][bgcolor='#FFEEFF']")
            @notfound = @page.css("table[bordercolor='#FF0000']")

            index = 0
            @class = []
            @listColor = ["blue", "red", "green", "pink", "yellow","mint", "orange", "violet"]
            @selected_color = []
            @cant_port = []
            
            while index < @subject_code_selected.count do 
                if Timer.find_by(time: (@times_selected[index].text[0..10][0..4].to_s.strip)) and 
                    Timer.find_by(time: @times_selected[index].text[0..10][7..10].to_s.strip)
                    @start = Timer.find_by(time: (@times_selected[index].text[0..10][0..4].to_s.strip)).id
                    @finish = Timer.find_by(time: @times_selected[index].text[0..10][7..10].to_s.strip).id
                else
                    @cant_port.push([
                            @subject_code_selected[index].text, 
                            @subject_selected[index].text,
                            @section_selected[index..index+1].text,
                            @days_selected[index].text,
                            @times_selected[index].text[0..10][0..4].to_s.strip,
                            @times_selected[index].text[0..10][7..10].to_s.strip
                        ])
                    index += 1
                    next
                end
                
                @select_color = @listColor.select {|item| not @selected_color.include? item  }
                @class.push([
                            @subject_code_selected[index].text, 
                            @subject_selected[index].text,
                            @section_selected[index..index+1].text,
                            @days_selected[index].text,
                            @start,
                            @finish,
                            @select_color[0]
                        ])
                @selected_color.push(@select_color[0])
                index += 1
            end
            
            @class = @class.sort {|a,b| a[4] <=> b[4]}

            # Midterm
            @page = Nokogiri::HTML(open("https://www3.reg.cmu.ac.th/regist#{link}/exam/index.php?type=MIDTERM&term=#{link}"))   

            @day_selected = @page.css("td[width='19%']")
            @time_selected = @page.css("div[align='center']")
            @exam_selected = @page.css("td[width='27%']")

            @dayss = []

            @day_selected.each do |day|
                @dayss.push(day.text)
            end

            @exams = []
            
            @exam_selected.each do |exam|
                @exams.push(exam.text.gsub(/[\r\n\t]/, '').split(','))
            end

            @myexam_midterm = []
            day_len = @dayss.count
            exam_len = @exams.count
            i = j = 0

            while i < day_len do
                while j < exam_len do 
                    @myexam_midterm.push([@dayss[i], @exams[j]])
                    j += 1
                    i += 1 if j % 3 == 0
                end
            end
            @is_shown = Set.new
            @count = 0

            #=======
            @regular = Regularexam.where("yearexam" => year, "semesterexam" => semester)
            @page = Nokogiri::HTML(open("https://www3.reg.cmu.ac.th/regist#{link}/exam/index.php?type=FINAL&term=#{link}"))   

            @day_selected = @page.css("td[width='19%']")
            @time_selected = @page.css("div[align='center']")
            @exam_selected = @page.css("td[width='27%']")     
            

            @dayss = []

            @day_selected.each do |day|
                @dayss.push(day.text)
            end

            @exams = []
            
            @exam_selected.each do |exam|
                @exams.push(exam.text.gsub(/[\r\n\t]/, '').split(','))
            end

            @myexam_final = []
            day_len = @dayss.count
            exam_len = @exams.count
            i = j = 0

            while i < day_len do
                while j < exam_len do 
                    @myexam_final.push([@dayss[i], @exams[j]])
                    j += 1
                    i += 1 if j % 3 == 0
                end
            end

            @is_shown = Set.new
            @is_shown_regular = Set.new

          end
        rescue OpenURI::HTTPError => e
          if e.message == '404 Not Found'
            @error = "no data in #{semester}/25#{year}"
          else
            raise e
          end
        end
    end

    def create
        session[:data] = params_info
        redirect_to generates_path
    end

    private
        def params_info
            params.require(:generate).permit(:stu_id, :year, :semester)
        end

end
