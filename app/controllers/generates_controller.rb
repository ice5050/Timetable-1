class GeneratesController < ApplicationController
    def index
        require 'rubygems'
        require 'nokogiri'
        require 'open-uri'       
        require 'net/http'

        unless session[:data] == nil
            year = session[:data]["year"]
            semester = session[:data]["semester"]
            link = (semester + year).to_i
            stu_id = session[:data]["stu_id"].to_i
        end

        @i = @count = 0
        @days = Day.order("id ASC")
        @times = Timer.all
        @error = ''

        url = "https://www3.reg.cmu.ac.th/regist#{link}/public/result.php?id=#{stu_id}"
        begin
          file = open(url)
          doc = Nokogiri::HTML(file) do
            
        
            @page = Nokogiri::HTML(open("https://www3.reg.cmu.ac.th/regist#{link}/public/result.php?id=#{stu_id}"))   
            
            @subject_code_selected = @page.css("td[width='57'][bgcolor='#E3F1FF']")
            @subject_selected = @page.css("td[width='157'][bgcolor='#E3F1FF']")
            @section_selected  = @page.css("td[width='35'][bgcolor='#FFFFFF']")
            @days_selected  = @page.css("td[width='35'][bgcolor='#E3F1FF']")
            @times_selected = @page.css("td[width='62'][bgcolor='#E3F1FF']")
            @stu_data = @page.css("td[width='62%'][bgcolor='#FFEEFF']")
            @notfound = @page.css("table[bordercolor='#FF0000']")

            @subject_code_lab_selected = @page.css("td[width='57'][bgcolor='#FFF2E6']")
            @subject_lab_selected = @page.css("td[width='157'][bgcolor='#FFF2E6']")
            @section_lab_selected  = @page.css("td[width='35'][bgcolor='#FFFFFF']")
            @days_lab_selected  = @page.css("td[width='35'][bgcolor='#FFF2E6']")
            @times_lab_selected = @page.css("td[width='62'][bgcolor='#FFF2E6']")

            index = 0
            @class = []
            @listColor = ["blue", "red", "green", "pink", "yellow", "mint", "pumpkin", "violet", "darkblue", "orange"]
            @selected_color = []
            @cant_port = []
            
            while index < @subject_code_selected.count do 
                section = index * 2
                if @days_selected[index].text.to_s.strip.length == 4
                    @start = Timer.find_by(time: (@times_selected[index].text[0..4].to_s.strip)).id
                    @finish = Timer.find_by(time: @times_selected[index].text[7..10].to_s.strip).id
                    @select_color = @listColor.select {|item| not @selected_color.include? item  }
                    @class.push([
                            @subject_code_selected[index].text, 
                            @subject_selected[index].text,
                            @section_selected[section..section+1].text,
                            @days_selected[index].text[0..1],
                            @start,
                            @finish,
                            @select_color[0]
                        ])

                    @start = Timer.find_by(time: (@times_selected[index].text[11..15].to_s.strip)).id
                    @finish = Timer.find_by(time: @times_selected[index].text[18..22].to_s.strip).id
                    @class.push([
                            @subject_code_selected[index].text, 
                            @subject_selected[index].text,
                            @section_selected[section..section+1].text,
                            @days_selected[index].text[2..3],
                            @start,
                            @finish,
                            @select_color[0]
                        ])
                    @selected_color.push(@select_color[0])
                    index += 1
                    next
                elsif @days_selected[index].text.to_s.strip.length == 5
                    @start = Timer.find_by(time: (@times_selected[index].text[0..4].to_s.strip)).id
                    @finish = Timer.find_by(time: @times_selected[index].text[7..10].to_s.strip).id
                    @select_color = @listColor.select {|item| not @selected_color.include? item  }
                    @class.push([
                            @subject_code_selected[index].text, 
                            @subject_selected[index].text,
                            @section_selected[section..section+1].text,
                            @days_selected[index].text[0..2],
                            @start,
                            @finish,
                            @select_color[0]
                        ])

                    @start = Timer.find_by(time: (@times_selected[index].text[11..15].to_s.strip)).id
                    @finish = Timer.find_by(time: @times_selected[index].text[18..22].to_s.strip).id
                    @class.push([
                            @subject_code_selected[index].text, 
                            @subject_selected[index].text,
                            @section_selected[section..section+1].text,
                            @days_selected[index].text[3..5],
                            @start,
                            @finish,
                            @select_color[0]
                        ])
                    @selected_color.push(@select_color[0])
                    index += 1
                    next
                end
                    

                if Timer.find_by(time: (@times_selected[index].text[0..10][0..4].to_s.strip)) and 
                    Timer.find_by(time: @times_selected[index].text[0..10][7..10].to_s.strip)
                    @start = Timer.find_by(time: (@times_selected[index].text[0..10][0..4].to_s.strip)).id
                    @finish = Timer.find_by(time: @times_selected[index].text[0..10][7..10].to_s.strip).id
                    @select_color = @listColor.select {|item| not @selected_color.include? item  }

                    @class.push([
                            @subject_code_selected[index].text, 
                            @subject_selected[index].text,
                            @section_selected[section..section+1].text,
                            @days_selected[index].text,
                            @start,
                            @finish,
                            @select_color[0]
                        ])
                    @selected_color.push(@select_color[0])
                else
                    @cant_port.push([
                            @subject_code_selected[index].text, 
                            @subject_selected[index].text,
                            @section_selected[section..section+1].text,
                            @days_selected[index].text,
                            @times_selected[index].text[0..10][0..4].to_s.strip,
                            @times_selected[index].text[0..10][7..10].to_s.strip
                        ])
                end

                index += 1
            end

            # LAB
            index = 0
            last = @subject_code_selected.count * 2
            while index < @subject_code_lab_selected.count do 
                if Timer.find_by(time: (@times_lab_selected[index].text[0..10][0..4].to_s.strip)) and 
                    Timer.find_by(time: @times_lab_selected[index].text[0..10][7..10].to_s.strip)
                    @start = Timer.find_by(time: (@times_lab_selected[index].text[0..10][0..4].to_s.strip)).id
                    @finish = Timer.find_by(time: @times_lab_selected[index].text[0..10][7..10].to_s.strip).id

                    @class.each do |class_|
                        if class_[0] == @subject_code_lab_selected[index].text.to_s.strip
                            @select_color = class_[6..-1]
                            break
                        else
                            @select_color = @listColor.select {|item| not @selected_color.include? item  }
                        end
                    end

                    section = last + (index * 2)
                    @class.push([
                            @subject_code_lab_selected[index].text, 
                            @subject_lab_selected[index].text,
                            @section_lab_selected[section..section+1].text,
                            @days_lab_selected[index].text,
                            @start,
                            @finish,
                            @select_color[0]
                        ])
                    @selected_color.push(@select_color[0])
                else
                    @cant_port.push([
                            @subject_lab_code_selected[index].text, 
                            @subject_lab_selected[index].text,
                            @section_lab_selected[section..section+1].text,
                            @days_lab_selected[index].text,
                            @times_lab_selected[index].text[0..10][0..4].to_s.strip,
                            @times_lab_selected[index].text[0..10][7..10].to_s.strip
                        ])
                    index += 1
                    next
                end
                index += 1
            end
            
            @class = @class.sort {|a,b| a[4] <=> b[4]}            
            
            midterm_exam()
            final_exam()

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

        def midterm_exam
            unless session[:data] == nil
                year = session[:data]["year"]
                semester = session[:data]["semester"]
                link = (semester + year).to_i
            end

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
        end    

        def final_exam
            unless session[:data] == nil
                year = session[:data]["year"]
                semester = session[:data]["semester"]
                link = (semester + year).to_i
            end
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
        end    

end
