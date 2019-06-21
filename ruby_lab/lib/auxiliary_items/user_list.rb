# frozen_string_literal: true
# conteiner for user
class UserList
  def initialize
    @list = {}
  end

  def add(user)
    @list[user.id] = user
  end

  def get(user_id)
    @list[user_id]
  end

  def get_id(user)
    @list.values.each do |users_from_list|
      return users_from_list.id if users_from_list == user
    end
    nil
  end

  def user?(user)
    @list.values.each do |users_from_list|
      return true if users_from_list == user
    end
    false
  end

  def nickname?(user)
    @list.values.each do |users_from_list|
      return true if users_from_list.name == user.name
    end
    false
  end
end
