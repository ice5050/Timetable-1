require 'test_helper'

class TableTest < ActiveSupport::TestCase
    # test "the truth" do
    #     assert true
    # end
    setup do
        @table = Table.new(name: "cmutimetable", year: 58, semester: 1)
    end

    test "can create new table" do
        assert @table.valid?, "should can't create"
    end

    test "can't create new table" do
        table = Table.new(name: nil, year: 58, semester: 1)
        assert !table.valid?, "should can create"
    end

    test "can update table" do
        @table.update(name: "cmutimetable2")
        assert @table.valid?, "should can update"

        @table.update(year: 59)
        assert @table.valid?, "should can update"

        @table.update(semester: 2)
        assert @table.valid?, "should can update"
    end

    test "can destroy table" do
        @table.destroy
        assert @table.valid?, "should can delete"
    end

end
