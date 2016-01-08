class API::FinalexamController < ApplicationController
    def index

        semester = params[:semester]
        year = params[:year]
        link = [semester, year].join('')
        stu_id = params[:stu_id]

        all_class = RestClient.get "cmutimetable.herokuapp.com/api/generates?year=#{year}&semester=#{semester}&stu_id=#{stu_id}"
        all_class = JSON.parse(all_class)
        page = Nokogiri::HTML(open("https://www3.reg.cmu.ac.th/regist#{link}/exam/index.php?type=FINAL&term=#{link}"))   

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
                data[:start] = times[indexTime][0..3].insert(2, ':')
                data[:finish] = times[indexTime][5..8].insert(2, ':')
                data[:date] = DateTime.new(date, 2, days[indexDay][1].to_i, times[indexTime][0..1].to_i, times[indexTime][2..3].to_i, 0, '+7')
                exams << data

            end
        end

        examStudent = []
        subject_code_added = []
        all_class.each do |class_|
            exams.each do |exam|  
                if class_["subject_code"] == exam[:subjectCode] and !subject_code_added.include? class_["subject_code"]
                    examData = Hash.new
                    examData["subject_code"] = class_["subject_code"]
                    examData["subject"] = class_["subject"]
                    examData["date_exam"] = exam[:date]
                    examData["start"] = exam[:start]
                    examData["finish"] = exam[:finish]
                    examStudent << examData
                    exam.clear
                    subject_code_added << class_["subject_code"]
                    break
                end
            end
        end

        render json: examStudent, status: :ok
    end
end
