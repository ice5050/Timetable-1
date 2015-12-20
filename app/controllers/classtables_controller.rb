class ClasstablesController < ApplicationController
    $error = ""

    def index

        @user = User.find(params[:user_id])
        @table = @user.tables.find(params[:table_id])

        @days = Day.order("id ASC")
        @classes = @table.classtables.order("daily ASC, start ASC")

        @i = 1
    end

    def new
        @user = User.find(params[:user_id])
        @table = @user.tables.find(params[:table_id])
        @class = @table.classtables.new
    end

    def create
        @user = User.find(params[:user_id])
        @table = @user.tables.find(params[:table_id])
        @class = @table.classtables.new(params_class)
        @addComplete = false
        
        @classes = @table.classtables.order("daily ASC, start ASC")

        if time_is_valid()
            @class.save
            add_color()
        end

        redirect_to user_table_classtables_path
    end

    def edit
        @user = User.find(params[:user_id])
        @table = @user.tables.find(params[:table_id])
        @class = @table.classtables.find(params[:id])

        @days = Day.order("id ASC")
        @classes = @table.classtables.order("daily ASC, start ASC")

        @i = 1
    end

    def update
        @user = User.find(params[:user_id])
        @table = @user.tables.find(params[:table_id])
        @class = @table.classtables.new(params_class)
        @class_old = @table.classtables.find(params[:id])

        @classes = @table.classtables.order("daily ASC, start ASC")

        @subject_code_old = @class_old.subject_code
        @subject_old = @class_old.subject
        @room_old = @class_old.room
        @section_old = @class_old.section
        @daily_old = @class_old.daily
        @start_old = @class_old.start
        @finish_old = @class_old.finish
        @color_old = @class_old.color
        
        @class_old.destroy
        if time_is_valid()
            @class.save
            add_color()
        else
            @class = @table.classtables.new("subject_code" => @subject_code_old, 
                                            "subject" => @subject_old, 
                                            "room" => @room_old, 
                                            "section" => @section_old, 
                                            "daily" => @daily_old, 
                                            "start" => @start_old, 
                                            "finish" => @finish_old,
                                            "color" => @color_old)
            @class.save
        end        

        redirect_to user_table_classtables_path
    end

    def destroy
        @user = User.find(params[:user_id])
        @table = @user.tables.find(params[:table_id])
        @class = @table.classtables.find(params[:id])
        @class.destroy

        redirect_to user_table_classtables_path
    end


    def copy
        @user = User.find(params[:user_id])
        @table = @user.tables.find(params[:table_id])
        @class = @table.classtables.find(params[:id])

        @days = Day.order("id ASC")
        @classes = @table.classtables.order("daily ASC, start ASC")

        @i = 1
    end

    def update_exam_final
        @user = User.find(params[:user_id])
        @table = @user.tables.find(params[:table_id])
        @class = @table.classtables.find(params[:id])
        @class.update(params_manual_final)

        if @class.dayFinal.to_s.length == 0
            @class.update('dayFinal' => nil)
        end

        if @class.timeFinal.to_s.length == 0
            @class.update('timeFinal' => nil)
        end

        redirect_to user_table_finaltables_path
    end

    def clear_manual_final
        @user = User.find(params[:user_id])
        @table = @user.tables.find(params[:table_id])
        @class = @table.classtables.find(params[:id])
               
        @class.update('dayFinal' => nil)    
        @class.update('timeFinal' => nil)
        
        redirect_to user_table_finaltables_path
    end

    def update_exam_midterm
        @user = User.find(params[:user_id])
        @table = @user.tables.find(params[:table_id])
        @class = @table.classtables.find(params[:id])
        @class.update(params_manual_midterm)

        if @class.dayMidterm.to_s.length == 0
            @class.update('dayMidterm' => nil)
        end

        if @class.timeMidterm.to_s.length == 0
            @class.update('timeMidterm' => nil)
        end

        redirect_to user_table_midtermtables_path
    end

    def clear_manual_midterm
        @user = User.find(params[:user_id])
        @table = @user.tables.find(params[:table_id])
        @class = @table.classtables.find(params[:id])
               
        @class.update('dayMidterm' => nil)    
        @class.update('timeMidterm' => nil)
        
        redirect_to user_table_midtermtables_path
    end
       

    private
        def params_class
            params.require(:class).permit(:subject_code, :subject, :daily, :start, :finish, :room, :section)
        end

        def time_is_valid
            if @class.start < @class.finish 

                if @classes.count == 0
                    @addComplete = true
                end

                @classes.each do |class_|
                    if class_.daily == @class.daily 
                        if (@class.start < class_.start and @class.finish <= class_.start)
                            next
                        elsif (@class.start >= class_.finish and @class.finish > class_.finish)
                            next
                        else
                            $error = "this time have a class already."
                            return false
                        end            
                    end
                end
                return true
            else
                $error = "Time invalid"
                return false
            end
        end


        def add_color
            # add color
            @listColor = ["blue", "red", "green", "pink", "yellow", "mint", "pumpkin", "violet", "darkblue", "orange"]
            @colorUsed = []
            @choosed = false

            # class not duplicate
            @classes.each do |class_|
                if @class.subject_code == class_.subject_code and !@choosed
                    @class.update("color" => class_.color)
                    @choosed = true
                    break
                end
                @colorUsed.push(class_.color)
            end

            if @colorUsed.empty? and !@choosed
                @class.update("color" => @listColor.first) 
                @choosed = true
            end

            @listColor.each do |color|
                if !@colorUsed.include?(color) and !@choosed
                   @class.update("color" => color) 
                   @choosed = true
                end
            end
        end

        def params_manual_final
            params.require(:exam).permit(:dayFinal, :timeFinal)
        end

        def params_manual_midterm
            params.require(:exam).permit(:dayMidterm, :timeMidterm)
        end
end
