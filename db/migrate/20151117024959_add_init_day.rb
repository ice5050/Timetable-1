class AddInitDay < ActiveRecord::Migration
  def change
    Day.create(day: "Sunday")
    Day.create(day: "Monday")
    Day.create(day: "Tuesday")
    Day.create(day: "Wednesday")
    Day.create(day: "Thursday")
    Day.create(day: "Faiday")
    Day.create(day: "Saturday")
  end
end
