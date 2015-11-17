class Classtable < ActiveRecord::Base
    belongs_to :table

    validates :subject, presence: true
    # validate :start_is_after_finish
end
