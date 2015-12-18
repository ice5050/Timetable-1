require 'test_helper'

class ClasstableTest < ActiveSupport::TestCase
  
    setup do
        @classstable = Classtable.new(
                            subject_code: "204217",
                            subject: "Ruby on rails",
                            daily: 1,
                            start: 1,
                            finish: 3,
                        )
    end

    test "time invalid" do 
        assert @classstable.start < @classstable.finish
    end

    test "can create new classstable" do
        assert @classstable.valid?, "should can create"
    end

    test "can't create new classstable" do
        classstable = Classtable.new(
                            subject_code: "204217",
                            subject: "Ruby on rails",
                            daily: 1,
                            start: 1,
                            finish: nil,
                        )
        assert !classstable.valid?, "should can't create"
    end

    test "can update classstable" do
        @classstable.update(subject_code: "204111")
        assert @classstable.valid?, "can update"

        @classstable.update(subject: "Python")
        assert @classstable.valid?, "can update"

        @classstable.update(daily: 2)
        assert @classstable.valid?, "can update"

        @classstable.update(daily: "two")
        assert !@classstable.valid?, "can update"
    end

    test "can destroy classstable" do
        @classstable.destroy
        assert @classstable.valid?, "can delete"
    end

end
