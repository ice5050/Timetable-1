
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
            
            all_class = []
            added = []
            @class.each do |class_|
                data = Hash.new
                data[:subject_code] = class_[0]
                data[:subject] = class_[1].strip
                data[:seclec] = class_[2][0..2]
                data[:seclab] = class_[2][4..6]
                
                data[:date] = []
                if added.include? class_[0]
                    index = added.index(class_[0])
                    black_day = class_[3].split /(?=[A-Z])/ 
                    black_day.each do |day|
                        dateData = Hash.new
                        dateData[:day] = day
                        dateData[:start] = class_[4]
                        dateData[:finish] = class_[5]
                        all_class[index][:date] << dateData
                    end
                    next
                elsif class_[3] != 'TBA'
                    black_day = class_[3].split /(?=[A-Z])/ 
                    black_day.each do |day|
                        dateData = Hash.new
                        dateData[:day] = day
                        dateData[:start] = class_[4]
                        dateData[:finish] = class_[5]
                        data[:date] << dateData
                    end
                else
                    dateData = Hash.new
                    dateData[:day] = class_[3]
                    dateData[:start] = class_[4]
                    dateData[:finish] = class_[5]
                    data[:date] << dateData
                end
                all_class << data
                added << data[:subject_code]
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
            
            
            while index < @subject_code_selected.count do 

                # [Day] Black text 
                section = index * 2                  

                @start = @times_selected[index].child.text[0..4].to_s.strip.insert(2, ':')  
                @finish = @times_selected[index].child.text[7..10].to_s.strip.insert(2, ':')  

                # Example: M-Sa
                if @days_selected[index].child.text.strip.include? "-" 
                    day = @days_selected[index].child.text.strip.split("-")

                    days = ["M", "Tu", "We", "Th", "F", "Sa", "Su"]
                    start = days.index(day[0])
                    finish = days.index(day[1])
                    day = days[start..finish].join('')
                    @class.push([
                        @subject_code_selected[index].text, 
                        @subject_selected[index].text,
                        @section_selected[section].text + '-' + @section_selected[section+1].text,
                        day,
                        @start,
                        @finish,
                    ])
                    index += 1
                    next
                end

                black_day = @days_selected[index].child.text
                @class.push([
                    @subject_code_selected[index].text, 
                    @subject_selected[index].text,
                    @section_selected[section].text + '-' + @section_selected[section+1].text,
                    black_day,
                    @start,
                    @finish,
                ])
                

                # [Day] Red text 
                unless @days_selected[index].css("font[color='#CC0000']").empty?
                    # red_day = @days_selected[index].css("font[color='#CC0000']").text.split /(?=[A-Z])/
                    red_day = @days_selected[index].css("font[color='#CC0000']").text
                    red_time = @times_selected[index].css("font[color='#CC0000']").text
                    start = red_time[0..4].insert(2, ':')
                    finish = red_time[7..11].insert(2, ':')
                    
                        
                    @class.push([
                        @subject_code_selected[index].text, 
                        @subject_selected[index].text,
                        @section_selected[section].text + '-' + @section_selected[section+1].text,
                        red_day,
                        start,
                        finish,
                    ])
                end

                index += 1
            end

            # LAB
            index = 0
            last = @subject_code_selected.count * 2
            while index < @subject_code_lab_selected.count do 
                
                @start = @times_lab_selected[index].text[0..4].to_s.strip.insert(2, ':')
                @finish = @times_lab_selected[index].text[7..10].to_s.strip.insert(2, ':')

                section = last + (index * 2)
                black_day = @days_lab_selected[index].text
                
                @class.push([
                        @subject_code_lab_selected[index].text, 
                        @subject_lab_selected[index].text,
                        @section_lab_selected[section..section+1].text,
                        black_day,
                        @start,
                        @finish,
                ])
                
                index += 1
            end
            
        end
end
