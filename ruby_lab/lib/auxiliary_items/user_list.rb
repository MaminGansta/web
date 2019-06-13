
class UserList

    def initialize
        @list = {}
    end

    def add(user)
        @list[user.id] = user
    end

    def del(user_id)
        @list.delete(user_id)
    end

    def get(user_id)
        @list[user_id]
    end

    def get_id(user)
        @list.values.each do |users_from_list|
            if users_from_list == user
                return users_from_list.id
            end
        end
        return nil
    end

    def has_user?(user)
        @list.values.each do |users_from_list|
            if users_from_list == user
                return true
            end
        end
        return false
    end

    def has_nickname?(user)
        @list.values.each do |users_from_list|
            if users_from_list.name == user.name
                return true
            end
        end
        return false
    end
end