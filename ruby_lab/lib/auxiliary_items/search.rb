require_relative '../trains'
require_relative '../train'
require_relative 'checker'

module Search

    def self.search_tickets(trains, from, to, date_from, date_to, price_from, price_unto)
        new_trains = Trains.new
        trains.each do |train|
            next if train.depart != from && train.arrived != to
            next if Checker.date_compare(train.d_date, date_from) == -1
            if !date_to.empty?
                next if Checker.date_compare(train.a_date, date_to) == 1
            end

            if !price_from.empty?
                next if train.price.to_i <= price_from.to_i
            end

            if !price_unto.empty?
                next if train.price.to_i >= price_unto.to_i
            end

            new_trains.add(train)
        end
        new_trains
    end

    def self.search_dead_end(trains)
        citys_end = []
        citys_start = []
        trains.each do |train|
        citys_end << train.arrived if !citys_end.include?(train.arrived)
        citys_start << train.depart if !citys_start.include?(train.depart)
        end

        citys_start.each do |town|
            citys_end.delete(town)
        end

        if citys_end.empty?
            return nil
        else
            return citys_end
        end
    end

    def self.citys_wits_trains(trains)
        citys = []
        trains.each do |train|
            citys << train.depart if !citys.include?(train.depart)
            citys << train.arrived if !citys.include?(train.arrived)
        end

        if citys.empty?
            return nil
        else
            return citys
        end
    end

    def self.how_railways_need(trains, city, date)
        valid_trains = []
        trains.each do |train|
            valid_trains << train if (train.depart == city && Checker.date_compare(train.d_date, date) == 0 ) || (Checker.date_compare(train.a_date, date) == 0 && city == train.arrived)
        end

        if valid_trains.any?
            day_time = Array.new(1440){ |index| 0 }
            count = 1
            flag_for_count = false

            valid_trains.each do |train|
                if train.depart == city
                    time = train.d_time.split(':')
                    time = time[0].to_i * 60 + time[1].to_i
                    for i in 0..30
                        flag_for_count = true if day_time[time - i] == 1
                        day_time[time - i] = 1
                    end
                    count += 1 if flag_for_count
                    flag_for_count = false
                else
                    time = train.a_time.split(':')
                    time = time[0].to_i * 60 + time[1].to_i
                    for i in 0..30
                        flag_for_count = true if day_time[time + i] == 1
                        day_time[time - i] = 1
                    end
                    count += 1 if flag_for_count
                    flag_for_count = false
                end
            end
        else
            return 0
        end
        return count
    end
end