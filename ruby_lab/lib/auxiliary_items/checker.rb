module Checker

    def self.check_ticket_search_validasity(from, to, date_from, date_to, price_from, price_unto)
        @errors = []

        if (from =~ /[а-я]+/i) == nil || (to =~ /[а-я]+/i) == nil
            @errors << 'неправильно указан город'
        end

        if !date_checker(date_from)
                @errors << 'неправильно указана дата в графе от'
        end  

        if !date_to.empty?
            @errors << 'неправильно указана дата  в графе до' if !date_checker(date_to)
        end

        p price_unto

        if !price_from.empty?
            @errors << 'неправильно указана цена в графе От' if (price_from =~ /^[\d]+$/) == nil          
        end

        if !price_unto.empty?
            @errors << 'неправильно указана цена в графе До' if (price_unto =~ /^[\d]+$/) == nil   
        end

        if @errors.empty?
            return nil 
        else
            return @errors
        end
    end

    def self.date_checker(date)
            return false if (date =~ /^[\d]+.[\d]+$/) == nil

            day_month = date.split(".")
            day = day_month[0].to_i
            month = day_month[1].to_i
            return false if day < 0 && month < 0 && month > 12 && day > 31
            
            return true
    end

    def self.date_compare(date1, date2) # 1 if fist greater then second, 0 if equls
        day_mont1 = date1.split('.')
        day_mont2 = date2.split('.')

        return 1 if day_mont1[1].to_i > day_mont2[1].to_i
        return -1 if day_mont1[1].to_i < day_mont2[1].to_i
        return 1 if day_mont1[0].to_i > day_mont2[0].to_i
        return -1 if day_mont1[0].to_i < day_mont2[0].to_i
        return 0 if day_mont1[0].to_i == day_mont2[0].to_i
    end

end