
class API::GeneratesController < ApplicationController
    def index
        @semester = params[:semester]
        @year = params[:year]
        @link = @semester.to_s + @year.to_s
        @stu_id = params[:stu_id]

        @i = 0
        @error = ''

        url = "https://www3.reg.cmu.ac.th/regist#{@link}/public/result.php?id=#{@stu_id}"
        begin
          file = open(url)
          doc = Nokogiri::HTML(file) do
            
            read_tag()
            add_class()

            midterm_exam()
            final_exam()

            
            all_class = []
            @class.each do |class_|
                data = Hash.new
                data[:subject_code] = class_[0]
                data[:subject] = class_[1]
                data[:seclec] = class_[2][0..2]
                data[:seclab] = class_[2][4..6]
                data[:day] = class_[3]
                data[:start] = [Timer.find(class_[4]).time[0..1], ':', Timer.find(class_[4]).time[2..4]].join('')
                data[:finish] = [Timer.find(class_[5]).time[0..1], ':', Timer.find(class_[5]).time[2..4]].join('')
                all_class << data
            end
            render json: all_class, status: :ok
          end
        rescue OpenURI::HTTPError => e
            if e.message == '404 Not Found'
                @error = "no data in #{@semester}/25#{@year}"
            else
                raise e
            end
        end
    end

    private

        def read_tag
            @page = Nokogiri::HTML(open("https://www3.reg.cmu.ac.th/regist#{@link}/public/result.php?id=#{@stu_id}"))   
            
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
        end

        def add_class
        
            index = 0
            @count = 0
            @days = Day.order("id ASC")
            @times = Timer.all
            @class = []
            @listColor = ["blue", "red", "green", "pink", "yellow", "mint", "pumpkin", "violet", "darkblue", "orange"]
            @selected_color = []
            @cant_port = []
            
            while index < @subject_code_selected.count do 

                # [Day] Black text 
                section = index * 2                  
                @select_color = @listColor.select {|item| not @selected_color.include? item  }

                if Timer.find_by(time: (@times_selected[index].child.text[0..4].to_s.strip)) and 
                    Timer.find_by(time: @times_selected[index].child.text[7..10].to_s.strip)
                    @start = Timer.find_by(time: (@times_selected[index].child.text[0..4].to_s.strip)).id
                    @finish = Timer.find_by(time: @times_selected[index].child.text[7..10].to_s.strip).id

                    if @days_selected[index].child.text.strip.include? "-" 
                        day = @days_selected[index].child.text.strip.split("-")

                        if ['Su'].include? day[0] then start = 1
                        elsif ['Mo', 'M'].include? day[0] then start = 2
                        elsif ['Tu'].include? day[0] then start = 3
                        elsif ['We', 'W'].include? day[0] then start = 4
                        elsif ['Th'].include? day[0] then start = 5
                        elsif ['Fr', 'F'].include? day[0] then start = 6
                        elsif ['Sa'].include? day[0] then start = 7
                        end    

                        if ['Su'].include? day[1] then finish = 1
                        elsif ['Mo', 'M'].include? day[1] then finish = 2
                        elsif ['Tu'].include? day[1] then finish = 3
                        elsif ['We', 'W'].include? day[1] then finish = 4
                        elsif ['Th'].include? day[1] then finish = 5
                        elsif ['Fr', 'F'].include? day[1] then finish = 6
                        elsif ['Sa'].include? day[1] then start = 7
                        end    

                        (start..finish).each do |i|

                            if i == 1 then day = "Su"
                            elsif i == 2 then day = "Mo"
                            elsif i == 3 then day = "Tu"
                            elsif i == 4 then day = "We"
                            elsif i == 5 then day = "Th"
                            elsif i == 6 then day = "Fr"
                            elsif i == 7 then day = "Sa"
                            end   

                            @class.push([
                                @subject_code_selected[index].text, 
                                @subject_selected[index].text,
                                @section_selected[section].text + '-' + @section_selected[section+1].text,
                                day,
                                @start,
                                @finish,
                                @select_color[0]
                            ])
                        end
                        @selected_color.push(@select_color[0])
                        index += 1
                        next
                    end

                    black_day = @days_selected[index].child.text.split /(?=[A-Z])/
                    black_day.each do |day|
                        @class.push([
                            @subject_code_selected[index].text, 
                            @subject_selected[index].text,
                            @section_selected[section].text + '-' + @section_selected[section+1].text,
                            day,
                            @start,
                            @finish,
                            @select_color[0]
                        ])
                    end
                else
                    @cant_port.push([
                        @subject_code_selected[index].text, 
                        @subject_selected[index].text,
                        @section_selected[section..section+1].text,
                        @days_selected[index].child.text,
                        @times_selected[index].text[0..10][0..4].to_s.strip,
                        @times_selected[index].text[0..10][7..10].to_s.strip
                    ])
                end

                # [Day] Red text 
                unless @days_selected[index].css("font[color='#CC0000']").empty?
                    red_day = @days_selected[index].css("font[color='#CC0000']").text.split /(?=[A-Z])/
                    red_time = @times_selected[index].css("font[color='#CC0000']").text
                    start = red_time[0..4]
                    finish = red_time[7..10]
                    if Timer.find_by(time: start.to_s.strip) and Timer.find_by(time: finish.to_s.strip)
                        @start = Timer.find_by(time: start.to_s.strip).id
                        @finish = Timer.find_by(time: finish.to_s.strip).id
                        red_day.each do |day| 
                            @class.push([
                                @subject_code_selected[index].text, 
                                @subject_selected[index].text,
                                @section_selected[section].text + '-' + @section_selected[section+1].text,
                                day,
                                @start,
                                @finish,
                                @select_color[0],
                            ])
                        end
                    
                    else
                        @cant_port.push([
                            @subject_code_selected[index].text, 
                            @subject_selected[index].text,
                            @section_selected[section..section+1].text,
                            @days_selected[index].child.text,
                            @times_selected[index].text[0..10][0..4].to_s.strip,
                            @times_selected[index].text[0..10][7..10].to_s.strip
                        ])
                    end 
                end

                @selected_color.push(@select_color[0])
                index += 1
            end

            # LAB
            index = 0
            last = @subject_code_selected.count * 2
            while index < @subject_code_lab_selected.count do 
                
                if Timer.find_by(time: (@times_lab_selected[index].text[0..4].to_s.strip)) and 
                    Timer.find_by(time: @times_lab_selected[index].text[7..10].to_s.strip)
                    @start = Timer.find_by(time: (@times_lab_selected[index].text[0..4].to_s.strip)).id
                    @finish = Timer.find_by(time: @times_lab_selected[index].text[7..10].to_s.strip).id

                    @class.each do |class_|
                        if class_[0] == @subject_code_lab_selected[index].text.to_s.strip
                            @select_color = class_[6..-1]
                            break
                        else
                            @select_color = @listColor.select {|item| not @selected_color.include? item  }
                        end
                    end

                    section = last + (index * 2)
                    black_day = @days_lab_selected[index].text.split /(?=[A-Z])/
                    black_day.each do |day|
                        @class.push([
                                @subject_code_lab_selected[index].text, 
                                @subject_lab_selected[index].text,
                                @section_lab_selected[section..section+1].text,
                                @days_lab_selected[index].text,
                                @start,
                                @finish,
                                @select_color[0]
                        ])
                    end
                    @selected_color.push(@select_color[0])
                else
                    black_day.each do |day|
                        @cant_port.push([
                                @subject_lab_code_selected[index].text, 
                                @subject_lab_selected[index].text,
                                @section_lab_selected[section..section+1].text,
                                day,
                                @times_lab_selected[index].text[0..4].to_s.strip,
                                @times_lab_selected[index].text[7..10].to_s.strip
                        ])
                    end
                    index += 1
                    next
                end
                index += 1
            end
            
            @class = @class.sort {|x, y| x[4] <=> y[4] }
        end

        def midterm_exam

            @page = Nokogiri::HTML(open("https://www3.reg.cmu.ac.th/regist#{@link}/exam/index.php?type=MIDTERM&term=#{@link}"))   

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
            @regular = Regularexam.where("yearexam" => @year, "semesterexam" => @semester)
            @page = Nokogiri::HTML(open("https://www3.reg.cmu.ac.th/regist#{@link}/exam/index.php?type=FINAL&term=#{@link}"))   

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
