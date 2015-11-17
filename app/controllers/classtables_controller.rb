class ClasstablesController < ApplicationController
    $error = ""

    def index

        @user = User.find(params[:user_id])
        @table = @user.tables.find(params[:table_id])
        @class = @table.classtables.new


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
        @class = @table.classtables.create(params_class)
        
        @classes = @table.classtables.order("daily ASC, start ASC")

        if @class.start < @class.finish 
            @classes.each do |class_|
                if class_.daily == @class.daily
                    if @class.start < class_.start and @class.finish <= class_.start
                        @class.save
                    elsif @class.start >= class_.finish and @class.finish > class_.finish
                        @class.save
                    else
                        $error = "class have already"
                        break
                    end            
                end
            end
        else
            $error = "Time invalid"
        end

        redirect_to user_table_classtables_path
    end

    def edit
        @user = User.find(current_user)
        @table = @user.tables.find(params[:table_id])
        @class = @table.classtables.new
    end

    def update
        @user = User.find(current_user)
        @table = @user.tables.find(params[:table_id])
        @class = @table.classtables.update(params_class)
        redirect_to user_table_classtables_path
    end

    def destroy
        @user = User.find(current_user)
        @table = @user.tables.find(params[:table_id])
        @class = @table.classtables.find(params[:id])
        @class.destroy

        redirect_to user_table_classtables_path
    end

    private
        def params_class
            params.require(:class).permit(:subject_code, :subject, :daily, :start, :finish, :room, :section)
        end
end
