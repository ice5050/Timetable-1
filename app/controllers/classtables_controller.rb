class ClasstablesController < ApplicationController
    $error = ""

    def index

        @user = User.find(params[:user_id])
        @table = @user.tables.find(params[:table_id])

        @days = Day.all
        @classes = @table.classtables.order("daily ASC, start ASC")

        @i = 1
    end

    def new
        @user = User.find(current_user)
        @table = @user.tables.find(params[:table_id])
        @class = @table.classtables.new
    end

    def create
        @user = User.find(current_user)
        @table = @user.tables.find(params[:table_id])
        @class = @table.classtables.new(params_class)
        @addComplete = false
        
        @classes = @table.classtables.order("daily ASC, start ASC")

        if @class.start < @class.finish 

            if @classes.count == 0
                @addComplete = true
            end

            @classes.each do |class_|
                if class_.daily == @class.daily
                    if (@class.start < class_.start and @class.finish <= class_.start)
                        @addComplete = true
                    elsif (@class.start >= class_.finish and @class.finish > class_.finish)
                        @addComplete = true
                    else
                        $error = "class have already"
                        @addComplete = false
                        break
                    end            
                else
                    @addComplete = true
                end
            end
            @class.save if @addComplete
        else
            $error = "Time invalid"
        end


        if @addComplete
            # add color
            @listColor = ["blue", "red", "green", "pink", "yellow","mint", "orange", "violet"]
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

        redirect_to user_table_classtables_path
    end

    def edit
        @user = User.find(current_user)
        @table = @user.tables.find(params[:table_id])
        @class = @table.classtables.find(params[:id])
        @copy = 1
    end

    def update
        @user = User.find(current_user)
        @table = @user.tables.find(params[:table_id])
        @class = @table.classtables.find(params[:id])
        @class.update(params_class)
        redirect_to user_table_classtables_path
    end

    def destroy
        @user = User.find(current_user)
        @table = @user.tables.find(params[:table_id])
        @class = @table.classtables.find(params[:id])
        @class.destroy

        redirect_to user_table_classtables_path
    end


    def copy
        @user = User.find(current_user)
        @table = @user.tables.find(params[:table_id])
        @class = @table.classtables.find(params[:id])
    end

    private
        def params_class
            params.require(:class).permit(:subject_code, :subject, :daily, :start, :finish, :room, :section)
        end

        def is_valid_time
        end
end
