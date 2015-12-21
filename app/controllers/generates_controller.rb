class GeneratesController < ApplicationController
    def index

        unless session[:data] == nil
            @year = session[:data]["year"]
            @semester = session[:data]["semester"]
            @link = (@semester + @year).to_i
            @stu_id = session[:data]["stu_id"].to_i
        end

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

    def create_table

        @link = session[:link]
        @stu_id = session[:stu_id]
        
        read_tag()
        add_class()

        @user = User.find(current_user)
        @table = @user.tables.create(name: "Sync id: #{@stu_id}", semester: (@link/100), year: @link%100)              
        
        @class.each do |class_|

            if ['Su'].include? class_[3]
                daily = 1
            elsif ['Mo', 'M'].include? class_[3]
                daily = 2
            elsif ['Tu'].include? class_[3] 
                daily = 3
            elsif ['We', 'W'].include? class_[3]
                daily = 4
            elsif ['Th'].include? class_[3]
                daily = 5
            elsif ['Fr', 'F'].include? class_[3]
                daily = 6
            elsif ['Sa'].include? class_[3]
                daily = 7
            end    
            
            @table.classtables.create(subject_code: class_[0], 
                                subject: class_[1], 
                                section: class_[2], 
                                room: '-',
                                daily: daily, 
                                start: class_[4], 
                                finish: class_[5],
                                color: class_[6],
            )
            
        end

        session.delete(:link)
        session.delete(:stu_id)
        redirect_to controller: 'classtables', action: 'index', user_id: @user.id, table_id: @table.id
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
