class Table < ActiveRecord::Base
    has_many :classtables, dependent: :destroy
    belongs_to :user

    validates :name, :year, :semester, presence: true 

    
    extend FriendlyId
    friendly_id :name, use: [:finders]
end
