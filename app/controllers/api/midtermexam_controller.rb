
class API::MidtermexamController < ApplicationController
    def index
        semester = params[:semester]
        year = params[:year]
        link = [semester, year].join('')
        page = Nokogiri::HTML(open("https://www3.reg.cmu.ac.th/regist#{link}/exam/index.php?type=MIDTERM&term=#{link}"))   

        examSelected = page.css("td[width='27%']")
        timeSelected = page.css("td[bgcolor='#EAEAEA']")
        daySelected = page.css("td[width='19%']")

        times = []
        timeSelected.each do |time|
            times << time.text
        end

        days = []
        daySelected.each do |day|
            days << day.text.split(' ')
        end

        exams = []
        examSelected.each_with_index do |day, index|
            day = day.text.gsub(/[\t\n\r]/, '').split(',')
            indexTime = index % 3
            indexDay = index % daySelected.size
            day.each do |subjectCode|
                date = ['25', '59'].join('').to_i - 543
                data = Hash.new
                data[:subjectCode] = subjectCode
                data[:time] = times[indexTime]
                data[:date] = DateTime.new(date, 2, days[indexDay][1].to_i, times[indexTime][0..1].to_i, times[indexTime][2..3].to_i, 0, '+7')
                exams << data

            end
        end
        render json: exams, status: :ok
    end
end


