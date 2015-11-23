class AddInitRegular < ActiveRecord::Migration
  def change
    Regularexam.create(dayexam: "2", timeexam: "7", dateexam: "WED MAY 04 12:00 - 15:00", yearexam: 58, semesterexam: 2)
    Regularexam.create(dayexam: "5", timeexam: "7", dateexam: "WED MAY 04 12:00 - 15:00", yearexam: 58, semesterexam: 2)

    Regularexam.create(dayexam: "2", timeexam: "10", dateexam: "FRI MAY 06 08:00 - 11:00", yearexam: 58, semesterexam: 2)
    Regularexam.create(dayexam: "2", timeexam: "11", dateexam: "FRI MAY 06 08:00 - 11:00", yearexam: 58, semesterexam: 2)
    Regularexam.create(dayexam: "5", timeexam: "10", dateexam: "FRI MAY 06 08:00 - 11:00", yearexam: 58, semesterexam: 2)
    Regularexam.create(dayexam: "5", timeexam: "11", dateexam: "FRI MAY 06 08:00 - 11:00", yearexam: 58, semesterexam: 2)

    Regularexam.create(dayexam: "3", timeexam: "7", dateexam: "FRI MAY 06 15:30 - 18:30", yearexam: 58, semesterexam: 2)
    Regularexam.create(dayexam: "6", timeexam: "7", dateexam: "FRI MAY 06 15:30 - 18:30", yearexam: 58, semesterexam: 2)

    Regularexam.create(dayexam: "2", timeexam: "1", dateexam: "SAT MAY 07 08:00 - 11:00", yearexam: 58, semesterexam: 2)
    Regularexam.create(dayexam: "5", timeexam: "1", dateexam: "SAT MAY 07 08:00 - 11:00", yearexam: 58, semesterexam: 2)

    Regularexam.create(dayexam: "2", timeexam: "17", dateexam: "SAT MAY 07 15:30 - 18:30", yearexam: 58, semesterexam: 2)
    Regularexam.create(dayexam: "5", timeexam: "17", dateexam: "SAT MAY 07 15:30 - 18:30", yearexam: 58, semesterexam: 2)

    Regularexam.create(dayexam: "3", timeexam: "17", dateexam: "MON MAY 09 12:00 - 15:00", yearexam: 58, semesterexam: 2)
    Regularexam.create(dayexam: "6", timeexam: "17", dateexam: "MON MAY 09 12:00 - 15:00", yearexam: 58, semesterexam: 2)

    Regularexam.create(dayexam: "3", timeexam: "10", dateexam: "WED MAY 11 12:00 - 15:00", yearexam: 58, semesterexam: 2)
    Regularexam.create(dayexam: "3", timeexam: "11", dateexam: "WED MAY 11 12:00 - 15:00", yearexam: 58, semesterexam: 2)
    Regularexam.create(dayexam: "6", timeexam: "10", dateexam: "WED MAY 11 12:00 - 15:00", yearexam: 58, semesterexam: 2)
    Regularexam.create(dayexam: "6", timeexam: "11", dateexam: "WED MAY 11 12:00 - 15:00", yearexam: 58, semesterexam: 2)

    Regularexam.create(dayexam: "3", timeexam: "1", dateexam: "THU MAY 12 12:00 - 15:00", yearexam: 58, semesterexam: 2)
    Regularexam.create(dayexam: "6", timeexam: "1", dateexam: "THU MAY 12 12:00 - 15:00", yearexam: 58, semesterexam: 2)

    Regularexam.create(dayexam: "2", timeexam: "4", dateexam: "FRI MAY 13 08:00 - 11:00", yearexam: 58, semesterexam: 2)
    Regularexam.create(dayexam: "5", timeexam: "4", dateexam: "FRI MAY 13 08:00 - 11:00", yearexam: 58, semesterexam: 2)

    Regularexam.create(dayexam: "3", timeexam: "4", dateexam: "FRI MAY 13 15:30 - 18:30", yearexam: 58, semesterexam: 2)
    Regularexam.create(dayexam: "6", timeexam: "4", dateexam: "FRI MAY 13 15:30 - 18:30", yearexam: 58, semesterexam: 2)

    Regularexam.create(dayexam: "3", timeexam: "14", dateexam: "SAT MAY 14 12:00 - 15:00", yearexam: 58, semesterexam: 2)
    Regularexam.create(dayexam: "6", timeexam: "14", dateexam: "SAT MAY 14 12:00 - 15:00", yearexam: 58, semesterexam: 2)

    Regularexam.create(dayexam: "2", timeexam: "14", dateexam: "SUN MAY 15 12:00 - 15:00", yearexam: 58, semesterexam: 2)
    Regularexam.create(dayexam: "5", timeexam: "14", dateexam: "SUN MAY 15 12:00 - 15:00", yearexam: 58, semesterexam: 2)

    Regularexam.create(dayexam: "4", timeexam: "4", dateexam: "MON MAY 16 08:00 - 11:00", yearexam: 58, semesterexam: 2)
    Regularexam.create(dayexam: "4", timeexam: "10", dateexam: "MON MAY 16 12:00 - 15:00", yearexam: 58, semesterexam: 2)
    Regularexam.create(dayexam: "4", timeexam: "11", dateexam: "MON MAY 16 12:00 - 15:00", yearexam: 58, semesterexam: 2)
    Regularexam.create(dayexam: "4", timeexam: "14", dateexam: "MON MAY 16 15:30 - 18:30", yearexam: 58, semesterexam: 2)

  end
end

