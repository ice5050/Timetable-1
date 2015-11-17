class Table < ActiveRecord::Base
    has_many :classtables, dependent: :destroy
    belongs_to :user
end
