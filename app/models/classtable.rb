class Classtable < ActiveRecord::Base
    belongs_to :table    

    validates :subject_code, :subject, presence: true
    
    validates :daily, :start, :finish, numericality: { only_integer: true }, presence: true
end

