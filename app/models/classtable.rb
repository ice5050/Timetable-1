class Classtable < ActiveRecord::Base
    belongs_to :table    

    validates :subject_code, :subject, presence: true
    
    validates :daily, :start, :finish, numericality: { only_integer: true }, presence: true

    if Rails.env.development?
        extend FriendlyId
        friendly_id :subject_code,  use: [:finders]
    end
end


